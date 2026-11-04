// Future ve zamanlayıcı gibi asenkron yapıları ekler
import 'dart:async';
// JSON metnini dönüştürmek için kullanılır
import 'dart:convert';
// İnternet üzerinden HTTP isteği göndermeyi sağlar
import 'package:http/http.dart' as http;
// Vazife modelini projeye ekler
import '../../models/habit.dart';
// Çevrimdışı rehber servisini projeye ekler
import '../guide_service.dart';
// AI hata sınıflarını projeye ekler
import 'ai_error_handler.dart';
// Sohbet mesajı modelini projeye ekler
import 'ai_message.dart';
// Rehber kişiliklerini projeye ekler
import 'ai_persona.dart';
// AI servis sözleşmesini projeye ekler
import 'ai_service.dart';
// AI ahit önerisi modelini projeye ekler
import 'pact_suggestion.dart';
// Yapay zekâ isteklerini Cloudflare Worker üzerinden gönderir
// API anahtarını doğrudan uygulama içinde saklamaz
// Cloudflare Worker üzerinden model yanıtı alır ve çözümleyerek döndürür
class GroqAiRepository implements AiService {
  // Yeni GroqAiRepository nesnesi oluşturur
  GroqAiRepository({
    // Worker adres için isteğe bağlı başlangıç değeri alır
    this.workerUrl,
    // client secret için isteğe bağlı başlangıç değeri alır
    this.clientSecret,
    // http client parametresini isteğe bağlı alır
    http.Client? httpClient,
    // fallback servis parametresini isteğe bağlı alır
    GuideService? fallbackService,
    // model için isteğe bağlı başlangıç değeri alır
    this.model = primaryModel,
  // Değer bulunmazsa varsayılan seçeneği kullanır
  })  : _client = httpClient ?? http.Client(),
        // fallback bilgisini yeni değeriyle günceller
        _fallback = fallbackService ?? OfflineGuideService();
  // primary model bilgisini saklar
  static const primaryModel = 'qwen/qwen3.8-27b';
  // fallback model bilgisini saklar
  static const fallbackModel = 'openai/gpt-oss-20b';
  // AI isteklerinin gönderileceği Worker adresini tutar
  final String? workerUrl;
  // Worker için isteğe bağlı istemci gizini tutar
  final String? clientSecret;
  // AI isteğinde kullanılacak modelin adını tutar
  final String model;
  // Worker isteğini gönderen HTTP istemcisini tutar
  final http.Client _client;
  // Bağlantı olmadığında kullanılacak yerel rehber servisini tutar
  final GuideService _fallback;
  // Geçerli bir Worker adresi ayarlanıp ayarlanmadığını belirtir
  bool get isConfigured =>
      // Bu koşuldaki değerleri karşılaştırır
      workerUrl != null &&
      // Worker adresinin http ile başlayıp başlamadığını kontrol eder
      workerUrl!.trim().isNotEmpty &&
      // Worker adresinin http ile başlayıp başlamadığını kontrol eder
      workerUrl!.startsWith('http');
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Kullanıcı mesajını işleyip uygun AI yanıtını getirir
  Future<AiMessage> sendMessage({
    // history parametresini zorunlu alır
    required List<AiMessage> history,
    // AI yanıtının kullanılacağı rehber kişiliğini alır ve zorunludur
    required AiPersona persona,
    // user soru parametresini zorunlu alır
    required String userPrompt,
    // Öneride eşleştirilebilecek vazife listesini alır ve zorunludur
    required List<Habit> availableHabits,
    // Kullanıcı izinli alışkanlık özetini alır, verilmezse null olabilir
    String? contextSummary,
    // Yanıtların sade Türkçe olmasını belirler
    bool plainTurkish = false,
    // Kullanıcının rehbere verdiği özel talimatları alır, verilmezse null olabilir
    String? customInstructions,
  }) async {
    // Worker adresi yoksa internet gerektirmeyen rehbere geçer
    // Worker adresi ayarlı değilse çevrimdışı yanıta geçer
    if (!isConfigured) {
      // Çevrimdışı rehberin hazırladığı yanıtı döndürür
      return _generateOfflineFallback(persona, userPrompt, availableHabits);
    }
    // Kişilik talimatını ve istek mesajlarını hazırlar
    // Kişilik ve kullanıcı tercihlerinden sistem talimatını oluşturur
    final systemPrompt = persona.buildSystemPrompt(
      // Sade Türkçe tercihinin durumunu gönderir
      plainTurkish: plainTurkish,
      // Kullanıcının özel isteklerini sisteme ekler
      customInstructions: customInstructions,
      // vazife bağlam alanına gelen değeri kullanır
      habitContext: contextSummary,
    );
    // Sistem ve sohbet mesajlarını HTTP için sıraya koyar
    final apiMessages = <Map<String, String>>[
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {'role': 'system', 'content': systemPrompt},
      // Sohbet geçmişinden en fazla altı mesajı isteğe ekler
      // Sohbet geçmişinden ilk altı mesajı AI isteğine aktarır
      ...history.take(6).map((m) => {
            // HTTP isteğindeki mesajın gönderen türünü belirler
            'role': m.isUser ? 'user' : 'assistant',
            // AIya gönderilecek mesaj içeriğini belirler
            'content': m.content,
          }),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {'role': 'user', 'content': userPrompt},
    ];
    // Model, mesajlar ve sınırları içeren JSON isteği hazırlar
    final requestBody = jsonEncode({
      // İsteğin kullanılacağı yapay zekâ modelini belirtir
      'model': model,
      // AIya gönderilecek mesaj geçmişini ekler
      'messages': apiMessages,
      // Model yanıtının çeşitlilik ayarını belirler
      'temperature': 0.7,
      // Model yanıtının üst token sınırını belirler
      'max_tokens': 600,
    });
    // HTTP isteğinde kullanılacak başlıkları oluşturur
    final headers = {
      // Content-Type alanına gönderilecek değeri yerleştirir
      'Content-Type': 'application/json',
      // X-App-Id alanına gönderilecek değeri yerleştirir
      'X-App-Id': 'haegaruuetn-v1',
      // İstemci gizi verilmişse HTTP başlığına ekler
      if (clientSecret != null && clientSecret!.isNotEmpty)
        // X-Hager-Client-Secret alanına gönderilecek değeri yerleştirir
        'X-Hager-Client-Secret': clientSecret!,
    };
    // Cloudflare Worker adresine HTTP isteği gönderir
    // Worker isteğinin HTTP yanıtını tutar
    http.Response response;
    // Hata oluşabilecek işlemleri denemeye başlar
    try {
      // response bilgisini yeni değerle günceller
      response = await _client
          // Worker adresine HTTP POST isteği gönderir
          .post(
            // Worker adresini HTTP isteğinde kullanılacak Uri türüne çevirir
            Uri.parse(workerUrl!),
            // HTTP isteğine başlık bilgilerini ekler
            headers: headers,
            // Ekranın içeriğini veya HTTP isteğinin gövdesini belirler
            body: requestBody,
          )
          // HTTP isteğine azami bekleme süresi koyar
          .timeout(const Duration(seconds: 15));
    // İstek belirlenen sürede bitmezse zaman aşımı hatasını ele alır
    } on TimeoutException {
      // Belirlenen AI hata türünü fırlatır
      throw const AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.timeout,
        // Kullanıcıya gösterilecek mesajı belirler
        message:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kraliyet ulağı zamanında dönemedi (zaman aşımı). Lütfen tekrar deneyin.',
      );
    // İşlem başarısız olursa hata durumunu ele alır
    } catch (e) {
      // Belirlenen AI hata türünü fırlatır
      throw AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.networkError,
        // Kullanıcıya gösterilecek mesajı belirler
        message:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Ağ bağlantısı kurulamadı. İnternet bağlantınızı kontrol edin.',
        // technical details alanına gelen değeri kullanır
        technicalDetails: e.toString(),
      );
    }
    // HTTP yanıtının başarılı olup olmadığını kontrol eder
    // HTTP 200 dışındaki yanıtları hataya dönüştürür
    if (response.statusCode != 200) {
      // HTTP yanıtından okunacak hata metnini geçici saklar
      String? serverMsg;
      // Hata oluşabilecek işlemleri denemeye başlar
      try {
        // Kaydedilen JSON metnini Dart verisine çevirir
        final errJson = jsonDecode(response.body);
        // server msg bilgisini yeni değerle günceller
        serverMsg = errJson['error']?['message'] as String?;
      // İşlem başarısız olursa hata durumunu ele alır
      } catch (_) {}
      // Belirlenen AI hata türünü fırlatır
      throw AiException.fromStatusCode(response.statusCode, serverMsg);
    }
    // Model yanıtını JSONdan metne dönüştürür
    // Hata oluşabilecek işlemleri denemeye başlar
    try {
      // data bilgisini saklar
      final data =
          // Gelen yanıtın UTF-8 baytlarını JSON nesnesine dönüştürür
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      // choices öğelerini içeren listeyi hazırlar
      final choices = data['choices'] as List<dynamic>?;
      // Modelin hiç yanıt seçeneği üretmediğini kontrol eder
      if (choices == null || choices.isEmpty) {
        // Belirlenen AI hata türünü fırlatır
        throw const AiException(
          // Hatanın türünü belirten kodu atar
          code: AiErrorCode.invalidResponse,
          // Kullanıcıya gösterilecek mesajı belirler
          message: 'Yapay zekâdan boş yanıt alındı.',
        );
      }
      // mesaj map öğelerini içeren listeyi hazırlar
      final messageMap = choices[0]['message'] as Map<String, dynamic>?;
      // ham veri content öğelerini içeren listeyi hazırlar
      final rawContent = (messageMap?['content'] as String?)?.trim() ?? '';
      // Modelin boş içerik göndermesini hata kabul eder
      if (rawContent.isEmpty) {
        // Belirlenen AI hata türünü fırlatır
        throw const AiException(
          // Hatanın türünü belirten kodu atar
          code: AiErrorCode.invalidResponse,
          // Kullanıcıya gösterilecek mesajı belirler
          message: 'Yapay zekâ mesajı boş döndü.',
        );
      }
      // Yanıtta yapılandırılmış ahit önerisi varsa ayıklar
      // AI yanıtındaki yapılandırılmış ahit önerisini ayıklar
      final suggestion = PactSuggestion.tryExtract(rawContent, availableHabits);
      // Ham JSON bloğunu sohbet metninden çıkaracak içeriği seçer
      final displayContent = suggestion != null
          // Koşul doğruysa kullanılacak sonucu belirler
          ? PactSuggestion.cleanDisplayMessage(rawContent)
          // Koşul yanlışsa kullanılacak sonucu belirler
          : rawContent;
      // AI yanıtını tarih ve kaynak bilgisiyle mesaj nesnesine çevirir
      return AiMessage(
        // Kaydın benzersiz kimliğini belirler
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        // Mesajı rehber yanıtı olarak işaretler
        role: AiRole.assistant,
        // Mesajın veya pencerenin içeriğini belirler
        content: displayContent.isEmpty
            // Koşul doğruysa kullanılacak sonucu belirler
            ? 'Sana bir ahit önerisi hazırladım:'
            // Koşul yanlışsa kullanılacak sonucu belirler
            : displayContent,
        // timestamp alanına güncel zamanı kullanır
        timestamp: DateTime.now(),
        // Yanıttan çıkarılan ahit önerisini mesaja bağlar
        pactSuggestion: suggestion,
        // Mesajın çevrimdışı kaynaktan geldiğini belirtir
        isOfflineFallback: false,
      );
    // AI servisine ait özel hata türünü yakalar
    } on AiException {
      // Yakalanan AI hatasını değiştirmeden üst katmana iletir
      rethrow;
    // İşlem başarısız olursa hata durumunu ele alır
    } catch (e) {
      // Belirlenen AI hata türünü fırlatır
      throw AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.invalidResponse,
        // Kullanıcıya gösterilecek mesajı belirler
        message: 'Model çıktısı çözümlenemedi.',
        // technical details alanına gelen değeri kullanır
        technicalDetails: e.toString(),
      );
    }
  }
  // İnternet bağlantısı yokken yerel rehber yanıtı oluşturur
  AiMessage _generateOfflineFallback(
    // AI yanıtının kullanılacağı rehber kişiliğini alır, verilmezse null olabilir
    AiPersona persona,
    // user soru parametresini isteğe bağlı alır
    String userPrompt,
    // Öneride eşleştirilebilecek vazife listesini alır, verilmezse null olabilir
    List<Habit> availableHabits,
  ) {
    // tone için anahtar değer tablosu oluşturur
    final tone = switch (persona.type) {
      // ai kişilik type.commander bilgisini yeni değerle günceller
      AiPersonaType.commander => GuideTone.commander,
      // ai kişilik type.sage bilgisini yeni değerle günceller
      AiPersonaType.sage => GuideTone.sage,
      // ai kişilik type.companion bilgisini yeni değerle günceller
      AiPersonaType.companion => GuideTone.companion,
    };
    // yanıt bilgisini saklar
    final reply = _fallback.reply(userPrompt, tone);
    // AI yanıtını tarih ve kaynak bilgisiyle mesaj nesnesine çevirir
    return AiMessage(
      // Kaydın benzersiz kimliğini belirler
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      // Mesajı rehber yanıtı olarak işaretler
      role: AiRole.assistant,
      // Mesajın veya pencerenin içeriğini belirler
      content: reply,
      // timestamp alanına güncel zamanı kullanır
      timestamp: DateTime.now(),
      // Mesajın çevrimdışı kaynaktan geldiğini belirtir
      isOfflineFallback: true,
    );
  }
}

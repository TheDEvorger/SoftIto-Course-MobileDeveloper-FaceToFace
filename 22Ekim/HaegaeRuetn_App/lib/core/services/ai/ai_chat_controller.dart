// ChangeNotifier ve ValueNotifier gibi durum yapılarını ekler
import 'package:flutter/foundation.dart';
// Verileri cihazda anahtar ve değer olarak saklamayı sağlar
import 'package:shared_preferences/shared_preferences.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../state/realm_controller.dart';
// İzinli vazife özeti oluşturucusunu projeye ekler
import 'ai_context_builder.dart';
// AI hata sınıflarını projeye ekler
import 'ai_error_handler.dart';
// Sohbet mesajı modelini projeye ekler
import 'ai_message.dart';
// Rehber kişiliklerini projeye ekler
import 'ai_persona.dart';
// AI servis sözleşmesini projeye ekler
import 'ai_service.dart';
// Worker üzerinden mesajlaşma servisini projeye ekler
import 'groq_ai_repository.dart';
// Bilge Rehber sohbetinin mesajlarını ve ayarlarını yönetir
// Rehber sohbetini, kişilik seçimini ve bağlantı tercihlerini yönetir
class AiChatController extends ChangeNotifier {
  // ai sohbet controller nesnesi için gereken başlangıç bilgilerini alır
  AiChatController({AiService? service})
      // Verilmeyen parametre yerine varsayılan nesneyi kullanır
      : _service = service ?? GroqAiRepository();
  // AI yanıtlarını gönderecek servis nesnesini tutar
  AiService _service;
  // Aktif AI servis bağlantısını döndürür
  AiService get service => _service;
  // Worker adresinin kayıt anahtarını tanımlar
  static const _prefWorkerUrl = 'haegaruuetn_ai_worker_url';
  // Vazife paylaşma izninin kayıt anahtarını tanımlar
  static const _prefShareContext = 'haegaruuetn_ai_share_context';
  // Sade Türkçe tercihi için kayıt anahtarını tanımlar
  static const _prefPlainTurkish = 'haegaruuetn_ai_plain_turkish';
  // Rehber kişiliğinin kayıt anahtarını tanımlar
  static const _prefPersona = 'haegaruuetn_ai_persona';
  // Özel talimatların kayıt anahtarını tanımlar
  static const _prefCustomInstructions = 'haegaruuetn_ai_custom_instructions';
  // Sohbet geçmişindeki mesajları tutar
  final List<AiMessage> _messages = [
    // Yeni AiMessage nesnesi oluşturur
    AiMessage(
      // Kaydın benzersiz kimliğini belirler
      id: 'welcome',
      // Mesajı rehber yanıtı olarak işaretler
      role: AiRole.assistant,
      // Mesajın veya pencerenin içeriğini belirler
      content:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Hoş geldin yolcu. Ben krallığın Bilge Rehberi. Bir hedef seç, birlikte ilk küçük adımı bulalım.',
      // timestamp alanına güncel zamanı kullanır
      timestamp: DateTime.now(),
      // Mesajın çevrimdışı kaynaktan geldiğini belirtir
      isOfflineFallback: true,
    ),
  ];
  // Dışarıdan değiştirilemeyen sohbet geçmişini döndürür
  List<AiMessage> get messages => List.unmodifiable(_messages);
  // Seçili rehber kişiliğinin türünü tutar
  AiPersonaType _personaType = AiPersonaType.companion;
  // Seçili rehber kişiliği türünü döndürür
  AiPersonaType get personaType => _personaType;
  // Seçilen rehber kişiliğinin ayrıntılarını döndürür
  AiPersona get currentPersona => AiPersona.fromType(_personaType);
  // AI yanıtı beklenip beklenmediğini tutar
  bool _isLoading = false;
  // AI cevabı beklenip beklenmediğini döndürür
  bool get isLoading => _isLoading;
  // Sohbetteki son hatanın mesajını tutar
  String? _currentError;
  // Son sohbet hatasının metnini döndürür
  String? get currentError => _currentError;
  // Vazife bilgilerinin AI ile paylaşılıp paylaşılmayacağını tutar
  bool _shareHabitContext = false;
  // Kullanıcı vazife paylaşımına izin verdiyse true döndürür
  bool get shareHabitContext => _shareHabitContext;
  // Rehberin sade Türkçe seçeneğinin açık olup olmadığını tutar
  bool _usePlainTurkish = false;
  // Rehber sade Türkçe modundaysa true döndürür
  bool get usePlainTurkish => _usePlainTurkish;
  // Rehbere verilen özel talimatları tutar
  String? _customInstructions;
  // Kullanıcının kayıtlı özel talimatlarını döndürür
  String? get customInstructions => _customInstructions;
  // Kaydedilen Cloudflare Worker adresini tutar
  String _workerUrl = '';
  // Kaydedilen AI Worker adresini döndürür
  String get workerUrl => _workerUrl;
  // Worker adresi varsa bulut bağlantısının ayarlı olduğunu belirtir
  bool get isCloudConnected =>
      // Worker adresi boş değilse ve HTTP adresiyse bağlantıyı etkin sayar
      _workerUrl.trim().isNotEmpty && _workerUrl.startsWith('http');
  // Tekrar denenebilecek son başarısız soruyu tutar
  String? _lastFailedPrompt;
  // Kullanıcı izinli vazife özeti oluşturan nesneyi hazırlar
  final _contextBuilder = const AiContextBuilder();
  // Kayıtlı verileri yükleyip uygulamanın durumunu hazırlar
  Future<void> initialize() async {
    // Hata oluşabilecek işlemleri denemeye başlar
    try {
      // Cihazın yerel tercih kayıtlarını açar
      final prefs = await SharedPreferences.getInstance();
      // Worker adres bilgisini yeni değeriyle günceller
      _workerUrl = prefs.getString(_prefWorkerUrl) ?? '';
      // share vazife bağlam bilgisini yeni değeriyle günceller
      _shareHabitContext = prefs.getBool(_prefShareContext) ?? false;
      // use plain turkish bilgisini yeni değeriyle günceller
      _usePlainTurkish = prefs.getBool(_prefPlainTurkish) ?? false;
      // custom instructions bilgisini yeni değeriyle günceller
      _customInstructions = prefs.getString(_prefCustomInstructions);
      // Daha önce kaydedilen rehber kişiliğini okur
      final savedPersona = prefs.getString(_prefPersona);
      // Daha önce kaydedilmiş kişilik varsa onu yükler
      if (savedPersona != null) {
        // kişilik type bilgisini yeni değeriyle günceller
        _personaType = AiPersonaType.values.firstWhere(
          // Kayıtlı kişilik adına uyan enum değerini arar
          (p) => p.name == savedPersona,
          // Eşleşme bulunmazsa kullanılacak değeri belirler
          orElse: () => AiPersonaType.companion,
        );
      }
      // Worker adresine göre AI servis bağlantısını yeniden oluşturur
      _rebuildService();
      // State değiştiğini dinleyen widgetlara bildirir
      notifyListeners();
    // İşlem başarısız olursa hata durumunu ele alır
    } catch (_) {}
  }
  // Worker adresine göre AI servis bağlantısını yeniden oluşturur
  void _rebuildService() {
    // Mesajları gönderecek AI servis nesnesini değiştirir
    _service =
        // Yeni GroqAiRepository nesnesi oluşturur
        GroqAiRepository(workerUrl: _workerUrl.isEmpty ? null : _workerUrl);
  }
  // Worker adresini temizleyip saklar ve bağlantıyı yeniler
  void setWorkerUrl(String url) async {
    // Worker adres metnindeki fazladan boşlukları temizler
    _workerUrl = url.trim();
    // Worker adresine göre AI servis bağlantısını yeniden oluşturur
    _rebuildService();
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Metin değerini cihazdaki kayda yazar
    await prefs.setString(_prefWorkerUrl, _workerUrl);
  }
  // Rehberin kişiliğini değiştirip tercihi cihaza kaydeder
  void setPersona(AiPersonaType type) async {
    // kişilik type bilgisini yeni değeriyle günceller
    _personaType = type;
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Metin değerini cihazdaki kayda yazar
    await prefs.setString(_prefPersona, type.name);
  }
  // Alışkanlıkların AI ile paylaşılma tercihini günceller
  void toggleShareHabitContext(bool value) async {
    // share vazife bağlam bilgisini yeni değeriyle günceller
    _shareHabitContext = value;
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Açık kapalı ayarını cihazda saklar
    await prefs.setBool(_prefShareContext, value);
  }
  // Rehberin sade Türkçe kullanım tercihini kaydeder
  void togglePlainTurkish(bool value) async {
    // use plain turkish bilgisini yeni değeriyle günceller
    _usePlainTurkish = value;
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Açık kapalı ayarını cihazda saklar
    await prefs.setBool(_prefPlainTurkish, value);
  }
  // Kullanıcı talimatlarını temizleyip cihaza kaydeder
  void setCustomInstructions(String? text) async {
    // custom instructions metnindeki fazladan boşlukları temizler
    _customInstructions = text?.trim().isEmpty == true ? null : text?.trim();
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Özel talimat boş bırakılmışsa kayıtlı ayarı siler
    if (_customInstructions == null) {
      // Kayıtlı tercihi cihazdan siler
      await prefs.remove(_prefCustomInstructions);
    // Önceki koşul sağlanmazsa bu yolu kullanır
    } else {
      // Metin değerini cihazdaki kayda yazar
      await prefs.setString(_prefCustomInstructions, _customInstructions!);
    }
  }
  // Sohbet geçmişini temizleyip yeni karşılama mesajı ekler
  void clearChat() {
    // Sohbet geçmişindeki bütün mesajları temizler
    _messages.clear();
    // Yeni öğeyi ilgili listeye veya kümeye ekler
    _messages.add(
      // Yeni AiMessage nesnesi oluşturur
      AiMessage(
        // Kaydın benzersiz kimliğini belirler
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        // Mesajı rehber yanıtı olarak işaretler
        role: AiRole.assistant,
        // Mesajın veya pencerenin içeriğini belirler
        content:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Sohbet defteri temizlendi. ${currentPersona.name} yeni fermanların için hazır!',
        // timestamp alanına güncel zamanı kullanır
        timestamp: DateTime.now(),
        // Mesajın çevrimdışı kaynaktan geldiğini belirtir
        isOfflineFallback: !isCloudConnected,
      ),
    );
    // Önceki hata durumunu temizler
    _currentError = null;
    // Tekrar denenecek başarısız soruyu temizler
    _lastFailedPrompt = null;
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
  }
  // Kullanıcı mesajını işleyip uygun AI yanıtını getirir
  Future<void> sendMessage(
      // Kullanılacak metin değerini veya onu üreten metodu tanımlar
      String text, RealmController? realmController) async {
    // trimmed bilgisini saklar
    final trimmed = text.trim();
    // Gerekli liste ya da metin boşsa işlem yapmaz
    if (trimmed.isEmpty || _isLoading) return;
    // last failed soru metnindeki fazladan boşlukları temizler
    _lastFailedPrompt = trimmed;
    // Önceki hata durumunu temizler
    _currentError = null;
    // Kullanıcı sorusunu tarihli sohbet mesajına dönüştürür
    final userMessage = AiMessage(
      // Kaydın benzersiz kimliğini belirler
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      // Mesajı kullanıcı tarafından gönderilmiş olarak işaretler
      role: AiRole.user,
      // Mesajın veya pencerenin içeriğini belirler
      content: trimmed,
      // timestamp alanına güncel zamanı kullanır
      timestamp: DateTime.now(),
    );
    // Yeni öğeyi ilgili listeye veya kümeye ekler
    _messages.add(userMessage);
    // Yeni yanıt beklenmeye başlandığını işaretler
    _isLoading = true;
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
    // Hata oluşabilecek işlemleri denemeye başlar
    try {
      // İzin verilmişse kullanıcı vazifelerinden özet çıkarır
      final contextSummary = realmController != null
          // Koşul doğruysa kullanılacak sonucu belirler
          ? _contextBuilder.buildContext(
              // Metin veya liste kontrolcüsünü ilgili alana bağlar
              controller: realmController,
              // consent granted alanına gelen değeri kullanır
              consentGranted: _shareHabitContext,
            )
          // Koşul yanlışsa kullanılacak sonucu belirler
          : null;
      // Hazırlanan sohbet geçmişini AI servisine gönderip yanıtı bekler
      final reply = await _service.sendMessage(
        // AI isteğine gönderilecek önceki mesajları ekler
        history: _messages.where((m) => !m.isError).toList(),
        // Cevapta kullanılacak rehber kişiliğini gönderir
        persona: currentPersona,
        // Kullanıcının mesajını AI isteğine ekler
        userPrompt: trimmed,
        // AI önerisinin kullanabileceği vazifeleri gönderir
        availableHabits: realmController?.activeHabits ?? [],
        // İzin verilen alışkanlık özetini isteğe ekler
        contextSummary: contextSummary,
        // Sade Türkçe tercihinin durumunu gönderir
        plainTurkish: _usePlainTurkish,
        // Kullanıcının özel isteklerini sisteme ekler
        customInstructions: _customInstructions,
      );
      // Yeni öğeyi ilgili listeye veya kümeye ekler
      _messages.add(reply);
      // Tekrar denenecek başarısız soruyu temizler
      _lastFailedPrompt = null;
    // AI servisine ait özel hata türünü yakalar
    } on AiException catch (e) {
      // güncel hata bilgisini yeni değeriyle günceller
      _currentError = e.message;
      // Yeni öğeyi ilgili listeye veya kümeye ekler
      _messages.add(
        // Yeni AiMessage nesnesi oluşturur
        AiMessage(
          // Kaydın benzersiz kimliğini belirler
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          // Mesajı rehber yanıtı olarak işaretler
          role: AiRole.assistant,
          // Mesajın veya pencerenin içeriğini belirler
          content: '⚠️ ${e.message}',
          // timestamp alanına güncel zamanı kullanır
          timestamp: DateTime.now(),
          // Mesajın hata olup olmadığını işaretler
          isError: true,
          // hata mesaj alanına gelen değeri kullanır
          errorMessage: e.message,
        ),
      );
    // İşlem başarısız olursa hata durumunu ele alır
    } catch (e) {
      // güncel hata bilgisini yeni değeriyle günceller
      _currentError = 'Beklenmeyen bir aksaklık oluştu: $e';
      // Yeni öğeyi ilgili listeye veya kümeye ekler
      _messages.add(
        // Yeni AiMessage nesnesi oluşturur
        AiMessage(
          // Kaydın benzersiz kimliğini belirler
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          // Mesajı rehber yanıtı olarak işaretler
          role: AiRole.assistant,
          // Mesajın veya pencerenin içeriğini belirler
          content: '⚠️ Beklenmeyen bir aksaklık oluştu. Lütfen tekrar deneyin.',
          // timestamp alanına güncel zamanı kullanır
          timestamp: DateTime.now(),
          // Mesajın hata olup olmadığını işaretler
          isError: true,
        ),
      );
    // Başarılı ya da hatalı her durumda temizlik işlemini yapar
    } finally {
      // Yanıt bekleme durumunu kapatır
      _isLoading = false;
      // State değiştiğini dinleyen widgetlara bildirir
      notifyListeners();
    }
  }
  // Başarısız son isteği temizleyip yeniden gönderir
  Future<void> retryLast(RealmController? realmController) async {
    // Tekrar denenecek mesaj yoksa veya cevap bekleniyorsa durur
    if (_lastFailedPrompt == null || _isLoading) return;
    // Varsa son hata mesajını sohbetten çıkarır
    // Sohbet geçmişinin son mesajını tekrar deneme için kontrol eder
    if (_messages.isNotEmpty && _messages.last.isError) {
      // Sohbet listesindeki son mesajı kaldırır
      _messages.removeLast();
    }
    // İstek yeniden ekleneceği için önce eski kullanıcı mesajını siler
    // Sohbet geçmişinin son mesajını tekrar deneme için kontrol eder
    if (_messages.isNotEmpty &&
        // En sondaki mesajın kullanıcıya ait olduğunu kontrol eder
        _messages.last.isUser &&
        // messages.last.content bilgisini yeni değerle günceller
        _messages.last.content == _lastFailedPrompt) {
      // Sohbet listesindeki son mesajı kaldırır
      _messages.removeLast();
    }
    // soru to retry bilgisini saklar
    final promptToRetry = _lastFailedPrompt!;
    // Tekrar denenecek başarısız soruyu temizler
    _lastFailedPrompt = null;
    // AI yanıtı gelene kadar asenkron isteği bekler
    await sendMessage(promptToRetry, realmController);
  }
}

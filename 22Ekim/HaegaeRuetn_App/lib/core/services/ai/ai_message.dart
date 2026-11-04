// AI ahit önerisi modelini projeye ekler
import 'pact_suggestion.dart';
// Mesaj göndereni kullanıcı, asistan veya sistem olarak ayırır
enum AiRole { user, assistant, system }
// Represents a single message in the Bilge Rehber chat session.
// Bir sohbet mesajının gönderenini, içeriğini ve tarihini tutar
class AiMessage {
  // AiMessage nesnesinin başlangıç bilgilerini alır
  const AiMessage({
    // ID parametresini zorunlu tutar
    required this.id,
    // role parametresini zorunlu tutar
    required this.role,
    // content parametresini zorunlu tutar
    required this.content,
    // timestamp parametresini zorunlu tutar
    required this.timestamp,
    // ahit suggestion için isteğe bağlı başlangıç değeri alır
    this.pactSuggestion,
    // çevrimdışı fallback için isteğe bağlı başlangıç değeri alır
    this.isOfflineFallback = false,
    // hata için isteğe bağlı başlangıç değeri alır
    this.isError = false,
    // hata mesaj için isteğe bağlı başlangıç değeri alır
    this.errorMessage,
  });
  // Kaydı diğerlerinden ayıran IDyi tutar
  final String id;
  // Mesajın kullanıcıya mı asistana mı ait olduğunu tutar
  final AiRole role;
  // Mesajın metnini tutar
  final String content;
  // Mesajın oluşturulma zamanını tutar
  final DateTime timestamp;
  // Mesaja eklenen yapılandırılmış ahit önerisini tutar
  final PactSuggestion? pactSuggestion;
  // Yanıtın çevrimdışı üretildiğini belirtir
  final bool isOfflineFallback;
  // Mesajın hata içerip içermediğini tutar
  final bool isError;
  // Mesaja ait hata açıklamasını tutar
  final String? errorMessage;
  // Mesaj kullanıcıdan geldiyse true döndürür
  bool get isUser => role == AiRole.user;
  // Mesaj asistandan geldiyse true döndürür
  bool get isAssistant => role == AiRole.assistant;
  // Mevcut nesneyi değiştirmeden seçilen alanlarla yeni kopya oluşturur
  AiMessage copyWith({
    // Mesajın metnini alır, verilmezse null olabilir
    String? content,
    // Mesaja eklenen yapılandırılmış ahit önerisini alır, verilmezse null olabilir
    PactSuggestion? pactSuggestion,
    // Yanıtın çevrimdışı üretildiğini belirtir, verilmezse null olabilir
    bool? isOfflineFallback,
    // Mesajın hata içerip içermediğini alır, verilmezse null olabilir
    bool? isError,
    // Mesaja ait hata açıklamasını alır, verilmezse null olabilir
    String? errorMessage,
  }) =>
      // Yeni AiMessage nesnesi oluşturur
      AiMessage(
        // Kaydın benzersiz kimliğini belirler
        id: id,
        // Mesajın kim tarafından yazıldığını belirtir
        role: role,
        // Mesajın veya pencerenin içeriğini belirler
        content: content ?? this.content,
        // timestamp alanına gelen değeri kullanır
        timestamp: timestamp,
        // Yanıttan çıkarılan ahit önerisini mesaja bağlar
        pactSuggestion: pactSuggestion ?? this.pactSuggestion,
        // Mesajın çevrimdışı kaynaktan geldiğini belirtir
        isOfflineFallback: isOfflineFallback ?? this.isOfflineFallback,
        // Mesajın hata olup olmadığını işaretler
        isError: isError ?? this.isError,
        // hata mesaj alanına gelen değeri kullanır
        errorMessage: errorMessage ?? this.errorMessage,
      );
  // Nesnenin alanlarını JSONa uygun Map biçimine çevirir
  Map<String, dynamic> toJson() => {
        // Kayıt kimliğini JSON alanına yazar
        'id': id,
        // HTTP isteğindeki mesajın gönderen türünü belirler
        'role': role.name,
        // AIya gönderilecek mesaj içeriğini belirler
        'content': content,
        // timestamp alanına gönderilecek değeri yerleştirir
        'timestamp': timestamp.toIso8601String(),
        // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
        if (pactSuggestion != null) 'pactSuggestion': pactSuggestion!.toJson(),
        // isOfflineFallback alanına gönderilecek değeri yerleştirir
        'isOfflineFallback': isOfflineFallback,
        // isError alanına gönderilecek değeri yerleştirir
        'isError': isError,
        // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
        if (errorMessage != null) 'errorMessage': errorMessage,
      };
  // JSON alanlarını okuyarak yeni model nesnesi oluşturur
  factory AiMessage.fromJson(Map<String, dynamic> json) => AiMessage(
        // Kaydın benzersiz kimliğini belirler
        id: json['id'] as String? ??
            // tarih time.now bileşenini oluşturur
            DateTime.now().microsecondsSinceEpoch.toString(),
        // Mesajın kim tarafından yazıldığını belirtir
        role: AiRole.values.firstWhere(
          // JSON nesnesini beklenen tipe dönüştürür
          (r) => r.name == json['role'],
          // Eşleşme bulunmazsa kullanılacak değeri belirler
          orElse: () => AiRole.assistant,
        ),
        // Mesajın veya pencerenin içeriğini belirler
        content: json['content'] as String? ?? '',
        // timestamp alanına gelen değeri kullanır
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            // Tarih çözümlenemezse güncel zamanı kullanır
            DateTime.now(),
        // Yanıttan çıkarılan ahit önerisini mesaja bağlar
        pactSuggestion: json['pactSuggestion'] != null
            // Koşul doğruysa kullanılacak sonucu belirler
            ? PactSuggestion.fromJson(
                // Anahtar değerlerden oluşan tablo hazırlar
                Map<String, dynamic>.from(json['pactSuggestion'] as Map))
            // Koşul yanlışsa kullanılacak sonucu belirler
            : null,
        // Mesajın çevrimdışı kaynaktan geldiğini belirtir
        isOfflineFallback: json['isOfflineFallback'] as bool? ?? false,
        // Mesajın hata olup olmadığını işaretler
        isError: json['isError'] as bool? ?? false,
        // hata mesaj alanına gelen değeri kullanır
        errorMessage: json['errorMessage'] as String?,
      );
}

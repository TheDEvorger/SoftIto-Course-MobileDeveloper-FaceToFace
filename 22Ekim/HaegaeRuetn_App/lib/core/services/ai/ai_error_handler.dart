// AI isteğinde karşılaşılabilecek hata türlerini tanımlar
enum AiErrorCode {
  // Ağ bağlantısı hatasını temsil eder
  networkError,
  // Yetkisiz API erişimini temsil eder
  unauthorized,
  // İstek kotası aşıldığında oluşan hatayı temsil eder
  rateLimitExceeded,
  // Sunucu tarafı hatayı temsil eder
  serverError,
  // Zaman aşımı hatasını temsil eder
  timeout,
  // Bozuk veya boş model yanıtını temsil eder
  invalidResponse,
  // Worker adresi ayarlanmamış durumunu temsil eder
  workerNotConfigured,
  // Sınıflandırılamayan hatayı temsil eder
  unknown,
}
// Structured exception for AI communications.
// AI isteğindeki hata kodunu ve kullanıcı mesajını taşır
class AiException implements Exception {
  // AiException nesnesinin başlangıç bilgilerini alır
  const AiException({
    // code parametresini zorunlu tutar
    required this.code,
    // mesaj parametresini zorunlu tutar
    required this.message,
    // technical details için isteğe bağlı başlangıç değeri alır
    this.technicalDetails,
    // http durum code için isteğe bağlı başlangıç değeri alır
    this.httpStatusCode,
  });
  // code bilgisini saklar
  final AiErrorCode code;
  // mesaj bilgisini saklar
  final String message;
  // technical details bilgisini saklar
  final String? technicalDetails;
  // http durum code bilgisini saklar
  final int? httpStatusCode;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // to string için gerekli sonucu hesaplar
  String toString() => 'AiException($code): $message';
  // AiException nesnesinin başlangıç bilgilerini alır
  factory AiException.fromStatusCode(int status, String? serverMessage) {
    // Yetkisiz erişim hatasını kullanıcıya uygun mesaja çevirir
    if (status == 401) {
      // Yeni AiException nesnesi oluşturup döndürür
      return AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.unauthorized,
        // Kullanıcıya gösterilecek mesajı belirler
        message:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Yetkilendirme hatası (401). Worker kimlik doğrulaması başarısız oldu.',
        // http durum code alanına 401 değerini kullanır
        httpStatusCode: 401,
        // technical details alanına gelen değeri kullanır
        technicalDetails: serverMessage,
      );
    }
    // İstek sınırı aşıldığında uygun hata döndürür
    if (status == 429) {
      // Yeni AiException nesnesi oluşturup döndürür
      return AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.rateLimitExceeded,
        // Kullanıcıya gösterilecek mesajı belirler
        message:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kraliyet habercisi meşgul. Ücretsiz kota sınırına ulaşıldı, lütfen biraz sonra tekrar deneyin.',
        // http durum code alanına 429 değerini kullanır
        httpStatusCode: 429,
        // technical details alanına gelen değeri kullanır
        technicalDetails: serverMessage,
      );
    }
    // Sunucu hatalarını ayrı bir hata türünde toplar
    if (status >= 500) {
      // Yeni AiException nesnesi oluşturup döndürür
      return AiException(
        // Hatanın türünü belirten kodu atar
        code: AiErrorCode.serverError,
        // Kullanıcıya gösterilecek mesajı belirler
        message:
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Sunucu tarafında geçici bir aksaklık oluştu ($status). Lütfen daha sonra tekrar deneyin.',
        // http durum code alanına gelen değeri kullanır
        httpStatusCode: status,
        // technical details alanına gelen değeri kullanır
        technicalDetails: serverMessage,
      );
    }
    // Yeni AiException nesnesi oluşturup döndürür
    return AiException(
      // Hatanın türünü belirten kodu atar
      code: AiErrorCode.unknown,
      // Kullanıcıya gösterilecek mesajı belirler
      message:
          // Değer bulunmazsa varsayılan seçeneği kullanır
          serverMessage ?? 'Beklenmeyen bir sunucu yanıtı alındı ($status).',
      // http durum code alanına gelen değeri kullanır
      httpStatusCode: status,
      // technical details alanına gelen değeri kullanır
      technicalDetails: serverMessage,
    );
  }
}

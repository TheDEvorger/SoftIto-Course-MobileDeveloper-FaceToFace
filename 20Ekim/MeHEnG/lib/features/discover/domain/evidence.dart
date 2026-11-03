// Kanıt bilgilerini tutan model
class Evidence {
  // Constructor gerekli bilgileri alır
  const Evidence({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Deneyin ID bilgisini zorunlu tutar
    required this.experimentId,
    // Kanıt açıklamasını zorunlu tutar
    required this.note,
    // Kanıtın yönünü zorunlu tutar
    required this.direction,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
    // Bilgi kaynağını isteğe bağlı alır
    this.source,
    // Kaydedilme tarihini isteğe bağlı alır
    this.recordedAt,
    // İzin durumunu isteğe bağlı alır
    this.hasConsent = true,
  });
  // ID bilgisini tutar
  final String id;
  // Deneyin ID bilgisini tutar
  final String experimentId;
  // Kanıt açıklamasını tutar
  final String note;
  // Kanıtın yönünü tutar
  final EvidenceDirection direction;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
  // Bilgi kaynağını tutar
  final String? source;
  // Kaydedilme tarihini tutar
  final DateTime? recordedAt;
  // İzin durumunu tutar
  final bool hasConsent;
}
// Kanıtın destekleme durumları
enum EvidenceDirection { supports, contradicts, neutral }

// Deney bilgilerini tutan model
class Experiment {
  // Constructor gerekli bilgileri alır
  const Experiment({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Hipotezin ID bilgisini zorunlu tutar
    required this.hypothesisId,
    // Başlık bilgisini zorunlu tutar
    required this.title,
    // Deney yöntemini zorunlu tutar
    required this.method,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
  });
  // ID bilgisini tutar
  final String id;
  // Hipotezin ID bilgisini tutar
  final String hypothesisId;
  // Başlık bilgisini tutar
  final String title;
  // Deney yöntemini tutar
  final String method;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
}

// Hipotez bilgilerini tutan model
class Hypothesis {
  // Constructor gerekli bilgileri alır
  const Hypothesis({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Girişimin ID bilgisini zorunlu tutar
    required this.ventureId,
    // Hipotez ifadesini zorunlu tutar
    required this.statement,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
  });
  // ID bilgisini tutar
  final String id;
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Hipotez ifadesini tutar
  final String statement;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
}

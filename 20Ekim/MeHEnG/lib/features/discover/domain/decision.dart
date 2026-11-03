// Karar sonucunun seçenekleri
enum DecisionOutcome {
  // Devam et karar seçeneği
  continueRun,
  // Yön değiştir karar seçeneği
  pivot,
  // Sonlandır karar seçeneği
  stop;
  // Enum değerinin görünen adını döndürür
  String get label => switch (this) {
        // Karar sonucunun görünen adını belirler
        DecisionOutcome.continueRun => 'Devam Et (Persevere)',
        // Karar sonucunun görünen adını belirler
        DecisionOutcome.pivot => 'Yön Değiştir (Pivot)',
        // Karar sonucunun görünen adını belirler
        DecisionOutcome.stop => 'Sonlandır (Stop)',
      };
}
// Karar bilgilerini tutan model
class Decision {
  // Constructor gerekli bilgileri alır
  const Decision({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Girişimin ID bilgisini zorunlu tutar
    required this.ventureId,
    // Karar sonucunu zorunlu tutar
    required this.outcome,
    // Kararın gerekçesini zorunlu tutar
    required this.rationale,
    // Kanıt ID listesini zorunlu tutar
    required this.evidenceIds,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
    // Hipotezin ID bilgisini isteğe bağlı alır
    this.hypothesisId,
  });
  // ID bilgisini tutar
  final String id;
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Hipotezin ID bilgisini tutar
  final String? hypothesisId;
  // Karar sonucunu tutar
  final DecisionOutcome outcome;
  // Kararın gerekçesini tutar
  final String rationale;
  // Kanıt ID listesini tutar
  final List<String> evidenceIds;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
}

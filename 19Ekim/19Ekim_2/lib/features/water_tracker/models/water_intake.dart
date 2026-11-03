// İçilen su bilgilerini tutan model sınıfı
class WaterIntake {
  // Constructor gerekli bilgileri alır
  const WaterIntake({
    // Su miktarını zorunlu tutar
    required this.amountMl,
    // Kayıt tarihini zorunlu tutar
    required this.recordedAt,
  });
  // İçilen su miktarını mililitre olarak tutar
  final int amountMl;
  // Suyun içildiği tarih ve saati tutar
  final DateTime recordedAt;
  // Mevcut nesneyi değiştirmeden yeni kopyasını oluşturur
  WaterIntake copyWith({int? amountMl, DateTime? recordedAt}) {
    // Yeni WaterIntake nesnesini döndürür
    return WaterIntake(
      // Yeni miktar varsa onu yoksa eskisini kullanır
      amountMl: amountMl ?? this.amountMl,
      // Yeni tarih varsa onu yoksa eskisini kullanır
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  // JSON verisinden WaterIntake nesnesi oluşturur
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    // JSONdan gelen bilgilerle nesne döndürür
    return WaterIntake(
      // Su miktarını num tipinden int tipine çevirir
      amountMl: (json['amountMl'] as num).toInt(),
      // String tarih bilgisini DateTime tipine çevirir
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }
  // Nesneyi JSONa uygun Map yapısına dönüştürür
  Map<String, dynamic> toJson() {
    // Anahtar ve değerlerden oluşan Map döndürür
    return {
      // Su miktarını kaydeder
      'amountMl': amountMl,
      // Tarihi ISO formatında Stringe çevirir
      'recordedAt': recordedAt.toIso8601String(),
    };
  }
}

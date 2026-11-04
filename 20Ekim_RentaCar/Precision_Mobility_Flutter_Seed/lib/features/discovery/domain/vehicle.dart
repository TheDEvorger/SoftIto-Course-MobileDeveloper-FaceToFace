// araç için sınıf oluşturur
class Vehicle {
  // araç nesnesi oluşturur
  const Vehicle(
      // Veri alanlarını tanımlar
      {required this.id,
      // ad bilgisini zorunlu alır
      required this.name,
      // kategori bilgisini zorunlu alır
      required this.category,
      // enerji bilgisini zorunlu alır
      required this.energy,
      // koltuk sayısı bilgisini zorunlu alır
      required this.seats,
      // rate kuruş cinsinden tutar bilgisini zorunlu alır
      required this.rateMinor,
      // ownership bilgisini zorunlu alır
      required this.ownership,
      // açıklama bilgisini zorunlu alır
      required this.description,
      // this değerini günceller
      this.photoUrl = '',
      // this değerini günceller
      this.published = true,
      // this değerini günceller
      this.example = false,
      // this değerini günceller
      this.artwork = '',
      // this değerini günceller
      this.status = 'active',
      // this değerini günceller
      this.currency = 'TRY'});
  // ID değerini tanımlar
  final String id,
      // Önceki ifadeyi tamamlar
      name,
      // Önceki ifadeyi tamamlar
      category,
      // Önceki ifadeyi tamamlar
      energy,
      // Önceki ifadeyi tamamlar
      ownership,
      // Önceki ifadeyi tamamlar
      description,
      // Önceki ifadeyi tamamlar
      photoUrl,
      // Önceki ifadeyi tamamlar
      status,
      // Önceki ifadeyi tamamlar
      currency;
  // rate kuruş cinsinden tutar bilgisini tutar
  final int seats, rateMinor;
  // example bilgisini tutar
  final bool published, example;
  // artwork bilgisini tutar
  final String artwork;
  // durum filo bilgisini döndürür
  bool get isFleet => ownership == 'fleet';
  // in maintenance bilgisini döndürür
  bool get inMaintenance => status == 'maintenance';
  // durum etiket bilgisini döndürür
  String get statusLabel => inMaintenance
      // Koşul doğruysa bu değeri seçer
      ? 'Bakımda'
      // Koşul yanlışsa bu değeri seçer
      : published
          // Koşul doğruysa bu değeri seçer
          ? 'Yayında'
          // Koşul yanlışsa bu değeri seçer
          : 'Yayında değil';
  // rate etiket bilgisini döndürür
  String get rateLabel => moneyLabel(rateMinor, currency);
  // from json verisinden yeni nesne oluşturur
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
      // ID bilgisini belirler
      id: json['id'] as String,
      // Ad bilgisini belirler
      name: json['name'] as String,
      // Kategori bilgisini belirler
      category: json['category'] as String,
      // Enerji türünü belirler
      energy: json['energy'] as String,
      // koltuk sayısı bilgisini belirler
      seats: json['seats'] as int,
      // rate kuruş cinsinden tutar bilgisini belirler
      rateMinor: json['rate_minor'] as int,
      // ownership bilgisini belirler
      ownership: json['ownership'] as String,
      // açıklama bilgisini belirler
      description: json['description'] as String,
      // fotoğraf url bilgisini belirler
      photoUrl: json['photo_url'] as String? ?? '',
      // published bilgisini belirler
      published: json['published'] != 0 && json['published'] != false,
      // example bilgisini belirler
      example: json['example'] == true,
      // artwork bilgisini belirler
      artwork: json['artwork'] as String? ?? '',
      // Durum bilgisini belirler
      status: json['status'] as String,
      // para birimi bilgisini belirler
      currency: json['currency'] as String);
}
// money etiket işlemini gerçekleştirir
String moneyLabel(int minor, String currency) =>
    // İlgili metin değerini belirler
    '${minor ~/ 100},${(minor % 100).toString().padLeft(2, '0')} $currency';
// tarih anahtar işlemini gerçekleştirir
String dateKey(DateTime date) =>
    // İlgili metin değerini belirler
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
// kiralama gün sayısı işlemini gerçekleştirir
int rentalDays(DateTime start, DateTime end) =>
    // Tarih ve saat bilgisini oluşturur
    DateTime.utc(end.year, end.month, end.day)
        // Önceki ifade üzerinde ek işlem uygular
        .difference(DateTime.utc(start.year, start.month, start.day))
        // Önceki ifade üzerinde ek işlem uygular
        .inDays;

/// Keşif ve kiralama için örnek araç modeli.
/// Gerçek araç veya canlı telemetri içermez; temsili veriler taşır.
// örnek araç için sınıf oluşturur
class DemoVehicle {
  // örnek araç nesnesi oluşturur
  const DemoVehicle(
      // ad parametresini alır
      this.name, this.category, this.pricePerDay, this.distanceKm, this.isFleet,
      // Veri alanlarını tanımlar
      {required this.id,
      // koltuk sayısı bilgisini zorunlu alır
      required this.seats,
      // enerji bilgisini zorunlu alır
      required this.energy,
      // açıklama bilgisini zorunlu alır
      required this.description});
  /// Benzersiz araç kimliği (örn. 'executive-s')
  // ID bilgisini tutar
  final String id;
  /// Araç model adı
  // ad bilgisini tutar
  final String name;
  /// Araç kategorisi ve şanzıman türü (örn. 'Sedan • Otomatik')
  // kategori bilgisini tutar
  final String category;
  /// Günlük kiralama bedeli (TL cinsinden temsili)
  // fiyat per day bilgisini tutar
  final int pricePerDay;
  /// Kullanıcıya olan temsili mesafe (km)
  // distance km bilgisini tutar
  final double distanceKm;
  /// Aracın bir kurumsal filoya mı yoksa bireysel araç sahibine mi ait olduğu
  // durum filo bilgisini tutar
  final bool isFleet;
  /// Koltuk sayısı
  // koltuk sayısı bilgisini tutar
  final int seats;
  /// Yakıt / enerji türü (örn. 'Benzin', 'Elektrik', 'Dizel')
  // enerji bilgisini tutar
  final String energy;
  /// Araç tanıtım açıklaması
  // açıklama bilgisini tutar
  final String description;
  /// Sağlayıcı türü etiketi
  // provider etiket bilgisini döndürür
  String get providerLabel =>
      // Önceki ifadeyi tamamlar
      isFleet ? 'Örnek filo' : 'Örnek bireysel araç sahibi';
}
/// Uygulama genelinde kullanılan statik örnek araç listesi
// örnek araçlar değerini belirler
const demoVehicles = [
  // örnek araç nesnesi oluşturur
  DemoVehicle('Executive S', 'Sedan • Otomatik', 2450, 1.2, true,
      // ID bilgisini belirler
      id: 'executive-s',
      // koltuk sayısı bilgisini belirler
      seats: 5,
      // Enerji türünü belirler
      energy: 'Benzin',
      // açıklama bilgisini belirler
      description: 'Şehir ve uzun yol için örnek konfor sedanı.'),
  // örnek araç nesnesi oluşturur
  DemoVehicle('Urban E', 'Elektrikli • Otomatik', 1750, 2.4, false,
      // ID bilgisini belirler
      id: 'urban-e',
      // koltuk sayısı bilgisini belirler
      seats: 5,
      // Enerji türünü belirler
      energy: 'Elektrik',
      // açıklama bilgisini belirler
      description: 'Şehir içi kullanım için örnek elektrikli araç.'),
  // örnek araç nesnesi oluşturur
  DemoVehicle('Grand Tourer', 'SUV • Otomatik', 3150, 3.8, true,
      // ID bilgisini belirler
      id: 'grand-tourer',
      // koltuk sayısı bilgisini belirler
      seats: 7,
      // Enerji türünü belirler
      energy: 'Dizel',
      // açıklama bilgisini belirler
      description: 'Geniş iç hacimli örnek aile SUV aracı.'),
  // örnek araç nesnesi oluşturur
  DemoVehicle('City Compact', 'Hatchback • Otomatik', 1150, 4.1, false,
      // ID bilgisini belirler
      id: 'city-compact',
      // koltuk sayısı bilgisini belirler
      seats: 4,
      // Enerji türünü belirler
      energy: 'Benzin',
      // açıklama bilgisini belirler
      description: 'Kompakt boyutlu örnek şehir aracı.'),
];
/// Kimliğe (id) göre araç arar, bulunamazsa null döndürür.
// find örnek araç işlemini gerçekleştirir
DemoVehicle? findDemoVehicle(String id) {
  // Listedeki öğeleri veya indeksleri sırayla dolaşır
  for (final vehicle in demoVehicles) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (vehicle.id == id) return vehicle;
  }
  // null bilgisini tutar
  return null;
}

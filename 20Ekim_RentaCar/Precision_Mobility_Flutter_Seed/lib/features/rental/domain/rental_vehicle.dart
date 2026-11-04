// kiralama araç için sınıf oluşturur
class RentalVehicle {
  // kiralama araç nesnesi oluşturur
  const RentalVehicle(
      // Veri alanlarını tanımlar
      {required this.id,
      // ad bilgisini zorunlu alır
      required this.name,
      // kategori bilgisini zorunlu alır
      required this.category,
      // şehir bilgisini zorunlu alır
      required this.city,
      // pickup bilgisini zorunlu alır
      required this.pickup,
      // enerji bilgisini zorunlu alır
      required this.energy,
      // günlük kuruş cinsinden tutar bilgisini zorunlu alır
      required this.dailyMinor,
      // görsel bilgisini zorunlu alır
      required this.image,
      // açıklama bilgisini zorunlu alır
      required this.description,
      // this değerini günceller
      this.seats = 5,
      // this değerini günceller
      this.bags = 2,
      // this değerini günceller
      this.gearbox = 'Otomatik',
      // this değerini günceller
      this.fleet = true});
  // ID değerini tanımlar
  final String id,
      // Önceki ifadeyi tamamlar
      name,
      // Önceki ifadeyi tamamlar
      category,
      // Önceki ifadeyi tamamlar
      city,
      // Önceki ifadeyi tamamlar
      pickup,
      // Önceki ifadeyi tamamlar
      energy,
      // Önceki ifadeyi tamamlar
      image,
      // Önceki ifadeyi tamamlar
      description,
      // Önceki ifadeyi tamamlar
      gearbox;
  // bags bilgisini tutar
  final int dailyMinor, seats, bags;
  // filo bilgisini tutar
  final bool fleet;
  // günlük etiket bilgisini döndürür
  String get dailyLabel => rentalMoney(dailyMinor);
}
// kiralama money işlemini gerçekleştirir
String rentalMoney(int minor) {
  // whole değerini belirler
  final whole = (minor ~/ 100)
      // Önceki ifade üzerinde ek işlem uygular
      .toString()
      // Önceki ifade üzerinde ek işlem uygular
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  // Hesaplanan sonucu geri döndürür
  return '$whole,${(minor % 100).toString().padLeft(2, '0')} ₺';
}
// calendar gün sayısı işlemini gerçekleştirir
int calendarDays(DateTime start, DateTime end) =>
    // Tarih ve saat bilgisini oluşturur
    DateTime.utc(end.year, end.month, end.day)
        // Önceki ifade üzerinde ek işlem uygular
        .difference(DateTime.utc(start.year, start.month, start.day))
        // Önceki ifade üzerinde ek işlem uygular
        .inDays;
// kiralama tarih anahtar işlemini gerçekleştirir
String rentalDateKey(DateTime date) =>
    // İlgili metin değerini belirler
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

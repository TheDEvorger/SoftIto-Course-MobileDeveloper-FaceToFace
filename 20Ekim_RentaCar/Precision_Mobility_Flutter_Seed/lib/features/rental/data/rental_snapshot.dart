// JSON kodlama ve çözme işlemlerini ekler
import 'dart:convert';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama kayıt anlık görüntüsü için sınıf oluşturur
class RentalSnapshot {
  // kiralama kayıt anlık görüntüsü nesnesi oluşturur
  RentalSnapshot(
      // Veri alanlarını tanımlar
      {Set<String>? favorites,
      // Asenkron işlemi veya veri türünü tanımlar
      List<LocalReservation>? plans,
      // this değerini günceller
      this.theme = 'system',
      // this değerini günceller
      this.city = 'Tüm şehirler'})
      // Constructor alanlarını başlangıç değerleriyle ayarlar
      : favorites = favorites ?? {},
        // planlar değerini günceller
        plans = plans ?? [];
  // favoriler bilgisini tutar
  final Set<String> favorites;
  // planlar bilgisini tutar
  final List<LocalReservation> plans;
  // Önceki ifadeyi tamamlar
  String theme, city;
  // copy işlemini gerçekleştirir
  RentalSnapshot copy() => RentalSnapshot(
      // favoriler bilgisini belirler
      favorites: {...favorites}, plans: [...plans], theme: theme, city: city);
  // encode işlemini gerçekleştirir
  String encode() => jsonEncode({
        // İlgili metin değerini belirler
        'version': 1,
        // İlgili metin değerini belirler
        'favorites': favorites.toList(),
        // İlgili metin değerini belirler
        'plans': plans.map((r) => r.toJson()).toList(),
        // İlgili metin değerini belirler
        'theme': theme,
        // İlgili metin değerini belirler
        'city': city
      });
  // decode verisinden yeni nesne oluşturur
  factory RentalSnapshot.decode(String raw) {
    // veri değerini belirler
    final data = jsonDecode(raw) as Map<String, dynamic>;
    // Koşul doğruysa bu işlemi çalıştırır
    if (data['version'] != 1 ||
        // Önceki ifadeyi tamamlar
        !['system', 'light', 'dark'].contains(data['theme']) ||
        // Önceki ifadeyi tamamlar
        !['Tüm şehirler', 'İstanbul', 'Ankara', 'İzmir']
            // Önceki ifade üzerinde ek işlem uygular
            .contains(data['city'])) {
      // Veri biçimi hatası oluşturur
      throw const FormatException();
    }
    // Hesaplanan sonucu geri döndürür
    return RentalSnapshot(
        // favoriler bilgisini belirler
        favorites: (data['favorites'] as List).cast<String>().toSet(),
        // planlar bilgisini belirler
        plans: (data['plans'] as List)
            // Listedeki elemanları dönüştürür
            .map((r) => LocalReservation.fromJson(r as Map<String, dynamic>))
            // Sonucu listeye dönüştürür
            .toList(),
        // Açık tema ayarlarını verir
        theme: data['theme'] as String,
        // Şehir bilgisini belirler
        city: data['city'] as String);
  }
}

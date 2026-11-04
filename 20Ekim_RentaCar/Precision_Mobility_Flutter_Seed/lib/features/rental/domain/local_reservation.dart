// kiralama araç dosyasını ekler
import 'rental_vehicle.dart';
// yerel rezervasyon için sınıf oluşturur
class LocalReservation {
  // yerel rezervasyon nesnesi oluşturur
  const LocalReservation(
      // Veri alanlarını tanımlar
      {required this.id,
      // araç ID bilgisini zorunlu alır
      required this.vehicleId,
      // başlangıç bilgisini zorunlu alır
      required this.start,
      // bitiş bilgisini zorunlu alır
      required this.end,
      // toplam kuruş cinsinden tutar bilgisini zorunlu alır
      required this.totalMinor,
      // işlem anahtarı bilgisini zorunlu alır
      required this.requestKey,
      // this değerini günceller
      this.cancelled = false});
  // işlem anahtarı bilgisini tutar
  final String id, vehicleId, requestKey;
  // bitiş bilgisini tutar
  final DateTime start, end;
  // toplam kuruş cinsinden tutar bilgisini tutar
  final int totalMinor;
  // cancelled bilgisini tutar
  final bool cancelled;
  // toplam etiket bilgisini döndürür
  String get totalLabel => rentalMoney(totalMinor);
  // iptal işlemini gerçekleştirir
  LocalReservation cancel() => LocalReservation(
      // ID bilgisini belirler
      id: id,
      // araç ID bilgisini belirler
      vehicleId: vehicleId,
      // Başlangıç bilgisini belirler
      start: start,
      // Bitiş bilgisini belirler
      end: end,
      // Toplam tutarı kuruş cinsinden belirler
      totalMinor: totalMinor,
      // İşlemin tekrarını önleyen anahtarı belirler
      requestKey: requestKey,
      // cancelled bilgisini belirler
      cancelled: true);
  // to json işlemini gerçekleştirir
  Map<String, dynamic> toJson() => {
        // İlgili metin değerini belirler
        'id': id,
        // İlgili metin değerini belirler
        'vehicle': vehicleId,
        // İlgili metin değerini belirler
        'start': rentalDateKey(start),
        // İlgili metin değerini belirler
        'end': rentalDateKey(end),
        // İlgili metin değerini belirler
        'total': totalMinor,
        // İlgili metin değerini belirler
        'request': requestKey,
        // İlgili metin değerini belirler
        'cancelled': cancelled
      };
  // from json verisinden yeni nesne oluşturur
  factory LocalReservation.fromJson(Map<String, dynamic> json) {
    // başlangıç değerini belirler
    final start = DateTime.parse(json['start'] as String);
    // bitiş değerini belirler
    final end = DateTime.parse(json['end'] as String);
    // toplam değerini belirler
    final total = json['total'] as int;
    // Koşul doğruysa bu işlemi çalıştırır
    if (calendarDays(start, end) < 1 || total < 1) {
      // Veri biçimi hatası oluşturur
      throw const FormatException();
    }
    // Hesaplanan sonucu geri döndürür
    return LocalReservation(
        // ID bilgisini belirler
        id: json['id'] as String,
        // araç ID bilgisini belirler
        vehicleId: json['vehicle'] as String,
        // Başlangıç bilgisini belirler
        start: start,
        // Bitiş bilgisini belirler
        end: end,
        // Toplam tutarı kuruş cinsinden belirler
        totalMinor: total,
        // İşlemin tekrarını önleyen anahtarı belirler
        requestKey: json['request'] as String,
        // cancelled bilgisini belirler
        cancelled: json['cancelled'] as bool);
  }
}
// kiralama fiyat teklifi için sınıf oluşturur
class RentalQuote {
  // kiralama fiyat teklifi nesnesi oluşturur
  const RentalQuote(
      // Veri alanlarını tanımlar
      {required this.vehicleId,
      // başlangıç bilgisini zorunlu alır
      required this.start,
      // bitiş bilgisini zorunlu alır
      required this.end,
      // günlük kuruş cinsinden tutar bilgisini zorunlu alır
      required this.dailyMinor,
      // sona erme at bilgisini zorunlu alır
      required this.expiresAt});
  // araç ID bilgisini tutar
  final String vehicleId;
  // sona erme at bilgisini tutar
  final DateTime start, end, expiresAt;
  // günlük kuruş cinsinden tutar bilgisini tutar
  final int dailyMinor;
  // gün sayısı bilgisini döndürür
  int get days => calendarDays(start, end);
  // toplam kuruş cinsinden tutar bilgisini döndürür
  int get totalMinor => dailyMinor * days;
  // toplam etiket bilgisini döndürür
  String get totalLabel => rentalMoney(totalMinor);
}
// kiralama failure sınıfını tanımlar ve belirtilen sözleşmeyi uygular
class RentalFailure implements Exception {
  // kiralama failure nesnesi oluşturur
  const RentalFailure(this.message);
  // mesaj bilgisini tutar
  final String message;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // to string işlemini gerçekleştirir
  String toString() => message;
}

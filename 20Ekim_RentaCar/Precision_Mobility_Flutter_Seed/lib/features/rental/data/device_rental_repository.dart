// Asenkron işlem yapılarını ekler
import 'dart:async';
// Matematiksel işlemleri ekler
import 'dart:math';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// kiralama kayıt anlık görüntüsü dosyasını ekler
import 'rental_snapshot.dart';
// kiralama depolama dosyasını ekler
import 'rental_storage.dart';
// device kiralama veri deposu için sınıf oluşturur
class DeviceRentalRepository {
  // device kiralama veri deposu nesnesi oluşturur
  DeviceRentalRepository(this.storage, this.catalog,
      // Saat fonksiyonunu isteğe bağlı alır
      {DateTime Function()? clock})
      // Constructor alanlarını başlangıç değerleriyle ayarlar
      : clock = clock ?? DateTime.now;
  // depolama bilgisini tutar
  final RentalStorage storage;
  // araç kataloğu bilgisini tutar
  final List<RentalVehicle> catalog;
  // function bilgisini tutar
  final DateTime Function() clock;
  // veri değerini belirler
  RentalSnapshot _data = RentalSnapshot();
  // veri bilgisini döndürür
  RentalSnapshot get data => _data.copy();
  // Asenkron işlemi veya veri türünü tanımlar
  Future<void> _tail = Future.value();
  // hazırlık değerini belirler
  bool _ready = false;
  // yükleme işlemini asenkron yürütür
  Future<void> load() async {
    // Hata oluşabilecek işlemleri dener
    try {
      // raw değerini belirler
      final raw = await storage.read();
      // next değerini belirler
      final next = raw == null ? RentalSnapshot() : RentalSnapshot.decode(raw);
      // Koşul doğruysa bu işlemi çalıştırır
      if (next.plans.any((r) => !catalog.any((v) => v.id == r.vehicleId))) {
        // Veri biçimi hatası oluşturur
        throw const FormatException();
      }
      // veri değerini günceller
      _data = next;
      // hazırlık değerini günceller
      _ready = true;
    // İşlem hata verirse çalışır
    } catch (_) {
      // hazırlık değerini günceller
      _ready = false;
      // Kiralama işleminin hata mesajını oluşturur
      throw const RentalFailure(
          // İlgili metin değerini belirler
          'Cihazdaki kayıtlar okunamadı. Veriler korunuyor; yeniden deneyin.');
    }
  }
  // araç işlemini gerçekleştirir
  RentalVehicle vehicle(String id) => catalog.firstWhere((v) => v.id == id,
      // kiralama failure constructorını tanımlar
      orElse: () => throw const RentalFailure('Araç bulunamadı.'));
  // uygunluk işlemini gerçekleştirir
  bool available(String id, DateTime start, DateTime end,
          // Veri alanlarını tanımlar
          {RentalSnapshot? data}) =>
      // Sonraki ifadeyi sonuç olarak döndürür
      !(data ?? _data).plans.any((r) =>
          // r değerini günceller
          r.vehicleId == id &&
          // Önceki ifadeyi tamamlar
          !r.cancelled &&
          // Önceki ifadeyi tamamlar
          r.start.isBefore(end) &&
          // Önceki ifadeyi tamamlar
          r.end.isAfter(start));
  // fiyat teklifi işlemini gerçekleştirir
  RentalQuote quote(String id, DateTime start, DateTime end) {
    // İlgili metodu çalıştırır
    _validateDates(start, end);
    // Uygunluk durumuna göre işlemi yapar
    if (!available(id, start, end)) {
      // Kiralama işleminin hata mesajını oluşturur
      throw const RentalFailure(
          // İlgili metin değerini belirler
          'Bu araç için seçilen tarihlerde bir planınız var.');
    }
    // Hesaplanan sonucu geri döndürür
    return RentalQuote(
        // araç ID bilgisini belirler
        vehicleId: id,
        // Başlangıç bilgisini belirler
        start: start,
        // Bitiş bilgisini belirler
        end: end,
        // Günlük fiyatı kuruş cinsinden belirler
        dailyMinor: vehicle(id).dailyMinor,
        // Son geçerlilik zamanını belirler
        expiresAt: clock().add(const Duration(minutes: 5)));
  }
  // doğrulama tarihler işlemini gerçekleştirir
  void _validateDates(DateTime start, DateTime end) {
    // today değerini belirler
    final today = clock();
    // Koşul doğruysa bu işlemi çalıştırır
    if (start.isBefore(DateTime(today.year, today.month, today.day)) ||
        // İfadeye karşılaştırma koşulu ekler
        start.hour != 0 ||
        // İfadeye karşılaştırma koşulu ekler
        end.hour != 0 ||
        // İfadeye karşılaştırma koşulu ekler
        start.minute != 0 ||
        // İfadeye karşılaştırma koşulu ekler
        end.minute != 0 ||
        // İlgili fonksiyonu çalıştırır
        calendarDays(start, end) < 1 ||
        // İlgili fonksiyonu çalıştırır
        calendarDays(start, end) > 7) {
      // Kiralama işleminin hata mesajını oluşturur
      throw const RentalFailure(
          // İlgili metin değerini belirler
          'Bugünden itibaren 1–7 günlük bir aralık seçin.');
    }
  }
  // reserve işlemini asenkron yürütür
  Future<LocalReservation> reserve(RentalQuote quote, String requestKey) =>
      // İlgili metodu çalıştırır
      _write((next) {
        // Listedeki öğeleri veya indeksleri sırayla dolaşır
        for (final old in next.plans) {
          // Koşul doğruysa bu işlemi çalıştırır
          if (old.requestKey == requestKey) {
            // Koşul doğruysa bu işlemi çalıştırır
            if (old.vehicleId != quote.vehicleId ||
                // İfadeye karşılaştırma koşulu ekler
                old.start != quote.start ||
                // İfadeye karşılaştırma koşulu ekler
                old.end != quote.end) {
              // Kiralama işleminin hata mesajını oluşturur
              throw const RentalFailure(
                  // İlgili metin değerini belirler
                  'İşlem anahtarı başka bir plan için kullanılmış.');
            }
            // old bilgisini tutar
            return old;
          }
        }
        // İlgili metodu çalıştırır
        _validateDates(quote.start, quote.end);
        // Koşul doğruysa bu işlemi çalıştırır
        if (!quote.expiresAt.isAfter(clock()) ||
            // İfadeye karşılaştırma koşulu ekler
            quote.dailyMinor != vehicle(quote.vehicleId).dailyMinor) {
          // Kiralama işleminin hata mesajını oluşturur
          throw const RentalFailure(
              // İlgili metin değerini belirler
              'Fiyat özeti güncellendi. Tekrar kontrol edip onaylayın.');
        }
        // Uygunluk durumuna göre işlemi yapar
        if (!available(quote.vehicleId, quote.start, quote.end, data: next)) {
          // Kiralama işleminin hata mesajını oluşturur
          throw const RentalFailure(
              // İlgili metin değerini belirler
              'Bu araç için seçilen tarihlerde bir planınız var.');
        }
        // Liste veya metin boşsa koşulu çalıştırır
        if (requestKey.isEmpty) {
          // Kiralama işleminin hata mesajını oluşturur
          throw const RentalFailure('İşlem anahtarı gerekli.');
        }
        // kayıt değerini belirler
        final record = LocalReservation(
            // ID bilgisini belirler
            id: 'PM-${clock().year}-${newRequestKey().substring(0, 8).toUpperCase()}',
            // araç ID bilgisini belirler
            vehicleId: quote.vehicleId,
            // Başlangıç bilgisini belirler
            start: quote.start,
            // Bitiş bilgisini belirler
            end: quote.end,
            // Toplam tutarı kuruş cinsinden belirler
            totalMinor: quote.totalMinor,
            // İşlemin tekrarını önleyen anahtarı belirler
            requestKey: requestKey);
        // Önceki ifadeyi tamamlar
        next.plans.insert(0, record);
        // kayıt bilgisini tutar
        return record;
      });
  // iptal işlemini asenkron yürütür
  Future<void> cancel(String id) => _write((next) {
        // indeks değerini belirler
        final index = next.plans.indexWhere((r) => r.id == id);
        // kiralama failure constructorını tanımlar
        if (index < 0) throw const RentalFailure('Rezervasyon bulunamadı.');
        // next değerini günceller
        next.plans[index] = next.plans[index].cancel();
      });
  // favori işlemini asenkron yürütür
  Future<void> favorite(String id) => _write((next) {
        // İlgili fonksiyonu çalıştırır
        vehicle(id);
        // Koşul doğruysa bu işlemi çalıştırır
        if (!next.favorites.remove(id)) next.favorites.add(id);
      });
  // preferences işlemini asenkron yürütür
  Future<void> preferences({String? theme, String? city}) => _write((next) {
        // Değer null değilse koşulu çalıştırır
        if (theme != null) {
          // Koşul doğruysa bu işlemi çalıştırır
          if (!['system', 'light', 'dark'].contains(theme)) {
            // Kiralama işleminin hata mesajını oluşturur
            throw const RentalFailure('Görünüm seçimi geçersiz.');
          }
          // next değerini günceller
          next.theme = theme;
        }
        // Değer null değilse koşulu çalıştırır
        if (city != null) {
          // Koşul doğruysa bu işlemi çalıştırır
          if (!['Tüm şehirler', 'İstanbul', 'Ankara', 'İzmir'].contains(city)) {
            // Kiralama işleminin hata mesajını oluşturur
            throw const RentalFailure('Şehir seçimi geçersiz.');
          }
          // next değerini günceller
          next.city = city;
        }
      });
  // Asenkron işlemi veya veri türünü tanımlar
  Future<T> _write<T>(T Function(RentalSnapshot) mutate) {
    // sonuç değerini belirler
    final result = Completer<T>();
    // tail değerini günceller
    _tail = _tail.then((_) async {
      // Hata oluşabilecek işlemleri dener
      try {
        // Koşul doğruysa bu işlemi çalıştırır
        if (!_ready) {
          // Kiralama işleminin hata mesajını oluşturur
          throw const RentalFailure('Cihaz kayıtlarını yeniden yükleyin.');
        }
        // raw değerini belirler
        final raw = await storage.read();
        // next değerini belirler
        final next =
            // raw değerini günceller
            raw == null ? RentalSnapshot() : RentalSnapshot.decode(raw);
        // değer değerini belirler
        final value = mutate(next);
        // Verilerin kaydedilmesini bekler
        await storage.write(next.encode());
        // veri değerini günceller
        _data = next;
        // İlgili verinin özelliğini kontrol eder
        result.complete(value);
      // İşlem hata verirse çalışır
      } catch (error, stack) {
        // İlgili verinin özelliğini kontrol eder
        result.completeError(
            // Gelen değerin tipini kontrol eder
            error is RentalFailure
                // Koşul doğruysa bu değeri seçer
                ? error
                // kiralama failure constructorını tanımlar
                : const RentalFailure(
                    // İlgili metin değerini belirler
                    'Değişiklik cihaza kaydedilemedi. Tekrar deneyin.'),
            // Önceki ifadeyi tamamlar
            stack);
      }
    });
    // Hesaplanan sonucu geri döndürür
    return result.future;
  }
  // yeni istek anahtar değerini tanımlar
  static String newRequestKey() {
    // random değerini belirler
    final random = Random.secure();
    // Hesaplanan sonucu geri döndürür
    return List.generate(
            // Önceki ifadeyi tamamlar
            16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'))
        // Önceki ifade üzerinde ek işlem uygular
        .join();
  }
}

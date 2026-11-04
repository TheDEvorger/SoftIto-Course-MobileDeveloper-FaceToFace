/// Rezervasyon yaşam döngüsü durumları:
/// - quoted: Teklif oluşturuldu, kullanıcı onayı bekleniyor.
/// - confirmed: Kullanıcı tarafından onaylandı, araç tahsis edildi.
/// - cancelled: İptal edildi, araç serbest bırakıldı.
/// - expired: 5 dakikalık teklif süresi doldu.
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum BookingState { quoted, confirmed, cancelled, expired }
/// Rezervasyon veri kaydı modeli.
// örnek rezervasyon için sınıf oluşturur
class DemoBooking {
  // örnek rezervasyon nesnesi oluşturur
  const DemoBooking(
      // Veri alanlarını tanımlar
      {required this.id,
      // araç ID bilgisini zorunlu alır
      required this.vehicleId,
      // araç ad bilgisini zorunlu alır
      required this.vehicleName,
      // başlangıç bilgisini zorunlu alır
      required this.start,
      // bitiş bilgisini zorunlu alır
      required this.end,
      // sona erme at bilgisini zorunlu alır
      required this.expiresAt,
      // toplam bilgisini zorunlu alır
      required this.total,
      // this değerini günceller
      this.state = BookingState.quoted});
  /// Rezervasyon kayıt kimliği (örn. 'demo-1')
  // ID bilgisini tutar
  final String id;
  /// Kiralanan aracın kimliği
  // araç ID bilgisini tutar
  final String vehicleId;
  /// Araç adı
  // araç ad bilgisini tutar
  final String vehicleName;
  /// Kiralama başlangıç zamanı
  // başlangıç bilgisini tutar
  final DateTime start;
  /// Kiralama bitiş zamanı
  // bitiş bilgisini tutar
  final DateTime end;
  /// Teklifin geçerlilik bitiş zamanı (oluşturulduktan 5 dakika sonra)
  // sona erme at bilgisini tutar
  final DateTime expiresAt;
  /// Toplam ücret tutarı
  // toplam bilgisini tutar
  final int total;
  /// Rezervasyonun güncel durumu
  // durum bilgisini tutar
  final BookingState state;
  /// Demo poliçe sürümü
  // policy version bilgisini döndürür
  String get policyVersion => 'demo-v1';
  /// Durumu güncellenmiş yeni bir DemoBooking kopyası üretir (immutability).
  // with durum işlemini gerçekleştirir
  DemoBooking withState(BookingState value) => DemoBooking(
      // ID bilgisini belirler
      id: id,
      // araç ID bilgisini belirler
      vehicleId: vehicleId,
      // araç ad bilgisini belirler
      vehicleName: vehicleName,
      // Başlangıç bilgisini belirler
      start: start,
      // Bitiş bilgisini belirler
      end: end,
      // Son geçerlilik zamanını belirler
      expiresAt: expiresAt,
      // toplam bilgisini belirler
      total: total,
      // durum bilgisini belirler
      state: value);
}
/// Bellek içi rezervasyon defteri (In-memory ledger).
/// Teklif oluşturma, çakışma (overlap) denetimi, onaylama ve iptal mantığını barındırır.
// rezervasyon defter için sınıf oluşturur
class BookingLedger {
  // kayıtlar değerini tanımlar
  final Map<String, DemoBooking> _records = {};
  // sequence değerini belirler
  int _sequence = 0;
  // kayıtlar bilgisini döndürür
  List<DemoBooking> get records => List.unmodifiable(_records.values);
  /// Yeni bir kiralama teklifi oluşturur ve 5 dakikalık süre başlatır.
  // fiyat teklifi işlemini gerçekleştirir
  DemoBooking quote(
      // Veri alanlarını tanımlar
      {required String vehicleId,
      // Parametre bilgisini zorunlu alır
      required String vehicleName,
      // Parametre bilgisini zorunlu alır
      required int dailyRate,
      // Parametre bilgisini zorunlu alır
      required DateTime start,
      // Parametre bilgisini zorunlu alır
      required DateTime end,
      // Parametre bilgisini zorunlu alır
      required DateTime now}) {
    // Liste veya metin boşsa koşulu çalıştırır
    if (vehicleId.isEmpty ||
        // Önceki ifadeyi tamamlar
        vehicleName.isEmpty ||
        // İfadeye karşılaştırma koşulu ekler
        dailyRate <= 0 ||
        // Önceki ifadeyi tamamlar
        !start.isAfter(now) ||
        // İlgili işlemin kod bloğunu başlatır
        !end.isAfter(start)) {
      // Geçersiz parametre hatası verir
      throw ArgumentError('Geçersiz örnek araç, tarih veya fiyat.');
    }
    // gün sayısı değerini belirler
    final days = (end.difference(start).inMilliseconds /
            // Süre bilgisini oluşturur
            const Duration(days: 1).inMilliseconds)
        // Önceki ifade üzerinde ek işlem uygular
        .ceil();
    // kayıt değerini belirler
    final record = DemoBooking(
        // ID bilgisini belirler
        id: 'demo-${++_sequence}',
        // araç ID bilgisini belirler
        vehicleId: vehicleId,
        // araç ad bilgisini belirler
        vehicleName: vehicleName,
        // Başlangıç bilgisini belirler
        start: start,
        // Bitiş bilgisini belirler
        end: end,
        // Son geçerlilik zamanını belirler
        expiresAt: now.add(const Duration(minutes: 5)),
        // toplam bilgisini belirler
        total: days * dailyRate);
    // kayıtlar değerini günceller
    _records[record.id] = record;
    // kayıt bilgisini tutar
    return record;
  }
  /// Rezervasyonu kimliğe göre getirir; teklif süresi dolmuşsa durumunu 'expired' yapar.
  // get işlemini gerçekleştirir
  DemoBooking get(String id, DateTime now) {
    // kayıt değerini belirler
    var record = _records[id];
    // Değer null ise koşulu çalıştırır
    if (record == null) throw StateError('Örnek rezervasyon bulunamadı.');
    // Koşul doğruysa bu işlemi çalıştırır
    if (record.state == BookingState.quoted &&
        // Koşul veya parametre ifadesini devam ettirir
        (!now.isBefore(record.expiresAt) || !now.isBefore(record.start))) {
      // kayıt değerini günceller
      record = record.withState(BookingState.expired);
      // kayıtlar değerini günceller
      _records[id] = record;
    }
    // kayıt bilgisini tutar
    return record;
  }
  /// Teklifi onaylar ve çakışan başka onaylı rezervasyon olup olmadığını doğrular.
  // onay işlemini gerçekleştirir
  DemoBooking confirm(String id, DateTime now) {
    // kayıt değerini belirler
    final record = get(id, now);
    // Koşul doğruysa bu işlemi çalıştırır
    if (record.state != BookingState.quoted) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Yalnızca geçerli bir teklif onaylanabilir.');
    }
    // conflict değerini belirler
    final conflict = _records.values.any((other) =>
        // İfadeye karşılaştırma koşulu ekler
        other.id != id &&
        // other değerini günceller
        other.vehicleId == record.vehicleId &&
        // other değerini günceller
        other.state == BookingState.confirmed &&
        // Önceki ifadeyi tamamlar
        record.start.isBefore(other.end) &&
        // Önceki ifadeyi tamamlar
        record.end.isAfter(other.start));
    // Koşul doğruysa bu işlemi çalıştırır
    if (conflict) throw StateError('Bu örnek araç için tarih çakışması var.');
    // Hesaplanan sonucu geri döndürür
    return _records[id] = record.withState(BookingState.confirmed);
  }
  /// Onaylı veya teklif aşamasındaki rezervasyonu iptal eder.
  // iptal işlemini gerçekleştirir
  DemoBooking cancel(String id, DateTime now) {
    // kayıt değerini belirler
    final record = get(id, now);
    // Koşul doğruysa bu işlemi çalıştırır
    if (record.state != BookingState.quoted &&
        // İfadeye karşılaştırma koşulu ekler
        record.state != BookingState.confirmed) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Bu durumdan iptal yapılamaz.');
    }
    // Hesaplanan sonucu geri döndürür
    return _records[id] = record.withState(BookingState.cancelled);
  }
}

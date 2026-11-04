/// Teslimat yöntemi (Fiziksel anahtar teslimi veya Dijital akıllı kilit)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum HandoverMode { physical, digital }
/// Dijital kilit onay durumları (fail-closed güvenlik prensibi ile)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum DemoLockState { unconfirmed, acknowledged, uncertain, rejected }
/// Teslimatın başlayabilmesi için sağlanması zorunlu ön koşullar
// teslim prerequisites için sınıf oluşturur
class HandoverPrerequisites {
  // teslim prerequisites nesnesi oluşturur
  const HandoverPrerequisites(
      // Veri alanlarını tanımlar
      {required this.bookingConfirmed,
      // pickup window bilgisini zorunlu alır
      required this.pickupWindow,
      // sürücü authorized bilgisini zorunlu alır
      required this.driverAuthorized,
      // araç hazırlık bilgisini zorunlu alır
      required this.vehicleReady,
      // this değerini günceller
      this.compatible = false});
  /// Rezervasyonun aktif ve onaylı olup olmadığı
  // rezervasyon confirmed bilgisini tutar
  final bool bookingConfirmed;
  /// Alış zaman aralığı (pickup window) içinde olunup olunmadığı
  // pickup window bilgisini tutar
  final bool pickupWindow;
  /// Sürücünün kimlik ve ehliyet doğrulamasının geçerliliği
  // sürücü authorized bilgisini tutar
  final bool driverAuthorized;
  /// Aracın temizlik ve hazırlık durumunun uygunluğu
  // araç hazırlık bilgisini tutar
  final bool vehicleReady;
  /// Aracın dijital donanım ve telemetri uyumluluğu
  // compatible bilgisini tutar
  final bool compatible;
}
/// Temsili teslimat simülasyon mantığı (Fail-closed prensibi).
/// Donanım veya araç kilidine doğrudan komut göndermez; güvenlik doğrulamasını simüle eder.
// örnek teslim için sınıf oluşturur
class DemoHandover {
  // örnek teslim nesnesi oluşturur
  DemoHandover(this.mode);
  /// Teslim yöntemi (fiziksel veya dijital)
  // mod bilgisini tutar
  final HandoverMode mode;
  // preflight passed değerini belirler
  bool _preflightPassed = false;
  // lock değerini belirler
  DemoLockState _lock = DemoLockState.unconfirmed;
  // preflight passed bilgisini döndürür
  bool get preflightPassed => _preflightPassed;
  // lock bilgisini döndürür
  DemoLockState get lock => _lock;
  // completed değerini belirler
  bool _completed = false;
  // completed bilgisini döndürür
  bool get completed => _completed;
  /// Koşullar değiştiğinde tamamlanma durumunu geçersiz kılar
  // invalidate completion işlemini gerçekleştirir
  void invalidateCompletion() => _completed = false;
  /// Teslimat öncesi ön kontrol (Preflight) çalıştırır.
  /// Tüm zorunlu koşulların sağlanıp sağlanmadığını denetler.
  // preflight işlemini gerçekleştirir
  void preflight(HandoverPrerequisites prerequisites) {
    // preflight passed değerini günceller
    _preflightPassed = false;
    // lock değerini günceller
    _lock = DemoLockState.unconfirmed;
    // completed değerini günceller
    _completed = false;
    // Koşul doğruysa bu işlemi çalıştırır
    if (!prerequisites.bookingConfirmed ||
        // Önceki ifadeyi tamamlar
        !prerequisites.pickupWindow ||
        // Önceki ifadeyi tamamlar
        !prerequisites.driverAuthorized ||
        // İlgili işlemin kod bloğunu başlatır
        !prerequisites.vehicleReady) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError(
          // İlgili metin değerini belirler
          'Rezervasyon, teslim zamanı, sürücü ve araç koşulları gerekli.');
    }
    // Koşul doğruysa bu işlemi çalıştırır
    if (mode == HandoverMode.digital && !prerequisites.compatible) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Dijital demo için temsili donanım uyumluluğu gerekli.');
    }
    // preflight passed değerini günceller
    _preflightPassed = true;
  }
  /// Dijital kilit yanıtını simüle eder (kabul veya ret).
  // acknowledge örnek unlock işlemini gerçekleştirir
  void acknowledgeDemoUnlock({required bool accepted}) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!_preflightPassed || mode != HandoverMode.digital || completed) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Dijital ön kontrol geçmeden örnek onay alınamaz.');
    }
    // lock değerini günceller
    _lock = accepted ? DemoLockState.acknowledged : DemoLockState.rejected;
  }
  /// Bağlantı koptuğunda durumu 'uncertain' yapar ve tamamlanmayı engeller (fail-closed).
  // bağlantı lost işlemini gerçekleştirir
  void connectionLost() {
    // preflight passed değerini günceller
    _preflightPassed = false;
    // lock değerini günceller
    _lock = DemoLockState.uncertain;
    // completed değerini günceller
    _completed = false;
  }
  /// Durumu sıfırlar.
  // invalidate işlemini gerçekleştirir
  void invalidate() {
    // preflight passed değerini günceller
    _preflightPassed = false;
    // lock değerini günceller
    _lock = DemoLockState.unconfirmed;
    // completed değerini günceller
    _completed = false;
  }
  /// Teslimatı nihai olarak tamamlar; inceleme, sayaç okumaları ve onayların tam olduğunu doğrular.
  // finish işlemini gerçekleştirir
  void finish(
      // Veri alanlarını tanımlar
      {required bool bookingStillConfirmed,
      // Parametre bilgisini zorunlu alır
      required bool inspectionComplete,
      // Parametre bilgisini zorunlu alır
      required bool readingsRecorded,
      // Parametre bilgisini zorunlu alır
      required bool partiesVerified,
      // Parametre bilgisini zorunlu alır
      required bool mutualAcceptance}) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (completed) throw StateError('Bu demo teslim zaten tamamlandı.');
    // Koşul doğruysa bu işlemi çalıştırır
    if (!bookingStillConfirmed ||
        // Önceki ifadeyi tamamlar
        !_preflightPassed ||
        // Önceki ifadeyi tamamlar
        !inspectionComplete ||
        // Önceki ifadeyi tamamlar
        !readingsRecorded ||
        // İlgili işlemin kod bloğunu başlatır
        !mutualAcceptance) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError(
          // İlgili metin değerini belirler
          'Ön kontrol, inceleme, sayaç/enerji ve karşılıklı onay eksik.');
    }
    // Koşul doğruysa bu işlemi çalıştırır
    if (mode == HandoverMode.physical && !partiesVerified) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError(
          // İlgili metin değerini belirler
          'Fiziksel teslimde iki tarafın temsili doğrulaması gerekli.');
    }
    // Koşul doğruysa bu işlemi çalıştırır
    if (mode == HandoverMode.digital && _lock != DemoLockState.acknowledged) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Kilit onayı yok veya belirsiz; demo tamamlanamaz.');
    }
    // completed değerini günceller
    _completed = true;
  }
}

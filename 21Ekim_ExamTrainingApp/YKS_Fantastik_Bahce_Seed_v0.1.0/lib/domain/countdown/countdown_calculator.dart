// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum CountdownState { notSet, running, completed }
// countdown result bilgilerini veya işlemlerini tutan sınıf
class CountdownResult {
  // countdown result nesnesini oluşturur
  const CountdownResult({
    // durum bilgisini zorunlu tutar
    required this.state,
    // days bilgisini isteğe bağlı alır
    this.days = 0,
    // hours bilgisini isteğe bağlı alır
    this.hours = 0,
    // minutes bilgisini isteğe bağlı alır
    this.minutes = 0,
    // seconds bilgisini isteğe bağlı alır
    this.seconds = 0,
  });
  // durum bilgisini tutar
  final CountdownState state;
  // days bilgisini tutar
  final int days;
  // hours bilgisini tutar
  final int hours;
  // minutes bilgisini tutar
  final int minutes;
  // seconds bilgisini tutar
  final int seconds;
  // running bilgisini kontrol eder
  bool get isRunning => state == CountdownState.running;
  // not set bilgisini kontrol eder
  bool get isNotSet => state == CountdownState.notSet;
  // completed bilgisini kontrol eder
  bool get isCompleted => state == CountdownState.completed;
}
// Sabitleri veya ortak işlemleri tutan, nesne oluşturulamayan sınıf
abstract final class CountdownCalculator {
  // calculate işlemini yapar
  static CountdownResult calculate({
    // tarih time bilgisini zorunlu tutar
    required DateTime? targetDate,
    // şimdiki zaman bilgisini zorunlu tutar
    required DateTime now,
  }) {
    // İlgili değer null ise kontrol eder
    if (targetDate == null) {
      // countdown result nesnesini oluşturur
      return const CountdownResult(state: CountdownState.notSet);
    }
    // diff bilgisini hesaplayıp saklar
    final diff = targetDate.difference(now);
    // Belirtilen koşul doğruysa işlemi yapar
    if (diff.isNegative || diff.inSeconds == 0) {
      // countdown result nesnesini oluşturur
      return const CountdownResult(state: CountdownState.completed);
    }
    // toplam seconds bilgisini hesaplayıp saklar
    final totalSeconds = diff.inSeconds;
    // days bilgisini hesaplayıp saklar
    final days = totalSeconds ~/ (24 * 3600);
    // hours bilgisini hesaplayıp saklar
    final hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    // minutes bilgisini hesaplayıp saklar
    final minutes = (totalSeconds % 3600) ~/ 60;
    // seconds bilgisini hesaplayıp saklar
    final seconds = totalSeconds % 60;
    // countdown result nesnesini oluşturur
    return CountdownResult(
      // durum bilgisini belirler
      state: CountdownState.running,
      // days bilgisini belirler
      days: days,
      // hours bilgisini belirler
      hours: hours,
      // minutes bilgisini belirler
      minutes: minutes,
      // seconds bilgisini belirler
      seconds: seconds,
    );
  }
}

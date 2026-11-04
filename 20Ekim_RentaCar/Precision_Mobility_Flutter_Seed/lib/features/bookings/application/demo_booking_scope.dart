// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// rezervasyon defter dosyasını ekler
import '../domain/booking_ledger.dart';
/// Rezervasyon durumu ve işlemlerini yöneten ChangeNotifier sınıfı.
/// UI bileşenlerini değişikliklerden haberdar eder (notifyListeners).
// örnek rezervasyon controller için sınıf oluşturur
class DemoBookingController extends ChangeNotifier {
  /// Rezervasyon kayıt defteri
  // defter değerini tanımlar
  final BookingLedger ledger = BookingLedger();
  /// Test edilebilirlik için saat fonksiyonu (varsayılan: DateTime.now)
  // function işlemini gerçekleştirir
  DateTime Function() clock = DateTime.now;
  /// Belirtilen gün sayısı (1-7 gün) için teklif üretir.
  // fiyat teklifi işlemini gerçekleştirir
  DemoBooking quote(
      // Veri alanlarını tanımlar
      {required String vehicleId,
      // Parametre bilgisini zorunlu alır
      required String vehicleName,
      // Parametre bilgisini zorunlu alır
      required int dailyRate,
      // Parametre bilgisini zorunlu alır
      required int days}) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (days < 1 || days > 7) throw ArgumentError('Demo süre 1–7 gün olmalı.');
    // now değerini belirler
    final now = clock();
    // başlangıç değerini belirler
    final start = DateTime(now.year, now.month, now.day + 1, 10);
    // sonuç değerini belirler
    final result = ledger.quote(
        // araç ID bilgisini belirler
        vehicleId: vehicleId,
        // araç ad bilgisini belirler
        vehicleName: vehicleName,
        // günlük rate bilgisini belirler
        dailyRate: dailyRate,
        // Başlangıç bilgisini belirler
        start: start,
        // Bitiş bilgisini belirler
        end: start.add(Duration(days: days)),
        // now bilgisini belirler
        now: now);
    // Değişiklikleri dinleyen widgetlara bildirir
    notifyListeners();
    // sonuç bilgisini tutar
    return result;
  }
  /// Belirtilen teklifi onaylar ve dinleyicileri uyarır.
  // onay işlemini gerçekleştirir
  DemoBooking confirm(String id) {
    // Hata oluşabilecek işlemleri dener
    try {
      // Hesaplanan sonucu geri döndürür
      return ledger.confirm(id, clock());
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Değişiklikleri dinleyen widgetlara bildirir
      notifyListeners();
    }
  }
  /// Belirtilen rezervasyonu iptal eder ve dinleyicileri uyarır.
  // iptal işlemini gerçekleştirir
  DemoBooking cancel(String id) {
    // Hata oluşabilecek işlemleri dener
    try {
      // Hesaplanan sonucu geri döndürür
      return ledger.cancel(id, clock());
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Değişiklikleri dinleyen widgetlara bildirir
      notifyListeners();
    }
  }
}
/// Widget ağacında DemoBookingController'a erişim sağlayan InheritedNotifier sınıfı.
// örnek rezervasyon scope için sınıf oluşturur
class DemoBookingScope extends InheritedNotifier<DemoBookingController> {
  // örnek rezervasyon scope nesnesi oluşturur
  const DemoBookingScope(
      // Veri alanlarını tanımlar
      {super.key,
      // Parametre bilgisini zorunlu alır
      required DemoBookingController controller,
      // Parametre bilgisini zorunlu alır
      required super.child})
      // Üst sınıfın constructorına değer gönderir
      : super(notifier: controller);
  /// Alt widget'lardan controller'a güvenli erişim metodu
  // of değerini tanımlar
  static DemoBookingController of(BuildContext context) =>
      // İfadeye karşılaştırma koşulu ekler
      context.dependOnInheritedWidgetOfExactType<DemoBookingScope>()!.notifier!;
}

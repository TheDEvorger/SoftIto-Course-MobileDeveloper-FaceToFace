// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// precision tema dosyasını ekler
import '../core/theme/precision_theme.dart';
// ana kabuk dosyasını ekler
import 'shell.dart';
// örnek kontrol depo dosyasını ekler
import '../features/inspections/application/demo_inspection_store.dart';
// kontrol örnek ekran dosyasını ekler
import '../features/inspections/presentation/inspection_demo_screen.dart';
// teslim örnek ekran dosyasını ekler
import '../features/handover/presentation/handover_demo_screen.dart';
// rezervasyon defter dosyasını ekler
import '../features/bookings/domain/booking_ledger.dart';
// örnek rezervasyon scope dosyasını ekler
import '../features/bookings/application/demo_booking_scope.dart';
// rezervasyon örnek ekran dosyasını ekler
import '../features/bookings/presentation/booking_demo_screen.dart';
// örnek araç dosyasını ekler
import '../features/discovery/domain/demo_vehicle.dart';
// precision empty durum dosyasını ekler
import '../shared/widgets/precision_empty_state.dart';
/// Precision Mobility ana uygulama bileşeni.
/// Tema durumu, yönlendirme (routing) ve demo veri kapsamlarını (scope) yönetir.
// precision app ekranının değişen durumunu yönetir
class PrecisionApp extends StatefulWidget {
  // precision app nesnesi oluşturur
  const PrecisionApp({super.key});
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<PrecisionApp> createState() => _PrecisionAppState();
}
// precision app durum ekranının durumunu yöneten sınıf
class _PrecisionAppState extends State<PrecisionApp> {
  // Seçili tema modu (sistem, açık veya koyu).
  // mod değerini belirler
  ThemeMode _mode = ThemeMode.system;
  // Demo rezervasyon ve denetim kontrolcüleri (yalnızca oturum belleğinde saklanır).
  // rezervasyonlar değerini belirler
  final _bookings = DemoBookingController();
  // inspections değerini belirler
  final _inspections = DemoInspectionStore();
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _bookings.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => DemoBookingScope(
      // İlgili controllerı bağlar
      controller: _bookings,
      // İçerikte gösterilecek widgetı belirler
      child: MaterialApp(
        // Başlığı belirler
        title: 'Precision Mobility',
        // Dinamik sayfa yönlendirme kuralları
        // generate route için callback belirler
        onGenerateRoute: (settings) {
          // Teslim veya denetim sayfaları için rezervasyon doğrulama kontrolü
          // Koşul doğruysa bu işlemi çalıştırır
          if ((settings.name == '/handover' ||
                  // settings değerini günceller
                  settings.name == '/inspection') &&
              // İlgili işlemin kod bloğunu başlatır
              settings.arguments is String) {
            // ID değerini belirler
            final id = settings.arguments as String;
            // Rezervasyonun onaylı olup olmadığını denetleyen yardımcı fonksiyon
            // eligible işlemini gerçekleştirir
            bool eligible() {
              // Hata oluşabilecek işlemleri dener
              try {
                // Hesaplanan sonucu geri döndürür
                return _bookings.ledger.get(id, _bookings.clock()).state ==
                    // Rezervasyon durumunu belirler
                    BookingState.confirmed;
              // İşlem hata verirse çalışır
              } on StateError {
                // false bilgisini tutar
                return false;
              }
            }
            // Onaylı rezervasyon için araç denetim (20 açı) ekranı
            // Koşul doğruysa bu işlemi çalıştırır
            if (settings.name == '/inspection' && eligible()) {
              // Sayfa geçişi oluşturur
              return MaterialPageRoute<bool>(
                  // settings bilgisini belirler
                  settings: settings,
                  // İçeriği oluşturan fonksiyonu belirler
                  builder: (_) => InspectionDemoScreen(
                      // taslak bilgisini belirler
                      draft: _inspections.open(id), onSave: _inspections.save));
            }
            // Araç teslim simülasyonu ekranı
            // Koşul doğruysa bu işlemi çalıştırır
            if (settings.name == '/handover') {
              // Sayfa geçişi oluşturur
              return MaterialPageRoute<void>(
                  // settings bilgisini belirler
                  settings: settings,
                  // İçeriği oluşturan fonksiyonu belirler
                  builder: (_) => HandoverDemoScreen(
                      // rezervasyon ID bilgisini belirler
                      bookingId: id,
                      // durum rezervasyon confirmed bilgisini belirler
                      isBookingConfirmed: eligible,
                      // open kontrol bilgisini belirler
                      openInspection: (context) async =>
                          // Sayfa geçişinin sonucunu bekler
                          await Navigator.of(context)
                              // İfadeye karşılaştırma koşulu ekler
                              .pushNamed<bool>('/inspection', arguments: id) ??
                          // Önceki ifadeyi tamamlar
                          false));
            }
          }
          // Araç rezervasyon ekranı yönlendirmesi
          // araç değerini belirler
          final vehicle = settings.arguments is String
              // Koşul doğruysa bu değeri seçer
              ? findDemoVehicle(settings.arguments as String)
              // Koşul yanlışsa bu değeri seçer
              : null;
          // Sayfa geçişi oluşturur
          return MaterialPageRoute<void>(
              // settings bilgisini belirler
              settings: settings,
              // İçeriği oluşturan fonksiyonu belirler
              builder: (_) => settings.name == '/booking' && vehicle != null
                  // Koşul doğruysa bu değeri seçer
                  ? BookingDemoScreen(
                      // araç ID bilgisini belirler
                      vehicleId: vehicle.id,
                      // araç ad bilgisini belirler
                      vehicleName: vehicle.name,
                      // günlük rate bilgisini belirler
                      dailyRate: vehicle.pricePerDay)
                  // scaffold constructorını tanımlar
                  : const Scaffold(
                      // Sayfanın ana içeriğini oluşturur
                      body: PrecisionEmptyState(
                          // Başlığı belirler
                          title: 'Sayfa bulunamadı',
                          // mesaj bilgisini belirler
                          message: 'Geri dönüp bir örnek araç seçin.')));
        },
        // Debug yazısını gösterip göstermeyeceğini belirler
        debugShowCheckedModeBanner: false,
        // Açık tema ayarlarını verir
        theme: PrecisionTheme.light(),
        // Koyu tema ayarlarını verir
        darkTheme: PrecisionTheme.dark(),
        // Aktif tema modunu belirler
        themeMode: _mode,
        // home bilgisini belirler
        home: AppShell(
          // Aktif tema modunu belirler
          themeMode: _mode,
          // tema changed için callback belirler
          onThemeChanged: (mode) => setState(() => _mode = mode),
        ),
      ));
}

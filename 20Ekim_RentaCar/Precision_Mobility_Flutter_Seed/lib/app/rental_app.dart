// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulama dil desteğini ekler
import 'package:flutter_localizations/flutter_localizations.dart';
// studio tema dosyasını ekler
import '../core/theme/studio_theme.dart';
// kiralama controller dosyasını ekler
import '../features/rental/application/rental_controller.dart';
// device kiralama veri deposu dosyasını ekler
import '../features/rental/data/device_rental_repository.dart';
// kiralama araç kataloğu dosyasını ekler
import '../features/rental/data/rental_catalog.dart';
// kiralama depolama dosyasını ekler
import '../features/rental/data/rental_storage.dart';
// kiralama araç dosyasını ekler
import '../features/rental/domain/rental_vehicle.dart';
// kiralama araç kataloğu ekran dosyasını ekler
import '../features/rental/presentation/rental_catalog_screen.dart';
// kiralama detay ekran dosyasını ekler
import '../features/rental/presentation/rental_detail_screen.dart';
// kiralama planlar ekran dosyasını ekler
import '../features/rental/presentation/rental_plans_screen.dart';
// kiralama profile ekran dosyasını ekler
import '../features/rental/presentation/rental_profile_screen.dart';
// kiralama ana kabuk dosyasını ekler
import 'rental_shell.dart';
// kiralama app ekranının değişen durumunu yönetir
class RentalApp extends StatefulWidget {
  // kiralama app nesnesi oluşturur
  const RentalApp({super.key, this.repository});
  // veri deposu bilgisini tutar
  final DeviceRentalRepository? repository;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<RentalApp> createState() => _RentalAppState();
}
// kiralama app durum ekranının durumunu yöneten sınıf
class _RentalAppState extends State<RentalApp> {
  // controller bilgisini tutar
  late final RentalController _controller;
  // indeks değerini belirler
  int _index = 0;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // controller değerini günceller
    _controller = RentalController(widget.repository ??
        // device kiralama veri deposu nesnesi oluşturur
        DeviceRentalRepository(DeviceRentalStorage(), rentalCatalog))
      // Aynı nesne üzerinde ek işlem yapar
      ..load();
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _controller.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // open işlemini asenkron yürütür
  Future<void> _open(
          // Sonraki ifadeyi sonuç olarak döndürür
          BuildContext context, RentalVehicle vehicle, DateTimeRange? dates) =>
      // Sayfa açma veya kapatma işlemini yapar
      Navigator.of(context).push<void>(MaterialPageRoute(
          // İçeriği oluşturan fonksiyonu belirler
          builder: (context) => RentalDetailScreen(
              // İlgili controllerı bağlar
              controller: _controller,
              // Araç bilgisini gönderir
              vehicle: vehicle,
              // İlk tarih aralığını belirler
              initialDates: dates,
              // rezervasyonlar için callback belirler
              onReservations: () {
                // Sayfa açma veya kapatma işlemini yapar
                Navigator.of(context).pop();
                // Değişen verileri ekrana bildirir
                setState(() => _index = 2);
              })));
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
      // listenable bilgisini belirler
      listenable: _controller,
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, _) => MaterialApp(
            // Başlığı belirler
            title: 'Precision · Araç Kiralama',
            // Debug yazısını gösterip göstermeyeceğini belirler
            debugShowCheckedModeBanner: false,
            // Açık tema ayarlarını verir
            theme: StudioTheme.light(fontFamily: 'PrecisionRoboto'),
            // Koyu tema ayarlarını verir
            darkTheme: StudioTheme.dark(fontFamily: 'PrecisionRoboto'),
            // Aktif tema modunu belirler
            themeMode: switch (_controller.repository.data.theme) {
              // Seçeneğe karşılık gelen değeri döndürür
              'dark' => ThemeMode.dark,
              // Seçeneğe karşılık gelen değeri döndürür
              'light' => ThemeMode.light,
              // değer değerini günceller
              _ => ThemeMode.system
            },
            // Uygulama dilini belirler
            locale: const Locale('tr', 'TR'),
            // Desteklenen dilleri listeler
            supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
            // Çeviri kaynaklarını ekler
            localizationsDelegates: const [
              // Flutterın yerelleştirme desteğini ekler
              GlobalMaterialLocalizations.delegate,
              // Flutterın yerelleştirme desteğini ekler
              GlobalWidgetsLocalizations.delegate,
              // Flutterın yerelleştirme desteğini ekler
              GlobalCupertinoLocalizations.delegate
            ],
            // home bilgisini belirler
            home: Builder(
                // İçeriği oluşturan fonksiyonu belirler
                builder: (context) => RentalShell(
                        // Öğenin indeksini belirler
                        index: _index,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: (index) => setState(() => _index = index),
                        // yükleme bilgisini belirler
                        loading: _controller.loading,
                        // hata bilgisini belirler
                        error: _controller.error,
                        // Yeniden deneme callbackini gönderir
                        onRetry: _controller.load,
                        // Ekran listesini gönderir
                        pages: [
                          // kiralama araç kataloğu ekran nesnesi oluşturur
                          RentalCatalogScreen(
                              // İlgili controllerı bağlar
                              controller: _controller,
                              // open için callback belirler
                              onOpen: (v, dates) => _open(context, v, dates)),
                          // kiralama araç kataloğu ekran nesnesi oluşturur
                          RentalCatalogScreen(
                              // İlgili controllerı bağlar
                              controller: _controller,
                              // favoriler only bilgisini belirler
                              favoritesOnly: true,
                              // open için callback belirler
                              onOpen: (v, dates) => _open(context, v, dates)),
                          // kiralama planlar ekran nesnesi oluşturur
                          RentalPlansScreen(
                              // İlgili controllerı bağlar
                              controller: _controller,
                              // discover için callback belirler
                              onDiscover: () => setState(() => _index = 0),
                              // open için callback belirler
                              onOpen: (v) => _open(context, v, null)),
                          // kiralama profile ekran nesnesi oluşturur
                          RentalProfileScreen(
                              // İlgili controllerı bağlar
                              controller: _controller,
                              // planlar için callback belirler
                              onPlans: () => setState(() => _index = 2),
                              // favoriler için callback belirler
                              onFavorites: () => setState(() => _index = 1)),
                        ])),
          ));
}

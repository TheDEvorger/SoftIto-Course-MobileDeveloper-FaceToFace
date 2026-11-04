// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulama dil desteğini ekler
import 'package:flutter_localizations/flutter_localizations.dart';
// API istemci dosyasını ekler
import '../core/network/api_client.dart';
// studio tema dosyasını ekler
import '../core/theme/studio_theme.dart';
// rezervasyon controller dosyasını ekler
import '../features/bookings/application/reservation_controller.dart';
// rezervasyonlar ekran dosyasını ekler
import '../features/bookings/presentation/reservations_screen.dart';
// reserve araç ekran dosyasını ekler
import '../features/bookings/presentation/reserve_vehicle_screen.dart';
// araç kataloğu controller dosyasını ekler
import '../features/discovery/application/catalog_controller.dart';
// araç dosyasını ekler
import '../features/discovery/domain/vehicle.dart';
// araç kataloğu ekran dosyasını ekler
import '../features/discovery/presentation/catalog_screen.dart';
// araç envanteri ekran dosyasını ekler
import '../features/garage/presentation/inventory_screen.dart';
// araç editor ekran dosyasını ekler
import '../features/garage/presentation/vehicle_editor_screen.dart';
// araç işlemler ekran dosyasını ekler
import '../features/garage/presentation/vehicle_operations_screen.dart';
// çalışma alanı ekran dosyasını ekler
import '../features/profile/presentation/workspace_screen.dart';
// mobility ana kabuk dosyasını ekler
import 'mobility_shell.dart';
// mobility app ekranının değişen durumunu yönetir
class MobilityApp extends StatefulWidget {
  // mobility app nesnesi oluşturur
  const MobilityApp(
      // Veri alanlarını tanımlar
      {super.key,
      // API parametresini alır
      this.api,
      // this değerini günceller
      this.initialExamples = const bool.fromEnvironment('PRECISION_EXAMPLES',
          // varsayılan değer bilgisini belirler
          defaultValue: true)});
  // API bilgisini tutar
  final ApiClient? api;
  // başlangıç örnekler bilgisini tutar
  final bool initialExamples;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<MobilityApp> createState() => _MobilityAppState();
}
// mobility app durum ekranının durumunu yöneten sınıf
class _MobilityAppState extends State<MobilityApp> {
  // API bilgisini tutar
  late final ApiClient _api;
  // araç envanteri bilgisini tutar
  late final CatalogController _catalog, _inventory;
  // rezervasyonlar bilgisini tutar
  late final ReservationController _reservations;
  // tema değerini belirler
  ThemeMode _theme = ThemeMode.system;
  // indeks değerini belirler
  int _index = 0;
  // geçiş değerini belirler
  bool _switching = false;
  // oturum hata bilgisini tutar
  String? _sessionError;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // API değerini günceller
    _api = widget.api ??
        // API istemci nesnesi oluşturur
        ApiClient(
            // API temel adresini belirler
            baseUri: Uri.parse(const String.fromEnvironment('PRECISION_API_URL',
                // varsayılan değer bilgisini belirler
                defaultValue: 'http://127.0.0.1:8765/api/v1/')));
    // araç kataloğu değerini günceller
    _catalog = CatalogController(_api);
    // araç envanteri değerini günceller
    _inventory = CatalogController(_api);
    // rezervasyonlar değerini günceller
    _reservations = ReservationController(_api);
    // Koşul doğruysa bu işlemi çalıştırır
    if (widget.initialExamples) {
      // İlgili metodu çalıştırır
      _openExamples();
    // Önceki koşul sağlanmazsa bu bölümü çalıştırır
    } else {
      // Verileri yükler
      _catalog.load();
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _catalog.dispose();
    // Kullanılan controller veya kaynağı temizler
    _inventory.dispose();
    // Kullanılan controller veya kaynağı temizler
    _reservations.dispose();
    // Değer null ise koşulu çalıştırır
    if (widget.api == null) _api.close();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // oturum changed işlemini gerçekleştirir
  void _sessionChanged() {
    // Verileri temizler
    _catalog.clear();
    // Verileri temizler
    _inventory.clear();
    // Verileri temizler
    _reservations.clear();
    // Verileri yükler
    _catalog.load();
    // Oturum doğrulandıysa işlemi yapar
    if (_api.authenticated) {
      // Verileri yükler
      _inventory.load(workspace: true);
      // Verileri yükler
      _reservations.load();
    }
    // Değişen verileri ekrana bildirir
    setState(() {});
  }
  // open örnekler işlemini asenkron yürütür
  Future<void> _openExamples() async {
    // Değişen verileri ekrana bildirir
    setState(() {
      // geçiş değerini günceller
      _switching = true;
      // oturum hata değerini günceller
      _sessionError = null;
    });
    // Hata oluşabilecek işlemleri dener
    try {
      // Oturum açma işleminin bitmesini bekler
      await _api.openExamples();
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) _sessionChanged();
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _sessionError = error.toString());
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _switching = false);
    }
  }
  // düzenleme işlemini asenkron yürütür
  Future<void> _edit(BuildContext context, Vehicle? vehicle) async {
    // saved değerini belirler
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
        // İçeriği oluşturan fonksiyonu belirler
        builder: (_) =>
            // araç editor ekran nesnesi oluşturur
            VehicleEditorScreen(controller: _inventory, vehicle: vehicle)));
    // Widget hâlâ ekrandaysa işlemi sürdürür
    if (saved == true && mounted) {
      // Verilerin yüklenmesini bekler
      await Future.wait([_inventory.load(workspace: true), _catalog.refresh()]);
    }
  }
  // open işlemini asenkron yürütür
  Future<void> _open(
      // İlgili işlemin kod bloğunu başlatır
      BuildContext context, Vehicle v, DateTimeRange? dates) async {
    // Sayfa geçişinin sonucunu bekler
    await Navigator.of(context).push<void>(MaterialPageRoute(
        // İçeriği oluşturan fonksiyonu belirler
        builder: (_) => ReserveVehicleScreen(
            // Araç bilgisini gönderir
            vehicle: v,
            // İlgili controllerı bağlar
            controller: _reservations,
            // Bağlantı durumunu gönderir
            connected: _api.authenticated,
            // İlk tarih aralığını belirler
            initialDates: dates,
            // connect için callback belirler
            onConnect: () => setState(() => _index = 3),
            // rezervasyonlar için callback belirler
            onReservations: () => setState(() => _index = 2))));
    // Widget hâlâ ekrandaysa işlemi sürdürür
    if (mounted) _catalog.refresh();
  }
  // manage işlemini asenkron yürütür
  Future<void> _manage(BuildContext context, Vehicle vehicle) async {
    // Sayfa geçişinin sonucunu bekler
    await Navigator.of(context).push<void>(MaterialPageRoute(
        // İçeriği oluşturan fonksiyonu belirler
        builder: (_) => VehicleOperationsScreen(api: _api, vehicle: vehicle)));
    // Widget hâlâ ekrandaysa işlemi sürdürür
    if (mounted) {
      // Verilerin yüklenmesini bekler
      await Future.wait([_inventory.load(workspace: true), _catalog.refresh()]);
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => MaterialApp(
      // Başlığı belirler
      title: 'Precision Mobility',
      // Debug yazısını gösterip göstermeyeceğini belirler
      debugShowCheckedModeBanner: false,
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
      // Açık tema ayarlarını verir
      theme: StudioTheme.light(),
      // Koyu tema ayarlarını verir
      darkTheme: StudioTheme.dark(),
      // Aktif tema modunu belirler
      themeMode: _theme,
      // home bilgisini belirler
      home: Builder(
          // İçeriği oluşturan fonksiyonu belirler
          builder: (context) => MobilityShell(
                  // Öğenin indeksini belirler
                  index: _index,
                  // Bağlantı durumunu gönderir
                  connected: _api.authenticated,
                  // Örnek veri durumunu belirler
                  examples: _api.examples,
                  // Geçiş durumunu gönderir
                  switching: _switching,
                  // Bağlantı hatasını gönderir
                  connectionError: _sessionError,
                  // Yeniden deneme callbackini gönderir
                  onRetry: _openExamples,
                  // Seçim değişince çalışacak fonksiyonu belirler
                  onSelected: (i) => setState(() => _index = i),
                  // Ekran listesini gönderir
                  pages: [
                    // araç kataloğu ekran nesnesi oluşturur
                    CatalogScreen(
                        // İlgili controllerı bağlar
                        controller: _catalog,
                        // open için callback belirler
                        onOpen: (v, dates) => _open(context, v, dates),
                        // ekleme araç için callback belirler
                        onAddVehicle: () => _api.authenticated
                            // Koşul doğruysa bu değeri seçer
                            ? _edit(context, null)
                            // Koşul yanlışsa bu değeri seçer
                            : setState(() => _index = 3)),
                    // araç envanteri ekran nesnesi oluşturur
                    InventoryScreen(
                        // İlgili controllerı bağlar
                        controller: _inventory,
                        // Bağlantı durumunu gönderir
                        connected: _api.authenticated,
                        // connect için callback belirler
                        onConnect: () => setState(() => _index = 3),
                        // manage için callback belirler
                        onManage: (v) => _manage(context, v),
                        // düzenleme için callback belirler
                        onEdit: (v) => _edit(context, v)),
                    // rezervasyonlar ekran nesnesi oluşturur
                    ReservationsScreen(
                        // İlgili controllerı bağlar
                        controller: _reservations,
                        // Bağlantı durumunu gönderir
                        connected: _api.authenticated,
                        // connect için callback belirler
                        onConnect: () => setState(() => _index = 3),
                        // discover için callback belirler
                        onDiscover: () => setState(() => _index = 0),
                        // Değer değişince çalışacak fonksiyonu belirler
                        onChanged: _catalog.refresh),
                    // çalışma alanı ekran nesnesi oluşturur
                    WorkspaceScreen(
                        // API bilgisini belirler
                        api: _api,
                        // örnekler için callback belirler
                        onExamples: _openExamples,
                        // araç envanteri bilgisini belirler
                        inventory: _inventory,
                        // Rezervasyonları gönderir
                        reservations: _reservations,
                        // oturum changed için callback belirler
                        onSessionChanged: _sessionChanged,
                        // Aktif tema modunu belirler
                        themeMode: _theme,
                        // tema changed için callback belirler
                        onThemeChanged: (mode) =>
                            // Değişen verileri ekrana bildirir
                            setState(() => _theme = mode)),
                  ])));
}

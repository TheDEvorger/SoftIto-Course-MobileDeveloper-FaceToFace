// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../data/demo/demo_clinic_store.dart';
// collection durum dosyasını projeye ekler
import '../../data/models/collection_status.dart';
// dashboard view dosyasını projeye ekler
import '../../features/dashboard/views/dashboard_view.dart';
// hasta intake view dosyasını projeye ekler
import '../../features/patient_intake/views/patient_intake_view.dart';
// sıra controller dosyasını projeye ekler
import '../../features/queue_management/controllers/queue_controller.dart';
// ziyaret işlemler dosyasını projeye ekler
import '../../features/queue_management/controllers/visit_actions.dart';
// sıra view dosyasını projeye ekler
import '../../features/queue_management/views/queue_view.dart';
// sample tracking view dosyasını projeye ekler
import '../../features/sample_tracking/views/sample_tracking_view.dart';
// settings view dosyasını projeye ekler
import '../../features/settings/views/settings_view.dart';
// tema controller dosyasını projeye ekler
import '../theme/theme_controller.dart';
// Uygulamanın ana widget sınıfı
class AppShell extends StatefulWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const AppShell({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // tema controllerı bilgisini zorunlu tutar
    required this.themeController,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // tema controllerı bilgisini tutar
  final ThemeController themeController;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın State sınıfını oluşturur
  State<AppShell> createState() => _AppShellState();
}
// Widgetın değişen durumunu yöneten State sınıfı
class _AppShellState extends State<AppShell> {
  // aktif sekme değerini tanımlar
  int _currentIndex = 0;
  // işlemler bilgisini tutar
  late final VisitActions _actions;
  // sıra controller bilgisini tutar
  late final QueueController _queueController;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın ilgili işlemini çağırır
    super.initState();
    // VisitActions nesnesini oluşturur veya kullanır
    _actions = VisitActions(widget.store);
    // QueueController nesnesini oluşturur
    _queueController = QueueController();
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    _queueController.dispose();
    // Üst sınıfın ilgili işlemini çağırır
    super.dispose();
  }
  // navigate to sıra işlemini çalıştırır
  void _navigateToQueue(CollectionStatus? status) {
    // Seçilen filtreyi uygular
    _queueController.setFilter(status);
    // State değişikliğini ekrana bildirir
    setState(() => _currentIndex = 1);
  }
  // navigate to hasta intake işlemini çalıştırır
  void _navigateToPatientIntake() {
    // State değişikliğini ekrana bildirir
    setState(() => _currentIndex = 2);
  }
  // toggle tema işlemini çalıştırır
  void _toggleTheme() {
    // güncel bilgisini ilgili kaynaktan alır
    final ThemeMode current = widget.themeController.mode.value;
    // sonraki değerini tanımlar
    final ThemeMode next = switch (current) {
      // tema mod bilgisini günceller
      ThemeMode.system => ThemeMode.light,
      // tema mod bilgisini günceller
      ThemeMode.light => ThemeMode.dark,
      // tema mod bilgisini günceller
      ThemeMode.dark => ThemeMode.system,
    };
    // Seçilen tema modunu ayarlar
    widget.themeController.setMode(next);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // renk şeması değerini tanımlar
    final ColorScheme scheme = theme.colorScheme;
    // sayfalar listesini oluşturur
    final List<Widget> pages = <Widget>[
      // DashboardView ekranını oluşturur
      DashboardView(
        // Veri deposunu widgeta gönderir
        store: widget.store,
        // İşlem fonksiyonlarını widgeta gönderir
        actions: _actions,
        // yeni hasta işlemi fonksiyonunu bağlar
        onNewPatient: _navigateToPatientIntake,
        // sırayı açma işlemi fonksiyonunu bağlar
        onOpenQueue: _navigateToQueue,
      ),
      // QueueView ekranını oluşturur
      QueueView(
        // Veri deposunu widgeta gönderir
        store: widget.store,
        // İlgili controllerı widgeta gönderir
        controller: _queueController,
        // İşlem fonksiyonlarını widgeta gönderir
        actions: _actions,
      ),
      // PatientIntakeView ekranını oluşturur
      PatientIntakeView(
        // Veri deposunu widgeta gönderir
        store: widget.store,
        // oluşturma sonrası işlem fonksiyonunu bağlar
        onCreated: (visit) {
          // İlgili alan veya listeyi temizler
          _queueController.clear();
          // State değişikliğini ekrana bildirir
          setState(() => _currentIndex = 1);
        },
      ),
      // SampleTrackingView ekranını oluşturur
      SampleTrackingView(
        // Veri deposunu widgeta gönderir
        store: widget.store,
        // İşlem fonksiyonlarını widgeta gönderir
        actions: _actions,
      ),
      // SettingsView ekranını oluşturur
      SettingsView(
        // Veri deposunu widgeta gönderir
        store: widget.store,
        // tema controllerı bilgisini belirler
        themeController: widget.themeController,
      ),
    ];
    // layout oluşturma fonksiyonu değerini hesaplar veya döndürür
    return LayoutBuilder(
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, BoxConstraints constraints) {
        // geniş ekran kontrolü durumunu kontrol eder
        final bool isWide = constraints.maxWidth >= 840;
        // app bar değerini tanımlar
        final PreferredSizeWidget appBar = AppBar(
          // başlık yatay boşluk bilgisini belirler
          titleSpacing: 16,
          // Başlığını belirler
          title: Row(
            // Kaplayacağı ana eksen alanını belirler
            mainAxisSize: MainAxisSize.min,
            // Alt widgetları listeler
            children: <Widget>[
              // Görünüm ve yerleşim için kutu oluşturur
              Container(
                // İç boşlukları belirler
                padding: const EdgeInsets.all(6),
                // Görünüm ayarlarını oluşturur
                decoration: BoxDecoration(
                  // Rengini belirler
                  color: scheme.primary.withValues(alpha: 0.12),
                  // Köşeleri yuvarlar
                  borderRadius: BorderRadius.circular(10),
                ),
                // İçeride gösterilecek widgetı belirler
                child: Icon(
                  // bloodtype rounded değerini listeye ekler
                  Icons.bloodtype_rounded,
                  // Rengini belirler
                  color: scheme.primary,
                  // boyut bilgisini belirler
                  size: 22,
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(width: 8),
              // Kalan alana göre esnek yerleşim sağlar
              Flexible(
                // İçeride gösterilecek widgetı belirler
                child: Text(
                  // Bu metin değerini kullanır
                  'VenaFlow',
                  // Uzun metnin taşmasını önler
                  overflow: TextOverflow.ellipsis,
                  // style bilgisini belirler
                  style: theme.textTheme.titleMedium?.copyWith(
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w800,
                    // Harfler arasındaki boşluğu ayarlar
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(width: 8),
              // Görünüm ve yerleşim için kutu oluşturur
              Container(
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // Görünüm ayarlarını oluşturur
                decoration: BoxDecoration(
                  // Rengini belirler
                  color: scheme.secondaryContainer.withValues(alpha: 0.7),
                  // Köşeleri yuvarlar
                  borderRadius: BorderRadius.circular(6),
                ),
                // İçeride gösterilecek widgetı belirler
                child: Text(
                  // Bu metin değerini kullanır
                  'DEMO',
                  // style bilgisini belirler
                  style: theme.textTheme.labelSmall?.copyWith(
                    // Rengini belirler
                    color: scheme.onSecondaryContainer,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w800,
                    // Yazı boyutunu belirler
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          // İşlem fonksiyonlarını widgeta gönderir
          actions: <Widget>[
            // Değer değişimlerini dinleyerek arayüzü günceller
            ValueListenableBuilder<bool>(
              // Değişimi takip edilecek değeri dinler
              valueListenable: widget.store.canUndo,
              // Güncel verilere göre arayüzü oluşturur
              builder: (BuildContext context, bool canUndo, _) {
                // Koşul sağlanırsa ilgili işlemi yapar
                if (!canUndo) return const SizedBox.shrink();
                // simge button değerini hesaplar veya döndürür
                return IconButton(
                  // Butonun açıklamasını belirler
                  tooltip: 'Son İşlemi Geri Al',
                  // Gösterilecek simgeyi belirler
                  icon: const Icon(Icons.undo_rounded),
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: () {
                    // Koşul sağlanırsa ilgili işlemi yapar
                    if (widget.store.undo()) {
                      // İlgili nesne üzerinden metodu çağırır
                      ScaffoldMessenger.of(context)
                        // Aynı nesne üzerinde işlemi sürdürür
                        ..hideCurrentSnackBar()
                        // Ekranda kısa bilgilendirme mesajı gösterir
                        ..showSnackBar(
                          // Constructor, yeni nesnenin bilgilerini alır
                          const SnackBar(
                            // içerik yazısını gösterir
                            content: Text('Son işlem geri alındı.'),
                            // İşlemin süresini belirler
                            duration: Duration(seconds: 2),
                          ),
                        );
                    }
                  },
                );
              },
            ),
            // Değer değişimlerini dinleyerek arayüzü günceller
            ValueListenableBuilder<ThemeMode>(
              // Değişimi takip edilecek değeri dinler
              valueListenable: widget.themeController.mode,
              // Güncel verilere göre arayüzü oluşturur
              builder: (BuildContext context, ThemeMode mode, _) {
                // simge button değerini hesaplar veya döndürür
                return IconButton(
                  // Butonun açıklamasını belirler
                  tooltip: 'Tema Değiştir (${mode.label})',
                  // Gösterilecek simgeyi belirler
                  icon: Icon(mode.icon),
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: _toggleTheme,
                );
              },
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 8),
          ],
        );
        // Geniş ekranda farklı yerleşim kullanır
        if (isWide) {
          // scaffold değerini hesaplar veya döndürür
          return Scaffold(
            // app bar bilgisini belirler
            appBar: appBar,
            // body bilgisini belirler
            body: Row(
              // Alt widgetları listeler
              children: <Widget>[
                // Yan gezinme menüsünü oluşturur
                NavigationRail(
                  // Aktif sekmenin indeksini belirler
                  selectedIndex: _currentIndex,
                  // destination seçili işlemi için callback gönderir
                  onDestinationSelected: (int index) =>
                      // State değişikliğini ekrana bildirir
                      setState(() => _currentIndex = index),
                  // etiket type bilgisini belirler
                  labelType: NavigationRailLabelType.all,
                  // Soldaki simge veya widgetı belirler
                  leading: Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.only(bottom: 12),
                    // İçeride gösterilecek widgetı belirler
                    child: FloatingActionButton.small(
                      // hero tag bilgisini belirler
                      heroTag: 'quick_intake_fab',
                      // Butonun açıklamasını belirler
                      tooltip: 'Yeni Hasta Kabulü',
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _navigateToPatientIntake,
                      // İçeride gösterilecek widgetı belirler
                      child: const Icon(Icons.add_rounded),
                    ),
                  ),
                  // destinations bilgisini belirler
                  destinations: const <NavigationRailDestination>[
                    // Yan menü sekmesi oluşturur
                    NavigationRailDestination(
                      // Gösterilecek simgeyi belirler
                      icon: Icon(Icons.dashboard_outlined),
                      // Seçili durumdaki simgeyi belirler
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      // Gösterilecek etiketi belirler
                      label: Text('Dashboard'),
                    ),
                    // Yan menü sekmesi oluşturur
                    NavigationRailDestination(
                      // Gösterilecek simgeyi belirler
                      icon: Icon(Icons.format_list_numbered_rounded),
                      // Seçili durumdaki simgeyi belirler
                      selectedIcon: Icon(Icons.format_list_numbered_rtl_rounded),
                      // Gösterilecek etiketi belirler
                      label: Text('Sıra'),
                    ),
                    // Yan menü sekmesi oluşturur
                    NavigationRailDestination(
                      // Gösterilecek simgeyi belirler
                      icon: Icon(Icons.person_add_outlined),
                      // Seçili durumdaki simgeyi belirler
                      selectedIcon: Icon(Icons.person_add_rounded),
                      // Gösterilecek etiketi belirler
                      label: Text('Kabul'),
                    ),
                    // Yan menü sekmesi oluşturur
                    NavigationRailDestination(
                      // Gösterilecek simgeyi belirler
                      icon: Icon(Icons.science_outlined),
                      // Seçili durumdaki simgeyi belirler
                      selectedIcon: Icon(Icons.science_rounded),
                      // Gösterilecek etiketi belirler
                      label: Text('Numuneler'),
                    ),
                    // Yan menü sekmesi oluşturur
                    NavigationRailDestination(
                      // Gösterilecek simgeyi belirler
                      icon: Icon(Icons.settings_outlined),
                      // Seçili durumdaki simgeyi belirler
                      selectedIcon: Icon(Icons.settings_rounded),
                      // Gösterilecek etiketi belirler
                      label: Text('Ayarlar'),
                    ),
                  ],
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const VerticalDivider(thickness: 1, width: 1),
                // Kalan alanı doldurmasını sağlar
                Expanded(
                  // İçeride gösterilecek widgetı belirler
                  child: IndexedStack(
                    // indeks bilgisini belirler
                    index: _currentIndex,
                    // Alt widgetları listeler
                    children: pages,
                  ),
                ),
              ],
            ),
          );
        }
        // scaffold değerini hesaplar veya döndürür
        return Scaffold(
          // app bar bilgisini belirler
          appBar: _currentIndex == 2 ? null : appBar,
          // body bilgisini belirler
          body: IndexedStack(
            // indeks bilgisini belirler
            index: _currentIndex,
            // Alt widgetları listeler
            children: pages,
          ),
          // bottom navigation bar bilgisini belirler
          bottomNavigationBar: NavigationBar(
            // Aktif sekmenin indeksini belirler
            selectedIndex: _currentIndex,
            // destination seçili işlemi için callback gönderir
            onDestinationSelected: (int index) =>
                // State değişikliğini ekrana bildirir
                setState(() => _currentIndex = index),
            // destinations bilgisini belirler
            destinations: const <NavigationDestination>[
              // Alt menü sekmesi oluşturur
              NavigationDestination(
                // Gösterilecek simgeyi belirler
                icon: Icon(Icons.dashboard_outlined),
                // Seçili durumdaki simgeyi belirler
                selectedIcon: Icon(Icons.dashboard_rounded),
                // Gösterilecek etiketi belirler
                label: 'Dashboard',
              ),
              // Alt menü sekmesi oluşturur
              NavigationDestination(
                // Gösterilecek simgeyi belirler
                icon: Icon(Icons.format_list_numbered_rounded),
                // Seçili durumdaki simgeyi belirler
                selectedIcon: Icon(Icons.format_list_numbered_rtl_rounded),
                // Gösterilecek etiketi belirler
                label: 'Sıra',
              ),
              // Alt menü sekmesi oluşturur
              NavigationDestination(
                // Gösterilecek simgeyi belirler
                icon: Icon(Icons.person_add_outlined),
                // Seçili durumdaki simgeyi belirler
                selectedIcon: Icon(Icons.person_add_rounded),
                // Gösterilecek etiketi belirler
                label: 'Kabul',
              ),
              // Alt menü sekmesi oluşturur
              NavigationDestination(
                // Gösterilecek simgeyi belirler
                icon: Icon(Icons.science_outlined),
                // Seçili durumdaki simgeyi belirler
                selectedIcon: Icon(Icons.science_rounded),
                // Gösterilecek etiketi belirler
                label: 'Numune',
              ),
              // Alt menü sekmesi oluşturur
              NavigationDestination(
                // Gösterilecek simgeyi belirler
                icon: Icon(Icons.settings_outlined),
                // Seçili durumdaki simgeyi belirler
                selectedIcon: Icon(Icons.settings_rounded),
                // Gösterilecek etiketi belirler
                label: 'Ayarlar',
              ),
            ],
          ),
        );
      },
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// discovery ekran dosyasını ekler
import '../features/discovery/presentation/discovery_screen.dart';
// filo çalışma alanı ekran dosyasını ekler
import '../features/fleet/presentation/fleet_workspace_screen.dart';
// rezervasyonlar ekran dosyasını ekler
import '../features/bookings/presentation/bookings_screen.dart';
// garage ekran dosyasını ekler
import '../features/garage/presentation/garage_screen.dart';
// profile ekran dosyasını ekler
import '../features/profile/presentation/profile_screen.dart';
/// Uygulama kabuğu (AppShell).
/// Ekran genişliğine göre uyum sağlayan (adaptive) gezinme çubuğu (Bottom Navigation veya NavigationRail) sunar.
// app ana kabuk ekranının değişen durumunu yönetir
class AppShell extends StatefulWidget {
  // app ana kabuk nesnesi oluşturur
  const AppShell(
      // Veri alanlarını tanımlar
      {super.key, required this.themeMode, required this.onThemeChanged});
  /// Mevcut tema modu
  // tema mod bilgisini tutar
  final ThemeMode themeMode;
  /// Tema modu değiştiğinde çağrılan geri çağırma (callback)
  // olay tema changed bilgisini tutar
  final ValueChanged<ThemeMode> onThemeChanged;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<AppShell> createState() => _AppShellState();
}
// app ana kabuk durum ekranının durumunu yöneten sınıf
class _AppShellState extends State<AppShell> {
  // Seçili sekme dizini (0: Keşfet, 1: Araçlar/Filo, 2: Sürüşlerim, 3: Hesabım)
  // indeks değerini belirler
  int _index = 0;
  // Mobil alt gezinme çubuğu hedefleri
  // destinations değerini tanımlar
  static const destinations = [
    // navigation destination nesnesi oluşturur
    NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Keşfet'),
    // navigation destination nesnesi oluşturur
    NavigationDestination(
        // Butonun veya öğenin simgesini belirler
        icon: Icon(Icons.directions_car_outlined), label: 'Araçlar'),
    // navigation destination nesnesi oluşturur
    NavigationDestination(
        // Butonun veya öğenin simgesini belirler
        icon: Icon(Icons.event_note_outlined), label: 'Sürüşlerim'),
    // navigation destination nesnesi oluşturur
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'Hesabım'),
  ];
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sekmelerde görüntülenecek ekranlar
    // sayfalar değerini belirler
    final pages = <Widget>[
      // discovery ekran nesnesi oluşturur
      const DiscoveryScreen(),
      // garage ekran nesnesi oluşturur
      const GarageScreen(workspace: FleetWorkspaceScreen()),
      // rezervasyonlar ekran nesnesi oluşturur
      const BookingsScreen(),
      // profile ekran nesnesi oluşturur
      ProfileScreen(
          // Aktif tema modunu belirler
          themeMode: widget.themeMode, onThemeChanged: widget.onThemeChanged),
    ];
    // Alan genişliğine göre içeriği düzenler
    return LayoutBuilder(builder: (context, constraints) {
      // 840px ve üzeri ekranlar geniş ekran (tablet/desktop) kabul edilir
      // wide değerini belirler
      final wide = constraints.maxWidth >= 840;
      // Geçerli sekmeyi bellek ve durum kaybı olmadan göstermek için IndexedStack kullanılır
      // gövde değerini belirler
      final body = IndexedStack(index: _index, children: pages);
      // Sayfanın temel yapısını oluşturur
      return Scaffold(
        // Sayfanın üst menüsünü oluşturur
        appBar: AppBar(
          // Başlığı belirler
          title: const Text('PRECISION / MOBILITY',
              // Görünüm stilini belirler
              style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 15,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w700,
                  // Harfler arasındaki boşluğu ayarlar
                  letterSpacing: 1.6)),
          // actions bilgisini belirler
          actions: const [
            // İçerik etrafına boşluk bırakır
            Padding(
                // İç boşlukları ayarlar
                padding: EdgeInsets.symmetric(horizontal: 16),
                // İçerikte gösterilecek widgetı belirler
                child: Center(
                    // İçerikte gösterilecek widgetı belirler
                    child: Text('DEMO', style: TextStyle(letterSpacing: 2))))
          ],
        ),
        // Geniş ekranda yan menü (NavigationRail), dar ekranda doğrudan sayfa gövdesi
        // Sayfanın ana içeriğini oluşturur
        body: wide
            // Koşul doğruysa bu değeri seçer
            ? Row(children: [
                // navigation rail nesnesi oluşturur
                NavigationRail(
                  // extended bilgisini belirler
                  extended: constraints.maxWidth >= 1120,
                  // Seçili sekmenin indeksini belirler
                  selectedIndex: _index,
                  // Sekme seçilince çalışacak fonksiyonu belirler
                  onDestinationSelected: (value) =>
                      // Değişen verileri ekrana bildirir
                      setState(() => _index = value),
                  // etiket type bilgisini belirler
                  labelType: constraints.maxWidth >= 1120
                      // Koşul doğruysa bu değeri seçer
                      ? NavigationRailLabelType.none
                      // Koşul yanlışsa bu değeri seçer
                      : NavigationRailLabelType.all,
                  // destinations bilgisini belirler
                  destinations: const [
                    // navigation rail destination nesnesi oluşturur
                    NavigationRailDestination(
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.explore_outlined),
                        // Görünen etiketi belirler
                        label: Text('Keşfet')),
                    // navigation rail destination nesnesi oluşturur
                    NavigationRailDestination(
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.directions_car_outlined),
                        // Görünen etiketi belirler
                        label: Text('Araçlar')),
                    // navigation rail destination nesnesi oluşturur
                    NavigationRailDestination(
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.event_note_outlined),
                        // Görünen etiketi belirler
                        label: Text('Sürüşlerim')),
                    // navigation rail destination nesnesi oluşturur
                    NavigationRailDestination(
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.person_outline),
                        // Görünen etiketi belirler
                        label: Text('Hesabım')),
                  ],
                ),
                // vertical divider nesnesi oluşturur
                const VerticalDivider(width: 1),
                // Kalan alanı doldurur
                Expanded(child: body),
              ])
            // Koşul yanlışsa bu değeri seçer
            : body,
        // Alt gezinme menüsünü oluşturur
        bottomNavigationBar: wide
            // Koşul doğruysa bu değeri seçer
            ? null
            // Koşul yanlışsa bu değeri seçer
            : NavigationBar(
                // Seçili sekmenin indeksini belirler
                selectedIndex: _index,
                // Sekme seçilince çalışacak fonksiyonu belirler
                onDestinationSelected: (value) =>
                    // Değişen verileri ekrana bildirir
                    setState(() => _index = value),
                // destinations bilgisini belirler
                destinations: destinations,
              ),
      );
    });
  }
}

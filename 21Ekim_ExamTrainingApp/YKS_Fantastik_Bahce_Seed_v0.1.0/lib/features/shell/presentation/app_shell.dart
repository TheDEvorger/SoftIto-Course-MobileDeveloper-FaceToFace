// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// analytics ekran dosyasını kullanıma ekler
import '../../analytics/presentation/analytics_screen.dart';
// exams ekran dosyasını kullanıma ekler
import '../../exams/presentation/exams_screen.dart';
// focus ekran dosyasını kullanıma ekler
import '../../focus/presentation/focus_screen.dart';
// home ekran dosyasını kullanıma ekler
import '../../home/presentation/home_screen.dart';
// profile ekran dosyasını kullanıma ekler
import '../../profile/presentation/profile_screen.dart';
// topics ekran dosyasını kullanıma ekler
import '../../topics/presentation/topics_screen.dart';
// app shell için değişen verileri yöneten StatefulWidget kullanılır
class AppShell extends StatefulWidget {
  // app shell nesnesini oluşturur
  const AppShell({super.key});
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<AppShell> createState() => _AppShellState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _AppShellState extends State<AppShell> {
  // seçilen indeks için başlangıç sayısını belirler
  int selectedIndex = 0;
  // focus bilgisini açar
  void openFocus() => Navigator.of(context).push(
        // material sayfa route nesnesini oluşturur
        MaterialPageRoute<void>(builder: (_) => const FocusScreen()),
      );
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // pages için boş koleksiyon oluşturur
    final pages = <Widget>[
      // home ekran sayfasını gösterir
      HomeScreen(onStartFocus: openFocus),
      // topics ekran sayfasını gösterir
      const TopicsScreen(),
      // exams ekran sayfasını gösterir
      const ExamsScreen(),
      // analytics ekran sayfasını gösterir
      const AnalyticsScreen(),
      // profile ekran sayfasını gösterir
      const ProfileScreen(),
    ];
    // destinations için boş koleksiyon oluşturur
    const destinations = <NavigationDestination>[
      // Gezinme menüsüne sekme ekler
      NavigationDestination(
        // simge bilgisini belirler
        icon: Icon(Icons.yard_outlined),
        // seçilen icon bilgisini belirler
        selectedIcon: Icon(Icons.yard, color: Colors.white),
        // Buton veya alan yazısını belirler
        label: 'Ana Sayfa',
      ),
      // Gezinme menüsüne sekme ekler
      NavigationDestination(
        // simge bilgisini belirler
        icon: Icon(Icons.auto_stories_outlined),
        // seçilen icon bilgisini belirler
        selectedIcon: Icon(Icons.auto_stories, color: Colors.white),
        // Buton veya alan yazısını belirler
        label: 'Konular',
      ),
      // Gezinme menüsüne sekme ekler
      NavigationDestination(
        // simge bilgisini belirler
        icon: Icon(Icons.fact_check_outlined),
        // seçilen icon bilgisini belirler
        selectedIcon: Icon(Icons.fact_check, color: Colors.white),
        // Buton veya alan yazısını belirler
        label: 'Denemeler',
      ),
      // Gezinme menüsüne sekme ekler
      NavigationDestination(
        // simge bilgisini belirler
        icon: Icon(Icons.insights_outlined),
        // seçilen icon bilgisini belirler
        selectedIcon: Icon(Icons.insights, color: Colors.white),
        // Buton veya alan yazısını belirler
        label: 'Analiz',
      ),
      // Gezinme menüsüne sekme ekler
      NavigationDestination(
        // simge bilgisini belirler
        icon: Icon(Icons.account_circle_outlined),
        // seçilen icon bilgisini belirler
        selectedIcon: Icon(Icons.account_circle, color: Colors.white),
        // Buton veya alan yazısını belirler
        label: 'Profil',
      ),
    ];
    // Kullanılabilir alana göre yerleşim oluşturur
    return LayoutBuilder(builder: (context, constraints) {
      // is wide bilgisini hesaplayıp saklar
      final isWide = constraints.maxWidth >= 760;
      // body bilgisini hesaplayıp saklar
      final body = IndexedStack(index: selectedIndex, children: pages);
      // Belirtilen koşul doğruysa işlemi yapar
      if (isWide) {
        // Sayfanın temel iskeletini oluşturur
        return Scaffold(
          // Sayfanın ana içeriğini belirler
          body: SafeArea(
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // navigation rail nesnesini oluşturur
                NavigationRail(
                  // Seçili sekmenin indeksini belirler
                  selectedIndex: selectedIndex,
                  // on destination seçilen olayındaki fonksiyonu belirler
                  onDestinationSelected: (index) =>
                      // Değişen verileri arayüze bildirir
                      setState(() => selectedIndex = index),
                  // label type bilgisini belirler
                  labelType: NavigationRailLabelType.all,
                  // Sol tarafta gösterilecek öğeyi belirler
                  leading: Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    // İçine yerleştirilecek widgetı belirler
                    child: Column(
                      // İçerideki widgetları listeler
                      children: [
                        // Görsel bir kutu oluşturur
                        Container(
                          // Genişliği belirler
                          width: 44,
                          // Yüksekliği belirler
                          height: 44,
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: GardenPalette.mossEmerald,
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: const Icon(Icons.eco,
                              // Rengi belirler
                              color: Colors.white, size: 24),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 12),
                        // Dolu arka planlı simge butonu oluşturur
                        IconButton.filled(
                          // Basılınca çalışacak fonksiyonu belirler
                          onPressed: openFocus,
                          // simge bilgisini belirler
                          icon: const Icon(Icons.timer_outlined),
                          // tooltip bilgisini belirler
                          tooltip: 'Odak Odası',
                          // Görünüm stilini belirler
                          style: IconButton.styleFrom(
                            // Arka plan rengini belirler
                            backgroundColor: GardenPalette.peachCoral,
                            // Yazı ve simge rengini belirler
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // indicator renk bilgisini belirler
                  indicatorColor: GardenPalette.mossEmerald,
                  // destinations bilgisini belirler
                  destinations: const [
                    // navigation rail destination nesnesini oluşturur
                    NavigationRailDestination(
                      // simge bilgisini belirler
                      icon: Icon(Icons.yard_outlined),
                      // seçilen icon bilgisini belirler
                      selectedIcon: Icon(Icons.yard, color: Colors.white),
                      // Buton veya alan yazısını belirler
                      label: Text('Ana Sayfa'),
                    ),
                    // navigation rail destination nesnesini oluşturur
                    NavigationRailDestination(
                      // simge bilgisini belirler
                      icon: Icon(Icons.auto_stories_outlined),
                      // seçilen icon bilgisini belirler
                      selectedIcon:
                          // Simge gösterir
                          Icon(Icons.auto_stories, color: Colors.white),
                      // Buton veya alan yazısını belirler
                      label: Text('Konular'),
                    ),
                    // navigation rail destination nesnesini oluşturur
                    NavigationRailDestination(
                      // simge bilgisini belirler
                      icon: Icon(Icons.fact_check_outlined),
                      // seçilen icon bilgisini belirler
                      selectedIcon: Icon(Icons.fact_check, color: Colors.white),
                      // Buton veya alan yazısını belirler
                      label: Text('Denemeler'),
                    ),
                    // navigation rail destination nesnesini oluşturur
                    NavigationRailDestination(
                      // simge bilgisini belirler
                      icon: Icon(Icons.insights_outlined),
                      // seçilen icon bilgisini belirler
                      selectedIcon: Icon(Icons.insights, color: Colors.white),
                      // Buton veya alan yazısını belirler
                      label: Text('Analiz'),
                    ),
                    // navigation rail destination nesnesini oluşturur
                    NavigationRailDestination(
                      // simge bilgisini belirler
                      icon: Icon(Icons.account_circle_outlined),
                      // seçilen icon bilgisini belirler
                      selectedIcon:
                          // Simge gösterir
                          Icon(Icons.account_circle, color: Colors.white),
                      // Buton veya alan yazısını belirler
                      label: Text('Profil'),
                    ),
                  ],
                ),
                // vertical divider nesnesini oluşturur
                const VerticalDivider(width: 1),
                // Kalan boşluğu kullanacak alan oluşturur
                Expanded(
                  // İçine yerleştirilecek widgetı belirler
                  child: Center(
                    // İçine yerleştirilecek widgetı belirler
                    child: ConstrainedBox(
                      // constraints bilgisini belirler
                      constraints: const BoxConstraints(maxWidth: 960),
                      // İçine yerleştirilecek widgetı belirler
                      child: body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Sayfanın temel iskeletini oluşturur
      return Scaffold(
        // Sayfanın ana içeriğini belirler
        body: SafeArea(child: body),
        // Alt menüyü belirler
        bottomNavigationBar: NavigationBar(
          // Seçili sekmenin indeksini belirler
          selectedIndex: selectedIndex,
          // on destination seçilen olayındaki fonksiyonu belirler
          onDestinationSelected: (index) =>
              // Değişen verileri arayüze bildirir
              setState(() => selectedIndex = index),
          // Arka plan rengini belirler
          backgroundColor: isDark
              // Koşul doğruysa bu değeri kullanır
              ? GardenPalette.nightBackdrop
              // Koşul yanlışsa bu değeri kullanır
              : GardenPalette.sandyPorcelain,
          // indicator renk bilgisini belirler
          indicatorColor: GardenPalette.mossEmerald,
          // Gölge yüksekliğini belirler
          elevation: 4,
          // destinations bilgisini belirler
          destinations: destinations,
        ),
      );
    });
  }
}

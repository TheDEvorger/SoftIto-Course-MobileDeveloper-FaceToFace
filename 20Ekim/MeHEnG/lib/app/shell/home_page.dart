// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ventures dosyasını ekler
import '../../features/ventures/ventures.dart';
// Tema modu providerını ekler
import '../theme/theme_provider.dart';
// Modül önizleme ekranını ekler
import 'module_preview.dart';
// Ana sayfa ekranı
class HomePage extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const HomePage({super.key});
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<HomePage> createState() => _HomePageState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _HomePageState extends ConsumerState<HomePage> {
  // Tam sayı değerini tanımlar
  int selected = 0;
  // Labels sabitini tanımlar
  static const labels = ['Girişimler', 'Keşfet', 'Topluluk', 'Büyüme'];
  // Icons sabitini tanımlar
  static const icons = [
    // Gösterilecek simgeyi belirler
    Icons.dashboard_outlined,
    // Gösterilecek simgeyi belirler
    Icons.science_outlined,
    // Gösterilecek simgeyi belirler
    Icons.groups_outlined,
    // Gösterilecek simgeyi belirler
    Icons.trending_up_outlined,
  ];
  // Selected icons sabitini tanımlar
  static const selectedIcons = [
    // Gösterilecek simgeyi belirler
    Icons.dashboard,
    // Gösterilecek simgeyi belirler
    Icons.science,
    // Gösterilecek simgeyi belirler
    Icons.groups,
    // Gösterilecek simgeyi belirler
    Icons.trending_up,
  ];
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Wide bilgisini oluşturur
    final wide = MediaQuery.sizeOf(context).width >= 700;
    // Is dark bilgisini oluşturur
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Content bilgisini oluşturur
    final content = selected == 0
        // Koşul doğruysa bu değeri kullanır
        ? const VentureOverview()
        // Koşul yanlışsa bu değeri kullanır
        : ModulePreview(index: selected);
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlık bilgisini belirler
        title: const Text(
          // Gösterilecek metni belirler
          'MeHEnG',
          // Görünüm stilini belirler
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        // Buton ve işlemleri listeler
        actions: [
          // İçerik çevresine boşluk bırakır
          Padding(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.only(right: 8),
            // İçerideki widgetı belirler
            child: Center(
              // İçerideki widgetı belirler
              child: Text(
                // Gösterilecek metni belirler
                'Fikirden kanıta',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          // Simge butonu oluşturur
          IconButton(
            // Buton açıklamasını belirler
            tooltip: isDark ? 'Açık temaya geç' : 'Koyu temaya geç',
            // Butonun simgesini gösterir
            icon: Icon(
              // Duruma uygun simgeyi seçer
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            // Butona basılınca çalışacak işlemi belirler
            onPressed: () {
              // Riverpod üzerinden ilgili işlemi çalıştırır
              ref.read(themeModeProvider.notifier).toggle(isDark);
            },
          ),
          // Constructor gerekli bilgileri alır
          const SizedBox(width: 8),
        ],
      ),
      // Sayfanın ana içeriğini oluşturur
      body: wide
          // Koşul doğruysa bu değeri kullanır
          ? Row(
              // İçeride gösterilecek elemanları listeler
              children: [
                // Navigation rail sınıfını tanımlar oluşturur
                NavigationRail(
                  // Extended özelliğini belirler
                  extended: MediaQuery.sizeOf(context).width >= 1100,
                  // Selected index özelliğini belirler
                  selectedIndex: selected,
                  // İşlem gerçekleşince çalışacak callbacki bağlar
                  onDestinationSelected: (i) => setState(() => selected = i),
                  // Destinations özelliğini belirler
                  destinations: [
                    // Listedeki elemanları sırayla dolaşır
                    for (var i = 0; i < labels.length; i++)
                      // Navigation rail destination sınıfını tanımlar oluşturur
                      NavigationRailDestination(
                        // Butonun simgesini gösterir
                        icon: Icon(icons[i]),
                        // Selected icon özelliğini belirler
                        selectedIcon: Icon(selectedIcons[i]),
                        // Butonun yazısını gösterir
                        label: Text(labels[i]),
                      ),
                  ],
                ),
                // Constructor gerekli bilgileri alır
                const VerticalDivider(width: 1),
                // Kalan alanı kullanır
                Expanded(child: content),
              ],
            )
          // Koşul yanlışsa bu değeri kullanır
          : content,
      // Bottom navigation bar özelliğini belirler
      bottomNavigationBar: wide
          // Koşul doğruysa bu değeri kullanır
          ? null
          // Koşul yanlışsa bu değeri kullanır
          : NavigationBar(
              // Selected index özelliğini belirler
              selectedIndex: selected,
              // İşlem gerçekleşince çalışacak callbacki bağlar
              onDestinationSelected: (i) => setState(() => selected = i),
              // Destinations özelliğini belirler
              destinations: [
                // Listedeki elemanları sırayla dolaşır
                for (var i = 0; i < labels.length; i++)
                  // Navigation destination sınıfını tanımlar oluşturur
                  NavigationDestination(
                    // Butonun simgesini gösterir
                    icon: Icon(icons[i]),
                    // Selected icon özelliğini belirler
                    selectedIcon: Icon(selectedIcons[i]),
                    // Gösterilecek etiketi belirler
                    label: labels[i],
                  ),
              ],
            ),
    );
  }
}

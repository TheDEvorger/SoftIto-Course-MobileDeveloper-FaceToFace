// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// kiralama ana kabuk görünümünü oluşturan widget sınıfı
class RentalShell extends StatelessWidget {
  // kiralama ana kabuk nesnesi oluşturur
  const RentalShell(
      // Veri alanlarını tanımlar
      {super.key,
      // sayfalar bilgisini zorunlu alır
      required this.pages,
      // indeks bilgisini zorunlu alır
      required this.index,
      // olay seçim bilgisini zorunlu alır
      required this.onSelected,
      // yükleme bilgisini zorunlu alır
      required this.loading,
      // olay yeniden deneme bilgisini zorunlu alır
      required this.onRetry,
      // Tema renklerinden uygun olanı kullanır
      this.error});
  // sayfalar bilgisini tutar
  final List<Widget> pages;
  // indeks bilgisini tutar
  final int index;
  // yükleme bilgisini tutar
  final bool loading;
  // hata bilgisini tutar
  final String? error;
  // olay seçim bilgisini tutar
  final ValueChanged<int> onSelected;
  // olay yeniden deneme bilgisini tutar
  final VoidCallback onRetry;
  // öğeler değerini tanımlar
  static const items = [
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.explore_outlined, 'Keşfet'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.favorite_border, 'Favoriler'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.calendar_month_outlined, 'Planlarım'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.person_outline, 'Profil')
  ];
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        // wide değerini belirler
        final wide = c.maxWidth >= 1000 &&
            // Ekran ölçülerini alır
            MediaQuery.textScalerOf(context).scale(1) < 1.4;
        // renkler değerini belirler
        final colors = Theme.of(context).colorScheme;
        // Sayfanın temel yapısını oluşturur
        return Scaffold(
            // Sayfanın ana içeriğini oluşturur
            body: SafeArea(
                // İçerikte gösterilecek widgetı belirler
                child: Column(children: [
              // Görünüm için kutu oluşturur
              Container(
                  // Kutunun görünümünü ayarlar
                  decoration: BoxDecoration(
                      // Rengi belirler
                      color: colors.surface,
                      // Kenarlık görünümünü oluşturur
                      border: Border(
                          // bottom bilgisini belirler
                          bottom: BorderSide(color: colors.outlineVariant))),
                  // İçerikte gösterilecek widgetı belirler
                  child: Center(
                      // İçerikte gösterilecek widgetı belirler
                      child: ConstrainedBox(
                          // box constraints constructorını tanımlar
                          constraints: const BoxConstraints(maxWidth: 1280),
                          // İçerikte gösterilecek widgetı belirler
                          child: Padding(
                              // İç boşlukları ayarlar
                              padding: const EdgeInsets.symmetric(
                                  // horizontal bilgisini belirler
                                  horizontal: 20, vertical: 16),
                              // İçerikte gösterilecek widgetı belirler
                              child: Row(children: [
                                // Görünüm için kutu oluşturur
                                Container(
                                    // İç boşlukları ayarlar
                                    padding: const EdgeInsets.all(10),
                                    // Kutunun görünümünü ayarlar
                                    decoration: BoxDecoration(
                                        // Rengi belirler
                                        color: colors.primary,
                                        // Köşeleri yuvarlar
                                        borderRadius:
                                            // Köşeleri yuvarlar
                                            BorderRadius.circular(13)),
                                    // İçerikte gösterilecek widgetı belirler
                                    child: Icon(Icons.route_rounded,
                                        // Rengi belirler
                                        color: colors.onPrimary, size: 23)),
                                // Belirtilen boyutta boşluk veya kutu oluşturur
                                const SizedBox(width: 12),
                                // Kalan alanı doldurur
                                Expanded(
                                    // İçerikte gösterilecek widgetı belirler
                                    child: Column(
                                        // Çapraz eksendeki hizalamayı belirler
                                        crossAxisAlignment:
                                            // Elemanların hizalanma biçimini belirler
                                            CrossAxisAlignment.start,
                                        // İçerideki elemanları listeler
                                        children: [
                                      // Metni gösterir
                                      Text('PRECISION',
                                          // Görünüm stilini belirler
                                          style: TextStyle(
                                              // Yazı boyutunu belirler
                                              fontSize: 15,
                                              // Harfler arasındaki boşluğu ayarlar
                                              letterSpacing: 2,
                                              // Yazı kalınlığını belirler
                                              fontWeight: FontWeight.w700,
                                              // Rengi belirler
                                              color: colors.onSurface)),
                                      // Metni gösterir
                                      Text('ARAÇ KİRALAMA',
                                          // Görünüm stilini belirler
                                          style: TextStyle(
                                              // Yazı boyutunu belirler
                                              fontSize: 8,
                                              // Harfler arasındaki boşluğu ayarlar
                                              letterSpacing: 1.6,
                                              // Rengi belirler
                                              color: colors.onSurfaceVariant)),
                                    ])),
                                // Koşul doğruysa bu işlemi çalıştırır
                                if (wide)
                                  // Listedeki öğeleri veya indeksleri sırayla dolaşır
                                  for (var i = 0; i < items.length; i++)
                                    // İçerik etrafına boşluk bırakır
                                    Padding(
                                        // İç boşlukları ayarlar
                                        padding: const EdgeInsets.only(left: 6),
                                        // İçerikte gösterilecek widgetı belirler
                                        child: TextButton.icon(
                                            // Butona basılınca çalışacak fonksiyonu belirler
                                            onPressed: () => onSelected(i),
                                            // Görünüm stilini belirler
                                            style: TextButton.styleFrom(
                                                // Arka plan rengini belirler
                                                backgroundColor: i == index
                                                    // Koşul doğruysa bu değeri seçer
                                                    ? colors.primaryContainer
                                                    // Koşul yanlışsa bu değeri seçer
                                                    : null),
                                            // Butonun veya öğenin simgesini belirler
                                            icon: Icon(items[i].$1, size: 18),
                                            // Görünen etiketi belirler
                                            label: Text(items[i].$2))),
                                // Koşul doğruysa bu işlemi çalıştırır
                                if (!wide)
                                  // Simge butonu oluşturur
                                  IconButton(
                                      // Butona basılınca çalışacak fonksiyonu belirler
                                      onPressed: () => onSelected(2),
                                      // Butonun açıklama metnini belirler
                                      tooltip: 'Rezervasyonlarım',
                                      // Butonun veya öğenin simgesini belirler
                                      icon: const Icon(
                                          // Flutter simgesini belirler
                                          Icons.event_available_outlined)),
                              ]))))),
              // linear progress indicator constructorını tanımlar
              if (loading) const LinearProgressIndicator(),
              // Değer null değilse koşulu çalıştırır
              if (error != null)
                // Görünüm için kutu oluşturur
                Container(
                    // Rengi belirler
                    color: colors.errorContainer,
                    // İç boşlukları ayarlar
                    padding: const EdgeInsets.all(12),
                    // İçerikte gösterilecek widgetı belirler
                    child: Row(children: [
                      // Kalan alanı doldurur
                      Expanded(
                          // İçerikte gösterilecek widgetı belirler
                          child: Text(error!,
                              // Görünüm stilini belirler
                              style:
                                  // Yazı stilini oluşturur
                                  TextStyle(color: colors.onErrorContainer))),
                      // Simge butonu oluşturur
                      IconButton(
                          // Butona basılınca çalışacak fonksiyonu belirler
                          onPressed: onRetry,
                          // Butonun açıklama metnini belirler
                          tooltip: 'Cihaz kayıtlarını yeniden yükle',
                          // Butonun veya öğenin simgesini belirler
                          icon: const Icon(Icons.refresh))
                    ])),
              // Kalan alanı doldurur
              Expanded(child: IndexedStack(index: index, children: pages)),
            ])),
            // Alt gezinme menüsünü oluşturur
            bottomNavigationBar: wide
                // Koşul doğruysa bu değeri seçer
                ? null
                // Koşul yanlışsa bu değeri seçer
                : SafeArea(
                    // top bilgisini belirler
                    top: false,
                    // İçerikte gösterilecek widgetı belirler
                    child: NavigationBar(
                        // Seçili sekmenin indeksini belirler
                        selectedIndex: index,
                        // Sekme seçilince çalışacak fonksiyonu belirler
                        onDestinationSelected: onSelected,
                        // etiket behavior bilgisini belirler
                        labelBehavior: c.maxWidth < 370 ||
                                // Ekran ölçülerini alır
                                MediaQuery.textScalerOf(context).scale(1) > 1.3
                            // Koşul doğruysa bu değeri seçer
                            ? NavigationDestinationLabelBehavior
                                // Önceki ifade üzerinde ek işlem uygular
                                .onlyShowSelected
                            // Koşul yanlışsa bu değeri seçer
                            : NavigationDestinationLabelBehavior.alwaysShow,
                        // destinations bilgisini belirler
                        destinations: [
                          // Listedeki öğeleri veya indeksleri sırayla dolaşır
                          for (final item in items)
                            // navigation destination nesnesi oluşturur
                            NavigationDestination(
                                // Butonun veya öğenin simgesini belirler
                                icon: Icon(item.$1),
                                // Görünen etiketi belirler
                                label: item.$2,
                                // Butonun açıklama metnini belirler
                                tooltip: item.$2)
                        ])));
      });
}

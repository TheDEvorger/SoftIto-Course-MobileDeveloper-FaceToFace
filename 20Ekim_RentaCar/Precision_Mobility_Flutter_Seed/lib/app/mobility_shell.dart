// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// çalışma alanı notice dosyasını ekler
import '../shared/design/workspace_notice.dart';
// mobility ana kabuk görünümünü oluşturan widget sınıfı
class MobilityShell extends StatelessWidget {
  // mobility ana kabuk nesnesi oluşturur
  const MobilityShell(
      // Veri alanlarını tanımlar
      {super.key,
      // sayfalar bilgisini zorunlu alır
      required this.pages,
      // indeks bilgisini zorunlu alır
      required this.index,
      // olay seçim bilgisini zorunlu alır
      required this.onSelected,
      // this değerini günceller
      this.examples = false,
      // this değerini günceller
      this.switching = false,
      // bağlantı hata parametresini alır
      this.connectionError,
      // olay yeniden deneme parametresini alır
      this.onRetry,
      // bağlantı bilgisini zorunlu alır
      required this.connected});
  // sayfalar bilgisini tutar
  final List<Widget> pages;
  // indeks bilgisini tutar
  final int index;
  // olay seçim bilgisini tutar
  final ValueChanged<int> onSelected;
  // bağlantı bilgisini tutar
  final bool connected;
  // geçiş bilgisini tutar
  final bool examples, switching;
  // bağlantı hata bilgisini tutar
  final String? connectionError;
  // olay yeniden deneme bilgisini tutar
  final VoidCallback? onRetry;
  // öğeler değerini tanımlar
  static const _items = [
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.explore_outlined, 'Keşfet'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.directions_car_outlined, 'Araçlar'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.event_note_outlined, 'Sürüşlerim'),
    // Menü için simge ve başlık çiftini oluşturur
    (Icons.tune_outlined, 'Hesabım'),
  ];
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // wide değerini belirler
        final wide = constraints.maxWidth >= 1000 &&
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
                        constraints: const BoxConstraints(maxWidth: 1360),
                        // İçerikte gösterilecek widgetı belirler
                        child: Padding(
                            // İç boşlukları ayarlar
                            padding: EdgeInsets.symmetric(
                                // horizontal bilgisini belirler
                                horizontal: wide ? 36 : 20, vertical: 18),
                            // İçerikte gösterilecek widgetı belirler
                            child: Row(children: [
                              // Görünüm için kutu oluşturur
                              Container(
                                  // Genişliği belirler
                                  width: 36,
                                  // Yüksekliği belirler
                                  height: 36,
                                  // Kutunun görünümünü ayarlar
                                  decoration: BoxDecoration(
                                      // Rengi belirler
                                      color: colors.onSurface,
                                      // Köşeleri yuvarlar
                                      borderRadius: BorderRadius.circular(11)),
                                  // İçerikte gösterilecek widgetı belirler
                                  child: Icon(Icons.route_rounded,
                                      // Rengi belirler
                                      color: colors.surface, size: 21)),
                              // Belirtilen boyutta boşluk veya kutu oluşturur
                              const SizedBox(width: 12),
                              // Kalan alanı doldurur
                              Expanded(
                                  // flex bilgisini belirler
                                  flex: wide ? 0 : 1,
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
                                                fontSize: 14,
                                                // Harfler arasındaki boşluğu ayarlar
                                                letterSpacing: 2.4,
                                                // Yazı kalınlığını belirler
                                                fontWeight: FontWeight.w800,
                                                // Rengi belirler
                                                color: colors.onSurface)),
                                        // Metni gösterir
                                        Text('MOBILITY, REFINED.',
                                            // Görünüm stilini belirler
                                            style: TextStyle(
                                                // Yazı boyutunu belirler
                                                fontSize: 8,
                                                // Harfler arasındaki boşluğu ayarlar
                                                letterSpacing: 1.8,
                                                // Rengi belirler
                                                color:
                                                    // Tema renklerinden uygun olanı kullanır
                                                    colors.onSurfaceVariant)),
                                      ])),
                              // Koşul doğruysa bu işlemi çalıştırır
                              if (wide) ...[
                                // Elemanlar arasında esnek boşluk bırakır
                                const Spacer(),
                                // Listedeki öğeleri veya indeksleri sırayla dolaşır
                                for (var i = 0; i < _items.length; i++)
                                  // İçerik etrafına boşluk bırakır
                                  Padding(
                                      // İç boşlukları ayarlar
                                      padding: const EdgeInsets.symmetric(
                                          // horizontal bilgisini belirler
                                          horizontal: 3),
                                      // İçerikte gösterilecek widgetı belirler
                                      child: TextButton.icon(
                                          // Butona basılınca çalışacak fonksiyonu belirler
                                          onPressed: () => onSelected(i),
                                          // Görünüm stilini belirler
                                          style: TextButton.styleFrom(
                                              // Arka plan rengini belirler
                                              backgroundColor: index == i
                                                  // Koşul doğruysa bu değeri seçer
                                                  ? colors.primaryContainer
                                                  // Koşul yanlışsa bu değeri seçer
                                                  : Colors.transparent,
                                              // Yazı ve simge rengini belirler
                                              foregroundColor: index == i
                                                  // Koşul doğruysa bu değeri seçer
                                                  ? colors.onPrimaryContainer
                                                  // Koşul yanlışsa bu değeri seçer
                                                  : colors.onSurfaceVariant,
                                              // İç boşlukları ayarlar
                                              padding:
                                                  // Boşlukları belirler
                                                  const EdgeInsets.symmetric(
                                                      // horizontal bilgisini belirler
                                                      horizontal: 18,
                                                      // vertical bilgisini belirler
                                                      vertical: 16)),
                                          // Butonun veya öğenin simgesini belirler
                                          icon: Icon(_items[i].$1, size: 18),
                                          // Görünen etiketi belirler
                                          label: Text(_items[i].$2))),
                                // Elemanlar arasında esnek boşluk bırakır
                                const Spacer(),
                              ],
                              // Simge butonu oluşturur
                              IconButton.filledTonal(
                                  // Butona basılınca çalışacak fonksiyonu belirler
                                  onPressed: () => onSelected(3),
                                  // Butonun açıklama metnini belirler
                                  tooltip: connected
                                      // Koşul doğruysa bu değeri seçer
                                      ? 'Çalışma alanı bağlı'
                                      // Koşul yanlışsa bu değeri seçer
                                      : 'Çalışma alanına bağlan',
                                  // Butonun veya öğenin simgesini belirler
                                  icon: Icon(
                                      // Önceki ifadeyi tamamlar
                                      connected
                                          // Koşul doğruysa bu değeri seçer
                                          ? Icons.verified_user_outlined
                                          // Koşul yanlışsa bu değeri seçer
                                          : Icons.key_outlined,
                                      // Boyutu belirler
                                      size: 20)),
                            ]))))),
            // çalışma alanı notice nesnesi oluşturur
            WorkspaceNotice(
                // Örnek veri durumunu belirler
                examples: examples,
                // yükleme bilgisini belirler
                loading: switching,
                // hata bilgisini belirler
                error: connectionError,
                // action için callback belirler
                onAction:
                    // İfadeye karşılaştırma koşulu ekler
                    connectionError != null ? onRetry! : () => onSelected(3)),
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
                  child: Padding(
                      // İç boşlukları ayarlar
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                      // İçerikte gösterilecek widgetı belirler
                      child: Container(
                          // Kutunun görünümünü ayarlar
                          decoration: BoxDecoration(
                              // Rengi belirler
                              color: colors.surface,
                              // Köşeleri yuvarlar
                              borderRadius: BorderRadius.circular(26),
                              // Kenarlık görünümünü oluşturur
                              border: Border.all(color: colors.outlineVariant)),
                          // İçerikte gösterilecek widgetı belirler
                          child: ClipRRect(
                              // Köşeleri yuvarlar
                              borderRadius: BorderRadius.circular(26),
                              // İçerikte gösterilecek widgetı belirler
                              child: NavigationBar(
                                // Seçili sekmenin indeksini belirler
                                selectedIndex: index,
                                // Sekme seçilince çalışacak fonksiyonu belirler
                                onDestinationSelected: onSelected,
                                // destinations bilgisini belirler
                                destinations: [
                                  // Listedeki öğeleri veya indeksleri sırayla dolaşır
                                  for (final item in _items)
                                    // navigation destination nesnesi oluşturur
                                    NavigationDestination(
                                        // Butonun veya öğenin simgesini belirler
                                        icon: Icon(item.$1), label: item.$2)
                                ],
                              ))))),
        );
      });
}

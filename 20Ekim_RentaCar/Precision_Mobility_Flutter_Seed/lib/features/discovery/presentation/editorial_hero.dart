// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio renkler dosyasını ekler
import '../../../core/theme/studio_colors.dart';
// editorial giriş alanı görünümünü oluşturan widget sınıfı
class EditorialHero extends StatelessWidget {
  // editorial giriş alanı nesnesi oluşturur
  const EditorialHero({super.key, required this.onExplore});
  // olay explore bilgisini tutar
  final VoidCallback onExplore;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // wide değerini belirler
        final wide = constraints.maxWidth >= 850 &&
            // Ekran ölçülerini alır
            MediaQuery.textScalerOf(context).scale(1) < 1.3;
        // koyu tema değerini belirler
        final dark = Theme.of(context).brightness == Brightness.dark;
        // yüzey değerini belirler
        final surface = Theme.of(context).colorScheme.surface;
        // copy değerini belirler
        final copy = Padding(
            // İç boşlukları ayarlar
            padding: EdgeInsets.all(wide ? 40 : 26),
            // İçerikte gösterilecek widgetı belirler
            child: Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // Ana eksende kaplanan alanı belirler
                mainAxisSize: MainAxisSize.min,
                // İçerideki elemanları listeler
                children: [
                  // Metni gösterir
                  Text('SÜRÜŞÜN YENİ PERSPEKTİFİ',
                      // Görünüm stilini belirler
                      style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 10,
                          // Harfler arasındaki boşluğu ayarlar
                          letterSpacing: 2.2,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.w700,
                          // Rengi belirler
                          color: Theme.of(context).colorScheme.primary)),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 20),
                  // Metni gösterir
                  Text('Yola çıkmanın\ndaha iyi bir yolu.',
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          // Yazı boyutunu belirler
                          fontSize: wide ? 48 : 34, letterSpacing: -1.8)),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 16),
                  // constrained box nesnesi oluşturur
                  ConstrainedBox(
                      // box constraints constructorını tanımlar
                      constraints: const BoxConstraints(maxWidth: 330),
                      // İçerikte gösterilecek widgetı belirler
                      child: Text(
                          // İlgili metin değerini belirler
                          'Şehre, planlarınıza, size uyan araç.\nBir sonraki yolculuğunuzu birlikte şekillendirelim.',
                          // Görünüm stilini belirler
                          style: TextStyle(
                              // Yüksekliği belirler
                              height: 1.7,
                              // Rengi belirler
                              color: Theme.of(context)
                                  // Önceki ifade üzerinde ek işlem uygular
                                  .colorScheme
                                  // Önceki ifade üzerinde ek işlem uygular
                                  .onSurfaceVariant))),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 24),
                  // Dolgulu buton oluşturur
                  FilledButton.icon(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: onExplore,
                      // Görünen etiketi belirler
                      label: const Text('Koleksiyonu keşfet'),
                      // Butonun veya öğenin simgesini belirler
                      icon: const Icon(Icons.north_east, size: 17)),
                ]));
        // fotoğraf değerini belirler
        final photo = Stack(fit: StackFit.expand, children: [
          // Görseli gösterir
          Image.asset('assets/images/precision-editorial-hero.png',
              // Görselin yerleşme biçimini belirler
              fit: BoxFit.cover,
              // Hizalamayı belirler
              alignment: const Alignment(.55, .4),
              // exclude from semantics bilgisini belirler
              excludeFromSemantics: true),
          // Öğeyi Stack içinde konumlandırır
          Positioned(
              // right bilgisini belirler
              right: 12,
              // bottom bilgisini belirler
              bottom: 12,
              // İçerikte gösterilecek widgetı belirler
              child: Container(
                  // İç boşlukları ayarlar
                  padding:
                      // Boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  // Kutunun görünümünü ayarlar
                  decoration: BoxDecoration(
                      // Rengi belirler
                      color: Colors.black.withValues(alpha: .68),
                      // Köşeleri yuvarlar
                      borderRadius: BorderRadius.circular(8)),
                  // İçerikte gösterilecek widgetı belirler
                  child: const Text('YAPAY ZEKÂ İLE ÜRETİLMİŞ MARKA GÖRSELİ',
                      // Görünüm stilini belirler
                      style: TextStyle(
                          // Rengi belirler
                          color: Colors.white,
                          // Yazı boyutunu belirler
                          fontSize: 8,
                          // Harfler arasındaki boşluğu ayarlar
                          letterSpacing: .5)))),
        ]);
        // Köşeleri yuvarlayarak içeriği keser
        return ClipRRect(
            // Köşeleri yuvarlar
            borderRadius: BorderRadius.circular(28),
            // İçerikte gösterilecek widgetı belirler
            child: ColoredBox(
                // Rengi belirler
                color: surface,
                // İçerikte gösterilecek widgetı belirler
                child: wide
                    // Koşul doğruysa bu değeri seçer
                    ? ConstrainedBox(
                        // box constraints constructorını tanımlar
                        constraints: const BoxConstraints(minHeight: 380),
                        // İçerikte gösterilecek widgetı belirler
                        child: Stack(children: [
                          // Öğeyi Stack içinde konumlandırır
                          Positioned.fill(child: photo),
                          // Öğeyi Stack içinde konumlandırır
                          Positioned.fill(
                              // İçerikte gösterilecek widgetı belirler
                              child: DecoratedBox(
                                  // Kutunun görünümünü ayarlar
                                  decoration: BoxDecoration(
                                      // gradient bilgisini belirler
                                      gradient: LinearGradient(stops: const [
                            // Önceki ifadeyi tamamlar
                            0,
                            // Önceki ifade üzerinde ek işlem uygular
                            .32,
                            // Önceki ifade üzerinde ek işlem uygular
                            .62
                          // Eleman listesini başlatır
                          ], colors: [
                            // Önceki ifadeyi tamamlar
                            surface,
                            // Önceki ifadeyi tamamlar
                            surface.withValues(alpha: .97),
                            // Önceki ifadeyi tamamlar
                            surface.withValues(alpha: 0)
                          ])))),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          SizedBox(
                              // Genişliği belirler
                              width: constraints.maxWidth * .52, child: copy),
                        ]))
                    // Koşul yanlışsa bu değeri seçer
                    : Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // İçerideki elemanları listeler
                        children: [
                            // Önceki ifadeyi tamamlar
                            copy,
                            // aspect ratio nesnesi oluşturur
                            AspectRatio(aspectRatio: 1.85, child: photo),
                            // Görünüm için kutu oluşturur
                            Container(
                                // Yüksekliği belirler
                                height: 5,
                                // Rengi belirler
                                color: dark
                                    // Koşul doğruysa bu değeri seçer
                                    ? StudioColors.forest
                                    // Koşul yanlışsa bu değeri seçer
                                    : StudioColors.mint),
                          ])));
      });
}

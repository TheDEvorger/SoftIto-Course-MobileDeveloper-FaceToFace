// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa heading görünümünü oluşturan widget sınıfı
class PageHeading extends StatelessWidget {
  // sayfa heading nesnesi oluşturur
  const PageHeading(
      // Veri alanlarını tanımlar
      {super.key,
      // eyebrow bilgisini zorunlu alır
      required this.eyebrow,
      // başlık bilgisini zorunlu alır
      required this.title,
      // açıklama bilgisini zorunlu alır
      required this.description,
      // action parametresini alır
      this.action});
  // açıklama bilgisini tutar
  final String eyebrow, title, description;
  // action bilgisini tutar
  final Widget? action;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // metin değerini belirler
        final text =
            // Elemanları alt alta dizer
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Metni gösterir
          Text(eyebrow.toUpperCase(),
              // Görünüm stilini belirler
              style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 10,
                  // Harfler arasındaki boşluğu ayarlar
                  letterSpacing: 2.5,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w700,
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.primary)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // semantics nesnesi oluşturur
          Semantics(
              // header bilgisini belirler
              header: true,
              // İçerikte gösterilecek widgetı belirler
              child: Text(title,
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      // Yazı boyutunu belirler
                      fontSize: constraints.maxWidth < 600 ? 30 : 40))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Metni gösterir
          Text(description,
              // Görünüm stilini belirler
              style: TextStyle(
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]);
        // Değer null ise koşulu çalıştırır
        if (constraints.maxWidth < 700 || action == null) {
          // Elemanları alt alta dizer
          return Column(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçerideki elemanları listeler
              children: [
                // Önceki ifadeyi tamamlar
                text,
                // sized box constructorını tanımlar
                if (action != null) ...[const SizedBox(height: 20), action!]
              ]);
        }
        // Elemanları yan yana dizer
        return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          // Kalan alanı doldurur
          Expanded(child: text),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(width: 24),
          // Önceki ifadeyi tamamlar
          action!
        ]);
      });
}

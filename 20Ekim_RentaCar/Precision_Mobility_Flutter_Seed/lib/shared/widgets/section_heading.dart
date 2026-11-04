// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// precision tokens dosyasını ekler
import '../../core/theme/precision_tokens.dart';
/// Sayfa ve bölüm başlıklarını standartlaştıran başlık bileşeni.
/// Başlık ve alt başlık içerir, erişilebilirlik için header semantiği sağlar.
// section heading görünümünü oluşturan widget sınıfı
class SectionHeading extends StatelessWidget {
  // section heading nesnesi oluşturur
  const SectionHeading(
      // Veri alanlarını tanımlar
      {super.key, required this.title, required this.subtitle});
  /// Bölüm ana başlığı
  // başlık bilgisini tutar
  final String title;
  /// Bölüm açıklayıcı alt başlığı
  // alt başlık bilgisini tutar
  final String subtitle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Column(
        // Çapraz eksendeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // İçerideki elemanları listeler
        children: [
          // semantics nesnesi oluşturur
          Semantics(
              // header bilgisini belirler
              header: true,
              // İçerikte gösterilecek widgetı belirler
              child: Text(title,
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.headlineMedium)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: PrecisionSpace.sm),
          // Metni gösterir
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// PageFrame sınıfını tanımlar
class PageFrame extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const PageFrame({super.key, required this.child, this.maxWidth = 1120});
  // alt eleman bilgisini tutar
  final Widget child;
  // en fazla genişlik bilgisini tutar
  final double maxWidth;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // safe area değerini hesaplar veya döndürür
    return SafeArea(
      // bottom bilgisini belirler
      bottom: false,
      // İçeride gösterilecek widgetı belirler
      child: Align(
        // Hizalama şeklini belirler
        alignment: Alignment.topCenter,
        // İçeride gösterilecek widgetı belirler
        child: ConstrainedBox(
          // Boyut sınırlarını belirler
          constraints: BoxConstraints(maxWidth: maxWidth),
          // İçeride gösterilecek widgetı belirler
          child: child,
        ),
      ),
    );
  }
}
// PageHeader sınıfını tanımlar
class PageHeader extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const PageHeader({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // alt başlık bilgisini zorunlu tutar
    required this.subtitle,
    // sağdaki eleman için varsayılan değeri belirler
    this.trailing,
  });
  // başlık bilgisini tutar
  final String title;
  // alt başlık bilgisini tutar
  final String subtitle;
  // sağdaki eleman bilgisini tutar
  final Widget? trailing;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // iç boşluk değerini hesaplar veya döndürür
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.center,
        // Alt widgetları listeler
        children: <Widget>[
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Semantics nesnesini oluşturur veya kullanır
                Semantics(
                  // header bilgisini belirler
                  header: true,
                  // İçeride gösterilecek widgetı belirler
                  child: Text(title, style: theme.textTheme.headlineSmall),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 4),
                // Metin gösterir
                Text(
                  // Metodun veya constructorın parametresini tanımlar
                  subtitle,
                  // style bilgisini belirler
                  style: theme.textTheme.bodyMedium
                      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          // Değer null değilse işlemi çalıştırır
          if (trailing != null) ...<Widget>[
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 12),
            // İlgili alanın değerini veya görünümünü ayarlar
            trailing!,
          ],
        ],
      ),
    );
  }
}
// SectionCard kartını oluşturan sınıf
class SectionCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const SectionCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // alt eleman bilgisini zorunlu tutar
    required this.child,
    // simge için varsayılan değeri belirler
    this.icon,
    // sağdaki eleman için varsayılan değeri belirler
    this.trailing,
    // iç boşluk için varsayılan değeri belirler
    this.padding = const EdgeInsets.all(16),
  });
  // başlık bilgisini tutar
  final String title;
  // simge bilgisini tutar
  final IconData? icon;
  // sağdaki eleman bilgisini tutar
  final Widget? trailing;
  // alt eleman bilgisini tutar
  final Widget child;
  // iç boşluk bilgisini tutar
  final EdgeInsetsGeometry padding;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // card değerini hesaplar veya döndürür
    return Card(
      // İçeride gösterilecek widgetı belirler
      child: Padding(
        // İç boşlukları belirler
        padding: padding,
        // İçeride gösterilecek widgetı belirler
        child: Column(
          // Elemanların çapraz hizasını belirler
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Alt widgetları listeler
          children: <Widget>[
            // Elemanları yan yana dizer
            Row(
              // Alt widgetları listeler
              children: <Widget>[
                // Değer null değilse işlemi çalıştırır
                if (icon != null) ...<Widget>[
                  // Simge gösterir
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(width: 8),
                ],
                // Kalan alanı doldurmasını sağlar
                Expanded(
                  // İçeride gösterilecek widgetı belirler
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                // İlgili alanın değerini veya görünümünü ayarlar
                ?trailing,
              ],
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(height: 12),
            // Metodun veya constructorın parametresini tanımlar
            child,
          ],
        ),
      ),
    );
  }
}
// QueueBadge sınıfını tanımlar
class QueueBadge extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const QueueBadge({super.key, required this.label, this.large = false});
  // etiket bilgisini tutar
  final String label;
  // large bilgisini tutar
  final bool large;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // container değerini hesaplar veya döndürür
    return Container(
      // İç boşlukları belirler
      padding: EdgeInsets.symmetric(
        // horizontal bilgisini belirler
        horizontal: large ? 16 : 10,
        // vertical bilgisini belirler
        vertical: large ? 10 : 8,
      ),
      // Görünüm ayarlarını oluşturur
      decoration: BoxDecoration(
        // Rengini belirler
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(large ? 14 : 10),
      ),
      // İçeride gösterilecek widgetı belirler
      child: Text(
        // Metodun veya constructorın parametresini tanımlar
        label,
        // style bilgisini belirler
        style: (large
                // Koşul doğruysa bu değeri kullanır
                ? theme.textTheme.headlineSmall
                // Koşul yanlışsa bu değeri kullanır
                : theme.textTheme.titleSmall)
            // Değer null değilse bu işlemi yapar
            ?.copyWith(
          // Rengini belirler
          color: theme.colorScheme.primary,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w800,
          // font features bilgisini belirler
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

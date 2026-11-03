// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// StatCard kartını oluşturan sınıf
class StatCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const StatCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // etiket bilgisini zorunlu tutar
    required this.label,
    // değer bilgisini zorunlu tutar
    required this.value,
    // açıklama bilgisini zorunlu tutar
    required this.caption,
    // simge bilgisini zorunlu tutar
    required this.icon,
    // renk bilgisini zorunlu tutar
    required this.color,
    // dokunma işlemi bilgisini zorunlu tutar
    required this.onTap,
  });
  // etiket bilgisini tutar
  final String label;
  // değer bilgisini tutar
  final int value;
  // açıklama bilgisini tutar
  final String caption;
  // simge bilgisini tutar
  final IconData icon;
  // renk bilgisini tutar
  final Color color;
  // dokunma işlemi bilgisini tutar
  final VoidCallback onTap;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // semantics değerini hesaplar veya döndürür
    return Semantics(
      // button bilgisini belirler
      button: true,
      // Gösterilecek etiketi belirler
      label: '$label: $value. $caption',
      // exclude semantics bilgisini belirler
      excludeSemantics: true,
      // İçeride gösterilecek widgetı belirler
      child: Card(
        // Taşan kısmın nasıl kesileceğini belirler
        clipBehavior: Clip.antiAlias,
        // İçeride gösterilecek widgetı belirler
        child: InkWell(
          // Dokunulunca çalışacak fonksiyonu belirler
          onTap: onTap,
          // İçeride gösterilecek widgetı belirler
          child: Padding(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(16),
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Elemanları yan yana dizer
                Row(
                  // Alt widgetları listeler
                  children: <Widget>[
                    // Görünüm ve yerleşim için kutu oluşturur
                    Container(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.all(8),
                      // Görünüm ayarlarını oluşturur
                      decoration: BoxDecoration(
                        // Rengini belirler
                        color: color.withValues(alpha: 0.14),
                        // Köşeleri yuvarlar
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // İçeride gösterilecek widgetı belirler
                      child: Icon(icon,
                          // boyut bilgisini belirler
                          size: 20,
                          // Rengini belirler
                          color: StatusColors.readable(context, color)),
                    ),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const Spacer(),
                    // Simge gösterir
                    Icon(Icons.arrow_outward_rounded,
                        // boyut bilgisini belirler
                        size: 18, color: theme.colorScheme.onSurfaceVariant),
                  ],
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 14),
                // TweenAnimationBuilder nesnesini oluşturur veya kullanır
                TweenAnimationBuilder<double>(
                  // tween bilgisini belirler
                  tween: Tween<double>(end: value.toDouble()),
                  // İşlemin süresini belirler
                  duration: const Duration(milliseconds: 450),
                  // Animasyon geçişini belirler
                  curve: Curves.easeOutCubic,
                  // Güncel verilere göre arayüzü oluşturur
                  builder: (BuildContext context, double v, _) => Text(
                    // İlgili nesne üzerinden metodu çağırır
                    v.round().toString(),
                    // style bilgisini belirler
                    style: theme.textTheme.headlineMedium?.copyWith(
                      // font features bilgisini belirler
                      fontFeatures: const <FontFeature>[
                        // İlgili nesne üzerinden metodu çağırır
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 2),
                // Metin gösterir
                Text(label,
                    // style bilgisini belirler
                    style: theme.textTheme.titleSmall,
                    // Giriş alanının satır sayısını belirler
                    maxLines: 1,
                    // Uzun metnin taşmasını önler
                    overflow: TextOverflow.ellipsis),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 2),
                // Metin gösterir
                Text(caption,
                    // style bilgisini belirler
                    style: theme.textTheme.bodySmall,
                    // Giriş alanının satır sayısını belirler
                    maxLines: 1,
                    // Uzun metnin taşmasını önler
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

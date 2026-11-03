// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import '../theme/app_theme.dart';
// InfoBanner sınıfını tanımlar
class InfoBanner extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const InfoBanner({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // mesaj bilgisini zorunlu tutar
    required this.message,
    // simge için varsayılan değeri belirler
    this.icon = Icons.info_outline_rounded,
    // başlık için varsayılan değeri belirler
    this.title,
    // uyarı için varsayılan değeri belirler
    this.warning = false,
  });
  // mesaj bilgisini tutar
  final String message;
  // başlık bilgisini tutar
  final String? title;
  // simge bilgisini tutar
  final IconData icon;
  // uyarı bilgisini tutar
  final bool warning;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // renk değerini tanımlar
    final Color color =
        // İlgili alanın değerini veya görünümünü ayarlar
        warning ? context.palette.amber : theme.colorScheme.primary;
    // fg durumunu kontrol eder
    final Color fg = theme.brightness == Brightness.dark
        // Koşul doğruysa bu değeri kullanır
        ? color
        // Koşul yanlışsa bu değeri kullanır
        : Color.lerp(color, theme.colorScheme.onSurface, 0.35)!;
    // container değerini hesaplar veya döndürür
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.all(14),
      // Görünüm ayarlarını oluşturur
      decoration: BoxDecoration(
        // Rengini belirler
        color: color.withValues(alpha: 0.10),
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(14),
        // Kenarlık ayarlarını belirler
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // Alt widgetları listeler
        children: <Widget>[
          // Simge gösterir
          Icon(icon, size: 20, color: fg),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(width: 12),
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Değer null değilse işlemi çalıştırır
                if (title != null) ...<Widget>[
                  // Metin gösterir
                  Text(title!,
                      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                      style: theme.textTheme.titleSmall?.copyWith(color: fg)),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 2),
                ],
                // Metin gösterir
                Text(message,
                    // style bilgisini belirler
                    style: theme.textTheme.bodySmall
                        // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                        ?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

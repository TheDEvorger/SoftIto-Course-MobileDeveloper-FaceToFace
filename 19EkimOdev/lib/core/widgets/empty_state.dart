// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// EmptyState sınıfını tanımlar
class EmptyState extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const EmptyState({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // simge bilgisini zorunlu tutar
    required this.icon,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // mesaj bilgisini zorunlu tutar
    required this.message,
    // action için varsayılan değeri belirler
    this.action,
  });
  // simge bilgisini tutar
  final IconData icon;
  // başlık bilgisini tutar
  final String title;
  // mesaj bilgisini tutar
  final String message;
  // action bilgisini tutar
  final Widget? action;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // center değerini hesaplar veya döndürür
    return Center(
      // İçeride gösterilecek widgetı belirler
      child: Padding(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        // İçeride gösterilecek widgetı belirler
        child: Column(
          // Kaplayacağı ana eksen alanını belirler
          mainAxisSize: MainAxisSize.min,
          // Alt widgetları listeler
          children: <Widget>[
            // Görünüm ve yerleşim için kutu oluşturur
            Container(
              // Genişliğini belirler
              width: 72,
              // Yüksekliğini belirler
              height: 72,
              // Görünüm ayarlarını oluşturur
              decoration: BoxDecoration(
                // Rengini belirler
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                // Widgetın şeklini belirler
                shape: BoxShape.circle,
              ),
              // İçeride gösterilecek widgetı belirler
              child: Icon(icon, size: 34, color: theme.colorScheme.primary),
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(height: 16),
            // Metin gösterir
            Text(title,
                // style bilgisini belirler
                style: theme.textTheme.titleMedium,
                // Metnin hizasını belirler
                textAlign: TextAlign.center),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(height: 6),
            // Metin gösterir
            Text(
              // Metodun veya constructorın parametresini tanımlar
              message,
              // style bilgisini belirler
              style: theme.textTheme.bodyMedium
                  // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              // Metnin hizasını belirler
              textAlign: TextAlign.center,
            ),
            // Değer null değilse işlemi çalıştırır
            if (action != null) ...<Widget>[
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // İlgili alanın değerini veya görünümünü ayarlar
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

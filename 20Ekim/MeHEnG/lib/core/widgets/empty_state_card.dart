// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Tema ayarlarını ekler
import '../../app/theme/meheng_theme.dart';
// Boş liste bilgilendirme kartı
class EmptyStateCard extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const EmptyStateCard({
    // Başlık bilgisini zorunlu tutar
    required this.title,
    // Description bilgisini zorunlu tutar
    required this.description,
    // Icon bilgisini isteğe bağlı alır
    this.icon = Icons.inbox_outlined,
    // Action label bilgisini isteğe bağlı alır
    this.actionLabel,
    // On action bilgisini isteğe bağlı alır
    this.onAction,
    // Key bilgisini üst sınıfa gönderir
    super.key,
  });
  // Başlık bilgisini tutar
  final String title;
  // Description bilgisini tutar
  final String description;
  // Icon bilgisini tutar
  final IconData icon;
  // Action label bilgisini tutar
  final String? actionLabel;
  // On action bilgisini tutar
  final VoidCallback? onAction;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Tema bilgisini oluşturur
    final theme = Theme.of(context);
    // Has action bilgisini koşula göre belirler
    final hasAction = actionLabel != null && onAction != null;
    // Erişilebilirlik bilgilerini ekler
    return Semantics(
      // Container özelliğini belirler
      container: true,
      // Gösterilecek etiketi belirler
      label: '$title. $description',
      // İçerideki widgetı belirler
      child: Card(
        // Dış boşlukları ayarlar
        margin: const EdgeInsets.symmetric(vertical: MehengSpacing.xs),
        // İçerideki widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(MehengSpacing.lg),
          // İçerideki widgetı belirler
          child: Column(
            // Ana eksende kaplanan alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçeride gösterilecek elemanları listeler
            children: [
              // Simgeyi gösterir
              Icon(icon, size: 40, color: theme.colorScheme.secondary),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: MehengSpacing.sm),
              // Metni ekranda gösterir
              Text(
                // Başlık metnini widgeta gönderir
                title,
                // Görünüm stilini belirler
                style: theme.textTheme.titleMedium?.copyWith(
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w700,
                ),
                // Metnin hizasını belirler
                textAlign: TextAlign.center,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: MehengSpacing.xs),
              // Metni ekranda gösterir
              Text(
                // Açıklama metnini widgeta gönderir
                description,
                // Görünüm stilini belirler
                style: theme.textTheme.bodyMedium?.copyWith(
                  // Rengi belirler
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                // Metnin hizasını belirler
                textAlign: TextAlign.center,
              ),
              // Koşul doğruysa ilgili işlemi yapar
              if (hasAction) ...[
                // Constructor gerekli bilgileri alır
                const SizedBox(height: MehengSpacing.md),
                // Alanı boyut sınırlarıyla oluşturur
                ConstrainedBox(
                  // Boyut sınırlarını belirler
                  constraints: const BoxConstraints(minHeight: 44),
                  // İçerideki widgetı belirler
                  child: FilledButton.tonalIcon(
                    // Butona basılınca çalışacak işlemi belirler
                    onPressed: onAction,
                    // Butonun simgesini gösterir
                    icon: const Icon(Icons.add, size: 18),
                    // Butonun yazısını gösterir
                    label: Text(actionLabel!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

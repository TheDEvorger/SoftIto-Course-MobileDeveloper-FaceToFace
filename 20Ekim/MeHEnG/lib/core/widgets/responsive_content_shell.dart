// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Tema ayarlarını ekler
import '../../app/theme/meheng_theme.dart';
// Ekran genişliğine uyum sağlayan alan
class ResponsiveContentShell extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const ResponsiveContentShell({
    // Child bilgisini zorunlu tutar
    required this.child,
    // Max width bilgisini isteğe bağlı alır
    this.maxWidth = MehengSpacing.maxContentWidth,
    // Key bilgisini üst sınıfa gönderir
    super.key,
  });
  // Child bilgisini tutar
  final Widget child;
  // Max width bilgisini tutar
  final double maxWidth;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Width bilgisini oluşturur
    final width = MediaQuery.sizeOf(context).width;
    // Horizontal padding bilgisini oluşturur
    final horizontalPadding = width < 600 ? MehengSpacing.md : MehengSpacing.lg;
    // İçeriği ortalar
    return Center(
      // İçerideki widgetı belirler
      child: ConstrainedBox(
        // Boyut sınırlarını belirler
        constraints: BoxConstraints(maxWidth: maxWidth),
        // İçerideki widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: EdgeInsets.symmetric(
            // Horizontal özelliğini belirler
            horizontal: horizontalPadding,
            // Vertical özelliğini belirler
            vertical: MehengSpacing.md,
          ),
          // İçerideki widgetı belirler
          child: FocusTraversalGroup(
            // Policy özelliğini belirler
            policy: OrderedTraversalPolicy(),
            // İçerideki widgetı belirler
            child: child,
          ),
        ),
      ),
    );
  }
}

// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık tema ayarlarını projeye ekler
import '../theme/realm_theme.dart';
// Painter for drawing medieval illuminated manuscript corner filigrees.
// Köşe süslerini Canvas üzerine çizer
class OrnateCornerPainter extends CustomPainter {
  // OrnateCornerPainter nesnesinin başlangıç bilgilerini alır
  const OrnateCornerPainter({
    // color için isteğe bağlı başlangıç değeri alır
    this.color = RealmPalette.gold,
    // stroke width için isteğe bağlı başlangıç değeri alır
    this.strokeWidth = 1.3,
    // boyut için isteğe bağlı başlangıç değeri alır
    this.size = 18.0,
    // inset için isteğe bağlı başlangıç değeri alır
    this.inset = 5.0,
  });
  // color bilgisini saklar
  final Color color;
  // stroke width bilgisini saklar
  final double strokeWidth;
  // boyut bilgisini saklar
  final double size;
  // inset bilgisini saklar
  final double inset;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Canvas üzerine krallık çiziminin parçalarını işler
  void paint(Canvas canvas, Size canvasSize) {
    // paint bilgisini saklar
    final paint = Paint()
      // Fırçanın rengini belirler
      ..color = color
      // Çizgi kalınlığını belirler
      ..strokeWidth = strokeWidth
      // Çizgi kalınlığını belirler
      ..style = PaintingStyle.stroke
      // Çizgi kalınlığını belirler
      ..strokeCap = StrokeCap.round;
    // dot paint bilgisini saklar
    final dotPaint = Paint()
      // Fırçanın rengini belirler
      ..color = color
      // Çizimin dolgu veya kenarlık tipini belirler
      ..style = PaintingStyle.fill;
    // w bilgisini saklar
    final w = canvasSize.width;
    // h bilgisini saklar
    final h = canvasSize.height;
    // s bilgisini saklar
    final s = size;
    // i bilgisini saklar
    final i = inset;
    // Helper to draw a single ornate corner with L-bracket and inner leaf arc
    // Verilen noktadan başlayarak süslü köşe çizgilerini çizer
    void drawCorner(double cx, double cy, double dirX, double dirY) {
      // Outer bracket lines
      // İki nokta arasına çizgi çizer
      canvas.drawLine(
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx, cy + dirY * s),
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx, cy),
        // Çizime hazırlanan fırça ayarlarını verir
        paint,
      );
      // İki nokta arasına çizgi çizer
      canvas.drawLine(
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx, cy),
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx + dirX * s, cy),
        // Çizime hazırlanan fırça ayarlarını verir
        paint,
      );
      // Inner ornate curve
      // arc path bilgisini saklar
      final arcPath = Path()
        // Çizim yolunun başlangıç noktasını belirler
        ..moveTo(cx + dirX * (s * 0.7), cy + dirY * 3)
        // İki noktayı yumuşak eğriyle bağlar
        ..quadraticBezierTo(
          // Köşe süsünün yatay koordinatını çizim yönüne göre hesaplar
          cx + dirX * 3,
          // Köşe süsünün dikey koordinatını çizim yönüne göre hesaplar
          cy + dirY * 3,
          // Köşe süsünün yatay koordinatını çizim yönüne göre hesaplar
          cx + dirX * 3,
          // Köşe süsünün dikey uzunluğunu ölçeğe göre hesaplar
          cy + dirY * (s * 0.7),
        );
      // Hazırlanan çizgi yolunu Canvas üzerine çizer
      canvas.drawPath(arcPath, paint);
      // Corner jewel dot
      // Verilen konuma daire çizer
      canvas.drawCircle(
          // Çizim için x ve y koordinatlarını belirler
          Offset(cx + dirX * 3.5, cy + dirY * 3.5), 1.6, dotPaint);
      // Outer accent dot
      // Verilen konuma daire çizer
      canvas.drawCircle(Offset(cx + dirX * s, cy), 1.2, dotPaint);
      // Verilen konuma daire çizer
      canvas.drawCircle(Offset(cx, cy + dirY * s), 1.2, dotPaint);
    }
    // Top-Left
    // Verilen noktadan başlayarak süslü köşe çizgilerini çizer
    drawCorner(i, i, 1, 1);
    // Top-Right
    // Verilen noktadan başlayarak süslü köşe çizgilerini çizer
    drawCorner(w - i, i, -1, 1);
    // Bottom-Left
    // Verilen noktadan başlayarak süslü köşe çizgilerini çizer
    drawCorner(i, h - i, 1, -1);
    // Bottom-Right
    // Verilen noktadan başlayarak süslü köşe çizgilerini çizer
    drawCorner(w - i, h - i, -1, -1);
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Çizim verileri değiştiğinde tekrar çizim gerekip gerekmediğini belirler
  bool shouldRepaint(covariant OrnateCornerPainter oldDelegate) =>
      // Bu koşuldaki değerleri karşılaştırır
      color != oldDelegate.color ||
      // Bu koşuldaki değerleri karşılaştırır
      strokeWidth != oldDelegate.strokeWidth ||
      // Bu koşuldaki değerleri karşılaştırır
      size != oldDelegate.size ||
      // Bu koşuldaki değerleri karşılaştırır
      inset != oldDelegate.inset;
}
// Ornate gilded divider with a central heraldic motif.
// Süslü bölüm ayırıcı çizgisini oluşturur
class HeraldicDivider extends StatelessWidget {
  // HeraldicDivider nesnesinin başlangıç bilgilerini alır
  const HeraldicDivider({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // color için isteğe bağlı başlangıç değeri alır
    this.color = const Color(0xFFDCC898),
    // accent color için isteğe bağlı başlangıç değeri alır
    this.accentColor = RealmPalette.gold,
    // icon için isteğe bağlı başlangıç değeri alır
    this.icon = Icons.auto_awesome,
  });
  // color bilgisini saklar
  final Color color;
  // accent color bilgisini saklar
  final Color accentColor;
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // HeraldicDivider için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // İçeriğin çevresine boşluk ekler
    return Padding(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(vertical: 8),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Row(
        // İçeride sıralanacak widgetları listeler
        children: [
          // İçeriğin kalan alanı doldurmasını sağlar
          Expanded(
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Container(
              // Elemanın veya satırın yüksekliğini ayarlar
              height: 1.2,
              // Kutunun arka plan, kenar ve süslerini ayarlar
              decoration: BoxDecoration(
                // Birden fazla rengin geçişini tanımlar
                gradient: LinearGradient(
                  // Renk geçişinde kullanılacak renkleri listeler
                  colors: [color.withValues(alpha: 0.1), color],
                ),
              ),
            ),
          ),
          // İçeriğin çevresine boşluk ekler
          Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Row(
              // Ana yönde kaplanacak alanı belirler
              mainAxisSize: MainAxisSize.min,
              // İçeride sıralanacak widgetları listeler
              children: [
                // Ekrana bir simge yerleştirir
                Icon(Icons.diamond_outlined, size: 10, color: accentColor),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(width: 4),
                // Ekrana bir simge yerleştirir
                Icon(icon, size: 14, color: accentColor),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(width: 4),
                // Ekrana bir simge yerleştirir
                Icon(Icons.diamond_outlined, size: 10, color: accentColor),
              ],
            ),
          ),
          // İçeriğin kalan alanı doldurmasını sağlar
          Expanded(
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Container(
              // Elemanın veya satırın yüksekliğini ayarlar
              height: 1.2,
              // Kutunun arka plan, kenar ve süslerini ayarlar
              decoration: BoxDecoration(
                // Birden fazla rengin geçişini tanımlar
                gradient: LinearGradient(
                  // Renk geçişinde kullanılacak renkleri listeler
                  colors: [color, color.withValues(alpha: 0.1)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Royal wax seal stamp for proclamations, completed habits, and achievements.
// Krallık mührünü arayüzde gösterir
class HeraldicSeal extends StatelessWidget {
  // HeraldicSeal nesnesinin başlangıç bilgilerini alır
  const HeraldicSeal({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // icon parametresini zorunlu tutar
    required this.icon,
    // boyut için isteğe bağlı başlangıç değeri alır
    this.size = 38,
    // color için isteğe bağlı başlangıç değeri alır
    this.color = const Color(0xFF9E2A2B),
    // border color için isteğe bağlı başlangıç değeri alır
    this.borderColor = const Color(0xFFFFD166),
    // icon color için isteğe bağlı başlangıç değeri alır
    this.iconColor = Colors.white,
  });
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // boyut bilgisini saklar
  final double size;
  // color bilgisini saklar
  final Color color;
  // border color bilgisini saklar
  final Color borderColor;
  // icon color bilgisini saklar
  final Color iconColor;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // HeraldicSeal için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // Elemanın genişliğini belirler
      width: size,
      // Elemanın veya satırın yüksekliğini ayarlar
      height: size,
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Kutunun veya butonun geometrik biçimini belirler
        shape: BoxShape.circle,
        // Bu elemanın rengini belirler
        color: color,
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: borderColor, width: 1.8),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: color.withValues(alpha: 0.35),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 8,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, 3),
          ),
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: borderColor.withValues(alpha: 0.25),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 3,
            // Gölgenin yayılma miktarını belirler
            spreadRadius: 1,
          ),
        ],
        // Birden fazla rengin geçişini tanımlar
        gradient: RadialGradient(
          // Renk geçişinde kullanılacak renkleri listeler
          colors: [
            // Verilen iki renk arasında yumuşak geçiş hesaplar
            Color.lerp(color, Colors.white, 0.25)!,
            // Geçerli renk değerini çizimde kullanır
            color,
            // Verilen iki renk arasında yumuşak geçiş hesaplar
            Color.lerp(color, Colors.black, 0.25)!,
          ],
        ),
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Center(
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Icon(icon, color: iconColor, size: size * 0.52),
      ),
    );
  }
}

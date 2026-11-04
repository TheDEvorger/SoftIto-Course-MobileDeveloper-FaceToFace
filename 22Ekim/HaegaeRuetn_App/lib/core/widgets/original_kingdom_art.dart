// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Original, code-drawn scenery. No external image files or third-party art.
// Each age supplies its own colors. This can later be replaced by commissioned art.
// Krallık manzarasını özel painter ile gösterir
class OriginalKingdomArt extends StatelessWidget {
  // OriginalKingdomArt nesnesinin başlangıç bilgilerini alır
  const OriginalKingdomArt(
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {super.key,
      // sky parametresini zorunlu tutar
      required this.sky,
      // land parametresini zorunlu tutar
      required this.land,
      // highlight parametresini zorunlu tutar
      required this.highlight,
      // height için isteğe bağlı başlangıç değeri alır
      this.height = 220});
  // sky bilgisini saklar
  final Color sky;
  // land bilgisini saklar
  final Color land;
  // highlight bilgisini saklar
  final Color highlight;
  // height bilgisini saklar
  final double height;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // OriginalKingdomArt için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => SizedBox(
        // Elemanın genişliğini belirler
        width: double.infinity,
        // Elemanın veya satırın yüksekliğini ayarlar
        height: height,
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: ClipRRect(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(22),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: CustomPaint(painter: _KingdomPainter(sky, land, highlight)),
        ),
      );
}
// Krallık manzarasındaki dağları, binaları ve süsleri çizer
class _KingdomPainter extends CustomPainter {
  // kingdom painter nesnesi için gereken başlangıç bilgilerini alır
  _KingdomPainter(this.sky, this.land, this.highlight);
  // sky bilgisini saklar
  final Color sky;
  // land bilgisini saklar
  final Color land;
  // highlight bilgisini saklar
  final Color highlight;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Canvas üzerine krallık çiziminin parçalarını işler
  void paint(Canvas canvas, Size size) {
    // w bilgisini saklar
    final w = size.width, h = size.height;
    // bg bilgisini saklar
    final bg = Paint()
      // Aynı nesnede ek çizim ayarını yapar
      ..shader = LinearGradient(
        // Renk geçişinin başlayacağı yönü belirler
        begin: Alignment.topLeft,
        // Renk geçişinin biteceği yönü belirler
        end: Alignment.bottomRight,
        // Renk geçişinde kullanılacak renkleri listeler
        colors: [
          // Gökyüzü çiziminin fırçasını kullanır
          sky,
          // Verilen iki renk arasında yumuşak geçiş hesaplar
          Color.lerp(sky, Colors.white, .58)!,
          // Verilen iki renk arasında yumuşak geçiş hesaplar
          Color.lerp(land, Colors.white, .55)!
        ],
      // Renk geçişini çizimde kullanılacak shader hâline getirir
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    // Canvas üzerine dikdörtgen çizer
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bg);
    // sun bilgisini saklar
    final sun = Paint()..color = highlight.withValues(alpha: .85);
    // Verilen konuma daire çizer
    canvas.drawCircle(Offset(w * .79, h * .22), h * .135, sun);
    // Verilen konuma daire çizer
    canvas.drawCircle(Offset(w * .79, h * .22), h * .18,
        // Çizim rengini, stilini ve kalınlığını belirler
        Paint()..color = highlight.withValues(alpha: .14));
    // Verilen zirve noktalarından dağ silueti çizer
    void mountain(double y, Color c, List<Offset> peaks) {
      // p bilgisini saklar
      final p = Path()..moveTo(0, h);
      // Çizim yoluna yeni koordinat ekler
      p.lineTo(0, y);
      // Koleksiyondaki her öğeyi sırayla işler
      for (final peak in peaks) {
        // Çizim yoluna yeni koordinat ekler
        p.lineTo(peak.dx * w, peak.dy * h);
      }
      // Çizim yoluna yeni koordinat ekler
      p.lineTo(w, h);
      // Dağ siluetinin çizim yolunu kapatır
      p.close();
      // Hazırlanan çizgi yolunu Canvas üzerine çizer
      canvas.drawPath(p, Paint()..color = c);
    }
    // Verilen zirve noktalarından dağ silueti çizer
    mountain(h * .68, Color.lerp(sky, land, .30)!, [
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.13, .47),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.23, .62),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.39, .35),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.56, .66),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.73, .45),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(1, .67),
    ]);
    // Verilen zirve noktalarından dağ silueti çizer
    mountain(h * .74, Color.lerp(land, Colors.white, .45)!, [
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.16, .66),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.30, .75),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.54, .55),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.76, .76),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(.89, .60),
      // Çizim için x ve y koordinatlarını belirler
      const Offset(1, .69),
    ]);
    // hill bilgisini saklar
    final hill = Path()
      // Çizim yolunun başlangıç noktasını belirler
      ..moveTo(0, h * .79)
      // İki noktayı yumuşak eğriyle bağlar
      ..quadraticBezierTo(w * .28, h * .60, w * .51, h * .81)
      // İki noktayı yumuşak eğriyle bağlar
      ..quadraticBezierTo(w * .75, h * .95, w, h * .70)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(w, h)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(0, h)
      // Çizim yolunun uçlarını birleştirir
      ..close();
    // Hazırlanan çizgi yolunu Canvas üzerine çizer
    canvas.drawPath(hill, Paint()..color = land);
    // road bilgisini saklar
    final road = Path()
      // Çizim yolunun başlangıç noktasını belirler
      ..moveTo(w * .51, h)
      // Üç kontrol noktasıyla eğri oluşturur
      ..cubicTo(w * .47, h * .84, w * .55, h * .82, w * .54, h * .73)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(w * .60, h * .73)
      // Üç kontrol noktasıyla eğri oluşturur
      ..cubicTo(w * .59, h * .85, w * .63, h * .92, w * .66, h)
      // Çizim yolunun uçlarını birleştirir
      ..close();
    // Hazırlanan çizgi yolunu Canvas üzerine çizer
    canvas.drawPath(road, Paint()..color = highlight.withValues(alpha: .43));
    // Original simple keep silhouette with warm highlights.
    // stone için sabit rengi belirler
    final stone = Paint()..color = const Color(0xFFFFF5DC);
    // edge bilgisini saklar
    final edge = Paint()..color = land.withValues(alpha: .47);
    // cx için güncel toplamı hesaplar
    final cx = w * .56, base = h * .75;
    // Köşeleri yuvarlak dikdörtgen çizer
    canvas.drawRRect(
        // rrect.from rect and radius bileşenini oluşturur
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - 39, base - 58, 78, 62),
            // Radius nesnesi için başlangıç değerlerini alır
            const Radius.circular(3)),
        // Taş yüzey için hazırlanan fırçayı kullanır
        stone);
    // Canvas üzerine dikdörtgen çizer
    canvas.drawRect(Rect.fromLTWH(cx - 25, base - 80, 50, 30), stone);
    // Canvas üzerine dikdörtgen çizer
    canvas.drawRect(Rect.fromLTWH(cx - 13, base - 108, 26, 32), stone);
    // Sayaçla sıradaki elemanı veya çizim adımını işler
    for (var i = -1; i <= 1; i++) {
      // Canvas üzerine dikdörtgen çizer
      canvas.drawRect(Rect.fromLTWH(cx + i * 24 - 7, base - 66, 14, 13), stone);
    }
    // roof bilgisini saklar
    final roof = Path()
      // Çizim yolunun başlangıç noktasını belirler
      ..moveTo(cx - 19, base - 107)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(cx, base - 134)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(cx + 19, base - 107)
      // Çizim yolunun uçlarını birleştirir
      ..close();
    // Hazırlanan çizgi yolunu Canvas üzerine çizer
    canvas.drawPath(roof, Paint()..color = highlight);
    // Canvas üzerine dikdörtgen çizer
    canvas.drawRect(Rect.fromLTWH(cx - 5, base - 45, 11, 17), edge);
    // Köşeleri yuvarlak dikdörtgen çizer
    canvas.drawRRect(
        // rrect.from rect and radius bileşenini oluşturur
        RRect.fromRectAndRadius(
            // rect.from ltwh bileşenini oluşturur
            Rect.fromLTWH(cx - 8, base - 22, 16, 26), const Radius.circular(8)),
        // Kenar çizgilerinde kullanılan fırçayı seçer
        edge);
    // İki nokta arasına çizgi çizer
    canvas.drawLine(
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx, base - 134),
        // Çizim için x ve y koordinatlarını belirler
        Offset(cx, base - 153),
        // Çizim rengini, stilini ve kalınlığını belirler
        Paint()
          // Fırçanın rengini belirler
          ..color = const Color(0xFF5D647F)
          // Çizgi kalınlığını belirler
          ..strokeWidth = 2);
    // flag bilgisini saklar
    final flag = Path()
      // Çizim yolunun başlangıç noktasını belirler
      ..moveTo(cx, base - 153)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(cx + 22, base - 147)
      // Çizim yoluna yeni doğru parçası ekler
      ..lineTo(cx, base - 140)
      // Çizim yolunun uçlarını birleştirir
      ..close();
    // Hazırlanan çizgi yolunu Canvas üzerine çizer
    canvas.drawPath(flag, Paint()..color = const Color(0xFFD66E6B));
    // Two rows of original stylized trees, no external sprites.
    // Koleksiyondaki her öğeyi sırayla işler
    for (final tree in const <Offset>[
      // Çizim için x ve y koordinatlarını belirler
      Offset(.07, .81),
      // Çizim için x ve y koordinatlarını belirler
      Offset(.14, .85),
      // Çizim için x ve y koordinatlarını belirler
      Offset(.25, .83),
      // Çizim için x ve y koordinatlarını belirler
      Offset(.79, .85),
      // Çizim için x ve y koordinatlarını belirler
      Offset(.87, .80),
      // Çizim için x ve y koordinatlarını belirler
      Offset(.95, .89)
    ]) {
      // x için güncel toplamı hesaplar
      final x = w * tree.dx, y = h * tree.dy;
      // Canvas üzerine dikdörtgen çizer
      canvas.drawRect(Rect.fromLTWH(x - 2, y - 16, 4, 21),
          // Çizim rengini, stilini ve kalınlığını belirler
          Paint()..color = const Color(0xFF987B59));
      // Sayaçla sıradaki elemanı veya çizim adımını işler
      for (var j = 0; j < 3; j++) {
        // Verilen konuma daire çizer
        canvas.drawCircle(
            // Çizim için x ve y koordinatlarını belirler
            Offset(x + (j - 1) * 6, y - 20 - (j % 2) * 8),
            // Sıraya göre değişen kule yüksekliğini hesaplar
            12 + j % 2 * 3,
            // Çizim rengini, stilini ve kalınlığını belirler
            Paint()
              // Fırçanın rengini belirler
              ..color =
                  // Verilen iki renk arasında yumuşak geçiş hesaplar
                  Color.lerp(land, const Color(0xFF167E57), .40 + j * .13)!);
      }
    }
    // Sayaçla sıradaki elemanı veya çizim adımını işler
    for (var i = 0; i < 17; i++) {
      // x için güncel toplamı hesaplar
      final x = w * ((i * 41 % 97) / 100), y = h * (.15 + (i * 23 % 42) / 100);
      // r için güncel toplamı hesaplar
      final r = 1.0 + (i % 3) * .5;
      // Verilen konuma daire çizer
      canvas.drawCircle(Offset(x, y), r,
          // Çizim rengini, stilini ve kalınlığını belirler
          Paint()..color = Colors.white.withValues(alpha: .75));
      // Belirtilen koşul sağlanırsa bu işlemi uygular
      if (i % 5 == 0) {
        // İki nokta arasına çizgi çizer
        canvas.drawLine(
            // Çizim için x ve y koordinatlarını belirler
            Offset(x - 4, y),
            // Çizim için x ve y koordinatlarını belirler
            Offset(x + 4, y),
            // Çizim rengini, stilini ve kalınlığını belirler
            Paint()
              // Fırçanın rengini belirler
              ..color = Colors.white.withValues(alpha: .55)
              // Çizgi kalınlığını belirler
              ..strokeWidth = .8);
        // İki nokta arasına çizgi çizer
        canvas.drawLine(
            // Çizim için x ve y koordinatlarını belirler
            Offset(x, y - 4),
            // Çizim için x ve y koordinatlarını belirler
            Offset(x, y + 4),
            // Çizim rengini, stilini ve kalınlığını belirler
            Paint()
              // Fırçanın rengini belirler
              ..color = Colors.white.withValues(alpha: .55)
              // Çizgi kalınlığını belirler
              ..strokeWidth = .8);
      }
    }
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Çizim verileri değiştiğinde tekrar çizim gerekip gerekmediğini belirler
  bool shouldRepaint(covariant _KingdomPainter old) =>
      // Bu koşuldaki değerleri karşılaştırır
      old.sky != sky || old.land != land || old.highlight != highlight;
}

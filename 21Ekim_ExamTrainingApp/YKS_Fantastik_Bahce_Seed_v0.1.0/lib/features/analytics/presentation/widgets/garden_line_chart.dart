// Matematiksel işlem fonksiyonlarını ekler
import 'dart:math' as math;
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../../core/theme/garden_palette.dart';
// analytics models dosyasını kullanıma ekler
import '../../domain/analytics_models.dart';
// garden line chart için değişen verileri yöneten StatefulWidget kullanılır
class GardenLineChart extends StatefulWidget {
  // garden line chart nesnesini oluşturur
  const GardenLineChart({
    // noktalar bilgisini zorunlu tutar
    required this.points,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 220,
    // çizgi rengi bilgisini isteğe bağlı alır
    this.lineColor = GardenPalette.mossEmerald,
    // unit bilgisini isteğe bağlı alır
    this.unit = 'Net',
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // noktalar bilgisini tutar
  final List<AnalyticsDataPoint> points;
  // yükseklik bilgisini tutar
  final double height;
  // çizgi rengi bilgisini tutar
  final Color lineColor;
  // unit bilgisini tutar
  final String unit;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<GardenLineChart> createState() => _GardenLineChartState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _GardenLineChartState extends State<GardenLineChart> {
  // seçilen indeks bilgisini tutar
  int? _selectedIndex;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Liste veya metin boşsa bu koşul çalışır
    if (widget.points.isEmpty) {
      // Görsel bir kutu oluşturur
      return Container(
        // Yüksekliği belirler
        height: widget.height,
        // İçeriğin hizalanmasını belirler
        alignment: Alignment.center,
        // İç boşlukları belirler
        padding: const EdgeInsets.all(24),
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Rengi belirler
          color: Theme.of(context).cardColor,
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(18),
          // Kenarlığı belirler
          border: Border.all(
            // Rengi belirler
            color: GardenPalette.mossEmerald.withAlpha(40),
          ),
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // Ana eksendeki hizalamayı belirler
          mainAxisAlignment: MainAxisAlignment.center,
          // İçerideki widgetları listeler
          children: [
            // Simge gösterir
            Icon(
              // Gösterilecek simgeyi belirler
              Icons.show_chart,
              // Boyutu belirler
              size: 42,
              // Rengi belirler
              color: Colors.grey.shade400,
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 10),
            // Metni ekranda gösterir
            const Text(
              // "Henüz Kayıtlı Deneme Verisi Yok" metnini kullanır
              'Henüz Kayıtlı Deneme Verisi Yok',
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Yazı boyutunu belirler
                fontSize: 14,
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 4),
            // Metni ekranda gösterir
            Text(
              // "Denemeler sekmesinden yeni denemeler ekledi…" metnini kullanır
              'Denemeler sekmesinden yeni denemeler ekledikçe gelişim grafiğin burada canlanacak.',
              // Yazıyı hizalar
              textAlign: TextAlign.center,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 12,
                // Rengi belirler
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }
    // Accessible description for screen readers
    // latest bilgisini hesaplayıp saklar
    final latest = widget.points.last;
    // semantic summary bilgisini hesaplayıp saklar
    final semanticSummary = widget.points.length >= 2
        // Koşul doğruysa bu değeri kullanır
        ? 'Net gelişim grafiği: Toplam ${widget.points.length} deneme. Son deneme "${latest.title}", ${latest.net.toStringAsFixed(2)} net.'
        // Koşul yanlışsa bu değeri kullanır
        : 'Tek deneme kaydı: "${latest.title}", ${latest.net.toStringAsFixed(2)} net. Trend için en az 2 deneme gerekir.';
    // Erişilebilirlik açıklaması ekler
    return Semantics(
      // Buton veya alan yazısını belirler
      label: semanticSummary,
      // İçine yerleştirilecek widgetı belirler
      child: Column(
        // Çapraz eksendeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // İçerideki widgetları listeler
        children: [
          // Selected point banner (Tooltip detail)
          // İlgili değer null değilse kontrol eder
          if (_selectedIndex != null &&
              // Öğe veya karakter sayısını kullanır
              _selectedIndex! < widget.points.length) ...[
            // seçilen tooltip bilgisini oluşturur
            _buildSelectedTooltip(widget.points[_selectedIndex!]),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
          // Öğe veya karakter sayısını kullanır
          ] else if (widget.points.length == 1) ...[
            // Görsel bir kutu oluşturur
            Container(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              // Kutu ve kenarlık görünümünü belirler
              decoration: BoxDecoration(
                // Rengi belirler
                color: GardenPalette.mossEmerald.withAlpha(25),
                // Köşelerin yuvarlaklığını belirler
                borderRadius: BorderRadius.circular(12),
                // Kenarlığı belirler
                border: Border.all(
                  // Rengi belirler
                  color: GardenPalette.mossEmerald.withAlpha(60),
                ),
              ),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  const Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.info_outline,
                    // Boyutu belirler
                    size: 16,
                    // Rengi belirler
                    color: GardenPalette.mossEmerald,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // "İlk denemen kaydedildi (${latest.net.toStri…" metnini kullanır
                      'İlk denemen kaydedildi (${latest.net.toStringAsFixed(2)} Net). Trend çizgisi 2. denemeden sonra oluşacak.',
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w600,
                        // Rengi belirler
                        color: GardenPalette.inkPlum,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
          ],
          // Chart Canvas
          // Görsel bir kutu oluşturur
          Container(
            // Yüksekliği belirler
            height: widget.height,
            // İç boşlukları belirler
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Rengi belirler
              color: Theme.of(context).cardColor,
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(20),
              // Kenarlığı belirler
              border: Border.all(
                // Rengi belirler
                color: widget.lineColor.withAlpha(45),
                // Genişliği belirler
                width: 1.2,
              ),
              // Gölge ayarlarını belirler
              boxShadow: [
                // Kutuya gölge ayarı ekler
                BoxShadow(
                  // Rengi belirler
                  color: widget.lineColor.withAlpha(15),
                  // Gölgenin bulanıklığını belirler
                  blurRadius: 16,
                  // Gölgenin konumunu belirler
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // İçine yerleştirilecek widgetı belirler
            child: LayoutBuilder(
              // Gelen verilerle arayüzü oluşturur
              builder: (context, constraints) {
                // Dokunma hareketlerini dinler
                return GestureDetector(
                  // on tap down olayındaki fonksiyonu belirler
                  onTapDown: (details) {
                    // tap bilgisini işler
                    _handleTap(details.localPosition, constraints.maxWidth);
                  },
                  // İçine yerleştirilecek widgetı belirler
                  child: CustomPaint(
                    // Boyutu belirler
                    size: Size(constraints.maxWidth, widget.height - 32),
                    // painter bilgisini belirler
                    painter: _GardenChartPainter(
                      // noktalar bilgisini belirler
                      points: widget.points,
                      // çizgi rengi bilgisini belirler
                      lineColor: widget.lineColor,
                      // Seçili sekmenin indeksini belirler
                      selectedIndex: _selectedIndex,
                      // Koyu tema durumunu belirler
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                );
              },
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 6),
          // Legend / info footer
          // Elemanları yan yana dizer
          Row(
            // Ana eksendeki hizalamayı belirler
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              Text(
                // "İlk: ${_formatDate(widget.points.first.date)}" metnini kullanır
                'İlk: ${_formatDate(widget.points.first.date)}',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 11,
                  // Rengi belirler
                  color: Colors.grey.shade600,
                ),
              ),
              // Metni ekranda gösterir
              Text(
                // "Detay için noktalara dokunun" metnini kullanır
                'Detay için noktalara dokunun',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 11,
                  // Yazının italik olup olmadığını belirler
                  fontStyle: FontStyle.italic,
                  // Rengi belirler
                  color: Colors.grey.shade500,
                ),
              ),
              // Metni ekranda gösterir
              Text(
                // "Son: ${_formatDate(widget.points.last.date)}" metnini kullanır
                'Son: ${_formatDate(widget.points.last.date)}',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 11,
                  // Rengi belirler
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // tap bilgisini işler
  void _handleTap(Offset localPosition, double width) {
    // Liste veya metin boşsa bu koşul çalışır
    if (widget.points.isEmpty) return;
    // Belirtilen koşul doğruysa işlemi yapar
    if (widget.points.length == 1) {
      // Değişen verileri arayüze bildirir
      setState(() => _selectedIndex = 0);
      // Metodu burada bitirir
      return;
    }
    // chart padding için başlangıç sayısını belirler
    const chartPadding = 24.0;
    // usable width bilgisini hesaplayıp saklar
    final usableWidth = width - (chartPadding * 2);
    // step bilgisini hesaplayıp saklar
    final step = usableWidth / (widget.points.length - 1);
    // closest index için başlangıç sayısını belirler
    int closestIndex = 0;
    // min distance bilgisini hesaplayıp saklar
    double minDistance = double.infinity;
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 0; i < widget.points.length; i++) {
      // point x bilgisini hesaplayıp saklar
      final pointX = chartPadding + (i * step);
      // distance bilgisini hesaplayıp saklar
      final distance = (localPosition.dx - pointX).abs();
      // Belirtilen koşul doğruysa işlemi yapar
      if (distance < minDistance) {
        // min distance değerini günceller
        minDistance = distance;
        // closest index değerini günceller
        closestIndex = i;
      }
    }
    // Değişen verileri arayüze bildirir
    setState(() {
      // seçilen indeks değerini günceller
      _selectedIndex = closestIndex;
    });
  }
  // seçilen tooltip bilgisini oluşturur
  Widget _buildSelectedTooltip(AnalyticsDataPoint point) {
    // Görsel bir kutu oluşturur
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: GardenPalette.inkPlum,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(14),
        // Gölge ayarlarını belirler
        boxShadow: [
          // Kutuya gölge ayarı ekler
          BoxShadow(
            // Rengi belirler
            color: Colors.black.withAlpha(40),
            // Gölgenin bulanıklığını belirler
            blurRadius: 8,
            // Gölgenin konumunu belirler
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // İçerideki widgetları listeler
        children: [
          // Görsel bir kutu oluşturur
          Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(6),
            // Kutu ve kenarlık görünümünü belirler
            decoration: const BoxDecoration(
              // Rengi belirler
              color: GardenPalette.harvestGold,
              // Widgetın kenar şeklini belirler
              shape: BoxShape.circle,
            ),
            // İçine yerleştirilecek widgetı belirler
            child: const Icon(
              // Gösterilecek simgeyi belirler
              Icons.stars,
              // Boyutu belirler
              size: 14,
              // Rengi belirler
              color: GardenPalette.inkPlum,
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(width: 10),
          // Kalan boşluğu kullanacak alan oluşturur
          Expanded(
            // İçine yerleştirilecek widgetı belirler
            child: Column(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçerideki widgetları listeler
              children: [
                // Metni ekranda gösterir
                Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  point.title,
                  // Görünüm stilini belirler
                  style: const TextStyle(
                    // Rengi belirler
                    color: Colors.white,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                    // Yazı boyutunu belirler
                    fontSize: 13,
                  ),
                  // Gösterilecek en fazla satır sayısını belirler
                  maxLines: 1,
                  // Uzun yazının taşma şeklini belirler
                  overflow: TextOverflow.ellipsis,
                ),
                // Metni ekranda gösterir
                Text(
                  // tarih bilgisini biçimlendirir
                  _formatDate(point.date),
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Rengi belirler
                    color: Colors.white.withAlpha(180),
                    // Yazı boyutunu belirler
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Görsel bir kutu oluşturur
          Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Rengi belirler
              color: GardenPalette.mossEmerald,
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(8),
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Text(
              // "${point.net.toStringAsFixed(2)} ${widget.unit}" metnini kullanır
              '${point.net.toStringAsFixed(2)} ${widget.unit}',
              // Görünüm stilini belirler
              style: const TextStyle(
                // Rengi belirler
                color: Colors.white,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Yazı boyutunu belirler
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // tarih bilgisini biçimlendirir
  String _formatDate(DateTime dt) {
    // "${dt.day.toString().padLeft(2, '0')}.${dt.m…" metnini kullanır
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}
// garden chart painter çizimini yapan sınıf
class _GardenChartPainter extends CustomPainter {
  // İlgili fonksiyonu çalıştırır
  _GardenChartPainter({
    // noktalar bilgisini zorunlu tutar
    required this.points,
    // çizgi rengi bilgisini zorunlu tutar
    required this.lineColor,
    // seçilen indeks bilgisini zorunlu tutar
    required this.selectedIndex,
    // koyu tema durumu bilgisini zorunlu tutar
    required this.isDark,
  });
  // noktalar bilgisini tutar
  final List<AnalyticsDataPoint> points;
  // çizgi rengi bilgisini tutar
  final Color lineColor;
  // seçilen indeks bilgisini tutar
  final int? selectedIndex;
  // koyu tema durumu bilgisini tutar
  final bool isDark;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Canvas üzerine gerekli şekilleri çizer
  void paint(Canvas canvas, Size size) {
    // Liste veya metin boşsa bu koşul çalışır
    if (points.isEmpty) return;
    // chart padding için başlangıç sayısını belirler
    const chartPadding = 24.0;
    // usable width bilgisini hesaplayıp saklar
    final usableWidth = size.width - (chartPadding * 2);
    // top padding için başlangıç sayısını belirler
    const topPadding = 16.0;
    // bottom padding için başlangıç sayısını belirler
    const bottomPadding = 18.0;
    // usable height bilgisini hesaplayıp saklar
    final usableHeight = size.height - topPadding - bottomPadding;
    // Calculate Min and Max Net with nice buffer
    // min net için listedeki öğeleri dönüştürür
    double minNet = points.map((p) => p.net).reduce(math.min);
    // max net için listedeki öğeleri dönüştürür
    double maxNet = points.map((p) => p.net).reduce(math.max);
    // Belirtilen koşul doğruysa işlemi yapar
    if ((maxNet - minNet).abs() < 2.0) {
      // max işlemini yapar
      minNet = math.max(0, minNet - 5);
      // max net değerini günceller
      maxNet = maxNet + 5;
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // range bilgisini hesaplayıp saklar
      final range = maxNet - minNet;
      // max işlemini yapar
      minNet = math.max(0, minNet - (range * 0.15));
      // max net değerini günceller
      maxNet = maxNet + (range * 0.15);
    }
    // range bilgisini iki değeri karşılaştırarak hesaplar
    final double range = maxNet - minNet == 0 ? 1.0 : (maxNet - minNet);
    // Grid lines (3 horizontal lines: min, mid, max)
    // grid paint bilgisini hesaplayıp saklar
    final gridPaint = Paint()
      // Rengin saydamlık değerini ayarlar
      ..color = (isDark ? Colors.white : Colors.black).withAlpha(20)
      // Aynı nesne üzerinde ek ayar yapar
      ..style = PaintingStyle.stroke
      // Aynı nesne üzerinde ek ayar yapar
      ..strokeWidth = 1.0;
    // metin style bilgisini hesaplayıp saklar
    final textStyle = TextStyle(
      // Rengi belirler
      color: (isDark ? Colors.white : Colors.black).withAlpha(120),
      // Yazı boyutunu belirler
      fontSize: 10,
      // Yazı kalınlığını belirler
      fontWeight: FontWeight.w500,
    );
    // Draw reference horizontal grid lines & labels
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 0; i <= 2; i++) {
      // y ratio bilgisini hesaplayıp saklar
      final yRatio = i / 2.0;
      // y konumu bilgisini hesaplayıp saklar
      final y = topPadding + (usableHeight * (1.0 - yRatio));
      // val bilgisini hesaplayıp saklar
      final val = minNet + (range * yRatio);
      // İlgili fonksiyonu çalıştırır
      canvas.drawLine(
        // offset nesnesini oluşturur
        Offset(chartPadding, y),
        // offset nesnesini oluşturur
        Offset(size.width - chartPadding, y),
        // İlgili değeri veya görünüm ayarını belirler
        gridPaint,
      );
      // span bilgisini hesaplayıp saklar
      final span = TextSpan(text: val.toStringAsFixed(1), style: textStyle);
      // tp bilgisini hesaplayıp saklar
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      // layout işlemini yapar
      tp.layout();
      // çizim fırçası işlemini yapar
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    // Single point case
    // Belirtilen koşul doğruysa işlemi yapar
    if (points.length == 1) {
      // center x bilgisini hesaplayıp saklar
      final centerX = size.width / 2;
      // net ratio değerini belirli aralıkta sınırlar
      final netRatio = ((points.first.net - minNet) / range).clamp(0.0, 1.0);
      // center y bilgisini hesaplayıp saklar
      final centerY = topPadding + (usableHeight * (1.0 - netRatio));
      // Outer glow ring
      // İlgili fonksiyonu çalıştırır
      canvas.drawCircle(
        // offset nesnesini oluşturur
        Offset(centerX, centerY),
        // İlgili değeri veya görünüm ayarını belirler
        10,
        // paint nesnesini oluşturur
        Paint()..color = lineColor.withAlpha(60),
      );
      // Main dot
      // İlgili fonksiyonu çalıştırır
      canvas.drawCircle(
        // offset nesnesini oluşturur
        Offset(centerX, centerY),
        // İlgili değeri veya görünüm ayarını belirler
        6,
        // paint nesnesini oluşturur
        Paint()..color = lineColor,
      );
      // İlgili fonksiyonu çalıştırır
      canvas.drawCircle(
        // offset nesnesini oluşturur
        Offset(centerX, centerY),
        // İlgili değeri veya görünüm ayarını belirler
        3,
        // paint nesnesini oluşturur
        Paint()..color = Colors.white,
      );
      // Metodu burada bitirir
      return;
    }
    // Multiple points: compute positions
    // step x bilgisini hesaplayıp saklar
    final stepX = usableWidth / (points.length - 1);
    // offsets için boş koleksiyon oluşturur
    final offsets = <Offset>[];
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 0; i < points.length; i++) {
      // x konumu bilgisini hesaplayıp saklar
      final x = chartPadding + (i * stepX);
      // net ratio değerini belirli aralıkta sınırlar
      final netRatio = ((points[i].net - minNet) / range).clamp(0.0, 1.0);
      // y konumu bilgisini hesaplayıp saklar
      final y = topPadding + (usableHeight * (1.0 - netRatio));
      // add işlemini yapar
      offsets.add(Offset(x, y));
    }
    // Draw gradient fill under the line
    // fill path bilgisini hesaplayıp saklar
    final fillPath = Path()
      // move to işlemini yapar
      ..moveTo(offsets.first.dx, size.height - bottomPadding);
    // line to işlemini yapar
    fillPath.lineTo(offsets.first.dx, offsets.first.dy);
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 1; i < offsets.length; i++) {
      // p0 bilgisini hesaplayıp saklar
      final p0 = offsets[i - 1];
      // p1 bilgisini hesaplayıp saklar
      final p1 = offsets[i];
      // control x bilgisini hesaplayıp saklar
      final controlX = (p0.dx + p1.dx) / 2;
      // cubic to işlemini yapar
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }
    // line to işlemini yapar
    fillPath.lineTo(offsets.last.dx, size.height - bottomPadding);
    // close işlemini yapar
    fillPath.close();
    // fill paint bilgisini hesaplayıp saklar
    final fillPaint = Paint()
      // Aynı nesne üzerinde ek ayar yapar
      ..shader = LinearGradient(
        // begin bilgisini belirler
        begin: Alignment.topCenter,
        // end bilgisini belirler
        end: Alignment.bottomCenter,
        // renkler bilgisini belirler
        colors: [
          // Rengin saydamlık değerini ayarlar
          lineColor.withAlpha(80),
          // Rengin saydamlık değerini ayarlar
          lineColor.withAlpha(10),
          // Temadan renk veya görünüm değeri alır
          Colors.transparent,
        ],
      // shader bilgisini oluşturur
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      // Aynı nesne üzerinde ek ayar yapar
      ..style = PaintingStyle.fill;
    // path bilgisini çizer
    canvas.drawPath(fillPath, fillPaint);
    // Draw smooth line
    // line path bilgisini hesaplayıp saklar
    final linePath = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 1; i < offsets.length; i++) {
      // p0 bilgisini hesaplayıp saklar
      final p0 = offsets[i - 1];
      // p1 bilgisini hesaplayıp saklar
      final p1 = offsets[i];
      // control x bilgisini hesaplayıp saklar
      final controlX = (p0.dx + p1.dx) / 2;
      // cubic to işlemini yapar
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }
    // line paint bilgisini hesaplayıp saklar
    final linePaint = Paint()
      // Aynı nesne üzerinde ek ayar yapar
      ..color = lineColor
      // Aynı nesne üzerinde ek ayar yapar
      ..strokeWidth = 3.2
      // Aynı nesne üzerinde ek ayar yapar
      ..style = PaintingStyle.stroke
      // Aynı nesne üzerinde ek ayar yapar
      ..strokeCap = StrokeCap.round
      // Aynı nesne üzerinde ek ayar yapar
      ..strokeJoin = StrokeJoin.round;
    // path bilgisini çizer
    canvas.drawPath(linePath, linePaint);
    // Draw dots
    // Belirtilen aralıkta döngü çalıştırır
    for (int i = 0; i < offsets.length; i++) {
      // is seçilen bilgisini iki değeri karşılaştırarak hesaplar
      final isSelected = selectedIndex == i;
      // nokta bilgisini hesaplayıp saklar
      final point = offsets[i];
      // Belirtilen koşul doğruysa işlemi yapar
      if (isSelected) {
        // Highlight ring
        // İlgili fonksiyonu çalıştırır
        canvas.drawCircle(
          // İlgili değeri veya görünüm ayarını belirler
          point,
          // İlgili değeri veya görünüm ayarını belirler
          11,
          // paint nesnesini oluşturur
          Paint()..color = GardenPalette.harvestGold.withAlpha(100),
        );
        // İlgili fonksiyonu çalıştırır
        canvas.drawCircle(
          // İlgili değeri veya görünüm ayarını belirler
          point,
          // İlgili değeri veya görünüm ayarını belirler
          6.5,
          // paint nesnesini oluşturur
          Paint()..color = GardenPalette.harvestGold,
        );
        // İlgili fonksiyonu çalıştırır
        canvas.drawCircle(
          // İlgili değeri veya görünüm ayarını belirler
          point,
          // İlgili değeri veya görünüm ayarını belirler
          3.5,
          // paint nesnesini oluşturur
          Paint()..color = Colors.white,
        );
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // İlgili fonksiyonu çalıştırır
        canvas.drawCircle(
          // İlgili değeri veya görünüm ayarını belirler
          point,
          // İlgili değeri veya görünüm ayarını belirler
          4.5,
          // paint nesnesini oluşturur
          Paint()..color = lineColor,
        );
        // İlgili fonksiyonu çalıştırır
        canvas.drawCircle(
          // İlgili değeri veya görünüm ayarını belirler
          point,
          // İlgili değeri veya görünüm ayarını belirler
          2.0,
          // paint nesnesini oluşturur
          Paint()..color = Colors.white,
        );
      }
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Çizimin yeniden yapılması gerekip gerekmediğini kontrol eder
  bool shouldRepaint(covariant _GardenChartPainter oldDelegate) {
    // Birden fazla koşulu birlikte kontrol eder
    return oldDelegate.points != points ||
        // Birden fazla koşulu birlikte kontrol eder
        oldDelegate.selectedIndex != selectedIndex ||
        // Birden fazla koşulu birlikte kontrol eder
        oldDelegate.lineColor != lineColor ||
        // İlgili değeri veya görünüm ayarını belirler
        oldDelegate.isDark != isDark;
  }
}

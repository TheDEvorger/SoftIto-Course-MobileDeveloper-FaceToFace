// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// müfredat dosyasını kullanıma ekler
import '../../../domain/models/curriculum.dart';
// konu relation dosyasını kullanıma ekler
import '../../../domain/models/topic_relation.dart';
// konu map painter çizimini yapan sınıf
class TopicMapPainter extends CustomPainter {
  // konu map painter çizimini oluşturur
  TopicMapPainter({
    // düğümler bilgisini zorunlu tutar
    required this.nodes,
    // seçilen konu ID bilgisini isteğe bağlı alır
    this.selectedTopicId,
    // koyu tema durumu bilgisini zorunlu tutar
    required this.isDark,
  });
  // düğümler bilgisini tutar
  final List<TopicNodeInfo> nodes;
  // seçilen konu ID bilgisini tutar
  final String? selectedTopicId;
  // koyu tema durumu bilgisini tutar
  final bool isDark;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Canvas üzerine gerekli şekilleri çizer
  void paint(Canvas canvas, Size size) {
    // Liste veya metin boşsa bu koşul çalışır
    if (nodes.isEmpty) return;
    // düğüm haritası bilgisini hesaplayıp saklar
    final nodeMap = {for (final n in nodes) n.topicId: n};
    // 1. Bağlantı Çizgilerini (Edges) Çiz
    // bağlantı çizgisi fırçası bilgisini hesaplayıp saklar
    final edgePaint = Paint()
      // Aynı nesne üzerinde ek ayar yapar
      ..style = PaintingStyle.stroke
      // Aynı nesne üzerinde ek ayar yapar
      ..strokeWidth = 2.0;
    // Listedeki öğeleri tek tek dolaşır
    for (final node in nodes) {
      // Listedeki öğeleri tek tek dolaşır
      for (final prereqId in node.prerequisiteIds) {
        // parent bilgisini hesaplayıp saklar
        final parent = nodeMap[prereqId];
        // İlgili değer null ise kontrol eder
        if (parent == null) continue;
        // tamamlanma durumu bilgisini iki değeri karşılaştırarak hesaplar
        final isCompleted = parent.status == TopicStatus.completed;
        // edge paint.renk değerini günceller
        edgePaint.color = isCompleted
            // Koşul doğruysa bu değeri kullanır
            ? GardenPalette.mossEmerald.withAlpha(200)
            // Koşul yanlışsa bu değeri kullanır
            : (isDark ? Colors.white24 : Colors.black26);
        // p1 bilgisini hesaplayıp saklar
        final p1 = Offset(parent.x + 30, parent.y);
        // p2 bilgisini hesaplayıp saklar
        final p2 = Offset(node.x - 30, node.y);
        // çizim yolu bilgisini hesaplayıp saklar
        final path = Path()..moveTo(p1.dx, p1.dy);
        // x farkı bilgisini hesaplayıp saklar
        final dx = (p2.dx - p1.dx).abs();
        // İlgili fonksiyonu çalıştırır
        path.cubicTo(
          // Konum veya boyut bilgisini hesaplamada kullanır
          p1.dx + dx * 0.5,
          // Konum veya boyut bilgisini hesaplamada kullanır
          p1.dy,
          // Konum veya boyut bilgisini hesaplamada kullanır
          p2.dx - dx * 0.5,
          // Konum veya boyut bilgisini hesaplamada kullanır
          p2.dy,
          // Konum veya boyut bilgisini hesaplamada kullanır
          p2.dx,
          // Konum veya boyut bilgisini hesaplamada kullanır
          p2.dy,
        );
        // path bilgisini çizer
        canvas.drawPath(path, edgePaint);
        // Küçük yön oku veya filiz noktası
        // mid x bilgisini hesaplayıp saklar
        final midX = (p1.dx + p2.dx) / 2;
        // mid y bilgisini hesaplayıp saklar
        final midY = (p1.dy + p2.dy) / 2;
        // nokta çizim fırçası bilgisini hesaplayıp saklar
        final dotPaint = Paint()
          // Aynı nesne üzerinde ek ayar yapar
          ..color = isCompleted
              // Koşul doğruysa bu değeri kullanır
              ? GardenPalette.lightSage
              // Koşul yanlışsa bu değeri kullanır
              : (isDark ? Colors.white30 : Colors.black38)
          // Aynı nesne üzerinde ek ayar yapar
          ..style = PaintingStyle.fill;
        // circle bilgisini çizer
        canvas.drawCircle(Offset(midX, midY), 3.0, dotPaint);
      }
    }
    // 2. Düğümleri (Nodes) Çiz
    // Listedeki öğeleri tek tek dolaşır
    for (final node in nodes) {
      // is seçilen bilgisini iki değeri karşılaştırarak hesaplar
      final isSelected = node.topicId == selectedTopicId;
      // merkez bilgisini hesaplayıp saklar
      final center = Offset(node.x, node.y);
      // Seçili halkası (glow)
      // Belirtilen koşul doğruysa işlemi yapar
      if (isSelected) {
        // parlama fırçası bilgisini hesaplayıp saklar
        final glowPaint = Paint()
          // Rengin saydamlık değerini ayarlar
          ..color = GardenPalette.harvestGold.withAlpha(120)
          // Aynı nesne üzerinde ek ayar yapar
          ..style = PaintingStyle.stroke
          // Aynı nesne üzerinde ek ayar yapar
          ..strokeWidth = 4.0;
        // circle bilgisini çizer
        canvas.drawCircle(center, 22.0, glowPaint);
      }
      // Düğüm gövdesi
      // düğüm çizim fırçası bilgisini hesaplayıp saklar
      final nodePaint = Paint()..style = PaintingStyle.fill;
      // border renk bilgisini tutar
      Color borderColor;
      // Değere göre uygun durumu seçer
      switch (node.status) {
        // konu status.completed durumu için çalışır
        case TopicStatus.completed:
          // node paint.renk değerini günceller
          nodePaint.color = GardenPalette.mossEmerald;
          // border renk değerini günceller
          borderColor = GardenPalette.lightSage;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
        // konu status.in ilerleme durumu için çalışır
        case TopicStatus.inProgress:
          // node paint.renk değerini günceller
          nodePaint.color = GardenPalette.harvestGold;
          // border renk değerini günceller
          borderColor = GardenPalette.honeyLight;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
        // konu status.not started durumu için çalışır
        case TopicStatus.notStarted:
          // node paint.renk değerini günceller
          nodePaint.color = node.isReady
              // Koşul doğruysa bu değeri kullanır
              ? (isDark ? const Color(0xFF2C3E50) : const Color(0xFFE2E8F0))
              // Koşul yanlışsa bu değeri kullanır
              : (isDark ? const Color(0xFF1E272E) : const Color(0xFFCBD5E1));
          // border renk değerini günceller
          borderColor = node.isReady
              // Koşul doğruysa bu değeri kullanır
              ? GardenPalette.streamTurquoise.withAlpha(180)
              // Koşul yanlışsa bu değeri kullanır
              : Colors.transparent;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
      }
      // Ana daire
      // circle bilgisini çizer
      canvas.drawCircle(center, 16.0, nodePaint);
      // Dış çerçeve
      // Belirtilen koşul doğruysa işlemi yapar
      if (borderColor != Colors.transparent) {
        // border paint bilgisini hesaplayıp saklar
        final borderPaint = Paint()
          // Aynı nesne üzerinde ek ayar yapar
          ..color = borderColor
          // Aynı nesne üzerinde ek ayar yapar
          ..style = PaintingStyle.stroke
          // Aynı nesne üzerinde ek ayar yapar
          ..strokeWidth = 2.0;
        // circle bilgisini çizer
        canvas.drawCircle(center, 16.0, borderPaint);
      }
      // İkonik işaret
      // icon metin bilgisini iki değeri karşılaştırarak hesaplar
      final iconText = node.status == TopicStatus.completed
          // Koşul doğruysa bu değeri kullanır
          ? '✓'
          // Koşul yanlışsa bu değeri kullanır
          : (node.status == TopicStatus.inProgress
              // Koşul doğruysa bu değeri kullanır
              ? '🌱'
              // Koşul yanlışsa bu değeri kullanır
              : (node.isReady ? '🔓' : '🔒'));
      // metin span bilgisini hesaplayıp saklar
      final textSpan = TextSpan(
        // Gösterilecek metni belirler
        text: iconText,
        // Görünüm stilini belirler
        style: TextStyle(
          // Rengi belirler
          color: node.status == TopicStatus.completed
              // Koşul doğruysa bu değeri kullanır
              ? Colors.white
              // Koşul yanlışsa bu değeri kullanır
              : (isDark ? Colors.white70 : Colors.black87),
          // Yazı boyutunu belirler
          fontSize: 12,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.bold,
        ),
      );
      // tp bilgisini hesaplayıp saklar
      final tp = TextPainter(
        // Gösterilecek metni belirler
        text: textSpan,
        // Yazının yönünü belirler
        textDirection: TextDirection.ltr,
      // layout işlemini yapar
      )..layout();
      // İlgili fonksiyonu çalıştırır
      tp.paint(
        // İlgili değeri veya görünüm ayarını belirler
        canvas,
        // offset nesnesini oluşturur
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2)),
      );
      // Başlık Etiketi (Node Title)
      // label span bilgisini hesaplayıp saklar
      final labelSpan = TextSpan(
        // Gösterilecek metni belirler
        text: node.topicName,
        // Görünüm stilini belirler
        style: TextStyle(
          // Rengi belirler
          color: isDark ? Colors.white : Colors.black87,
          // Yazı boyutunu belirler
          fontSize: 11,
          // Yazı kalınlığını belirler
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      );
      // label painter bilgisini hesaplayıp saklar
      final labelPainter = TextPainter(
        // Gösterilecek metni belirler
        text: labelSpan,
        // Yazının yönünü belirler
        textDirection: TextDirection.ltr,
        // Gösterilecek en fazla satır sayısını belirler
        maxLines: 2,
        // ellipsis bilgisini belirler
        ellipsis: '...',
      // layout işlemini yapar
      )..layout(maxWidth: 130);
      // Metni düğümün yanına yerleştir (sol veya sağ)
      // label x değerini tanımlar
      final labelX =
          // Koşula göre iki değerden birini seçer
          node.stage == 'TYT' ? node.x - labelPainter.width - 24 : node.x + 24;
      // label y bilgisini hesaplayıp saklar
      final labelY = node.y - (labelPainter.height / 2);
      // çizim fırçası işlemini yapar
      labelPainter.paint(canvas, Offset(labelX, labelY));
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Çizimin yeniden yapılması gerekip gerekmediğini kontrol eder
  bool shouldRepaint(covariant TopicMapPainter oldDelegate) {
    // Birden fazla koşulu birlikte kontrol eder
    return oldDelegate.nodes != nodes ||
        // Birden fazla koşulu birlikte kontrol eder
        oldDelegate.selectedTopicId != selectedTopicId ||
        // İlgili değeri veya görünüm ayarını belirler
        oldDelegate.isDark != isDark;
  }
}

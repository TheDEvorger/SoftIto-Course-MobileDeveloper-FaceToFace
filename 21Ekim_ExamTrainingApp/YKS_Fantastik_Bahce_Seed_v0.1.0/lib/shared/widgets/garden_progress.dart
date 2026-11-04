// Matematiksel işlem fonksiyonlarını ekler
import 'dart:math' as math;
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
/// Yaprak ayrıntılı ilerleme çubuğu.
/// İlerleme ucunda organik filiz/yaprak ikonu ve yumuşak geçiş.
// leaf ilerleme bar bölümünü oluşturan StatelessWidget sınıfı
class LeafProgressBar extends StatelessWidget {
  // leaf ilerleme bar nesnesini oluşturur
  const LeafProgressBar({
    // ilerleme bilgisini zorunlu tutar
    required this.progress,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 14,
    // show leaf tip bilgisini isteğe bağlı alır
    this.showLeafTip = true,
    // active renk bilgisini isteğe bağlı alır
    this.activeColor,
    // arka plan rengi bilgisini isteğe bağlı alır
    this.backgroundColor,
    // etiket bilgisini isteğe bağlı alır
    this.label,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  /// 0.0 ile 1.0 arasında değer
  // ilerleme bilgisini tutar
  final double progress;
  // yükseklik bilgisini tutar
  final double height;
  // show leaf tip bilgisini tutar
  final bool showLeafTip;
  // active renk bilgisini tutar
  final Color? activeColor;
  // arka plan rengi bilgisini tutar
  final Color? backgroundColor;
  // etiket bilgisini tutar
  final String? label;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // clamped değerini belirli aralıkta sınırlar
    final clamped = progress.clamp(0.0, 1.0);
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // renk bilgisini hesaplayıp saklar
    final color = activeColor ??
        // Yeni değer veya liste oluşturur
        (isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald);
    // bg bilgisini hesaplayıp saklar
    final bg = backgroundColor ??
        // Yeni değer veya liste oluşturur
        (isDark
            // Koşul doğruysa bu değeri kullanır
            ? GardenPalette.nightBackdrop
            // Koşul yanlışsa bu değeri kullanır
            : GardenPalette.lightSage.withAlpha(120));
    // Elemanları alt alta dizer
    return Column(
      // Çapraz eksendeki hizalamayı belirler
      crossAxisAlignment: CrossAxisAlignment.start,
      // Ana eksende kaplanacak alanı belirler
      mainAxisSize: MainAxisSize.min,
      // İçerideki widgetları listeler
      children: [
        // İlgili değer null değilse kontrol eder
        if (label != null) ...[
          // Elemanları yan yana dizer
          Row(
            // Ana eksendeki hizalamayı belirler
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              Text(
                // İlgili değeri veya görünüm ayarını belirler
                label!,
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 12,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w600,
                  // Rengi belirler
                  color:
                      // Koşula göre iki değerden birini seçer
                      isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
                ),
              ),
              // Metni ekranda gösterir
              Text(
                // Sayıyı int tipine çevirir
                '%${(clamped * 100).toInt()}',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 12,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.bold,
                  // Rengi belirler
                  color: color,
                ),
              ),
            ],
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 6),
        ],
        // Kullanılabilir alana göre yerleşim oluşturur
        LayoutBuilder(
          // Gelen verilerle arayüzü oluşturur
          builder: (context, constraints) {
            // toplam width bilgisini hesaplayıp saklar
            final totalWidth = constraints.maxWidth;
            // fill width bilgisini hesaplayıp saklar
            final fillWidth = totalWidth * clamped;
            // Elemanları üst üste yerleştirir
            return Stack(
              // Dışarı taşan içeriğin kesilmesini belirler
              clipBehavior: Clip.none,
              // İçeriğin hizalanmasını belirler
              alignment: Alignment.centerLeft,
              // İçerideki widgetları listeler
              children: [
                // Arka plan izi
                // Görsel bir kutu oluşturur
                Container(
                  // Genişliği belirler
                  width: totalWidth,
                  // Yüksekliği belirler
                  height: height,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: bg,
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                // Dolu çubuk
                // Değişiklikleri animasyonla gösterir
                AnimatedContainer(
                  // Animasyonun süresini belirler
                  duration: const Duration(milliseconds: 350),
                  // Animasyonun hareket şeklini belirler
                  curve: Curves.easeOutCubic,
                  // Genişliği belirler
                  width: fillWidth,
                  // Yüksekliği belirler
                  height: height,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Renk geçişini belirler
                    gradient: LinearGradient(
                      // renkler bilgisini belirler
                      colors: [
                        // Rengin saydamlık değerini ayarlar
                        color.withAlpha(200),
                        // İlgili değeri veya görünüm ayarını belirler
                        color,
                      ],
                    ),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                // Uçtaki yaprak süsü
                // Belirtilen koşul doğruysa işlemi yapar
                if (showLeafTip && clamped > 0.05)
                  // Elemanı Stack içinde konumlandırır
                  Positioned(
                    // left bilgisini belirler
                    left: math.max(0, fillWidth - (height + 2)),
                    // İçine yerleştirilecek widgetı belirler
                    child: Container(
                      // Genişliği belirler
                      width: height + 4,
                      // Yüksekliği belirler
                      height: height + 4,
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: BoxDecoration(
                        // Rengi belirler
                        color: Colors.white,
                        // Widgetın kenar şeklini belirler
                        shape: BoxShape.circle,
                        // Gölge ayarlarını belirler
                        boxShadow: [
                          // Kutuya gölge ayarı ekler
                          BoxShadow(
                            // Rengi belirler
                            color: color.withAlpha(90),
                            // Gölgenin bulanıklığını belirler
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      // İçine yerleştirilecek widgetı belirler
                      child: Center(
                        // İçine yerleştirilecek widgetı belirler
                        child: Icon(
                          // Gösterilecek simgeyi belirler
                          Icons.eco,
                          // Boyutu belirler
                          size: height - 2,
                          // Rengi belirler
                          color: color,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
/// Organik ama net okunabilen dairesel ilerleme halkası.
// organic ilerleme ring bölümünü oluşturan StatelessWidget sınıfı
class OrganicProgressRing extends StatelessWidget {
  // organic ilerleme ring nesnesini oluşturur
  const OrganicProgressRing({
    // ilerleme bilgisini zorunlu tutar
    required this.progress,
    // boyut bilgisini isteğe bağlı alır
    this.size = 90,
    // çizgi kalınlığı bilgisini isteğe bağlı alır
    this.strokeWidth = 9,
    // active renk bilgisini isteğe bağlı alır
    this.activeColor,
    // center metin bilgisini isteğe bağlı alır
    this.centerText,
    // sub metin bilgisini isteğe bağlı alır
    this.subText,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // ilerleme bilgisini tutar
  final double progress;
  // boyut bilgisini tutar
  final double size;
  // çizgi kalınlığı bilgisini tutar
  final double strokeWidth;
  // active renk bilgisini tutar
  final Color? activeColor;
  // center metin bilgisini tutar
  final String? centerText;
  // sub metin bilgisini tutar
  final String? subText;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // clamped değerini belirli aralıkta sınırlar
    final clamped = progress.clamp(0.0, 1.0);
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // renk bilgisini hesaplayıp saklar
    final color = activeColor ??
        // Yeni değer veya liste oluşturur
        (isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald);
    // Sabit boyutlu veya boşluk bırakan alan oluşturur
    return SizedBox(
      // Genişliği belirler
      width: size,
      // Yüksekliği belirler
      height: size,
      // İçine yerleştirilecek widgetı belirler
      child: Stack(
        // İçeriğin hizalanmasını belirler
        alignment: Alignment.center,
        // İçerideki widgetları listeler
        children: [
          // Arka plan halkası
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          SizedBox(
            // Genişliği belirler
            width: size,
            // Yüksekliği belirler
            height: size,
            // İçine yerleştirilecek widgetı belirler
            child: CircularProgressIndicator(
              // Kullanılacak değeri belirler
              value: 1.0,
              // Çizgi kalınlığını belirler
              strokeWidth: strokeWidth,
              // Rengi belirler
              color: isDark
                  // Koşul doğruysa bu değeri kullanır
                  ? Colors.white10
                  // Koşul yanlışsa bu değeri kullanır
                  : GardenPalette.lightSage.withAlpha(120),
            ),
          ),
          // Aktif ilerleme halkası
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          SizedBox(
            // Genişliği belirler
            width: size,
            // Yüksekliği belirler
            height: size,
            // İçine yerleştirilecek widgetı belirler
            child: TweenAnimationBuilder<double>(
              // tween bilgisini belirler
              tween: Tween(begin: 0.0, end: clamped),
              // Animasyonun süresini belirler
              duration: const Duration(milliseconds: 500),
              // Animasyonun hareket şeklini belirler
              curve: Curves.easeOutCubic,
              // Gelen verilerle arayüzü oluşturur
              builder: (context, value, _) {
                // Dairesel ilerleme göstergesi oluşturur
                return CircularProgressIndicator(
                  // Kullanılacak değeri belirler
                  value: value,
                  // Çizgi kalınlığını belirler
                  strokeWidth: strokeWidth,
                  // Çizgi uçlarını belirler
                  strokeCap: StrokeCap.round,
                  // Rengi belirler
                  color: color,
                );
              },
            ),
          ),
          // Merkez metni
          // Elemanları alt alta dizer
          Column(
            // Ana eksende kaplanacak alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              Text(
                // Sayıyı int tipine çevirir
                centerText ?? '%${(clamped * 100).toInt()}',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: size * 0.22,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.bold,
                  // Rengi belirler
                  color:
                      // Koşula göre iki değerden birini seçer
                      isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
                ),
              ),
              // İlgili değer null değilse kontrol eder
              if (subText != null)
                // Metni ekranda gösterir
                Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  subText!,
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: size * 0.12,
                    // Rengi belirler
                    color:
                        // Koşula göre iki değerden birini seçer
                        isDark ? const Color(0xFFC7BDC8) : Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
/// Derslere göre renkli ilerleme rozeti.
// ders ilerleme badge bölümünü oluşturan StatelessWidget sınıfı
class SubjectProgressBadge extends StatelessWidget {
  // ders ilerleme badge nesnesini oluşturur
  const SubjectProgressBadge({
    // ders adı bilgisini zorunlu tutar
    required this.subjectName,
    // tamamlanan konular bilgisini zorunlu tutar
    required this.completedTopics,
    // toplam konular bilgisini zorunlu tutar
    required this.totalTopics,
    // renk bilgisini isteğe bağlı alır
    this.color = GardenPalette.mossEmerald,
    // dokunma fonksiyonu bilgisini isteğe bağlı alır
    this.onTap,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // ders adı bilgisini tutar
  final String subjectName;
  // tamamlanan konular bilgisini tutar
  final int completedTopics;
  // toplam konular bilgisini tutar
  final int totalTopics;
  // renk bilgisini tutar
  final Color color;
  // dokunma fonksiyonu bilgisini tutar
  final VoidCallback? onTap;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // oran değerini koşula göre hesaplar
    final ratio = totalTopics > 0 ? completedTopics / totalTopics : 0.0;
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Tıklanabilir alan oluşturur
    return InkWell(
      // Köşelerin yuvarlaklığını belirler
      borderRadius: BorderRadius.circular(14),
      // Dokunulunca çalışacak fonksiyonu belirler
      onTap: onTap,
      // İçine yerleştirilecek widgetı belirler
      child: Container(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Rengi belirler
          color: isDark ? GardenPalette.nightCard : Colors.white,
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(14),
          // Kenarlığı belirler
          border: Border.all(color: color.withAlpha(60), width: 1.2),
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // Çapraz eksendeki hizalamayı belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // İçerideki widgetları listeler
          children: [
            // Elemanları yan yana dizer
            Row(
              // Ana eksendeki hizalamayı belirler
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // İçerideki widgetları listeler
              children: [
                // Metni ekranda gösterir
                Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  subjectName,
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 14,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                    // Rengi belirler
                    color: isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFF8F2E8)
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.inkPlum,
                  ),
                ),
                // Metni ekranda gösterir
                Text(
                  // "$completedTopics / $totalTopics" metnini kullanır
                  '$completedTopics / $totalTopics',
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 12,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w600,
                    // Rengi belirler
                    color: color,
                  ),
                ),
              ],
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
            // leaf ilerleme bar nesnesini oluşturur
            LeafProgressBar(
              // ilerleme bilgisini belirler
              progress: ratio,
              // Yüksekliği belirler
              height: 8,
              // show leaf tip bilgisini belirler
              showLeafTip: false,
              // Etkin durum rengini belirler
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}

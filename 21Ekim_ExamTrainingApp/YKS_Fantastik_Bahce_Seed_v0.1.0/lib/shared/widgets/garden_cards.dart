// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
/// Genel içerik kartları. Zarif çift katmanlı hissi veren kenarlık,
/// yumuşak gölgeler ve sıcak yüzey renkleri.
// garden kart bölümünü oluşturan StatelessWidget sınıfı
class GardenCard extends StatelessWidget {
  // garden kart kartını oluşturur
  const GardenCard({
    // alt widget bilgisini zorunlu tutar
    required this.child,
    // padding bilgisini isteğe bağlı alır
    this.padding = const EdgeInsets.all(16),
    // margin bilgisini isteğe bağlı alır
    this.margin,
    // dokunma fonksiyonu bilgisini isteğe bağlı alır
    this.onTap,
    // border renk bilgisini isteğe bağlı alır
    this.borderColor,
    // arka plan rengi bilgisini isteğe bağlı alır
    this.backgroundColor,
    // elevation bilgisini isteğe bağlı alır
    this.elevation = 0,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // alt widget bilgisini tutar
  final Widget child;
  // padding bilgisini tutar
  final EdgeInsetsGeometry padding;
  // margin bilgisini tutar
  final EdgeInsetsGeometry? margin;
  // dokunma fonksiyonu bilgisini tutar
  final VoidCallback? onTap;
  // border renk bilgisini tutar
  final Color? borderColor;
  // arka plan rengi bilgisini tutar
  final Color? backgroundColor;
  // elevation bilgisini tutar
  final double elevation;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // bg bilgisini hesaplayıp saklar
    final bg = backgroundColor ??
        // Yeni değer veya liste oluşturur
        (isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain);
    // border bilgisini hesaplayıp saklar
    final border = borderColor ??
        // Yeni değer veya liste oluşturur
        (isDark
            // Koşul doğruysa bu değeri kullanır
            ? GardenPalette.mossEmerald.withAlpha(40)
            // Koşul yanlışsa bu değeri kullanır
            : GardenPalette.mossEmerald.withAlpha(30));
    // Görsel bir kutu oluşturur
    return Container(
      // Dış boşlukları belirler
      margin: margin,
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: bg,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(20),
        // Kenarlığı belirler
        border: Border.all(color: border, width: 1.2),
        // Gölge ayarlarını belirler
        boxShadow: [
          // Kutuya gölge ayarı ekler
          BoxShadow(
            // Rengi belirler
            color: Colors.black.withAlpha(isDark ? 35 : 12),
            // Gölgenin konumunu belirler
            offset: const Offset(0, 3),
            // Gölgenin bulanıklığını belirler
            blurRadius: 8,
          ),
        ],
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Material(
        // Rengi belirler
        color: Colors.transparent,
        // İçine yerleştirilecek widgetı belirler
        child: InkWell(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(20),
          // Dokunulunca çalışacak fonksiyonu belirler
          onTap: onTap,
          // İçine yerleştirilecek widgetı belirler
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
/// Manzaralı büyük karşılama ve vurgu kartları.
/// Görsel üzerine okunaklı koyu botanik degrade yerleştirilir.
// forest hero kart bölümünü oluşturan StatelessWidget sınıfı
class ForestHeroCard extends StatelessWidget {
  // forest hero kart kartını oluşturur
  const ForestHeroCard({
    // görsel dosya yolu bilgisini zorunlu tutar
    required this.assetPath,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // alt başlık bilgisini zorunlu tutar
    required this.subtitle,
    // tag bilgisini isteğe bağlı alır
    this.tag,
    // action label bilgisini isteğe bağlı alır
    this.actionLabel,
    // on action bilgisini isteğe bağlı alır
    this.onAction,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 210,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // görsel dosya yolu bilgisini tutar
  final String assetPath;
  // başlık bilgisini tutar
  final String title;
  // alt başlık bilgisini tutar
  final String subtitle;
  // tag bilgisini tutar
  final String? tag;
  // action label bilgisini tutar
  final String? actionLabel;
  // on action bilgisini tutar
  final VoidCallback? onAction;
  // yükseklik bilgisini tutar
  final double height;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Erişilebilirlik açıklaması ekler
    return Semantics(
      // Buton veya alan yazısını belirler
      label: '$title. $subtitle',
      // İçine yerleştirilecek widgetı belirler
      child: ClipRRect(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(22),
        // İçine yerleştirilecek widgetı belirler
        child: SizedBox(
          // Yüksekliği belirler
          height: height,
          // Genişliği belirler
          width: double.infinity,
          // İçine yerleştirilecek widgetı belirler
          child: Stack(
            // Görselin alana nasıl sığacağını belirler
            fit: StackFit.expand,
            // İçerideki widgetları listeler
            children: [
              // Projeden görsel dosyası gösterir
              Image.asset(
                // İlgili değeri veya görünüm ayarını belirler
                assetPath,
                // Görselin alana nasıl sığacağını belirler
                fit: BoxFit.cover,
                // İçeriğin hizalanmasını belirler
                alignment: Alignment.center,
                // exclude from semantics bilgisini belirler
                excludeFromSemantics: true,
                // hata oluşturucu bilgisini belirler
                errorBuilder: (context, error, stackTrace) =>
                    // colored box nesnesini oluşturur
                    ColoredBox(color: Theme.of(context).colorScheme.primary),
              ),
              // decorated box nesnesini oluşturur
              const DecoratedBox(
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Renk geçişini belirler
                  gradient: LinearGradient(
                    // begin bilgisini belirler
                    begin: Alignment.topCenter,
                    // end bilgisini belirler
                    end: Alignment.bottomCenter,
                    // renkler bilgisini belirler
                    colors: [
                      // Sabit renk değeri oluşturur
                      Color(0x660B2319),
                      // Sabit renk değeri oluşturur
                      Color(0x330B2319),
                      // Sabit renk değeri oluşturur
                      Color(0xE6001810),
                    ],
                  ),
                ),
              ),
              // İlgili değer null değilse kontrol eder
              if (tag != null)
                // Elemanı Stack içinde konumlandırır
                Positioned(
                  // top bilgisini belirler
                  top: 16,
                  // left bilgisini belirler
                  left: 16,
                  // İçine yerleştirilecek widgetı belirler
                  child: Container(
                    // İç boşlukları belirler
                    padding:
                        // Yatay ve dikey boşlukları belirler
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.mossEmerald.withAlpha(220),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      tag!,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Rengi belirler
                        color: Colors.white,
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Elemanı Stack içinde konumlandırır
              Positioned(
                // bottom bilgisini belirler
                bottom: 16,
                // left bilgisini belirler
                left: 16,
                // right bilgisini belirler
                right: 16,
                // İçine yerleştirilecek widgetı belirler
                child: Column(
                  // Ana eksende kaplanacak alanı belirler
                  mainAxisSize: MainAxisSize.min,
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçerideki widgetları listeler
                  children: [
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      title,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Rengi belirler
                        color: Colors.white,
                        // Yazı boyutunu belirler
                        fontSize: 21,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w800,
                        // Harfler arasındaki boşluğu belirler
                        letterSpacing: -0.3,
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(height: 6),
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      subtitle,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Rengi belirler
                        color: Color(0xFFF2F8E8),
                        // Yazı boyutunu belirler
                        fontSize: 13,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // İlgili değer null değilse kontrol eder
                    if (actionLabel != null && onAction != null) ...[
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 12),
                      // Tıklanabilir alan oluşturur
                      InkWell(
                        // Dokunulunca çalışacak fonksiyonu belirler
                        onTap: onAction,
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(12),
                        // İçine yerleştirilecek widgetı belirler
                        child: Container(
                          // İç boşlukları belirler
                          padding: const EdgeInsets.symmetric(
                              // horizontal bilgisini belirler
                              horizontal: 14, vertical: 8),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: GardenPalette.peachCoral,
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            actionLabel!,
                            // Görünüm stilini belirler
                            style: const TextStyle(
                              // Rengi belirler
                              color: Colors.white,
                              // Yazı boyutunu belirler
                              fontSize: 13,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Hedef ve başarı alanları için altın vurgulu özel kart.
// golden achievement kart bölümünü oluşturan StatelessWidget sınıfı
class GoldenAchievementCard extends StatelessWidget {
  // golden achievement kart kartını oluşturur
  const GoldenAchievementCard({
    // başlık bilgisini zorunlu tutar
    required this.title,
    // alt başlık bilgisini zorunlu tutar
    required this.subtitle,
    // badge metin bilgisini isteğe bağlı alır
    this.badgeText,
    // ilerleme metin bilgisini isteğe bağlı alır
    this.progressText,
    // simge bilgisini isteğe bağlı alır
    this.icon = Icons.workspace_premium,
    // dokunma fonksiyonu bilgisini isteğe bağlı alır
    this.onTap,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // başlık bilgisini tutar
  final String title;
  // alt başlık bilgisini tutar
  final String subtitle;
  // badge metin bilgisini tutar
  final String? badgeText;
  // ilerleme metin bilgisini tutar
  final String? progressText;
  // simge bilgisini tutar
  final IconData icon;
  // dokunma fonksiyonu bilgisini tutar
  final VoidCallback? onTap;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Görsel bir kutu oluşturur
    return Container(
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: isDark ? GardenPalette.nightCard : const Color(0xFFFCF8EE),
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(20),
        // Kenarlığı belirler
        border: Border.all(
          // Rengi belirler
          color: GardenPalette.harvestGold.withAlpha(isDark ? 120 : 150),
          // Genişliği belirler
          width: 1.5,
        ),
        // Gölge ayarlarını belirler
        boxShadow: [
          // Kutuya gölge ayarı ekler
          BoxShadow(
            // Rengi belirler
            color: GardenPalette.harvestGold.withAlpha(isDark ? 40 : 35),
            // Gölgenin konumunu belirler
            offset: const Offset(0, 3),
            // Gölgenin bulanıklığını belirler
            blurRadius: 10,
          ),
        ],
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Material(
        // Rengi belirler
        color: Colors.transparent,
        // İçine yerleştirilecek widgetı belirler
        child: InkWell(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(20),
          // Dokunulunca çalışacak fonksiyonu belirler
          onTap: onTap,
          // İçine yerleştirilecek widgetı belirler
          child: Padding(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(16),
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // Görsel bir kutu oluşturur
                Container(
                  // Genişliği belirler
                  width: 48,
                  // Yüksekliği belirler
                  height: 48,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Widgetın kenar şeklini belirler
                    shape: BoxShape.circle,
                    // Renk geçişini belirler
                    gradient: const LinearGradient(
                      // renkler bilgisini belirler
                      colors: [
                        // Temadan renk veya görünüm değeri alır
                        GardenPalette.honeyLight,
                        // Temadan renk veya görünüm değeri alır
                        GardenPalette.harvestGold,
                      ],
                    ),
                    // Gölge ayarlarını belirler
                    boxShadow: [
                      // Kutuya gölge ayarı ekler
                      BoxShadow(
                        // Rengi belirler
                        color: GardenPalette.harvestGold.withAlpha(90),
                        // Gölgenin bulanıklığını belirler
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Icon(icon, color: GardenPalette.inkPlum, size: 26),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(width: 14),
                // Kalan boşluğu kullanacak alan oluşturur
                Expanded(
                  // İçine yerleştirilecek widgetı belirler
                  child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki widgetları listeler
                    children: [
                      // Elemanları yan yana dizer
                      Row(
                        // İçerideki widgetları listeler
                        children: [
                          // Kalan boşluğu kullanacak alan oluşturur
                          Expanded(
                            // İçine yerleştirilecek widgetı belirler
                            child: Text(
                              // İlgili değeri veya görünüm ayarını belirler
                              title,
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 16,
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
                          ),
                          // İlgili değer null değilse kontrol eder
                          if (badgeText != null)
                            // Görsel bir kutu oluşturur
                            Container(
                              // İç boşlukları belirler
                              padding: const EdgeInsets.symmetric(
                                  // horizontal bilgisini belirler
                                  horizontal: 8, vertical: 2),
                              // Kutu ve kenarlık görünümünü belirler
                              decoration: BoxDecoration(
                                // Rengi belirler
                                color: GardenPalette.harvestGold,
                                // Köşelerin yuvarlaklığını belirler
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // İçine yerleştirilecek widgetı belirler
                              child: Text(
                                // İlgili değeri veya görünüm ayarını belirler
                                badgeText!,
                                // Görünüm stilini belirler
                                style: const TextStyle(
                                  // Rengi belirler
                                  color: Colors.white,
                                  // Yazı boyutunu belirler
                                  fontSize: 11,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 4),
                      // Metni ekranda gösterir
                      Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        subtitle,
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 13,
                          // Rengi belirler
                          color: isDark
                              // Koşul doğruysa bu değeri kullanır
                              ? const Color(0xFFC7BDC8)
                              // Koşul yanlışsa bu değeri kullanır
                              : Colors.grey.shade700,
                        ),
                      ),
                      // İlgili değer null değilse kontrol eder
                      if (progressText != null) ...[
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 6),
                        // Metni ekranda gösterir
                        Text(
                          // İlgili değeri veya görünüm ayarını belirler
                          progressText!,
                          // Görünüm stilini belirler
                          style: const TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.w600,
                            // Rengi belirler
                            color: GardenPalette.harvestGold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/// Su tonlarından (`streamTurquoise`, `lilyWater`) yararlanan bilgi/ipucu kartı.
// water info kart bölümünü oluşturan StatelessWidget sınıfı
class WaterInfoCard extends StatelessWidget {
  // water info kart kartını oluşturur
  const WaterInfoCard({
    // başlık bilgisini zorunlu tutar
    required this.title,
    // mesaj bilgisini zorunlu tutar
    required this.message,
    // simge bilgisini isteğe bağlı alır
    this.icon = Icons.water_drop_outlined,
    // on action bilgisini isteğe bağlı alır
    this.onAction,
    // action label bilgisini isteğe bağlı alır
    this.actionLabel,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // başlık bilgisini tutar
  final String title;
  // mesaj bilgisini tutar
  final String message;
  // simge bilgisini tutar
  final IconData icon;
  // on action bilgisini tutar
  final VoidCallback? onAction;
  // action label bilgisini tutar
  final String? actionLabel;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Görsel bir kutu oluşturur
    return Container(
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: isDark ? const Color(0xFF24323A) : GardenPalette.lilyWater,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kenarlığı belirler
        border: Border.all(
          // Rengi belirler
          color: GardenPalette.streamTurquoise.withAlpha(isDark ? 90 : 120),
          // Genişliği belirler
          width: 1.2,
        ),
      ),
      // İç boşlukları belirler
      padding: const EdgeInsets.all(16),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // Çapraz eksendeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // İçerideki widgetları listeler
        children: [
          // Görsel bir kutu oluşturur
          Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(8),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Widgetın kenar şeklini belirler
              shape: BoxShape.circle,
              // Rengi belirler
              color: GardenPalette.streamTurquoise.withAlpha(35),
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Icon(icon, color: GardenPalette.streamTurquoise, size: 22),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(width: 12),
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
                  title,
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 15,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                    // Rengi belirler
                    color: isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFE8F6F4)
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.inkPlum,
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 4),
                // Metni ekranda gösterir
                Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  message,
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 13,
                    // Yüksekliği belirler
                    height: 1.35,
                    // Rengi belirler
                    color: isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFB5C9C6)
                        // Koşul yanlışsa bu değeri kullanır
                        : const Color(0xFF3B5652),
                  ),
                ),
                // İlgili değer null değilse kontrol eder
                if (actionLabel != null && onAction != null) ...[
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 8),
                  // Dokunma hareketlerini dinler
                  GestureDetector(
                    // Dokunulunca çalışacak fonksiyonu belirler
                    onTap: onAction,
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      actionLabel!,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 13,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.bold,
                        // Rengi belirler
                        color: GardenPalette.streamTurquoise,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/// İnce doğal süslemelerle desteklenmiş bölüm başlığı.
// botanical section header bölümünü oluşturan StatelessWidget sınıfı
class BotanicalSectionHeader extends StatelessWidget {
  // botanical section header nesnesini oluşturur
  const BotanicalSectionHeader({
    // başlık bilgisini zorunlu tutar
    required this.title,
    // alt başlık bilgisini isteğe bağlı alır
    this.subtitle,
    // action metin bilgisini isteğe bağlı alır
    this.actionText,
    // on action bilgisini isteğe bağlı alır
    this.onAction,
    // simge bilgisini isteğe bağlı alır
    this.icon = Icons.spa_outlined,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // başlık bilgisini tutar
  final String title;
  // alt başlık bilgisini tutar
  final String? subtitle;
  // action metin bilgisini tutar
  final String? actionText;
  // on action bilgisini tutar
  final VoidCallback? onAction;
  // simge bilgisini tutar
  final IconData icon;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // İç boşluk ekler
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(vertical: 8),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // İçerideki widgetları listeler
        children: [
          // Görsel bir kutu oluşturur
          Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(6),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Rengi belirler
              color: GardenPalette.mossEmerald.withAlpha(isDark ? 50 : 25),
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(8),
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Icon(
              // İlgili değeri veya görünüm ayarını belirler
              icon,
              // Boyutu belirler
              size: 18,
              // Rengi belirler
              color:
                  // Koşula göre iki değerden birini seçer
                  isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald,
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
                  title,
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 17,
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
                // İlgili değer null değilse kontrol eder
                if (subtitle != null)
                  // Metni ekranda gösterir
                  Text(
                    // İlgili değeri veya görünüm ayarını belirler
                    subtitle!,
                    // Görünüm stilini belirler
                    style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 12,
                      // Rengi belirler
                      color: isDark
                          // Koşul doğruysa bu değeri kullanır
                          ? const Color(0xFFB3A6B7)
                          // Koşul yanlışsa bu değeri kullanır
                          : Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          // İlgili değer null değilse kontrol eder
          if (actionText != null && onAction != null)
            // Esneyebilen alan oluşturur
            Flexible(
              // İçine yerleştirilecek widgetı belirler
              child: TextButton(
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: onAction,
                // Görünüm stilini belirler
                style: TextButton.styleFrom(
                  // visual density bilgisini belirler
                  visualDensity: VisualDensity.compact,
                  // Yazı ve simge rengini belirler
                  foregroundColor: isDark
                      // Koşul doğruysa bu değeri kullanır
                      ? const Color(0xFFA4D49B)
                      // Koşul yanlışsa bu değeri kullanır
                      : GardenPalette.mossEmerald,
                ),
                // İçine yerleştirilecek widgetı belirler
                child: Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  actionText!,
                  // Uzun yazının taşma şeklini belirler
                  overflow: TextOverflow.ellipsis,
                  // Görünüm stilini belirler
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

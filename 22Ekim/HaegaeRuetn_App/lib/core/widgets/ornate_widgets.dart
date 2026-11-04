// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık tema ayarlarını projeye ekler
import '../theme/realm_theme.dart';
// Mühür ve köşe süslerini projeye ekler
import 'heraldic_decorations.dart';
// Diğer dosyaların bu bileşene ulaşmasını sağlar
export 'heraldic_decorations.dart';
// art assets bilgilerini ve ilgili davranışları tanımlar
class ArtAssets {
  // Vazifeleri tutan listeyi saklar
  static const habits = 'assets/art/vazifeler_concept.png';
  // Oluşturulmuş ahitlerin listesini saklar
  static const pacts = 'assets/art/ahitler_concept.png';
  // chronicle bilgisini saklar
  static const chronicle = 'assets/art/kronik_concept.png';
  // plaza bilgisini saklar
  static const plaza = 'assets/art/meydan_concept.jpg';
  // guide bilgisini saklar
  static const guide = 'assets/art/rehber_concept.jpg';
  // wallpaper bilgisini saklar
  static const wallpaper = 'assets/art/realm_wallpaper.jpg';
}
// Ornate parchment card with gilded borders and illuminated corner filigrees.
// Altın kenarlıklı krallık kartını oluşturur
class OrnateCard extends StatelessWidget {
  // OrnateCard nesnesinin başlangıç bilgilerini alır
  const OrnateCard({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // child parametresini zorunlu tutar
    required this.child,
    // padding için isteğe bağlı başlangıç değeri alır
    this.padding = const EdgeInsets.all(16),
    // color için isteğe bağlı başlangıç değeri alır
    this.color = Colors.white,
    // border color için isteğe bağlı başlangıç değeri alır
    this.borderColor,
    // show corners için isteğe bağlı başlangıç değeri alır
    this.showCorners = true,
  });
  // child bilgisini saklar
  final Widget child;
  // padding bilgisini saklar
  final EdgeInsets padding;
  // color bilgisini saklar
  final Color color;
  // border color bilgisini saklar
  final Color? borderColor;
  // show corners bilgisini saklar
  final bool showCorners;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // OrnateCard için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // border için sabit rengi belirler
    final border = borderColor ?? const Color(0xFFDCC898);
    // Canvas ile özel çizimi ekranda gösterir
    return CustomPaint(
      // foreground painter alanına gelen değeri kullanır
      foregroundPainter: showCorners
          // Koşul doğruysa kullanılacak sonucu belirler
          ? OrnateCornerPainter(
              // Rengin saydamlığını belirtilen oranda ayarlar
              color: const Color(0xFFC79F45).withValues(alpha: 0.75),
              // Simgenin veya şeklin boyutunu belirler
              size: 15,
              // inset alanına 5 değerini kullanır
              inset: 5,
            )
          // Koşul yanlışsa kullanılacak sonucu belirler
          : null,
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Container(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: padding,
        // Kutunun arka plan, kenar ve süslerini ayarlar
        decoration: BoxDecoration(
          // Bu elemanın rengini belirler
          color: color,
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(22),
          // Kutunun kenarlık çizgisini oluşturur
          border: Border.all(color: border, width: 1.4),
          // Kutunun gölge ayarlarını belirler
          boxShadow: [
            // Kutunun düşen gölgesini tanımlar
            BoxShadow(
              // Rengin saydamlığını belirtilen oranda ayarlar
              color: const Color(0xFF3E311A).withValues(alpha: 0.08),
              // Gölgenin ne kadar dağıtılacağını belirler
              blurRadius: 18,
              // Çizimin hangi yönde kaydırılacağını belirler
              offset: const Offset(0, 6),
            ),
            // Kutunun düşen gölgesini tanımlar
            BoxShadow(
              // Rengin saydamlığını belirtilen oranda ayarlar
              color: const Color(0xFFDFC682).withValues(alpha: 0.12),
              // Gölgenin ne kadar dağıtılacağını belirler
              blurRadius: 6,
              // Çizimin hangi yönde kaydırılacağını belirler
              offset: const Offset(0, 1),
            ),
          ],
          // Birden fazla rengin geçişini tanımlar
          gradient: LinearGradient(
            // Renk geçişinin başlayacağı yönü belirler
            begin: Alignment.topLeft,
            // Renk geçişinin biteceği yönü belirler
            end: Alignment.bottomRight,
            // Renk geçişinde kullanılacak renkleri listeler
            colors: [
              // Verilen iki renk arasında yumuşak geçiş hesaplar
              Color.lerp(color, Colors.white, 0.4)!,
              // Geçerli renk değerini çizimde kullanır
              color,
              // Verilen iki renk arasında yumuşak geçiş hesaplar
              Color.lerp(color, const Color(0xFFFBF4E4), 0.18)!,
            ],
          ),
        ),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: child,
      ),
    );
  }
}
// Section title with heraldic icon frame and gilded accent.
// Simge ve yan bileşen içeren süslü başlığı oluşturur
class OrnateSectionTitle extends StatelessWidget {
  // OrnateSectionTitle nesnesinin başlangıç bilgilerini alır
  const OrnateSectionTitle(this.label, {super.key, this.trailing, this.icon});
  // label bilgisini saklar
  final String label;
  // trailing bilgisini saklar
  final Widget? trailing;
  // Gösterilecek simgeyi tutar
  final IconData? icon;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // OrnateSectionTitle için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Elemanları yatay yönde sıralar
    return Row(
      // İçeride sıralanacak widgetları listeler
      children: [
        // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
        if (icon != null) ...[
          // Arka plan ve ölçüleri olan bir kutu oluşturur
          Container(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.all(6),
            // Kutunun arka plan, kenar ve süslerini ayarlar
            decoration: BoxDecoration(
              // Bu elemanın rengini belirler
              color: const Color(0xFFFFF2D3),
              // Kutunun veya butonun geometrik biçimini belirler
              shape: BoxShape.circle,
              // Kutunun kenarlık çizgisini oluşturur
              border: Border.all(color: const Color(0xFFE2C886), width: 1.2),
              // Kutunun gölge ayarlarını belirler
              boxShadow: [
                // Kutunun düşen gölgesini tanımlar
                BoxShadow(
                  // Rengin saydamlığını belirtilen oranda ayarlar
                  color: const Color(0xFFC49A28).withValues(alpha: 0.2),
                  // Gölgenin ne kadar dağıtılacağını belirler
                  blurRadius: 6,
                ),
              ],
            ),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Icon(icon, color: const Color(0xFF8B6415), size: 16),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(width: 9),
        ],
        // İçeriğin kalan alanı doldurmasını sağlar
        Expanded(
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Text(
            // Etikette gösterilecek metni aktarır
            label,
            // Yazının ya da butonun görünümünü belirler
            style: Theme.of(context)
                // Aktif temanın metin stillerini kullanır
                .textTheme
                // Temadan ilgili yazı stilini seçer
                .titleLarge
                // Nesne null değilse bu işleme devam eder
                ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.2),
          ),
        ),
        // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
        if (trailing != null) trailing!,
      ],
    );
  }
}
// Duyuru alanının görünümünü oluşturur
// Krallık duyurularını banner olarak gösterir
class HeraldBanner extends StatelessWidget {
  // HeraldBanner nesnesinin başlangıç bilgilerini alır
  const HeraldBanner({super.key, required this.message, required this.accent});
  // mesaj bilgisini saklar
  final String message;
  // Vurgu rengini tutar
  final Color accent;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // HeraldBanner için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: const Color(0xFFDFBF6C), width: 1.4),
        // Birden fazla rengin geçişini tanımlar
        gradient: const LinearGradient(
          // Renk geçişinin başlayacağı yönü belirler
          begin: Alignment.topLeft,
          // Renk geçişinin biteceği yönü belirler
          end: Alignment.bottomRight,
          // Renk geçişinde kullanılacak renkleri listeler
          colors: [Color(0xFFFFF7E2), Color(0xFFF7E7BE)],
        ),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFF7A5C1B).withValues(alpha: 0.12),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 14,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, 4),
          ),
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFFFFD166).withValues(alpha: 0.2),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 8,
          ),
        ],
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Row(
        // İçeride sıralanacak widgetları listeler
        children: [
          // Arka plan ve ölçüleri olan bir kutu oluşturur
          Container(
            // Elemanın genişliğini belirler
            width: 36,
            // Elemanın veya satırın yüksekliğini ayarlar
            height: 36,
            // Kutunun arka plan, kenar ve süslerini ayarlar
            decoration: BoxDecoration(
              // Kutunun veya butonun geometrik biçimini belirler
              shape: BoxShape.circle,
              // Bu elemanın rengini belirler
              color: const Color(0xFF8B2628),
              // Kutunun kenarlık çizgisini oluşturur
              border: Border.all(color: const Color(0xFFFFD166), width: 1.6),
              // Kutunun gölge ayarlarını belirler
              boxShadow: [
                // Kutunun düşen gölgesini tanımlar
                BoxShadow(
                  // Rengin saydamlığını belirtilen oranda ayarlar
                  color: const Color(0xFF8B2628).withValues(alpha: 0.35),
                  // Gölgenin ne kadar dağıtılacağını belirler
                  blurRadius: 6,
                  // Çizimin hangi yönde kaydırılacağını belirler
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: const Icon(Icons.mark_email_unread_rounded,
                // Bu elemanın rengini belirler
                color: Colors.white, size: 18),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(width: 11),
          // İçeriğin kalan alanı doldurmasını sağlar
          Expanded(
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Column(
              // Ana eksene dik yöndeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Ana yönde kaplanacak alanı belirler
              mainAxisSize: MainAxisSize.min,
              // İçeride sıralanacak widgetları listeler
              children: [
                // Ekrana metin yerleştirir
                const Text(
                  // Gösterilecek veya kullanılacak metin parçasını ekler
                  'KRALİYET FERMANI',
                  // Yazının ya da butonun görünümünü belirler
                  style: TextStyle(
                    // Yazının boyutunu belirler
                    fontSize: 9.5,
                    // Yazının kalınlığını belirler
                    fontWeight: FontWeight.w900,
                    // Bu elemanın rengini belirler
                    color: Color(0xFF7A4A0A),
                    // Harfler arasındaki uzaklığı ayarlar
                    letterSpacing: 0.6,
                  ),
                ),
                // Ekrana metin yerleştirir
                Text(
                  // Duyuru metnini widgeta verir
                  message,
                  // Yazının ya da butonun görünümünü belirler
                  style: const TextStyle(
                    // Yazının boyutunu belirler
                    fontSize: 12.5,
                    // Yazının kalınlığını belirler
                    fontWeight: FontWeight.w700,
                    // Elemanın veya satırın yüksekliğini ayarlar
                    height: 1.35,
                    // Bu elemanın rengini belirler
                    color: Color(0xFF282319),
                  ),
                ),
              ],
            ),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(width: 6),
          // Ekrana bir simge yerleştirir
          const Icon(Icons.auto_awesome, color: Color(0xFFB8860B), size: 16),
        ],
      ),
    );
  }
}
// Hero header with an ornate gilded frame and fantasy illuminated styling.
// Üst başlıkta görsel ve metin içeren büyük alanı oluşturur
class FancyHeroHeader extends StatelessWidget {
  // FancyHeroHeader nesnesinin başlangıç bilgilerini alır
  const FancyHeroHeader({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // başlık parametresini zorunlu tutar
    required this.title,
    // subtitle parametresini zorunlu tutar
    required this.subtitle,
    // asset path parametresini zorunlu tutar
    required this.assetPath,
    // height için isteğe bağlı başlangıç değeri alır
    this.height = 220,
    // rozet için isteğe bağlı başlangıç değeri alır
    this.badge,
  });
  // Başlık metnini tutar
  final String title;
  // subtitle bilgisini saklar
  final String subtitle;
  // asset path bilgisini saklar
  final String assetPath;
  // height bilgisini saklar
  final double height;
  // rozet bilgisini saklar
  final Widget? badge;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // FancyHeroHeader için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(26),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: const Color(0xFFDFC47E), width: 2),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFF382910).withValues(alpha: 0.16),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 22,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: ClipRRect(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(24),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Stack(
          // İçeride sıralanacak widgetları listeler
          children: [
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            SizedBox(
              // Elemanın veya satırın yüksekliğini ayarlar
              height: height,
              // Elemanın genişliğini belirler
              width: double.infinity,
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
            // Öğeyi mevcut alanın tamamına yayar
            Positioned.fill(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: DecoratedBox(
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: BoxDecoration(
                  // Birden fazla rengin geçişini tanımlar
                  gradient: LinearGradient(
                    // Renk geçişinin başlayacağı yönü belirler
                    begin: Alignment.bottomCenter,
                    // Renk geçişinin biteceği yönü belirler
                    end: Alignment.topCenter,
                    // Renk geçişinde kullanılacak renkleri listeler
                    colors: [
                      // Renk tonuna belirtilen saydamlık oranını uygular
                      Colors.black.withValues(alpha: .68),
                      // Renk tonuna belirtilen saydamlık oranını uygular
                      Colors.black.withValues(alpha: .22),
                      // Renk tonuna belirtilen saydamlık oranını uygular
                      Colors.black.withValues(alpha: .04),
                    ],
                    // Renklerin geçiş noktalarını belirler
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Ornate Corner Painter over the image
            // Öğeyi Stack içinde belirli konuma yerleştirir
            const Positioned.fill(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: CustomPaint(
                // painter alanına gelen değeri kullanır
                painter: OrnateCornerPainter(
                  // Bu elemanın rengini belirler
                  color: Color(0xFFFFE082),
                  // Simgenin veya şeklin boyutunu belirler
                  size: 20,
                  // inset alanına 8 değerini kullanır
                  inset: 8,
                ),
              ),
            ),
            // Öğeyi Stack içinde belirli konuma yerleştirir
            Positioned(
              // left alanına 14 değerini kullanır
              left: 14,
              // right alanına 14 değerini kullanır
              right: 14,
              // bottom alanına 14 değerini kullanır
              bottom: 14,
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Row(
                // Ana eksene dik yöndeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.end,
                // İçeride sıralanacak widgetları listeler
                children: [
                  // İçeriğin kalan alanı doldurmasını sağlar
                  Expanded(
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Container(
                      // İçeriğin kenarlara olan uzaklığını ayarlar
                      padding: const EdgeInsets.symmetric(
                          // horizontal alanına 14, vertical: 11) değerini kullanır
                          horizontal: 14, vertical: 11),
                      // Kutunun arka plan, kenar ve süslerini ayarlar
                      decoration: BoxDecoration(
                        // Rengin saydamlığını belirtilen oranda ayarlar
                        color: Colors.white.withValues(alpha: .92),
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(18),
                        // Kutunun kenarlık çizgisini oluşturur
                        border: Border.all(
                            // Bu elemanın rengini belirler
                            color: const Color(0xFFDFC47E), width: 1.4),
                        // Kutunun gölge ayarlarını belirler
                        boxShadow: [
                          // Kutunun düşen gölgesini tanımlar
                          BoxShadow(
                            // Rengin saydamlığını belirtilen oranda ayarlar
                            color: Colors.black.withValues(alpha: 0.14),
                            // Gölgenin ne kadar dağıtılacağını belirler
                            blurRadius: 10,
                            // Çizimin hangi yönde kaydırılacağını belirler
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // Bu widgetın içinde gösterilecek elemanı yerleştirir
                      child: Column(
                        // Ana eksene dik yöndeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // İçeride sıralanacak widgetları listeler
                        children: [
                          // Elemanları yatay yönde sıralar
                          Row(
                            // İçeride sıralanacak widgetları listeler
                            children: [
                              // Ekrana bir simge yerleştirir
                              const Icon(Icons.shield_moon_outlined,
                                  // Simgenin veya şeklin boyutunu belirler
                                  size: 14, color: Color(0xFFB8860B)),
                              // Belirtilen ölçülerde boşluk veya alan oluşturur
                              const SizedBox(width: 5),
                              // İçeriğin kalan alanı doldurmasını sağlar
                              Expanded(
                                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                child: Text(
                                  // Başlık metnini gösterir
                                  title,
                                  // Metnin veya giriş alanının en fazla satır sayısını belirler
                                  maxLines: 1,
                                  // Uzun metnin alana sığmayınca nasıl davranacağını belirler
                                  overflow: TextOverflow.ellipsis,
                                  // Yazının ya da butonun görünümünü belirler
                                  style: Theme.of(context)
                                      // Aktif temanın metin stillerini kullanır
                                      .textTheme
                                      // Temadan ilgili yazı stilini seçer
                                      .headlineSmall
                                      // Nesne null değilse bu işleme devam eder
                                      ?.copyWith(
                                          // Yazının kalınlığını belirler
                                          fontWeight: FontWeight.w900,
                                          // Yazının boyutunu belirler
                                          fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          // Belirtilen ölçülerde boşluk veya alan oluşturur
                          const SizedBox(height: 3),
                          // Ekrana metin yerleştirir
                          Text(
                            // Alt başlık metnini gösterir
                            subtitle,
                            // Yazının ya da butonun görünümünü belirler
                            style: Theme.of(context)
                                // Aktif temanın metin stillerini kullanır
                                .textTheme
                                // Temadan ilgili yazı stilini seçer
                                .bodySmall
                                // Nesne null değilse bu işleme devam eder
                                ?.copyWith(
                                    // Bu elemanın rengini belirler
                                    color: const Color(0xFF4C4538),
                                    // Elemanın veya satırın yüksekliğini ayarlar
                                    height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
                  if (badge != null) ...[
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(width: 10),
                    // Rozet bilgisinin null olmadığını belirtip gösterir
                    badge!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Arka planda renk geçişi oluşturur
// Krallık temasına uygun özel buton oluşturur
class OrnateButton extends StatelessWidget {
  // OrnateButton nesnesinin başlangıç bilgilerini alır
  const OrnateButton({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // label parametresini zorunlu tutar
    required this.label,
    // on pressed parametresini zorunlu tutar
    required this.onPressed,
    // icon için isteğe bağlı başlangıç değeri alır
    this.icon,
    // expanded için isteğe bağlı başlangıç değeri alır
    this.expanded = false,
  });
  // label bilgisini saklar
  final String label;
  // on pressed bilgisini saklar
  final VoidCallback? onPressed;
  // Gösterilecek simgeyi tutar
  final IconData? icon;
  // Kartın genişletilip genişletilmediğini tutar
  final bool expanded;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // OrnateButton için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // enabled bilgisini saklar
    final isEnabled = onPressed != null;
    // button bilgisini saklar
    final button = InkWell(
      // Dokunulduğunda çalışacak işlemi bağlar
      onTap: onPressed,
      // Köşelerin yuvarlaklığını belirler
      borderRadius: BorderRadius.circular(20),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Ink(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        // Kutunun arka plan, kenar ve süslerini ayarlar
        decoration: BoxDecoration(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(20),
          // Kutunun kenarlık çizgisini oluşturur
          border: Border.all(
            // Bu elemanın rengini belirler
            color:
                // Buton aktifse parlak, pasifse soluk çerçeve rengi kullanır
                isEnabled ? const Color(0xFFE5C568) : const Color(0xFFC7BFB1),
            // Elemanın genişliğini belirler
            width: 1.4,
          ),
          // Birden fazla rengin geçişini tanımlar
          gradient: LinearGradient(
            // Renk geçişinin başlayacağı yönü belirler
            begin: Alignment.topLeft,
            // Renk geçişinin biteceği yönü belirler
            end: Alignment.bottomRight,
            // Renk geçişinde kullanılacak renkleri listeler
            colors: !isEnabled
                // Koşul doğruysa kullanılacak sonucu belirler
                ? [const Color(0xFFE4DDD2), const Color(0xFFD8D1C5)]
                // Koşul yanlışsa kullanılacak sonucu belirler
                : [const Color(0xFF2E5399), const Color(0xFF16325E)],
          ),
          // Kutunun gölge ayarlarını belirler
          boxShadow: isEnabled
              // Koşul doğruysa kullanılacak sonucu belirler
              ? [
                  // Kutunun düşen gölgesini tanımlar
                  BoxShadow(
                    // Rengin saydamlığını belirtilen oranda ayarlar
                    color: const Color(0xFF1E386B).withValues(alpha: .28),
                    // Gölgenin ne kadar dağıtılacağını belirler
                    blurRadius: 14,
                    // Çizimin hangi yönde kaydırılacağını belirler
                    offset: const Offset(0, 5),
                  ),
                  // Kutunun düşen gölgesini tanımlar
                  BoxShadow(
                    // Rengin saydamlığını belirtilen oranda ayarlar
                    color: const Color(0xFFFFD56B).withValues(alpha: .2),
                    // Gölgenin ne kadar dağıtılacağını belirler
                    blurRadius: 6,
                  ),
                ]
              // Koşul yanlışsa kullanılacak sonucu belirler
              : null,
        ),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Row(
          // Ana yönde kaplanacak alanı belirler
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          // Ana yöndeki hizalamayı belirler
          mainAxisAlignment: MainAxisAlignment.center,
          // İçeride sıralanacak widgetları listeler
          children: [
            // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
            if (icon != null) ...[
              // Arka plan ve ölçüleri olan bir kutu oluşturur
              Container(
                // Elemanın genişliğini belirler
                width: 26,
                // Elemanın veya satırın yüksekliğini ayarlar
                height: 26,
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: BoxDecoration(
                  // Rengin saydamlığını belirtilen oranda ayarlar
                  color: Colors.white.withValues(alpha: .18),
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(20),
                  // Kutunun kenarlık çizgisini oluşturur
                  border:
                      // Kutunun dört kenarına çizgi ekler
                      Border.all(color: const Color(0xFFFFDF7D), width: 1.0),
                ),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Icon(icon, size: 15, color: const Color(0xFFFFECB3)),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(width: 9),
            ],
            // İçeriğin esneyip mevcut alana sığmasını sağlar
            Flexible(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text(
                // Etikette gösterilecek metni aktarır
                label,
                // text align alanına gelen değeri kullanır
                textAlign: TextAlign.center,
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(
                  // Bu elemanın rengini belirler
                  color: isEnabled ? Colors.white : const Color(0xFF7E776C),
                  // Yazının kalınlığını belirler
                  fontWeight: FontWeight.w800,
                  // Yazının boyutunu belirler
                  fontSize: 14.5,
                  // Harfler arasındaki uzaklığı ayarlar
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // Hesaplanan değeri çağıran yere geri döndürür
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
// Bir istatistiği küçük kart içinde gösterir
class MiniStatCard extends StatelessWidget {
  // MiniStatCard nesnesinin başlangıç bilgilerini alır
  const MiniStatCard({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // label parametresini zorunlu tutar
    required this.label,
    // value parametresini zorunlu tutar
    required this.value,
    // icon parametresini zorunlu tutar
    required this.icon,
    // color parametresini zorunlu tutar
    required this.color,
  });
  // label bilgisini saklar
  final String label;
  // value bilgisini saklar
  final String value;
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // color bilgisini saklar
  final Color color;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // MiniStatCard için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Yeni OrnateCard nesnesi oluşturup döndürür
    return OrnateCard(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      // Bu elemanın rengini belirler
      color: color,
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Column(
        // Ana eksene dik yöndeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // İçeride sıralanacak widgetları listeler
        children: [
          // Elemanları yatay yönde sıralar
          Row(
            // Ana yöndeki hizalamayı belirler
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Ekrana bir simge yerleştirir
              Icon(icon, size: 18, color: RealmPalette.ink),
              // Ekrana bir simge yerleştirir
              const Icon(Icons.diamond_outlined,
                  // Simgenin veya şeklin boyutunu belirler
                  size: 10, color: Color(0xFFB8860B)),
            ],
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 7),
          // fitted box bileşenini oluşturur
          FittedBox(
            // Görselin ayrılan alana nasıl sığacağını belirler
            fit: BoxFit.scaleDown,
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Text(
              // Hesaplanan sayıyı widgeta gönderir
              value,
              // Yazının ya da butonun görünümünü belirler
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 2),
          // Ekrana metin yerleştirir
          Text(
            // Etikette gösterilecek metni aktarır
            label,
            // Yazının ya da butonun görünümünü belirler
            style: const TextStyle(
              // Yazının boyutunu belirler
              fontSize: 9.5,
              // Yazının kalınlığını belirler
              fontWeight: FontWeight.w800,
              // Harfler arasındaki uzaklığı ayarlar
              letterSpacing: .3,
              // Bu elemanın rengini belirler
              color: Color(0xFF4C4538),
            ),
          ),
        ],
      ),
    );
  }
}
// İlerlemeyi süslü bir çubukla gösterir
class OrnateProgressBar extends StatelessWidget {
  // OrnateProgressBar nesnesinin başlangıç bilgilerini alır
  const OrnateProgressBar({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // value parametresini zorunlu tutar
    required this.value,
    // color parametresini zorunlu tutar
    required this.color,
    // arka plan için isteğe bağlı başlangıç değeri alır
    this.background = const Color(0xFFE9E0CC),
    // height için isteğe bağlı başlangıç değeri alır
    this.height = 13,
  });
  // value bilgisini saklar
  final double value;
  // color bilgisini saklar
  final Color color;
  // arka plan bilgisini saklar
  final Color background;
  // height bilgisini saklar
  final double height;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // OrnateProgressBar için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // Elemanın veya satırın yüksekliğini ayarlar
      height: height,
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Bu elemanın rengini belirler
        color: background,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(30),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: const Color(0xFFD8C7A2), width: 1.2),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: Colors.black.withValues(alpha: 0.04),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 4,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, 1),
          ),
        ],
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: ClipRRect(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(30),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: FractionallySizedBox(
          // İçeriğin hangi tarafa hizalanacağını belirler
          alignment: Alignment.centerLeft,
          // width factor alanına değeri belirtilen aralıkta sınırlar
          widthFactor: value.clamp(0.0, 1.0),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Container(
            // Kutunun arka plan, kenar ve süslerini ayarlar
            decoration: BoxDecoration(
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(30),
              // Birden fazla rengin geçişini tanımlar
              gradient: LinearGradient(
                // Renk geçişinde kullanılacak renkleri listeler
                colors: [
                  // Verilen iki renk arasında yumuşak geçiş hesaplar
                  Color.lerp(color, Colors.white, .25)!,
                  // Geçerli renk değerini çizimde kullanır
                  color,
                  // Verilen iki renk arasında yumuşak geçiş hesaplar
                  Color.lerp(color, const Color(0xFFFFD166), .2)!,
                ],
              ),
              // Kutunun gölge ayarlarını belirler
              boxShadow: [
                // Kutunun düşen gölgesini tanımlar
                BoxShadow(
                  // Rengin saydamlığını belirtilen oranda ayarlar
                  color: color.withValues(alpha: 0.4),
                  // Gölgenin ne kadar dağıtılacağını belirler
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Çerçeveli simge rozetini oluşturur
class FramedIconBadge extends StatelessWidget {
  // FramedIconBadge nesnesinin başlangıç bilgilerini alır
  const FramedIconBadge({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // icon parametresini zorunlu tutar
    required this.icon,
    // label parametresini zorunlu tutar
    required this.label,
    // value parametresini zorunlu tutar
    required this.value,
    // color parametresini zorunlu tutar
    required this.color,
  });
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // label bilgisini saklar
  final String label;
  // value bilgisini saklar
  final String value;
  // color bilgisini saklar
  final Color color;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // FramedIconBadge için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Rengin saydamlığını belirtilen oranda ayarlar
        color: Colors.white.withValues(alpha: .94),
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: const Color(0xFFDFC57C), width: 1.4),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFF4A3816).withValues(alpha: 0.1),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 8,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Row(
        // Ana yönde kaplanacak alanı belirler
        mainAxisSize: MainAxisSize.min,
        // İçeride sıralanacak widgetları listeler
        children: [
          // Arka plan ve ölçüleri olan bir kutu oluşturur
          Container(
            // Elemanın genişliğini belirler
            width: 32,
            // Elemanın veya satırın yüksekliğini ayarlar
            height: 32,
            // Kutunun arka plan, kenar ve süslerini ayarlar
            decoration: BoxDecoration(
              // Kutunun veya butonun geometrik biçimini belirler
              shape: BoxShape.circle,
              // Rengin saydamlığını belirtilen oranda ayarlar
              color: color.withValues(alpha: .18),
              // Kutunun kenarlık çizgisini oluşturur
              border:
                  // Kutunun dört kenarına çizgi ekler
                  Border.all(color: color.withValues(alpha: .4), width: 1.2),
            ),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: Icon(icon, size: 17, color: color),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(width: 9),
          // Elemanları dikey yönde sıralar
          Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // Ana yönde kaplanacak alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Ekrana metin yerleştirir
              Text(
                // Hesaplanan sayıyı widgeta gönderir
                value,
                // Yazının ya da butonun görünümünü belirler
                style:
                    // Metnin renk, boyut ve kalınlığını belirler
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
              // Ekrana metin yerleştirir
              Text(
                // Etikette gösterilecek metni aktarır
                label,
                // Yazının ya da butonun görünümünü belirler
                style: const TextStyle(
                    // Yazının boyutunu belirler
                    fontSize: 9.5,
                    // Yazının kalınlığını belirler
                    fontWeight: FontWeight.w700,
                    // Bu elemanın rengini belirler
                    color: Color(0xFF6B6559)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

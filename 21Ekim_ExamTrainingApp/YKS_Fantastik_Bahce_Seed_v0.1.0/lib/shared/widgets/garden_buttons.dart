// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
/// Ana eylemler için mercan (`peachCoral`) veya zümrüt (`mossEmerald`)
/// renkli, basılma animasyonlu, ışık/gölge detaylarına sahip ana buton.
// garden primary button için değişen verileri yöneten StatefulWidget kullanılır
class GardenPrimaryButton extends StatefulWidget {
  // garden primary button nesnesini oluşturur
  const GardenPrimaryButton({
    // etiket bilgisini zorunlu tutar
    required this.label,
    // buton fonksiyonu bilgisini zorunlu tutar
    required this.onPressed,
    // simge bilgisini isteğe bağlı alır
    this.icon,
    // is secondary bilgisini isteğe bağlı alır
    this.isSecondary = false,
    // yükleme durumu bilgisini isteğe bağlı alır
    this.isLoading = false,
    // genişlik bilgisini isteğe bağlı alır
    this.width,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 50,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // etiket bilgisini tutar
  final String label;
  // buton fonksiyonu bilgisini tutar
  final VoidCallback? onPressed;
  // simge bilgisini tutar
  final IconData? icon;
  // is secondary bilgisini tutar
  final bool isSecondary;
  // yükleme durumu bilgisini tutar
  final bool isLoading;
  // genişlik bilgisini tutar
  final double? width;
  // yükseklik bilgisini tutar
  final double height;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<GardenPrimaryButton> createState() => _GardenPrimaryButtonState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _GardenPrimaryButtonState extends State<GardenPrimaryButton> {
  // is pressed durumunu başlangıçta belirler
  bool _isPressed = false;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // etkinlik durumu bilgisini iki değeri karşılaştırarak hesaplar
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    // base renk bilgisini hesaplayıp saklar
    final baseColor = widget.isSecondary
        // Koşul doğruysa bu değeri kullanır
        ? GardenPalette.mossEmerald
        // Koşul yanlışsa bu değeri kullanır
        : GardenPalette.peachCoral;
    // gradient end değerini tanımlar
    final gradientEnd =
        // Koşula göre iki değerden birini seçer
        widget.isSecondary ? const Color(0xFF3B6B45) : const Color(0xFFD46D4E);
    // animated scale nesnesini oluşturur
    return AnimatedScale(
      // scale bilgisini belirler
      scale: _isPressed ? 0.96 : 1.0,
      // Animasyonun süresini belirler
      duration: const Duration(milliseconds: 100),
      // Animasyonun hareket şeklini belirler
      curve: Curves.easeInOut,
      // İçine yerleştirilecek widgetı belirler
      child: Container(
        // Genişliği belirler
        width: widget.width,
        // Yüksekliği belirler
        height: widget.height,
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(16),
          // Renk geçişini belirler
          gradient: isEnabled
              // Koşul doğruysa bu değeri kullanır
              ? LinearGradient(
                  // begin bilgisini belirler
                  begin: Alignment.topLeft,
                  // end bilgisini belirler
                  end: Alignment.bottomRight,
                  // renkler bilgisini belirler
                  colors: [baseColor, gradientEnd],
                )
              // Koşul yanlışsa bu değeri kullanır
              : null,
          // Rengi belirler
          color: isEnabled ? null : Colors.grey.shade400,
          // Gölge ayarlarını belirler
          boxShadow: isEnabled
              // Koşul doğruysa bu değeri kullanır
              ? [
                  // Kutuya gölge ayarı ekler
                  BoxShadow(
                    // Rengi belirler
                    color: baseColor.withAlpha(75),
                    // Gölgenin konumunu belirler
                    offset: const Offset(0, 4),
                    // Gölgenin bulanıklığını belirler
                    blurRadius: 10,
                  ),
                ]
              // Koşul yanlışsa bu değeri kullanır
              : null,
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Material(
          // Rengi belirler
          color: Colors.transparent,
          // İçine yerleştirilecek widgetı belirler
          child: InkWell(
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(16),
            // Dokunulunca çalışacak fonksiyonu belirler
            onTap: isEnabled ? widget.onPressed : null,
            // on tap down olayındaki fonksiyonu belirler
            onTapDown: (_) => setState(() => _isPressed = true),
            // on tap up olayındaki fonksiyonu belirler
            onTapUp: (_) => setState(() => _isPressed = false),
            // on tap cancel olayındaki fonksiyonu belirler
            onTapCancel: () => setState(() => _isPressed = false),
            // İçine yerleştirilecek widgetı belirler
            child: Center(
              // İçine yerleştirilecek widgetı belirler
              child: widget.isLoading
                  // Koşul doğruysa bu değeri kullanır
                  ? const SizedBox(
                      // Genişliği belirler
                      width: 22,
                      // Yüksekliği belirler
                      height: 22,
                      // İçine yerleştirilecek widgetı belirler
                      child: CircularProgressIndicator(
                        // Çizgi kalınlığını belirler
                        strokeWidth: 2.5,
                        // İlerleme göstergesinin rengini belirler
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  // Koşul yanlışsa bu değeri kullanır
                  : Row(
                      // Ana eksende kaplanacak alanı belirler
                      mainAxisSize: MainAxisSize.min,
                      // Ana eksendeki hizalamayı belirler
                      mainAxisAlignment: MainAxisAlignment.center,
                      // İçerideki widgetları listeler
                      children: [
                        // İlgili değer null değilse kontrol eder
                        if (widget.icon != null) ...[
                          // Simge gösterir
                          Icon(widget.icon, color: Colors.white, size: 20),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(width: 8),
                        ],
                        // Esneyebilen alan oluşturur
                        Flexible(
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            widget.label,
                            // Gösterilecek en fazla satır sayısını belirler
                            maxLines: 1,
                            // Uzun yazının taşma şeklini belirler
                            overflow: TextOverflow.ellipsis,
                            // Görünüm stilini belirler
                            style: const TextStyle(
                              // Rengi belirler
                              color: Colors.white,
                              // Yazı boyutunu belirler
                              fontSize: 15,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.w700,
                              // Harfler arasındaki boşluğu belirler
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
/// Özel başarı ve hedef eylemleri için altın vurgulu buton.
// golden action button için değişen verileri yöneten StatefulWidget kullanılır
class GoldenActionButton extends StatefulWidget {
  // golden action button nesnesini oluşturur
  const GoldenActionButton({
    // etiket bilgisini zorunlu tutar
    required this.label,
    // buton fonksiyonu bilgisini zorunlu tutar
    required this.onPressed,
    // simge bilgisini isteğe bağlı alır
    this.icon = Icons.auto_awesome,
    // badge metin bilgisini isteğe bağlı alır
    this.badgeText,
    // genişlik bilgisini isteğe bağlı alır
    this.width,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 48,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // etiket bilgisini tutar
  final String label;
  // buton fonksiyonu bilgisini tutar
  final VoidCallback? onPressed;
  // simge bilgisini tutar
  final IconData icon;
  // badge metin bilgisini tutar
  final String? badgeText;
  // genişlik bilgisini tutar
  final double? width;
  // yükseklik bilgisini tutar
  final double height;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<GoldenActionButton> createState() => _GoldenActionButtonState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _GoldenActionButtonState extends State<GoldenActionButton> {
  // is pressed durumunu başlangıçta belirler
  bool _isPressed = false;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // etkinlik durumu bilgisini iki değeri karşılaştırarak hesaplar
    final isEnabled = widget.onPressed != null;
    // animated scale nesnesini oluşturur
    return AnimatedScale(
      // scale bilgisini belirler
      scale: _isPressed ? 0.96 : 1.0,
      // Animasyonun süresini belirler
      duration: const Duration(milliseconds: 100),
      // İçine yerleştirilecek widgetı belirler
      child: Container(
        // Genişliği belirler
        width: widget.width,
        // Yüksekliği belirler
        height: widget.height,
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(16),
          // Renk geçişini belirler
          gradient: isEnabled
              // Koşul doğruysa bu değeri kullanır
              ? const LinearGradient(
                  // renkler bilgisini belirler
                  colors: [
                    // Temadan renk veya görünüm değeri alır
                    GardenPalette.honeyLight,
                    // Temadan renk veya görünüm değeri alır
                    GardenPalette.harvestGold,
                  ],
                  // begin bilgisini belirler
                  begin: Alignment.topLeft,
                  // end bilgisini belirler
                  end: Alignment.bottomRight,
                )
              // Koşul yanlışsa bu değeri kullanır
              : null,
          // Rengi belirler
          color: isEnabled ? null : Colors.grey.shade400,
          // Kenarlığı belirler
          border: Border.all(
            // Rengi belirler
            color: isEnabled ? const Color(0xFFDFB356) : Colors.transparent,
            // Genişliği belirler
            width: 1.2,
          ),
          // Gölge ayarlarını belirler
          boxShadow: isEnabled
              // Koşul doğruysa bu değeri kullanır
              ? [
                  // Kutuya gölge ayarı ekler
                  BoxShadow(
                    // Rengi belirler
                    color: GardenPalette.harvestGold.withAlpha(80),
                    // Gölgenin konumunu belirler
                    offset: const Offset(0, 3),
                    // Gölgenin bulanıklığını belirler
                    blurRadius: 8,
                  ),
                ]
              // Koşul yanlışsa bu değeri kullanır
              : null,
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Material(
          // Rengi belirler
          color: Colors.transparent,
          // İçine yerleştirilecek widgetı belirler
          child: InkWell(
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(16),
            // Dokunulunca çalışacak fonksiyonu belirler
            onTap: widget.onPressed,
            // on tap down olayındaki fonksiyonu belirler
            onTapDown: (_) => setState(() => _isPressed = true),
            // on tap up olayındaki fonksiyonu belirler
            onTapUp: (_) => setState(() => _isPressed = false),
            // on tap cancel olayındaki fonksiyonu belirler
            onTapCancel: () => setState(() => _isPressed = false),
            // İçine yerleştirilecek widgetı belirler
            child: Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(horizontal: 16),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // Ana eksende kaplanacak alanı belirler
                mainAxisSize: MainAxisSize.min,
                // Ana eksendeki hizalamayı belirler
                mainAxisAlignment: MainAxisAlignment.center,
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  Icon(widget.icon, color: GardenPalette.inkPlum, size: 20),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Esneyebilen alan oluşturur
                  Flexible(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      widget.label,
                      // Gösterilecek en fazla satır sayısını belirler
                      maxLines: 1,
                      // Uzun yazının taşma şeklini belirler
                      overflow: TextOverflow.ellipsis,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Rengi belirler
                        color: GardenPalette.inkPlum,
                        // Yazı boyutunu belirler
                        fontSize: 14,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // İlgili değer null değilse kontrol eder
                  if (widget.badgeText != null) ...[
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(width: 8),
                    // Görsel bir kutu oluşturur
                    Container(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.symmetric(
                          // horizontal bilgisini belirler
                          horizontal: 8, vertical: 2),
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: BoxDecoration(
                        // Rengi belirler
                        color: GardenPalette.inkPlum,
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // İçine yerleştirilecek widgetı belirler
                      child: Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        widget.badgeText!,
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Rengi belirler
                          color: GardenPalette.honeyLight,
                          // Yazı boyutunu belirler
                          fontSize: 11,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/// İkon çevresinde hafif yaprak, tomurcuk veya doğal çerçeve ayrıntıları.
// botanical icon button bölümünü oluşturan StatelessWidget sınıfı
class BotanicalIconButton extends StatelessWidget {
  // botanical icon button nesnesini oluşturur
  const BotanicalIconButton({
    // simge bilgisini zorunlu tutar
    required this.icon,
    // buton fonksiyonu bilgisini zorunlu tutar
    required this.onPressed,
    // tooltip bilgisini isteğe bağlı alır
    this.tooltip,
    // boyut bilgisini isteğe bağlı alır
    this.size = 44,
    // icon size bilgisini isteğe bağlı alır
    this.iconSize = 22,
    // arka plan rengi bilgisini isteğe bağlı alır
    this.backgroundColor,
    // icon renk bilgisini isteğe bağlı alır
    this.iconColor,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // simge bilgisini tutar
  final IconData icon;
  // buton fonksiyonu bilgisini tutar
  final VoidCallback? onPressed;
  // tooltip bilgisini tutar
  final String? tooltip;
  // boyut bilgisini tutar
  final double size;
  // icon size bilgisini tutar
  final double iconSize;
  // arka plan rengi bilgisini tutar
  final Color? backgroundColor;
  // icon renk bilgisini tutar
  final Color? iconColor;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // bg bilgisini hesaplayıp saklar
    final bg = backgroundColor ??
        // Yeni değer veya liste oluşturur
        (isDark ? GardenPalette.nightCard : GardenPalette.lightSage);
    // fg değerini tanımlar
    final fg =
        // Koşula göre iki değerden birini seçer
        iconColor ?? (isDark ? const Color(0xFFA4D49B) : GardenPalette.inkPlum);
    // button bilgisini hesaplayıp saklar
    final button = Material(
      // Rengi belirler
      color: Colors.transparent,
      // İçine yerleştirilecek widgetı belirler
      child: InkWell(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(size / 2),
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: onPressed,
        // İçine yerleştirilecek widgetı belirler
        child: Container(
          // Genişliği belirler
          width: size,
          // Yüksekliği belirler
          height: size,
          // Kutu ve kenarlık görünümünü belirler
          decoration: BoxDecoration(
            // Widgetın kenar şeklini belirler
            shape: BoxShape.circle,
            // Rengi belirler
            color: bg,
            // Kenarlığı belirler
            border: Border.all(
              // Rengi belirler
              color: GardenPalette.mossEmerald.withAlpha(45),
              // Genişliği belirler
              width: 1.5,
            ),
          ),
          // İçine yerleştirilecek widgetı belirler
          child: Icon(icon, size: iconSize, color: fg),
        ),
      ),
    );
    // İlgili değer null değilse kontrol eder
    if (tooltip != null) {
      // Üzerine gelince açıklama gösterir
      return Tooltip(message: tooltip!, child: button);
    }
    // Hesaplanan sonucu döndürür
    return button;
  }
}
/// TYT/AYT, filtre ve görünüm seçimleri için özgün sekmeli kontrol.
// nature segmented control bölümünü oluşturan StatelessWidget sınıfı
class NatureSegmentedControl<T> extends StatelessWidget {
  // nature segmented control nesnesini oluşturur
  const NatureSegmentedControl({
    // öğeler bilgisini zorunlu tutar
    required this.items,
    // seçili olma durumu bilgisini zorunlu tutar
    required this.selected,
    // on changed bilgisini zorunlu tutar
    required this.onChanged,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // öğeler bilgisini tutar
  final Map<T, String> items;
  // seçili olma durumu bilgisini tutar
  final T selected;
  // on changed bilgisini tutar
  final ValueChanged<T> onChanged;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Görsel bir kutu oluşturur
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.all(4),
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(16),
        // Kenarlığı belirler
        border: Border.all(
          // Rengi belirler
          color: GardenPalette.mossEmerald.withAlpha(35),
          // Genişliği belirler
          width: 1,
        ),
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // Ana eksende kaplanacak alanı belirler
        mainAxisSize: MainAxisSize.min,
        // İçerideki widgetları listeler
        children: items.entries.map((entry) {
          // is seçilen bilgisini iki değeri karşılaştırarak hesaplar
          final isSelected = entry.key == selected;
          // Kalan boşluğu kullanacak alan oluşturur
          return Expanded(
            // İçine yerleştirilecek widgetı belirler
            child: GestureDetector(
              // Dokunulunca çalışacak fonksiyonu belirler
              onTap: () => onChanged(entry.key),
              // behavior bilgisini belirler
              behavior: HitTestBehavior.opaque,
              // İçine yerleştirilecek widgetı belirler
              child: AnimatedContainer(
                // Animasyonun süresini belirler
                duration: const Duration(milliseconds: 200),
                // Animasyonun hareket şeklini belirler
                curve: Curves.easeInOut,
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(vertical: 10),
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(12),
                  // Rengi belirler
                  color: isSelected
                      // Koşul doğruysa bu değeri kullanır
                      ? (isDark
                          // Koşul doğruysa bu değeri kullanır
                          ? GardenPalette.mossEmerald
                          // Koşul yanlışsa bu değeri kullanır
                          : GardenPalette.mossEmerald)
                      // Koşul yanlışsa bu değeri kullanır
                      : Colors.transparent,
                  // Gölge ayarlarını belirler
                  boxShadow: isSelected
                      // Koşul doğruysa bu değeri kullanır
                      ? [
                          // Kutuya gölge ayarı ekler
                          BoxShadow(
                            // Rengi belirler
                            color: Colors.black.withAlpha(25),
                            // Gölgenin konumunu belirler
                            offset: const Offset(0, 2),
                            // Gölgenin bulanıklığını belirler
                            blurRadius: 4,
                          ),
                        ]
                      // Koşul yanlışsa bu değeri kullanır
                      : null,
                ),
                // İçine yerleştirilecek widgetı belirler
                child: Center(
                  // İçine yerleştirilecek widgetı belirler
                  child: Text(
                    // İlgili değeri veya görünüm ayarını belirler
                    entry.value,
                    // Görünüm stilini belirler
                    style: TextStyle(
                      // Rengi belirler
                      color: isSelected
                          // Koşul doğruysa bu değeri kullanır
                          ? Colors.white
                          // Koşul yanlışsa bu değeri kullanır
                          : (isDark
                              // Koşul doğruysa bu değeri kullanır
                              ? const Color(0xFFF8F2E8)
                              // Koşul yanlışsa bu değeri kullanır
                              : GardenPalette.inkPlum),
                      // Yazı kalınlığını belirler
                      fontWeight:
                          // Koşula göre iki değerden birini seçer
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      // Yazı boyutunu belirler
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        // Sonuçları listeye çevirir
        }).toList(),
      ),
    );
  }
}

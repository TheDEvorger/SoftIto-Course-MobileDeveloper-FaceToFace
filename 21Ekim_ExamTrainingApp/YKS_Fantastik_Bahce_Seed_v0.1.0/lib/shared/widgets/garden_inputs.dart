// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// services dosyasını kullanıma ekler
import 'package:flutter/services.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum ScoreFieldType { correct, wrong, blank }
/// Özgün doğru / yanlış / boş giriş hücresi.
/// Büyük, okunaklı, klavye uyumlu ve belirgin renkli kenarlıklar.
// garden deneme score field bölümünü oluşturan StatelessWidget sınıfı
class GardenExamScoreField extends StatelessWidget {
  // garden deneme score field nesnesini oluşturur
  const GardenExamScoreField({
    // controller bilgisini zorunlu tutar
    required this.controller,
    // type bilgisini zorunlu tutar
    required this.type,
    // on changed bilgisini isteğe bağlı alır
    this.onChanged,
    // max value bilgisini isteğe bağlı alır
    this.maxValue = 40,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // controller bilgisini tutar
  final TextEditingController controller;
  // type bilgisini tutar
  final ScoreFieldType type;
  // Değerleri karşılaştırır
  final ValueChanged<String>? onChanged;
  // max value bilgisini tutar
  final int maxValue;
  // etiket işlemini yapar
  String get _label {
    // Değere göre uygun durumu seçer
    switch (type) {
      // score field type.correct durumu için çalışır
      case ScoreFieldType.correct:
        // "Doğru" metnini kullanır
        return 'Doğru';
      // score field type.wrong durumu için çalışır
      case ScoreFieldType.wrong:
        // "Yanlış" metnini kullanır
        return 'Yanlış';
      // score field type.blank durumu için çalışır
      case ScoreFieldType.blank:
        // "Boş" metnini kullanır
        return 'Boş';
    }
  }
  // accent renk işlemini yapar
  Color get _accentColor {
    // Değere göre uygun durumu seçer
    switch (type) {
      // score field type.correct durumu için çalışır
      case ScoreFieldType.correct:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.mossEmerald;
      // score field type.wrong durumu için çalışır
      case ScoreFieldType.wrong:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.peachCoral;
      // score field type.blank durumu için çalışır
      case ScoreFieldType.blank:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.streamTurquoise;
    }
  }
  // simge işlemini yapar
  IconData get _icon {
    // Değere göre uygun durumu seçer
    switch (type) {
      // score field type.correct durumu için çalışır
      case ScoreFieldType.correct:
        // Gösterilecek simgeyi belirler
        return Icons.check_circle_outline;
      // score field type.wrong durumu için çalışır
      case ScoreFieldType.wrong:
        // Gösterilecek simgeyi belirler
        return Icons.highlight_off;
      // score field type.blank durumu için çalışır
      case ScoreFieldType.blank:
        // Gösterilecek simgeyi belirler
        return Icons.radio_button_unchecked;
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Görsel bir kutu oluşturur
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: isDark ? GardenPalette.nightCard : Colors.white,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(16),
        // Kenarlığı belirler
        border: Border.all(
          // Rengi belirler
          color: _accentColor.withAlpha(isDark ? 110 : 90),
          // Genişliği belirler
          width: 1.5,
        ),
        // Gölge ayarlarını belirler
        boxShadow: [
          // Kutuya gölge ayarı ekler
          BoxShadow(
            // Rengi belirler
            color: _accentColor.withAlpha(isDark ? 25 : 15),
            // Gölgenin konumunu belirler
            offset: const Offset(0, 2),
            // Gölgenin bulanıklığını belirler
            blurRadius: 6,
          ),
        ],
      ),
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
              // Simge gösterir
              Icon(_icon, size: 16, color: _accentColor),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 6),
              // Metni ekranda gösterir
              Text(
                // İlgili değeri veya görünüm ayarını belirler
                _label,
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 12,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.bold,
                  // Rengi belirler
                  color: _accentColor,
                ),
              ),
            ],
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 4),
          // Metin giriş alanı oluşturur
          TextField(
            // Veriyi yöneten controllerı bağlar
            controller: controller,
            // Klavye tipini belirler
            keyboardType: TextInputType.number,
            // Yazıyı hizalar
            textAlign: TextAlign.center,
            // Girilebilecek karakterleri sınırlar
            inputFormatters: [
              // İlgili değeri veya görünüm ayarını belirler
              FilteringTextInputFormatter.digitsOnly,
              // length limiting metin input formatter nesnesini oluşturur
              LengthLimitingTextInputFormatter(3),
            ],
            // Görünüm stilini belirler
            style: TextStyle(
              // Yazı boyutunu belirler
              fontSize: 22,
              // Yazı kalınlığını belirler
              fontWeight: FontWeight.w800,
              // Rengi belirler
              color: isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
            ),
            // Kutu ve kenarlık görünümünü belirler
            decoration: InputDecoration(
              // is dense bilgisini belirler
              isDense: true,
              // Kenarlığı belirler
              border: InputBorder.none,
              // content padding bilgisini belirler
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              // Giriş alanında ipucu gösterir
              hintText: '0',
              // hint style bilgisini belirler
              hintStyle: TextStyle(
                // Rengi belirler
                color: Colors.grey.shade400,
                // Yazı boyutunu belirler
                fontSize: 22,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.w800,
              ),
            ),
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
/// Doğa temasıyla uyumlu arama kutusu.
// nature search field için değişen verileri yöneten StatefulWidget kullanılır
class NatureSearchField extends StatefulWidget {
  // nature search field nesnesini oluşturur
  const NatureSearchField({
    // controller bilgisini zorunlu tutar
    required this.controller,
    // hint metin bilgisini isteğe bağlı alır
    this.hintText = 'Konu veya ders ara...',
    // on changed bilgisini isteğe bağlı alır
    this.onChanged,
    // on clear bilgisini isteğe bağlı alır
    this.onClear,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // controller bilgisini tutar
  final TextEditingController controller;
  // hint metin bilgisini tutar
  final String hintText;
  // Değerleri karşılaştırır
  final ValueChanged<String>? onChanged;
  // on clear bilgisini tutar
  final VoidCallback? onClear;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<NatureSearchField> createState() => _NatureSearchFieldState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _NatureSearchFieldState extends State<NatureSearchField> {
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // listener bilgisini ekler
    widget.controller.addListener(_onTextChanged);
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widgetın yeni bilgileri geldiğinde çalışır
  void didUpdateWidget(covariant NatureSearchField oldWidget) {
    // Üst sınıfın ilgili metodunu çalıştırır
    super.didUpdateWidget(oldWidget);
    // Belirtilen koşul doğruysa işlemi yapar
    if (oldWidget.controller != widget.controller) {
      // listener bilgisini kaldırır
      oldWidget.controller.removeListener(_onTextChanged);
      // listener bilgisini ekler
      widget.controller.addListener(_onTextChanged);
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // listener bilgisini kaldırır
    widget.controller.removeListener(_onTextChanged);
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // metin changed bilgisini işler
  void _onTextChanged() {
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) setState(() {});
  }
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
        color: isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(16),
        // Kenarlığı belirler
        border: Border.all(
          // Rengi belirler
          color: GardenPalette.mossEmerald.withAlpha(isDark ? 60 : 40),
          // Genişliği belirler
          width: 1.2,
        ),
      ),
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 14),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // İçerideki widgetları listeler
        children: [
          // Simge gösterir
          Icon(
            // Gösterilecek simgeyi belirler
            Icons.search,
            // Rengi belirler
            color: isDark ? const Color(0xFFA4D49B) : GardenPalette.mossEmerald,
            // Boyutu belirler
            size: 20,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(width: 10),
          // Kalan boşluğu kullanacak alan oluşturur
          Expanded(
            // İçine yerleştirilecek widgetı belirler
            child: TextField(
              // Veriyi yöneten controllerı bağlar
              controller: widget.controller,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 14,
                // Rengi belirler
                color: isDark ? const Color(0xFFF8F2E8) : GardenPalette.inkPlum,
              ),
              // Kutu ve kenarlık görünümünü belirler
              decoration: InputDecoration(
                // Giriş alanında ipucu gösterir
                hintText: widget.hintText,
                // hint style bilgisini belirler
                hintStyle: TextStyle(
                  // Rengi belirler
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                  // Yazı boyutunu belirler
                  fontSize: 14,
                ),
                // Kenarlığı belirler
                border: InputBorder.none,
                // is dense bilgisini belirler
                isDense: true,
                // content padding bilgisini belirler
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: widget.onChanged,
            ),
          ),
          // Liste veya metin doluysa bu koşul çalışır
          if (widget.controller.text.isNotEmpty)
            // Dokunma hareketlerini dinler
            GestureDetector(
              // Dokunulunca çalışacak fonksiyonu belirler
              onTap: () {
                // clear işlemini yapar
                widget.controller.clear();
                // İlgili değer null değilse kontrol eder
                if (widget.onClear != null) widget.onClear!();
                // İlgili değer null değilse kontrol eder
                if (widget.onChanged != null) widget.onChanged!('');
              },
              // İçine yerleştirilecek widgetı belirler
              child: Icon(
                // Gösterilecek simgeyi belirler
                Icons.cancel,
                // Boyutu belirler
                size: 18,
                // Rengi belirler
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }
}
/// Filtre ve ders seçimleri için organik chip.
// nature filter chip bölümünü oluşturan StatelessWidget sınıfı
class NatureFilterChip extends StatelessWidget {
  // nature filter chip nesnesini oluşturur
  const NatureFilterChip({
    // etiket bilgisini zorunlu tutar
    required this.label,
    // seçili olma durumu bilgisini zorunlu tutar
    required this.selected,
    // on seçilen bilgisini zorunlu tutar
    required this.onSelected,
    // simge bilgisini isteğe bağlı alır
    this.icon,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // etiket bilgisini tutar
  final String label;
  // seçili olma durumu bilgisini tutar
  final bool selected;
  // on seçilen bilgisini tutar
  final ValueChanged<bool> onSelected;
  // simge bilgisini tutar
  final IconData? icon;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Dokunma hareketlerini dinler
    return GestureDetector(
      // Dokunulunca çalışacak fonksiyonu belirler
      onTap: () => onSelected(!selected),
      // İçine yerleştirilecek widgetı belirler
      child: AnimatedContainer(
        // Animasyonun süresini belirler
        duration: const Duration(milliseconds: 180),
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Rengi belirler
          color: selected
              // Koşul doğruysa bu değeri kullanır
              ? (isDark ? GardenPalette.mossEmerald : GardenPalette.mossEmerald)
              // Koşul yanlışsa bu değeri kullanır
              : (isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper),
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(14),
          // Kenarlığı belirler
          border: Border.all(
            // Rengi belirler
            color: selected
                // Koşul doğruysa bu değeri kullanır
                ? GardenPalette.mossEmerald
                // Koşul yanlışsa bu değeri kullanır
                : GardenPalette.mossEmerald.withAlpha(40),
            // Genişliği belirler
            width: 1.2,
          ),
          // Gölge ayarlarını belirler
          boxShadow: selected
              // Koşul doğruysa bu değeri kullanır
              ? [
                  // Kutuya gölge ayarı ekler
                  BoxShadow(
                    // Rengi belirler
                    color: GardenPalette.mossEmerald.withAlpha(50),
                    // Gölgenin bulanıklığını belirler
                    blurRadius: 6,
                    // Gölgenin konumunu belirler
                    offset: const Offset(0, 2),
                  ),
                ]
              // Koşul yanlışsa bu değeri kullanır
              : null,
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Row(
          // Ana eksende kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçerideki widgetları listeler
          children: [
            // İlgili değer null değilse kontrol eder
            if (icon != null) ...[
              // Simge gösterir
              Icon(
                // İlgili değeri veya görünüm ayarını belirler
                icon,
                // Boyutu belirler
                size: 16,
                // Rengi belirler
                color: selected
                    // Koşul doğruysa bu değeri kullanır
                    ? Colors.white
                    // Koşul yanlışsa bu değeri kullanır
                    : (isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFA4D49B)
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.mossEmerald),
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 6),
            ],
            // Metni ekranda gösterir
            Text(
              // İlgili değeri veya görünüm ayarını belirler
              label,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 13,
                // Yazı kalınlığını belirler
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                // Rengi belirler
                color: selected
                    // Koşul doğruysa bu değeri kullanır
                    ? Colors.white
                    // Koşul yanlışsa bu değeri kullanır
                    : (isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFF8F2E8)
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.inkPlum),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app colors dosyasını projeye ekler
import 'app_colors.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// VenaPalette sınıfını tanımlar
class VenaPalette extends ThemeExtension<VenaPalette> {
  // Constructor, yeni nesnenin bilgilerini alır
  const VenaPalette({
    // amber bilgisini zorunlu tutar
    required this.amber,
    // coral bilgisini zorunlu tutar
    required this.coral,
    // başarı bilgisini zorunlu tutar
    required this.success,
    // ikincil renk metin bilgisini zorunlu tutar
    required this.secondaryText,
    // ana renk dark bilgisini zorunlu tutar
    required this.primaryDark,
    // hero start bilgisini zorunlu tutar
    required this.heroStart,
    // hero end bilgisini zorunlu tutar
    required this.heroEnd,
  });
  // amber bilgisini tutar
  final Color amber;
  // coral bilgisini tutar
  final Color coral;
  // başarı bilgisini tutar
  final Color success;
  // ikincil renk metin bilgisini tutar
  final Color secondaryText;
  // ana renk dark bilgisini tutar
  final Color primaryDark;
  // hero start bilgisini tutar
  final Color heroStart;
  // hero end bilgisini tutar
  final Color heroEnd;
  // light değerini tanımlar
  static const VenaPalette light = VenaPalette(
    // amber bilgisini belirler
    amber: AppColors.lightAmber,
    // coral bilgisini belirler
    coral: AppColors.lightCoral,
    // başarı bilgisini belirler
    success: AppColors.lightSuccess,
    // ikincil renk metin bilgisini belirler
    secondaryText: AppColors.lightSecondaryText,
    // ana renk dark bilgisini belirler
    primaryDark: AppColors.lightPrimaryDark,
    // hero start bilgisini belirler
    heroStart: AppColors.heroStartLight,
    // hero end bilgisini belirler
    heroEnd: AppColors.heroEndLight,
  );
  // dark değerini tanımlar
  static const VenaPalette dark = VenaPalette(
    // amber bilgisini belirler
    amber: AppColors.darkAmber,
    // coral bilgisini belirler
    coral: AppColors.darkCoral,
    // başarı bilgisini belirler
    success: AppColors.darkSuccess,
    // ikincil renk metin bilgisini belirler
    secondaryText: AppColors.darkSecondaryText,
    // ana renk dark bilgisini belirler
    primaryDark: AppColors.darkPrimaryDark,
    // hero start bilgisini belirler
    heroStart: AppColors.heroStartDark,
    // hero end bilgisini belirler
    heroEnd: AppColors.heroEndDark,
  );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
  VenaPalette copyWith({
    // Metodun veya constructorın parametresini tanımlar
    Color? amber,
    // Metodun veya constructorın parametresini tanımlar
    Color? coral,
    // Metodun veya constructorın parametresini tanımlar
    Color? success,
    // Metodun veya constructorın parametresini tanımlar
    Color? secondaryText,
    // Metodun veya constructorın parametresini tanımlar
    Color? primaryDark,
    // Metodun veya constructorın parametresini tanımlar
    Color? heroStart,
    // Metodun veya constructorın parametresini tanımlar
    Color? heroEnd,
  }) {
    // vena renk paleti değerini hesaplar veya döndürür
    return VenaPalette(
      // amber bilgisini belirler
      amber: amber ?? this.amber,
      // coral bilgisini belirler
      coral: coral ?? this.coral,
      // başarı bilgisini belirler
      success: success ?? this.success,
      // ikincil renk metin bilgisini belirler
      secondaryText: secondaryText ?? this.secondaryText,
      // ana renk dark bilgisini belirler
      primaryDark: primaryDark ?? this.primaryDark,
      // hero start bilgisini belirler
      heroStart: heroStart ?? this.heroStart,
      // hero end bilgisini belirler
      heroEnd: heroEnd ?? this.heroEnd,
    );
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // lerp değerini hesaplar veya döndürür
  VenaPalette lerp(ThemeExtension<VenaPalette>? other, double t) {
    // Koşul sağlanırsa ilgili işlemi yapar
    if (other is! VenaPalette) return this;
    // vena renk paleti değerini hesaplar veya döndürür
    return VenaPalette(
      // amber bilgisini belirler
      amber: Color.lerp(amber, other.amber, t)!,
      // coral bilgisini belirler
      coral: Color.lerp(coral, other.coral, t)!,
      // başarı bilgisini belirler
      success: Color.lerp(success, other.success, t)!,
      // ikincil renk metin bilgisini belirler
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      // ana renk dark bilgisini belirler
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      // hero start bilgisini belirler
      heroStart: Color.lerp(heroStart, other.heroStart, t)!,
      // hero end bilgisini belirler
      heroEnd: Color.lerp(heroEnd, other.heroEnd, t)!,
    );
  }
}
// VenaPaletteContext ile ilgili tipe yeni özellikler ekler
extension VenaPaletteContext on BuildContext {
  // renk paleti bilgisini döndürür
  VenaPalette get palette => Theme.of(this).extension<VenaPalette>()!;
}
// AppTheme sabitlerini tutar, nesne oluşturulamaz
abstract final class AppTheme {
  // light bilgisini döndürür
  static ThemeData get light => _build(
        // Tema parlaklığını belirler
        brightness: Brightness.light,
        // ana renk bilgisini belirler
        primary: AppColors.lightPrimary,
        // ana renk dark bilgisini belirler
        primaryDark: AppColors.lightPrimaryDark,
        // background bilgisini belirler
        background: AppColors.lightBackground,
        // yüzey rengi bilgisini belirler
        surface: AppColors.lightSurface,
        // ikincil renk metin bilgisini belirler
        secondaryText: AppColors.lightSecondaryText,
        // dış çizgi rengi bilgisini belirler
        outline: AppColors.lightOutline,
        // coral bilgisini belirler
        coral: AppColors.lightCoral,
        // amber bilgisini belirler
        amber: AppColors.lightAmber,
        // renk paleti bilgisini belirler
        palette: VenaPalette.light,
      );
  // dark bilgisini döndürür
  static ThemeData get dark => _build(
        // Tema parlaklığını belirler
        brightness: Brightness.dark,
        // ana renk bilgisini belirler
        primary: AppColors.darkPrimary,
        // ana renk dark bilgisini belirler
        primaryDark: AppColors.darkPrimaryDark,
        // background bilgisini belirler
        background: AppColors.darkBackground,
        // yüzey rengi bilgisini belirler
        surface: AppColors.darkSurface,
        // ikincil renk metin bilgisini belirler
        secondaryText: AppColors.darkSecondaryText,
        // dış çizgi rengi bilgisini belirler
        outline: AppColors.darkOutline,
        // coral bilgisini belirler
        coral: AppColors.darkCoral,
        // amber bilgisini belirler
        amber: AppColors.darkAmber,
        // renk paleti bilgisini belirler
        palette: VenaPalette.dark,
      );
  // build değerini hesaplar veya döndürür
  static ThemeData _build({
    // Bu parametrenin verilmesini zorunlu tutar
    required Brightness brightness,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color primary,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color primaryDark,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color background,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color surface,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color secondaryText,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color outline,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color coral,
    // Bu parametrenin verilmesini zorunlu tutar
    required Color amber,
    // Bu parametrenin verilmesini zorunlu tutar
    required VenaPalette palette,
  }) {
    // koyu tema kontrolü durumunu kontrol eder
    final bool isDark = brightness == Brightness.dark;
    // renk şeması değerini tanımlar
    final ColorScheme scheme = ColorScheme.fromSeed(
      // Renk şemasının temel rengini belirler
      seedColor: primary,
      // Tema parlaklığını belirler
      brightness: brightness,
    // İlgili alanın değerini veya görünümünü ayarlar
    ).copyWith(
      // ana renk bilgisini belirler
      primary: primary,
      // ana renk işlemi fonksiyonunu bağlar
      onPrimary: isDark ? AppColors.darkBackground : Colors.white,
      // ikincil renk bilgisini belirler
      secondary: primaryDark,
      // ikincil renk işlemi fonksiyonunu bağlar
      onSecondary: isDark ? AppColors.darkBackground : Colors.white,
      // tertiary bilgisini belirler
      tertiary: amber,
      // hata bilgisini belirler
      error: coral,
      // yüzey rengi bilgisini belirler
      surface: surface,
      // yüzey üstü yazı rengi fonksiyonunu bağlar
      onSurface: primaryDark,
      // yüzey rengi variant işlemi fonksiyonunu bağlar
      onSurfaceVariant: secondaryText,
      // dış çizgi rengi bilgisini belirler
      outline: outline,
      // dış çizgi rengi variant bilgisini belirler
      outlineVariant: outline,
      // yüzey rengi container lowest bilgisini belirler
      surfaceContainerLowest: surface,
      // yüzey rengi container low bilgisini belirler
      surfaceContainerLow: background,
    );
    // base metin değerini tanımlar
    final TextTheme baseText =
        // Koşulu kontrol eder
        (isDark ? Typography.material2021().white : Typography.material2021().black)
            // İlgili alanın değerini veya görünümünü ayarlar
            .apply(bodyColor: primaryDark, displayColor: primaryDark);
    // yazı stilleri değerini tanımlar
    final TextTheme textTheme = baseText.copyWith(
      // headline medium bilgisini belirler
      headlineMedium: baseText.headlineMedium
          // Mevcut nesnenin güncellenmiş kopyasını oluşturur
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      // headline small bilgisini belirler
      headlineSmall: baseText.headlineSmall
          // Mevcut nesnenin güncellenmiş kopyasını oluşturur
          ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      titleMedium: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      titleSmall: baseText.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      bodyMedium: baseText.bodyMedium?.copyWith(height: 1.4),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      bodySmall: baseText.bodySmall?.copyWith(color: secondaryText),
      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
      labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
    // rounded 16 değerini tanımlar
    final RoundedRectangleBorder rounded16 =
        // Constructor, nesne oluşturmak için bilgileri alır
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    // rounded 12 değerini tanımlar
    final RoundedRectangleBorder rounded12 =
        // Constructor, nesne oluşturmak için bilgileri alır
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    // tema data değerini hesaplar veya döndürür
    return ThemeData(
      // Material 3 tasarımını kullanır
      useMaterial3: true,
      // Tema parlaklığını belirler
      brightness: brightness,
      // Renk şemasını belirler
      colorScheme: scheme,
      // Yazı stillerini belirler
      textTheme: textTheme,
      // Sayfanın arka planını belirler
      scaffoldBackgroundColor: background,
      // extensions bilgisini belirler
      extensions: <ThemeExtension<dynamic>>[palette],
      // app bar tema bilgisini belirler
      appBarTheme: AppBarTheme(
        // Arka plan rengini belirler
        backgroundColor: background,
        // Yazı ve simge rengini belirler
        foregroundColor: primaryDark,
        // Yüzeyin renk etkisini belirler
        surfaceTintColor: Colors.transparent,
        // Gölge yüksekliğini belirler
        elevation: 0,
        // scrolled under gölge yüksekliği bilgisini belirler
        scrolledUnderElevation: 0,
        // center başlık bilgisini belirler
        centerTitle: false,
        // başlık metin style bilgisini belirler
        titleTextStyle: textTheme.titleLarge,
      ),
      // card tema bilgisini belirler
      cardTheme: CardThemeData(
        // Rengini belirler
        color: surface,
        // Gölge yüksekliğini belirler
        elevation: 0,
        // Dış boşlukları belirler
        margin: EdgeInsets.zero,
        // Yüzeyin renk etkisini belirler
        surfaceTintColor: Colors.transparent,
        // Widgetın şeklini belirler
        shape: RoundedRectangleBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(16),
          // side bilgisini belirler
          side: BorderSide(color: outline),
        ),
      ),
      // dialog tema bilgisini belirler
      dialogTheme: DialogThemeData(
        // Arka plan rengini belirler
        backgroundColor: surface,
        // Yüzeyin renk etkisini belirler
        surfaceTintColor: Colors.transparent,
        // Widgetın şeklini belirler
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      // filled button tema bilgisini belirler
      filledButtonTheme: FilledButtonThemeData(
        // style bilgisini belirler
        style: FilledButton.styleFrom(
          // minimum boyut bilgisini belirler
          minimumSize: const Size(48, 48),
          // İç boşlukları belirler
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          // Widgetın şeklini belirler
          shape: rounded12,
          // yazı stili bilgisini belirler
          textStyle: textTheme.labelLarge,
        ),
      ),
      // outlined button tema bilgisini belirler
      outlinedButtonTheme: OutlinedButtonThemeData(
        // style bilgisini belirler
        style: OutlinedButton.styleFrom(
          // minimum boyut bilgisini belirler
          minimumSize: const Size(48, 48),
          // İç boşlukları belirler
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          // Widgetın şeklini belirler
          shape: rounded12,
          // side bilgisini belirler
          side: BorderSide(color: outline),
          // yazı stili bilgisini belirler
          textStyle: textTheme.labelLarge,
        ),
      ),
      // metin button tema bilgisini belirler
      textButtonTheme: TextButtonThemeData(
        // style bilgisini belirler
        style: TextButton.styleFrom(
          // minimum boyut bilgisini belirler
          minimumSize: const Size(48, 48),
          // Widgetın şeklini belirler
          shape: rounded12,
          // yazı stili bilgisini belirler
          textStyle: textTheme.labelLarge,
        ),
      ),
      // floating action button tema bilgisini belirler
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        // Arka plan rengini belirler
        backgroundColor: primary,
        // Yazı ve simge rengini belirler
        foregroundColor: scheme.onPrimary,
        // Widgetın şeklini belirler
        shape: rounded16,
        // Gölge yüksekliğini belirler
        elevation: 2,
      ),
      // input görünüm ayarları tema bilgisini belirler
      inputDecorationTheme: InputDecorationTheme(
        // filled bilgisini belirler
        filled: true,
        // fill renk bilgisini belirler
        fillColor: surface,
        // içerik iç boşluk bilgisini belirler
        contentPadding:
            // Constructor, yeni nesnenin bilgilerini alır
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        // Kenarlık ayarlarını belirler
        border: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(12),
          // Kenarlık rengini ve kalınlığını ayarlar
          borderSide: BorderSide(color: outline),
        ),
        // normal kenarlık bilgisini belirler
        enabledBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(12),
          // Kenarlık rengini ve kalınlığını ayarlar
          borderSide: BorderSide(color: outline),
        ),
        // odaklanınca kenarlık bilgisini belirler
        focusedBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(12),
          // Kenarlık rengini ve kalınlığını ayarlar
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
        // hata kenarlık bilgisini belirler
        errorBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(12),
          // Kenarlık rengini ve kalınlığını ayarlar
          borderSide: BorderSide(color: coral),
        ),
        // focused hata kenarlık bilgisini belirler
        focusedErrorBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(12),
          // Kenarlık rengini ve kalınlığını ayarlar
          borderSide: BorderSide(color: coral, width: 1.6),
        ),
        // ipucu style bilgisini belirler
        hintStyle: TextStyle(color: secondaryText),
        // prefix simge renk bilgisini belirler
        prefixIconColor: secondaryText,
      ),
      // chip tema bilgisini belirler
      chipTheme: ChipThemeData(
        // Arka plan rengini belirler
        backgroundColor: surface,
        // seçili renk bilgisini belirler
        selectedColor: primary.withValues(alpha: isDark ? 0.24 : 0.12),
        // side bilgisini belirler
        side: BorderSide(color: outline),
        // Widgetın şeklini belirler
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // Mevcut nesnenin güncellenmiş kopyasını oluşturur
        labelStyle: textTheme.labelLarge?.copyWith(color: primaryDark),
        // checkmark renk bilgisini belirler
        checkmarkColor: primary,
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      // navigation bar tema bilgisini belirler
      navigationBarTheme: NavigationBarThemeData(
        // Arka plan rengini belirler
        backgroundColor: surface,
        // Yüzeyin renk etkisini belirler
        surfaceTintColor: Colors.transparent,
        // indicator renk bilgisini belirler
        indicatorColor: primary.withValues(alpha: isDark ? 0.24 : 0.14),
        // Gölge yüksekliğini belirler
        elevation: 0,
        // Yüksekliğini belirler
        height: 68,
        // etiket metin style bilgisini belirler
        labelTextStyle: WidgetStateProperty.resolveWith(
          // Bu eleman için dönüşüm veya karşılaştırma yapar
          (Set<WidgetState> states) => textTheme.labelMedium?.copyWith(
            // Yazı kalınlığını belirler
            fontWeight: states.contains(WidgetState.selected)
                // Koşul doğruysa bu değeri kullanır
                ? FontWeight.w700
                // Koşul yanlışsa bu değeri kullanır
                : FontWeight.w500,
            // Rengini belirler
            color: states.contains(WidgetState.selected)
                // Koşul doğruysa bu değeri kullanır
                ? primary
                // Koşul yanlışsa bu değeri kullanır
                : secondaryText,
          ),
        ),
        // simge tema bilgisini belirler
        iconTheme: WidgetStateProperty.resolveWith(
          // Bu eleman için dönüşüm veya karşılaştırma yapar
          (Set<WidgetState> states) => IconThemeData(
            // Rengini belirler
            color: states.contains(WidgetState.selected)
                // Koşul doğruysa bu değeri kullanır
                ? primary
                // Koşul yanlışsa bu değeri kullanır
                : secondaryText,
          ),
        ),
      ),
      // navigation rail tema bilgisini belirler
      navigationRailTheme: NavigationRailThemeData(
        // Arka plan rengini belirler
        backgroundColor: surface,
        // indicator renk bilgisini belirler
        indicatorColor: primary.withValues(alpha: isDark ? 0.24 : 0.14),
        // seçili simge tema bilgisini belirler
        selectedIconTheme: IconThemeData(color: primary),
        // unselected simge tema bilgisini belirler
        unselectedIconTheme: IconThemeData(color: secondaryText),
        // Mevcut nesnenin güncellenmiş kopyasını oluşturur
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(color: primary),
        // unselected etiket metin style bilgisini belirler
        unselectedLabelTextStyle:
            // Mevcut nesnenin güncellenmiş kopyasını oluşturur
            textTheme.labelLarge?.copyWith(color: secondaryText),
      ),
      // snack bar tema bilgisini belirler
      snackBarTheme: SnackBarThemeData(
        // Görünüm davranışını belirler
        behavior: SnackBarBehavior.floating,
        // Arka plan rengini belirler
        backgroundColor: isDark ? AppColors.darkPrimaryDark : primaryDark,
        // içerik metin style bilgisini belirler
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          // Rengini belirler
          color: isDark ? AppColors.darkBackground : Colors.white,
        ),
        // action metin renk bilgisini belirler
        actionTextColor: isDark ? AppColors.lightPrimary : AppColors.darkPrimary,
        // Widgetın şeklini belirler
        shape: rounded12,
      ),
      // divider tema bilgisini belirler
      dividerTheme: DividerThemeData(color: outline, space: 1, thickness: 1),
      // list tile tema bilgisini belirler
      listTileTheme: ListTileThemeData(
        // Widgetın şeklini belirler
        shape: rounded12,
        // simge renk bilgisini belirler
        iconColor: secondaryText,
      ),
      // segmented button tema bilgisini belirler
      segmentedButtonTheme: SegmentedButtonThemeData(
        // style bilgisini belirler
        style: SegmentedButton.styleFrom(
          // seçili background renk bilgisini belirler
          selectedBackgroundColor:
              // İlgili nesne üzerinden metodu çağırır
              primary.withValues(alpha: isDark ? 0.24 : 0.14),
          // seçili foreground renk bilgisini belirler
          selectedForegroundColor: primary,
          // side bilgisini belirler
          side: BorderSide(color: outline),
          // minimum boyut bilgisini belirler
          minimumSize: const Size(48, 48),
        ),
      ),
    );
  }
}

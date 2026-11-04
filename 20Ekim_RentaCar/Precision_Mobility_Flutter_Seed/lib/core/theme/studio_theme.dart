// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio renkler dosyasını ekler
import 'studio_colors.dart';
// studio tema sabitlerini tutan sınıf, nesne oluşturulamaz
abstract final class StudioTheme {
  // açık tema değerini tanımlar
  static ThemeData light({String? fontFamily}) => _build(false, fontFamily);
  // koyu tema değerini tanımlar
  static ThemeData dark({String? fontFamily}) => _build(true, fontFamily);
  // build değerini tanımlar
  static ThemeData _build(bool dark, String? fontFamily) {
    // ink değerini belirler
    final ink = dark ? StudioColors.pale : StudioColors.ink;
    // ana renk değerini belirler
    final primary = dark ? const Color(0xFFB2DABC) : StudioColors.forest;
    // yüzey değerini belirler
    final surface = dark ? StudioColors.nightSurface : Colors.white;
    // scheme değerini belirler
    final scheme = ColorScheme.fromSeed(
            // Renk şemasının başlangıç rengini belirler
            seedColor: StudioColors.forest,
            // Tema parlaklığını belirler
            brightness: dark ? Brightness.dark : Brightness.light)
        // Önceki ifade üzerinde ek işlem uygular
        .copyWith(
            // Ana rengi belirler
            primary: primary,
            // Ana renk üzerindeki yazı rengini belirler
            onPrimary: dark ? StudioColors.night : Colors.white,
            // ana renk container bilgisini belirler
            primaryContainer: dark ? StudioColors.forest : StudioColors.mint,
            // ana renk container için callback belirler
            onPrimaryContainer: dark ? StudioColors.pale : StudioColors.forest,
            // İkincil rengi belirler
            secondary: dark ? const Color(0xFFACDDE1) : StudioColors.teal,
            // ikincil renk için callback belirler
            onSecondary: dark ? StudioColors.night : Colors.white,
            // ikincil renk container bilgisini belirler
            secondaryContainer: dark ? StudioColors.night : StudioColors.ice,
            // ikincil renk container için callback belirler
            onSecondaryContainer: ink,
            // Yüzey rengini belirler
            surface: surface,
            // Yüzey üzerindeki yazı rengini belirler
            onSurface: ink,
            // yüzey container highest bilgisini belirler
            surfaceContainerHighest:
                // Önceki ifadeyi tamamlar
                dark ? StudioColors.night : StudioColors.canvas,
            // yüzey container low bilgisini belirler
            surfaceContainerLow: surface,
            // yüzey container bilgisini belirler
            surfaceContainer: surface,
            // yüzey variant için callback belirler
            onSurfaceVariant:
                // renk constructorını tanımlar
                dark ? const Color(0xFFB7C8BB) : StudioColors.muted,
            // Kenarlık rengini belirler
            outline: dark ? const Color(0xFF9BAC9E) : StudioColors.outline,
            // çerçeve variant bilgisini belirler
            outlineVariant:
                // renk constructorını tanımlar
                dark ? const Color(0xFF3B4C41) : const Color(0xFFDCE2DA),
            // renk constructorını tanımlar
            error: dark ? const Color(0xFFFFB4A4) : const Color(0xFFA13625));
    // base değerini belirler
    final base = ThemeData(
        // Material 3 tasarımını kullanır
        useMaterial3: true, colorScheme: scheme, fontFamily: fontFamily);
    // shape değerini belirler
    final shape =
        // rounded rectangle kenarlık nesnesi oluşturur
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    // button değerini belirler
    final button = ButtonStyle(
        // Minimum boyutu belirler
        minimumSize: const WidgetStatePropertyAll(Size(48, 50)),
        // İç boşlukları ayarlar
        padding: const WidgetStatePropertyAll(
            // Boşlukları belirler
            EdgeInsets.symmetric(horizontal: 22, vertical: 14)),
        // Elemanın şeklini belirler
        shape: WidgetStatePropertyAll(shape));
    // Güncellenmiş nesnenin kopyasını döndürür
    return base.copyWith(
      // scaffold arka plan renk bilgisini belirler
      scaffoldBackgroundColor: dark ? StudioColors.night : StudioColors.canvas,
      // Yazı stillerini ayarlar
      textTheme: base.textTheme.copyWith(
          // display small bilgisini belirler
          displaySmall: base.textTheme.displaySmall?.copyWith(
              // Yazı kalınlığını belirler
              fontWeight: FontWeight.w600, letterSpacing: -1.8, height: 1.08),
          // headline medium bilgisini belirler
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
              // Yazı kalınlığını belirler
              fontWeight: FontWeight.w700, letterSpacing: -1, height: 1.16),
          // başlık large bilgisini belirler
          titleLarge: base.textTheme.titleLarge
              // Değer null değilse ilgili işlemi yapar
              ?.copyWith(fontWeight: FontWeight.w600, letterSpacing: -.5),
          // gövde medium bilgisini belirler
          bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.55),
          // gövde large bilgisini belirler
          bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5)),
      // app bar tema bilgisini belirler
      appBarTheme: AppBarTheme(
          // Arka plan rengini belirler
          backgroundColor: surface,
          // Yazı ve simge rengini belirler
          foregroundColor: ink,
          // center başlık bilgisini belirler
          centerTitle: false,
          // Gölge yüksekliğini belirler
          elevation: 0,
          // scrolled under elevation bilgisini belirler
          scrolledUnderElevation: 0,
          // toolbar yükseklik bilgisini belirler
          toolbarHeight: 72),
      // kart tema bilgisini belirler
      cardTheme: CardThemeData(
          // Rengi belirler
          color: surface,
          // Gölge yüksekliğini belirler
          elevation: 0,
          // Dış boşlukları ayarlar
          margin: EdgeInsets.zero,
          // Elemanın şeklini belirler
          shape: RoundedRectangleBorder(
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(24),
              // Kenarlık çizgisini belirler
              side: BorderSide(color: scheme.outlineVariant))),
      // filled button tema bilgisini belirler
      filledButtonTheme: FilledButtonThemeData(style: button),
      // outlined button tema bilgisini belirler
      outlinedButtonTheme: OutlinedButtonThemeData(style: button),
      // metin button tema bilgisini belirler
      textButtonTheme: TextButtonThemeData(style: button),
      // input decoration tema bilgisini belirler
      inputDecorationTheme: InputDecorationTheme(
          // filled bilgisini belirler
          filled: true,
          // Dolgu rengini belirler
          fillColor: dark ? StudioColors.night : StudioColors.canvas,
          // content iç boşluk bilgisini belirler
          contentPadding:
              // Boşlukları belirler
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          // Kenarlık görünümünü oluşturur
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          // etkinlik kenarlık bilgisini belirler
          enabledBorder: OutlineInputBorder(
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(14),
              // Kenarlık rengini ve kalınlığını belirler
              borderSide: BorderSide(color: scheme.outline)),
          // focused kenarlık bilgisini belirler
          focusedBorder: OutlineInputBorder(
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(14),
              // Kenarlık rengini ve kalınlığını belirler
              borderSide: BorderSide(color: primary, width: 2))),
      // chip tema bilgisini belirler
      chipTheme: ChipThemeData(
          // Arka plan rengini belirler
          backgroundColor: surface,
          // Seçili öğenin rengini belirler
          selectedColor: scheme.primaryContainer,
          // etiket style bilgisini belirler
          labelStyle: base.textTheme.labelLarge?.copyWith(color: ink),
          // Kenarlık çizgisini belirler
          side: BorderSide(color: scheme.outlineVariant),
          // Elemanın şeklini belirler
          shape: const StadiumBorder(),
          // İç boşlukları ayarlar
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
      // navigation bar tema bilgisini belirler
      navigationBarTheme: NavigationBarThemeData(
          // Arka plan rengini belirler
          backgroundColor: surface,
          // Yüksekliği belirler
          height: 74,
          // Gölge yüksekliğini belirler
          elevation: 0,
          // indicator renk bilgisini belirler
          indicatorColor: scheme.primaryContainer),
      // divider renk bilgisini belirler
      dividerColor: scheme.outlineVariant,
    );
  }
}

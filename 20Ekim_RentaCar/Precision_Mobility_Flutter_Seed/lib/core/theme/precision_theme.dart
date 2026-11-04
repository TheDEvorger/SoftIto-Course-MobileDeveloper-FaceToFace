// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// palette dosyasını ekler
import 'palette.dart';
// precision tokens dosyasını ekler
import 'precision_tokens.dart';
/// Precision Mobility tema yapılandırıcı.
/// Açık ve koyu tema modları için Material 3 renk şemalarını, buton ve kart stillerini üretir.
// precision tema sabitlerini tutan sınıf, nesne oluşturulamaz
abstract final class PrecisionTheme {
  /// Açık tema (Light theme) tanımı
  // açık tema değerini tanımlar
  static ThemeData light() => _build(Brightness.light);
  /// Koyu tema (Dark theme) tanımı
  // koyu tema değerini tanımlar
  static ThemeData dark() => _build(Brightness.dark);
  /// Belirtilen parlaklık değerine göre eksiksiz ThemeData nesnesini oluşturur.
  // build değerini tanımlar
  static ThemeData _build(Brightness brightness) {
    // koyu tema değerini belirler
    final dark = brightness == Brightness.dark;
    // Arka plan, yüzey ve metin renkleri paletten çekilir
    // arka plan değerini belirler
    final background = dark ? Palette.carbonBlack : Palette.arcticWhite;
    // yüzey değerini belirler
    final surface = dark ? Palette.smokedGraphite : Colors.white;
    // ink değerini belirler
    final ink = dark ? Palette.arcticWhite : Palette.carbonBlack;
    // ana renk değerini belirler
    final primary = dark ? Palette.coldPlatinum : Palette.smokedGraphite;
    // Material 3 renk şeması yapılandırması
    // scheme değerini belirler
    final scheme = ColorScheme.fromSeed(
      // Renk şemasının başlangıç rengini belirler
      seedColor: Palette.precisionBlueGrey,
      // Tema parlaklığını belirler
      brightness: brightness,
    // İlgili widget veya fonksiyonun parametrelerini başlatır
    ).copyWith(
      // Ana rengi belirler
      primary: primary,
      // Ana renk üzerindeki yazı rengini belirler
      onPrimary: dark ? Palette.carbonBlack : Colors.white,
      // İkincil rengi belirler
      secondary: Palette.precisionBlueGrey,
      // ikincil renk için callback belirler
      onSecondary: Colors.black,
      // Yüzey rengini belirler
      surface: surface,
      // Yüzey üzerindeki yazı rengini belirler
      onSurface: ink,
      // yüzey variant için callback belirler
      onSurfaceVariant: dark ? Palette.coldPlatinum : Palette.deepNobleOlive,
      // Kenarlık rengini belirler
      outline: dark ? Palette.coldPlatinum : Palette.precisionBlueGrey,
      // renk constructorını tanımlar
      error: dark ? const Color(0xFFFFB4AB) : const Color(0xFF9C2727),
      // hata için callback belirler
      onError: dark ? Palette.carbonBlack : Colors.white,
    );
    // base değerini belirler
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    // Butonlar için ortak oval köşe formu
    // button shape değerini belirler
    final buttonShape = RoundedRectangleBorder(
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(PrecisionSpace.md),
    );
    // Tema ayarlarını oluşturur
    return ThemeData(
      // Material 3 tasarımını kullanır
      useMaterial3: true,
      // Tema parlaklığını belirler
      brightness: brightness,
      // Tema renk şemasını belirler
      colorScheme: scheme,
      // Yazı stillerini ayarlar
      textTheme: PrecisionTypography.apply(base.textTheme),
      // scaffold arka plan renk bilgisini belirler
      scaffoldBackgroundColor: background,
      // app bar tema bilgisini belirler
      appBarTheme:
          // app bar tema nesnesi oluşturur
          AppBarTheme(backgroundColor: background, foregroundColor: ink),
      // kart tema bilgisini belirler
      cardTheme: CardThemeData(
          // Rengi belirler
          color: surface,
          // Gölge yüksekliğini belirler
          elevation: 0,
          // Elemanın şeklini belirler
          shape: RoundedRectangleBorder(
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(16),
              // Kenarlık çizgisini belirler
              side: BorderSide(color: scheme.outline.withValues(alpha: 0.35)))),
      // input decoration tema bilgisini belirler
      inputDecorationTheme: InputDecorationTheme(
        // filled bilgisini belirler
        filled: true,
        // Dolgu rengini belirler
        fillColor: surface,
        // etiket style bilgisini belirler
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        // Kenarlık görünümünü oluşturur
        border: OutlineInputBorder(
            // Köşeleri yuvarlar
            borderRadius: BorderRadius.circular(PrecisionSpace.md)),
        // etkinlik kenarlık bilgisini belirler
        enabledBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(PrecisionSpace.md),
          // Kenarlık rengini ve kalınlığını belirler
          borderSide: BorderSide(color: scheme.outline),
        ),
        // focused kenarlık bilgisini belirler
        focusedBorder: OutlineInputBorder(
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(PrecisionSpace.md),
          // Kenarlık rengini ve kalınlığını belirler
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      // filled button tema bilgisini belirler
      filledButtonTheme: FilledButtonThemeData(
          // Görünüm stilini belirler
          style: FilledButton.styleFrom(
        // Arka plan rengini belirler
        backgroundColor: primary,
        // Yazı ve simge rengini belirler
        foregroundColor: scheme.onPrimary,
        // Minimum boyutu belirler
        minimumSize: const Size(
            // Önceki ifadeyi tamamlar
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        // Elemanın şeklini belirler
        shape: buttonShape,
      )),
      // outlined button tema bilgisini belirler
      outlinedButtonTheme: OutlinedButtonThemeData(
          // Görünüm stilini belirler
          style: OutlinedButton.styleFrom(
        // Yazı ve simge rengini belirler
        foregroundColor: primary,
        // Minimum boyutu belirler
        minimumSize: const Size(
            // Önceki ifadeyi tamamlar
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        // Kenarlık çizgisini belirler
        side: BorderSide(color: scheme.outline),
        // Elemanın şeklini belirler
        shape: buttonShape,
      )),
      // elevated button tema bilgisini belirler
      elevatedButtonTheme: ElevatedButtonThemeData(
          // Görünüm stilini belirler
          style: ElevatedButton.styleFrom(
        // Arka plan rengini belirler
        backgroundColor: primary,
        // Yazı ve simge rengini belirler
        foregroundColor: scheme.onPrimary,
        // Minimum boyutu belirler
        minimumSize: const Size(
            // Önceki ifadeyi tamamlar
            PrecisionSpace.controlHeight, PrecisionSpace.controlHeight),
        // Elemanın şeklini belirler
        shape: buttonShape,
      )),
      // navigation bar tema bilgisini belirler
      navigationBarTheme: NavigationBarThemeData(backgroundColor: surface),
      // divider renk bilgisini belirler
      dividerColor: scheme.outline.withValues(alpha: 0.35),
    );
  }
}

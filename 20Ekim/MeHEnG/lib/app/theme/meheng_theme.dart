// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulamanın renk sabitleri, nesne oluşturulamaz
abstract final class MehengColors {
  // Forest rengini tanımlar
  static const forest = Color(0xFF193E38);
  // Canvas rengini tanımlar
  static const canvas = Color(0xFFF5F2EB);
  // Copper rengini tanımlar
  static const copper = Color(0xFFD57C52);
  // Sage rengini tanımlar
  static const sage = Color(0xFF9EB8A9);
  // Ink rengini tanımlar
  static const ink = Color(0xFF263331);
  // Dark Mode Tokens
  // Dark canvas rengini tanımlar
  static const darkCanvas = Color(0xFF121B19);
  // Dark surface rengini tanımlar
  static const darkSurface = Color(0xFF1A2825);
  // Dark surface variant rengini tanımlar
  static const darkSurfaceVariant = Color(0xFF233632);
  // Dark ink rengini tanımlar
  static const darkInk = Color(0xFFE5EDE9);
  // Dark copper rengini tanımlar
  static const darkCopper = Color(0xFFE28B62);
  // Dark sage rengini tanımlar
  static const darkSage = Color(0xFFB0C9BC);
}
// Boşluk ölçülerinin sabitleri, nesne oluşturulamaz
abstract final class MehengSpacing {
  // Xxs sabitini tanımlar
  static const double xxs = 4.0;
  // Xs sabitini tanımlar
  static const double xs = 8.0;
  // Sm sabitini tanımlar
  static const double sm = 12.0;
  // Md sabitini tanımlar
  static const double md = 16.0;
  // Lg sabitini tanımlar
  static const double lg = 24.0;
  // Xl sabitini tanımlar
  static const double xl = 32.0;
  // Max content width sabitini tanımlar
  static const double maxContentWidth = 1120.0;
}
// Köşe yuvarlama ölçülerinin sabitleri, nesne oluşturulamaz
abstract final class MehengRadii {
  // Sm sabitini tanımlar
  static const double sm = 10.0;
  // Md sabitini tanımlar
  static const double md = 16.0;
  // Lg sabitini tanımlar
  static const double lg = 24.0;
}
// MeHEnG tema ayarlarını tutan sınıf, nesne oluşturulamaz
abstract final class MehengTheme {
  // Tema ayarlarını oluşturur
  static final light = ThemeData(
    // Material 3 tasarımını kullanır
    useMaterial3: true,
    // Temanın açık koyu durumunu belirler
    brightness: Brightness.light,
    // Color scheme özelliğini belirler
    colorScheme: const ColorScheme.light(
      // Ana tema rengini belirler
      primary: MehengColors.forest,
      // Ana renk üzerindeki yazı rengini belirler
      onPrimary: Colors.white,
      // İkincil tema rengini belirler
      secondary: MehengColors.copper,
      // İkincil renk üzerindeki yazı rengini belirler
      onSecondary: Colors.white,
      // Yüzey rengini belirler
      surface: MehengColors.canvas,
      // Yüzeydeki yazı rengini belirler
      onSurface: MehengColors.ink,
      // Yüksek yüzey rengini belirler
      surfaceContainerHighest: Color(0xFFE8E4DA),
    ),
    // Sayfanın arka plan rengini belirler
    scaffoldBackgroundColor: MehengColors.canvas,
    // Input decoration theme özelliğini belirler
    inputDecorationTheme: InputDecorationTheme(
      // Filled özelliğini belirler
      filled: true,
      // Fill color özelliğini belirler
      fillColor: Colors.white,
      // Kenarlığı belirler
      border: OutlineInputBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(MehengRadii.sm),
      ),
    ),
    // App bar theme özelliğini belirler
    appBarTheme: const AppBarTheme(
      // Arka plan rengini belirler
      backgroundColor: MehengColors.canvas,
      // Yazı ve simge rengini belirler
      foregroundColor: MehengColors.ink,
      // Center title özelliğini belirler
      centerTitle: false,
      // Gölge yüksekliğini belirler
      elevation: 0,
    ),
    // Card theme özelliğini belirler
    cardTheme: CardThemeData(
      // Gölge yüksekliğini belirler
      elevation: 0,
      // Rengi belirler
      color: Colors.white,
      // Köşelerin ve kenarlığın şeklini belirler
      shape: RoundedRectangleBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(MehengRadii.md),
        // Kenarlık görünümünü belirler
        side: const BorderSide(color: Color(0xFFE4DFD5)),
      ),
    ),
  );
  // Tema ayarlarını oluşturur
  static final dark = ThemeData(
    // Material 3 tasarımını kullanır
    useMaterial3: true,
    // Temanın açık koyu durumunu belirler
    brightness: Brightness.dark,
    // Color scheme özelliğini belirler
    colorScheme: const ColorScheme.dark(
      // Ana tema rengini belirler
      primary: MehengColors.sage,
      // Ana renk üzerindeki yazı rengini belirler
      onPrimary: MehengColors.darkCanvas,
      // İkincil tema rengini belirler
      secondary: MehengColors.darkCopper,
      // İkincil renk üzerindeki yazı rengini belirler
      onSecondary: MehengColors.darkCanvas,
      // Yüzey rengini belirler
      surface: MehengColors.darkSurface,
      // Yüzeydeki yazı rengini belirler
      onSurface: MehengColors.darkInk,
      // Yüksek yüzey rengini belirler
      surfaceContainerHighest: MehengColors.darkSurfaceVariant,
    ),
    // Sayfanın arka plan rengini belirler
    scaffoldBackgroundColor: MehengColors.darkCanvas,
    // Input decoration theme özelliğini belirler
    inputDecorationTheme: InputDecorationTheme(
      // Filled özelliğini belirler
      filled: true,
      // Fill color özelliğini belirler
      fillColor: MehengColors.darkSurface,
      // Kenarlığı belirler
      border: OutlineInputBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(MehengRadii.sm),
      ),
    ),
    // App bar theme özelliğini belirler
    appBarTheme: const AppBarTheme(
      // Arka plan rengini belirler
      backgroundColor: MehengColors.darkCanvas,
      // Yazı ve simge rengini belirler
      foregroundColor: MehengColors.darkInk,
      // Center title özelliğini belirler
      centerTitle: false,
      // Gölge yüksekliğini belirler
      elevation: 0,
    ),
    // Card theme özelliğini belirler
    cardTheme: CardThemeData(
      // Gölge yüksekliğini belirler
      elevation: 0,
      // Rengi belirler
      color: MehengColors.darkSurface,
      // Köşelerin ve kenarlığın şeklini belirler
      shape: RoundedRectangleBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(MehengRadii.md),
        // Kenarlık görünümünü belirler
        side: const BorderSide(color: MehengColors.darkSurfaceVariant),
      ),
    ),
  );
}

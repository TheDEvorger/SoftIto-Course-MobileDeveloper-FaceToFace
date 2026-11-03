// Flutter arayüz ve renk kütüphanesi
import 'package:flutter/material.dart';

// Uygulamanın renklerini tutan sınıf, nesne oluşturulamaz
abstract final class Palette {
  // Ana yazı rengi
  static const ink = Color(0xFF263C33);
  // Koyu yeşil tema rengi
  static const forest = Color(0xFF213B30);
  // Daha koyu yeşil renk
  static const forestDeep = Color(0xFF192D27);
  // Yosun yeşili renk
  static const moss = Color(0xFF53715D);
  // Açık yeşil renk
  static const sage = Color(0xFFE1E8D9);
  // Zeytin yeşili renk
  static const olive = Color(0xFFBFC992);
  // Kiremit rengi
  static const terracotta = Color(0xFFB85D43);
  // Açık mercan rengi
  static const coralLight = Color(0xFFF2DFD4);
  // Hardal sarısı renk
  static const mustard = Color(0xFFDAB779);
  // Sayfanın ana arka plan rengi
  static const parchment = Color(0xFFF6F2EA);
  // Açık kağıt rengi
  static const paper = Color(0xFFFFFDF8);
  // Kenarlıklarda kullanılan renk
  static const border = Color(0xFFDDD8CC);
  // Soluk yazı rengi
  static const muted = Color(0xFF6D796F);
  // Açık gri bej renk
  static const fog = Color(0xFFEDE9DE);
  // Beyaz renk
  static const white = Color(0xFFFFFFFF);
  // Eski canvas adını parchment rengine bağlar
  static const canvas = parchment;
  // Emerald adını moss rengine bağlar
  static const emerald = moss;
  // EmeraldDark adını forest rengine bağlar
  static const emeraldDark = forest;
  // TealSoft adını sage rengine bağlar
  static const tealSoft = sage;
  // Indigo adını terracotta rengine bağlar
  static const indigo = terracotta;
  // IndigoSoft adını coralLight rengine bağlar
  static const indigoSoft = coralLight;
  // Amber adını mustard rengine bağlar
  static const amber = mustard;
  // Açık sarı renk tanımlar
  static const amberSoft = Color(0xFFF8EED7);
}

// Uygulamanın genel temasını oluşturan fonksiyon
ThemeData buildAppTheme() {
  // Ana renklerden ColorScheme oluşturur
  final colors = ColorScheme.fromSeed(
    // Temel renk olarak forest kullanır
    seedColor: Palette.forest,
    // Açık tema kullanır
    brightness: Brightness.light,
    // Birincil rengi belirler
    primary: Palette.forest,
    // Birincil renk üzerindeki yazı rengini belirler
    onPrimary: Palette.paper,
    // Yüzey rengini belirler
    surface: Palette.paper,
    // Yüzey üzerindeki yazı rengini belirler
    onSurface: Palette.ink,
    // İkincil rengi belirler
    secondary: Palette.terracotta,
  );
  // Uygulamanın tema bilgilerini döndürür
  return ThemeData(
    // Material 3 tasarımını kullanır
    useMaterial3: true,
    // Oluşturulan renk şemasını kullanır
    colorScheme: colors,
    // Sayfanın arka plan rengini belirler
    scaffoldBackgroundColor: Palette.parchment,
    // Ayırıcı çizgilerin rengini belirler
    dividerColor: Palette.border,
    // Uygulamanın genel yazı stillerini belirler
    textTheme: const TextTheme(
      // Büyük başlıkların yazı ayarları
      headlineLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 39,
        height: 1.12,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
      // Orta boy başlıkların yazı ayarları
      headlineMedium: TextStyle(
        fontFamily: 'serif',
        fontSize: 32,
        height: 1.18,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
      // Büyük başlık stilini belirler
      titleLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Palette.ink,
      ),
      // Orta boy başlık stilini belirler
      titleMedium: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: Palette.ink,
      ),
      // Büyük gövde yazılarının stilini belirler
      bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: Palette.ink),
      // Normal yazıların stilini belirler
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Palette.ink),
    ),
    // Üst menünün genel tema ayarları
    appBarTheme: const AppBarTheme(
      // Üst menünün arka plan rengi
      backgroundColor: Palette.parchment,
      // Yazı ve simgelerin rengi
      foregroundColor: Palette.ink,
      // Yüzey renk etkisini kaldırır
      surfaceTintColor: Colors.transparent,
      // Üst menünün gölgesini kaldırır
      elevation: 0,
    ),
    // Alt gezinme menüsünün tema ayarları
    navigationBarTheme: NavigationBarThemeData(
      // Alt menünün arka plan rengi
      backgroundColor: Palette.paper,
      // Seçili sekmenin gösterge rengi
      indicatorColor: Palette.sage,
      // Alt menünün yüksekliği
      height: 74,
      // Sekmenin durumuna göre yazı stilini belirler
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          // Seçiliyse daha kalın yazı kullanır
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800
              : FontWeight.w500,
          // Yazı boyutunu belirler
          fontSize: 11,
          // Yazı rengini belirler
          color: Palette.forest,
        ),
      ),
    ),
    // Metin giriş alanlarının görünümünü ayarlar
    inputDecorationTheme: InputDecorationTheme(
      // Giriş alanının arka planını doldurur
      filled: true,
      // Giriş alanının arka plan rengi
      fillColor: Palette.paper,
      // Metin kutusunun iç boşluğunu belirler
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
      // İpucu yazısının rengini belirler
      hintStyle: const TextStyle(color: Color(0xFF9D9C91)),
      // Varsayılan kenarlığı oluşturur
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      // Seçili olmayan giriş alanının kenarlığı
      enabledBorder: OutlineInputBorder(
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(13),
        // Kenarlık rengini belirler
        borderSide: const BorderSide(color: Palette.border),
      ),
      // Giriş alanına odaklanınca kullanılacak kenarlık
      focusedBorder: OutlineInputBorder(
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(13),
        // Kenarlık rengini ve kalınlığını değiştirir
        borderSide: const BorderSide(color: Palette.moss, width: 2),
      ),
    ),
    // FilledButton butonlarının genel tema ayarları
    filledButtonTheme: FilledButtonThemeData(
      // Butonun stilini oluşturur
      style: FilledButton.styleFrom(
        // Butonun arka plan rengi
        backgroundColor: Palette.terracotta,
        // Buton yazısının ve simgesinin rengi
        foregroundColor: Palette.white,
        // Butonun minimum boyutlarını belirler
        minimumSize: const Size(0, 48),
        // Butonun köşelerini yuvarlar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Buton yazısını kalın yapar
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    // ElevatedButton butonlarının genel tema ayarları
    elevatedButtonTheme: ElevatedButtonThemeData(
      // Butonun stilini oluşturur
      style: ElevatedButton.styleFrom(
        // Butonun arka plan rengi
        backgroundColor: Palette.terracotta,
        // Yazı ve simge rengini belirler
        foregroundColor: Palette.white,
        // Butonun gölgesini kaldırır
        elevation: 0,
        // Butonun minimum boyutlarını belirler
        minimumSize: const Size(0, 48),
        // Butonun köşelerini yuvarlar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // Buton yazısını kalın yapar
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    // SnackBar mesajlarının tema ayarları
    snackBarTheme: SnackBarThemeData(
      // Mesajı yüzen kutu şeklinde gösterir
      behavior: SnackBarBehavior.floating,
      // Mesajın arka plan rengi
      backgroundColor: Palette.forestDeep,
      // Mesaj yazısının rengini belirler
      contentTextStyle: const TextStyle(color: Palette.paper),
      // Mesaj kutusunun köşelerini yuvarlar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    // Açılır pencerelerin genel tema ayarları
    dialogTheme: DialogThemeData(
      // Pencerenin arka plan rengi
      backgroundColor: Palette.paper,
      // Pencerenin köşelerini yuvarlar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    ),
  );
}

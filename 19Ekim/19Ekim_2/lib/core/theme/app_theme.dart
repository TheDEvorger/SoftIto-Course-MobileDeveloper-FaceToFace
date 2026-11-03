// Flutter tema kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulamanın renk sabitlerini ekler
import '../constants/app_colors.dart';

// Uygulamanın açık ve koyu temalarını tutar, nesne oluşturulamaz
abstract final class AppTheme {
  // Koyu tema ayarlarını döndürür
  static ThemeData get dark {
    // Koyu tema için renk şeması oluşturur
    const colorScheme = ColorScheme.dark(
      // Ana vurgu rengini belirler
      primary: AppColors.accent,
      // Ana renk üzerindeki yazı rengini belirler
      onPrimary: AppColors.background,
      // İkincil rengi belirler
      secondary: AppColors.success,
      // Yüzey rengini belirler
      surface: AppColors.surface,
      // Yüzey üzerindeki yazı rengini belirler
      onSurface: AppColors.textPrimary,
      // Kenarlık rengini belirler
      outline: AppColors.divider,
    );
    // Koyu temanın bütün ayarlarını döndürür
    return ThemeData(
      // Material 3 tasarımını kullanır
      useMaterial3: true,
      // Tema parlaklığını koyu yapar
      brightness: Brightness.dark,
      // Oluşturulan renk şemasını kullanır
      colorScheme: colorScheme,
      // Sayfanın arka plan rengini belirler
      scaffoldBackgroundColor: AppColors.background,
      // Uygulamanın yazı tipini belirler
      fontFamily: 'SF Pro Display',
      // Özel koyu tema renklerini ekler
      extensions: const [AppThemeColors.dark],
      // Ayırıcı çizgilerin görünümünü ayarlar
      dividerTheme: const DividerThemeData(
        // Çizgi rengini belirler
        color: AppColors.divider,
        // Çizgi kalınlığını belirler
        thickness: 1,
      ),
      // Yazıların genel stillerini belirler
      textTheme: const TextTheme(
        // Orta boy büyük başlık stilini oluşturur
        headlineMedium: TextStyle(
          // Başlık rengini belirler
          color: AppColors.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 28,
          // Yazıyı kalın yapar
          fontWeight: FontWeight.w700,
          // Harfler arasındaki boşluğu azaltır
          letterSpacing: -0.7,
        ),
        // Büyük başlık stilini oluşturur
        titleLarge: TextStyle(
          // Başlık rengini belirler
          color: AppColors.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 18,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w600,
        ),
        // Orta başlık stilini oluşturur
        titleMedium: TextStyle(
          // Başlık rengini belirler
          color: AppColors.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 16,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w600,
        ),
        // Normal metin stilini oluşturur
        bodyMedium: TextStyle(
          // Metin rengini belirler
          color: AppColors.textSecondary,
          // Yazı boyutunu belirler
          fontSize: 14,
        ),
        // Küçük etiket yazılarının stilini oluşturur
        labelSmall: TextStyle(
          // Etiket rengini belirler
          color: AppColors.textSecondary,
          // Yazı boyutunu belirler
          fontSize: 11,
          // Yazıyı kalın yapar
          fontWeight: FontWeight.w700,
          // Harfler arasındaki boşluğu artırır
          letterSpacing: 1.1,
        ),
      ),
      // Kartların genel görünümünü ayarlar
      cardTheme: const CardThemeData(
        // Kartın arka plan rengini belirler
        color: AppColors.surface,
        // Kartın dış boşluğunu sıfırlar
        margin: EdgeInsets.zero,
        // Kartın gölgesini kaldırır
        elevation: 0,
        // Kartın şeklini oluşturur
        shape: RoundedRectangleBorder(
          // Köşeleri 24 birim yuvarlar
          borderRadius: BorderRadius.all(Radius.circular(24)),
          // Kartın kenarlık rengini belirler
          side: BorderSide(color: AppColors.divider),
        ),
      ),
      // FilledButton butonlarının temasını oluşturur
      filledButtonTheme: FilledButtonThemeData(
        // Butonun stilini ayarlar
        style: FilledButton.styleFrom(
          // Butonun arka plan rengini belirler
          backgroundColor: AppColors.accent,
          // Butondaki yazı ve simge rengini belirler
          foregroundColor: AppColors.background,
          // Buton yazısını kalın yapar
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          // Butonun şeklini oluşturur
          shape: RoundedRectangleBorder(
            // Buton köşelerini yuvarlar
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  // Açık tema ayarlarını döndürür
  static ThemeData get light {
    // Açık tema için renk şeması oluşturur
    const colorScheme = ColorScheme.light(
      // Ana vurgu rengini belirler
      primary: AppColorsLight.accent,
      // Ana renk üzerindeki yazı rengini beyaz yapar
      onPrimary: Colors.white,
      // İkincil rengi belirler
      secondary: AppColorsLight.success,
      // Yüzey rengini belirler
      surface: AppColorsLight.surface,
      // Yüzey üzerindeki yazı rengini belirler
      onSurface: AppColorsLight.textPrimary,
      // Kenarlık rengini belirler
      outline: AppColorsLight.divider,
    );
    // Açık temanın bütün ayarlarını döndürür
    return ThemeData(
      // Material 3 tasarımını kullanır
      useMaterial3: true,
      // Tema parlaklığını açık yapar
      brightness: Brightness.light,
      // Oluşturulan renk şemasını kullanır
      colorScheme: colorScheme,
      // Sayfanın arka plan rengini belirler
      scaffoldBackgroundColor: AppColorsLight.background,
      // Uygulamanın yazı tipini belirler
      fontFamily: 'SF Pro Display',
      // Özel açık tema renklerini ekler
      extensions: const [AppThemeColors.light],
      // Ayırıcı çizgilerin görünümünü ayarlar
      dividerTheme: const DividerThemeData(
        // Çizgi rengini belirler
        color: AppColorsLight.divider,
        // Çizgi kalınlığını belirler
        thickness: 1,
      ),
      // Açık temanın yazı stillerini belirler
      textTheme: const TextTheme(
        // Orta boy büyük başlık stilini oluşturur
        headlineMedium: TextStyle(
          // Başlık rengini belirler
          color: AppColorsLight.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 28,
          // Yazıyı kalın yapar
          fontWeight: FontWeight.w700,
          // Harfler arasındaki boşluğu azaltır
          letterSpacing: -0.7,
        ),
        // Büyük başlık stilini oluşturur
        titleLarge: TextStyle(
          // Başlık rengini belirler
          color: AppColorsLight.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 18,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w600,
        ),
        // Orta başlık stilini oluşturur
        titleMedium: TextStyle(
          // Başlık rengini belirler
          color: AppColorsLight.textPrimary,
          // Yazı boyutunu belirler
          fontSize: 16,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w600,
        ),
        // Normal metin stilini oluşturur
        bodyMedium: TextStyle(
          // Metin rengini belirler
          color: AppColorsLight.textSecondary,
          // Yazı boyutunu belirler
          fontSize: 14,
        ),
        // Küçük etiket yazılarının stilini oluşturur
        labelSmall: TextStyle(
          // Etiket rengini belirler
          color: AppColorsLight.textSecondary,
          // Yazı boyutunu belirler
          fontSize: 11,
          // Yazıyı kalın yapar
          fontWeight: FontWeight.w700,
          // Harfler arasındaki boşluğu artırır
          letterSpacing: 1.1,
        ),
      ),
      // Açık temadaki kart görünümünü ayarlar
      cardTheme: const CardThemeData(
        // Kartın arka plan rengini belirler
        color: AppColorsLight.surface,
        // Kartın dış boşluğunu sıfırlar
        margin: EdgeInsets.zero,
        // Kartın gölgesini kaldırır
        elevation: 0,
        // Kartın şeklini oluşturur
        shape: RoundedRectangleBorder(
          // Kartın köşelerini yuvarlar
          borderRadius: BorderRadius.all(Radius.circular(24)),
          // Kartın kenarlık rengini belirler
          side: BorderSide(color: AppColorsLight.divider),
        ),
      ),
      // Açık temadaki FilledButton ayarlarını oluşturur
      filledButtonTheme: FilledButtonThemeData(
        // Butonun stilini ayarlar
        style: FilledButton.styleFrom(
          // Butonun arka plan rengini belirler
          backgroundColor: AppColorsLight.accent,
          // Butondaki yazı ve simge rengini beyaz yapar
          foregroundColor: Colors.white,
          // Buton yazısını kalın yapar
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          // Butonun şeklini oluşturur
          shape: RoundedRectangleBorder(
            // Butonun köşelerini yuvarlar
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

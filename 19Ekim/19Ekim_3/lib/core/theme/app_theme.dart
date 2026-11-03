// Flutter tema kütüphanesini ekler
import 'package:flutter/material.dart';

// Uygulamanın renk sabitlerini ekler
import '../constants/app_colors.dart';

// Tema ayarlarını tutan sınıf, nesne oluşturulamaz
abstract final class AppTheme {
  // Koyu temayı bir kere oluşturup tutar
  static final ThemeData dark = _build(
    // Temel renkten koyu renk şeması oluşturur
    ColorScheme.fromSeed(
      // Ana renk olarak neon maviyi kullanır
      seedColor: AppColors.neonCyan,
      // Koyu tema olduğunu belirtir
      brightness: Brightness.dark,
      // Oluşturulan renk şemasındaki değerleri değiştirir
    ).copyWith(
      // Birincil rengi belirler
      primary: AppColors.neonCyan,
      // İkincil rengi belirler
      secondary: AppColors.neonLime,
      // Kart ve yüzey rengini belirler
      surface: AppColors.obsidianSurface,
      // Yüzey üzerindeki yazı rengini belirler
      onSurface: AppColors.darkOnSurface,
      // Hata rengini belirler
      error: AppColors.error,
    ),
    // Ana sayfa arka plan rengini gönderir
    AppColors.obsidian,
  );
  // Açık temayı bir kere oluşturup tutar
  static final ThemeData light = _build(
    // Temel renkten açık renk şeması oluşturur
    ColorScheme.fromSeed(
      // Ana renk olarak koyu mavi kullanır
      seedColor: AppColors.deepWater,
      // Açık tema olduğunu belirtir
      brightness: Brightness.light,
      // Oluşturulan renk şemasındaki değerleri değiştirir
    ).copyWith(
      // Birincil rengi belirler
      primary: AppColors.deepWater,
      // İkincil rengi belirler
      secondary: AppColors.freshLime,
      // Kart ve yüzey rengini belirler
      surface: AppColors.frostSurface,
      // Yüzey üzerindeki yazı rengini belirler
      onSurface: AppColors.lightOnSurface,
      // Hata rengini belirler
      error: AppColors.error,
    ),
    // Ana sayfa arka plan rengini gönderir
    AppColors.frost,
  );
  // Gelen renk şemasıyla ThemeData oluşturur
  static ThemeData _build(ColorScheme scheme, Color background) {
    // Uygulamanın tema ayarlarını döndürür
    return ThemeData(
      // Material 3 tasarımını kullanır
      useMaterial3: true,
      // Gelen renk şemasını kullanır
      colorScheme: scheme,
      // Sayfanın arka plan rengini belirler
      scaffoldBackgroundColor: background,
      // Üst menünün görünümünü ayarlar
      appBarTheme: AppBarTheme(
        // Üst menünün arka planını belirler
        backgroundColor: background,
        // Yazı ve simge rengini belirler
        foregroundColor: scheme.onSurface,
        // Başlığı ortalar
        centerTitle: true,
      ),
      // Kartların genel görünümünü ayarlar
      cardTheme: CardThemeData(
        // Kart rengini renk şemasından alır
        color: scheme.surface,
        // Kartın gölgesini kaldırır
        elevation: 0,
        // Kartın köşelerini yuvarlar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// Flutter tema kütüphanesini ekler
import 'package:flutter/material.dart';
// Özel tema renklerini ekler
import '../constants/app_colors.dart';

// BuildContext tipine yeni getterlar ekler
extension ThemeContextExtensions on BuildContext {
  // Aktif temanın özel renklerini getirir
  AppThemeColors get colors =>
      // Önce temada kayıtlı AppThemeColors değerini arar
      Theme.of(this).extension<AppThemeColors>() ??
      // Kayıtlı renk yoksa temanın açıklığını kontrol eder
      (Theme.of(this).brightness == Brightness.dark
          // Koyu tema varsa koyu renkleri döndürür
          ? AppThemeColors.dark
          // Değilse açık renkleri döndürür
          : AppThemeColors.light);
  // Aktif tema koyuysa true döndürür
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  // Aktif temanın yazı stillerini getirir
  TextTheme get textTheme => Theme.of(this).textTheme;
  // Aktif temanın renk şemasını getirir
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

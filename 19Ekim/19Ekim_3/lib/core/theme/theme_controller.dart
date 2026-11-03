// Flutter tema ve ValueNotifier yapılarını ekler
import 'package:flutter/material.dart';

// Uygulamanın temasını yöneten sınıf
class ThemeController {
  // Dışarıdan nesne oluşturulmasını engelleyen private constructor
  ThemeController._();
  // Tek bir ThemeController nesnesi oluşturur
  static final ThemeController instance = ThemeController._();
  // Tema modunu tutar ve değişiklikleri bildirir
  final ValueNotifier<ThemeMode> themeMode =
      // Başlangıçta cihazın temasını kullanır
      ValueNotifier<ThemeMode>(ThemeMode.system);
  // Açık ve koyu tema arasında geçiş yapar
  void toggle({required bool isDark}) {
    // Mevcut temaya göre diğer temayı seçer
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
  }

  // Verilen tema modunu aktif tema yapar
  void setMode(ThemeMode mode) => themeMode.value = mode;
}

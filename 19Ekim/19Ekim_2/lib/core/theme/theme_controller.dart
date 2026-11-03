// Flutter tema ve ValueNotifier yapılarını ekler
import 'package:flutter/material.dart';

// Uygulamanın tema değişimlerini yöneten sınıf
class ThemeController {
  // Başlangıç temasını alır, verilmezse koyu tema kullanır
  ThemeController({ThemeMode initialMode = ThemeMode.dark})
      // Başlangıç değerini ValueNotifier içine atar
      : themeMode = ValueNotifier<ThemeMode>(initialMode);
  // Tema modunu tutar ve değişiklikleri dinleyenlere bildirir
  final ValueNotifier<ThemeMode> themeMode;
  // Aktif tema koyuysa true döndürür
  bool get isDark => themeMode.value == ThemeMode.dark;
  // Açık ve koyu tema arasında geçiş yapar
  void toggleTheme() {
    // Tema değerini değiştirerek dinleyenleri günceller
    themeMode.value =
        // Koyuysa açığa, değilse koyuya geçirir
        themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }

  // Gelen tema modunu aktif tema olarak ayarlar
  void setThemeMode(ThemeMode mode) {
    // Yeni tema mevcut temadan farklıysa çalışır
    if (themeMode.value != mode) {
      // Yeni temayı atar ve dinleyenlere bildirir
      themeMode.value = mode;
    }
  }

  // Controllerın kullandığı kaynakları temizler
  void dispose() {
    // ValueNotifierı temizler
    themeMode.dispose();
  }
}

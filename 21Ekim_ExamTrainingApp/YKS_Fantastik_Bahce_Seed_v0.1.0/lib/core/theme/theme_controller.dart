// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// student preferences dosyasını kullanıma ekler
import '../../domain/models/student_preferences.dart';
// app tema controller bilgilerini veya işlemlerini tutan sınıf
class AppThemeController {
  // app tema controller.  nesnesini oluşturur
  AppThemeController._();
  // instance bilgisini hesaplayıp saklar
  static final AppThemeController instance = AppThemeController._();
  // tema modu dinleyicisi değerini tanımlar
  final ValueNotifier<ThemeMode> themeModeNotifier =
      // value notifier nesnesini oluşturur
      ValueNotifier<ThemeMode>(ThemeMode.system);
  // from preference bilgisini günceller
  void updateFromPreference(ThemeModePreference pref) {
    // Değere göre uygun durumu seçer
    switch (pref) {
      // tema mode preference.system durumu için çalışır
      case ThemeModePreference.system:
        // tema mode notifier.value değerini günceller
        themeModeNotifier.value = ThemeMode.system;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // tema mode preference.light durumu için çalışır
      case ThemeModePreference.light:
        // tema mode notifier.value değerini günceller
        themeModeNotifier.value = ThemeMode.light;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // tema mode preference.dark durumu için çalışır
      case ThemeModePreference.dark:
        // tema mode notifier.value değerini günceller
        themeModeNotifier.value = ThemeMode.dark;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
    }
  }
}

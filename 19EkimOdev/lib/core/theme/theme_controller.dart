// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// ThemeController işlemlerini yöneten sınıf
class ThemeController {
  // Constructor, nesne oluşturmak için bilgileri alır
  ThemeController({ThemeMode initialMode = ThemeMode.system})
      // ValueNotifier nesnesini oluşturur veya kullanır
      : mode = ValueNotifier<ThemeMode>(initialMode);
  // mod bilgisini tutar
  final ValueNotifier<ThemeMode> mode;
  // Yeni tema modunu ayarlar
  void setMode(ThemeMode newMode) => mode.value = newMode;
  // İlgili controller veya notifierı temizler
  void dispose() => mode.dispose();
}
// ThemeModeLabel ile ilgili tipe yeni özellikler ekler
extension ThemeModeLabel on ThemeMode {
  // etiket bilgisini döndürür
  String get label => switch (this) {
        // tema mod bilgisini günceller
        ThemeMode.system => 'Sistem',
        // tema mod bilgisini günceller
        ThemeMode.light => 'Aydınlık',
        // tema mod bilgisini günceller
        ThemeMode.dark => 'Karanlık',
      };
  // simge bilgisini döndürür
  IconData get icon => switch (this) {
        // tema mod bilgisini günceller
        ThemeMode.system => Icons.brightness_auto_outlined,
        // tema mod bilgisini günceller
        ThemeMode.light => Icons.light_mode_outlined,
        // tema mod bilgisini günceller
        ThemeMode.dark => Icons.dark_mode_outlined,
      };
}

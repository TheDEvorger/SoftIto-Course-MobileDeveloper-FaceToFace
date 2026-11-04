// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden tema dosyasını kullanıma ekler
import 'core/theme/garden_theme.dart';
// tema controller dosyasını kullanıma ekler
import 'core/theme/theme_controller.dart';
// app shell dosyasını kullanıma ekler
import 'features/shell/presentation/app_shell.dart';
// garden yks app bölümünü oluşturan StatelessWidget sınıfı
class GardenYksApp extends StatelessWidget {
  // garden yks app nesnesini oluşturur
  const GardenYksApp({super.key});
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Dinlenen değer değişince ilgili arayüzü günceller
    return ValueListenableBuilder<ThemeMode>(
      // Değişiklikleri izlenecek değeri belirler
      valueListenable: AppThemeController.instance.themeModeNotifier,
      // Gelen verilerle arayüzü oluşturur
      builder: (context, currentThemeMode, _) {
        // Uygulamanın Material yapısını oluşturur
        return MaterialApp(
          // Sağ üstteki debug etiketini gizler
          debugShowCheckedModeBanner: false,
          // Başlığı belirler
          title: 'Fantastik Bahçe YKS',
          // Açık tema ayarlarını belirler
          theme: GardenTheme.light,
          // Koyu tema ayarlarını belirler
          darkTheme: GardenTheme.dark,
          // Kullanılacak tema modunu belirler
          themeMode: currentThemeMode,
          // Uygulamanın ilk ekranını belirler
          home: const AppShell(),
        );
      },
    );
  }
}

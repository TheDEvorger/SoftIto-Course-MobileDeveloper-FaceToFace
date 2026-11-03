// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';

// Açık ve koyu tema ayarlarını ekler
import 'core/theme/app_theme.dart';
// Tema değişimlerini yöneten sınıfı ekler
import 'core/theme/theme_controller.dart';
// Su takip ekranını ekler
import 'features/water_tracker/view/water_tracker_view.dart';

// Uygulamayı başlatır
void main() => runApp(const SusadimApp());

// Uygulamanın ana widget sınıfı
class SusadimApp extends StatelessWidget {
  // Sınıfın constructorı
  const SusadimApp({super.key});
  // Üstteki build metodunu yeniden yazar
  @override
  // Uygulamanın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Tema değişimlerini dinleyerek arayüzü günceller
    return ValueListenableBuilder<ThemeMode>(
      // Tekil controllerdaki tema değerini dinler
      valueListenable: ThemeController.instance.themeMode,
      // Tema değişince MaterialApp yapısını yeniden oluşturur
      builder: (context, mode, _) => MaterialApp(
        // Uygulamanın başlığını belirler
        title: 'Susadım',
        // Debug yazısını kaldırır
        debugShowCheckedModeBanner: false,
        // Açık temayı belirler
        theme: AppTheme.light,
        // Koyu temayı belirler
        darkTheme: AppTheme.dark,
        // Aktif temayı dinlenen değerden alır
        themeMode: mode,
        // İlk ekran olarak su takip sayfasını açar
        home: const WaterTrackerView(),
      ),
    );
  }
}

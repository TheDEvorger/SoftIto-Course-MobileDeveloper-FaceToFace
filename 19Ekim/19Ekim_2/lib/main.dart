// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulamanın tema ayarlarını ekler
import 'core/theme/app_theme.dart';
// Tema değişimlerini yöneten sınıfı ekler
import 'core/theme/theme_controller.dart';
// Su takip ekranını projeye ekler
import 'features/water_tracker/view/water_tracker_view.dart';

// Uygulamanın ana fonksiyonu
void main() {
  // Uygulamayı başlatır
  runApp(const SusadimApp());
}

// Tema değişebileceği için StatefulWidget kullanılır
class SusadimApp extends StatefulWidget {
  // Constructor ile isteğe bağlı controller alır
  const SusadimApp({
    // Key bilgisini üst sınıfa gönderir
    super.key,
    // Tema controllerı dışarıdan verilebilir
    this.themeController,
  });
  // Controller bilgisini tutar, null olabilir
  final ThemeController? themeController;
  // Üstteki createState metodunu uygular
  @override
  // State sınıfını oluşturur
  State<SusadimApp> createState() => _SusadimAppState();
}

// Uygulamanın tema durumunu yöneten State sınıfı
class _SusadimAppState extends State<SusadimApp> {
  // Tema controllerını tutar, late ile sonradan atanır
  late final ThemeController _themeController;
  // Controllerın içeride oluşturulup oluşturulmadığını tutar
  late final bool _isInternalController;
  // Üstteki initState metodunu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda bir kere çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // Dışarıdan controller verilmişse onu kullanır
    if (widget.themeController != null) {
      // ! ile null olmadığını belirtip controllerı alır
      _themeController = widget.themeController!;
      // Controller dışarıdan geldiği için false olur
      _isInternalController = false;
      // Controller verilmemişse burası çalışır
    } else {
      // Yeni tema controllerı oluşturur
      _themeController = ThemeController();
      // Controller içeride oluşturulduğu için true olur
      _isInternalController = true;
    }
  }

  // Üstteki dispose metodunu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // Controller içeride oluşturulmuşsa temizler
    if (_isInternalController) {
      // Tema controllerının dispose metodunu çağırır
      _themeController.dispose();
    }
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Uygulamanın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Tema değişimlerini dinleyerek arayüzü günceller
    return ValueListenableBuilder<ThemeMode>(
      // ThemeMode değerini dinler
      valueListenable: _themeController.themeMode,
      // Tema değişince yeni mode değeriyle çalışır
      builder: (context, mode, _) {
        // Material uygulama yapısını oluşturur
        return MaterialApp(
          // Uygulamanın başlığını belirler
          title: 'Susadım v1',
          // Debug yazısını kaldırır
          debugShowCheckedModeBanner: false,
          // Açık tema ayarlarını kullanır
          theme: AppTheme.light,
          // Koyu tema ayarlarını kullanır
          darkTheme: AppTheme.dark,
          // Aktif temayı seçilen mode değerine göre belirler
          themeMode: mode,
          // İlk ekranı açar ve tema controllerını gönderir
          home: WaterTrackerView(themeController: _themeController),
        );
      },
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import 'core/theme/app_theme.dart';
// tema controller dosyasını projeye ekler
import 'core/theme/theme_controller.dart';
// app shell dosyasını projeye ekler
import 'core/widgets/app_shell.dart';
// demo clinic veri deposu dosyasını projeye ekler
import 'data/demo/demo_clinic_store.dart';
// Uygulamanın ana widget sınıfı
class VenaFlowApp extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const VenaFlowApp({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // tema controllerı bilgisini zorunlu tutar
    required this.themeController,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // tema controllerı bilgisini tutar
  final ThemeController themeController;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<ThemeMode>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: themeController.mode,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, ThemeMode mode, _) {
        // material app değerini hesaplar veya döndürür
        return MaterialApp(
          // Başlığını belirler
          title: 'VenaFlow',
          // Debug yazısını gizler
          debugShowCheckedModeBanner: false,
          // Açık tema ayarlarını gönderir
          theme: AppTheme.light,
          // Koyu tema ayarlarını gönderir
          darkTheme: AppTheme.dark,
          // Aktif tema modunu belirler
          themeMode: mode,
          // home bilgisini belirler
          home: AppShell(
            // Veri deposunu widgeta gönderir
            store: store,
            // tema controllerı bilgisini belirler
            themeController: themeController,
          ),
        );
      },
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app dosyasını projeye ekler
import 'app.dart';
// tema controller dosyasını projeye ekler
import 'core/theme/theme_controller.dart';
// demo clinic veri deposu dosyasını projeye ekler
import 'data/demo/demo_clinic_store.dart';
// Uygulamanın başlangıç fonksiyonu
void main() {
  // İlgili nesne üzerinden metodu çağırır
  WidgetsFlutterBinding.ensureInitialized();
  // veri deposu değerini tanımlar
  final DemoClinicStore store = DemoClinicStore();
  // tema controllerı değerini tanımlar
  final ThemeController themeController = ThemeController();
  // Uygulamayı çalıştırır
  runApp(
    // VenaFlowApp nesnesini oluşturur veya kullanır
    VenaFlowApp(
      // Veri deposunu widgeta gönderir
      store: store,
      // tema controllerı bilgisini belirler
      themeController: themeController,
    ),
  );
}

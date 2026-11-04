// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Tanımlanan GoRouter rotalarını ekler
import 'app_router.dart';
// Uygulamanın giriş fonksiyonu
void main() {
  // SepetUygulamasi widgetını başlatır
  runApp(const SepetUygulamasi());
}
// Ana uygulama widgetını tanımlar
class SepetUygulamasi extends StatelessWidget {
  // Widgetın constructorı
  const SepetUygulamasi({super.key});
  // build metodunu yeniden yazar
  @override
  // Uygulama arayüzünü oluşturur
  Widget build(BuildContext context) {
    // GoRouter kullanan MaterialApp başlatır
    return MaterialApp.router(
      // Sağ üstteki debug yazısını kaldırır
      debugShowCheckedModeBanner: false,
      // Sayfa geçişlerinde uygulamaRotalarını kullanır
      routerConfig: uygulamaRotalari,
    );
  }
}

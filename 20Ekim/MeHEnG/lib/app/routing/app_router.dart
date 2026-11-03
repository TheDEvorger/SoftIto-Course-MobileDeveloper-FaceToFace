// Sayfa yönlendirme kütüphanesini ekler
import 'package:go_router/go_router.dart';
// Ana sayfa ekranını ekler
import '../shell/home_page.dart';
// Girişim çalışma alanını ekler
import '../pages/venture_workspace_page.dart';
// App router bilgisini oluşturur
final appRouter = GoRouter(
  // Uygulamanın sayfa rotalarını listeler
  routes: [
    // Go route sınıfını tanımlar oluşturur
    GoRoute(path: '/', builder: (_, _) => const HomePage()),
    // Go route sınıfını tanımlar oluşturur
    GoRoute(
      // Sayfa yolunu belirler
      path: '/venture/:id',
      // Alt widgetı oluşturan fonksiyonu tanımlar
      builder: (_, state) =>
          // Girişim çalışma alanı ekranı oluşturur
          VentureWorkspacePage(ventureId: state.pathParameters['id']!),
    ),
  ],
);

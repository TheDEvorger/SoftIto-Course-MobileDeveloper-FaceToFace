// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Sayfa yönlendirme ayarlarını ekler
import 'routing/app_router.dart';
// Tema ayarlarını ekler
import 'theme/meheng_theme.dart';
// Tema modu providerını ekler
import 'theme/theme_provider.dart';
// MeHEnG uygulamasının ana widgetı
class MehengApp extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const MehengApp({super.key, this.initialThemeMode});
  // Başlangıç tema modunu tutar
  final ThemeMode? initialThemeMode;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema modunu Riverpod üzerinden dinler
    final mode = initialThemeMode ?? ref.watch(themeModeProvider);
    // Router kullanan Material uygulamasını oluşturur
    return MaterialApp.router(
      // Başlık bilgisini belirler
      title: 'MeHEnG',
      // Debug etiketinin görünürlüğünü ayarlar
      debugShowCheckedModeBanner: false,
      // Açık tema ayarlarını kullanır
      theme: MehengTheme.light,
      // Koyu tema ayarlarını kullanır
      darkTheme: MehengTheme.dark,
      // Aktif tema modunu seçer
      themeMode: mode,
      // Sayfa yönlendirme ayarını bağlar
      routerConfig: appRouter,
    );
  }
}

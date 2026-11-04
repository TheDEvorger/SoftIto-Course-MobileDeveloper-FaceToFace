// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import 'garden_palette.dart';
// Sabitleri veya ortak işlemleri tutan, nesne oluşturulamayan sınıf
abstract final class GardenTheme {
  // açık tema işlemini yapar
  static ThemeData get light {
    // scheme bilgisini hesaplayıp saklar
    final scheme = ColorScheme.fromSeed(
      // seed renk bilgisini belirler
      seedColor: GardenPalette.mossEmerald,
      // brightness bilgisini belirler
      brightness: Brightness.light,
    // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
    ).copyWith(
      // ana renk bilgisini belirler
      primary: GardenPalette.mossEmerald,
      // ikincil renk bilgisini belirler
      secondary: GardenPalette.streamTurquoise,
      // tertiary bilgisini belirler
      tertiary: GardenPalette.harvestGold,
      // surface bilgisini belirler
      surface: GardenPalette.sandyPorcelain,
      // on surface olayındaki fonksiyonu belirler
      onSurface: GardenPalette.inkPlum,
    );
    // Uygulamanın tema ayarlarını oluşturur
    return ThemeData(
      // use material3 bilgisini belirler
      useMaterial3: true,
      // renk scheme bilgisini belirler
      colorScheme: scheme,
      // scaffold background renk bilgisini belirler
      scaffoldBackgroundColor: GardenPalette.sproutMist,
      // app bar tema bilgisini belirler
      appBarTheme: const AppBarTheme(
        // Arka plan rengini belirler
        backgroundColor: GardenPalette.sproutMist,
        // Yazı ve simge rengini belirler
        foregroundColor: GardenPalette.inkPlum,
      ),
      // kart renk bilgisini belirler
      cardColor: GardenPalette.sandyPorcelain,
      // visual density bilgisini belirler
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
  // koyu tema işlemini yapar
  static ThemeData get dark {
    // scheme bilgisini hesaplayıp saklar
    final scheme = ColorScheme.fromSeed(
      // seed renk bilgisini belirler
      seedColor: GardenPalette.lavenderGlow,
      // brightness bilgisini belirler
      brightness: Brightness.dark,
    // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
    ).copyWith(
      // ana renk bilgisini belirler
      primary: const Color(0xFFA4D49B),
      // ikincil renk bilgisini belirler
      secondary: GardenPalette.streamTurquoise,
      // tertiary bilgisini belirler
      tertiary: const Color(0xFFE4BC63),
      // surface bilgisini belirler
      surface: GardenPalette.nightCard,
      // on surface olayındaki fonksiyonu belirler
      onSurface: const Color(0xFFF8F2E8),
    );
    // Uygulamanın tema ayarlarını oluşturur
    return ThemeData(
      // use material3 bilgisini belirler
      useMaterial3: true,
      // renk scheme bilgisini belirler
      colorScheme: scheme,
      // scaffold background renk bilgisini belirler
      scaffoldBackgroundColor: GardenPalette.nightBackdrop,
      // app bar tema bilgisini belirler
      appBarTheme: const AppBarTheme(
        // Arka plan rengini belirler
        backgroundColor: GardenPalette.nightBackdrop,
        // Yazı ve simge rengini belirler
        foregroundColor: Color(0xFFF8F2E8),
      ),
      // kart renk bilgisini belirler
      cardColor: GardenPalette.nightCard,
      // visual density bilgisini belirler
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

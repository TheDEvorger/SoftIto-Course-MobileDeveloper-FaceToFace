// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık arayüzündeki renkleri tek yerde tanımlar
class RealmPalette {
  // parchment için sabit rengi belirler
  static const parchment = Color(0xFFF8F1DD);
  // parchment deep için sabit rengi belirler
  static const parchmentDeep = Color(0xFFECDDBB);
  // ink için sabit rengi belirler
  static const ink = Color(0xFF253036);
  // gold için sabit rengi belirler
  static const gold = Color(0xFFCA9E42);
  // gold soft için sabit rengi belirler
  static const goldSoft = Color(0xFFF2D389);
  // navy için sabit rengi belirler
  static const navy = Color(0xFF233D73);
  // forest için sabit rengi belirler
  static const forest = Color(0xFF355C4B);
  // rose için sabit rengi belirler
  static const rose = Color(0xFFA56574);
}
// build realm tema için gerekli sonucu hesaplar
ThemeData buildRealmTheme() {
  // scheme için sabit rengi belirler
  final scheme = ColorScheme.fromSeed(
          // seed color alanına gelen değeri kullanır
          seedColor: RealmPalette.navy, brightness: Brightness.light)
      // Mevcut verilerin değişen alanlarla kopyasını oluşturur
      .copyWith(
    // Temadaki birincil rengi belirler
    primary: RealmPalette.navy,
    // Temadaki ikincil rengi belirler
    secondary: RealmPalette.gold,
    // Kart ve panellerin arka plan rengini belirler
    surface: const Color(0xFFF7F3EA),
  );
  // Yeni ThemeData nesnesi oluşturup döndürür
  return ThemeData(
    // Material 3 tasarımını kullanır
    useMaterial3: true,
    // Sayfanın arka plan rengini belirler
    scaffoldBackgroundColor: const Color(0xFFF7F3EA),
    // Uygulamanın renk sistemini belirler
    colorScheme: scheme,
    // text tema alanına gelen değeri kullanır
    textTheme: const TextTheme(
      // headline large alanına gelen değeri kullanır
      headlineLarge: TextStyle(
          // Yazının boyutunu belirler
          fontSize: 35,
          // Yazının kalınlığını belirler
          fontWeight: FontWeight.w900,
          // Harfler arasındaki uzaklığı ayarlar
          letterSpacing: -1.3,
          // Bu elemanın rengini belirler
          color: RealmPalette.ink),
      // headline medium alanına gelen değeri kullanır
      headlineMedium: TextStyle(
          // Yazının boyutunu belirler
          fontSize: 28,
          // Yazının kalınlığını belirler
          fontWeight: FontWeight.w800,
          // Harfler arasındaki uzaklığı ayarlar
          letterSpacing: -0.8,
          // Bu elemanın rengini belirler
          color: RealmPalette.ink),
      // headline small alanına gelen değeri kullanır
      headlineSmall: TextStyle(
          // Yazının boyutunu belirler
          fontSize: 22, fontWeight: FontWeight.w800, color: RealmPalette.ink),
      // başlık large alanına gelen değeri kullanır
      titleLarge: TextStyle(
          // Yazının boyutunu belirler
          fontSize: 19, fontWeight: FontWeight.w800, color: RealmPalette.ink),
      // başlık medium alanına gelen değeri kullanır
      titleMedium: TextStyle(
          // Yazının boyutunu belirler
          fontSize: 16, fontWeight: FontWeight.w700, color: RealmPalette.ink),
      // body large alanına gelen değeri kullanır
      bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: RealmPalette.ink),
      // body medium alanına değerini belirler
      bodyMedium:
          // Metnin renk, boyut ve kalınlığını belirler
          TextStyle(fontSize: 14, height: 1.42, color: RealmPalette.ink),
      // body small alanına değerini belirler
      bodySmall:
          // Metnin renk, boyut ve kalınlığını belirler
          TextStyle(fontSize: 12, height: 1.32, color: Color(0xFF635C4F)),
    ),
    // Kartların ortak görünümünü belirler
    cardTheme: CardThemeData(
      // Bu elemanın rengini belirler
      color: Colors.white,
      // Bileşenin dışındaki boşluğu belirler
      margin: EdgeInsets.zero,
      // elevation alanına 0 değerini kullanır
      elevation: 0,
      // Kutunun veya butonun geometrik biçimini belirler
      shape: RoundedRectangleBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(24),
        // Dış çerçeve çizgisini belirler
        side:
            // border side bileşenini oluşturur
            BorderSide(color: const Color(0xFFDDD1B6).withValues(alpha: 0.85)),
      ),
    ),
    // Form giriş alanlarının genel görünümünü belirler
    inputDecorationTheme: InputDecorationTheme(
      // filled alanına özelliği açık yapar
      filled: true,
      // fill color alanına gelen değeri kullanır
      fillColor: Colors.white,
      // hint style alanına belirtilen renk değerini kullanır
      hintStyle: const TextStyle(color: Color(0xFF908774)),
      // İçeriğin kendi içindeki boşluğunu belirler
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // Kutunun kenarlık çizgisini oluşturur
      border: OutlineInputBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kenarlığın rengini ve kalınlığını belirler
        borderSide: const BorderSide(color: Color(0xFFD9CEB8)),
      ),
      // enabled border alanına gelen değeri kullanır
      enabledBorder: OutlineInputBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kenarlığın rengini ve kalınlığını belirler
        borderSide: const BorderSide(color: Color(0xFFD9CEB8)),
      ),
      // focused border alanına gelen değeri kullanır
      focusedBorder: OutlineInputBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(18),
        // Kenarlığın rengini ve kalınlığını belirler
        borderSide: const BorderSide(color: RealmPalette.gold, width: 1.4),
      ),
    ),
    // chip tema alanına gelen değeri kullanır
    chipTheme: ChipThemeData(
      // Arka plan rengini belirler
      backgroundColor: Colors.white,
      // Kutunun veya butonun geometrik biçimini belirler
      shape: RoundedRectangleBorder(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(24),
        // Dış çerçeve çizgisini belirler
        side: const BorderSide(color: Color(0xFFD7CCB6)),
      ),
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Etiket yazısının stilini belirler
      labelStyle:
          // Metnin renk, boyut ve kalınlığını belirler
          const TextStyle(fontWeight: FontWeight.w700, color: RealmPalette.ink),
      // seçilenler color alanına gelen değeri kullanır
      selectedColor: RealmPalette.parchmentDeep,
    ),
    // divider tema alanına değerini belirler
    dividerTheme:
        // DividerThemeData nesnesi için başlangıç değerlerini alır
        const DividerThemeData(color: Color(0xFFE1D8C6), thickness: 1),
  );
}

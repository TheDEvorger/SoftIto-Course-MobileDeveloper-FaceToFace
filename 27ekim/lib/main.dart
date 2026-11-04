// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Ürün listesini gösteren ekranı ekler
import 'screens/urun_listesi_ekrani.dart';
// Uygulamanın başlangıç fonksiyonu
void main() {
  // Mini mağaza widgetını çalıştırır
  runApp(const MiniMagazaUygulamasi());
}
// Durum tutmayan ana uygulama widgetı
class MiniMagazaUygulamasi extends StatelessWidget {
  // Widgetın key alabilen constructorı
  const MiniMagazaUygulamasi({super.key});
  // Üst sınıftaki build metodunu yeniden yazar
  @override
  // Uygulamanın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Material tasarımına sahip uygulama oluşturur
    return MaterialApp(
      // Sağ üstteki debug etiketini gizler
      debugShowCheckedModeBanner: false,
      // Uygulamanın başlığını belirler
      title:"Mini Mağaza",
      // Genel tema ayarlarını oluşturur
      theme: ThemeData(
        // Material 3 bileşenlerini kullanır
        useMaterial3: true,
        // Belirlenen renkten bir tema şeması üretir
        colorScheme: ColorScheme.fromSeed(
          // Temanın temel rengini lacivert seçer
          seedColor: Colors.indigo,
          // Açık renk modunu kullanır
          brightness: Brightness.light,
        ),
      ),
      // İlk sayfada ürün listesini gösterir
      home: const UrunListesiEkrani(),
    );
  }
}

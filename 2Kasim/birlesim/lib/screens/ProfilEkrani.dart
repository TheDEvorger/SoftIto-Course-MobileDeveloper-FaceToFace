// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Sepet sayacını yöneten sınıfı ekler
import '../SepetKontrolu.dart';
// Sepet sıfırlama butonunu gösteren profil sayfası
class ProfilEkrani extends StatelessWidget {
  // Widgetın constructorı
  const ProfilEkrani({super.key});
  // build metodunu yeniden yazar
  @override
  // Profil sayfasını oluşturur
  Widget build(BuildContext context) {
    // Üst menü ve sayfa gövdesini oluşturur
    return Scaffold(
      // Üstte Kullanıcı Profili başlığını gösterir
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      // Butonu sayfanın ortasına yerleştirir
      body: Center(
        // Sepeti temizleme butonu oluşturur
        child: TextButton(
          // Butona basılınca sepet sayacını sıfırlar
          onPressed: SepetKontrolu.ornek.sepetiSifirla,
          // Butonun görünen yazısını belirler
          child: const Text('Sepeti Temizle (0 Yap)'),
        ),
      ),
    );
  }
}

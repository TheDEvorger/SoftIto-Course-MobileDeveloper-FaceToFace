// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Sepet sayacını yöneten sınıfı ekler
import '../SepetKontrolu.dart';
// Sepete ekleme butonunun bulunduğu vitrin ekranı
class VitrinEkrani extends StatelessWidget {
  // Widgetın constructorı
  const VitrinEkrani({super.key});
  // build metodunu yeniden yazar
  @override
  // Vitrin sayfasını oluşturur
  Widget build(BuildContext context) {
    // Üst menü ve sayfa gövdesini oluşturur
    return Scaffold(
      // Sayfa başlığını gösterir
      appBar: AppBar(title: const Text('Canlı Vitrin (ValueNotifier)')),
      // Butonu sayfanın ortasına yerleştirir
      body: Center(
        // Simge ve yazılı buton oluşturur
        child: ElevatedButton.icon(
          // Butona basılınca ürün sayacını bir artırır
          onPressed: SepetKontrolu.ornek.sepeteEkle,
          // Butonda sepet simgesi gösterir
          icon: const Icon(Icons.add_shopping_cart),
          // Butonun yazısını belirler
          label: const Text('Sepete Ürün Ekle (+1)'),
        ),
      ),
    );
  }
}

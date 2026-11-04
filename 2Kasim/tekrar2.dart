// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Row taşmasını anlatan örnek ekranı oluşturur
class HataliveDogruRow extends StatelessWidget {
  // Widgetın constructorını tanımlar
  const HataliveDogruRow({super.key});
  // StatelessWidgetın build metodunu yeniden yazar
  @override
  // Ekranın widget ağacını kurar
  Widget build(BuildContext context) {
    // Üst menü ve gövde için Scaffold kullanır
    return Scaffold(
      // Üst menüde Row örneği başlığını gösterir
      appBar: AppBar(title: const Text('Row ve Layout Örneği')),
      // Gövdenin çevresine boşluk ekler
      body: Padding(
        // Her kenardan 16 boşluk bırakır
        padding: const EdgeInsets.all(16.0),
        // Elemanları alt alta düzenler
        child: Column(
          // Çocukları sola hizalar
          crossAxisAlignment: CrossAxisAlignment.start,
          // Column içindeki elemanları sıralar
          children: [
            // Hatalı örnek için açıklama metni başlatır
            const Text(
              // Uzun bir Row metninin taşabileceğini belirtir
              'Hatalı Yapı: a overflowed by ** pixels(sarı siyah şerit)',
              // Hatalı örnek başlığını kırmızı kalın yazar
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            // Başlık ile örnek arasına 8 boşluk bırakır
            const SizedBox(height: 8.0),
            // Hatalı yerleşim için sarı kutu oluşturur
            Container(
              // Kutunun arka planını sarı yapar
              color: Colors.yellow,
              // Simge ve metni Row içinde yan yana dizer
              child: Row(
                // Row çocuklarını tanımlar
                children: [
                  // Uyarı simgesini gösterir
                  const Icon(Icons.warning, color: Colors.black),
                  // Simge ile metin arasına 8 boşluk bırakır
                  const SizedBox(width: 8.0),
                  // Sınırlandırılmamış örnek metni oluşturur
                  const Text(
                    // Metin uzarsa Row içinde taşma oluşabileceğini anlatır
                    'Kısa metin (hata vermez ama uzarsa Render patlar).',
                  ),
                ],
              ),
            ),
            // İki örnek arasına 32 boşluk bırakır
            const SizedBox(height: 32),
            // Doğru yerleşim başlığı için metin oluşturur
            const Text(
              // Expanded ve Flexible ile sınırlandırmayı anlatır
              'Doğru Yapı:Flexible ve expanded ile sınırlandırılmıştır.',
              // Başlığın yazı stilini başlatır
              style: TextStyle(
                // Yazıyı kalınlaştırır
                fontWeight: FontWeight.bold,
                // Başlık rengini yeşil yapar
                color: Colors.green,
              ),
            ),
          ],
        ),
        // İkinci örnek için Container oluşturur
        Container(
          // İçeriden 8 boşluk bırakır
          padding: const EdgeInsets.all(8.0),
          // Kutunun arka planını yeşil belirler
          decoration: BoxDecoration(color: Colors.green),
          // Burada Border adlı geçersiz parametre var, kod derlenmez
          Border: Border.all(color: Colors.black),
          // Simge ile içeriği yan yana dizer
          child: Row(
            // Row çocuklarını sıralar
            children: [
              // Solda onay simgesi için yuvarlak alan açar
              const CircleAvatar(
                // Avatar arka planını yeşil yapar
                backgroundColor: Colors.green,
                // Beyaz onay simgesi gösterir
                child: Icon(Icons.check, color: Colors.white),
              ),
              // Simge ile metin arasına 12 boşluk bırakır
              const SizedBox(width: 12),
              // Sağdaki yazı grubuna kalan alanı verir
              Expanded(
                // Metinleri alt alta düzenler
                child: Column(
                  // Yazıları sola hizalar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Yazı grubunun çocuklarını sıralar
                  children: [
                    // Expanded ile taşmama açıklamasını başlatır
                    const Text(
                      // Metnin yatay alanla sınırlandırıldığını belirtir
                      'Bu metin uzun olsa bile taşmaz çünkü Expanded ile sınırlandırılmıştır.',
                      // Metnin stilini başlatır
                      style: TextStyle(
                        // Metin rengini amber yapar
                        color: Colors.amber,
                        // Yazıyı kalınlaştırır
                        fontWeight: FontWeight.bold,
                      ),
                      // İki açıklama arasına 4 boşluk koyar
                      SizedBox(height: 4),
                      // Expanded hakkında ikinci metni başlatır
                      Text(
                        // Row ve Column içinde kullanılabilir alanın paylaşımını anlatır
                        'Expanded widget, Row veya Column içindeki çocuk widget\'ların mevcut alanı paylaşmasını sağlar. Bu sayede taşma (overflow) sorunları önlenir.',
                        // İkinci açıklamayı turuncu renkte gösterir
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

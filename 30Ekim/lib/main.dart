
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Uygulamanın başlangıç fonksiyonu
void main() {
  // MyApp widgetını çalıştırır
  runApp(const MyApp());
}
// Ürün listesinin ana widget sınıfı
class MyApp extends StatelessWidget {
  // Sınıfın constructorı
  const MyApp({super.key});
  // Üstteki build metodunu yeniden yazar
  @override
  // Uygulamanın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Material tasarım yapısını oluşturur
    return MaterialApp(
      // Uygulamanın ilk ekranını belirler
      home: Scaffold(
        // Sayfanın üst menüsünü oluşturur
        appBar: AppBar(
          // Üst menüde sayfa başlığını gösterir
          title: Text("Ürün Listesi"),
        ),
        // Sayfanın ana içeriğini oluşturur
        body: Column(
          // Ürün kartlarını alt alta sıralar
          children: [
            // İlk ürün için kart oluşturur
            ProductCard(
              // İlk ürünün internet üzerindeki görsel adresi
              imageURL:'https://ia601602.us.archive.org/BookReader/BookReaderImages.php?zip=/10/items/brotherskaramaz00dost/brotherskaramaz00dost_jp2.zip&file=brotherskaramaz00dost_jp2/brotherskaramaz00dost_0001.jp2&id=brotherskaramaz00dost&scale=4&rotate=0',
              // İlk ürünün adını belirler
              title: 'Books1',
              // İlk ürünün fiyatını metin olarak gönderir
              price: '1000 TL',
            ),
            // İkinci ürün için kart oluşturur
            ProductCard(
              // İkinci ürünün internet üzerindeki görsel adresi
              imageURL: 'https://ia801603.us.archive.org/BookReader/BookReaderImages.php?zip=/26/items/31761116480161/31761116480161_jp2.zip&file=31761116480161_jp2/31761116480161_0005.jp2&id=31761116480161&scale=8&rotate=0',
              // İkinci ürünün adını belirler
              title: 'Books2',
              // İkinci ürünün fiyatını metin olarak gönderir
              price: '2000 TL',
            ),
          ],
        ),
      ),
    );
  }
}
// Farklı ürün bilgileriyle tekrar kullanılabilen kart sınıfı
class ProductCard extends StatelessWidget {
  // Ürün görselinin internet adresini tutar
  final String imageURL;
  // Ürünün adını tutar
  final String title;
  // Ürünün fiyatını String olarak tutar
  final String price;
  // Kartı oluşturmak için gerekli bilgileri alır
  const ProductCard({
    // Key bilgisini üst sınıfa gönderir
    super.key,
    // Görsel adresini zorunlu tutar
    required this.imageURL,
    // Ürün adını zorunlu tutar
    required this.title,
    // Fiyat bilgisini zorunlu tutar
    required this.price,
  });
  // Üstteki build metodunu yeniden yazar
  @override
  // Ürün kartının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ürün bilgilerini kart içinde gösterir
    return Card(
      // Görselle ürün bilgilerini yan yana dizer
      child: Row(
        // Kartın içindeki elemanlar
        children: [
          // Ürün görseli için kutu oluşturur
          Container(
            // Görsel kutusunun genişliğini belirler
            width: 100,
            // Görsel kutusunun yüksekliğini belirler
            height: 100,
            // Görsel yüklenmezse görülebilecek arka plan rengini belirler
            color: Colors.grey[200],
            // Görseli kutunun ortasına yerleştirir
            child: Center(
              // İnternetten görseli yükler ve kutuyu kaplayacak şekilde ölçekler
              child: Image.network(imageURL, fit: BoxFit.cover),
            ),
          ),
          // Görselin yanında kalan yatay alanı kullanır
          Expanded(
            // Ürün yazılarının çevresine boşluk ekler
            child: Padding(
              // Her taraftan 8 piksel boşluk bırakır
              padding: const EdgeInsets.all(8.0),
              // Ürün adı ve fiyatını alt alta dizer
              child: Column(
                // Yazıları sola hizalar
                crossAxisAlignment: CrossAxisAlignment.start,
                // Yazı elemanlarını listeler
                children: [
                  // Ürün adını 18 boyutunda kalın yazıyla gösterir
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // Ürün adıyla fiyat arasına 8 piksel boşluk bırakır
                  SizedBox(height: 8),
                  // Fiyatı 16 boyutunda yeşil yazıyla gösterir
                  Text(price, style: TextStyle(fontSize: 16, color: Colors.green[700])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

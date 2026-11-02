import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//Amacımız: İki adet basit ürün kartı oluşturmak
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Ürün Listesi"),
        ),
        body: Column(
          //Ürün kartları çalışan linklere sahip olmalı ve sol tarafta kutu içinde görseli olabilmeli
          children: [
            ProductCard(
              imageURL:'https://ia601602.us.archive.org/BookReader/BookReaderImages.php?zip=/10/items/brotherskaramaz00dost/brotherskaramaz00dost_jp2.zip&file=brotherskaramaz00dost_jp2/brotherskaramaz00dost_0001.jp2&id=brotherskaramaz00dost&scale=4&rotate=0',
              title: 'Books1',
              price: '1000 TL',
            ),
            ProductCard(
              imageURL: 'https://ia801603.us.archive.org/BookReader/BookReaderImages.php?zip=/26/items/31761116480161/31761116480161_jp2.zip&file=31761116480161_jp2/31761116480161_0005.jp2&id=31761116480161&scale=8&rotate=0',
              title: 'Books2',
              price: '2000 TL',
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageURL;
  final String title;
  final String price;

  const ProductCard({
    super.key,
    required this.imageURL,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.grey[200],
            child: Center(
              child: Image.network(imageURL, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
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
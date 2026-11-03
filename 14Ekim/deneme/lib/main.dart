// Flutter arayüz elemanlarını kullanmak için
import 'package:flutter/material.dart';

// Uygulamanın başlangıç fonksiyonu
void main() {
  // MyApp widgetını çalıştırır
  runApp(const MyApp());
}

// Değişken durum tutmayan ana widget
class MyApp extends StatelessWidget {
  // Constructor, super.key üst sınıfa key gönderir
  const MyApp({super.key});

  // Üst sınıftaki build metodunu yeniden yazar
  @override
  // Ekranda gösterilecek widget yapısını oluşturur
  Widget build(BuildContext context) {
    // Uygulamanın ana Material yapısı
    return MaterialApp(
      // Uygulamanın başlığı
      title: 'Flutter Demo',
      // Uygulamanın genel temasını belirler
      theme: ThemeData(
        // Mor rengi temel alarak renk paleti oluşturur
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      // Uygulama açıldığında gösterilecek ilk ekran
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Değişebilen verileri olan ekran için StatefulWidget
class MyHomePage extends StatefulWidget {
  // Constructor, title parametresinin verilmesini zorunlu tutar
  const MyHomePage({super.key, required this.title});

  // Ekranın başlığını tutar, final olduğu için sonradan değişmez
  final String title;

  // Üst sınıftaki createState metodunu yeniden yazar
  @override
  // Bu widget için State nesnesi oluşturur
  State<MyHomePage> createState() => _MyHomePageState();
}

// Ekranın değişebilen durumunu yöneten State sınıfı
class _MyHomePageState extends State<MyHomePage> {
  // Sayaç değişkeni, başlangıç değeri 0
  int _counter = 0;

  // Sayaç değerini artırmak için metot
  void _incrementCounter() {
    // State değiştiğinde build metodunun tekrar çalışmasını sağlar
    setState(() {
      // Sayaç değerini 1 artırır
      _counter++;
    });
  }

  // Üst sınıftaki build metodunu yeniden yazar
  @override
  // Ekranın güncel arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Ekranın üst çubuğunu oluşturur
      appBar: AppBar(
        // Temadan renk alarak AppBar arka planını belirler
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Widgeta verilen title değerini başlıkta gösterir
        title: Text(widget.title),
      ),
      // Sayfanın ana içerik alanı
      body: Center(
        // İçindeki widgetı merkeze yerleştirir
        child: Column(
          // Elemanları dikey eksende ortalar
          mainAxisAlignment: .center,
          // Alt alta gösterilecek widgetların listesi
          children: [
            // Değişmeyen açıklama metnini gösterir
            const Text('You have pushed the button this many times:'),
            // Sayaç değerini göstermek için Text widgetı
            Text(
              // Counter değerini String içine yerleştirir
              '$_counter',
              // Temadan orta boy başlık yazı stilini alır
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // Ekranın üzerinde duran yuvarlak işlem butonu
      floatingActionButton: FloatingActionButton(
        // Butona basılınca sayaç artırma metodunu çağırır
        onPressed: _incrementCounter,
        // Butonun ne işe yaradığını belirten kısa açıklama
        tooltip: 'Increment',
        // Butonun içinde artı simgesi gösterir
        child: const Icon(Icons.add),
      ),
    );
  }
}

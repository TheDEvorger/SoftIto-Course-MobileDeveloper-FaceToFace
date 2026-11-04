// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Generated concept photography is restricted to labelled fictional records.
// collection artwork görünümünü oluşturan widget sınıfı
class CollectionArtwork extends StatelessWidget {
  // collection artwork nesnesi oluşturur
  const CollectionArtwork({super.key, required this.tone, required this.name});
  // ad bilgisini tutar
  final String tone, name;
  // assets değerini tanımlar
  static const _assets = {
    // İlgili metin değerini belirler
    'touring': 'assets/images/sample-touring.png',
    // İlgili metin değerini belirler
    'electric': 'assets/images/sample-electric.png',
    // İlgili metin değerini belirler
    'suv': 'assets/images/sample-suv.png',
  };
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Semantics(
        // Görünen etiketi belirler
        label: '$name, yapay zekâ ile üretilmiş örnek araç görseli',
        // İçerikte gösterilecek widgetı belirler
        child: Stack(fit: StackFit.expand, children: [
          // Görseli gösterir
          Image.asset(_assets[tone] ?? _assets['electric']!,
              // Görselin yerleşme biçimini belirler
              fit: BoxFit.cover,
              // exclude from semantics bilgisini belirler
              excludeFromSemantics: true,
              // hata builder bilgisini belirler
              errorBuilder: (_, __, ___) => ColoredBox(
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  // İçerikte gösterilecek widgetı belirler
                  child: const Icon(Icons.directions_car_outlined, size: 40))),
          // Öğeyi Stack içinde konumlandırır
          Positioned(
              // left bilgisini belirler
              left: 8,
              // right bilgisini belirler
              right: 8,
              // bottom bilgisini belirler
              bottom: 8,
              // İçerikte gösterilecek widgetı belirler
              child: Align(
                  // Hizalamayı belirler
                  alignment: Alignment.bottomLeft,
                  // İçerikte gösterilecek widgetı belirler
                  child: Container(
                      // İç boşlukları ayarlar
                      padding: const EdgeInsets.symmetric(
                          // horizontal bilgisini belirler
                          horizontal: 8, vertical: 5),
                      // Kutunun görünümünü ayarlar
                      decoration: BoxDecoration(
                          // Rengi belirler
                          color: const Color(0xFF17221E),
                          // Köşeleri yuvarlar
                          borderRadius: BorderRadius.circular(6)),
                      // İçerikte gösterilecek widgetı belirler
                      child: const Text('ÖRNEK GÖRSEL · YAPAY ZEKÂ',
                          // Görünüm stilini belirler
                          style:
                              // Yazı stilini oluşturur
                              TextStyle(color: Colors.white, fontSize: 8))))),
        ]),
      );
}

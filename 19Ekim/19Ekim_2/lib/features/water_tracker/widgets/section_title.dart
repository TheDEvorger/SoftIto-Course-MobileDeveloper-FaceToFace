// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';

// Bölüm başlıklarını göstermek için StatelessWidget
class SectionTitle extends StatelessWidget {
  // Başlık bilgisini zorunlu alır
  const SectionTitle({super.key, required this.title});
  // Başlığın metnini tutar
  final String title;
  // Üstteki build metodunun üzerine yazar
  @override
  // Başlığı temadaki yazı stiliyle gösterir
  Widget build(BuildContext context) {
    // Gelen başlığı büyük başlık stiliyle yazdırır
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

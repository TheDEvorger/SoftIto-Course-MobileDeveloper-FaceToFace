// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';

// Su ekleme butonunu oluşturan sınıf
class QuickAddButton extends StatelessWidget {
  // onPressed fonksiyonunu zorunlu tutar
  const QuickAddButton({super.key, required this.onPressed});
  // Butona basılınca çalışacak callback
  final VoidCallback onPressed;
  // Üstteki build metodunun üzerine yazar
  @override
  // Butonun arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Butonun boyutlarını ayarlar
    return SizedBox(
      // Butonu yatayda mümkün olduğunca genişletir
      width: double.infinity,
      // Butonun yüksekliğini belirler
      height: 54,
      // Simge ve yazı içeren buton oluşturur
      child: FilledButton.icon(
        // Basılınca gönderilen fonksiyonu çalıştırır
        onPressed: onPressed,
        // Artı simgesini gösterir
        icon: const Icon(Icons.add_rounded),
        // Butonun yazısını gösterir
        label: const Text('Su ekle'),
      ),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';

// Tema controllerını ekler
import 'theme_controller.dart';

// Açık ve koyu tema değiştirme butonunu oluşturur
class ThemeToggleButton extends StatelessWidget {
  // Sınıfın constructorı
  const ThemeToggleButton({super.key});
  // Üstteki build metodunu yeniden yazar
  @override
  // Tema değiştirme butonunu oluşturur
  Widget build(BuildContext context) {
    // Aktif tema koyuysa true olur
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Simge butonu oluşturur
    return IconButton(
      // Temaya göre buton açıklamasını belirler
      tooltip: isDark ? 'Aydınlık moda geç' : 'Karanlık moda geç',
      // Koyu temada güneş, açık temada ay simgesi gösterir
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      // Basılınca tekil controller üzerinden temayı değiştirir
      onPressed: () => ThemeController.instance.toggle(isDark: isDark),
    );
  }
}

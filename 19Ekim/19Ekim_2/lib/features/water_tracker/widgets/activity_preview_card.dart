// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Tema renklerine ulaşmak için
import '../../../core/extensions/theme_extensions.dart';

// Antrenman kartını gösteren sınıf
class ActivityPreviewCard extends StatelessWidget {
  // Sınıfın constructorı
  const ActivityPreviewCard({super.key});
  // Üstteki build metodunun üzerine yazar
  @override
  // Antrenman kartının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Kart görünümü oluşturur
    return const Card(
      // Kartın iç boşluğunu ayarlar
      child: Padding(
        // Her taraftan 18 boşluk bırakır
        padding: EdgeInsets.all(18),
        // Kartın elemanlarını yan yana dizer
        child: Row(
          // Row içindeki elemanlar
          children: [
            // Antrenman simgesini gösterir
            _ActivityIcon(),
            // Yatayda 14 boşluk bırakır
            SizedBox(width: 14),
            // Açıklamayı kalan alana yayar
            Expanded(child: _ActivityDescription()),
            // Yakında yazısını gösterir
            _ComingSoonBadge(),
          ],
        ),
      ),
    );
  }
}

// Antrenman simgesini oluşturan sınıf
class _ActivityIcon extends StatelessWidget {
  // Sınıfın constructorı
  const _ActivityIcon();
  // Üstteki build metodunun üzerine yazar
  @override
  // Simgenin arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Simge için kutu oluşturur
    return Container(
      // Kutunun genişliği
      width: 46,
      // Kutunun yüksekliği
      height: 46,
      // Kutunun görünümünü ayarlar
      decoration: BoxDecoration(
        // Temadan arka plan rengini alır
        color: context.colors.workoutSurface,
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(15),
      ),
      // Şimşek simgesini tema rengiyle gösterir
      child: Icon(Icons.bolt_rounded, color: context.colors.workoutAccent),
    );
  }
}

// Antrenman açıklamasını gösteren sınıf
class _ActivityDescription extends StatelessWidget {
  // Sınıfın constructorı
  const _ActivityDescription();
  // Üstteki build metodunun üzerine yazar
  @override
  // Açıklama alanını oluşturur
  Widget build(BuildContext context) {
    // Yazıları alt alta dizer
    return Column(
      // Yazıları sola hizalar
      crossAxisAlignment: CrossAxisAlignment.start,
      // Column içindeki elemanlar
      children: [
        // Antrenman başlığını gösterir
        Text(
          // Başlık metni
          'Antrenman takibi',
          // Temadaki orta başlık stilini kullanır
          style: context.textTheme.titleMedium,
        ),
        // Dikeyde 4 boşluk bırakır
        const SizedBox(height: 4),
        // Antrenman açıklamasını gösterir
        Text(
          // Açıklama metni
          'Egzersiz ve kalori takibi',
          // Yazının rengini ve boyutunu belirler
          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

// Yakında etiketini oluşturan sınıf
class _ComingSoonBadge extends StatelessWidget {
  // Sınıfın constructorı
  const _ComingSoonBadge();
  // Üstteki build metodunun üzerine yazar
  @override
  // Etiketin arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka planı olan kutu oluşturur
    return DecoratedBox(
      // Kutunun görünümünü belirler
      decoration: BoxDecoration(
        // Arka plan rengini temadan alır
        color: context.colors.elevatedSurface,
        // Köşeleri yuvarlar
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      // Etiketin iç boşluğunu ayarlar
      child: Padding(
        // Yatayda 10 dikeyde 6 boşluk bırakır
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        // Etiket yazısını gösterir
        child: Text(
          // Henüz hazır olmayan özelliği belirtir
          'Yakında',
          // Yazının rengini ve boyutunu belirler
          style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
        ),
      ),
    );
  }
}

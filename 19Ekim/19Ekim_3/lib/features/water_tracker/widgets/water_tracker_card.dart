// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';

// Su miktarını ve hedefi gösteren kart sınıfı
class WaterTrackerCard extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const WaterTrackerCard({
    // Key bilgisini üst sınıfa gönderir
    super.key,
    // İçilen su miktarını zorunlu tutar
    required this.currentWater,
    // Günlük hedefi zorunlu tutar
    required this.dailyGoal,
  });
  // Güncel su miktarını tutar
  final int currentWater;
  // Günlük su hedefini tutar
  final int dailyGoal;
  // Üstteki build metodunu yeniden yazar
  @override
  // Su takip kartının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temanın yazı stillerini alır
    final TextTheme texts = Theme.of(context).textTheme;
    // Aktif temanın renk şemasını alır
    final ColorScheme colors = Theme.of(context).colorScheme;
    // İçilen suyun hedefe oranını hesaplar
    final double progress = (currentWater / dailyGoal).clamp(0.0, 1.0);
    // Kart görünümü oluşturur
    return Card(
      // Kartın iç boşluklarını ayarlar
      child: Padding(
        // Her taraftan 24 boşluk bırakır
        padding: const EdgeInsets.all(24),
        // Elemanları alt alta dizer
        child: Column(
          // Sadece içeriği kadar yükseklik kaplar
          mainAxisSize: MainAxisSize.min,
          // Kart içindeki elemanlar
          children: [
            // Su damlası simgesini ana tema rengiyle gösterir
            Icon(Icons.water_drop_rounded, size: 48, color: colors.primary),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Güncel su miktarını ve hedefi gösterir
            Text(
              // İçilen su ve hedefi ml olarak yazar
              '$currentWater / $dailyGoal ml',
              // Temadaki başlık stilini kopyalayıp değiştirir
              style: texts.headlineMedium?.copyWith(
                // Yazıyı kalın yapar
                fontWeight: FontWeight.bold,
                // Yazı rengini belirler
                color: colors.onSurface,
              ),
            ),
            // Dikeyde 16 boşluk bırakır
            const SizedBox(height: 16),
            // Yatay ilerleme çubuğu oluşturur
            LinearProgressIndicator(
              // Tamamlanma oranını gösterir
              value: progress,
              // Çubuğun yüksekliğini belirler
              minHeight: 12,
              // Çubuğun köşelerini yuvarlar
              borderRadius: BorderRadius.circular(8),
              // Çubuğun arka plan rengini belirler
              backgroundColor: colors.surfaceContainerHighest,
              // İlerleme rengini sabit tutar
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Tamamlanma yüzdesini gösterir
            Text(
              // Oranı 100 ile çarpıp yuvarlayarak yazdırır
              '%${(progress * 100).round()} tamamlandı',
              // Temadaki etiket stilini kopyalayıp değiştirir
              style: texts.labelLarge?.copyWith(
                // Yazı rengini ikincil tema renginden alır
                color: colors.secondary,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

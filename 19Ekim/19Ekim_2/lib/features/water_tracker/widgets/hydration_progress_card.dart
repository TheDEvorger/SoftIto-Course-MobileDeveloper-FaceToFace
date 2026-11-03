// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Tema renklerini ve yazı stillerini ekler
import '../../../core/extensions/theme_extensions.dart';
// Su takip controllerını ekler
import '../controllers/water_tracker_controller.dart';
// Su ekleme butonunu ekler
import 'quick_add_button.dart';

// Günlük su ilerlemesini gösteren sınıf
class HydrationProgressCard extends StatelessWidget {
  // Controller verilmesini zorunlu tutar
  const HydrationProgressCard({super.key, required this.controller});
  // Su verilerini yöneten controller
  final WaterTrackerController controller;
  // Üstteki build metodunun üzerine yazar
  @override
  // Su takip kartının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Kart oluşturur
    return Card(
      // Kartın iç boşluğunu ayarlar
      child: Padding(
        // Her taraftan 22 boşluk bırakır
        padding: const EdgeInsets.all(22),
        // Elemanları alt alta dizer
        child: Column(
          // Elemanları sola hizalar
          crossAxisAlignment: CrossAxisAlignment.start,
          // Kart içindeki elemanlar
          children: [
            // Kart başlığını gösterir
            const _CardHeading(),
            // Dikeyde 22 boşluk bırakır
            const SizedBox(height: 22),
            // Su miktarı ve ilerleme bilgisini gösterir
            _ProgressSummary(controller: controller),
            // Dikeyde 22 boşluk bırakır
            const SizedBox(height: 22),
            // Basılınca controllerdaki su ekleme metodunu çalıştırır
            QuickAddButton(onPressed: controller.addWater),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Bir bardak suyun miktarını gösterir
            const _ServingHint(),
          ],
        ),
      ),
    );
  }
}

// Kart başlığını oluşturan sınıf
class _CardHeading extends StatelessWidget {
  // Sınıfın constructorı
  const _CardHeading();
  // Üstteki build metodunun üzerine yazar
  @override
  // Başlığın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Simge ve başlığı yan yana dizer
    return Row(
      // Row içindeki elemanlar
      children: [
        // Su damlası simgesini gösterir
        Icon(Icons.water_drop_outlined, color: context.colors.accent, size: 20),
        // Yatayda 8 boşluk bırakır
        const SizedBox(width: 8),
        // Günlük su hedefi başlığını gösterir
        Text('Günlük su hedefi', style: context.textTheme.titleLarge),
      ],
    );
  }
}

// Su ilerleme özetini oluşturan sınıf
class _ProgressSummary extends StatelessWidget {
  // Controllerı zorunlu alır
  const _ProgressSummary({required this.controller});
  // Su takip controllerını tutar
  final WaterTrackerController controller;
  // Üstteki build metodunun üzerine yazar
  @override
  // Su miktarındaki değişimleri dinler
  Widget build(BuildContext context) {
    // int tipindeki su miktarını dinler
    return ValueListenableBuilder<int>(
      // Güncel su miktarını takip eder
      valueListenable: controller.currentWater,
      // Miktar değişince ilgili arayüzü günceller
      builder: (context, amount, _) => Row(
        // Row içindeki elemanlar
        children: [
          // Dairesel ilerleme göstergesini oluşturur
          _ProgressRing(amount: amount),
          // Yatayda 22 boşluk bırakır
          const SizedBox(width: 22),
          // Su miktarı özetini kalan alana yayar
          Expanded(child: _AmountSummary(amount: amount)),
        ],
      ),
    );
  }
}

// Dairesel ilerleme göstergesini oluşturan sınıf
class _ProgressRing extends StatelessWidget {
  // Su miktarını zorunlu alır
  const _ProgressRing({required this.amount});
  // İçilen su miktarını tutar
  final int amount;
  // Üstteki build metodunun üzerine yazar
  @override
  // İlerleme göstergesini oluşturur
  Widget build(BuildContext context) {
    // İçilen suyu günlük hedefe bölüp oranı hesaplar
    final progress = (amount / WaterTrackerController.dailyGoalMl)
        // Oranı 0 ile 1 arasında sınırlar
        .clamp(0.0, 1.0)
        // Sonucu double tipine çevirir
        .toDouble();
    // Göstergenin boyutlarını belirler
    return SizedBox(
      // Genişliği 106 yapar
      width: 106,
      // Yüksekliği 106 yapar
      height: 106,
      // Daire ile yazıları üst üste yerleştirir
      child: Stack(
        // Elemanları ortalar
        alignment: Alignment.center,
        // Stack içindeki elemanlar
        children: [
          // Dairesel ilerleme çubuğu oluşturur
          CircularProgressIndicator(
            // Günlük tamamlanma oranını gösterir
            value: progress,
            // Çubuğun kalınlığını belirler
            strokeWidth: 9,
            // Çubuk uçlarını yuvarlar
            strokeCap: StrokeCap.round,
            // Çubuğun arka plan rengini belirler
            backgroundColor: context.colors.progressRingBackground,
            // İlerleme rengini sabit tutar
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.accent),
          ),
          // Yüzde ve açıklamayı alt alta gösterir
          Column(
            // Sadece içeriği kadar alan kaplar
            mainAxisSize: MainAxisSize.min,
            // Column içindeki elemanlar
            children: [
              // Tamamlanan yüzdeyi gösterir
              Text(
                // Oranı 100 ile çarpıp yuvarlar
                '${(progress * 100).round()}%',
                // Temadaki başlık stilini kullanır
                style: context.textTheme.titleLarge,
              ),
              // Yüzdenin altındaki açıklama
              Text(
                // Tamamlanma yazısı
                'tamamlandı',
                // Yazının boyutunu ve rengini belirler
                style: TextStyle(
                  // Yazı boyutu
                  fontSize: 9,
                  // Yazı rengini temadan alır
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// İçilen ve kalan su miktarını gösteren sınıf
class _AmountSummary extends StatelessWidget {
  // Su miktarını zorunlu alır
  const _AmountSummary({required this.amount});
  // İçilen su miktarını tutar
  final int amount;
  // Üstteki build metodunun üzerine yazar
  @override
  // Su miktarı özetini oluşturur
  Widget build(BuildContext context) {
    // Günlük hedeften içilen miktarı çıkarır
    final remaining = (WaterTrackerController.dailyGoalMl - amount).clamp(
      // Kalan miktar sıfırın altına düşmez
      0,
      // Kalan miktar günlük hedefi geçmez
      WaterTrackerController.dailyGoalMl,
    );
    // Bilgileri alt alta dizer
    return Column(
      // Elemanları sola hizalar
      crossAxisAlignment: CrossAxisAlignment.start,
      // Column içindeki elemanlar
      children: [
        // İçilen su miktarını gösterir
        Text('$amount', style: context.textTheme.headlineMedium),
        // Miktarın birimini gösterir
        Text(
          // Mililitre açıklaması
          'ml içildi',
          // Yazı rengini belirler
          style: TextStyle(color: context.colors.textSecondary),
        ),
        // Dikeyde 12 boşluk bırakır
        const SizedBox(height: 12),
        // Hedef durumuna göre mesaj gösterir
        Text(
          // Kalan miktar sıfırsa hedef tamamlanmıştır
          remaining == 0
              // Hedef tamamlandıysa bu mesajı gösterir
              ? 'Harika! Günlük hedefini tamamladın.'
              // Hedef tamamlanmadıysa kalan miktarı gösterir
              : 'Hedefine $remaining ml kaldı.',
          // Yazının rengini ve boyutunu belirler
          style: TextStyle(color: context.colors.accent, fontSize: 12),
        ),
      ],
    );
  }
}

// Bir bardak su miktarını gösteren sınıf
class _ServingHint extends StatelessWidget {
  // Sınıfın constructorı
  const _ServingHint();
  // Üstteki build metodunun üzerine yazar
  @override
  // Bilgilendirme yazısını oluşturur
  Widget build(BuildContext context) {
    // Bir bardak miktarını gösterir
    return Text(
      // Su ekleme miktarı
      'Bir bardak su ekle · 250 ml',
      // Yazıyı ortalar
      textAlign: TextAlign.center,
      // Yazının rengini ve boyutunu belirler
      style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
    );
  }
}

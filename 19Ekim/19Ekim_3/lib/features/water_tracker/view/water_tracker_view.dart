// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';

// Tema değiştirme butonunu ekler
import '../../../core/theme/theme_toggle_button.dart';
// Su takip controllerını ekler
import '../controllers/water_tracker_controller.dart';
// Su takip kartını ekler
import '../widgets/water_tracker_card.dart';

// Su takip ekranının ana sınıfı
class WaterTrackerView extends StatefulWidget {
  // Sınıfın constructorı
  const WaterTrackerView({super.key});
  // Üstteki createState metodunu uygular
  @override
  // Ekranın State sınıfını oluşturur
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

// Ekranın durumunu yöneten State sınıfı
class _WaterTrackerViewState extends State<WaterTrackerView> {
  // Su takip işlemleri için controller oluşturur
  final WaterTrackerController _controller = WaterTrackerController();
  // Üstteki dispose metodunu yeniden yazar
  @override
  // Widget kaldırılırken çalışır
  void dispose() {
    // Su takip controllerını temizler
    _controller.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Su takip ekranının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfanın temel yapısını oluşturur
    return Scaffold(
      // Üst menüyü oluşturur
      appBar: AppBar(
        // Uygulamanın başlığını gösterir
        title: const Text('Susadım'),
        // Sağ tarafa tema değiştirme butonu ekler
        actions: const [ThemeToggleButton()],
      ),
      // Sayfanın ana içeriğini oluşturur
      body: SafeArea(
        // İçeriği güvenli ekran alanında tutar
        child: Padding(
          // Her taraftan 24 boşluk bırakır
          padding: const EdgeInsets.all(24),
          // Elemanları alt alta dizer
          child: Column(
            // Elemanları yatayda genişletir
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Sayfa içindeki elemanlar
            children: [
              // Sayfanın başlık bölümünü gösterir
              const _Header(),
              // Dikeyde 24 boşluk bırakır
              const SizedBox(height: 24),
              // Su miktarını dinleyerek kartı günceller
              ValueListenableBuilder<int>(
                // Controller içindeki güncel su miktarını dinler
                valueListenable: _controller.currentWater,
                // Miktar değişince kartı yeniden oluşturur
                builder: (context, currentWater, _) => WaterTrackerCard(
                  // Güncel su miktarını karta gönderir
                  currentWater: currentWater,
                  // Günlük hedefi karta gönderir
                  dailyGoal: _controller.dailyGoalWater,
                ),
              ),
            ],
          ),
        ),
      ),
      // Sağ alttaki su işlem butonlarını oluşturur
      floatingActionButton: _WaterActions(controller: _controller),
    );
  }
}

// Sayfanın başlık bölümünü oluşturan sınıf
class _Header extends StatelessWidget {
  // Sınıfın constructorı
  const _Header();
  // Üstteki build metodunu yeniden yazar
  @override
  // Başlık alanını oluşturur
  Widget build(BuildContext context) {
    // Aktif temanın yazı stillerini alır
    final TextTheme texts = Theme.of(context).textTheme;
    // Başlık ve açıklamayı alt alta dizer
    return Column(
      // Yazıları sola hizalar
      crossAxisAlignment: CrossAxisAlignment.start,
      // Başlık alanındaki elemanlar
      children: [
        // Ana başlığı gösterir
        Text('Bugünkü Su Tüketimi', style: texts.headlineSmall),
        // Dikeyde 4 boşluk bırakır
        const SizedBox(height: 4),
        // Her bardağın miktarını açıklar
        Text('Her bardak 250 ml olarak eklenir.', style: texts.bodyMedium),
      ],
    );
  }
}

// Su ekleme ve sıfırlama butonlarını oluşturan sınıf
class _WaterActions extends StatelessWidget {
  // Controllerı zorunlu alır
  const _WaterActions({required this.controller});
  // Su takip controllerını tutar
  final WaterTrackerController controller;
  // Üstteki build metodunu yeniden yazar
  @override
  // Su işlem butonlarını oluşturur
  Widget build(BuildContext context) {
    // Butonları yan yana dizer
    return Row(
      // Sadece butonların kapladığı kadar genişler
      mainAxisSize: MainAxisSize.min,
      // Row içindeki elemanlar
      children: [
        // Küçük sıfırlama butonu oluşturur
        FloatingActionButton.small(
          // Butona benzersiz Hero etiketi verir
          heroTag: 'reset_water',
          // Butonun açıklamasını belirler
          tooltip: 'Sıfırla',
          // Basılınca su miktarını sıfırlar
          onPressed: controller.resetWater,
          // Yenileme simgesini gösterir
          child: const Icon(Icons.refresh_rounded),
        ),
        // Yatayda 12 boşluk bırakır
        const SizedBox(width: 12),
        // Genişletilmiş su ekleme butonu oluşturur
        FloatingActionButton.extended(
          // Butona benzersiz Hero etiketi verir
          heroTag: 'add_water',
          // Basılınca su miktarına 250 ml ekler
          onPressed: controller.addWater,
          // Su damlası simgesini gösterir
          icon: const Icon(Icons.water_drop_rounded),
          // Butonun yazısını gösterir
          label: const Text('+250 ml'),
        ),
      ],
    );
  }
}

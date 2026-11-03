// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Tema renklerine ulaşmak için
import '../../../core/extensions/theme_extensions.dart';
// Tema controllerını ekler
import '../../../core/theme/theme_controller.dart';
// Su takip controllerını ekler
import '../controllers/water_tracker_controller.dart';
// Antrenman önizleme kartını ekler
import '../widgets/activity_preview_card.dart';
// Su ilerleme kartını ekler
import '../widgets/hydration_progress_card.dart';
// Son içilen sular kartını ekler
import '../widgets/recent_intakes_card.dart';
// Bölüm başlığı widgetını ekler
import '../widgets/section_title.dart';

// Su takip ekranının ana sınıfı
class WaterTrackerView extends StatefulWidget {
  // İsteğe bağlı tema controllerı alır
  const WaterTrackerView({
    // Key bilgisini üst sınıfa gönderir
    super.key,
    // Tema controllerı dışarıdan verilebilir
    this.themeController,
  });
  // Tema controllerını tutar, null olabilir
  final ThemeController? themeController;
  // Üstteki createState metodunu uygular
  @override
  // Ekranın State sınıfını oluşturur
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

// Ekranın değişen durumunu yöneten State sınıfı
class _WaterTrackerViewState extends State<WaterTrackerView> {
  // Su işlemlerini yöneten controllerı oluşturur
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
      // Ekranın ana içeriğini belirler
      body: SafeArea(
        // İçeriği güvenli ekran alanında tutar
        child: SingleChildScrollView(
          // Sayfanın kaydırılmasını sağlar
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
          // Elemanları alt alta dizer
          child: Column(
            // Elemanları sola hizalar
            crossAxisAlignment: CrossAxisAlignment.start,
            // Sayfadaki elemanlar
            children: [
              // Üst başlık alanını oluşturur
              _DashboardHeader(
                // Sıfırlama fonksiyonunu gönderir
                onReset: _controller.resetDay,
                // Tema controllerını gönderir
                themeController: widget.themeController,
              ),
              // Dikeyde 26 boşluk bırakır
              const SizedBox(height: 26),
              // Günlük su ilerleme kartını gösterir
              HydrationProgressCard(controller: _controller),
              // Dikeyde 30 boşluk bırakır
              const SizedBox(height: 30),
              // Bugünkü içimler başlığını gösterir
              const SectionTitle(title: 'Bugünkü içimler'),
              // Dikeyde 14 boşluk bırakır
              const SizedBox(height: 14),
              // Son su kayıtlarını gösterir
              RecentIntakesCard(controller: _controller),
              // Dikeyde 30 boşluk bırakır
              const SizedBox(height: 30),
              // Hareket ve kalori başlığını gösterir
              const SectionTitle(title: 'Hareket ve kalori'),
              // Dikeyde 14 boşluk bırakır
              const SizedBox(height: 14),
              // Antrenman önizleme kartını gösterir
              const ActivityPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// Sayfanın üst başlık alanını oluşturan sınıf
class _DashboardHeader extends StatelessWidget {
  // Sıfırlama fonksiyonunu zorunlu alır
  const _DashboardHeader({
    // Sıfırlama callbackini alır
    required this.onReset,
    // Tema controllerı isteğe bağlıdır
    this.themeController,
  });
  // Sıfırlama fonksiyonunu tutar
  final VoidCallback onReset;
  // Tema controllerını tutar, null olabilir
  final ThemeController? themeController;
  // Üstteki build metodunu yeniden yazar
  @override
  // Üst başlık alanını oluşturur
  Widget build(BuildContext context) {
    // Elemanları yan yana dizer
    return Row(
      // Row içindeki elemanlar
      children: [
        // Uygulamanın logosunu gösterir
        const _BrandMark(),
        // Yatayda 12 boşluk bırakır
        const SizedBox(width: 12),
        // Karşılama yazısını kalan alana yayar
        const Expanded(child: _Greeting()),
        // Tema controllerı varsa tema butonunu gösterir
        if (themeController != null)
          // Null olmadığını belirterek controllerı gönderir
          _ThemeToggleButton(themeController: themeController!),
        // Günlük kayıtları sıfırlama butonu
        IconButton(
          // Butonun açıklamasını gösterir
          tooltip: 'Günlük takibi sıfırla',
          // Basılınca sıfırlama onayı ister
          onPressed: () => _confirmReset(context, onReset),
          // Sıfırlama simgesini gösterir
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
    );
  }

  // Günlük kayıtları silmeden önce onay ister
  Future<void> _confirmReset(
    // Pencerenin açılacağı context
    BuildContext context,
    // Onay sonrası çalışacak fonksiyon
    VoidCallback onReset,
    // Asenkron metodu başlatır
  ) async {
    // Kullanıcının onay sonucunu bekler
    final shouldReset = await showDialog<bool>(
      // Pencerenin açılacağı context
      context: context,
      // Onay penceresini oluşturur
      builder: (context) => AlertDialog(
        // Pencerenin başlığını gösterir
        title: const Text('Günü sıfırla?'),
        // Silme uyarısını gösterir
        content: const Text('Bugünkü su kayıtların silinecek.'),
        // Pencerenin butonlarını tutar
        actions: [
          // Vazgeçme butonu oluşturur
          TextButton(
            // Basılınca false döndürerek pencereyi kapatır
            onPressed: () => Navigator.pop(context, false),
            // Butonun yazısını gösterir
            child: const Text('Vazgeç'),
          ),
          // Sıfırlama butonu oluşturur
          FilledButton(
            // Basılınca true döndürerek pencereyi kapatır
            onPressed: () => Navigator.pop(context, true),
            // Butonun yazısını gösterir
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
    // Onay verildiyse ve context hâlâ geçerliyse çalışır
    if (shouldReset == true && context.mounted) {
      // Günlük kayıtları sıfırlar
      onReset();
    }
  }
}

// Açık ve koyu tema butonunu oluşturan sınıf
class _ThemeToggleButton extends StatelessWidget {
  // Tema controllerını zorunlu alır
  const _ThemeToggleButton({required this.themeController});
  // Tema controllerını tutar
  final ThemeController themeController;
  // Üstteki build metodunu yeniden yazar
  @override
  // Tema değişimlerini dinleyen butonu oluşturur
  Widget build(BuildContext context) {
    // Tema değeri değiştikçe arayüzü günceller
    return ValueListenableBuilder<ThemeMode>(
      // Aktif tema modunu dinler
      valueListenable: themeController.themeMode,
      // Tema değişince yeni değeri alır
      builder: (context, mode, _) {
        // Koyu tema seçiliyse true olur
        final isDark = mode == ThemeMode.dark;
        // Tema değiştirme butonunu oluşturur
        return IconButton(
          // Aktif temaya göre açıklamayı değiştirir
          tooltip: isDark ? 'Aydınlık moda geç' : 'Karanlık moda geç',
          // Basılınca tema değiştirme metodunu çalıştırır
          onPressed: themeController.toggleTheme,
          // Aktif temaya göre simge gösterir
          icon: Icon(
            // Koyu temada güneş, açık temada ay simgesi gösterir
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            // Temaya göre simge rengini belirler
            color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF5C6BC0),
          ),
        );
      },
    );
  }
}

// Uygulama logosunu oluşturan sınıf
class _BrandMark extends StatelessWidget {
  // Sınıfın constructorı
  const _BrandMark();
  // Üstteki build metodunu yeniden yazar
  @override
  // Logo alanını oluşturur
  Widget build(BuildContext context) {
    // Logo için kutu oluşturur
    return Container(
      // Kutunun genişliği
      width: 46,
      // Kutunun yüksekliği
      height: 46,
      // Kutunun görünümünü ayarlar
      decoration: BoxDecoration(
        // Arka plan rengini temadan alır
        color: context.colors.brandSurface,
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(16),
      ),
      // Su damlası simgesini gösterir
      child: Icon(Icons.water_drop_rounded, color: context.colors.accent),
    );
  }
}

// Karşılama yazısını oluşturan sınıf
class _Greeting extends StatelessWidget {
  // Sınıfın constructorı
  const _Greeting();
  // Üstteki build metodunu yeniden yazar
  @override
  // Karşılama alanını oluşturur
  Widget build(BuildContext context) {
    // Yazıları alt alta dizer
    return Column(
      // Yazıları sola hizalar
      crossAxisAlignment: CrossAxisAlignment.start,
      // Column içindeki elemanlar
      children: [
        // Uygulamanın adını gösterir
        Text('SUSADIM', style: context.textTheme.labelSmall),
        // Dikeyde 3 boşluk bırakır
        const SizedBox(height: 3),
        // Karşılama mesajını gösterir
        Text('Bugün kendine iyi bak.', style: context.textTheme.bodyMedium),
      ],
    );
  }
}

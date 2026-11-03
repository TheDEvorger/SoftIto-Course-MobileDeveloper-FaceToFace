// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Tema renklerine ulaşmak için
import '../../../core/extensions/theme_extensions.dart';
// Su takip controllerını ekler
import '../controllers/water_tracker_controller.dart';
// Su kayıt modelini ekler
import '../models/water_intake.dart';

// Son içilen suları gösteren sınıf
class RecentIntakesCard extends StatelessWidget {
  // Controller verilmesini zorunlu tutar
  const RecentIntakesCard({super.key, required this.controller});
  // Su kayıtlarını yöneten controller
  final WaterTrackerController controller;
  // Üstteki build metodunun üzerine yazar
  @override
  // Son kayıtların arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Su kayıtlarını dinler değişince ekranı günceller
    return ValueListenableBuilder<List<WaterIntake>>(
      // Controller içindeki kayıt listesini dinler
      valueListenable: controller.intakes,
      // Gelen kayıtlarla kartı oluşturur
      builder: (context, intakes, _) => Card(
        // Kayıt yoksa boş mesajı gösterir
        child: intakes.isEmpty
            // Boş kayıt widgetını getirir
            ? const _EmptyIntakes()
            // Kayıt varsa alt alta listeler
            : Column(
                // Liste içindeki elemanlar
                children: [
                  // En fazla son 3 kaydı gösterir
                  for (var i = 0; i < intakes.length && i < 3; i++)
                    // Her kayıt için satır oluşturur
                    _IntakeRow(
                      // İlgili kaydı gönderir
                      intake: intakes[i],
                      // Son kayıt dışında ayırıcı çizgi gösterir
                      showDivider: i < intakes.length - 1 && i < 2,
                    ),
                ],
              ),
      ),
    );
  }
}

// Kayıt olmadığında gösterilecek widget
class _EmptyIntakes extends StatelessWidget {
  // Sınıfın constructorı
  const _EmptyIntakes();
  // Üstteki build metodunun üzerine yazar
  @override
  // Boş kayıt mesajını oluşturur
  Widget build(BuildContext context) {
    // Mesajın dış boşluklarını ayarlar
    return Padding(
      // Yatayda 18 dikeyde 22 boşluk bırakır
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      // Simge ve yazıyı yan yana dizer
      child: Row(
        // Row içindeki elemanlar
        children: [
          // Bardak simgesini gösterir
          Icon(Icons.local_drink_outlined, color: context.colors.textSecondary),
          // Yatayda 12 boşluk bırakır
          const SizedBox(width: 12),
          // Yazıyı kalan alana yayar
          Expanded(
            // Kayıt olmadığını belirten mesaj
            child: Text(
              // Kullanıcıya ilk kaydı eklemesini söyler
              'Henüz kayıt yok. İlk bardağını ekleyerek başlayabilirsin.',
              // Yazının rengini ve satır yüksekliğini belirler
              style:
                  TextStyle(color: context.colors.textSecondary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// Tek bir su kaydını gösteren sınıf
class _IntakeRow extends StatelessWidget {
  // Kayıt ve çizgi bilgisini zorunlu alır
  const _IntakeRow({required this.intake, required this.showDivider});
  // İçilen su kaydını tutar
  final WaterIntake intake;
  // Ayırıcı çizginin gösterilip gösterilmeyeceğini tutar
  final bool showDivider;
  // Üstteki build metodunun üzerine yazar
  @override
  // Kayıt satırının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Kayıt saatini ekranda gösterilecek biçime çevirir
    final time = TimeOfDay.fromDateTime(intake.recordedAt).format(context);
    // Satır ve çizgiyi alt alta dizer
    return Column(
      // Column içindeki elemanlar
      children: [
        // Hazır liste satırı oluşturur
        ListTile(
          // Sol tarafta yuvarlak simge gösterir
          leading: CircleAvatar(
            // Simgenin arka plan rengi
            backgroundColor: context.colors.accentMuted,
            // Su damlası simgesini gösterir
            child: Icon(
              // Simgeyi belirler
              Icons.water_drop_rounded,
              // Simgenin rengini belirler
              color: context.colors.accent,
              // Simgenin boyutu
              size: 20,
            ),
          ),
          // İçilen su miktarını gösterir
          title: Text(
            // Miktarı ml olarak yazar
            '${intake.amountMl} ml',
            // Temadaki başlık stilini kullanır
            style: context.textTheme.titleLarge,
          ),
          // İçilen suyun saatini gösterir
          subtitle: Text(
            // Formatlanan saat bilgisi
            time,
            // Yazının rengini belirler
            style: TextStyle(color: context.colors.textSecondary),
          ),
          // Sağ tarafta onay simgesi gösterir
          trailing: Icon(
            // Onay simgesini belirler
            Icons.check_circle,
            // Başarılı işlem rengini kullanır
            color: context.colors.success,
            // Simgenin boyutu
            size: 20,
          ),
        ),
        // Gerekliyse kayıtların arasına çizgi koyar
        if (showDivider) const Divider(height: 1, indent: 72, endIndent: 18),
      ],
    );
  }
}

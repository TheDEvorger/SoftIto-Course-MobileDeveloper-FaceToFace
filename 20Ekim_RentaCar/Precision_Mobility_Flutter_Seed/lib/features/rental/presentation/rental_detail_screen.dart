// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// kiralama controller dosyasını ekler
import '../application/rental_controller.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// yerel rezervasyon panel dosyasını ekler
import 'local_booking_panel.dart';
// kiralama actions dosyasını ekler
import 'rental_actions.dart';
// kiralama car kart dosyasını ekler
import 'rental_car_card.dart';
// kiralama detay ekran görünümünü oluşturan widget sınıfı
class RentalDetailScreen extends StatelessWidget {
  // kiralama detay ekran nesnesi oluşturur
  const RentalDetailScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // olay rezervasyonlar bilgisini zorunlu alır
      required this.onReservations,
      // başlangıç tarihler parametresini alır
      this.initialDates});
  // controller bilgisini tutar
  final RentalController controller;
  // araç bilgisini tutar
  final RentalVehicle vehicle;
  // olay rezervasyonlar bilgisini tutar
  final VoidCallback onReservations;
  // başlangıç tarihler bilgisini tutar
  final DateTimeRange? initialDates;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
      // listenable bilgisini belirler
      listenable: controller,
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, _) => Scaffold(
          // Sayfanın üst menüsünü oluşturur
          appBar: AppBar(title: const Text('Araç detayı'), actions: [
            // Simge butonu oluşturur
            IconButton(
                // Butonun açıklama metnini belirler
                tooltip:
                    // Önceki ifadeyi tamamlar
                    controller.repository.data.favorites.contains(vehicle.id)
                        // Koşul doğruysa bu değeri seçer
                        ? 'Favorilerden çıkar'
                        // Koşul yanlışsa bu değeri seçer
                        : 'Favorilere ekle',
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: !controller.ready || controller.busy
                    // Koşul doğruysa bu değeri seçer
                    ? null
                    // Koşul yanlışsa bu değeri seçer
                    : () => rentalAction(
                        // Önceki ifadeyi tamamlar
                        context, () => controller.favorite(vehicle.id)),
                // Butonun veya öğenin simgesini belirler
                icon: Icon(
                    // Önceki ifadeyi tamamlar
                    controller.repository.data.favorites.contains(vehicle.id)
                        // Koşul doğruysa bu değeri seçer
                        ? Icons.favorite
                        // Koşul yanlışsa bu değeri seçer
                        : Icons.favorite_border)),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 12),
          ]),
          // Sayfanın ana içeriğini oluşturur
          body: StudioPage(width: 1160, children: [
            // sayfa heading nesnesi oluşturur
            PageHeading(
                // eyebrow bilgisini belirler
                eyebrow: '${vehicle.category} / ${vehicle.city}',
                // Başlığı belirler
                title: vehicle.name,
                // açıklama bilgisini belirler
                description:
                    // İlgili metin değerini belirler
                    '${vehicle.gearbox} · ${vehicle.energy} · ${vehicle.seats} kişilik'),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 24),
            // Alan genişliğine göre içeriği düzenler
            LayoutBuilder(builder: (context, c) {
              // detaylar değerini belirler
              final details = Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // İçerideki elemanları listeler
                  children: [
                    // kiralama car fotoğraf nesnesi oluşturur
                    RentalCarPhoto(vehicle: vehicle),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 22),
                    // studio panel nesnesi oluşturur
                    StudioPanel(
                        // İçerikte gösterilecek widgetı belirler
                        child: Column(
                            // Çapraz eksendeki hizalamayı belirler
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // İçerideki elemanları listeler
                            children: [
                          // Metni gösterir
                          Text('Yolculuğunuza eşlik etsin.',
                              // Görünüm stilini belirler
                              style: Theme.of(context).textTheme.titleLarge),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(height: 12),
                          // Metni gösterir
                          Text(vehicle.description),
                          // Ayırıcı çizgi oluşturur
                          const Divider(height: 32),
                          // Sığmayan öğeleri alt satıra geçirir
                          Wrap(spacing: 24, runSpacing: 20, children: [
                            // İlgili metodu çalıştırır
                            _spec(Icons.settings_outlined, 'Vites',
                                // Önceki ifadeyi tamamlar
                                vehicle.gearbox),
                            // İlgili metodu çalıştırır
                            _spec(
                                // Flutter simgesini belirler
                                Icons.bolt_outlined, 'Enerji', vehicle.energy),
                            // İlgili metodu çalıştırır
                            _spec(Icons.person_outline, 'Kapasite',
                                // İlgili metin değerini belirler
                                '${vehicle.seats} kişi'),
                            // İlgili metodu çalıştırır
                            _spec(Icons.luggage_outlined, 'Bagaj',
                                // İlgili metin değerini belirler
                                '${vehicle.bags} valiz'),
                          ]),
                          // Ayırıcı çizgi oluşturur
                          const Divider(height: 32),
                          // Metni gösterir
                          Text('Alış noktası',
                              // Görünüm stilini belirler
                              style: Theme.of(context).textTheme.titleMedium),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(height: 8),
                          // Metni gösterir
                          Text('${vehicle.city} · ${vehicle.pickup}'),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(height: 8),
                          // Metni gösterir
                          Text(vehicle.fleet
                              // Koşul doğruysa bu değeri seçer
                              ? 'Filo koleksiyonu'
                              // Koşul yanlışsa bu değeri seçer
                              : 'Bireysel koleksiyon'),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(height: 16),
                          // Metni gösterir
                          const Text(
                              // İlgili metin değerini belirler
                              'Araç, donanım, fiyat ve alış noktası bilgileri hazır örnek koleksiyona aittir. '
                              // İlgili metin değerini belirler
                              'Görsel yapay zekâ ile üretilmiştir; bu modelin gerçek ilan fotoğrafı değildir.',
                              // Görünüm stilini belirler
                              style: TextStyle(fontSize: 11)),
                        ])),
                  ]);
              // rezervasyon değerini belirler
              final booking = LocalBookingPanel(
                  // İlgili controllerı bağlar
                  controller: controller,
                  // Araç bilgisini gönderir
                  vehicle: vehicle,
                  // İlk tarih aralığını belirler
                  initialDates: initialDates,
                  // rezervasyonlar için callback belirler
                  onReservations: onReservations);
              // Koşul doğruysa bu işlemi çalıştırır
              if (c.maxWidth < 850 ||
                  // Ekran ölçülerini alır
                  MediaQuery.textScalerOf(context).scale(1) > 1.3) {
                // Elemanları alt alta dizer
                return Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // İçerideki elemanları listeler
                    children: [details, const SizedBox(height: 24), booking]);
              }
              // Elemanları yan yana dizer
              return Row(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçerideki elemanları listeler
                  children: [
                    // Kalan alanı doldurur
                    Expanded(flex: 3, child: details),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(width: 24),
                    // Kalan alanı doldurur
                    Expanded(flex: 2, child: booking)
                  ]);
            }),
          ])));
  // spec işlemini gerçekleştirir
  Widget _spec(IconData icon, String label, String value) =>
      // Elemanları alt alta dizer
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Simgeyi gösterir
        Icon(icon, size: 22),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 7),
        // Metni gösterir
        Text(label, style: const TextStyle(fontSize: 11)),
        // Metni gösterir
        Text(value)
      ]);
}

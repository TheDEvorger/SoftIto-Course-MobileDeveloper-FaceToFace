// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// araç kataloğu araç kart dosyasını ekler
import '../../discovery/presentation/catalog_vehicle_card.dart';
// rezervasyon controller dosyasını ekler
import '../application/reservation_controller.dart';
// rezervasyon panel dosyasını ekler
import 'booking_panel.dart';
// reserve araç ekran görünümünü oluşturan widget sınıfı
class ReserveVehicleScreen extends StatelessWidget {
  // reserve araç ekran nesnesi oluşturur
  const ReserveVehicleScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // controller bilgisini zorunlu alır
      required this.controller,
      // bağlantı bilgisini zorunlu alır
      required this.connected,
      // olay connect bilgisini zorunlu alır
      required this.onConnect,
      // olay rezervasyonlar bilgisini zorunlu alır
      required this.onReservations,
      // başlangıç tarihler parametresini alır
      this.initialDates});
  // araç bilgisini tutar
  final Vehicle vehicle;
  // controller bilgisini tutar
  final ReservationController controller;
  // bağlantı bilgisini tutar
  final bool connected;
  // olay rezervasyonlar bilgisini tutar
  final VoidCallback onConnect, onReservations;
  // başlangıç tarihler bilgisini tutar
  final DateTimeRange? initialDates;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Scaffold(
      // Sayfanın üst menüsünü oluşturur
      appBar: AppBar(title: const Text('Araç ve yolculuk')),
      // Sayfanın ana içeriğini oluşturur
      body: StudioPage(children: [
        // sayfa heading nesnesi oluşturur
        PageHeading(
            // eyebrow bilgisini belirler
            eyebrow: 'Koleksiyon / ${vehicle.category}',
            // Başlığı belirler
            title: vehicle.name,
            // açıklama bilgisini belirler
            description:
                // İlgili metin değerini belirler
                '${vehicle.isFleet ? 'Filo' : 'Bireysel'} · ${vehicle.energy} · ${vehicle.seats} koltuk'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 30),
        // Alan genişliğine göre içeriği düzenler
        LayoutBuilder(builder: (context, constraints) {
          // detaylar değerini belirler
          final details =
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // araç fotoğraf nesnesi oluşturur
            VehiclePhoto(vehicle: vehicle),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 24),
            // studio panel nesnesi oluşturur
            StudioPanel(
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                  // Metni gösterir
                  Text('Aracı yakından tanıyın.',
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.titleLarge),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 16),
                  // Metni gösterir
                  Text(vehicle.description),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 24),
                  // Sığmayan öğeleri alt satıra geçirir
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    // chip nesnesi oluşturur
                    Chip(
                        // icon constructorını tanımlar
                        avatar: const Icon(Icons.bolt_outlined, size: 17),
                        // Görünen etiketi belirler
                        label: Text(vehicle.energy)),
                    // chip nesnesi oluşturur
                    Chip(
                        // icon constructorını tanımlar
                        avatar: const Icon(
                            // Flutter simgesini belirler
                            Icons.airline_seat_recline_normal_outlined,
                            // Boyutu belirler
                            size: 17),
                        // Görünen etiketi belirler
                        label: Text('${vehicle.seats} koltuk')),
                    // chip nesnesi oluşturur
                    Chip(label: Text(vehicle.category)),
                  ]),
                ])),
          ]);
          // rezervasyon değerini belirler
          final booking = BookingPanel(
              // Araç bilgisini gönderir
              vehicle: vehicle,
              // İlgili controllerı bağlar
              controller: controller,
              // Bağlantı durumunu gönderir
              connected: connected,
              // İlk tarih aralığını belirler
              initialDates: initialDates,
              // connect için callback belirler
              onConnect: () {
                // Sayfa açma veya kapatma işlemini yapar
                Navigator.of(context).pop();
                // İlgili metodu çalıştırır
                onConnect();
              },
              // rezervasyonlar için callback belirler
              onReservations: () {
                // Sayfa açma veya kapatma işlemini yapar
                Navigator.of(context).pop();
                // İlgili metodu çalıştırır
                onReservations();
              });
          // Koşul doğruysa bu işlemi çalıştırır
          if (constraints.maxWidth < 900 ||
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
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Kalan alanı doldurur
            Expanded(flex: 3, child: details),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 28),
            // Kalan alanı doldurur
            Expanded(flex: 2, child: booking)
          ]);
        }),
      ]));
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// palette dosyasını ekler
import '../../../core/theme/palette.dart';
// araç detaylar ekran dosyasını ekler
import 'vehicle_details_screen.dart';
// örnek araç dosyasını ekler
import '../domain/demo_vehicle.dart';
// precision button dosyasını ekler
import '../../../shared/widgets/precision_button.dart';
/// Keşif ekranında her bir aracı listeleyen kart bileşeni.
/// Araç görseli temsili ikonu, isim, kategori, mesafe ve fiyat bilgisini gösterir.
// araç kart görünümünü oluşturan widget sınıfı
class VehicleCard extends StatelessWidget {
  // araç kart nesnesi oluşturur
  const VehicleCard({super.key, required this.vehicle});
  /// Kartta gösterilecek araç verisi
  // araç bilgisini tutar
  final DemoVehicle vehicle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // metin tema değerini belirler
    final textTheme = Theme.of(context).textTheme;
    // Kart görünümü oluşturur
    return Card(
        // İçerikte gösterilecek widgetı belirler
        child: Padding(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.all(16),
            // İçerikte gösterilecek widgetı belirler
            child: Column(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçerideki elemanları listeler
              children: [
                // Görünüm için kutu oluşturur
                Container(
                    // Yüksekliği belirler
                    height: 120,
                    // Hizalamayı belirler
                    alignment: Alignment.center,
                    // Kutunun görünümünü ayarlar
                    decoration: BoxDecoration(
                        // Rengi belirler
                        color:
                            // Önceki ifadeyi tamamlar
                            Palette.precisionBlueGrey.withValues(alpha: 0.12),
                        // Köşeleri yuvarlar
                        borderRadius: BorderRadius.circular(12)),
                    // İçerikte gösterilecek widgetı belirler
                    child: const Icon(Icons.directions_car_filled_outlined,
                        // Boyutu belirler
                        size: 68, color: Palette.precisionBlueGrey)),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 16),
                // Metni gösterir
                Text(vehicle.name,
                    // Görünüm stilini belirler
                    style: textTheme.titleLarge
                        // Değer null değilse ilgili işlemi yapar
                        ?.copyWith(fontWeight: FontWeight.w700)),
                // Metni gösterir
                Text(vehicle.category),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 6),
                // Metni gösterir
                Text('${vehicle.distanceKm.toStringAsFixed(1)} km • '
                    // İlgili metin değerini belirler
                    '${vehicle.isFleet ? 'Filo' : 'Bireysel'}'),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 16),
                // Metni gösterir
                Text('₺${vehicle.pricePerDay} / gün',
                    // Görünüm stilini belirler
                    style: textTheme.titleMedium
                        // Değer null değilse ilgili işlemi yapar
                        ?.copyWith(fontWeight: FontWeight.bold)),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 10),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                SizedBox(
                    // Genişliği belirler
                    width: double.infinity,
                    // İçerikte gösterilecek widgetı belirler
                    child: PrecisionButton(
                        // Görünen etiketi belirler
                        label: 'Aracı incele',
                        // Görünüm stilini belirler
                        style: PrecisionButtonStyle.secondary,
                        // Butona basılınca çalışacak fonksiyonu belirler
                        onPressed: () => Navigator.of(context).push<void>(
                              // Sayfa geçişi oluşturur
                              MaterialPageRoute(
                                  // İçeriği oluşturan fonksiyonu belirler
                                  builder: (_) => VehicleDetailsScreen(
                                      // araç ID bilgisini belirler
                                      vehicleId: vehicle.id)),
                            ))),
              ],
            )));
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// precision empty durum dosyasını ekler
import '../../../shared/widgets/precision_empty_state.dart';
// örnek araç dosyasını ekler
import '../domain/demo_vehicle.dart';
/// Seçilen aracın teknik özelliklerini, açıklamasını ve fiyatını gösteren detay ekranı.
/// Kullanıcı bu ekrandan demo rezervasyon adımına ilerleyebilir.
// araç detaylar ekran görünümünü oluşturan widget sınıfı
class VehicleDetailsScreen extends StatelessWidget {
  // araç detaylar ekran nesnesi oluşturur
  const VehicleDetailsScreen({super.key, required this.vehicleId});
  /// Görüntülenecek aracın benzersiz kimliği
  // araç ID bilgisini tutar
  final String vehicleId;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // araç değerini belirler
    final vehicle = findDemoVehicle(vehicleId);
    // Sayfanın temel yapısını oluşturur
    return Scaffold(
      // Sayfanın üst menüsünü oluşturur
      appBar: AppBar(title: const Text('Araç detayları • DEMO')),
      // Sayfanın ana içeriğini oluşturur
      body: vehicle == null
          // precision empty durum constructorını tanımlar
          ? const PrecisionEmptyState(
              // Başlığı belirler
              title: 'Araç bulunamadı',
              // mesaj bilgisini belirler
              message: 'Bu örnek araç mevcut değil. Listeye geri dönün.')
          // Koşul yanlışsa bu değeri seçer
          : SingleChildScrollView(
              // İç boşlukları ayarlar
              padding: const EdgeInsets.all(24),
              // İçerikte gösterilecek widgetı belirler
              child: Center(
                  // İçerikte gösterilecek widgetı belirler
                  child: ConstrainedBox(
                // box constraints constructorını tanımlar
                constraints: const BoxConstraints(maxWidth: 900),
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçerideki elemanları listeler
                  children: [
                    // aspect ratio nesnesi oluşturur
                    const AspectRatio(
                        // aspect ratio bilgisini belirler
                        aspectRatio: 2.5,
                        // İçerikte gösterilecek widgetı belirler
                        child: Card(
                            // İçerikte gösterilecek widgetı belirler
                            child: Center(
                                // İçerikte gösterilecek widgetı belirler
                                child: Icon(Icons.directions_car_outlined,
                                    // Boyutu belirler
                                    size: 80)))),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 24),
                    // Metni gösterir
                    Text(vehicle.name,
                        // Görünüm stilini belirler
                        style: Theme.of(context).textTheme.headlineMedium),
                    // Metni gösterir
                    Text(vehicle.providerLabel),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 16),
                    // Metni gösterir
                    Text(vehicle.description),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 16),
                    // Sığmayan öğeleri alt satıra geçirir
                    Wrap(spacing: 12, runSpacing: 8, children: [
                      // chip nesnesi oluşturur
                      Chip(label: Text(vehicle.category)),
                      // chip nesnesi oluşturur
                      Chip(label: Text('${vehicle.seats} koltuk')),
                      // chip nesnesi oluşturur
                      Chip(label: Text(vehicle.energy)),
                    ]),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 16),
                    // Metni gösterir
                    Text('Örnek günlük fiyat: ₺${vehicle.pricePerDay}'),
                    // Metni gösterir
                    Text('Temsili uzaklık: ${vehicle.distanceKm} km'),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 16),
                    // Dolgulu buton oluşturur
                    FilledButton(
                        // Butona basılınca çalışacak fonksiyonu belirler
                        onPressed: () => Navigator.of(context)
                            // Önceki ifade üzerinde ek işlem uygular
                            .pushNamed('/booking', arguments: vehicle.id),
                        // İçerikte gösterilecek widgetı belirler
                        child: const Text('Rezervasyon demosunu aç')),
                    // Belirtilen boyutta boşluk veya kutu oluşturur
                    const SizedBox(height: 16),
                    // Metni gösterir
                    const Text('Yalnızca demo envanter. Araç, fiyat, mesafe ve '
                        // İlgili metin değerini belirler
                        'sağlayıcı bilgileri temsilidir. Gerçek kiralama yapılamaz.'),
                  ],
                ),
              ))),
    );
  }
}

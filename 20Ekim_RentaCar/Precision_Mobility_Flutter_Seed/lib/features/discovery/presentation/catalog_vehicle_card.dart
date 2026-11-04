// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç dosyasını ekler
import '../domain/vehicle.dart';
// collection artwork dosyasını ekler
import 'collection_artwork.dart';
// araç fotoğraf görünümünü oluşturan widget sınıfı
class VehiclePhoto extends StatelessWidget {
  // araç fotoğraf nesnesi oluşturur
  const VehiclePhoto({super.key, required this.vehicle});
  // araç bilgisini tutar
  final Vehicle vehicle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ClipRRect(
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(18),
      // İçerikte gösterilecek widgetı belirler
      child: AspectRatio(
          // aspect ratio bilgisini belirler
          aspectRatio: 1.75,
          // İçerikte gösterilecek widgetı belirler
          child: vehicle.example && vehicle.artwork.isNotEmpty
              // Koşul doğruysa bu değeri seçer
              ? CollectionArtwork(tone: vehicle.artwork, name: vehicle.name)
              // Koşul yanlışsa bu değeri seçer
              : vehicle.photoUrl.isEmpty
                  // Koşul doğruysa bu değeri seçer
                  ? _missing(context, false)
                  // Koşul yanlışsa bu değeri seçer
                  : Image.network(vehicle.photoUrl,
                      // Görselin yerleşme biçimini belirler
                      fit: BoxFit.cover,
                      // semantic etiket bilgisini belirler
                      semanticLabel: '${vehicle.name} fotoğrafı',
                      // hata builder bilgisini belirler
                      errorBuilder: (_, __, ___) => _missing(context, true))));
  // missing işlemini gerçekleştirir
  Widget _missing(BuildContext context, bool failed) => Container(
      // Kutunun görünümünü ayarlar
      decoration: BoxDecoration(
          // Rengi belirler
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      // İçerikte gösterilecek widgetı belirler
      child: LayoutBuilder(
          // İçeriği oluşturan fonksiyonu belirler
          builder: (context, constraints) =>
              // Elemanları alt alta dizer
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                // Simgeyi gösterir
                Icon(Icons.directions_car_outlined,
                    // Boyutu belirler
                    size: constraints.maxHeight < 160 ? 30 : 56,
                    // Rengi belirler
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 10),
                // Metni gösterir
                Text(failed ? 'Fotoğraf yüklenemedi' : 'Fotoğraf eklenmedi',
                    // Görünüm stilini belirler
                    style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 11,
                        // Rengi belirler
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ])));
}
// araç kataloğu araç kart görünümünü oluşturan widget sınıfı
class CatalogVehicleCard extends StatelessWidget {
  // araç kataloğu araç kart nesnesi oluşturur
  const CatalogVehicleCard(
      // Veri alanlarını tanımlar
      {super.key,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // olay manage parametresini alır
      this.onManage,
      // this değerini günceller
      this.manage = false});
  // araç bilgisini tutar
  final Vehicle vehicle;
  // olay open bilgisini tutar
  final VoidCallback onOpen;
  // olay manage bilgisini tutar
  final VoidCallback? onManage;
  // manage bilgisini tutar
  final bool manage;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => StudioPanel(
      // İç boşlukları ayarlar
      padding: 16,
      // İçerikte gösterilecek widgetı belirler
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // araç fotoğraf nesnesi oluşturur
        VehiclePhoto(vehicle: vehicle),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 20),
        // Sığmayan öğeleri alt satıra geçirir
        Wrap(
            // Hizalamayı belirler
            alignment: WrapAlignment.spaceBetween,
            // Öğeler arasındaki boşluğu belirler
            spacing: 14,
            // Satırlar arasındaki boşluğu belirler
            runSpacing: 8,
            // İçerideki elemanları listeler
            children: [
              // Metni gösterir
              Text(vehicle.category.toUpperCase(),
                  // Görünüm stilini belirler
                  style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 10,
                      // Harfler arasındaki boşluğu ayarlar
                      letterSpacing: 1.5,
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              // Metni gösterir
              Text(
                  // Önceki ifadeyi tamamlar
                  manage
                      // Koşul doğruysa bu değeri seçer
                      ? vehicle.statusLabel
                      // Koşul yanlışsa bu değeri seçer
                      : vehicle.isFleet
                          // Koşul doğruysa bu değeri seçer
                          ? 'Filo'
                          // Koşul yanlışsa bu değeri seçer
                          : 'Bireysel',
                  // Görünüm stilini belirler
                  style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 11,
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.primary))
            ]),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 14),
        // Sığmayan öğeleri alt satıra geçirir
        Wrap(spacing: 16, runSpacing: 8, children: [
          // İlgili metodu çalıştırır
          _spec(context, Icons.bolt_outlined, vehicle.energy),
          // İlgili metodu çalıştırır
          _spec(context, Icons.airline_seat_recline_normal_outlined,
              // İlgili metin değerini belirler
              '${vehicle.seats} koltuk'),
        ]),
        // Ayırıcı çizgi oluşturur
        const Divider(height: 32),
        // Metni gösterir
        Text(vehicle.rateLabel, style: Theme.of(context).textTheme.titleLarge),
        // Metni gösterir
        Text('günlük kiralama',
            // Görünüm stilini belirler
            style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 11,
                // Rengi belirler
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 18),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        SizedBox(
            // Genişliği belirler
            width: double.infinity,
            // İçerikte gösterilecek widgetı belirler
            child: OutlinedButton.icon(
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: onOpen,
                // Butonun veya öğenin simgesini belirler
                icon: Icon(manage ? Icons.edit_outlined : Icons.north_east,
                    // Boyutu belirler
                    size: 17),
                // Görünen etiketi belirler
                label: Text(manage ? 'Aracı düzenle' : 'Detayları gör'))),
        // Değer null değilse koşulu çalıştırır
        if (onManage != null)
          // Belirtilen boyutta boşluk veya kutu oluşturur
          SizedBox(
              // Genişliği belirler
              width: double.infinity,
              // İçerikte gösterilecek widgetı belirler
              child: TextButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: onManage,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.calendar_month_outlined, size: 17),
                  // Görünen etiketi belirler
                  label: const Text('Takvim ve yayın'))),
      ]));
  // spec işlemini gerçekleştirir
  Widget _spec(BuildContext context, IconData icon, String value) =>
      // Elemanları yan yana dizer
      Row(mainAxisSize: MainAxisSize.min, children: [
        // Simgeyi gösterir
        Icon(icon,
            // Boyutu belirler
            size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(width: 5),
        // Esnek genişlik sağlar
        Flexible(child: Text(value, style: const TextStyle(fontSize: 12)))
      ]);
}
// araç kataloğu grid görünümünü oluşturan widget sınıfı
class CatalogGrid extends StatelessWidget {
  // araç kataloğu grid nesnesi oluşturur
  const CatalogGrid(
      // Veri alanlarını tanımlar
      {super.key,
      // araçlar bilgisini zorunlu alır
      required this.vehicles,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // olay manage parametresini alır
      this.onManage,
      // this değerini günceller
      this.manage = false});
  // araçlar bilgisini tutar
  final List<Vehicle> vehicles;
  // olay open bilgisini tutar
  final ValueChanged<Vehicle> onOpen;
  // olay manage bilgisini tutar
  final ValueChanged<Vehicle>? onManage;
  // manage bilgisini tutar
  final bool manage;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // columns değerini belirler
        final columns = constraints.maxWidth >= 1000
            // Koşul doğruysa bu değeri seçer
            ? 3
            // Koşul yanlışsa bu değeri seçer
            : constraints.maxWidth >= 640
                // Koşul doğruysa bu değeri seçer
                ? 2
                // Koşul yanlışsa bu değeri seçer
                : 1;
        // Elemanları alt alta dizer
        return Column(children: [
          // Listedeki öğeleri veya indeksleri sırayla dolaşır
          for (var row = 0; row < (vehicles.length / columns).ceil(); row++)
            // İçerik etrafına boşluk bırakır
            Padding(
                // İç boşlukları ayarlar
                padding: const EdgeInsets.only(bottom: 18),
                // İçerikte gösterilecek widgetı belirler
                child: Row(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (var col = 0; col < columns; col++) ...[
                        // sized box constructorını tanımlar
                        if (col > 0) const SizedBox(width: 18),
                        // Kalan alanı doldurur
                        Expanded(
                            // İçerikte gösterilecek widgetı belirler
                            child: row * columns + col >= vehicles.length
                                // Koşul doğruysa bu değeri seçer
                                ? const SizedBox.shrink()
                                // Koşul yanlışsa bu değeri seçer
                                : CatalogVehicleCard(
                                    // Araç bilgisini gönderir
                                    vehicle: vehicles[row * columns + col],
                                    // manage bilgisini belirler
                                    manage: manage,
                                    // manage için callback belirler
                                    onManage: onManage == null
                                        // Koşul doğruysa bu değeri seçer
                                        ? null
                                        // Koşul yanlışsa bu değeri seçer
                                        : () => onManage!(
                                            // Önceki ifadeyi tamamlar
                                            vehicles[row * columns + col]),
                                    // open için callback belirler
                                    onOpen: () =>
                                        // İlgili metodu çalıştırır
                                        onOpen(vehicles[row * columns + col]))),
                      ]
                    ]))
        ]);
      });
}

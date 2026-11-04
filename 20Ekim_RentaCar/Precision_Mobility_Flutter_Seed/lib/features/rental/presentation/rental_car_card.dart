// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// kiralama car fotoğraf görünümünü oluşturan widget sınıfı
class RentalCarPhoto extends StatelessWidget {
  // kiralama car fotoğraf nesnesi oluşturur
  const RentalCarPhoto({super.key, required this.vehicle});
  // araç bilgisini tutar
  final RentalVehicle vehicle;
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
          child: Stack(fit: StackFit.expand, children: [
            // Görseli gösterir
            Image.asset('assets/images/sample-${vehicle.image}.png',
                // Görselin yerleşme biçimini belirler
                fit: BoxFit.cover,
                // semantic etiket bilgisini belirler
                semanticLabel:
                    // İlgili metin değerini belirler
                    '${vehicle.name}, yapay zekâ ile üretilmiş temsili görsel'),
            // Öğeyi Stack içinde konumlandırır
            Positioned(
                // left bilgisini belirler
                left: 10,
                // bottom bilgisini belirler
                bottom: 10,
                // İçerikte gösterilecek widgetı belirler
                child: Container(
                    // İç boşlukları ayarlar
                    padding:
                        // Boşlukları belirler
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // Kutunun görünümünü ayarlar
                    decoration: BoxDecoration(
                        // Rengi belirler
                        color: const Color(0xFF17221E),
                        // Köşeleri yuvarlar
                        borderRadius: BorderRadius.circular(6)),
                    // İçerikte gösterilecek widgetı belirler
                    child: const Text('Temsili görsel',
                        // Görünüm stilini belirler
                        style: TextStyle(color: Colors.white, fontSize: 10)))),
          ])));
}
// kiralama car kart görünümünü oluşturan widget sınıfı
class RentalCarCard extends StatelessWidget {
  // kiralama car kart nesnesi oluşturur
  const RentalCarCard(
      // Veri alanlarını tanımlar
      {super.key,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // favori bilgisini zorunlu alır
      required this.favorite,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // olay favori bilgisini zorunlu alır
      required this.onFavorite});
  // araç bilgisini tutar
  final RentalVehicle vehicle;
  // favori bilgisini tutar
  final bool favorite;
  // olay open bilgisini tutar
  final VoidCallback onOpen;
  // olay favori bilgisini tutar
  final VoidCallback? onFavorite;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => StudioPanel(
      // İç boşlukları ayarlar
      padding: 14,
      // İçerikte gösterilecek widgetı belirler
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Elemanları üst üste yerleştirir
        Stack(children: [
          // kiralama car fotoğraf nesnesi oluşturur
          RentalCarPhoto(vehicle: vehicle),
          // Öğeyi Stack içinde konumlandırır
          Positioned(
              // top bilgisini belirler
              top: 8,
              // right bilgisini belirler
              right: 8,
              // İçerikte gösterilecek widgetı belirler
              child: IconButton.filledTonal(
                  // Butonun açıklama metnini belirler
                  tooltip: favorite ? 'Favorilerden çıkar' : 'Favorilere ekle',
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: onFavorite,
                  // durum seçim bilgisini belirler
                  isSelected: favorite,
                  // Görünüm stilini belirler
                  style: IconButton.styleFrom(
                      // Arka plan rengini belirler
                      backgroundColor: Theme.of(context).colorScheme.surface),
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.favorite_border),
                  // Seçili durumdaki simgeyi belirler
                  selectedIcon: const Icon(Icons.favorite))),
        ]),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 18),
        // Metni gösterir
        Text(vehicle.category.toUpperCase(),
            // Görünüm stilini belirler
            style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 10,
                // Harfler arasındaki boşluğu ayarlar
                letterSpacing: 1.4,
                // Rengi belirler
                color: Theme.of(context).colorScheme.primary)),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 6),
        // Metni gösterir
        Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        Text('${vehicle.city} · ${vehicle.pickup}',
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.bodySmall),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 14),
        // Sığmayan öğeleri alt satıra geçirir
        Wrap(spacing: 12, runSpacing: 8, children: [
          // İlgili metodu çalıştırır
          _spec(Icons.settings_outlined, vehicle.gearbox),
          // İlgili metodu çalıştırır
          _spec(Icons.bolt_outlined, vehicle.energy),
          // İlgili metodu çalıştırır
          _spec(Icons.person_outline, '${vehicle.seats} kişi'),
        ]),
        // Ayırıcı çizgi oluşturur
        const Divider(height: 30),
        // Sığmayan öğeleri alt satıra geçirir
        Wrap(
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: WrapCrossAlignment.center,
            // Öğeler arasındaki boşluğu belirler
            spacing: 8,
            // İçerideki elemanları listeler
            children: [
              // Metni gösterir
              Text(vehicle.dailyLabel,
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleLarge),
              // Metni gösterir
              const Text('/ gün', style: TextStyle(fontSize: 12)),
            ]),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 16),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        SizedBox(
            // Genişliği belirler
            width: double.infinity,
            // İçerikte gösterilecek widgetı belirler
            child: OutlinedButton.icon(
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: onOpen,
                // Butonun veya öğenin simgesini belirler
                icon: const Icon(Icons.arrow_outward, size: 17),
                // Görünen etiketi belirler
                label: const Text('Aracı incele'))),
      ]));
  // spec işlemini gerçekleştirir
  Widget _spec(IconData icon, String text) =>
      // Elemanları yan yana dizer
      Row(mainAxisSize: MainAxisSize.min, children: [
        // Simgeyi gösterir
        Icon(icon, size: 15),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(width: 4),
        // Esnek genişlik sağlar
        Flexible(child: Text(text, style: const TextStyle(fontSize: 11)))
      ]);
}
// kiralama car grid görünümünü oluşturan widget sınıfı
class RentalCarGrid extends StatelessWidget {
  // kiralama car grid nesnesi oluşturur
  const RentalCarGrid(
      // Veri alanlarını tanımlar
      {super.key,
      // araçlar bilgisini zorunlu alır
      required this.vehicles,
      // favoriler bilgisini zorunlu alır
      required this.favorites,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // olay favori bilgisini zorunlu alır
      required this.onFavorite});
  // araçlar bilgisini tutar
  final List<RentalVehicle> vehicles;
  // favoriler bilgisini tutar
  final Set<String> favorites;
  // olay open bilgisini tutar
  final ValueChanged<RentalVehicle> onOpen;
  // olay favori bilgisini tutar
  final ValueChanged<RentalVehicle>? onFavorite;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // scale değerini belirler
        final scale = MediaQuery.textScalerOf(context).scale(1);
        // columns değerini belirler
        final columns = constraints.maxWidth >= 1050 && scale < 1.5
            // Koşul doğruysa bu değeri seçer
            ? 3
            // Koşul yanlışsa bu değeri seçer
            : constraints.maxWidth >= 650 && scale < 1.5
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
                padding: const EdgeInsets.only(bottom: 20),
                // İçerikte gösterilecek widgetı belirler
                child: Row(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (var col = 0; col < columns; col++) ...[
                        // sized box constructorını tanımlar
                        if (col > 0) const SizedBox(width: 20),
                        // Kalan alanı doldurur
                        Expanded(
                            // İçerikte gösterilecek widgetı belirler
                            child: row * columns + col >= vehicles.length
                                // Koşul doğruysa bu değeri seçer
                                ? const SizedBox.shrink()
                                // Koşul yanlışsa bu değeri seçer
                                : RentalCarCard(
                                    // Araç bilgisini gönderir
                                    vehicle: vehicles[row * columns + col],
                                    // favori bilgisini belirler
                                    favorite: favorites.contains(
                                        // Önceki ifadeyi tamamlar
                                        vehicles[row * columns + col].id),
                                    // open için callback belirler
                                    onOpen: () =>
                                        // İlgili metodu çalıştırır
                                        onOpen(vehicles[row * columns + col]),
                                    // favori için callback belirler
                                    onFavorite: onFavorite == null
                                        // Koşul doğruysa bu değeri seçer
                                        ? null
                                        // Koşul yanlışsa bu değeri seçer
                                        : () => onFavorite!(
                                            // Önceki ifadeyi tamamlar
                                            vehicles[row * columns + col]))),
                      ],
                    ])),
        ]);
      });
}

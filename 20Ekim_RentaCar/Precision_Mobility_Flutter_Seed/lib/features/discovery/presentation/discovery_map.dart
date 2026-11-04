// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// örnek araç dosyasını ekler
import '../domain/demo_vehicle.dart';
/// Şematik harita görünümü.
/// Gerçek GPS koordinatları veya harita sağlayıcısı (Google Maps vb.) kullanmaz;
/// araçların temsili konumlarını şematik bir ızgara üzerinde simüle eder.
// discovery map görünümünü oluşturan widget sınıfı
class DiscoveryMap extends StatelessWidget {
  // discovery map nesnesi oluşturur
  const DiscoveryMap(
      // Veri alanlarını tanımlar
      {super.key,
      // araçlar bilgisini zorunlu alır
      required this.vehicles,
      // seçim bilgisini zorunlu alır
      required this.selected,
      // olay seçim bilgisini zorunlu alır
      required this.onSelected});
  /// Haritada işaretlenecek araçlar listesi
  // araçlar bilgisini tutar
  final List<DemoVehicle> vehicles;
  /// Kullanıcının o an seçtiği araç (işaretçi vurgusu için)
  // seçim bilgisini tutar
  final DemoVehicle? selected;
  /// Bir araç işareti tıklandığında çağrılan geri çağırma
  // olay seçim bilgisini tutar
  final ValueChanged<DemoVehicle> onSelected;
  // Araçların harita üzerindeki sabit temsili yerleşim hizalamaları
  // positions değerini tanımlar
  static const _positions = [
    // alignment nesnesi oluşturur
    Alignment(-0.65, -0.65),
    // alignment nesnesi oluşturur
    Alignment(0.55, -0.25),
    // alignment nesnesi oluşturur
    Alignment(-0.45, 0.35),
    // alignment nesnesi oluşturur
    Alignment(0.65, 0.75),
  ];
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // renkler değerini belirler
    final colors = Theme.of(context).colorScheme;
    // Kart görünümü oluşturur
    return Card(
        // İçerikte gösterilecek widgetı belirler
        child: Padding(
      // İç boşlukları ayarlar
      padding: const EdgeInsets.all(16),
      // İçerikte gösterilecek widgetı belirler
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Metni gösterir
        Text('Şematik demo harita',
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        const Text(
            // İlgili metin değerini belirler
            'Canlı harita ve GPS yok. İşaretlerin konumları temsilidir.'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 12),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        SizedBox(
            // Yüksekliği belirler
            height: 300,
            // İçerikte gösterilecek widgetı belirler
            child: ClipRRect(
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(12),
              // İçerikte gösterilecek widgetı belirler
              child: ColoredBox(
                  // Rengi belirler
                  color: colors.surfaceContainerHighest,
                  // İçerikte gösterilecek widgetı belirler
                  child: Stack(
                    // Görselin yerleşme biçimini belirler
                    fit: StackFit.expand,
                    // İçerideki elemanları listeler
                    children: [
                      // exclude semantics nesnesi oluşturur
                      ExcludeSemantics(
                          // İçerikte gösterilecek widgetı belirler
                          child: CustomPaint(
                        // painter bilgisini belirler
                        painter: _SchematicRoads(colors.outlineVariant),
                      )),
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (final vehicle in vehicles)
                        // İçeriği hizalar
                        Align(
                          // Hizalamayı belirler
                          alignment: _positions[demoVehicles.indexOf(vehicle)],
                          // İçerikte gösterilecek widgetı belirler
                          child: Semantics(
                            // Seçili olup olmadığını belirler
                            selected: selected == vehicle,
                            // İçerikte gösterilecek widgetı belirler
                            child: IconButton.filledTonal(
                              // Widget kimliğini belirler
                              key: ValueKey('map-${vehicle.name}'),
                              // Butonun açıklama metnini belirler
                              tooltip: '${vehicle.name} • '
                                  // İlgili metin değerini belirler
                                  '${vehicle.isFleet ? 'Filo' : 'Bireysel'} • Örnek araç',
                              // durum seçim bilgisini belirler
                              isSelected: selected == vehicle,
                              // Butona basılınca çalışacak fonksiyonu belirler
                              onPressed: () => onSelected(vehicle),
                              // Butonun veya öğenin simgesini belirler
                              icon: const Icon(Icons.directions_car_outlined),
                              // Seçili durumdaki simgeyi belirler
                              selectedIcon: const Icon(Icons.directions_car),
                            ),
                          ),
                        ),
                    ],
                  )),
            )),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 12),
        // semantics nesnesi oluşturur
        Semantics(
            // live region bilgisini belirler
            liveRegion: true,
            // İçerikte gösterilecek widgetı belirler
            child: Text(
              // seçim değerini günceller
              selected == null
                  // Koşul doğruysa bu değeri seçer
                  ? '${vehicles.length} örnek araç • Bir işaret seçin.'
                  // Koşul yanlışsa bu değeri seçer
                  : 'Seçilen örnek: ${selected!.name}',
            )),
      ]),
    ));
  }
}
// schematic roads için sınıf oluşturur
class _SchematicRoads extends CustomPainter {
  // schematic roads constructorını tanımlar
  const _SchematicRoads(this.color);
  // renk bilgisini tutar
  final Color color;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // paint işlemini gerçekleştirir
  void paint(Canvas canvas, Size size) {
    // paint değerini belirler
    final paint = Paint()
      // Aynı nesne üzerinde ek işlem yapar
      ..color = color
      // Aynı nesne üzerinde ek işlem yapar
      ..strokeWidth = 12;
    // Listedeki öğeleri veya indeksleri sırayla dolaşır
    for (final fraction in [0.25, 0.5, 0.75]) {
      // Önceki ifadeyi tamamlar
      canvas.drawLine(Offset(size.width * fraction, 0),
          // başlangıç konumu nesnesi oluşturur
          Offset(size.width * fraction, size.height), paint);
      // Önceki ifadeyi tamamlar
      canvas.drawLine(Offset(0, size.height * fraction),
          // başlangıç konumu nesnesi oluşturur
          Offset(size.width, size.height * fraction), paint);
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // should repaint işlemini gerçekleştirir
  bool shouldRepaint(_SchematicRoads oldDelegate) => color != oldDelegate.color;
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// section heading dosyasını ekler
import '../../../shared/widgets/section_heading.dart';
// precision arama alan dosyasını ekler
import '../../../shared/widgets/precision_search_field.dart';
// precision empty durum dosyasını ekler
import '../../../shared/widgets/precision_empty_state.dart';
// örnek araç dosyasını ekler
import '../domain/demo_vehicle.dart';
// araç kart dosyasını ekler
import 'vehicle_card.dart';
// discovery map dosyasını ekler
import 'discovery_map.dart';
/// Araç keşif ana ekranı.
/// Arama, filo filtreleme, liste görünümü ve adaptif şematik harita sunar.
// discovery ekran ekranının değişen durumunu yönetir
class DiscoveryScreen extends StatefulWidget {
  // discovery ekran nesnesi oluşturur
  const DiscoveryScreen({super.key});
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}
// discovery ekran durum ekranının durumunu yöneten sınıf
class _DiscoveryScreenState extends State<DiscoveryScreen> {
  // Arama metni
  // arama metni değerini belirler
  String _query = '';
  // Sadece filo araçlarını filtreleme bayrağı
  // filo only değerini belirler
  bool _fleetOnly = false;
  // Dar ekranda harita mı liste mi görüntüleneceğini belirleyen bayrak
  // show map değerini belirler
  bool _showMap = false;
  // Haritada veya listede seçilen araç
  // seçim bilgisini tutar
  DemoVehicle? _selected;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // filtered değerini belirler
    final filtered = demoVehicles
        // Koşula uyan elemanları filtreler
        .where((vehicle) =>
            // Önceki ifadeyi tamamlar
            vehicle.name.toLowerCase().contains(_query.trim().toLowerCase()) &&
            // Koşul veya parametre ifadesini devam ettirir
            (!_fleetOnly || vehicle.isFleet))
        // Sonucu listeye dönüştürür
        .toList();
    // Alan genişliğine göre içeriği düzenler
    return LayoutBuilder(builder: (context, constraints) {
      // wide değerini belirler
      final wide = constraints.maxWidth >= 900;
      // map değerini belirler
      final map = DiscoveryMap(
        // Araç listesini gönderir
        vehicles: filtered,
        // Seçili olup olmadığını belirler
        selected: _selected,
        // Seçim değişince çalışacak fonksiyonu belirler
        onSelected: (vehicle) => setState(() => _selected = vehicle),
      );
      // results değerini belirler
      final results = CustomScrollView(slivers: [
        // sliver iç boşluk nesnesi oluşturur
        SliverPadding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          // sliver bilgisini belirler
          sliver: SliverToBoxAdapter(
              // İçerikte gösterilecek widgetı belirler
              child: Column(
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçerideki elemanları listeler
            children: [
              // section heading nesnesi oluşturur
              const SectionHeading(
                // Başlığı belirler
                title: 'Sürüşünüzü keşfedin',
                // Alt başlığı belirler
                subtitle:
                    // İlgili metin değerini belirler
                    'Örnek araçlar • Gerçek konum veya fiyat kullanılmıyor',
              ),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 20),
              // precision arama alan nesnesi oluşturur
              PrecisionSearchField(
                  // Görünen etiketi belirler
                  label: 'Araç adı ara',
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: (value) {
                    // Değişen verileri ekrana bildirir
                    setState(() {
                      // arama metni değerini günceller
                      _query = value;
                      // seçim değerini günceller
                      _selected = null;
                    });
                  }),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 8),
              // Filtre etiketi oluşturur
              FilterChip(
                // Görünen etiketi belirler
                label: const Text('Yalnızca filo araçları'),
                // Seçili olup olmadığını belirler
                selected: _fleetOnly,
                // Seçim değişince çalışacak fonksiyonu belirler
                onSelected: (value) => setState(() {
                  // filo only değerini günceller
                  _fleetOnly = value;
                  // seçim değerini günceller
                  _selected = null;
                }),
              ),
              // Koşul doğruysa bu işlemi çalıştırır
              if (!wide) ...[
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 12),
                // İfadeye karşılaştırma koşulu ekler
                SegmentedButton<bool>(
                  // segments bilgisini belirler
                  segments: const [
                    // button segment nesnesi oluşturur
                    ButtonSegment(
                        // Kullanılacak değeri belirler
                        value: false,
                        // Görünen etiketi belirler
                        label: Text('Liste'),
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.view_list_outlined)),
                    // button segment nesnesi oluşturur
                    ButtonSegment(
                        // Kullanılacak değeri belirler
                        value: true,
                        // Görünen etiketi belirler
                        label: Text('Harita'),
                        // Butonun veya öğenin simgesini belirler
                        icon: Icon(Icons.map_outlined)),
                  ],
                  // Seçili olup olmadığını belirler
                  selected: {_showMap},
                  // selection changed için callback belirler
                  onSelectionChanged: (value) =>
                      // Değişen verileri ekrana bildirir
                      setState(() => _showMap = value.single),
                ),
              ],
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 16),
              // semantics nesnesi oluşturur
              Semantics(
                  // live region bilgisini belirler
                  liveRegion: true,
                  // İçerikte gösterilecek widgetı belirler
                  child: Text(
                    // İlgili metin değerini belirler
                    'Koleksiyon • ${filtered.length} örnek araç',
                    // Görünüm stilini belirler
                    style: Theme.of(context).textTheme.titleLarge,
                  )),
            ],
          )),
        ),
        // Koşul doğruysa bu işlemi çalıştırır
        if (!wide && _showMap)
          // sliver iç boşluk nesnesi oluşturur
          SliverPadding(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            // sliver bilgisini belirler
            sliver: SliverToBoxAdapter(child: map),
          ),
        // Liste veya metin boşsa koşulu çalıştırır
        if (filtered.isEmpty)
          // sliver to box adapter nesnesi oluşturur
          const SliverToBoxAdapter(
              // İçerikte gösterilecek widgetı belirler
              child: PrecisionEmptyState(
            // Başlığı belirler
            title: 'Araç bulunamadı',
            // mesaj bilgisini belirler
            message: 'Arama metnini veya filo filtresini değiştirin.',
          )),
        // Koşul doğruysa bu işlemi çalıştırır
        if (wide || !_showMap)
          // sliver iç boşluk nesnesi oluşturur
          SliverPadding(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            // sliver bilgisini belirler
            sliver: SliverLayoutBuilder(builder: (context, constraints) {
              // columns değerini belirler
              final columns = constraints.crossAxisExtent >= 600 ? 2 : 1;
              // Hesaplanan sonucu geri döndürür
              return SliverList(
                // delegate bilgisini belirler
                delegate: SliverChildBuilderDelegate((context, row) {
                  // İçerik etrafına boşluk bırakır
                  return Padding(
                    // İç boşlukları ayarlar
                    padding: const EdgeInsets.only(bottom: 12),
                    // İçerikte gösterilecek widgetı belirler
                    child: Row(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçerideki elemanları listeler
                      children: [
                        // Listedeki öğeleri veya indeksleri sırayla dolaşır
                        for (var column = 0; column < columns; column++) ...[
                          // sized box constructorını tanımlar
                          if (column > 0) const SizedBox(width: 12),
                          // Kalan alanı doldurur
                          Expanded(
                              // İçerikte gösterilecek widgetı belirler
                              child: row * columns + column < filtered.length
                                  // Koşul doğruysa bu değeri seçer
                                  ? VehicleCard(
                                      // Araç bilgisini gönderir
                                      vehicle: filtered[row * columns + column])
                                  // Koşul yanlışsa bu değeri seçer
                                  : const SizedBox.shrink()),
                        ],
                      ],
                    ),
                  );
                // Önceki ifadeyi tamamlar
                }, childCount: (filtered.length / columns).ceil()),
              );
            }),
          ),
      ]);
      // Koşul doğruysa bu işlemi çalıştırır
      if (!wide) return results;
      // değer anahtar constructorını tanımlar
      return Row(key: const ValueKey('discovery-split'), children: [
        // Kalan alanı doldurur
        Expanded(flex: 3, child: results),
        // Kalan alanı doldurur
        Expanded(
            // flex bilgisini belirler
            flex: 2,
            // İçerikte gösterilecek widgetı belirler
            child: SingleChildScrollView(
              // İç boşlukları ayarlar
              padding: const EdgeInsets.fromLTRB(0, 24, 20, 24),
              // İçerikte gösterilecek widgetı belirler
              child: map,
            )),
      ]);
    });
  }
}

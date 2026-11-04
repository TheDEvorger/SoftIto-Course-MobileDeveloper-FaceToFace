// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio renkler dosyasını ekler
import '../../../core/theme/studio_colors.dart';
// action durum dosyasını ekler
import '../../../shared/design/action_state.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç kataloğu controller dosyasını ekler
import '../../discovery/application/catalog_controller.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// araç kataloğu araç kart dosyasını ekler
import '../../discovery/presentation/catalog_vehicle_card.dart';
// araç envanteri ekran ekranının değişen durumunu yönetir
class InventoryScreen extends StatefulWidget {
  // araç envanteri ekran nesnesi oluşturur
  const InventoryScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // bağlantı bilgisini zorunlu alır
      required this.connected,
      // olay connect bilgisini zorunlu alır
      required this.onConnect,
      // olay manage bilgisini zorunlu alır
      required this.onManage,
      // olay düzenleme bilgisini zorunlu alır
      required this.onEdit});
  // controller bilgisini tutar
  final CatalogController controller;
  // bağlantı bilgisini tutar
  final bool connected;
  // olay connect bilgisini tutar
  final VoidCallback onConnect;
  // olay düzenleme bilgisini tutar
  final ValueChanged<Vehicle?> onEdit;
  // olay manage bilgisini tutar
  final ValueChanged<Vehicle> onManage;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<InventoryScreen> createState() => _InventoryScreenState();
}
// araç envanteri ekran durum ekranının durumunu yöneten sınıf
class _InventoryScreenState extends State<InventoryScreen> {
  // filtre değerini belirler
  String _filter = 'all';
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
      // listenable bilgisini belirler
      listenable: widget.controller,
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, _) {
        // durum değerini belirler
        final state = widget.controller;
        // araçlar değerini belirler
        final vehicles = state.vehicles
            // Koşula uyan elemanları filtreler
            .where((v) =>
                // filtre değerini günceller
                _filter == 'all' ||
                // Koşul veya parametre ifadesini devam ettirir
                (_filter == 'published'
                    // Koşul doğruysa bu değeri seçer
                    ? v.published && !v.inMaintenance
                    // Constructor alanlarını başlangıç değerleriyle ayarlar
                    : _filter == 'unpublished'
                        // Koşul doğruysa bu değeri seçer
                        ? !v.published
                        // Koşul yanlışsa bu değeri seçer
                        : v.inMaintenance))
            // Sonucu listeye dönüştürür
            .toList();
        // Hesaplanan sonucu geri döndürür
        return StudioPage(children: [
          // sayfa heading nesnesi oluşturur
          PageHeading(
              // eyebrow bilgisini belirler
              eyebrow: 'Çalışma alanı / Araçlar',
              // Başlığı belirler
              title: 'Her araç, kontrolünüzde.',
              // açıklama bilgisini belirler
              description:
                  // İlgili metin değerini belirler
                  'Koleksiyonunuzu düzenleyin. Fiyatları ve bakım durumlarını tek yerden yönetin.',
              // action bilgisini belirler
              action: FilledButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: widget.connected
                      // Koşul doğruysa bu değeri seçer
                      ? () => widget.onEdit(null)
                      // Koşul yanlışsa bu değeri seçer
                      : widget.onConnect,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.add, size: 18),
                  // Görünen etiketi belirler
                  label: const Text('Araç ekle'))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 32),
          // Koşul doğruysa bu işlemi çalıştırır
          if (!widget.connected)
            // action durum nesnesi oluşturur
            ActionState(
                // Başlığı belirler
                title: 'Koleksiyonunuza bir kapı açın.',
                // mesaj bilgisini belirler
                message:
                    // İlgili metin değerini belirler
                    'Kayıtlı araçları yönetmek için Hesabım bölümünden çalışma alanınıza bağlanın.',
                // Butonun veya öğenin simgesini belirler
                icon: Icons.garage_outlined,
                // action bilgisini belirler
                action: widget.onConnect,
                // Görünen etiketi belirler
                label: 'Çalışma alanına bağlan')
          // Önceki koşul sağlanmazsa bu bölümü çalıştırır
          else ...[
            // İlgili metodu çalıştırır
            _summary(context, state.vehicles),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 30),
            // Sığmayan öğeleri alt satıra geçirir
            Wrap(
                // Hizalamayı belirler
                alignment: WrapAlignment.spaceBetween,
                // Öğeler arasındaki boşluğu belirler
                spacing: 20,
                // Satırlar arasındaki boşluğu belirler
                runSpacing: 12,
                // İçerideki elemanları listeler
                children: [
                  // Sığmayan öğeleri alt satıra geçirir
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    // Listedeki öğeleri veya indeksleri sırayla dolaşır
                    for (final f in const [
                      // Koşul veya parametre ifadesini devam ettirir
                      ('all', 'Tüm araçlar'),
                      // Koşul veya parametre ifadesini devam ettirir
                      ('published', 'Yayında'),
                      // Koşul veya parametre ifadesini devam ettirir
                      ('unpublished', 'Yayında değil'),
                      // Koşul veya parametre ifadesini devam ettirir
                      ('maintenance', 'Bakımda')
                    ])
                      // Seçilebilir filtre etiketi oluşturur
                      ChoiceChip(
                          // Görünen etiketi belirler
                          label: Text(f.$2),
                          // Seçili olup olmadığını belirler
                          selected: _filter == f.$1,
                          // Seçim değişince çalışacak fonksiyonu belirler
                          onSelected: (_) => setState(() => _filter = f.$1)),
                  ]),
                  // Çerçeveli buton oluşturur
                  OutlinedButton.icon(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: () => state.load(workspace: true),
                      // Butonun veya öğenin simgesini belirler
                      icon: const Icon(Icons.refresh, size: 17),
                      // Görünen etiketi belirler
                      label: const Text('Envanteri yenile')),
                ]),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 24),
            // Koşul doğruysa bu işlemi çalıştırır
            if (state.loading)
              // Yatay ilerleme çubuğu oluşturur
              const LinearProgressIndicator()
            // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
            else if (state.error != null)
              // action durum nesnesi oluşturur
              ActionState(
                  // Başlığı belirler
                  title: 'Envanter yüklenemedi.',
                  // mesaj bilgisini belirler
                  message: state.error!,
                  // Butonun veya öğenin simgesini belirler
                  icon: Icons.wifi_off_outlined,
                  // action bilgisini belirler
                  action: () => state.load(workspace: true),
                  // Görünen etiketi belirler
                  label: 'Yeniden dene')
            // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
            else if (vehicles.isEmpty)
              // action durum nesnesi oluşturur
              ActionState(
                  // Başlığı belirler
                  title: 'Koleksiyonunuzu oluşturun.',
                  // mesaj bilgisini belirler
                  message:
                      // İlgili metin değerini belirler
                      'Araç ekle ile araç bilgilerini ve günlük ücreti kaydedin.',
                  // Butonun veya öğenin simgesini belirler
                  icon: Icons.add_road_outlined,
                  // action bilgisini belirler
                  action: () => widget.onEdit(null),
                  // Görünen etiketi belirler
                  label: 'Yeni araç ekle')
            // Önceki ifadeyi tamamlar
            else
              // Alan genişliğine göre içeriği düzenler
              LayoutBuilder(
                  // İçeriği oluşturan fonksiyonu belirler
                  builder: (context, constraints) =>
                      // İfadeye karşılaştırma koşulu ekler
                      constraints.maxWidth >= 900 &&
                              // Ekran ölçülerini alır
                              MediaQuery.textScalerOf(context).scale(1) < 1.4
                          // Koşul doğruysa bu değeri seçer
                          ? _table(context, vehicles)
                          // Koşul yanlışsa bu değeri seçer
                          : CatalogGrid(
                              // Araç listesini gönderir
                              vehicles: vehicles,
                              // open için callback belirler
                              onOpen: widget.onEdit,
                              // manage için callback belirler
                              onManage: widget.onManage,
                              // manage bilgisini belirler
                              manage: true)),
          ],
        ]);
      });
  // summary işlemini gerçekleştirir
  Widget _summary(BuildContext context, List<Vehicle> vehicles) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(
          // İçeriği oluşturan fonksiyonu belirler
          builder: (context, constraints) =>
              // Sığmayan öğeleri alt satıra geçirir
              Wrap(spacing: 16, runSpacing: 16, children: [
                // Listedeki öğeleri veya indeksleri sırayla dolaşır
                for (final stat in [
                  // Koşul veya parametre ifadesini devam ettirir
                  (
                    // Önceki ifadeyi tamamlar
                    vehicles.length,
                    // İlgili metin değerini belirler
                    'Koleksiyondaki araç',
                    // Önceki ifadeyi tamamlar
                    StudioColors.lilac,
                    // Önceki ifadeyi tamamlar
                    StudioColors.violet,
                    // Flutter simgesini belirler
                    Icons.garage_outlined
                  ),
                  // Koşul veya parametre ifadesini devam ettirir
                  (
                    // Önceki ifadeyi tamamlar
                    vehicles
                        // Koşula uyan elemanları filtreler
                        .where((v) => v.published && !v.inMaintenance)
                        // Önceki ifade üzerinde ek işlem uygular
                        .length,
                    // İlgili metin değerini belirler
                    'Yayında',
                    // Önceki ifadeyi tamamlar
                    StudioColors.mint,
                    // Önceki ifadeyi tamamlar
                    StudioColors.forest,
                    // Flutter simgesini belirler
                    Icons.check_circle_outline
                  ),
                  // Koşul veya parametre ifadesini devam ettirir
                  (
                    // where((v) değerini günceller
                    vehicles.where((v) => v.inMaintenance).length,
                    // İlgili metin değerini belirler
                    'Bakımda',
                    // Önceki ifadeyi tamamlar
                    StudioColors.peach,
                    // Önceki ifadeyi tamamlar
                    StudioColors.coral,
                    // Flutter simgesini belirler
                    Icons.build_outlined
                  ),
                ])
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  SizedBox(
                      // Genişliği belirler
                      width: constraints.maxWidth < 600
                          // Koşul doğruysa bu değeri seçer
                          ? constraints.maxWidth
                          // Koşul yanlışsa bu değeri seçer
                          : (constraints.maxWidth - 32) / 3,
                      // İçerikte gösterilecek widgetı belirler
                      child: StudioPanel(
                          // Rengi belirler
                          color: Theme.of(context).brightness == Brightness.dark
                              // Koşul doğruysa bu değeri seçer
                              ? null
                              // Koşul yanlışsa bu değeri seçer
                              : stat.$3,
                          // İçerikte gösterilecek widgetı belirler
                          child: Row(children: [
                            // Kalan alanı doldurur
                            Expanded(
                                // İçerikte gösterilecek widgetı belirler
                                child: Column(
                                    // Çapraz eksendeki hizalamayı belirler
                                    crossAxisAlignment:
                                        // Elemanların hizalanma biçimini belirler
                                        CrossAxisAlignment.start,
                                    // İçerideki elemanları listeler
                                    children: [
                                  // Metni gösterir
                                  Text('${stat.$1}',
                                      // Görünüm stilini belirler
                                      style: Theme.of(context)
                                          // Önceki ifade üzerinde ek işlem uygular
                                          .textTheme
                                          // Önceki ifade üzerinde ek işlem uygular
                                          .displaySmall),
                                  // Belirtilen boyutta boşluk veya kutu oluşturur
                                  const SizedBox(height: 5),
                                  // Metni gösterir
                                  Text(stat.$2),
                                ])),
                            // Simgeyi gösterir
                            Icon(stat.$5,
                                // Rengi belirler
                                color: Theme.of(context).brightness ==
                                        // Tema parlaklığını belirler
                                        Brightness.dark
                                    // Koşul doğruysa bu değeri seçer
                                    ? null
                                    // Koşul yanlışsa bu değeri seçer
                                    : stat.$4,
                                // Boyutu belirler
                                size: 28)
                          ]))),
              ]));
  // table işlemini gerçekleştirir
  Widget _table(BuildContext context, List<Vehicle> vehicles) => StudioPanel(
      // İç boşlukları ayarlar
      padding: 8,
      // İçerikte gösterilecek widgetı belirler
      child: SingleChildScrollView(
          // scroll direction bilgisini belirler
          scrollDirection: Axis.horizontal,
          // İçerikte gösterilecek widgetı belirler
          child: DataTable(
              // horizontal dış boşluk bilgisini belirler
              horizontalMargin: 20,
              // column aralık bilgisini belirler
              columnSpacing: 24,
              // veri row min yükseklik bilgisini belirler
              dataRowMinHeight: 72,
              // veri row max yükseklik bilgisini belirler
              dataRowMaxHeight: 80,
              // columns bilgisini belirler
              columns: const [
                // veri column nesnesi oluşturur
                DataColumn(label: Text('Araç')),
                // veri column nesnesi oluşturur
                DataColumn(label: Text('Kaynak')),
                // veri column nesnesi oluşturur
                DataColumn(label: Text('Günlük ücret')),
                // veri column nesnesi oluşturur
                DataColumn(label: Text('Durum')),
                // veri column nesnesi oluşturur
                DataColumn(label: Text('İşlem'))
              ],
              // rows bilgisini belirler
              rows: [
                // Listedeki öğeleri veya indeksleri sırayla dolaşır
                for (final v in vehicles)
                  // veri row nesnesi oluşturur
                  DataRow(cells: [
                    // veri cell nesnesi oluşturur
                    DataCell(SizedBox(
                        // Genişliği belirler
                        width: 220,
                        // İçerikte gösterilecek widgetı belirler
                        child: Column(
                            // Ana eksendeki hizalamayı belirler
                            mainAxisAlignment: MainAxisAlignment.center,
                            // Çapraz eksendeki hizalamayı belirler
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // İçerideki elemanları listeler
                            children: [
                              // Metni gösterir
                              Text(v.name,
                                  // En fazla satır sayısını belirler
                                  maxLines: 2,
                                  // Taşan yazının nasıl gösterileceğini belirler
                                  overflow: TextOverflow.ellipsis,
                                  // Görünüm stilini belirler
                                  style: const TextStyle(
                                      // Yazı kalınlığını belirler
                                      fontWeight: FontWeight.w600)),
                              // Metni gösterir
                              Text(v.category,
                                  // En fazla satır sayısını belirler
                                  maxLines: 1,
                                  // Taşan yazının nasıl gösterileceğini belirler
                                  overflow: TextOverflow.ellipsis,
                                  // Görünüm stilini belirler
                                  style: const TextStyle(fontSize: 11))
                            ]))),
                    // veri cell nesnesi oluşturur
                    DataCell(Text(v.isFleet ? 'Filo' : 'Bireysel')),
                    // veri cell nesnesi oluşturur
                    DataCell(Text(v.rateLabel)),
                    // veri cell nesnesi oluşturur
                    DataCell(Text(v.statusLabel)),
                    // veri cell nesnesi oluşturur
                    DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                      // Simge butonu oluşturur
                      IconButton(
                          // Butonun açıklama metnini belirler
                          tooltip: 'Aracı düzenle',
                          // Butona basılınca çalışacak fonksiyonu belirler
                          onPressed: () => widget.onEdit(v),
                          // Butonun veya öğenin simgesini belirler
                          icon: const Icon(Icons.edit_outlined, size: 20)),
                      // Simge butonu oluşturur
                      IconButton(
                          // Butonun açıklama metnini belirler
                          tooltip: 'Takvim ve yayın',
                          // Butona basılınca çalışacak fonksiyonu belirler
                          onPressed: () => widget.onManage(v),
                          // Butonun veya öğenin simgesini belirler
                          icon: const Icon(Icons.calendar_month_outlined,
                              // Boyutu belirler
                              size: 20))
                    ])),
                  ])
              ])));
}

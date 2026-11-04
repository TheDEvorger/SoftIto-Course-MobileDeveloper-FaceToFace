// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// action durum dosyasını ekler
import '../../../shared/design/action_state.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç kataloğu controller dosyasını ekler
import '../application/catalog_controller.dart';
// araç dosyasını ekler
import '../domain/vehicle.dart';
// araç kataloğu araç kart dosyasını ekler
import 'catalog_vehicle_card.dart';
// editorial giriş alanı dosyasını ekler
import 'editorial_hero.dart';
// araç kataloğu ekran ekranının değişen durumunu yönetir
class CatalogScreen extends StatefulWidget {
  // araç kataloğu ekran nesnesi oluşturur
  const CatalogScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // olay ekleme araç bilgisini zorunlu alır
      required this.onAddVehicle});
  // controller bilgisini tutar
  final CatalogController controller;
  // function bilgisini tutar
  final void Function(Vehicle, DateTimeRange?) onOpen;
  // olay ekleme araç bilgisini tutar
  final VoidCallback onAddVehicle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<CatalogScreen> createState() => _CatalogScreenState();
}
// araç kataloğu ekran durum ekranının durumunu yöneten sınıf
class _CatalogScreenState extends State<CatalogScreen> {
  // results anahtar değerini belirler
  final _resultsKey = GlobalKey();
  // arama metni değerini belirler
  String _query = '', _source = 'all', _sort = 'name';
  // tarihler bilgisini tutar
  DateTimeRange? _dates;
  // reload işlemini asenkron yürütür
  Future<void> _reload() =>
      // Üst widgettan gelen bilgilere erişir
      widget.controller.load(start: _dates?.start, end: _dates?.end);
  // pick tarihler işlemini asenkron yürütür
  Future<void> _pickDates() async {
    // now değerini belirler
    final now = DateUtils.dateOnly(DateTime.now());
    // range değerini belirler
    final range = await showDateRangePicker(
        // context bilgisini belirler
        context: context,
        // Seçilebilecek ilk tarihi belirler
        firstDate: now,
        // Seçilebilecek son tarihi belirler
        lastDate: now.add(const Duration(days: 365)),
        // Başlangıç tarih aralığını belirler
        initialDateRange: _dates,
        // help metin bilgisini belirler
        helpText: 'Alış ve dönüş tarihleri',
        // kaydetme metin bilgisini belirler
        saveText: 'Uygula');
    // Widget kaldırılmışsa işlemi durdurur
    if (!mounted || range == null) return;
    // Koşul doğruysa bu işlemi çalıştırır
    if (rentalDays(range.start, range.end) < 1 ||
        // İlgili fonksiyonu çalıştırır
        rentalDays(range.start, range.end) > 7) {
      // Ekranda kısa bilgi mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
          // Alt bilgi mesajı oluşturur
          const SnackBar(content: Text('1–7 günlük bir tarih aralığı seçin.')));
      // Önceki ifadeyi tamamlar
      return;
    }
    // Değişen verileri ekrana bildirir
    setState(() => _dates = range);
    // Asenkron işlemin tamamlanmasını bekler
    await _reload();
  }
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
        // filtered değerini belirler
        final filtered = state.vehicles
            // Koşula uyan elemanları filtreler
            .where((v) =>
                // İlgili metin değerini belirler
                '${v.name} ${v.category} ${v.energy}'
                    // Önceki ifade üzerinde ek işlem uygular
                    .toLowerCase()
                    // Önceki ifade üzerinde ek işlem uygular
                    .contains(_query.toLowerCase().trim()) &&
                // Koşul veya parametre ifadesini devam ettirir
                (_source == 'all' || v.ownership == _source))
            // Sonucu listeye dönüştürür
            .toList();
        // sort((a, b) değerini günceller
        filtered.sort((a, b) => _sort == 'low'
            // Koşul doğruysa bu değeri seçer
            ? a.rateMinor.compareTo(b.rateMinor)
            // Constructor alanlarını başlangıç değerleriyle ayarlar
            : _sort == 'high'
                // Koşul doğruysa bu değeri seçer
                ? b.rateMinor.compareTo(a.rateMinor)
                // Koşul yanlışsa bu değeri seçer
                : a.name.compareTo(b.name));
        // Hesaplanan sonucu geri döndürür
        return StudioPage(children: [
          // editorial giriş alanı nesnesi oluşturur
          EditorialHero(
              // explore için callback belirler
              onExplore: () => Scrollable.ensureVisible(
                  // İlgili işlemi çalıştırır
                  _resultsKey.currentContext!,
                  // Süreyi belirler
                  duration: const Duration(milliseconds: 350),
                  // Hizalamayı belirler
                  alignment: .1)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // studio panel nesnesi oluşturur
          StudioPanel(
              // İç boşlukları ayarlar
              padding: 20,
              // İçerikte gösterilecek widgetı belirler
              child: LayoutBuilder(builder: (context, constraints) {
                // arama değerini belirler
                final search = TextField(
                    // Kutunun görünümünü ayarlar
                    decoration: const InputDecoration(
                        // Giriş alanının etiketini belirler
                        labelText: 'Araç, kategori veya enerji türü ara',
                        // Metin kutusunun sol simgesini belirler
                        prefixIcon: Icon(Icons.search)),
                    // Değer değişince çalışacak fonksiyonu belirler
                    onChanged: (value) => setState(() => _query = value));
                // tarihler değerini belirler
                final dates = OutlinedButton.icon(
                    // Butona basılınca çalışacak fonksiyonu belirler
                    onPressed: _pickDates,
                    // Butonun veya öğenin simgesini belirler
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    // Görünen etiketi belirler
                    label: Text(_dates == null
                        // Koşul doğruysa bu değeri seçer
                        ? 'Tarih seç'
                        // Koşul yanlışsa bu değeri seçer
                        : '${dateKey(_dates!.start)} → ${dateKey(_dates!.end)}'));
                // Elemanları alt alta dizer
                return Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // İçerideki elemanları listeler
                    children: [
                      // Koşul doğruysa bu işlemi çalıştırır
                      if (constraints.maxWidth >= 760 &&
                          // Ekran ölçülerini alır
                          MediaQuery.textScalerOf(context).scale(1) < 1.4)
                        // Elemanları yan yana dizer
                        Row(children: [
                          // Kalan alanı doldurur
                          Expanded(child: search),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(width: 20),
                          // Önceki ifadeyi tamamlar
                          dates
                        ])
                      // sized box constructorını tanımlar
                      else ...[search, const SizedBox(height: 12), dates],
                      // Değer null değilse koşulu çalıştırır
                      if (_dates != null)
                        // İçeriği hizalar
                        Align(
                            // Hizalamayı belirler
                            alignment: Alignment.centerLeft,
                            // İçerikte gösterilecek widgetı belirler
                            child: TextButton(
                                // Butona basılınca çalışacak fonksiyonu belirler
                                onPressed: () {
                                  // Değişen verileri ekrana bildirir
                                  setState(() => _dates = null);
                                  // İlgili metodu çalıştırır
                                  _reload();
                                },
                                // İçerikte gösterilecek widgetı belirler
                                child: const Text('Tarihleri temizle'))),
                    ]);
              })),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 36),
          // Görünüm için kutu oluşturur
          Container(
              // Widget kimliğini belirler
              key: _resultsKey,
              // İçerikte gösterilecek widgetı belirler
              child: Wrap(
                  // Hizalamayı belirler
                  alignment: WrapAlignment.spaceBetween,
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // Öğeler arasındaki boşluğu belirler
                  spacing: 20,
                  // Satırlar arasındaki boşluğu belirler
                  runSpacing: 16,
                  // İçerideki elemanları listeler
                  children: [
                    // Elemanları alt alta dizer
                    Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // İçerideki elemanları listeler
                        children: [
                          // Metni gösterir
                          Text('KOLEKSİYON',
                              // Görünüm stilini belirler
                              style: TextStyle(
                                  // Yazı boyutunu belirler
                                  fontSize: 10,
                                  // Harfler arasındaki boşluğu ayarlar
                                  letterSpacing: 2,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.w700,
                                  // Rengi belirler
                                  color:
                                      // Aktif temayı alır
                                      Theme.of(context).colorScheme.primary)),
                          // Belirtilen boyutta boşluk veya kutu oluşturur
                          const SizedBox(height: 8),
                          // Metni gösterir
                          Text('Sürüşünüzü seçin.',
                              // Görünüm stilini belirler
                              style:
                                  // Aktif temayı alır
                                  Theme.of(context).textTheme.headlineMedium),
                          // Değer null ise koşulu çalıştırır
                          if (!state.loading && state.error == null)
                            // Metni gösterir
                            Text('${filtered.length} araç',
                                // Görünüm stilini belirler
                                style: TextStyle(
                                    // Rengi belirler
                                    color: Theme.of(context)
                                        // Önceki ifade üzerinde ek işlem uygular
                                        .colorScheme
                                        // Önceki ifade üzerinde ek işlem uygular
                                        .onSurfaceVariant)),
                        ]),
                    // Alan genişliğine göre içeriği düzenler
                    LayoutBuilder(
                        // İçeriği oluşturan fonksiyonu belirler
                        builder: (context, constraints) => SizedBox(
                            // Genişliği belirler
                            width: constraints.maxWidth.clamp(0.0, 280.0),
                            // İçerikte gösterilecek widgetı belirler
                            child: Row(children: [
                              // Kalan alanı doldurur
                              Expanded(
                                  // İçerikte gösterilecek widgetı belirler
                                  child: DropdownButton<String>(
                                      // durum genişletme bilgisini belirler
                                      isExpanded: true,
                                      // Kullanılacak değeri belirler
                                      value: _sort,
                                      // underline bilgisini belirler
                                      underline: const SizedBox.shrink(),
                                      // Seçenekleri listeler
                                      items: const [
                                        // Seçim listesine seçenek ekler
                                        DropdownMenuItem(
                                            // Kullanılacak değeri belirler
                                            value: 'name',
                                            // İçerikte gösterilecek widgetı belirler
                                            child: Text('Ada göre',
                                                // En fazla satır sayısını belirler
                                                maxLines: 1,
                                                // Taşan yazının nasıl gösterileceğini belirler
                                                overflow:
                                                    // Önceki ifadeyi tamamlar
                                                    TextOverflow.ellipsis)),
                                        // Seçim listesine seçenek ekler
                                        DropdownMenuItem(
                                            // Kullanılacak değeri belirler
                                            value: 'low',
                                            // İçerikte gösterilecek widgetı belirler
                                            child: Text('Fiyat: düşükten',
                                                // En fazla satır sayısını belirler
                                                maxLines: 1,
                                                // Taşan yazının nasıl gösterileceğini belirler
                                                overflow:
                                                    // Önceki ifadeyi tamamlar
                                                    TextOverflow.ellipsis)),
                                        // Seçim listesine seçenek ekler
                                        DropdownMenuItem(
                                            // Kullanılacak değeri belirler
                                            value: 'high',
                                            // İçerikte gösterilecek widgetı belirler
                                            child: Text('Fiyat: yüksekten',
                                                // En fazla satır sayısını belirler
                                                maxLines: 1,
                                                // Taşan yazının nasıl gösterileceğini belirler
                                                overflow:
                                                    // Önceki ifadeyi tamamlar
                                                    TextOverflow.ellipsis))
                                      ],
                                      // Değer değişince çalışacak fonksiyonu belirler
                                      onChanged: (value) =>
                                          // Değişen verileri ekrana bildirir
                                          setState(() => _sort = value!))),
                              // Belirtilen boyutta boşluk veya kutu oluşturur
                              const SizedBox(width: 8),
                              // Simge butonu oluşturur
                              IconButton(
                                  // Butona basılınca çalışacak fonksiyonu belirler
                                  onPressed: state.loading ? null : _reload,
                                  // Butonun açıklama metnini belirler
                                  tooltip: 'Araçları yenile',
                                  // Butonun veya öğenin simgesini belirler
                                  icon: const Icon(Icons.refresh)),
                            ]))),
                  ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 20),
          // Sığmayan öğeleri alt satıra geçirir
          Wrap(spacing: 10, runSpacing: 10, children: [
            // Listedeki öğeleri veya indeksleri sırayla dolaşır
            for (final filter in const [
              // Koşul veya parametre ifadesini devam ettirir
              ('all', 'Tümü'),
              // Koşul veya parametre ifadesini devam ettirir
              ('fleet', 'Filo'),
              // Koşul veya parametre ifadesini devam ettirir
              ('private', 'Bireysel')
            ])
              // Seçilebilir filtre etiketi oluşturur
              ChoiceChip(
                  // Görünen etiketi belirler
                  label: Text(filter.$2),
                  // Seçili olup olmadığını belirler
                  selected: _source == filter.$1,
                  // Seçim değişince çalışacak fonksiyonu belirler
                  onSelected: (_) => setState(() => _source = filter.$1)),
          ]),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Koşul doğruysa bu işlemi çalıştırır
          if (state.loading)
            // Yatay ilerleme çubuğu oluşturur
            const LinearProgressIndicator(semanticsLabel: 'Araçlar yükleniyor')
          // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
          else if (state.error != null)
            // action durum nesnesi oluşturur
            ActionState(
                // Başlığı belirler
                title: 'Bağlantıyı yeniden kuralım.',
                // mesaj bilgisini belirler
                message: state.error!,
                // Butonun veya öğenin simgesini belirler
                icon: Icons.wifi_off_outlined,
                // action bilgisini belirler
                action: _reload,
                // Görünen etiketi belirler
                label: 'Yeniden dene')
          // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
          else if (filtered.isEmpty)
            // action durum nesnesi oluşturur
            ActionState(
                // Başlığı belirler
                title: state.vehicles.isEmpty && _dates == null
                    // Koşul doğruysa bu değeri seçer
                    ? 'İlk yolculuk, ilk araçla başlar.'
                    // Koşul yanlışsa bu değeri seçer
                    : 'Bu seçimde uygun araç yok.',
                // mesaj bilgisini belirler
                message: _dates == null
                    // Koşul doğruysa bu değeri seçer
                    ? 'Kendi araç kayıtlarınızı ekleyin. Yayındaki araçlar bu koleksiyonda görünsün.'
                    // Koşul yanlışsa bu değeri seçer
                    : 'Tarihlerinizi veya araç kaynağını değiştirerek tekrar arayabilirsiniz.',
                // Butonun veya öğenin simgesini belirler
                icon: Icons.directions_car_outlined,
                // action bilgisini belirler
                action: widget.onAddVehicle,
                // Görünen etiketi belirler
                label: 'Araç ekle')
          // Önceki ifadeyi tamamlar
          else
            // araç kataloğu grid nesnesi oluşturur
            CatalogGrid(
                // Araç listesini gönderir
                vehicles: filtered, onOpen: (v) => widget.onOpen(v, _dates)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 36),
          // Ayırıcı çizgi oluşturur
          const Divider(),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 20),
          // Sığmayan öğeleri alt satıra geçirir
          Wrap(
              // Hizalamayı belirler
              alignment: WrapAlignment.spaceBetween,
              // Öğeler arasındaki boşluğu belirler
              spacing: 24,
              // Satırlar arasındaki boşluğu belirler
              runSpacing: 18,
              // İçerideki elemanları listeler
              children: [
                // İlgili metodu çalıştırır
                _note(context, Icons.calendar_month_outlined,
                    // İlgili metin değerini belirler
                    'Tarihinizi seçin', 'Veritabanından güncel müsaitlik.'),
                // İlgili metodu çalıştırır
                _note(
                    // Önceki ifadeyi tamamlar
                    context,
                    // Flutter simgesini belirler
                    Icons.compare_arrows_rounded,
                    // İlgili metin değerini belirler
                    'Seçenekleri karşılaştırın',
                    // İlgili metin değerini belirler
                    'Bireysel ve filo araçları bir arada.'),
                // İlgili metodu çalıştırır
                _note(context, Icons.route_outlined, 'Planınızı yönetin',
                    // İlgili metin değerini belirler
                    'Rezervasyon ve iptal kayıtlarına erişin.'),
              ]),
        ]);
      });
  // note işlemini gerçekleştirir
  Widget _note(
          // Sonraki ifadeyi sonuç olarak döndürür
          BuildContext context, IconData icon, String title, String message) =>
      // Belirtilen boyutta boşluk veya kutu oluşturur
      SizedBox(
          // Genişliği belirler
          width: 290,
          // İçerikte gösterilecek widgetı belirler
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Simgeyi gösterir
            Icon(icon, size: 23, color: Theme.of(context).colorScheme.primary),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 12),
            // Kalan alanı doldurur
            Expanded(
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                  // Metni gösterir
                  Text(title,
                      // Görünüm stilini belirler
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 5),
                  // Metni gösterir
                  Text(message,
                      // Görünüm stilini belirler
                      style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 12,
                          // Rengi belirler
                          color:
                              // Aktif temayı alır
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ])),
          ]));
}

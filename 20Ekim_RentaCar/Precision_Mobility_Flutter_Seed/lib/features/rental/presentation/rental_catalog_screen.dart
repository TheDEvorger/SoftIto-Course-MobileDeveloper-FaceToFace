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
// kiralama actions dosyasını ekler
import 'rental_actions.dart';
// kiralama car kart dosyasını ekler
import 'rental_car_card.dart';
// kiralama giriş alanı dosyasını ekler
import 'rental_hero.dart';
// kiralama araç kataloğu ekran ekranının değişen durumunu yönetir
class RentalCatalogScreen extends StatefulWidget {
  // kiralama araç kataloğu ekran nesnesi oluşturur
  const RentalCatalogScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // olay open bilgisini zorunlu alır
      required this.onOpen,
      // this değerini günceller
      this.favoritesOnly = false});
  // controller bilgisini tutar
  final RentalController controller;
  // function bilgisini tutar
  final void Function(RentalVehicle, DateTimeRange?) onOpen;
  // favoriler only bilgisini tutar
  final bool favoritesOnly;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<RentalCatalogScreen> createState() => _RentalCatalogScreenState();
}
// kiralama araç kataloğu ekran durum ekranının durumunu yöneten sınıf
class _RentalCatalogScreenState extends State<RentalCatalogScreen> {
  // arama metni değerini belirler
  String _query = '', _category = 'Tümü', _sort = 'collection';
  // tarihler bilgisini tutar
  DateTimeRange? _dates;
  // arama değerini belirler
  final _search = TextEditingController();
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _search.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // choose tarihler işlemini asenkron yürütür
  Future<void> _chooseDates() async {
    // tarihler değerini belirler
    final dates = await rentalDates(context, initial: _dates);
    // Widget kaldırılmışsa işlemi durdurur
    if (dates == null || !mounted) return;
    // gün sayısı değerini belirler
    final days = calendarDays(dates.start, dates.end);
    // Koşul doğruysa bu işlemi çalıştırır
    if (days < 1 || days > 7) {
      // Ekranda kısa bilgi mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
          // Alt bilgi mesajı oluşturur
          const SnackBar(content: Text('1–7 günlük bir tarih aralığı seçin.')));
      // Önceki ifadeyi tamamlar
      return;
    }
    // Değişen verileri ekrana bildirir
    setState(() => _dates = dates);
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
        // veri değerini belirler
        final data = state.repository.data;
        // empty favoriler değerini belirler
        final emptyFavorites = widget.favoritesOnly && data.favorites.isEmpty;
        // liste değerini belirler
        final list = state.repository.catalog.where((v) {
          // matches değerini belirler
          final matches = '${v.name} ${v.category} ${v.energy} ${v.city}'
              // Önceki ifade üzerinde ek işlem uygular
              .toLowerCase()
              // Önceki ifade üzerinde ek işlem uygular
              .contains(_query.toLowerCase());
          // Hesaplanan sonucu geri döndürür
          return matches &&
              // Koşul veya parametre ifadesini devam ettirir
              (_category == 'Tümü' || v.category == _category) &&
              // Koşul veya parametre ifadesini devam ettirir
              (widget.favoritesOnly
                  // Koşul doğruysa bu değeri seçer
                  ? emptyFavorites || data.favorites.contains(v.id)
                  // Koşul yanlışsa bu değeri seçer
                  : data.city == 'Tüm şehirler' || v.city == data.city) &&
              // Koşul veya parametre ifadesini devam ettirir
              (_dates == null ||
                  // Önceki ifadeyi tamamlar
                  state.repository.available(v.id, _dates!.start, _dates!.end));
        // Önceki ifadeyi tamamlar
        }).toList();
        // Koşul doğruysa bu işlemi çalıştırır
        if (_sort == 'low') {
          // sort((a, b) değerini günceller
          list.sort((a, b) => a.dailyMinor.compareTo(b.dailyMinor));
        }
        // Koşul doğruysa bu işlemi çalıştırır
        if (_sort == 'high') {
          // sort((a, b) değerini günceller
          list.sort((a, b) => b.dailyMinor.compareTo(a.dailyMinor));
        }
        // Koşul doğruysa bu işlemi çalıştırır
        if (emptyFavorites && list.length > 3) list.removeRange(3, list.length);
        // localizations değerini belirler
        final localizations = MaterialLocalizations.of(context);
        // Hesaplanan sonucu geri döndürür
        return StudioPage(children: [
          // Koşul doğruysa bu işlemi çalıştırır
          if (!widget.favoritesOnly)
            // kiralama giriş alanı nesnesi oluşturur
            const RentalHero()
          // Önceki ifadeyi tamamlar
          else
            // sayfa heading nesnesi oluşturur
            const PageHeading(
                // eyebrow bilgisini belirler
                eyebrow: 'Koleksiyonunuz',
                // Başlığı belirler
                title: 'Gözünüzün kaldığı araçlar.',
                // açıklama bilgisini belirler
                description:
                    // İlgili metin değerini belirler
                    'Kalbine dokunun, favorilerinize ekleyin. Seçtikleriniz burada sizi beklesin.'),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Koşul doğruysa bu işlemi çalıştırır
          if (emptyFavorites) ...[
            // studio panel nesnesi oluşturur
            const StudioPanel(
                // İçerikte gösterilecek widgetı belirler
                child: Text(
                    // İlgili metin değerini belirler
                    'Henüz bir favoriniz yok. Başlamak için koleksiyondan üç seçenek hazırladık.')),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 20),
          ],
          // studio panel nesnesi oluşturur
          StudioPanel(
              // İç boşlukları ayarlar
              padding: 16,
              // İçerikte gösterilecek widgetı belirler
              child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // İçerideki elemanları listeler
                  children: [
                    // Metin giriş alanı oluşturur
                    TextField(
                        // İlgili controllerı bağlar
                        controller: _search,
                        // Değer değişince çalışacak fonksiyonu belirler
                        onChanged: (v) => setState(() => _query = v),
                        // Kutunun görünümünü ayarlar
                        decoration: InputDecoration(
                            // Giriş alanının etiketini belirler
                            labelText: 'Hangi aracı arıyorsunuz?',
                            // Giriş alanındaki ipucu yazısını belirler
                            hintText: 'Marka, model veya kategori',
                            // Metin kutusunun sol simgesini belirler
                            prefixIcon: const Icon(Icons.search),
                            // Metin kutusunun sağ simgesini belirler
                            suffixIcon: _query.isEmpty
                                // Koşul doğruysa bu değeri seçer
                                ? null
                                // Koşul yanlışsa bu değeri seçer
                                : IconButton(
                                    // Butonun açıklama metnini belirler
                                    tooltip: 'Aramayı temizle',
                                    // Butona basılınca çalışacak fonksiyonu belirler
                                    onPressed: () {
                                      // Verileri temizler
                                      _search.clear();
                                      // Değişen verileri ekrana bildirir
                                      setState(() => _query = '');
                                    },
                                    // Butonun veya öğenin simgesini belirler
                                    icon: const Icon(Icons.close)))),
                    // Koşul doğruysa bu işlemi çalıştırır
                    if (!widget.favoritesOnly) ...[
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 12),
                      // Alan genişliğine göre içeriği düzenler
                      LayoutBuilder(builder: (context, c) {
                        // şehir değerini belirler
                        final city = DropdownButtonFormField<String>(
                            // Widget kimliğini belirler
                            key: ValueKey(data.city),
                            // Başlangıç değerini belirler
                            initialValue: data.city,
                            // durum genişletme bilgisini belirler
                            isExpanded: true,
                            // Kutunun görünümünü ayarlar
                            decoration: const InputDecoration(
                                // Giriş alanının etiketini belirler
                                labelText: 'Alış şehri',
                                // Metin kutusunun sol simgesini belirler
                                prefixIcon: Icon(Icons.location_on_outlined)),
                            // Seçenekleri listeler
                            items: [
                              // Listedeki öğeleri veya indeksleri sırayla dolaşır
                              for (final city in [
                                // İlgili metin değerini belirler
                                'Tüm şehirler',
                                // İlgili metin değerini belirler
                                'İstanbul',
                                // İlgili metin değerini belirler
                                'Ankara',
                                // İlgili metin değerini belirler
                                'İzmir'
                              ])
                                // Seçim listesine seçenek ekler
                                DropdownMenuItem(value: city, child: Text(city))
                            ],
                            // Değer değişince çalışacak fonksiyonu belirler
                            onChanged: !state.ready || state.busy
                                // Koşul doğruysa bu değeri seçer
                                ? null
                                // Koşul yanlışsa bu değeri seçer
                                : (v) => rentalAction(
                                    // Önceki ifadeyi tamamlar
                                    context, () => state.preferences(city: v)));
                        // tarih değerini belirler
                        final date = OutlinedButton.icon(
                            // Butona basılınca çalışacak fonksiyonu belirler
                            onPressed: _chooseDates,
                            // Butonun veya öğenin simgesini belirler
                            icon: const Icon(Icons.calendar_month_outlined,
                                // Boyutu belirler
                                size: 18),
                            // Görünen etiketi belirler
                            label: Text(_dates == null
                                // Koşul doğruysa bu değeri seçer
                                ? 'Alış ve dönüş tarihi'
                                // Koşul yanlışsa bu değeri seçer
                                : '${localizations.formatShortDate(_dates!.start)} — ${localizations.formatShortDate(_dates!.end)}'));
                        // Hesaplanan sonucu geri döndürür
                        return c.maxWidth < 650 ||
                                // Ekran ölçülerini alır
                                MediaQuery.textScalerOf(context).scale(1) > 1.3
                            // Koşul doğruysa bu değeri seçer
                            ? Column(
                                // Çapraz eksendeki hizalamayı belirler
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                // İçerideki elemanları listeler
                                children: [
                                    // Önceki ifadeyi tamamlar
                                    city,
                                    // Belirtilen boyutta boşluk veya kutu oluşturur
                                    const SizedBox(height: 12),
                                    // Önceki ifadeyi tamamlar
                                    date
                                  ])
                            // Koşul yanlışsa bu değeri seçer
                            : Row(children: [
                                // Kalan alanı doldurur
                                Expanded(child: city),
                                // Belirtilen boyutta boşluk veya kutu oluşturur
                                const SizedBox(width: 16),
                                // Kalan alanı doldurur
                                Expanded(child: date)
                              ]);
                      }),
                    ],
                    // Değer null değilse koşulu çalıştırır
                    if (_dates != null)
                      // İçeriği hizalar
                      Align(
                          // Hizalamayı belirler
                          alignment: Alignment.centerLeft,
                          // İçerikte gösterilecek widgetı belirler
                          child: TextButton.icon(
                              // Butona basılınca çalışacak fonksiyonu belirler
                              onPressed: () => setState(() => _dates = null),
                              // Butonun veya öğenin simgesini belirler
                              icon: const Icon(Icons.close, size: 16),
                              // Görünen etiketi belirler
                              label: const Text('Tarih filtresini kaldır'))),
                  ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 22),
          // Sayfanın kaydırılmasını sağlar
          SingleChildScrollView(
              // scroll direction bilgisini belirler
              scrollDirection: Axis.horizontal,
              // İçerikte gösterilecek widgetı belirler
              child: Row(children: [
                // Listedeki öğeleri veya indeksleri sırayla dolaşır
                for (final category in [
                  // İlgili metin değerini belirler
                  'Tümü',
                  // İlgili metin değerini belirler
                  'Ekonomik',
                  // İlgili metin değerini belirler
                  'Konfor',
                  // İlgili metin değerini belirler
                  'SUV',
                  // İlgili metin değerini belirler
                  'Elektrikli',
                  // İlgili metin değerini belirler
                  'Premium'
                ])
                  // İçerik etrafına boşluk bırakır
                  Padding(
                      // İç boşlukları ayarlar
                      padding: const EdgeInsets.only(right: 8),
                      // İçerikte gösterilecek widgetı belirler
                      child: ChoiceChip(
                          // Görünen etiketi belirler
                          label: Text(category),
                          // Seçili olup olmadığını belirler
                          selected: _category == category,
                          // Seçim değişince çalışacak fonksiyonu belirler
                          onSelected: (_) =>
                              // Değişen verileri ekrana bildirir
                              setState(() => _category = category))),
              ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Alan genişliğine göre içeriği düzenler
          LayoutBuilder(
              // İçeriği oluşturan fonksiyonu belirler
              builder: (context, c) => Wrap(
                      // Hizalamayı belirler
                      alignment: WrapAlignment.spaceBetween,
                      // Öğeler arasındaki boşluğu belirler
                      spacing: 16,
                      // Satırlar arasındaki boşluğu belirler
                      runSpacing: 12,
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // İçerideki elemanları listeler
                      children: [
                        // Metni gösterir
                        Text(
                            // İlgili metin değerini belirler
                            '${list.length} araç${emptyFavorites ? ' önerisi' : ''}',
                            // Görünüm stilini belirler
                            style: Theme.of(context).textTheme.titleLarge),
                        // Belirtilen boyutta boşluk veya kutu oluşturur
                        SizedBox(
                            // Genişliği belirler
                            width: c.maxWidth.clamp(0, 230),
                            // İçerikte gösterilecek widgetı belirler
                            child: DropdownButtonFormField<String>(
                                // Başlangıç değerini belirler
                                initialValue: _sort,
                                // durum genişletme bilgisini belirler
                                isExpanded: true,
                                // Kutunun görünümünü ayarlar
                                decoration: const InputDecoration(
                                    // Giriş alanının etiketini belirler
                                    labelText: 'Sıralama'),
                                // Seçenekleri listeler
                                items: const [
                                  // Seçim listesine seçenek ekler
                                  DropdownMenuItem(
                                      // Kullanılacak değeri belirler
                                      value: 'collection',
                                      // İçerikte gösterilecek widgetı belirler
                                      child: Text('Koleksiyon sırası')),
                                  // Seçim listesine seçenek ekler
                                  DropdownMenuItem(
                                      // Kullanılacak değeri belirler
                                      value: 'low',
                                      // İçerikte gösterilecek widgetı belirler
                                      child: Text('Fiyat: artan')),
                                  // Seçim listesine seçenek ekler
                                  DropdownMenuItem(
                                      // Kullanılacak değeri belirler
                                      value: 'high',
                                      // İçerikte gösterilecek widgetı belirler
                                      child: Text('Fiyat: azalan'))
                                ],
                                // Değer değişince çalışacak fonksiyonu belirler
                                onChanged: (v) => setState(() => _sort = v!))),
                      ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 20),
          // Liste veya metin boşsa koşulu çalıştırır
          if (list.isEmpty)
            // studio panel nesnesi oluşturur
            StudioPanel(
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                  // Metni gösterir
                  Text('Bu seçimle eşleşen araç yok.',
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.titleLarge),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 12),
                  // Metni gösterir
                  const Text('Aramayı, kategoriyi veya tarihleri değiştirin.'),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 16),
                  // Çerçeveli buton oluşturur
                  OutlinedButton(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: () {
                        // Verileri temizler
                        _search.clear();
                        // Değişen verileri ekrana bildirir
                        setState(() {
                          // arama metni değerini günceller
                          _query = '';
                          // kategori değerini günceller
                          _category = 'Tümü';
                          // tarihler değerini günceller
                          _dates = null;
                        });
                        // Koşul doğruysa bu işlemi çalıştırır
                        if (!widget.favoritesOnly) {
                          // İlgili fonksiyonu çalıştırır
                          rentalAction(context,
                              // Bu eleman için oluşturulacak değeri belirler
                              () => state.preferences(city: 'Tüm şehirler'));
                        }
                      },
                      // İçerikte gösterilecek widgetı belirler
                      child: const Text('Filtreleri temizle')),
                ]))
          // Önceki ifadeyi tamamlar
          else
            // kiralama car grid nesnesi oluşturur
            RentalCarGrid(
                // Araç listesini gönderir
                vehicles: list,
                // favoriler bilgisini belirler
                favorites: data.favorites,
                // open için callback belirler
                onOpen: (v) => widget.onOpen(v, _dates),
                // favori için callback belirler
                onFavorite: !state.ready || state.busy
                    // Koşul doğruysa bu değeri seçer
                    ? null
                    // Koşul yanlışsa bu değeri seçer
                    : (v) => rentalAction(context, () => state.favorite(v.id))),
          // İçerik etrafına boşluk bırakır
          const Padding(
              // İç boşlukları ayarlar
              padding: EdgeInsets.symmetric(vertical: 12),
              // İçerikte gösterilecek widgetı belirler
              child: Text(
                  // İlgili metin değerini belirler
                  'Hazır koleksiyon · Araç bilgileri ve fiyatlar örnektir. Planlar bu cihazda saklanır.',
                  // Görünüm stilini belirler
                  style: TextStyle(fontSize: 11))),
        ]);
      });
}

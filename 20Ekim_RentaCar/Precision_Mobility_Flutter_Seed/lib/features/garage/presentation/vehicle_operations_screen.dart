// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// araç işlemler controller dosyasını ekler
import '../application/vehicle_operations_controller.dart';
// araç işlemler ekran ekranının değişen durumunu yönetir
class VehicleOperationsScreen extends StatefulWidget {
  // araç işlemler ekran nesnesi oluşturur
  const VehicleOperationsScreen(
      // Veri alanlarını tanımlar
      {super.key, required this.api, required this.vehicle});
  // API bilgisini tutar
  final ApiClient api;
  // araç bilgisini tutar
  final Vehicle vehicle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<VehicleOperationsScreen> createState() =>
      // İlgili metodu çalıştırır
      _VehicleOperationsScreenState();
}
// araç işlemler ekran durum ekranının durumunu yöneten sınıf
class _VehicleOperationsScreenState extends State<VehicleOperationsScreen> {
  // durum değerini tanımlar
  late final _state = VehicleOperationsController(widget.api, widget.vehicle)
    // Aynı nesne üzerinde ek işlem yapar
    ..load();
  // reason değerini belirler
  String _reason = 'Planlı bakım';
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // İlgili işlemi çalıştırır
    _state;
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _state.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // block işlemini asenkron yürütür
  Future<void> _block() async {
    // today değerini belirler
    final today = DateUtils.dateOnly(DateTime.now());
    // range değerini belirler
    final range = await showDateRangePicker(
        // context bilgisini belirler
        context: context,
        // Seçilebilecek ilk tarihi belirler
        firstDate: today,
        // Seçilebilecek son tarihi belirler
        lastDate: today.add(const Duration(days: 365)),
        // help metin bilgisini belirler
        helpText: 'Kapatılacak tarihler',
        // kaydetme metin bilgisini belirler
        saveText: 'Seç');
    // Widget kaldırılmışsa işlemi durdurur
    if (range == null || !mounted) return;
    // Asenkron işlemin tamamlanmasını bekler
    await _state.block(range.start, range.end, _reason);
  }
  // tarihler işlemini gerçekleştirir
  String _dates(Map<String, dynamic> item) {
    // tarihler değerini belirler
    final dates = MaterialLocalizations.of(context);
    // Tarih bilgisini döndürür
    return '${dates.formatShortDate(DateTime.parse(item['starts_on'] as String))} — '
        // İlgili metin değerini belirler
        '${dates.formatShortDate(DateTime.parse(item['ends_on'] as String))}';
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
      // listenable bilgisini belirler
      listenable: _state,
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, _) => PopScope(
          // izin pop bilgisini belirler
          canPop: !_state.busy,
          // İçerikte gösterilecek widgetı belirler
          child: Scaffold(
              // Sayfanın üst menüsünü oluşturur
              appBar: AppBar(title: const Text('Takvim ve yayın')),
              // Sayfanın ana içeriğini oluşturur
              body: StudioPage(width: 1000, children: [
                // sayfa heading nesnesi oluşturur
                PageHeading(
                    // eyebrow bilgisini belirler
                    eyebrow: 'Envanter / Müsaitlik',
                    // Başlığı belirler
                    title: widget.vehicle.name,
                    // açıklama bilgisini belirler
                    description:
                        // İlgili metin değerini belirler
                        'Yayın durumunu ve kiralamaya kapalı günleri yönetin. '
                        // İlgili metin değerini belirler
                        'Tarih aralıkları dönüş gününü içermez; her kayıt 1–7 gün olabilir.'),
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
                      // İlgili widget veya fonksiyonun parametrelerini başlatır
                      SwitchListTile.adaptive(
                          // content iç boşluk bilgisini belirler
                          contentPadding: EdgeInsets.zero,
                          // Başlığı belirler
                          title: const Text('Keşfet koleksiyonunda yayınla'),
                          // Alt başlığı belirler
                          subtitle: Text(_state.published
                              // Koşul doğruysa bu değeri seçer
                              ? 'Yayın açık. Bakımdaki araçlar keşfette gösterilmez.'
                              // Koşul yanlışsa bu değeri seçer
                              : 'Yayın kapalı. Araç ve rezervasyon geçmişi korunuyor.'),
                          // Kullanılacak değeri belirler
                          value: _state.published,
                          // Değer değişince çalışacak fonksiyonu belirler
                          onChanged: _state.busy ? null : _state.publish),
                      // Ayırıcı çizgi oluşturur
                      const Divider(height: 32),
                      // Metni gösterir
                      Text('Yeni kapalı tarih',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 12),
                      // İfadeye karşılaştırma koşulu ekler
                      DropdownButtonFormField<String>(
                          // Başlangıç değerini belirler
                          initialValue: _reason,
                          // durum genişletme bilgisini belirler
                          isExpanded: true,
                          // Kutunun görünümünü ayarlar
                          decoration: const InputDecoration(
                              // Giriş alanının etiketini belirler
                              labelText: 'Kapatma nedeni'),
                          // Seçenekleri listeler
                          items: [
                            // Listedeki öğeleri veya indeksleri sırayla dolaşır
                            for (final reason in [
                              // İlgili metin değerini belirler
                              'Planlı bakım',
                              // İlgili metin değerini belirler
                              'Kişisel kullanım',
                              // İlgili metin değerini belirler
                              'Operasyon hazırlığı'
                            ])
                              // Seçim listesine seçenek ekler
                              DropdownMenuItem(
                                  // Kullanılacak değeri belirler
                                  value: reason, child: Text(reason))
                          ],
                          // Değer değişince çalışacak fonksiyonu belirler
                          onChanged: _state.busy
                              // Koşul doğruysa bu değeri seçer
                              ? null
                              // Koşul yanlışsa bu değeri seçer
                              : (v) => setState(() => _reason = v!)),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 14),
                      // Dolgulu buton oluşturur
                      FilledButton.icon(
                          // Butona basılınca çalışacak fonksiyonu belirler
                          onPressed: _state.busy ? null : _block,
                          // Butonun veya öğenin simgesini belirler
                          icon: const Icon(Icons.event_busy_outlined),
                          // Görünen etiketi belirler
                          label: const Text('Tarih aralığını kapat')),
                      // Koşul doğruysa bu işlemi çalıştırır
                      if (_state.busy)
                        // İçerik etrafına boşluk bırakır
                        const Padding(
                            // İç boşlukları ayarlar
                            padding: EdgeInsets.only(top: 16),
                            // İçerikte gösterilecek widgetı belirler
                            child: LinearProgressIndicator()),
                      // Değer null değilse koşulu çalıştırır
                      if (_state.error != null)
                        // İçerik etrafına boşluk bırakır
                        Padding(
                            // İç boşlukları ayarlar
                            padding: const EdgeInsets.only(top: 16),
                            // İçerikte gösterilecek widgetı belirler
                            child: Semantics(
                                // live region bilgisini belirler
                                liveRegion: true,
                                // İçerikte gösterilecek widgetı belirler
                                child: Column(
                                    // Çapraz eksendeki hizalamayı belirler
                                    crossAxisAlignment:
                                        // Elemanların hizalanma biçimini belirler
                                        CrossAxisAlignment.start,
                                    // İçerideki elemanları listeler
                                    children: [
                                      // Metni gösterir
                                      Text(_state.error!,
                                          // Görünüm stilini belirler
                                          style: TextStyle(
                                              // Rengi belirler
                                              color: Theme.of(context)
                                                  // Önceki ifade üzerinde ek işlem uygular
                                                  .colorScheme
                                                  // Önceki ifade üzerinde ek işlem uygular
                                                  .error)),
                                      // Metin butonu oluşturur
                                      TextButton(
                                          // Butona basılınca çalışacak fonksiyonu belirler
                                          onPressed:
                                              // İlgili işlemi çalıştırır
                                              _state.busy ? null : _state.load,
                                          // İçerikte gösterilecek widgetı belirler
                                          child: const Text('Takvimi yenile'))
                                    ]))),
                    ])),
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
                      Text('Müsaitlik takvimi',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 8),
                      // Metni gösterir
                      const Text(
                          // İlgili metin değerini belirler
                          'Rezervasyonlu veya kapalı günlerde yeni kayıt alınmaz.'),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 20),
                      // Liste veya metin boşsa koşulu çalıştırır
                      if (_state.blocks.isEmpty &&
                          // İlgili işlemi çalıştırır
                          _state.reservations.isEmpty &&
                          // Önceki ifadeyi tamamlar
                          !_state.busy &&
                          // durum değerini günceller
                          _state.error == null)
                        // Liste satırı oluşturur
                        const ListTile(
                            // content iç boşluk bilgisini belirler
                            contentPadding: EdgeInsets.zero,
                            // Sol taraftaki elemanı belirler
                            leading: Icon(Icons.event_available_outlined),
                            // Başlığı belirler
                            title: Text('Takvim açık'),
                            // Alt başlığı belirler
                            subtitle: Text(
                                // İlgili metin değerini belirler
                                'Kayıtlı rezervasyon veya kapalı tarih yok.')),
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (final booking in _state.reservations)
                        // Liste satırı oluşturur
                        ListTile(
                            // content iç boşluk bilgisini belirler
                            contentPadding: EdgeInsets.zero,
                            // Sol taraftaki elemanı belirler
                            leading: const Icon(Icons.event_note_outlined),
                            // Başlığı belirler
                            title: Text(_dates(booking)),
                            // Alt başlığı belirler
                            subtitle: const Text('Rezerve edildi')),
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (final block in _state.blocks)
                        // İçerik etrafına boşluk bırakır
                        Padding(
                            // İç boşlukları ayarlar
                            padding: const EdgeInsets.only(bottom: 16),
                            // İçerikte gösterilecek widgetı belirler
                            child: Column(
                                // Çapraz eksendeki hizalamayı belirler
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // İçerideki elemanları listeler
                                children: [
                                  // Liste satırı oluşturur
                                  ListTile(
                                      // content iç boşluk bilgisini belirler
                                      contentPadding: EdgeInsets.zero,
                                      // Sol taraftaki elemanı belirler
                                      leading:
                                          // Simgeyi gösterir
                                          const Icon(Icons.event_busy_outlined),
                                      // Başlığı belirler
                                      title: Text(_dates(block)),
                                      // Alt başlığı belirler
                                      subtitle:
                                          // Metni gösterir
                                          Text(block['reason'] as String)),
                                  // Çerçeveli buton oluşturur
                                  OutlinedButton.icon(
                                      // Butona basılınca çalışacak fonksiyonu belirler
                                      onPressed: _state.busy
                                          // Koşul doğruysa bu değeri seçer
                                          ? null
                                          // Koşul yanlışsa bu değeri seçer
                                          : () => _state
                                              // Önceki ifade üzerinde ek işlem uygular
                                              .release(block['id'] as String),
                                      // Butonun veya öğenin simgesini belirler
                                      icon: const Icon(Icons.lock_open_outlined,
                                          // Boyutu belirler
                                          size: 16),
                                      // Görünen etiketi belirler
                                      label:
                                          // Metni gösterir
                                          const Text('Tarihleri yeniden aç')),
                                ])),
                    ])),
              ]))));
}

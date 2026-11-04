// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç kataloğu controller dosyasını ekler
import '../../discovery/application/catalog_controller.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// araç editor ekran ekranının değişen durumunu yönetir
class VehicleEditorScreen extends StatefulWidget {
  // araç editor ekran nesnesi oluşturur
  const VehicleEditorScreen(
      // Veri alanlarını tanımlar
      {super.key, required this.controller, this.vehicle});
  // controller bilgisini tutar
  final CatalogController controller;
  // araç bilgisini tutar
  final Vehicle? vehicle;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<VehicleEditorScreen> createState() => _VehicleEditorScreenState();
}
// araç editor ekran durum ekranının durumunu yöneten sınıf
class _VehicleEditorScreenState extends State<VehicleEditorScreen> {
  // form değerini belirler
  final _form = GlobalKey<FormState>();
  // fields bilgisini tutar
  late final Map<String, TextEditingController> _fields;
  // ownership bilgisini tutar
  late String _ownership, _status;
  // koltuk sayısı bilgisini tutar
  late int _seats;
  // saving değerini belirler
  bool _saving = false;
  // hata bilgisini tutar
  String? _error;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // v değerini belirler
    final v = widget.vehicle;
    // fields değerini günceller
    _fields = {
      // İlgili metin değerini belirler
      'name': TextEditingController(text: v?.name),
      // İlgili metin değerini belirler
      'category': TextEditingController(text: v?.category),
      // İlgili metin değerini belirler
      'energy': TextEditingController(text: v?.energy),
      // İlgili metin değerini belirler
      'description': TextEditingController(text: v?.description),
      // İlgili metin değerini belirler
      'photo_url': TextEditingController(text: v?.photoUrl),
      // İlgili metin değerini belirler
      'rate': TextEditingController(
          // metin bilgisini belirler
          text: v == null
              // Koşul doğruysa bu değeri seçer
              ? ''
              // Koşul yanlışsa bu değeri seçer
              : '${v.rateMinor ~/ 100}.${(v.rateMinor % 100).toString().padLeft(2, '0')}'),
    };
    // ownership değerini günceller
    _ownership = v?.ownership ?? 'private';
    // durum değerini günceller
    _status = v?.status ?? 'active';
    // koltuk sayısı değerini günceller
    _seats = v?.seats ?? 5;
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Listedeki öğeleri veya indeksleri sırayla dolaşır
    for (final field in _fields.values) {
      // Kullanılan controller veya kaynağı temizler
      field.dispose();
    }
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // rate işlemini gerçekleştirir
  int? _rate(String raw) {
    // değer değerini belirler
    final value = raw.trim().replaceAll(',', '.');
    // Koşul doğruysa bu işlemi çalıştırır
    if (!RegExp(r'^\d{1,7}(\.\d{1,2})?$').hasMatch(value)) return null;
    // parts değerini belirler
    final parts = value.split('.');
    // sonuç değerini belirler
    final result = int.parse(parts.first) * 100 +
        // Koşul veya parametre ifadesini devam ettirir
        (parts.length == 1 ? 0 : int.parse(parts.last.padRight(2, '0')));
    // Hesaplanan sonucu geri döndürür
    return result > 0 && result <= 100000000 ? result : null;
  }
  // kaydetme işlemini asenkron yürütür
  Future<void> _save() async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!_form.currentState!.validate()) return;
    // Değişen verileri ekrana bildirir
    setState(() {
      // saving değerini günceller
      _saving = true;
      // hata değerini günceller
      _error = null;
    });
    // Hata oluşabilecek işlemleri dener
    try {
      // Verilerin kaydedilmesini bekler
      await widget.controller.save({
        // Listedeki öğeleri veya indeksleri sırayla dolaşır
        for (final key in [
          // İlgili metin değerini belirler
          'name',
          // İlgili metin değerini belirler
          'category',
          // İlgili metin değerini belirler
          'energy',
          // İlgili metin değerini belirler
          'description',
          // İlgili metin değerini belirler
          'photo_url'
        ])
          // Widget kimliğini belirler
          key: _fields[key]!.text.trim(),
        // İlgili metin değerini belirler
        'rate_minor': _rate(_fields['rate']!.text),
        // İlgili metin değerini belirler
        'seats': _seats,
        // İlgili metin değerini belirler
        'ownership': _ownership,
        // İlgili metin değerini belirler
        'status': _status,
      // Önceki ifadeyi tamamlar
      }, id: widget.vehicle?.id);
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) Navigator.of(context).pop(true);
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) {
        // Değişen verileri ekrana bildirir
        setState(() => _error =
            // Gelen değerin tipini kontrol eder
            error is ApiException ? error.message : 'Araç kaydedilemedi.');
      }
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _saving = false);
    }
  }
  // metin işlemini gerçekleştirir
  Widget _text(String key, String label, {int max = 120, int lines = 1}) =>
      // Form giriş alanı oluşturur
      TextFormField(
          // İlgili controllerı bağlar
          controller: _fields[key],
          // Etkinlik durumunu belirler
          enabled: !_saving,
          // En fazla karakter sayısını belirler
          maxLength: max,
          // En fazla satır sayısını belirler
          maxLines: lines,
          // Kutunun görünümünü ayarlar
          decoration: InputDecoration(labelText: label),
          // Girilen değeri kontrol eden fonksiyonu belirler
          validator: (v) =>
              // v değerini günceller
              v == null || v.trim().isEmpty ? '$label gerekli.' : null);
  // pair işlemini gerçekleştirir
  Widget _pair(Widget a, Widget b) => LayoutBuilder(
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, constraints) => constraints.maxWidth > 650 &&
              // Ekran ölçülerini alır
              MediaQuery.textScalerOf(context).scale(1) < 1.4
          // Koşul doğruysa bu değeri seçer
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Kalan alanı doldurur
              Expanded(child: a),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(width: 20),
              // Kalan alanı doldurur
              Expanded(child: b)
            ])
          // Koşul yanlışsa bu değeri seçer
          : Column(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // İçerideki elemanları listeler
              children: [a, const SizedBox(height: 16), b]));
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => PopScope(
      // izin pop bilgisini belirler
      canPop: !_saving,
      // İçerikte gösterilecek widgetı belirler
      child: Scaffold(
          // Sayfanın üst menüsünü oluşturur
          appBar: AppBar(
              // Başlığı belirler
              title:
                  // Metni gösterir
                  Text(widget.vehicle == null ? 'Yeni araç' : 'Araç düzenle')),
          // Alt gezinme menüsünü oluşturur
          bottomNavigationBar: SafeArea(
              // top bilgisini belirler
              top: false,
              // İçerikte gösterilecek widgetı belirler
              child: Padding(
                  // İç boşlukları ayarlar
                  padding: const EdgeInsets.all(20),
                  // İçerikte gösterilecek widgetı belirler
                  child: Center(
                      // Yükseklik oranını belirler
                      heightFactor: 1,
                      // İçerikte gösterilecek widgetı belirler
                      child: SizedBox(
                          // Genişliği belirler
                          width: 600,
                          // İçerikte gösterilecek widgetı belirler
                          child: FilledButton.icon(
                              // Butona basılınca çalışacak fonksiyonu belirler
                              onPressed: _saving ? null : _save,
                              // Butonun veya öğenin simgesini belirler
                              icon: const Icon(Icons.check, size: 18),
                              // Görünen etiketi belirler
                              label: Text(_saving
                                  // Koşul doğruysa bu değeri seçer
                                  ? 'Kaydediliyor…'
                                  // Koşul yanlışsa bu değeri seçer
                                  : 'Aracı kaydet')))))),
          // Sayfanın ana içeriğini oluşturur
          body: Form(
              // Widget kimliğini belirler
              key: _form,
              // İçerikte gösterilecek widgetı belirler
              child: StudioPage(width: 1060, children: [
                // sayfa heading nesnesi oluşturur
                PageHeading(
                    // eyebrow bilgisini belirler
                    eyebrow: 'Koleksiyon / Araç bilgileri',
                    // Başlığı belirler
                    title: widget.vehicle == null
                        // Koşul doğruysa bu değeri seçer
                        ? 'Aracınızı tanıyalım.'
                        // Koşul yanlışsa bu değeri seçer
                        : 'Her detay yerli yerinde.',
                    // açıklama bilgisini belirler
                    description:
                        // İlgili metin değerini belirler
                        'Bilgileri kaydedin. Yayındaki araçlar keşif koleksiyonuna eklensin.'),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 30),
                // Değer null değilse koşulu çalıştırır
                if (_error != null)
                  // İçerik etrafına boşluk bırakır
                  Padding(
                      // İç boşlukları ayarlar
                      padding: const EdgeInsets.only(bottom: 20),
                      // İçerikte gösterilecek widgetı belirler
                      child: Semantics(
                          // live region bilgisini belirler
                          liveRegion: true,
                          // İçerikte gösterilecek widgetı belirler
                          child: Text(_error!,
                              // Görünüm stilini belirler
                              style: TextStyle(
                                  // Rengi belirler
                                  color:
                                      // Aktif temayı alır
                                      Theme.of(context).colorScheme.error)))),
                // studio panel nesnesi oluşturur
                StudioPanel(
                    // İçerikte gösterilecek widgetı belirler
                    child: Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // İçerideki elemanları listeler
                        children: [
                      // Metni gösterir
                      Text('01 / Aracın kimliği',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 24),
                      // İlgili metodu çalıştırır
                      _text('name', 'Araç adı'),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 16),
                      // İlgili metodu çalıştırır
                      _pair(_text('category', 'Kategori'),
                          // İlgili metodu çalıştırır
                          _text('energy', 'Enerji türü')),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 16),
                      // İlgili metodu çalıştırır
                      _text('description', 'Açıklama', max: 1200, lines: 3),
                    ])),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 20),
                // studio panel nesnesi oluşturur
                StudioPanel(
                    // İçerikte gösterilecek widgetı belirler
                    child: Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // İçerideki elemanları listeler
                        children: [
                      // Metni gösterir
                      Text('02 / Kiralama ve yayın',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 24),
                      // İlgili metodu çalıştırır
                      _pair(
                          // Form giriş alanı oluşturur
                          TextFormField(
                              // İlgili controllerı bağlar
                              controller: _fields['rate'],
                              // Etkinlik durumunu belirler
                              enabled: !_saving,
                              // Klavye türünü belirler
                              keyboardType:
                                  // metin input type nesnesi oluşturur
                                  const TextInputType.numberWithOptions(
                                      // decimal bilgisini belirler
                                      decimal: true),
                              // Kutunun görünümünü ayarlar
                              decoration: const InputDecoration(
                                  // Giriş alanının etiketini belirler
                                  labelText: 'Günlük ücret (TRY)',
                                  // Metin kutusunun sol simgesini belirler
                                  prefixIcon: Icon(Icons.payments_outlined)),
                              // Girilen değeri kontrol eden fonksiyonu belirler
                              validator: (v) => _rate(v ?? '') == null
                                  // Koşul doğruysa bu değeri seçer
                                  ? 'Pozitif bir ücret girin; en fazla iki ondalık basamak.'
                                  // Koşul yanlışsa bu değeri seçer
                                  : null),
                          // İfadeye karşılaştırma koşulu ekler
                          DropdownButtonFormField<int>(
                              // Başlangıç değerini belirler
                              initialValue: _seats,
                              // Kutunun görünümünü ayarlar
                              decoration: const InputDecoration(
                                  // Giriş alanının etiketini belirler
                                  labelText: 'Koltuk sayısı'),
                              // Seçenekleri listeler
                              items: List.generate(
                                  // Önceki ifadeyi tamamlar
                                  9,
                                  // Bu eleman için oluşturulacak değeri belirler
                                  (i) => DropdownMenuItem(
                                      // Kullanılacak değeri belirler
                                      value: i + 1,
                                      // İçerikte gösterilecek widgetı belirler
                                      child: Text('${i + 1} koltuk'))),
                              // Değer değişince çalışacak fonksiyonu belirler
                              onChanged: _saving
                                  // Koşul doğruysa bu değeri seçer
                                  ? null
                                  // Koşul yanlışsa bu değeri seçer
                                  : (v) => setState(() => _seats = v!))),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 20),
                      // İlgili metodu çalıştırır
                      _pair(
                          // İfadeye karşılaştırma koşulu ekler
                          DropdownButtonFormField<String>(
                              // Başlangıç değerini belirler
                              initialValue: _ownership,
                              // Kutunun görünümünü ayarlar
                              decoration: const InputDecoration(
                                  // Giriş alanının etiketini belirler
                                  labelText: 'Araç kaynağı'),
                              // Seçenekleri listeler
                              items: const [
                                // Seçim listesine seçenek ekler
                                DropdownMenuItem(
                                    // Kullanılacak değeri belirler
                                    value: 'private', child: Text('Bireysel')),
                                // Seçim listesine seçenek ekler
                                DropdownMenuItem(
                                    // Kullanılacak değeri belirler
                                    value: 'fleet', child: Text('Filo'))
                              ],
                              // Değer değişince çalışacak fonksiyonu belirler
                              onChanged: _saving
                                  // Koşul doğruysa bu değeri seçer
                                  ? null
                                  // Koşul yanlışsa bu değeri seçer
                                  : (v) => setState(() => _ownership = v!)),
                          // İfadeye karşılaştırma koşulu ekler
                          DropdownButtonFormField<String>(
                              // Başlangıç değerini belirler
                              initialValue: _status,
                              // Kutunun görünümünü ayarlar
                              decoration: const InputDecoration(
                                  // Giriş alanının etiketini belirler
                                  labelText: 'Yayın durumu'),
                              // Seçenekleri listeler
                              items: const [
                                // Seçim listesine seçenek ekler
                                DropdownMenuItem(
                                    // Kullanılacak değeri belirler
                                    value: 'active', child: Text('Yayında')),
                                // Seçim listesine seçenek ekler
                                DropdownMenuItem(
                                    // Kullanılacak değeri belirler
                                    value: 'maintenance',
                                    // İçerikte gösterilecek widgetı belirler
                                    child: Text('Bakımda'))
                              ],
                              // Değer değişince çalışacak fonksiyonu belirler
                              onChanged: _saving
                                  // Koşul doğruysa bu değeri seçer
                                  ? null
                                  // Koşul yanlışsa bu değeri seçer
                                  : (v) => setState(() => _status = v!))),
                    ])),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 20),
                // studio panel nesnesi oluşturur
                StudioPanel(
                    // İçerikte gösterilecek widgetı belirler
                    child: Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // İçerideki elemanları listeler
                        children: [
                      // Metni gösterir
                      Text('03 / Aracınızın fotoğrafı',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 10),
                      // Metni gösterir
                      const Text(
                          // İlgili metin değerini belirler
                          'Varsa aracınıza ait HTTPS fotoğraf adresini ekleyin. Fotoğraf olmadan da kaydedebilirsiniz.'),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 20),
                      // Form giriş alanı oluşturur
                      TextFormField(
                          // İlgili controllerı bağlar
                          controller: _fields['photo_url'],
                          // Etkinlik durumunu belirler
                          enabled: !_saving,
                          // En fazla karakter sayısını belirler
                          maxLength: 2048,
                          // Klavye türünü belirler
                          keyboardType: TextInputType.url,
                          // Kutunun görünümünü ayarlar
                          decoration: const InputDecoration(
                              // Giriş alanının etiketini belirler
                              labelText: 'Fotoğraf adresi',
                              // Metin kutusunun sol simgesini belirler
                              prefixIcon: Icon(Icons.image_outlined)),
                          // Girilen değeri kontrol eden fonksiyonu belirler
                          validator: (v) {
                            // Liste veya metin boşsa koşulu çalıştırır
                            if (v == null || v.trim().isEmpty) return null;
                            // url değerini belirler
                            final url = Uri.tryParse(v.trim());
                            // url değerini belirler
                            return url == null ||
                                    // İfadeye karşılaştırma koşulu ekler
                                    url.scheme != 'https' ||
                                    // Önceki ifadeyi tamamlar
                                    url.host.isEmpty ||
                                    // Önceki ifadeyi tamamlar
                                    url.userInfo.isNotEmpty
                                // Koşul doğruysa bu değeri seçer
                                ? 'Geçerli bir HTTPS adresi girin.'
                                // Koşul yanlışsa bu değeri seçer
                                : null;
                          }),
                    ])),
              ]))));
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// örnek teslim dosyasını ekler
import '../domain/demo_handover.dart';
/// Araç teslim alma (Handover) simülasyon ekranı.
/// Ön koşulların işaretlenmesi, 20 açılı araç incelemesinin açılması,
/// dijital kilit simülasyonu ve karşılıklı kabul onayını yönetir.
// teslim örnek ekran ekranının değişen durumunu yönetir
class HandoverDemoScreen extends StatefulWidget {
  // teslim örnek ekran nesnesi oluşturur
  const HandoverDemoScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // rezervasyon ID bilgisini zorunlu alır
      required this.bookingId,
      // durum rezervasyon confirmed bilgisini zorunlu alır
      required this.isBookingConfirmed,
      // open kontrol parametresini alır
      this.openInspection});
  /// Teslim alınacak rezervasyon kimliği
  // rezervasyon ID bilgisini tutar
  final String bookingId;
  /// Rezervasyonun hala onaylı olup olmadığını kontrol eden fonksiyon
  // function bilgisini tutar
  final bool Function() isBookingConfirmed;
  /// 20 açılı inceleme ekranını açan fonksiyon
  // function bilgisini tutar
  final Future<bool> Function(BuildContext)? openInspection;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<HandoverDemoScreen> createState() => _HandoverDemoScreenState();
}
// teslim örnek ekran durum ekranının durumunu yöneten sınıf
class _HandoverDemoScreenState extends State<HandoverDemoScreen> {
  // Aktif teslim oturumu modeli
  // oturum değerini belirler
  DemoHandover _session = DemoHandover(HandoverMode.physical);
  // Ön kontrol koşul bayrakları
  // window değerini belirler
  bool _window = false, _driver = false, _ready = false, _compatible = false;
  // Tamamlama gereksinimleri bayrakları
  // kontrol değerini belirler
  bool _inspection = false,
      // readings değerini günceller
      _readings = false,
      // parties değerini günceller
      _parties = false,
      // accept değerini günceller
      _accept = false;
  // Durum ve geri bildirim mesajı
  // mesaj değerini belirler
  String _message = 'Ön koşulları temsili olarak işaretleyin.';
  // run işlemini gerçekleştirir
  void _run(VoidCallback action, String success) {
    // Hata oluşabilecek işlemleri dener
    try {
      // İlgili fonksiyonu çalıştırır
      action();
      // Değişen verileri ekrana bildirir
      setState(() => _message = success);
    // İşlem hata verirse çalışır
    } on StateError catch (e) {
      // Değişen verileri ekrana bildirir
      setState(() => _message = e.message);
    }
  }
  // check işlemini gerçekleştirir
  Widget _check(String label, bool value, ValueChanged<bool> update) =>
      // switch liste tile nesnesi oluşturur
      SwitchListTile(
          // Başlığı belirler
          title: Text(label),
          // Kullanılacak değeri belirler
          value: value,
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (next) => setState(() {
                // İlgili fonksiyonu çalıştırır
                update(next);
                // İlgili işlemi çalıştırır
                _session.invalidate();
                // mesaj değerini günceller
                _message = 'Koşul değişti; ön kontrolü yeniden çalıştırın.';
              }));
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Scaffold(
        // Sayfanın üst menüsünü oluşturur
        appBar: AppBar(title: const Text('Teslim simülasyonu • DEMO')),
        // Sayfanın ana içeriğini oluşturur
        body: ListView(padding: const EdgeInsets.all(20), children: [
          // Metni gösterir
          Text('Örnek rezervasyon: ${widget.bookingId}'),
          // Metni gösterir
          const Text('Gerçek anahtar, kilit komutu veya sürüş başlatma yok. '
              // İlgili metin değerini belirler
              'Tüm onaylar ve koşullar simülasyondur.'),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // İfadeye karşılaştırma koşulu ekler
          DropdownButtonFormField<HandoverMode>(
            // Başlangıç değerini belirler
            initialValue: _session.mode,
            // Kutunun görünümünü ayarlar
            decoration:
                // Giriş alanının görünümünü belirler
                const InputDecoration(labelText: 'Örnek teslim yöntemi'),
            // Seçenekleri listeler
            items: const [
              // Seçim listesine seçenek ekler
              DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: HandoverMode.physical, child: Text('Fiziksel teslim')),
              // Seçim listesine seçenek ekler
              DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: HandoverMode.digital, child: Text('Dijital teslim')),
            ],
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (mode) => setState(() {
              // oturum değerini günceller
              _session = DemoHandover(mode!);
              // kontrol değerini günceller
              _inspection = _readings = _parties = _accept = false;
              // mesaj değerini günceller
              _message = 'Teslim yöntemi değişti; onayları yeniden tamamlayın.';
            }),
          ),
          // İlgili metodu çalıştırır
          _check('Örnek teslim zamanı uygun', _window, (v) => _window = v),
          // İlgili metodu çalıştırır
          _check('Örnek sürücü yetkili', _driver, (v) => _driver = v),
          // İlgili metodu çalıştırır
          _check('Örnek araç koşulları uygun', _ready, (v) => _ready = v),
          // Koşul doğruysa bu işlemi çalıştırır
          if (_session.mode == HandoverMode.digital)
            // İlgili metodu çalıştırır
            _check('Örnek donanım uyumlu', _compatible, (v) => _compatible = v),
          // Dolgulu buton oluşturur
          FilledButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () => _run(
                  // Bu eleman için oluşturulacak değeri belirler
                  () => _session.preflight(HandoverPrerequisites(
                      // rezervasyon confirmed bilgisini belirler
                      bookingConfirmed: widget.isBookingConfirmed(),
                      // pickup window bilgisini belirler
                      pickupWindow: _window,
                      // sürücü authorized bilgisini belirler
                      driverAuthorized: _driver,
                      // araç hazırlık bilgisini belirler
                      vehicleReady: _ready,
                      // compatible bilgisini belirler
                      compatible: _compatible)),
                  // İlgili metin değerini belirler
                  'Örnek ön kontrol geçti.'),
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Demo ön kontrolü çalıştır')),
          // Koşul doğruysa bu işlemi çalıştırır
          if (_session.mode == HandoverMode.digital) ...[
            // Metni gösterir
            Text('Temsili kilit durumu: ${_session.lock.name}'),
            // Çerçeveli buton oluşturur
            OutlinedButton(
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: () => _run(
                    // Bu eleman için oluşturulacak değeri belirler
                    () => _session.acknowledgeDemoUnlock(accepted: true),
                    // İlgili metin değerini belirler
                    'Yalnızca temsili kilit onayı alındı.'),
                // İçerikte gösterilecek widgetı belirler
                child: const Text('Olumlu kilit yanıtını simüle et')),
            // Çerçeveli buton oluşturur
            OutlinedButton(
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: () => _run(
                    // Bu eleman için oluşturulacak değeri belirler
                    () => _session.acknowledgeDemoUnlock(accepted: false),
                    // İlgili metin değerini belirler
                    'Temsili kilit yanıtı olumsuz; devam edilemez.'),
                // İçerikte gösterilecek widgetı belirler
                child: const Text('Olumsuz kilit yanıtını simüle et')),
            // Çerçeveli buton oluşturur
            OutlinedButton(
                // Butona basılınca çalışacak fonksiyonu belirler
                onPressed: () => _run(_session.connectionLost,
                    // İlgili metin değerini belirler
                    'Bağlantı belirsiz; yeniden ön kontrol ve temsili onay gerekli.'),
                // İçerikte gösterilecek widgetı belirler
                child: const Text('Bağlantı kaybını simüle et')),
          ],
          // Çerçeveli buton oluşturur
          OutlinedButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: widget.openInspection == null
                  // Koşul doğruysa bu değeri seçer
                  ? null
                  // Koşul yanlışsa bu değeri seçer
                  : () async {
                      // Değişen verileri ekrana bildirir
                      setState(() {
                        // kontrol değerini günceller
                        _inspection = false;
                        // İlgili işlemi çalıştırır
                        _session.invalidateCompletion();
                      });
                      // complete değerini belirler
                      final complete = await widget.openInspection!(context);
                      // Widget kaldırılmışsa işlemi durdurur
                      if (!mounted) return;
                      // Değişen verileri ekrana bildirir
                      setState(() {
                        // kontrol değerini günceller
                        _inspection = complete;
                        // mesaj değerini günceller
                        _message = complete
                            // Koşul doğruysa bu değeri seçer
                            ? '20/20 örnek inceleme kabul edildi.'
                            // Koşul yanlışsa bu değeri seçer
                            : 'İnceleme tamamlanmadı; taslağa devam edebilirsiniz.';
                      });
                    },
              // İçerikte gösterilecek widgetı belirler
              child: Text(_inspection
                  // Koşul doğruysa bu değeri seçer
                  ? 'İnceleme 20/20 • Yeniden aç'
                  // Koşul yanlışsa bu değeri seçer
                  : '20 açılı inceleme demosunu aç')),
          // switch liste tile nesnesi oluşturur
          SwitchListTile(
              // Başlığı belirler
              title: const Text('Örnek sayaç ve enerji kaydedildi'),
              // Kullanılacak değeri belirler
              value: _readings,
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: (v) => setState(() {
                    // readings değerini günceller
                    _readings = v;
                    // İlgili işlemi çalıştırır
                    _session.invalidateCompletion();
                    // mesaj değerini günceller
                    _message =
                        // İlgili metin değerini belirler
                        'Onay değişti; teslim demosunu yeniden kontrol edin.';
                  })),
          // Koşul doğruysa bu işlemi çalıştırır
          if (_session.mode == HandoverMode.physical)
            // switch liste tile nesnesi oluşturur
            SwitchListTile(
                // Başlığı belirler
                title: const Text('Örnek teslim tarafları doğrulandı'),
                // Kullanılacak değeri belirler
                value: _parties,
                // Değer değişince çalışacak fonksiyonu belirler
                onChanged: (v) => setState(() {
                      // parties değerini günceller
                      _parties = v;
                      // İlgili işlemi çalıştırır
                      _session.invalidateCompletion();
                      // mesaj değerini günceller
                      _message =
                          // İlgili metin değerini belirler
                          'Onay değişti; teslim demosunu yeniden kontrol edin.';
                    })),
          // switch liste tile nesnesi oluşturur
          SwitchListTile(
              // Başlığı belirler
              title: const Text('Örnek karşılıklı kabul verildi'),
              // Kullanılacak değeri belirler
              value: _accept,
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: (v) => setState(() {
                    // accept değerini günceller
                    _accept = v;
                    // İlgili işlemi çalıştırır
                    _session.invalidateCompletion();
                    // mesaj değerini günceller
                    _message =
                        // İlgili metin değerini belirler
                        'Onay değişti; teslim demosunu yeniden kontrol edin.';
                  })),
          // Dolgulu buton oluşturur
          FilledButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () => _run(
                  // Bu eleman için oluşturulacak değeri belirler
                  () => _session.finish(
                      // rezervasyon still confirmed bilgisini belirler
                      bookingStillConfirmed: widget.isBookingConfirmed(),
                      // kontrol complete bilgisini belirler
                      inspectionComplete: _inspection,
                      // readings recorded bilgisini belirler
                      readingsRecorded: _readings,
                      // parties verified bilgisini belirler
                      partiesVerified: _parties,
                      // mutual acceptance bilgisini belirler
                      mutualAcceptance: _accept),
                  // İlgili metin değerini belirler
                  'Simülasyon tamamlandı. Gerçek sürüş başlatılmadı.'),
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Teslim demosunu tamamla')),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // semantics nesnesi oluşturur
          Semantics(liveRegion: true, child: Text(_message)),
        ]),
      );
}

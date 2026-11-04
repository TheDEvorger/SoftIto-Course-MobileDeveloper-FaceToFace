// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// action durum dosyasını ekler
import '../../../shared/design/action_state.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// rezervasyon controller dosyasını ekler
import '../application/reservation_controller.dart';
// rezervasyon dosyasını ekler
import '../domain/reservation.dart';
// fiyat fiyat teklifi dosyasını ekler
import '../domain/price_quote.dart';
// rezervasyon panel ekranının değişen durumunu yönetir
class BookingPanel extends StatefulWidget {
  // rezervasyon panel nesnesi oluşturur
  const BookingPanel(
      // Veri alanlarını tanımlar
      {super.key,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // controller bilgisini zorunlu alır
      required this.controller,
      // bağlantı bilgisini zorunlu alır
      required this.connected,
      // olay connect bilgisini zorunlu alır
      required this.onConnect,
      // olay rezervasyonlar bilgisini zorunlu alır
      required this.onReservations,
      // başlangıç tarihler parametresini alır
      this.initialDates});
  // araç bilgisini tutar
  final Vehicle vehicle;
  // controller bilgisini tutar
  final ReservationController controller;
  // bağlantı bilgisini tutar
  final bool connected;
  // olay rezervasyonlar bilgisini tutar
  final VoidCallback onConnect, onReservations;
  // başlangıç tarihler bilgisini tutar
  final DateTimeRange? initialDates;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<BookingPanel> createState() => _BookingPanelState();
}
// rezervasyon panel durum ekranının durumunu yöneten sınıf
class _BookingPanelState extends State<BookingPanel> {
  // tarihler bilgisini tutar
  late DateTimeRange _dates;
  // anahtar değerini belirler
  String _key = ReservationController.requestKey();
  // saving değerini belirler
  bool _saving = false;
  // attempted değerini belirler
  bool _attempted = false;
  // quoting değerini belirler
  bool _quoting = false;
  // fiyat teklifi istek değerini belirler
  int _quoteRequest = 0;
  // fiyat teklifi bilgisini tutar
  PriceQuote? _quote;
  // hata bilgisini tutar
  String? _error;
  // kayıt bilgisini tutar
  Reservation? _record;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // today değerini belirler
    final today = DateUtils.dateOnly(DateTime.now());
    // tomorrow değerini belirler
    final tomorrow = today.add(const Duration(days: 1));
    // tarihler değerini günceller
    _dates = widget.initialDates != null &&
            // Önceki ifadeyi tamamlar
            !widget.initialDates!.start.isBefore(today)
        // Koşul doğruysa bu değeri seçer
        ? widget.initialDates!
        // Koşul yanlışsa bu değeri seçer
        : DateTimeRange(
            // Başlangıç bilgisini belirler
            start: tomorrow, end: tomorrow.add(const Duration(days: 1)));
    // Koşul doğruysa bu işlemi çalıştırır
    if (widget.connected) _loadQuote();
  }
  // yükleme fiyat teklifi işlemini asenkron yürütür
  Future<void> _loadQuote() async {
    // istek değerini belirler
    final request = ++_quoteRequest;
    // Değişen verileri ekrana bildirir
    setState(() {
      // quoting değerini günceller
      _quoting = true;
      // fiyat teklifi değerini günceller
      _quote = null;
    });
    // Hata oluşabilecek işlemleri dener
    try {
      // fiyat teklifi değerini belirler
      final quote = await widget.controller
          // Önceki ifade üzerinde ek işlem uygular
          .quote(widget.vehicle.id, _dates.start, _dates.end);
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted && request == _quoteRequest) {
        // Değişen verileri ekrana bildirir
        setState(() {
          // fiyat teklifi değerini günceller
          _quote = quote;
          // hata değerini günceller
          _error = null;
        });
      }
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted && request == _quoteRequest) {
        // Değişen verileri ekrana bildirir
        setState(() => _error = error.toString());
      }
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted && request == _quoteRequest) setState(() => _quoting = false);
    }
  }
  // choose işlemini asenkron yürütür
  Future<void> _choose() async {
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
        // Başlangıç tarih aralığını belirler
        initialDateRange: _dates,
        // help metin bilgisini belirler
        helpText: 'Alış ve dönüş tarihleri',
        // kaydetme metin bilgisini belirler
        saveText: 'Seç');
    // Widget kaldırılmışsa işlemi durdurur
    if (!mounted || range == null) return;
    // Koşul doğruysa bu işlemi çalıştırır
    if (rentalDays(range.start, range.end) < 1 ||
        // İlgili fonksiyonu çalıştırır
        rentalDays(range.start, range.end) > 7) {
      // Değişen verileri ekrana bildirir
      setState(() => _error = '1–7 günlük bir tarih aralığı seçin.');
      // Önceki ifadeyi tamamlar
      return;
    }
    // Değişen verileri ekrana bildirir
    setState(() {
      // tarihler değerini günceller
      _dates = range;
      // anahtar değerini günceller
      _key = ReservationController.requestKey();
      // attempted değerini günceller
      _attempted = false;
      // hata değerini günceller
      _error = null;
    });
    // Asenkron işlemin tamamlanmasını bekler
    await _loadQuote();
  }
  // reserve işlemini asenkron yürütür
  Future<void> _reserve() async {
    // Değer null ise koşulu çalıştırır
    if (_quote == null) return;
    // Koşul doğruysa bu işlemi çalıştırır
    if (_quote!.expired && !_attempted) {
      // Asenkron işlemin tamamlanmasını bekler
      await _loadQuote();
      // Önceki ifadeyi tamamlar
      return;
    }
    // Değişen verileri ekrana bildirir
    setState(() {
      // saving değerini günceller
      _saving = true;
      // attempted değerini günceller
      _attempted = true;
      // hata değerini günceller
      _error = null;
    });
    // Hata oluşabilecek işlemleri dener
    try {
      // kayıt değerini belirler
      final record = await widget.controller.reserve(
          // Üst widgettan gelen bilgilere erişir
          widget.vehicle.id, _dates.start, _dates.end,
          // İşlemin tekrarını önleyen anahtarı belirler
          requestKey: _key, quoteToken: _quote!.token);
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _record = record);
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) {
        // Değişen verileri ekrana bildirir
        setState(() => _error = error is ApiException
            // Koşul doğruysa bu değeri seçer
            ? error.message
            // Koşul yanlışsa bu değeri seçer
            : 'Rezervasyon kaydedilemedi.');
        // Koşul doğruysa bu işlemi çalıştırır
        if (error is ApiException && error.status == 409) {
          // Asenkron işlemin tamamlanmasını bekler
          await _loadQuote();
        }
      }
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _saving = false);
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!widget.connected) {
      // Hesaplanan sonucu geri döndürür
      return ActionState(
          // Başlığı belirler
          title: 'Yolculuğu planlamaya başlayın.',
          // mesaj bilgisini belirler
          message:
              // İlgili metin değerini belirler
              'Rezervasyon kaydı oluşturmak için çalışma alanınıza bağlanın.',
          // Butonun veya öğenin simgesini belirler
          icon: Icons.key_outlined,
          // action bilgisini belirler
          action: widget.onConnect,
          // Görünen etiketi belirler
          label: 'Çalışma alanına bağlan');
    }
    // Değer null değilse koşulu çalıştırır
    if (_record != null) {
      // Hesaplanan sonucu geri döndürür
      return ActionState(
          // Başlığı belirler
          title: 'Rezervasyon kaydedildi',
          // mesaj bilgisini belirler
          message:
              // İlgili metin değerini belirler
              'Sunucuda kayıtlı toplam: ${_record!.totalLabel}\nReferans: ${_record!.id}',
          // Butonun veya öğenin simgesini belirler
          icon: Icons.check_circle_outline,
          // action bilgisini belirler
          action: widget.onReservations,
          // Görünen etiketi belirler
          label: 'Rezervasyonlarıma git');
    }
    // gün sayısı değerini belirler
    final days = rentalDays(_dates.start, _dates.end);
    // tarihler değerini belirler
    final dates = MaterialLocalizations.of(context);
    // Hesaplanan sonucu geri döndürür
    return PopScope(
        // izin pop bilgisini belirler
        canPop: !_saving,
        // İçerikte gösterilecek widgetı belirler
        child: StudioPanel(
            // İçerikte gösterilecek widgetı belirler
            child: Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // İçerideki elemanları listeler
                children: [
              // Metni gösterir
              Text('Sizin yolculuğunuz',
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleLarge),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 8),
              // Metni gösterir
              Text('${widget.vehicle.rateLabel} / gün',
                  // Görünüm stilini belirler
                  style: TextStyle(
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 24),
              // Metni gösterir
              Text('ALIŞ',
                  // Görünüm stilini belirler
                  style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 10,
                      // Harfler arasındaki boşluğu ayarlar
                      letterSpacing: 2,
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 6),
              // Metni gösterir
              Text(dates.formatMediumDate(_dates.start),
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleMedium),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 18),
              // Metni gösterir
              Text('DÖNÜŞ',
                  // Görünüm stilini belirler
                  style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 10,
                      // Harfler arasındaki boşluğu ayarlar
                      letterSpacing: 2,
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 6),
              // Metni gösterir
              Text(dates.formatMediumDate(_dates.end),
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleMedium),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 18),
              // Çerçeveli buton oluşturur
              OutlinedButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: _saving || _quoting ? null : _choose,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.calendar_today_outlined, size: 17),
                  // Görünen etiketi belirler
                  label: const Text('Tarihleri değiştir')),
              // Ayırıcı çizgi oluşturur
              const Divider(height: 36),
              // Metni gösterir
              Text('$days gün · Sunucu fiyat teklifi'),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 8),
              // Koşul doğruysa bu işlemi çalıştırır
              if (_quoting)
                // Yatay ilerleme çubuğu oluşturur
                const LinearProgressIndicator()
              // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
              else if (_quote != null)
                // Metni gösterir
                Text(_quote!.totalLabel,
                    // Görünüm stilini belirler
                    style: Theme.of(context).textTheme.headlineMedium),
              // Değer null değilse koşulu çalıştırır
              if (_quote != null)
                // Metni gösterir
                Text('${_quote!.rateLabel} / gün · Teklif 5 dakika geçerli',
                    // Görünüm stilini belirler
                    style: const TextStyle(fontSize: 12)),
              // Metin butonu oluşturur
              TextButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: _saving || _quoting ? null : _loadQuote,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.refresh, size: 16),
                  // Görünen etiketi belirler
                  label: const Text('Fiyatı ve müsaitliği yenile')),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 16),
              // Metni gösterir
              const Text(
                  // İlgili metin değerini belirler
                  'Tutar ve müsaitlik sunucudan alınır, kayıt sırasında tekrar kontrol edilir. Dönüş günü kiralamaya dahil değildir. '
                  // İlgili metin değerini belirler
                  'Bu adım rezervasyon kaydı oluşturur; ödeme hizmeti henüz bağlı değildir.',
                  // Görünüm stilini belirler
                  style: TextStyle(fontSize: 12)),
              // Değer null değilse koşulu çalıştırır
              if (_error != null)
                // İçerik etrafına boşluk bırakır
                Padding(
                    // İç boşlukları ayarlar
                    padding: const EdgeInsets.only(top: 16),
                    // İçerikte gösterilecek widgetı belirler
                    child: Semantics(
                        // live region bilgisini belirler
                        liveRegion: true,
                        // İçerikte gösterilecek widgetı belirler
                        child: Text(_error!,
                            // Görünüm stilini belirler
                            style: TextStyle(
                                // Rengi belirler
                                color: Theme.of(context).colorScheme.error)))),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 24),
              // Dolgulu buton oluşturur
              FilledButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed:
                      // İlgili işlemi çalıştırır
                      _saving || _quoting || _quote == null ? null : _reserve,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.north_east, size: 18),
                  // Görünen etiketi belirler
                  label: Text(
                      // İlgili işlemi çalıştırır
                      _saving ? 'Kaydediliyor…' : 'Rezervasyon kaydı oluştur')),
            ])));
  }
}

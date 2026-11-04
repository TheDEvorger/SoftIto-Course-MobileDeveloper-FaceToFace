// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// kiralama controller dosyasını ekler
import '../application/rental_controller.dart';
// device kiralama veri deposu dosyasını ekler
import '../data/device_rental_repository.dart';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// kiralama actions dosyasını ekler
import 'rental_actions.dart';
// yerel rezervasyon panel ekranının değişen durumunu yönetir
class LocalBookingPanel extends StatefulWidget {
  // yerel rezervasyon panel nesnesi oluşturur
  const LocalBookingPanel(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // olay rezervasyonlar bilgisini zorunlu alır
      required this.onReservations,
      // başlangıç tarihler parametresini alır
      this.initialDates});
  // controller bilgisini tutar
  final RentalController controller;
  // araç bilgisini tutar
  final RentalVehicle vehicle;
  // başlangıç tarihler bilgisini tutar
  final DateTimeRange? initialDates;
  // olay rezervasyonlar bilgisini tutar
  final VoidCallback onReservations;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<LocalBookingPanel> createState() => _LocalBookingPanelState();
}
// yerel rezervasyon panel durum ekranının durumunu yöneten sınıf
class _LocalBookingPanelState extends State<LocalBookingPanel> {
  // tarihler bilgisini tutar
  late DateTimeRange _dates;
  // fiyat teklifi bilgisini tutar
  RentalQuote? _quote;
  // kayıt bilgisini tutar
  LocalReservation? _record;
  // hata bilgisini tutar
  String? _error;
  // saving değerini belirler
  bool _saving = false;
  // istek değerini belirler
  String _request = DeviceRentalRepository.newRequestKey();
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // today değerini belirler
    final today = DateUtils.dateOnly(DateTime.now());
    // tomorrow değerini belirler
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    // tarihler değerini günceller
    _dates = widget.initialDates != null &&
            // Önceki ifadeyi tamamlar
            !widget.initialDates!.start.isBefore(today)
        // Koşul doğruysa bu değeri seçer
        ? widget.initialDates!
        // Koşul yanlışsa bu değeri seçer
        : DateTimeRange(
            // Başlangıç bilgisini belirler
            start: tomorrow,
            // Bitiş bilgisini belirler
            end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day + 2));
    // İlgili metodu çalıştırır
    _calculate();
  }
  // calculate işlemini gerçekleştirir
  void _calculate() {
    // Hata oluşabilecek işlemleri dener
    try {
      // fiyat teklifi değerini günceller
      _quote = widget.controller.repository
          // Önceki ifade üzerinde ek işlem uygular
          .quote(widget.vehicle.id, _dates.start, _dates.end);
      // hata değerini günceller
      _error = null;
    // İşlem hata verirse çalışır
    } catch (error) {
      // fiyat teklifi değerini günceller
      _quote = null;
      // hata değerini günceller
      _error = error.toString();
    }
  }
  // choose işlemini asenkron yürütür
  Future<void> _choose() async {
    // tarihler değerini belirler
    final dates = await rentalDates(context, initial: _dates);
    // Widget kaldırılmışsa işlemi durdurur
    if (dates == null || !mounted) return;
    // Değişen verileri ekrana bildirir
    setState(() {
      // tarihler değerini günceller
      _dates = dates;
      // istek değerini günceller
      _request = DeviceRentalRepository.newRequestKey();
      // İlgili metodu çalıştırır
      _calculate();
    });
  }
  // book işlemini asenkron yürütür
  Future<void> _book() async {
    // Değer null ise koşulu çalıştırır
    if (_quote == null || _saving) return;
    // Değişen verileri ekrana bildirir
    setState(() => _saving = true);
    // fiyat teklifi değerini belirler
    final quote = _quote!;
    // accepted değerini belirler
    final accepted = await showDialog<bool>(
        // context bilgisini belirler
        context: context,
        // İçeriği oluşturan fonksiyonu belirler
        builder: (context) => AlertDialog(
                // scrollable bilgisini belirler
                scrollable: true,
                // Başlığı belirler
                title: const Text('Yolculuk planını onaylayın'),
                // content bilgisini belirler
                content: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Ana eksende kaplanan alanı belirler
                    mainAxisSize: MainAxisSize.min,
                    // İçerideki elemanları listeler
                    children: [
                      // Metni gösterir
                      Text(widget.vehicle.name,
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.titleLarge),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 12),
                      // Metni gösterir
                      Text('${quote.days} gün · ${quote.totalLabel}'),
                      // Belirtilen boyutta boşluk veya kutu oluşturur
                      const SizedBox(height: 16),
                      // Metni gösterir
                      const Text(
                          // İlgili metin değerini belirler
                          'Bu rezervasyon cihazınıza kaydedilir. Araç tedarikçisine iletilmez ve ödeme alınmaz.'),
                    ]),
                // actions bilgisini belirler
                actions: [
                  // Metin butonu oluşturur
                  TextButton(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: () => Navigator.pop(context, false),
                      // İçerikte gösterilecek widgetı belirler
                      child: const Text('Vazgeç')),
                  // Dolgulu buton oluşturur
                  FilledButton(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: () => Navigator.pop(context, true),
                      // İçerikte gösterilecek widgetı belirler
                      child: const Text('Rezervasyonu kaydet'))
                ]));
    // Widget kaldırılmışsa işlemi durdurur
    if (!mounted) return;
    // Koşul doğruysa bu işlemi çalıştırır
    if (accepted != true) {
      // Değişen verileri ekrana bildirir
      setState(() => _saving = false);
      // Önceki ifadeyi tamamlar
      return;
    }
    // Hata oluşabilecek işlemleri dener
    try {
      // kayıt değerini belirler
      final record = await widget.controller.reserve(quote, _request);
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) {
        // Değişen verileri ekrana bildirir
        setState(() {
          // kayıt değerini günceller
          _record = record;
          // hata değerini günceller
          _error = null;
        });
      }
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) {
        // Değişen verileri ekrana bildirir
        setState(() {
          // İlgili metodu çalıştırır
          _calculate();
          // hata değerini günceller
          _error = error.toString();
        });
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
    // tarihler değerini belirler
    final dates = MaterialLocalizations.of(context);
    // Değer null değilse koşulu çalıştırır
    if (_record != null) {
      // Hesaplanan sonucu geri döndürür
      return StudioPanel(
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Simgeyi gösterir
        Icon(Icons.check_circle_outline,
            // Rengi belirler
            color: Theme.of(context).colorScheme.primary, size: 48),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 20),
        // Metni gösterir
        Text('Rezervasyonunuz kaydedildi.',
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.headlineSmall),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 16),
        // Metni gösterir
        Text('Referans: ${_record!.id}'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        Text(
            // İlgili metin değerini belirler
            '${dates.formatMediumDate(_record!.start)} — ${dates.formatMediumDate(_record!.end)}'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        Text(_record!.totalLabel,
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.headlineMedium),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 16),
        // Metni gösterir
        const Text(
            // İlgili metin değerini belirler
            'Bu cihazda kayıtlı. Tedarikçi onayı veya tahsilat yapılmadı.',
            // Görünüm stilini belirler
            style: TextStyle(fontSize: 12)),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 22),
        // Dolgulu buton oluşturur
        FilledButton(
            // Butona basılınca çalışacak fonksiyonu belirler
            onPressed: widget.onReservations,
            // İçerikte gösterilecek widgetı belirler
            child: const Text('Rezervasyonlarımı gör')),
      ]));
    }
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
              Text('Yolculuğunuzu planlayın',
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleLarge),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 8),
              // Metni gösterir
              Text('${widget.vehicle.dailyLabel} / gün'),
              // Ayırıcı çizgi oluşturur
              const Divider(height: 32),
              // Metni gösterir
              const Text('ALIŞ TARİHİ',
                  // Görünüm stilini belirler
                  style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
              // Metni gösterir
              Text(dates.formatMediumDate(_dates.start),
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleMedium),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 16),
              // Metni gösterir
              const Text('DÖNÜŞ TARİHİ',
                  // Görünüm stilini belirler
                  style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
              // Metni gösterir
              Text(dates.formatMediumDate(_dates.end),
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleMedium),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 16),
              // Çerçeveli buton oluşturur
              OutlinedButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: _saving ? null : _choose,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  // Görünen etiketi belirler
                  label: const Text('Tarihleri değiştir')),
              // Ayırıcı çizgi oluşturur
              const Divider(height: 32),
              // Değer null değilse koşulu çalıştırır
              if (_quote != null) ...[
                // Metni gösterir
                Text('${_quote!.days} gün × ${widget.vehicle.dailyLabel}'),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 8),
                // Metni gösterir
                Text(_quote!.totalLabel,
                    // Görünüm stilini belirler
                    style: Theme.of(context).textTheme.headlineMedium),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 8),
                // Metni gösterir
                const Text('Ek hizmet veya ödeme eklenmedi.',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 12)),
              ],
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
              const SizedBox(height: 22),
              // Dolgulu buton oluşturur
              FilledButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: _saving ||
                          // Önceki ifadeyi tamamlar
                          !widget.controller.ready ||
                          // Üst widgettan gelen bilgilere erişir
                          widget.controller.busy ||
                          // fiyat teklifi değerini günceller
                          _quote == null
                      // Koşul doğruysa bu değeri seçer
                      ? null
                      // Koşul yanlışsa bu değeri seçer
                      : _book,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.arrow_outward, size: 18),
                  // Görünen etiketi belirler
                  label:
                      // Metni gösterir
                      Text(_saving ? 'Kaydediliyor…' : 'Rezervasyon oluştur')),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: 14),
              // Metni gösterir
              const Text(
                  // İlgili metin değerini belirler
                  'Hazır koleksiyonun fiyat özetidir. Plan bu cihazda saklanır; '
                  // İlgili metin değerini belirler
                  'gerçek kiralama veya ödeme onayı değildir. Dönüş günü ücrete dahil değildir.',
                  // Görünüm stilini belirler
                  style: TextStyle(fontSize: 11)),
            ])));
  }
}

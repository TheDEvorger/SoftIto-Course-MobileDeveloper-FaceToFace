// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// örnek rezervasyon scope dosyasını ekler
import '../application/demo_booking_scope.dart';
// rezervasyon defter dosyasını ekler
import '../domain/booking_ledger.dart';
/// Rezervasyon durumunu kullanıcı dostu Türkçe metne dönüştürür.
// rezervasyon durum etiket işlemini gerçekleştirir
String bookingStateLabel(BookingState state) => switch (state) {
      // rezervasyon durum değerini günceller
      BookingState.quoted => 'Teklif hazır',
      // rezervasyon durum değerini günceller
      BookingState.confirmed => 'Demo rezervasyon onaylandı',
      // rezervasyon durum değerini günceller
      BookingState.cancelled => 'İptal edildi',
      // rezervasyon durum değerini günceller
      BookingState.expired => 'Teklif süresi doldu',
    };
/// Rezervasyon oluşturma, teklif alma ve onaylama adımlarını simüle eden ekran.
// rezervasyon örnek ekran ekranının değişen durumunu yönetir
class BookingDemoScreen extends StatefulWidget {
  // rezervasyon örnek ekran nesnesi oluşturur
  const BookingDemoScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // araç ID bilgisini zorunlu alır
      required this.vehicleId,
      // araç ad bilgisini zorunlu alır
      required this.vehicleName,
      // günlük rate bilgisini zorunlu alır
      required this.dailyRate});
  /// Rezervasyon yapılacak araç kimliği
  // araç ID bilgisini tutar
  final String vehicleId;
  /// Araç model adı
  // araç ad bilgisini tutar
  final String vehicleName;
  /// Günlük kiralama birim fiyatı
  // günlük rate bilgisini tutar
  final int dailyRate;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<BookingDemoScreen> createState() => _BookingDemoScreenState();
}
// rezervasyon örnek ekran durum ekranının durumunu yöneten sınıf
class _BookingDemoScreenState extends State<BookingDemoScreen> {
  // Seçilen kiralama gün sayısı (1, 2, 3, 7)
  // gün sayısı değerini belirler
  int _days = 1;
  // Oluşturulan teklif kimliği
  // ID bilgisini tutar
  String? _id;
  // Hata mesajı (varsa)
  // hata bilgisini tutar
  String? _error;
  // run işlemini gerçekleştirir
  void _run(VoidCallback action) {
    // Hata oluşabilecek işlemleri dener
    try {
      // İlgili fonksiyonu çalıştırır
      action();
      // Değişen verileri ekrana bildirir
      setState(() => _error = null);
    // İşlem hata verirse çalışır
    } on StateError catch (e) {
      // Değişen verileri ekrana bildirir
      setState(() => _error = e.message);
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // controller değerini belirler
    final controller = DemoBookingScope.of(context);
    // kayıt değerini belirler
    final record =
        // ID değerini günceller
        _id == null ? null : controller.ledger.get(_id!, controller.clock());
    // Sayfanın temel yapısını oluşturur
    return Scaffold(
      // Sayfanın üst menüsünü oluşturur
      appBar: AppBar(title: const Text('Örnek rezervasyon')),
      // Sayfanın ana içeriğini oluşturur
      body: ListView(padding: const EdgeInsets.all(24), children: [
        // Metni gösterir
        Text(widget.vehicleName,
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.headlineSmall),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 12),
        // Metni gösterir
        const Text('DEMO • Gerçek rezervasyon veya ödeme yapılmaz. '
            // İlgili metin değerini belirler
            'Başlangıç: yarın 10:00 (cihazın yerel saati). '
            // İlgili metin değerini belirler
            'Teklif 5 dakika geçerli; fiyat yalnızca örnektir.'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 16),
        // İfadeye karşılaştırma koşulu ekler
        DropdownButtonFormField<int>(
          // Başlangıç değerini belirler
          initialValue: _days,
          // Kutunun görünümünü ayarlar
          decoration: const InputDecoration(labelText: 'Örnek kiralama süresi'),
          // Seçenekleri listeler
          items: [1, 2, 3, 7]
              // Listedeki elemanları dönüştürür
              .map((days) =>
                  // Seçim listesine seçenek ekler
                  DropdownMenuItem(value: days, child: Text('$days gün')))
              // Sonucu listeye dönüştürür
              .toList(),
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (value) => setState(() {
            // gün sayısı değerini günceller
            _days = value!;
            // ID değerini günceller
            _id = null;
          }),
        ),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 16),
        // Dolgulu buton oluşturur
        FilledButton(
            // Butona basılınca çalışacak fonksiyonu belirler
            onPressed: () => setState(() {
                  // ID değerini günceller
                  _id = controller
                      // Önceki ifade üzerinde ek işlem uygular
                      .quote(
                          // araç ID bilgisini belirler
                          vehicleId: widget.vehicleId,
                          // araç ad bilgisini belirler
                          vehicleName: widget.vehicleName,
                          // günlük rate bilgisini belirler
                          dailyRate: widget.dailyRate,
                          // gün sayısı bilgisini belirler
                          days: _days)
                      // Önceki ifade üzerinde ek işlem uygular
                      .id;
                  // hata değerini günceller
                  _error = null;
                }),
            // İçerikte gösterilecek widgetı belirler
            child: const Text('Örnek teklif oluştur')),
        // Değer null değilse koşulu çalıştırır
        if (record != null) ...[
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // Metni gösterir
          Text('Örnek toplam: ₺${record.total} • ${record.policyVersion}'),
          // Metni gösterir
          Text('Başlangıç: ${record.start}'),
          // Metni gösterir
          Text('Bitiş: ${record.end}'),
          // Metni gösterir
          Text('Teklif sonu: ${record.expiresAt}'),
          // semantics nesnesi oluşturur
          Semantics(
              // live region bilgisini belirler
              liveRegion: true, child: Text(bookingStateLabel(record.state))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Dolgulu buton oluşturur
          FilledButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: record.state == BookingState.quoted
                  // Koşul doğruysa bu değeri seçer
                  ? () => _run(() => controller.confirm(record.id))
                  // Koşul yanlışsa bu değeri seçer
                  : null,
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Demo onayı ver')),
          // Çerçeveli buton oluşturur
          OutlinedButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: record.state == BookingState.quoted ||
                      // kayıt değerini günceller
                      record.state == BookingState.confirmed
                  // Koşul doğruysa bu değeri seçer
                  ? () => _run(() => controller.cancel(record.id))
                  // Koşul yanlışsa bu değeri seçer
                  : null,
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Örnek rezervasyonu iptal et')),
          // Metin butonu oluşturur
          TextButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () => setState(() {}),
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Teklif durumunu yenile')),
        ],
        // Değer null değilse koşulu çalıştırır
        if (_error != null)
          // semantics nesnesi oluşturur
          Semantics(
              // live region bilgisini belirler
              liveRegion: true,
              // İçerikte gösterilecek widgetı belirler
              child: Text(_error!,
                  // Görünüm stilini belirler
                  style:
                      // Yazı stilini oluşturur
                      TextStyle(color: Theme.of(context).colorScheme.error))),
        // Metni gösterir
        const Text('Oturum verileri bellektedir; uygulama kapanınca silinir.'),
      ]),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Flutter sistem hizmetlerini ekler
import 'package:flutter/services.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// kiralama car kart dosyasını ekler
import 'rental_car_card.dart';
// kiralama plan kart görünümünü oluşturan widget sınıfı
class RentalPlanCard extends StatelessWidget {
  // kiralama plan kart nesnesi oluşturur
  const RentalPlanCard(
      // Veri alanlarını tanımlar
      {super.key,
      // kayıt bilgisini zorunlu alır
      required this.record,
      // araç bilgisini zorunlu alır
      required this.vehicle,
      // olay iptal bilgisini zorunlu alır
      required this.onCancel,
      // this değerini günceller
      this.details = false});
  // kayıt bilgisini tutar
  final LocalReservation record;
  // araç bilgisini tutar
  final RentalVehicle vehicle;
  // olay iptal bilgisini tutar
  final VoidCallback? onCancel;
  // detaylar bilgisini tutar
  final bool details;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // tarihler değerini belirler
    final dates = MaterialLocalizations.of(context);
    // information değerini belirler
    final information =
        // Elemanları alt alta dizer
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Sığmayan öğeleri alt satıra geçirir
      Wrap(
          // Öğeler arasındaki boşluğu belirler
          spacing: 7,
          // Çapraz eksendeki hizalamayı belirler
          crossAxisAlignment: WrapCrossAlignment.center,
          // İçerideki elemanları listeler
          children: [
            // Simgeyi gösterir
            Icon(
                // Önceki ifadeyi tamamlar
                record.cancelled
                    // Koşul doğruysa bu değeri seçer
                    ? Icons.cancel_outlined
                    // Koşul yanlışsa bu değeri seçer
                    : Icons.event_available_outlined,
                // Boyutu belirler
                size: 17),
            // Metni gösterir
            Text(record.cancelled ? 'İptal edildi' : 'Cihazda kayıtlı',
                // Görünüm stilini belirler
                style: const TextStyle(fontSize: 12)),
          ]),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 12),
      // Metni gösterir
      Text(vehicle.name, style: Theme.of(context).textTheme.titleLarge),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 8),
      // Metni gösterir
      Text('${vehicle.city} · ${vehicle.pickup}'),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 8),
      // Metni gösterir
      Text(
          // İlgili metin değerini belirler
          '${dates.formatShortDate(record.start)} — ${dates.formatShortDate(record.end)}'),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 8),
      // Metni gösterir
      Text(
          // İlgili metin değerini belirler
          '${calendarDays(record.start, record.end)} gün · ${record.totalLabel}',
          // Görünüm stilini belirler
          style: const TextStyle(fontWeight: FontWeight.w600)),
      // Koşul doğruysa bu işlemi çalıştırır
      if (details) ...[
        // Ayırıcı çizgi oluşturur
        const Divider(height: 30),
        // selectable metin nesnesi oluşturur
        SelectableText('Referans: ${record.id}'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 12),
        // Metni gösterir
        const Text(
            // İlgili metin değerini belirler
            'Bu cihazdaki plan kaydıdır. Gerçek araç tahsisi, tedarikçi onayı ve ödeme işlemi yapılmadı.'),
      ],
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 18),
      // Sığmayan öğeleri alt satıra geçirir
      Wrap(spacing: 10, runSpacing: 10, children: [
        // Koşul doğruysa bu işlemi çalıştırır
        if (!details)
          // Çerçeveli buton oluşturur
          OutlinedButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () => showModalBottomSheet<void>(
                  // context bilgisini belirler
                  context: context,
                  // durum scroll controlled bilgisini belirler
                  isScrollControlled: true,
                  // use safe area bilgisini belirler
                  useSafeArea: true,
                  // İçeriği oluşturan fonksiyonu belirler
                  builder: (_) => SingleChildScrollView(
                      // İç boşlukları ayarlar
                      padding: const EdgeInsets.all(20),
                      // İçerikte gösterilecek widgetı belirler
                      child: RentalPlanCard(
                          // kayıt bilgisini belirler
                          record: record,
                          // Araç bilgisini gönderir
                          vehicle: vehicle,
                          // iptal için callback belirler
                          onCancel: null,
                          // detaylar bilgisini belirler
                          details: true))),
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Rezervasyon detayı')),
        // Koşul doğruysa bu işlemi çalıştırır
        if (details)
          // Çerçeveli buton oluşturur
          OutlinedButton.icon(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () async {
                // Asenkron işlemin tamamlanmasını bekler
                await Clipboard.setData(ClipboardData(
                    // metin bilgisini belirler
                    text: '${record.id} · ${vehicle.name} · '
                        // İlgili metin değerini belirler
                        '${rentalDateKey(record.start)} / ${rentalDateKey(record.end)} · ${record.totalLabel} · '
                        // İlgili metin değerini belirler
                        '${record.cancelled ? 'İptal edildi' : 'Yerel plan'}'));
                // Widget hâlâ ekrandaysa işlemi sürdürür
                if (context.mounted) {
                  // snack bar constructorını tanımlar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      // content bilgisini belirler
                      content: Text('Rezervasyon özeti kopyalandı.')));
                }
              },
              // Butonun veya öğenin simgesini belirler
              icon: const Icon(Icons.copy_outlined, size: 16),
              // Görünen etiketi belirler
              label: const Text('Özeti kopyala')),
        // Koşul doğruysa bu işlemi çalıştırır
        if (!record.cancelled && !details)
          // Metin butonu oluşturur
          TextButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: onCancel, child: const Text('Rezervasyonu iptal et')),
      ]),
    ]);
    // Hesaplanan sonucu geri döndürür
    return StudioPanel(
        // İç boşlukları ayarlar
        padding: 18,
        // İçerikte gösterilecek widgetı belirler
        child: LayoutBuilder(builder: (context, c) {
          // Koşul doğruysa bu işlemi çalıştırır
          if (c.maxWidth < 700 ||
              // Ekran ölçülerini alır
              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
            // Elemanları alt alta dizer
            return Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // İçerideki elemanları listeler
                children: [
                  // kiralama car fotoğraf nesnesi oluşturur
                  RentalCarPhoto(vehicle: vehicle),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 20),
                  // Önceki ifadeyi tamamlar
                  information
                ]);
          }
          // Elemanları yan yana dizer
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Belirtilen boyutta boşluk veya kutu oluşturur
            SizedBox(width: 250, child: RentalCarPhoto(vehicle: vehicle)),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 24),
            // Kalan alanı doldurur
            Expanded(child: information)
          ]);
        }));
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// section heading dosyasını ekler
import '../../../shared/widgets/section_heading.dart';
// örnek rezervasyon scope dosyasını ekler
import '../application/demo_booking_scope.dart';
// rezervasyon defter dosyasını ekler
import '../domain/booking_ledger.dart';
// rezervasyon örnek ekran dosyasını ekler
import 'booking_demo_screen.dart';
/// "Sürüşlerim" sekmesi ekranı.
/// Oturum süresince oluşturulan tüm rezervasyon kayıtlarını listeler;
/// teslim ekranını açma veya rezervasyonu iptal etme aksiyonları sunar.
// rezervasyonlar ekran görünümünü oluşturan widget sınıfı
class BookingsScreen extends StatelessWidget {
  // rezervasyonlar ekran nesnesi oluşturur
  const BookingsScreen({super.key});
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // DemoBookingScope üzerinden rezervasyon controller'ı alınır
    // controller değerini belirler
    final controller = DemoBookingScope.of(context);
    // Kayıtlar listelenirken anlık geçerlilik (expiration) durumları hesaplanır
    // kayıtlar değerini belirler
    final records = controller.ledger.records
        // Listedeki elemanları dönüştürür
        .map((r) => controller.ledger.get(r.id, controller.clock()))
        // Sonucu listeye dönüştürür
        .toList();
    // Kaydırılabilir liste oluşturur
    return ListView(padding: const EdgeInsets.all(24), children: [
      // section heading nesnesi oluşturur
      const SectionHeading(
          // Başlığı belirler
          title: 'Sürüşlerim',
          // Alt başlığı belirler
          subtitle: 'DEMO • Gerçek rezervasyon veya ödeme yapılmaz.'),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 20),
      // Liste veya metin boşsa koşulu çalıştırır
      if (records.isEmpty)
        // Metni gösterir
        const Text(
            // İlgili metin değerini belirler
            'Henüz örnek rezervasyon yok. Keşfet → Aracı incele ile başlayın.'),
      // Listedeki öğeleri veya indeksleri sırayla dolaşır
      for (final record in records)
        // Kart görünümü oluşturur
        Card(
            // İçerikte gösterilecek widgetı belirler
            child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(16),
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Metni gösterir
            Text('${record.vehicleName} • ${record.id}'),
            // Metni gösterir
            Text(bookingStateLabel(record.state)),
            // Metni gösterir
            Text('${record.start} → ${record.end}'),
            // Metni gösterir
            Text('Örnek toplam ₺${record.total}'),
            // Koşul doğruysa bu işlemi çalıştırır
            if (record.state == BookingState.confirmed)
              // Çerçeveli buton oluşturur
              OutlinedButton(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: () => Navigator.of(context)
                      // Önceki ifade üzerinde ek işlem uygular
                      .pushNamed('/handover', arguments: record.id),
                  // İçerikte gösterilecek widgetı belirler
                  child: const Text('Teslim demosunu aç')),
            // Koşul doğruysa bu işlemi çalıştırır
            if (record.state == BookingState.confirmed)
              // Çerçeveli buton oluşturur
              OutlinedButton(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: () => controller.cancel(record.id),
                  // İçerikte gösterilecek widgetı belirler
                  child: const Text('Demo rezervasyonu iptal et')),
          ]),
        )),
      // Metni gösterir
      const Text('Veriler yalnızca bu oturumun belleğinde tutulur.'),
    ]);
  }
}

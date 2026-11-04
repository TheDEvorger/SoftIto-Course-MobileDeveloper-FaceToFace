// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// kiralama controller dosyasını ekler
import '../application/rental_controller.dart';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// kiralama actions dosyasını ekler
import 'rental_actions.dart';
// kiralama car kart dosyasını ekler
import 'rental_car_card.dart';
// kiralama plan kart dosyasını ekler
import 'rental_plan_card.dart';
// kiralama planlar ekran ekranının değişen durumunu yönetir
class RentalPlansScreen extends StatefulWidget {
  // kiralama planlar ekran nesnesi oluşturur
  const RentalPlansScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // olay discover bilgisini zorunlu alır
      required this.onDiscover,
      // olay open bilgisini zorunlu alır
      required this.onOpen});
  // controller bilgisini tutar
  final RentalController controller;
  // olay discover bilgisini tutar
  final VoidCallback onDiscover;
  // olay open bilgisini tutar
  final ValueChanged<RentalVehicle> onOpen;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<RentalPlansScreen> createState() => _RentalPlansScreenState();
}
// kiralama planlar ekran durum ekranının durumunu yöneten sınıf
class _RentalPlansScreenState extends State<RentalPlansScreen> {
  // filtre değerini belirler
  String _filter = 'all';
  // iptal işlemini asenkron yürütür
  Future<void> _cancel(LocalReservation record) async {
    // onay değerini belirler
    final confirm = await showDialog<bool>(
        // context bilgisini belirler
        context: context,
        // İçeriği oluşturan fonksiyonu belirler
        builder: (context) => AlertDialog(
                // scrollable bilgisini belirler
                scrollable: true,
                // Başlığı belirler
                title: const Text('Bu planı iptal edelim mi?'),
                // metin constructorını tanımlar
                content: const Text(
                    // İlgili metin değerini belirler
                    'Cihazınızdaki kayıt iptal edildi olarak saklanır. Tarihler yeniden açılır. Ödeme veya iade yapılmaz.'),
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
                      child: const Text('Evet, iptal et'))
                ]));
    // Widget hâlâ ekrandaysa işlemi sürdürür
    if (confirm == true && mounted) {
      // Asenkron işlemin tamamlanmasını bekler
      await rentalAction(context, () => widget.controller.cancel(record.id));
    }
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
        // kayıtlar değerini belirler
        final records = data.plans
            // Koşula uyan elemanları filtreler
            .where((r) =>
                // filtre değerini günceller
                _filter == 'all' ||
                // Koşul veya parametre ifadesini devam ettirir
                (_filter == 'cancelled' ? r.cancelled : !r.cancelled))
            // Sonucu listeye dönüştürür
            .toList();
        // Hesaplanan sonucu geri döndürür
        return StudioPage(children: [
          // sayfa heading nesnesi oluşturur
          PageHeading(
              // eyebrow bilgisini belirler
              eyebrow: 'Yolculuklarınız',
              // Başlığı belirler
              title: 'Rezervasyonlarım',
              // açıklama bilgisini belirler
              description:
                  // İlgili metin değerini belirler
                  'Tarihleriniz, seçtiğiniz araçlar ve tüm yolculuk planlarınız.',
              // action bilgisini belirler
              action: OutlinedButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: widget.onDiscover,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.add, size: 18),
                  // Görünen etiketi belirler
                  label: const Text('Yeni rezervasyon'))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Sığmayan öğeleri alt satıra geçirir
          Wrap(spacing: 10, runSpacing: 10, children: [
            // Listedeki öğeleri veya indeksleri sırayla dolaşır
            for (final f in [
              // Koşul veya parametre ifadesini devam ettirir
              ('all', 'Tümü (${data.plans.length})'),
              // Koşul veya parametre ifadesini devam ettirir
              (
                // İlgili metin değerini belirler
                'active',
                // İlgili metin değerini belirler
                'Planlanan (${data.plans.where((r) => !r.cancelled).length})'
              ),
              // Koşul veya parametre ifadesini devam ettirir
              ('cancelled', 'İptal edilen')
            ])
              // Seçilebilir filtre etiketi oluşturur
              ChoiceChip(
                  // Görünen etiketi belirler
                  label: Text(f.$2),
                  // Seçili olup olmadığını belirler
                  selected: _filter == f.$1,
                  // Seçim değişince çalışacak fonksiyonu belirler
                  onSelected: (_) => setState(() => _filter = f.$1)),
          ]),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Liste veya metin boşsa koşulu çalıştırır
          if (records.isEmpty) ...[
            // studio panel nesnesi oluşturur
            StudioPanel(
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                  // Simgeyi gösterir
                  Icon(Icons.route_outlined,
                      // Boyutu belirler
                      size: 32, color: Theme.of(context).colorScheme.primary),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 16),
                  // Metni gösterir
                  Text(
                      // İlgili verinin özelliğini kontrol eder
                      data.plans.isEmpty
                          // Koşul doğruysa bu değeri seçer
                          ? 'İlk yolculuğunuz buradan başlasın.'
                          // Koşul yanlışsa bu değeri seçer
                          : 'Bu listede henüz bir plan yok.',
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.titleLarge),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 12),
                  // Metni gösterir
                  const Text(
                      // İlgili metin değerini belirler
                      'Aracınızı seçin, tarihlerinizi belirleyin. Kaydettiğiniz planlar burada görünsün.'),
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 18),
                  // Dolgulu buton oluşturur
                  FilledButton(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: widget.onDiscover,
                      // İçerikte gösterilecek widgetı belirler
                      child: const Text('Araçları keşfet')),
                ])),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 28),
            // Metni gösterir
            Text('Bir sonraki rotanız için',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.titleLarge),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 16),
            // kiralama car grid nesnesi oluşturur
            RentalCarGrid(
                // Araç listesini gönderir
                vehicles: state.repository.catalog.take(3).toList(),
                // favoriler bilgisini belirler
                favorites: data.favorites,
                // open için callback belirler
                onOpen: widget.onOpen,
                // favori için callback belirler
                onFavorite: !state.ready || state.busy
                    // Koşul doğruysa bu değeri seçer
                    ? null
                    // Koşul yanlışsa bu değeri seçer
                    : (v) => rentalAction(context, () => state.favorite(v.id))),
          // Önceki ifadeyi tamamlar
          ] else
            // Listedeki öğeleri veya indeksleri sırayla dolaşır
            for (final record in records)
              // İçerik etrafına boşluk bırakır
              Padding(
                  // İç boşlukları ayarlar
                  padding: const EdgeInsets.only(bottom: 20),
                  // İçerikte gösterilecek widgetı belirler
                  child: RentalPlanCard(
                      // kayıt bilgisini belirler
                      record: record,
                      // Araç bilgisini gönderir
                      vehicle: state.repository.vehicle(record.vehicleId),
                      // iptal için callback belirler
                      onCancel: state.busy || !state.ready
                          // Koşul doğruysa bu değeri seçer
                          ? null
                          // Koşul yanlışsa bu değeri seçer
                          : () => _cancel(record))),
        ]);
      });
}

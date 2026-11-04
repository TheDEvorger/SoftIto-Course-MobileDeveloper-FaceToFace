// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// action durum dosyasını ekler
import '../../../shared/design/action_state.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// rezervasyon controller dosyasını ekler
import '../application/reservation_controller.dart';
// rezervasyon dosyasını ekler
import '../domain/reservation.dart';
// rezervasyonlar ekran ekranının değişen durumunu yönetir
class ReservationsScreen extends StatefulWidget {
  // rezervasyonlar ekran nesnesi oluşturur
  const ReservationsScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // bağlantı bilgisini zorunlu alır
      required this.connected,
      // olay connect bilgisini zorunlu alır
      required this.onConnect,
      // olay discover bilgisini zorunlu alır
      required this.onDiscover,
      // olay changed bilgisini zorunlu alır
      required this.onChanged});
  // controller bilgisini tutar
  final ReservationController controller;
  // bağlantı bilgisini tutar
  final bool connected;
  // olay changed bilgisini tutar
  final VoidCallback onConnect, onDiscover, onChanged;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}
// rezervasyonlar ekran durum ekranının durumunu yöneten sınıf
class _ReservationsScreenState extends State<ReservationsScreen> {
  // filtre değerini belirler
  String _filter = 'all';
  // bekleyen değerini tanımlar
  final Set<String> _pending = {};
  // iptal işlemini asenkron yürütür
  Future<void> _cancel(String id) async {
    // onay değerini belirler
    final confirm = await showDialog<bool>(
        // context bilgisini belirler
        context: context,
        // İçeriği oluşturan fonksiyonu belirler
        builder: (context) => AlertDialog(
                // Başlığı belirler
                title: const Text('Planınızı iptal edelim mi?'),
                // metin constructorını tanımlar
                content: const Text(
                    // İlgili metin değerini belirler
                    'Rezervasyon iptal edildi olarak saklanır ve araç bu tarihlerde yeniden müsait olur. Ödeme veya iade işlemi yapılmaz.'),
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
                      child: const Text('İptal et'))
                ]));
    // Widget kaldırılmışsa işlemi durdurur
    if (confirm != true || !mounted) return;
    // Değişen verileri ekrana bildirir
    setState(() => _pending.add(id));
    // Hata oluşabilecek işlemleri dener
    try {
      // Asenkron işlemin tamamlanmasını bekler
      await widget.controller.cancel(id);
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) widget.onChanged();
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) {
        // Ekranda kısa bilgi mesajı gösterir
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // content bilgisini belirler
            content: Text(error is ApiException
                // Koşul doğruysa bu değeri seçer
                ? error.message
                // Koşul yanlışsa bu değeri seçer
                : 'İptal işlemi tamamlanamadı.')));
      }
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _pending.remove(id));
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
        // kayıtlar değerini belirler
        final records = state.records
            // Koşula uyan elemanları filtreler
            .where((r) =>
                // filtre değerini günceller
                _filter == 'all' ||
                // Koşul veya parametre ifadesini devam ettirir
                (_filter == 'active' ? !r.cancelled : r.cancelled))
            // Sonucu listeye dönüştürür
            .toList();
        // Hesaplanan sonucu geri döndürür
        return StudioPage(children: [
          // sayfa heading nesnesi oluşturur
          PageHeading(
              // eyebrow bilgisini belirler
              eyebrow: 'Yolculuklar / Rezervasyonlar',
              // Başlığı belirler
              title: 'Sıradaki güzel planınız.',
              // açıklama bilgisini belirler
              description:
                  // İlgili metin değerini belirler
                  'Yolculuk takviminiz, rezervasyonlarınız ve geçmiş kayıtlarınız.',
              // action bilgisini belirler
              action: OutlinedButton.icon(
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: widget.onDiscover,
                  // Butonun veya öğenin simgesini belirler
                  icon: const Icon(Icons.add, size: 17),
                  // Görünen etiketi belirler
                  label: const Text('Yeni yolculuk planla'))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 32),
          // Koşul doğruysa bu işlemi çalıştırır
          if (!widget.connected)
            // action durum nesnesi oluşturur
            ActionState(
                // Başlığı belirler
                title: 'Planlarınızı bir araya getirin.',
                // mesaj bilgisini belirler
                message:
                    // İlgili metin değerini belirler
                    'Kayıtlı rezervasyonları görmek için çalışma alanınıza bağlanın.',
                // Butonun veya öğenin simgesini belirler
                icon: Icons.event_note_outlined,
                // action bilgisini belirler
                action: widget.onConnect,
                // Görünen etiketi belirler
                label: 'Çalışma alanına bağlan')
          // Önceki koşul sağlanmazsa bu bölümü çalıştırır
          else ...[
            // Sığmayan öğeleri alt satıra geçirir
            Wrap(
                // Hizalamayı belirler
                alignment: WrapAlignment.spaceBetween,
                // Öğeler arasındaki boşluğu belirler
                spacing: 20,
                // Satırlar arasındaki boşluğu belirler
                runSpacing: 12,
                // İçerideki elemanları listeler
                children: [
                  // Sığmayan öğeleri alt satıra geçirir
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    // Listedeki öğeleri veya indeksleri sırayla dolaşır
                    for (final f in const [
                      // Koşul veya parametre ifadesini devam ettirir
                      ('all', 'Tümü'),
                      // Koşul veya parametre ifadesini devam ettirir
                      ('active', 'Aktif planlar'),
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
                  // Simge butonu oluşturur
                  IconButton(
                      // Butona basılınca çalışacak fonksiyonu belirler
                      onPressed: state.loading ? null : state.load,
                      // Butonun açıklama metnini belirler
                      tooltip: 'Rezervasyonları yenile',
                      // Butonun veya öğenin simgesini belirler
                      icon: const Icon(Icons.refresh)),
                ]),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 24),
            // Koşul doğruysa bu işlemi çalıştırır
            if (state.loading)
              // Yatay ilerleme çubuğu oluşturur
              const LinearProgressIndicator()
            // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
            else if (state.error != null)
              // action durum nesnesi oluşturur
              ActionState(
                  // Başlığı belirler
                  title: 'Planlar yüklenemedi.',
                  // mesaj bilgisini belirler
                  message: state.error!,
                  // Butonun veya öğenin simgesini belirler
                  icon: Icons.wifi_off_outlined,
                  // action bilgisini belirler
                  action: state.load,
                  // Görünen etiketi belirler
                  label: 'Yeniden dene')
            // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
            else if (records.isEmpty)
              // action durum nesnesi oluşturur
              ActionState(
                  // Başlığı belirler
                  title: 'Takviminizde yeni bir sayfa.',
                  // mesaj bilgisini belirler
                  message:
                      // İlgili metin değerini belirler
                      'Aracınızı ve tarihlerinizi seçin. Kaydettiğiniz rezervasyonlar burada görünsün.',
                  // Butonun veya öğenin simgesini belirler
                  icon: Icons.route_outlined,
                  // action bilgisini belirler
                  action: widget.onDiscover,
                  // Görünen etiketi belirler
                  label: 'Araçları keşfet')
            // Önceki ifadeyi tamamlar
            else
              // Listedeki öğeleri veya indeksleri sırayla dolaşır
              for (final record in records)
                // İçerik etrafına boşluk bırakır
                Padding(
                    // İç boşlukları ayarlar
                    padding: const EdgeInsets.only(bottom: 18),
                    // İçerikte gösterilecek widgetı belirler
                    child: _card(context, record)),
          ],
        ]);
      });
  // kart işlemini gerçekleştirir
  Widget _card(BuildContext context, Reservation record) =>
      // studio panel nesnesi oluşturur
      StudioPanel(child: LayoutBuilder(builder: (context, constraints) {
        // tarihler değerini belirler
        final dates = MaterialLocalizations.of(context);
        // content değerini belirler
        final content =
            // Elemanları alt alta dizer
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Elemanları yan yana dizer
          Row(children: [
            // Simgeyi gösterir
            Icon(
                // Önceki ifadeyi tamamlar
                record.cancelled
                    // Koşul doğruysa bu değeri seçer
                    ? Icons.cancel_outlined
                    // Koşul yanlışsa bu değeri seçer
                    : Icons.event_available_outlined,
                // Boyutu belirler
                size: 16,
                // Rengi belirler
                color: Theme.of(context).colorScheme.primary),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 7),
            // Kalan alanı doldurur
            Expanded(
                // İçerikte gösterilecek widgetı belirler
                child: Text(
                    // Önceki ifadeyi tamamlar
                    record.cancelled ? 'İptal edildi' : 'Rezerve edildi',
                    // Görünüm stilini belirler
                    style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Rengi belirler
                        color: Theme.of(context).colorScheme.primary)))
          ]),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Metni gösterir
          Text(record.vehicleName,
              // Görünüm stilini belirler
              style: Theme.of(context).textTheme.titleLarge),
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
              '${rentalDays(record.start, record.end)} gün · ${record.totalLabel}',
              // Görünüm stilini belirler
              style: const TextStyle(fontWeight: FontWeight.w600)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 8),
          // Metni gösterir
          Text('Kayıt: ${record.id}',
              // Görünüm stilini belirler
              style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 11,
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]);
        // action değerini belirler
        final action = OutlinedButton(
            // Butona basılınca çalışacak fonksiyonu belirler
            onPressed:
                // İlgili işlemi çalıştırır
                _pending.contains(record.id) ? null : () => _cancel(record.id),
            // İçerikte gösterilecek widgetı belirler
            child: Text(_pending.contains(record.id)
                // Koşul doğruysa bu değeri seçer
                ? 'İşleniyor…'
                // Koşul yanlışsa bu değeri seçer
                : 'Rezervasyonu iptal et'));
        // Koşul doğruysa bu işlemi çalıştırır
        if (constraints.maxWidth < 700) {
          // Elemanları alt alta dizer
          return Column(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçerideki elemanları listeler
              children: [
                // Önceki ifadeyi tamamlar
                content,
                // sized box constructorını tanımlar
                if (!record.cancelled) ...[const SizedBox(height: 22), action]
              ]);
        }
        // Elemanları yan yana dizer
        return Row(children: [
          // Görünüm için kutu oluşturur
          Container(
              // Genişliği belirler
              width: 70,
              // Yüksekliği belirler
              height: 80,
              // Hizalamayı belirler
              alignment: Alignment.center,
              // Kutunun görünümünü ayarlar
              decoration: BoxDecoration(
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // Köşeleri yuvarlar
                  borderRadius: BorderRadius.circular(18)),
              // İçerikte gösterilecek widgetı belirler
              child: Text(
                  // İlgili metin değerini belirler
                  '${record.start.day.toString().padLeft(2, '0')}\n${record.start.month.toString().padLeft(2, '0')}',
                  // Metnin hizasını ayarlar
                  textAlign: TextAlign.center,
                  // Görünüm stilini belirler
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(width: 24),
          // Kalan alanı doldurur
          Expanded(child: content),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(width: 20),
          // Koşul doğruysa bu işlemi çalıştırır
          if (!record.cancelled) action
        ]);
      }));
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Flutter servislerini ekler
import 'package:flutter/services.dart';
// empty durum dosyasını projeye ekler
import '../../../core/widgets/empty_state.dart';
// info banner dosyasını projeye ekler
import '../../../core/widgets/info_banner.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum filtre bar dosyasını projeye ekler
import '../../../core/widgets/status_filter_bar.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// demo numune dosyasını projeye ekler
import '../../../data/models/demo_specimen.dart';
// ziyaret işlemler dosyasını projeye ekler
import '../../queue_management/controllers/visit_actions.dart';
// ziyaret detail view dosyasını projeye ekler
import '../../queue_management/views/visit_detail_view.dart';
// sample tracking controller dosyasını projeye ekler
import '../controllers/sample_tracking_controller.dart';
// numune row dosyasını projeye ekler
import '../models/specimen_row.dart';
// numune card dosyasını projeye ekler
import '../widgets/specimen_card.dart';
// SampleTrackingView ekranını oluşturan sınıf
class SampleTrackingView extends StatefulWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const SampleTrackingView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // işlemler bilgisini zorunlu tutar
    required this.actions,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın State sınıfını oluşturur
  State<SampleTrackingView> createState() => _SampleTrackingViewState();
}
// Widgetın değişen durumunu yöneten State sınıfı
class _SampleTrackingViewState extends State<SampleTrackingView> {
  // controller bilgisini tutar
  late final SampleTrackingController _controller;
  // arama ctrl bilgisini tutar
  late final TextEditingController _searchCtrl;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın ilgili işlemini çağırır
    super.initState();
    // SampleTrackingController nesnesini oluşturur
    _controller = SampleTrackingController();
    // TextEditingController nesnesini oluşturur
    _searchCtrl = TextEditingController();
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    _controller.dispose();
    // İlgili controller veya notifierı temizler
    _searchCtrl.dispose();
    // Üst sınıfın ilgili işlemini çağırır
    super.dispose();
  }
  // copy işlemini asenkron çalıştırır
  Future<void> _copy(String code) async {
    // Asenkron işlemin tamamlanmasını bekler
    await Clipboard.setData(ClipboardData(text: code));
    // Widget hâlâ ekrandaysa işleme devam eder
    if (!mounted) return;
    // İlgili nesne üzerinden metodu çağırır
    ScaffoldMessenger.of(context)
      // Aynı nesne üzerinde işlemi sürdürür
      ..hideCurrentSnackBar()
      // Ekranda kısa bilgilendirme mesajı gösterir
      ..showSnackBar(SnackBar(content: Text('$code panoya kopyalandı.')));
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // sayfa frame değerini hesaplar veya döndürür
    return PageFrame(
      // İçeride gösterilecek widgetı belirler
      child: ValueListenableBuilder<ClinicState>(
        // Değişimi takip edilecek değeri dinler
        valueListenable: widget.store.state,
        // Güncel verilere göre arayüzü oluşturur
        builder: (BuildContext context, ClinicState state, _) {
          // awaiting değerini tanımlar
          final int awaiting = SampleTrackingController.countByStatus(
              // İlgili alanın değerini veya görünümünü ayarlar
              state, SpecimenStatus.awaitingDelivery);
          // column değerini hesaplar veya döndürür
          return Column(
            // Elemanların çapraz hizasını belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Alt widgetları listeler
            children: <Widget>[
              // PageHeader nesnesini oluşturur veya kullanır
              PageHeader(
                // Başlığını belirler
                title: 'Numune Takibi',
                // Alt başlığını belirler
                subtitle: '${state.specimens.length} kurgusal numune · '
                    // Bu metin değerini kullanır
                    '$awaiting teslim bekliyor',
              ),
              // İçeriğin çevresine boşluk bırakır
              Padding(
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // İçeride gösterilecek widgetı belirler
                child: TextField(
                  // Widgetın kimlik bilgisini belirler
                  key: const Key('specimen_search'),
                  // İlgili controllerı widgeta gönderir
                  controller: _searchCtrl,
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: _controller.search,
                  // Görünüm ayarlarını oluşturur
                  decoration: const InputDecoration(
                    // Giriş alanının örnek yazısını belirler
                    hintText: 'Numune kodu, sıra no veya hasta ara',
                    // prefix simge bilgisini belirler
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 12),
              // Değer değişimlerini dinleyerek arayüzü günceller
              ValueListenableBuilder<SpecimenStatus?>(
                // Değişimi takip edilecek değeri dinler
                valueListenable: _controller.filter,
                // Güncel verilere göre arayüzü oluşturur
                builder: (BuildContext context, SpecimenStatus? filter, _) {
                  // Hesaplanan sonucu döndürür
                  return StatusFilterBar<SpecimenStatus>(
                    // options bilgisini belirler
                    options: _filterOptions(state),
                    // Seçili olup olmadığını belirler
                    selected: filter,
                    // Seçilince çalışacak fonksiyonu belirler
                    onSelected: _controller.setFilter,
                  );
                },
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 8),
              // Kalan alanı doldurmasını sağlar
              Expanded(child: _buildList(state)),
            ],
          );
        },
      ),
    );
  }
  // filtre options değerini hesaplar veya döndürür
  List<FilterOption<SpecimenStatus>> _filterOptions(ClinicState state) {
    // Hesaplanan sonucu döndürür
    return <FilterOption<SpecimenStatus>>[
      // FilterOption nesnesini oluşturur veya kullanır
      FilterOption<SpecimenStatus>(
        // Gösterilen değeri belirler
        value: null,
        // Gösterilecek etiketi belirler
        label: 'Tümü',
        // sayı bilgisini belirler
        count: state.specimens.length,
      ),
      // Listedeki elemanları sırayla dolaşır
      for (final SpecimenStatus s in SpecimenStatus.values)
        // FilterOption nesnesini oluşturur veya kullanır
        FilterOption<SpecimenStatus>(
          // Gösterilen değeri belirler
          value: s,
          // Gösterilecek etiketi belirler
          label: s.label,
          // sayı bilgisini belirler
          count: SampleTrackingController.countByStatus(state, s),
          // Gösterilecek simgeyi belirler
          icon: s.icon,
        ),
    ];
  }
  // build list bölümünün arayüzünü oluşturur
  Widget _buildList(ClinicState state) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<String>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: _controller.query,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, String query, _) {
        // Hesaplanan sonucu döndürür
        return ValueListenableBuilder<SpecimenStatus?>(
          // Değişimi takip edilecek değeri dinler
          valueListenable: _controller.filter,
          // Güncel verilere göre arayüzü oluşturur
          builder: (BuildContext context, SpecimenStatus? filter, _) {
            // rows değerini tanımlar
            final List<SpecimenRow> rows = SampleTrackingController.apply(
                // İlgili alanın değerini veya görünümünü ayarlar
                state, query: query, filter: filter);
            // list view değerini hesaplar veya döndürür
            return ListView(
              // İç boşlukları belirler
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              // Alt widgetları listeler
              children: <Widget>[
                // Constructor, yeni nesnenin bilgilerini alır
                const InfoBanner(
                  // Gösterilecek simgeyi belirler
                  icon: Icons.qr_code_scanner_rounded,
                  // Başlığını belirler
                  title: 'Bu sürümde barkod / LIS bağlantısı yok',
                  // mesaj bilgisini belirler
                  message: 'Numune kodları kurgusaldır. Gerçek barkod/QR '
                      // Bu metin değerini kullanır
                      'tarama, etiket basımı ve laboratuvar sistemi '
                      // Bu metin değerini kullanır
                      'entegrasyonu ileriki sürümler için planlanmıştır.',
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 12),
                // İlgili alan veya liste boşsa kontrol eder
                if (rows.isEmpty)
                  // EmptyState nesnesini oluşturur veya kullanır
                  EmptyState(
                    // Gösterilecek simgeyi belirler
                    icon: Icons.science_outlined,
                    // Başlığını belirler
                    title: 'Numune bulunamadı',
                    // mesaj bilgisini belirler
                    message: state.specimens.isEmpty
                        // Koşul doğruysa bu değeri kullanır
                        ? 'Kan alma işlemi tamamlanınca numuneler burada görünür.'
                        // Koşul yanlışsa bu değeri kullanır
                        : 'Arama veya filtre ile eşleşen numune yok.',
                  )
                // Önceki koşul sağlanmazsa burası çalışır
                else
                  // Listedeki elemanları sırayla dolaşır
                  for (final SpecimenRow row in rows)
                    // İçeriğin çevresine boşluk bırakır
                    Padding(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.only(bottom: 10),
                      // İçeride gösterilecek widgetı belirler
                      child: SpecimenCard(
                        // Widgetın kimlik bilgisini belirler
                        key: ValueKey<String>(row.specimen.id),
                        // row bilgisini belirler
                        row: row,
                        // copy işlemi için callback gönderir
                        onCopy: () => _copy(row.specimen.code),
                        // open detail işlemi fonksiyonunu bağlar
                        onOpenDetail: row.visit == null
                            // Koşul doğruysa bu değeri kullanır
                            ? null
                            // Koşul yanlışsa bu değeri kullanır
                            : () => VisitDetailView.open(context, widget.store,
                                // İlgili alanın değerini veya görünümünü ayarlar
                                widget.actions, row.visit!.id),
                        // deliver işlemi için callback gönderir
                        onDeliver: () {
                          // Değer null değilse işlemi çalıştırır
                          if (row.visit != null) {
                            // İlgili nesne üzerinden metodu çağırır
                            widget.actions.advance(context, row.visit!);
                          }
                        },
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
  }
}

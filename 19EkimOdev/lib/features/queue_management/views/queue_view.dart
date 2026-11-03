// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// empty durum dosyasını projeye ekler
import '../../../core/widgets/empty_state.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum filtre bar dosyasını projeye ekler
import '../../../core/widgets/status_filter_bar.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// sıra controller dosyasını projeye ekler
import '../controllers/queue_controller.dart';
// ziyaret işlemler dosyasını projeye ekler
import '../controllers/visit_actions.dart';
// ziyaret card dosyasını projeye ekler
import '../widgets/visit_card.dart';
// ziyaret detail view dosyasını projeye ekler
import 'visit_detail_view.dart';
// QueueView ekranını oluşturan sınıf
class QueueView extends StatefulWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const QueueView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // controller bilgisini zorunlu tutar
    required this.controller,
    // işlemler bilgisini zorunlu tutar
    required this.actions,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // controller bilgisini tutar
  final QueueController controller;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın State sınıfını oluşturur
  State<QueueView> createState() => _QueueViewState();
}
// Widgetın değişen durumunu yöneten State sınıfı
class _QueueViewState extends State<QueueView> {
  // arama ctrl bilgisini tutar
  late final TextEditingController _searchCtrl;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın ilgili işlemini çağırır
    super.initState();
    // TextEditingController nesnesini oluşturur
    _searchCtrl = TextEditingController(text: widget.controller.query.value);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    _searchCtrl.dispose();
    // Üst sınıfın ilgili işlemini çağırır
    super.dispose();
  }
  // clear arama işlemini çalıştırır
  void _clearSearch() {
    // İlgili alan veya listeyi temizler
    _searchCtrl.clear();
    // İlgili nesne üzerinden metodu çağırır
    widget.controller.search('');
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
          // column değerini hesaplar veya döndürür
          return Column(
            // Elemanların çapraz hizasını belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Alt widgetları listeler
            children: <Widget>[
              // PageHeader nesnesini oluşturur veya kullanır
              PageHeader(
                // Başlığını belirler
                title: 'Kan Alma Sırası',
                // Alt başlığını belirler
                subtitle: 'Bugün ${state.visits.length} kayıt · '
                    // Bu metin değerini kullanır
                    '${state.countByStatus(CollectionStatus.waiting)} bekliyor',
                // Sağdaki widgetı belirler
                trailing: FilledButton.tonalIcon(
                  // Widgetın kimlik bilgisini belirler
                  key: const Key('queue_call_next'),
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: state.nextWaiting == null
                      // Koşul doğruysa bu değeri kullanır
                      ? null
                      // Koşul yanlışsa bu değeri kullanır
                      : () => widget.actions.callNext(context),
                  // Gösterilecek simgeyi belirler
                  icon: const Icon(Icons.campaign_outlined),
                  // Gösterilecek etiketi belirler
                  label: const Text('Çağır'),
                ),
              ),
              // arama field fonksiyonunu çağırır
              _SearchField(
                // İlgili controllerı widgeta gönderir
                controller: _searchCtrl,
                // Değer değişince çalışacak fonksiyonu belirler
                onChanged: widget.controller.search,
                // clear işlemi fonksiyonunu bağlar
                onClear: _clearSearch,
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 12),
              // Değer değişimlerini dinleyerek arayüzü günceller
              ValueListenableBuilder<CollectionStatus?>(
                // Değişimi takip edilecek değeri dinler
                valueListenable: widget.controller.filter,
                // Güncel verilere göre arayüzü oluşturur
                builder: (BuildContext context, CollectionStatus? filter, _) {
                  // Hesaplanan sonucu döndürür
                  return StatusFilterBar<CollectionStatus>(
                    // options bilgisini belirler
                    options: _filterOptions(state),
                    // Seçili olup olmadığını belirler
                    selected: filter,
                    // Seçilince çalışacak fonksiyonu belirler
                    onSelected: widget.controller.setFilter,
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
  List<FilterOption<CollectionStatus>> _filterOptions(ClinicState state) {
    // Hesaplanan sonucu döndürür
    return <FilterOption<CollectionStatus>>[
      // FilterOption nesnesini oluşturur veya kullanır
      FilterOption<CollectionStatus>(
        // Gösterilen değeri belirler
        value: null,
        // Gösterilecek etiketi belirler
        label: 'Tümü',
        // sayı bilgisini belirler
        count: state.visits.length,
      ),
      // Listedeki elemanları sırayla dolaşır
      for (final CollectionStatus s in CollectionStatus.values)
        // FilterOption nesnesini oluşturur veya kullanır
        FilterOption<CollectionStatus>(
          // Gösterilen değeri belirler
          value: s,
          // Gösterilecek etiketi belirler
          label: s.label,
          // sayı bilgisini belirler
          count: state.countByStatus(s),
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
      valueListenable: widget.controller.query,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, String query, _) {
        // Hesaplanan sonucu döndürür
        return ValueListenableBuilder<CollectionStatus?>(
          // Değişimi takip edilecek değeri dinler
          valueListenable: widget.controller.filter,
          // Güncel verilere göre arayüzü oluşturur
          builder: (BuildContext context, CollectionStatus? filter, _) {
            // ziyaretler değerini tanımlar
            final List<CollectionVisit> visits =
                // İlgili nesne üzerinden metodu çağırır
                QueueController.apply(state, query: query, filter: filter);
            // İlgili alan veya liste boşsa kontrol eder
            if (visits.isEmpty) {
              // single alt eleman scroll view değerini hesaplar veya döndürür
              return SingleChildScrollView(
                // İçeride gösterilecek widgetı belirler
                child: EmptyState(
                  // Gösterilecek simgeyi belirler
                  icon: Icons.manage_search_rounded,
                  // Başlığını belirler
                  title: 'Kayıt bulunamadı',
                  // mesaj bilgisini belirler
                  message: query.trim().isNotEmpty || filter != null
                      // Koşul doğruysa bu değeri kullanır
                      ? 'Arama veya filtre ile eşleşen bir kayıt yok.'
                      // Koşul yanlışsa bu değeri kullanır
                      : 'Bugün için henüz kayıt yok. Yeni hasta ekleyin.',
                  // action bilgisini belirler
                  action: query.trim().isNotEmpty || filter != null
                      // Koşul doğruysa bu değeri kullanır
                      ? OutlinedButton.icon(
                          // Basılınca çalışacak fonksiyonu belirler
                          onPressed: () {
                            // clear arama fonksiyonunu çağırır
                            _clearSearch();
                            // Seçilen filtreyi uygular
                            widget.controller.setFilter(null);
                          },
                          // Gösterilecek simgeyi belirler
                          icon: const Icon(Icons.filter_alt_off_outlined),
                          // Gösterilecek etiketi belirler
                          label: const Text('Filtreleri Temizle'),
                        )
                      // Koşul yanlışsa bu değeri kullanır
                      : null,
                ),
              );
            }
            // Kaydırılabilir listeyi döndürür
            return ListView.separated(
              // İç boşlukları belirler
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
              // Listedeki eleman sayısını belirler
              itemCount: visits.length,
              // separator oluşturma fonksiyonu bilgisini belirler
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              // Her liste elemanı için widget oluşturur
              itemBuilder: (BuildContext context, int index) {
                // ziyaret değerini tanımlar
                final CollectionVisit visit = visits[index];
                // ziyaret card değerini hesaplar veya döndürür
                return VisitCard(
                  // Widgetın kimlik bilgisini belirler
                  key: ValueKey<String>(visit.id),
                  // ziyaret bilgisini belirler
                  visit: visit,
                  // hasta bilgisini belirler
                  patient: state.patientOf(visit),
                  // açma işlemi için callback gönderir
                  onOpen: () => VisitDetailView.open(
                      // İşlem için ekran bağlamını gönderir
                      context, widget.store, widget.actions, visit.id),
                  // durumu ilerletme işlemi için callback gönderir
                  onAdvance: () => widget.actions.advance(context, visit),
                  // cancel işlemi için callback gönderir
                  onCancel: () => widget.actions.cancel(context, visit),
                );
              },
            );
          },
        );
      },
    );
  }
}
// _SearchField sınıfını tanımlar
class _SearchField extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _SearchField({
    // controller bilgisini zorunlu tutar
    required this.controller,
    // değişim işlemi bilgisini zorunlu tutar
    required this.onChanged,
    // clear işlemi bilgisini zorunlu tutar
    required this.onClear,
  });
  // controller bilgisini tutar
  final TextEditingController controller;
  // değişim işlemi bilgisini tutar
  final ValueChanged<String> onChanged;
  // clear işlemi bilgisini tutar
  final VoidCallback onClear;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // iç boşluk değerini hesaplar veya döndürür
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // İçeride gösterilecek widgetı belirler
      child: ValueListenableBuilder<TextEditingValue>(
        // Değişimi takip edilecek değeri dinler
        valueListenable: controller,
        // Güncel verilere göre arayüzü oluşturur
        builder: (BuildContext context, TextEditingValue value, _) {
          // metin field değerini hesaplar veya döndürür
          return TextField(
            // Widgetın kimlik bilgisini belirler
            key: const Key('queue_search'),
            // İlgili controllerı widgeta gönderir
            controller: controller,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: onChanged,
            // Klavye işlem tuşunu belirler
            textInputAction: TextInputAction.search,
            // Görünüm ayarlarını oluşturur
            decoration: InputDecoration(
              // Giriş alanının örnek yazısını belirler
              hintText: 'Ad, demo kod, sıra no (${Formatters.queueNumber(7)}) '
                  // Bu metin değerini kullanır
                  'veya birim ara',
              // prefix simge bilgisini belirler
              prefixIcon: const Icon(Icons.search_rounded),
              // suffix simge bilgisini belirler
              suffixIcon: value.text.isEmpty
                  // Koşul doğruysa bu değeri kullanır
                  ? null
                  // Simge butonu oluşturur
                  : IconButton(
                      // Butonun açıklamasını belirler
                      tooltip: 'Aramayı temizle',
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: onClear,
                      // Gösterilecek simgeyi belirler
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          );
        },
      ),
    );
  }
}

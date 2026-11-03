// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import '../../../core/theme/app_theme.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// ziyaret işlemler dosyasını projeye ekler
import '../../queue_management/controllers/visit_actions.dart';
// ziyaret detail view dosyasını projeye ekler
import '../../queue_management/views/visit_detail_view.dart';
// dashboard summary dosyasını projeye ekler
import '../models/dashboard_summary.dart';
// activity cards dosyasını projeye ekler
import '../widgets/activity_cards.dart';
// hero panel dosyasını projeye ekler
import '../widgets/hero_panel.dart';
// stat card dosyasını projeye ekler
import '../widgets/stat_card.dart';
// workflow card dosyasını projeye ekler
import '../widgets/workflow_card.dart';
// DashboardView ekranını oluşturan sınıf
class DashboardView extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const DashboardView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // işlemler bilgisini zorunlu tutar
    required this.actions,
    // yeni hasta işlemi bilgisini zorunlu tutar
    required this.onNewPatient,
    // sırayı açma işlemi bilgisini zorunlu tutar
    required this.onOpenQueue,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // yeni hasta işlemi bilgisini tutar
  final VoidCallback onNewPatient;
  // sırayı açma işlemi bilgisini tutar
  final ValueChanged<CollectionStatus?> onOpenQueue;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // sayfa frame değerini hesaplar veya döndürür
    return PageFrame(
      // İçeride gösterilecek widgetı belirler
      child: ValueListenableBuilder<ClinicState>(
        // Değişimi takip edilecek değeri dinler
        valueListenable: store.state,
        // Güncel verilere göre arayüzü oluşturur
        builder: (BuildContext context, ClinicState state, _) {
          // summary değerini tanımlar
          final DashboardSummary summary = DashboardSummary.fromState(state);
          // sonraki değerini tanımlar
          final CollectionVisit? next = state.nextWaiting;
          // layout oluşturma fonksiyonu değerini hesaplar veya döndürür
          return LayoutBuilder(
            // Güncel verilere göre arayüzü oluşturur
            builder: (BuildContext context, BoxConstraints constraints) {
              // wide durumunu kontrol eder
              final bool wide = constraints.maxWidth >= 900;
              // list view değerini hesaplar veya döndürür
              return ListView(
                // İç boşlukları belirler
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
                // Alt widgetları listeler
                children: <Widget>[
                  // HeroPanel nesnesini oluşturur veya kullanır
                  HeroPanel(
                    // today için tarih bilgisini atar
                    today: DateTime.now(),
                    // sonraki ziyaret bilgisini belirler
                    nextVisit: next,
                    // sonraki hasta bilgisini belirler
                    nextPatient: next == null ? null : state.patientOf(next),
                    // waiting sayı bilgisini belirler
                    waitingCount: summary.waiting,
                    // call sonraki işlemi için callback gönderir
                    onCallNext: () => actions.callNext(context),
                    // yeni hasta işlemi fonksiyonunu bağlar
                    onNewPatient: onNewPatient,
                  ),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 20),
                  // stat grid fonksiyonunu çağırır
                  _StatGrid(summary: summary, onOpenQueue: onOpenQueue),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 20),
                  // Koşul sağlanırsa ilgili işlemi yapar
                  if (wide)
                    // Elemanları yan yana dizer
                    Row(
                      // Elemanların çapraz hizasını belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Alt widgetları listeler
                      children: <Widget>[
                        // Kalan alanı doldurmasını sağlar
                        Expanded(
                          // esneklik oranı bilgisini belirler
                          flex: 3,
                          // İçeride gösterilecek widgetı belirler
                          child: _MainColumn(
                              // durum bilgisini belirler
                              state: state,
                              // summary bilgisini belirler
                              summary: summary,
                              // Veri deposunu widgeta gönderir
                              store: store,
                              // İşlem fonksiyonlarını widgeta gönderir
                              actions: actions),
                        ),
                        // Constructor, yeni nesnenin bilgilerini alır
                        const SizedBox(width: 20),
                        // Kalan alanı doldurmasını sağlar
                        Expanded(
                          // esneklik oranı bilgisini belirler
                          flex: 2,
                          // İçeride gösterilecek widgetı belirler
                          child: _recentActivity(context, state),
                        ),
                      ],
                    )
                  // Önceki koşul sağlanmazsa burası çalışır
                  else ...<Widget>[
                    // main column fonksiyonunu çağırır
                    _MainColumn(
                        // durum bilgisini belirler
                        state: state,
                        // summary bilgisini belirler
                        summary: summary,
                        // Veri deposunu widgeta gönderir
                        store: store,
                        // İşlem fonksiyonlarını widgeta gönderir
                        actions: actions),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const SizedBox(height: 16),
                    // recent activity fonksiyonunu çağırır
                    _recentActivity(context, state),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
  // recent activity bölümünün arayüzünü oluşturur
  Widget _recentActivity(BuildContext context, ClinicState state) {
    // recent activity card değerini hesaplar veya döndürür
    return RecentActivityCard(
      // activities bilgisini belirler
      activities: state.activities,
      // ziyareti açma işlemi için callback gönderir
      onOpenVisit: (String id) =>
          // İlgili nesne üzerinden metodu çağırır
          VisitDetailView.open(context, store, actions, id),
    );
  }
}
// _MainColumn sınıfını tanımlar
class _MainColumn extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _MainColumn({
    // durum bilgisini zorunlu tutar
    required this.state,
    // summary bilgisini zorunlu tutar
    required this.summary,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // işlemler bilgisini zorunlu tutar
    required this.actions,
  });
  // durum bilgisini tutar
  final ClinicState state;
  // summary bilgisini tutar
  final DashboardSummary summary;
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // column değerini hesaplar veya döndürür
    return Column(
      // Elemanların çapraz hizasını belirler
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // Alt widgetları listeler
      children: <Widget>[
        // ActiveCallsCard kartını oluşturur
        ActiveCallsCard(
          // durum bilgisini belirler
          state: state,
          // ziyaretler bilgisini belirler
          visits: summary.activeVisits,
          // durumu ilerletme işlemi için callback gönderir
          onAdvance: (CollectionVisit v) => actions.advance(context, v),
          // açma işlemi için callback gönderir
          onOpen: (CollectionVisit v) =>
              // İlgili nesne üzerinden metodu çağırır
              VisitDetailView.open(context, store, actions, v.id),
        ),
        // Constructor, yeni nesnenin bilgilerini alır
        const SizedBox(height: 16),
        // WorkflowCard kartını oluşturur
        WorkflowCard(summary: summary),
      ],
    );
  }
}
// _StatGrid sınıfını tanımlar
class _StatGrid extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _StatGrid({required this.summary, required this.onOpenQueue});
  // summary bilgisini tutar
  final DashboardSummary summary;
  // sırayı açma işlemi bilgisini tutar
  final ValueChanged<CollectionStatus?> onOpenQueue;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan renk şeması bilgisini alır
    final ColorScheme scheme = Theme.of(context).colorScheme;
    // renk paleti değerini tanımlar
    final VenaPalette palette = context.palette;
    // percent değerini tanımlar
    final int percent = (summary.completionRate * 100).round();
    // cards listesini oluşturur
    final List<Widget> cards = <Widget>[
      // StatCard kartını oluşturur
      StatCard(
        // Widgetın kimlik bilgisini belirler
        key: const Key('stat_waiting'),
        // Gösterilecek etiketi belirler
        label: 'Sırada Bekleyen',
        // Gösterilen değeri belirler
        value: summary.waiting,
        // açıklama bilgisini belirler
        caption: 'Çağrılmayı bekliyor',
        // Gösterilecek simgeyi belirler
        icon: Icons.hourglass_top_rounded,
        // Rengini belirler
        color: palette.amber,
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: () => onOpenQueue(CollectionStatus.waiting),
      ),
      // StatCard kartını oluşturur
      StatCard(
        // Widgetın kimlik bilgisini belirler
        key: const Key('stat_active'),
        // Gösterilecek etiketi belirler
        label: 'İşlemde',
        // Gösterilen değeri belirler
        value: summary.active,
        // açıklama bilgisini belirler
        caption: '${summary.called} çağrıldı · ${summary.inProgress} işlemde',
        // Gösterilecek simgeyi belirler
        icon: Icons.vaccines_rounded,
        // Rengini belirler
        color: scheme.primary,
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: () => onOpenQueue(CollectionStatus.inProgress),
      ),
      // StatCard kartını oluşturur
      StatCard(
        // Widgetın kimlik bilgisini belirler
        key: const Key('stat_collected'),
        // Gösterilecek etiketi belirler
        label: 'Numunesi Alınan',
        // Gösterilen değeri belirler
        value: summary.sampleCollected,
        // açıklama bilgisini belirler
        caption: 'Teslim bekliyor',
        // Gösterilecek simgeyi belirler
        icon: Icons.science_rounded,
        // Rengini belirler
        color: palette.primaryDark,
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: () => onOpenQueue(CollectionStatus.sampleCollected),
      ),
      // StatCard kartını oluşturur
      StatCard(
        // Widgetın kimlik bilgisini belirler
        key: const Key('stat_delivered'),
        // Gösterilecek etiketi belirler
        label: 'Teslim Edilen',
        // Gösterilen değeri belirler
        value: summary.delivered,
        // açıklama bilgisini belirler
        caption: '%$percent tamamlandı · ${summary.cancelled} iptal',
        // Gösterilecek simgeyi belirler
        icon: Icons.task_alt_rounded,
        // Rengini belirler
        color: palette.success,
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: () => onOpenQueue(CollectionStatus.delivered),
      ),
    ];
    // layout oluşturma fonksiyonu değerini hesaplar veya döndürür
    return LayoutBuilder(
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, BoxConstraints constraints) {
        // boşluk değerini tanımlar
        const double gap = 12;
        // columns durumunu kontrol eder
        final int columns = constraints.maxWidth >= 720 ? 4 : 2;
        // genişlik değerini tanımlar
        final double width =
            // Kullanılabilir genişliğe göre boyutu hesaplar
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        // wrap değerini hesaplar veya döndürür
        return Wrap(
          // Elemanların arasındaki boşluğu belirler
          spacing: gap,
          // Satırlar arasındaki boşluğu belirler
          runSpacing: gap,
          // Alt widgetları listeler
          children: <Widget>[
            // Listedeki elemanları sırayla dolaşır
            for (final Widget card in cards)
              // Sabit boyut veya boşluk oluşturur
              SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

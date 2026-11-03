// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Flutter servislerini ekler
import 'package:flutter/services.dart';
// app tema dosyasını projeye ekler
import '../../../core/theme/app_theme.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// empty durum dosyasını projeye ekler
import '../../../core/widgets/empty_state.dart';
// info banner dosyasını projeye ekler
import '../../../core/widgets/info_banner.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// demo numune dosyasını projeye ekler
import '../../../data/models/demo_specimen.dart';
// ziyaret işlemler dosyasını projeye ekler
import '../controllers/visit_actions.dart';
// durum timeline dosyasını projeye ekler
import '../widgets/status_timeline.dart';
// VisitDetailView ekranını oluşturan sınıf
class VisitDetailView extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const VisitDetailView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // işlemler bilgisini zorunlu tutar
    required this.actions,
    // ziyaret ID bilgisini zorunlu tutar
    required this.visitId,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // ziyaret ID bilgisini tutar
  final String visitId;
  // open değerini hesaplar veya döndürür
  static Future<void> open(
    // Metodun veya constructorın parametresini tanımlar
    BuildContext context,
    // Metodun veya constructorın parametresini tanımlar
    DemoClinicStore store,
    // Metodun veya constructorın parametresini tanımlar
    VisitActions actions,
    // Metodun veya constructorın parametresini tanımlar
    String visitId,
  ) {
    // Hesaplanan sonucu döndürür
    return Navigator.of(context).push(
      // MaterialPageRoute nesnesini oluşturur veya kullanır
      MaterialPageRoute<void>(
        // Güncel verilere göre arayüzü oluşturur
        builder: (_) =>
            // VisitDetailView ekranını oluşturur
            VisitDetailView(store: store, actions: actions, visitId: visitId),
      ),
    );
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<ClinicState>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: store.state,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, ClinicState state, _) {
        // ziyaret değerini tanımlar
        final CollectionVisit? visit = state.visitById(visitId);
        // Değer null ise işlemi çalıştırır
        if (visit == null) {
          // scaffold değerini hesaplar veya döndürür
          return Scaffold(
            // app bar yazısını gösterir
            appBar: AppBar(title: const Text('İşlem Detayı')),
            // body bilgisini belirler
            body: const EmptyState(
              // Gösterilecek simgeyi belirler
              icon: Icons.search_off_rounded,
              // Başlığını belirler
              title: 'Kayıt bulunamadı',
              // mesaj bilgisini belirler
              message: 'Bu kayıt demo sıfırlandığı için kaldırılmış olabilir.',
            ),
          );
        }
        // hasta değerini tanımlar
        final DemoPatient? patient = state.patientOf(visit);
        // numune değerini tanımlar
        final DemoSpecimen? specimen = state.specimenForVisit(visit.id);
        // scaffold değerini hesaplar veya döndürür
        return Scaffold(
          // app bar bilgisini belirler
          appBar: AppBar(
            // Başlığını belirler
            title: Text('İşlem ${Formatters.queueNumber(visit.queueNumber)}'),
          ),
          // bottom navigation bar bilgisini belirler
          bottomNavigationBar: visit.status.isTerminal
              // Koşul doğruysa bu değeri kullanır
              ? null
              // Koşul yanlışsa bu değeri kullanır
              : _ActionBar(visit: visit, actions: actions),
          // body bilgisini belirler
          body: PageFrame(
            // En fazla genişliği belirler
            maxWidth: 760,
            // İçeride gösterilecek widgetı belirler
            child: ListView(
              // İç boşlukları belirler
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              // Alt widgetları listeler
              children: <Widget>[
                // header card fonksiyonunu çağırır
                _HeaderCard(visit: visit, patient: patient),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 16),
                // SectionCard kartını oluşturur
                SectionCard(
                  // Başlığını belirler
                  title: 'İşlem Akışı',
                  // Gösterilecek simgeyi belirler
                  icon: Icons.timeline_rounded,
                  // İçeride gösterilecek widgetı belirler
                  child: StatusTimeline(visit: visit),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 16),
                // info card fonksiyonunu çağırır
                _InfoCard(visit: visit),
                // Değer null değilse işlemi çalıştırır
                if (specimen != null) ...<Widget>[
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 16),
                  // numune card fonksiyonunu çağırır
                  _SpecimenCard(specimen: specimen),
                ],
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 16),
                // Constructor, yeni nesnenin bilgilerini alır
                const InfoBanner(
                  // uyarı bilgisini belirler
                  warning: true,
                  // Gösterilecek simgeyi belirler
                  icon: Icons.verified_user_outlined,
                  // Başlığını belirler
                  title: 'Klinik prosedür uygulama dışındadır',
                  // mesaj bilgisini belirler
                  message: 'Hasta kimlik doğrulaması ve klinik kontroller, '
                      // Bu metin değerini kullanır
                      'kurumun gerçek prosedürüne göre yapılmalıdır. Bu eğitim '
                      // Bu metin değerini kullanır
                      'demosu bu adımları yapılmış saymaz.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// _HeaderCard kartını oluşturan sınıf
class _HeaderCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _HeaderCard({required this.visit, required this.patient});
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // hasta bilgisini tutar
  final DemoPatient? patient;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // card değerini hesaplar veya döndürür
    return Card(
      // İçeride gösterilecek widgetı belirler
      child: Padding(
        // İç boşlukları belirler
        padding: const EdgeInsets.all(20),
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Alt widgetları listeler
          children: <Widget>[
            // QueueBadge nesnesini oluşturur veya kullanır
            QueueBadge(
              // Gösterilecek etiketi belirler
              label: Formatters.queueNumber(visit.queueNumber),
              // large bilgisini belirler
              large: true,
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 16),
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: Column(
                // Elemanların çapraz hizasını belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alt widgetları listeler
                children: <Widget>[
                  // Metin gösterir
                  Text(patient?.displayName ?? 'Bilinmeyen kayıt',
                      // style bilgisini belirler
                      style: theme.textTheme.titleLarge),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 2),
                  // Metin gösterir
                  Text(
                    // Bu metin değerini kullanır
                    '${patient?.code ?? '-'} · ${patient?.department ?? '-'}',
                    // style bilgisini belirler
                    style: theme.textTheme.bodySmall,
                  ),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 10),
                  // Kaydın durumunu gösteren etiketi oluşturur
                  StatusChip.visit(visit.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// _InfoCard kartını oluşturan sınıf
class _InfoCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _InfoCard({required this.visit});
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // called at değerini tanımlar
    final DateTime? calledAt = visit.statusHistory[CollectionStatus.called];
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Kayıt Bilgileri',
      // Gösterilecek simgeyi belirler
      icon: Icons.assignment_outlined,
      // İçeride gösterilecek widgetı belirler
      child: Column(
        // Alt widgetları listeler
        children: <Widget>[
          // info row fonksiyonunu çağırır
          _InfoRow(
            // Gösterilecek simgeyi belirler
            icon: Icons.login_rounded,
            // Gösterilecek etiketi belirler
            label: 'Kabul saati',
            // Gösterilen değeri belirler
            value: Formatters.shortDateTime(visit.createdAt),
          ),
          // info row fonksiyonunu çağırır
          _InfoRow(
            // Gösterilecek simgeyi belirler
            icon: Icons.event_outlined,
            // Gösterilecek etiketi belirler
            label: 'Randevu',
            // Gösterilen değeri belirler
            value: visit.appointmentAt == null
                // Koşul doğruysa bu değeri kullanır
                ? 'Randevusuz'
                // Koşul yanlışsa bu değeri kullanır
                : Formatters.time(visit.appointmentAt!),
          ),
          // info row fonksiyonunu çağırır
          _InfoRow(
            // Gösterilecek simgeyi belirler
            icon: Icons.timer_outlined,
            // Gösterilecek etiketi belirler
            label: 'Çağrılana kadar bekleme',
            // Gösterilen değeri belirler
            value: calledAt == null
                // Koşul doğruysa bu değeri kullanır
                ? 'Henüz çağrılmadı'
                // Koşul yanlışsa bu değeri kullanır
                : Formatters.duration(visit.createdAt, calledAt),
          ),
          // info row fonksiyonunu çağırır
          _InfoRow(
            // Gösterilecek simgeyi belirler
            icon: Icons.sticky_note_2_outlined,
            // Gösterilecek etiketi belirler
            label: 'Not',
            // Gösterilen değeri belirler
            value: visit.note ?? '—',
          ),
        ],
      ),
    );
  }
}
// _InfoRow sınıfını tanımlar
class _InfoRow extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _InfoRow({required this.icon, required this.label, required this.value});
  // simge bilgisini tutar
  final IconData icon;
  // etiket bilgisini tutar
  final String label;
  // değer bilgisini tutar
  final String value;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // iç boşluk değerini hesaplar veya döndürür
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(vertical: 6),
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // Alt widgetları listeler
        children: <Widget>[
          // Simge gösterir
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(width: 10),
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // esneklik oranı bilgisini belirler
            flex: 2,
            // İçeride gösterilecek widgetı belirler
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(
                // Rengini belirler
                color: theme.colorScheme.onSurfaceVariant)),
          ),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(width: 8),
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // esneklik oranı bilgisini belirler
            flex: 3,
            // İçeride gösterilecek widgetı belirler
            child: Text(value,
                // Metnin hizasını belirler
                textAlign: TextAlign.end, style: theme.textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}
// _SpecimenCard kartını oluşturan sınıf
class _SpecimenCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _SpecimenCard({required this.specimen});
  // numune bilgisini tutar
  final DemoSpecimen specimen;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Kurgusal Numune',
      // Gösterilecek simgeyi belirler
      icon: Icons.science_outlined,
      // Sağdaki widgetı belirler
      trailing: StatusChip.specimen(specimen.status),
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Alt widgetları listeler
        children: <Widget>[
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Seçilebilir metin gösterir
                SelectableText(
                  // kod değerini listeye ekler
                  specimen.code,
                  // style bilgisini belirler
                  style: theme.textTheme.titleMedium?.copyWith(
                    // Yazı tipini belirler
                    fontFamily: 'monospace',
                    // Harfler arasındaki boşluğu ayarlar
                    letterSpacing: 0.5,
                  ),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 2),
                // Metin gösterir
                Text(
                  // Bu metin değerini kullanır
                  'Oluşturulma: ${Formatters.shortDateTime(specimen.createdAt)}',
                  // style bilgisini belirler
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // İlgili işlem butonunu oluşturur
          IconButton.outlined(
            // Butonun açıklamasını belirler
            tooltip: 'Numune kodunu kopyala',
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () async {
              // Asenkron işlemin tamamlanmasını bekler
              await Clipboard.setData(ClipboardData(text: specimen.code));
              // Widget hâlâ ekrandaysa işleme devam eder
              if (!context.mounted) return;
              // İlgili nesne üzerinden metodu çağırır
              ScaffoldMessenger.of(context)
                // Aynı nesne üzerinde işlemi sürdürür
                ..hideCurrentSnackBar()
                // Ekranda kısa bilgilendirme mesajı gösterir
                ..showSnackBar(SnackBar(
                    // içerik yazısını gösterir
                    content: Text('${specimen.code} panoya kopyalandı.')));
            },
            // Gösterilecek simgeyi belirler
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}
// _ActionBar sınıfını tanımlar
class _ActionBar extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _ActionBar({required this.visit, required this.actions});
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // işlemler bilgisini tutar
  final VisitActions actions;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // coral değerini tanımlar
    final Color coral = context.palette.coral;
    // material değerini hesaplar veya döndürür
    return Material(
      // Rengini belirler
      color: theme.colorScheme.surface,
      // İçeride gösterilecek widgetı belirler
      child: SafeArea(
        // top bilgisini belirler
        top: false,
        // İçeride gösterilecek widgetı belirler
        child: Container(
          // Görünüm ayarlarını oluşturur
          decoration: BoxDecoration(
            // Kenarlık ayarlarını belirler
            border: Border(top: BorderSide(color: theme.colorScheme.outline)),
          ),
          // İç boşlukları belirler
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          // İçeride gösterilecek widgetı belirler
          child: Center(
            // yükseklik factor bilgisini belirler
            heightFactor: 1,
            // İçeride gösterilecek widgetı belirler
            child: ConstrainedBox(
              // Boyut sınırlarını belirler
              constraints: const BoxConstraints(maxWidth: 720),
              // İçeride gösterilecek widgetı belirler
              child: Row(
                // Alt widgetları listeler
                children: <Widget>[
                  // İlgili işlem butonunu oluşturur
                  OutlinedButton.icon(
                    // style bilgisini belirler
                    style: OutlinedButton.styleFrom(
                      // Yazı ve simge rengini belirler
                      foregroundColor: coral,
                      // side bilgisini belirler
                      side: BorderSide(color: coral.withValues(alpha: 0.5)),
                    ),
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: () => actions.cancel(context, visit),
                    // Gösterilecek simgeyi belirler
                    icon: const Icon(Icons.cancel_outlined),
                    // Gösterilecek etiketi belirler
                    label: const Text('İptal'),
                  ),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(width: 12),
                  // Kalan alanı doldurmasını sağlar
                  Expanded(
                    // İçeride gösterilecek widgetı belirler
                    child: FilledButton.icon(
                      // Widgetın kimlik bilgisini belirler
                      key: const Key('detail_advance'),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => actions.advance(context, visit),
                      // Gösterilecek simgeyi belirler
                      icon: Icon(visit.status.nextActionIcon),
                      // Gösterilecek etiketi belirler
                      label: Text(visit.status.nextActionLabel ?? ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

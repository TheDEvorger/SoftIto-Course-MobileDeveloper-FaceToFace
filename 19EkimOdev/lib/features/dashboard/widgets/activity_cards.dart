// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// activity entry dosyasını projeye ekler
import '../../../data/models/activity_entry.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// ActiveCallsCard kartını oluşturan sınıf
class ActiveCallsCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const ActiveCallsCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // durum bilgisini zorunlu tutar
    required this.state,
    // ziyaretler bilgisini zorunlu tutar
    required this.visits,
    // durumu ilerletme işlemi bilgisini zorunlu tutar
    required this.onAdvance,
    // açma işlemi bilgisini zorunlu tutar
    required this.onOpen,
  });
  // durum bilgisini tutar
  final ClinicState state;
  // ziyaretler bilgisini tutar
  final List<CollectionVisit> visits;
  // durumu ilerletme işlemi bilgisini tutar
  final ValueChanged<CollectionVisit> onAdvance;
  // açma işlemi bilgisini tutar
  final ValueChanged<CollectionVisit> onOpen;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Aktif Çağrılar',
      // Gösterilecek simgeyi belirler
      icon: Icons.campaign_outlined,
      // İç boşlukları belirler
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      // İçeride gösterilecek widgetı belirler
      child: visits.isEmpty
          // İçeriğin çevresine boşluk bırakır
          ? Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.only(bottom: 8),
              // İçeride gösterilecek widgetı belirler
              child: Text(
                // Bu metin değerini kullanır
                'Şu an çağrılmış veya işlemde hasta yok.',
                // style bilgisini belirler
                style: theme.textTheme.bodyMedium
                    // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            )
          // Elemanları alt alta dizer
          : Column(
              // Alt widgetları listeler
              children: <Widget>[
                // Listedeki elemanları sırayla dolaşır
                for (final CollectionVisit v in visits)
                  // aktiflik row fonksiyonunu çağırır
                  _ActiveRow(
                    // ziyaret bilgisini belirler
                    visit: v,
                    // hasta bilgisini belirler
                    patient: state.patientOf(v),
                    // durumu ilerletme işlemi için callback gönderir
                    onAdvance: () => onAdvance(v),
                    // açma işlemi için callback gönderir
                    onOpen: () => onOpen(v),
                  ),
              ],
            ),
    );
  }
}
// _ActiveRow sınıfını tanımlar
class _ActiveRow extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _ActiveRow({
    // ziyaret bilgisini zorunlu tutar
    required this.visit,
    // hasta bilgisini zorunlu tutar
    required this.patient,
    // durumu ilerletme işlemi bilgisini zorunlu tutar
    required this.onAdvance,
    // açma işlemi bilgisini zorunlu tutar
    required this.onOpen,
  });
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // hasta bilgisini tutar
  final DemoPatient? patient;
  // durumu ilerletme işlemi bilgisini tutar
  final VoidCallback onAdvance;
  // açma işlemi bilgisini tutar
  final VoidCallback onOpen;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // ink well değerini hesaplar veya döndürür
    return InkWell(
      // Dokunulunca çalışacak fonksiyonu belirler
      onTap: onOpen,
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(12),
      // İçeride gösterilecek widgetı belirler
      child: Padding(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(vertical: 8),
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Alt widgetları listeler
          children: <Widget>[
            // QueueBadge nesnesini oluşturur veya kullanır
            QueueBadge(label: Formatters.queueNumber(visit.queueNumber)),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 12),
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: Column(
                // Elemanların çapraz hizasını belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alt widgetları listeler
                children: <Widget>[
                  // Metin gösterir
                  Text(
                    // Değeri ekranda gösterilecek biçime çevirir
                    Formatters.shortName(patient?.displayName ?? '-'),
                    // style bilgisini belirler
                    style: theme.textTheme.titleSmall,
                    // Uzun metnin taşmasını önler
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 4),
                  // Kaydın durumunu gösteren etiketi oluşturur
                  StatusChip.visit(visit.status),
                ],
              ),
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 8),
            // İlgili işlem butonunu oluşturur
            FilledButton.tonal(
              // Basılınca çalışacak fonksiyonu belirler
              onPressed: onAdvance,
              // İçeride gösterilecek widgetı belirler
              child: Text(visit.status.nextActionLabel ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
// RecentActivityCard kartını oluşturan sınıf
class RecentActivityCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const RecentActivityCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // activities bilgisini zorunlu tutar
    required this.activities,
    // ziyareti açma işlemi bilgisini zorunlu tutar
    required this.onOpenVisit,
  });
  // activities bilgisini tutar
  final List<ActivityEntry> activities;
  // ziyareti açma işlemi bilgisini tutar
  final ValueChanged<String> onOpenVisit;
  // visible sayı değerini tanımlar
  static const int _visibleCount = 7;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // items değerini tanımlar
    final List<ActivityEntry> items =
        // İlgili nesne üzerinden metodu çağırır
        activities.take(_visibleCount).toList(growable: false);
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Son Hareketler',
      // Gösterilecek simgeyi belirler
      icon: Icons.history_rounded,
      // İç boşlukları belirler
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      // İçeride gösterilecek widgetı belirler
      child: items.isEmpty
          // Metin gösterir
          ? Text('Henüz hareket yok.', style: theme.textTheme.bodyMedium)
          // Elemanları alt alta dizer
          : Column(
              // Alt widgetları listeler
              children: <Widget>[
                // Listedeki elemanları sırayla dolaşır
                for (final ActivityEntry a in items)
                  // activity row fonksiyonunu çağırır
                  _ActivityRow(
                    // entry bilgisini belirler
                    entry: a,
                    // Dokunulunca çalışacak fonksiyonu belirler
                    onTap: a.visitId == null
                        // Koşul doğruysa bu değeri kullanır
                        ? null
                        // Koşul yanlışsa bu değeri kullanır
                        : () => onOpenVisit(a.visitId!),
                  ),
              ],
            ),
    );
  }
}
// _ActivityRow sınıfını tanımlar
class _ActivityRow extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _ActivityRow({required this.entry, required this.onTap});
  // entry bilgisini tutar
  final ActivityEntry entry;
  // dokunma işlemi bilgisini tutar
  final VoidCallback? onTap;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // renk değerini tanımlar
    final Color color = StatusColors.forVisit(context, entry.status);
    // ink well değerini hesaplar veya döndürür
    return InkWell(
      // Dokunulunca çalışacak fonksiyonu belirler
      onTap: onTap,
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(12),
      // İçeride gösterilecek widgetı belirler
      child: Padding(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(vertical: 8),
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Alt widgetları listeler
          children: <Widget>[
            // Görünüm ve yerleşim için kutu oluşturur
            Container(
              // Genişliğini belirler
              width: 34,
              // Yüksekliğini belirler
              height: 34,
              // Görünüm ayarlarını oluşturur
              decoration: BoxDecoration(
                // Rengini belirler
                color: color.withValues(alpha: 0.14),
                // Widgetın şeklini belirler
                shape: BoxShape.circle,
              ),
              // İçeride gösterilecek widgetı belirler
              child: Icon(entry.status.icon,
                  // boyut bilgisini belirler
                  size: 18, color: StatusColors.readable(context, color)),
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 12),
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: Text(entry.message,
                  // style bilgisini belirler
                  style: theme.textTheme.bodyMedium,
                  // Giriş alanının satır sayısını belirler
                  maxLines: 2,
                  // Uzun metnin taşmasını önler
                  overflow: TextOverflow.ellipsis),
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 8),
            // Metin gösterir
            Text(Formatters.time(entry.timestamp),
                // style bilgisini belirler
                style: theme.textTheme.labelMedium?.copyWith(
                    // Rengini belirler
                    color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

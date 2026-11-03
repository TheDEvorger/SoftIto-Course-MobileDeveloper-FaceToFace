// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// dashboard summary dosyasını projeye ekler
import '../models/dashboard_summary.dart';
// WorkflowCard kartını oluşturan sınıf
class WorkflowCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const WorkflowCard({super.key, required this.summary});
  // summary bilgisini tutar
  final DashboardSummary summary;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // percent değerini tanımlar
    final int percent = (summary.completionRate * 100).round();
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Günlük İş Akışı',
      // Gösterilecek simgeyi belirler
      icon: Icons.insights_rounded,
      // Sağdaki widgetı belirler
      trailing: Text(
        // Bu metin değerini kullanır
        '%$percent tamamlandı',
        // style bilgisini belirler
        style: theme.textTheme.labelLarge
            // Mevcut nesnenin güncellenmiş kopyasını oluşturur
            ?.copyWith(color: theme.colorScheme.primary),
      ),
      // İçeride gösterilecek widgetı belirler
      child: Column(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // Alt widgetları listeler
        children: <Widget>[
          // distribution bar fonksiyonunu çağırır
          _DistributionBar(summary: summary),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 14),
          // Elemanları yan yana dizer, sığmayınca alt satıra geçirir
          Wrap(
            // Elemanların arasındaki boşluğu belirler
            spacing: 14,
            // Satırlar arasındaki boşluğu belirler
            runSpacing: 8,
            // Alt widgetları listeler
            children: <Widget>[
              // Listedeki elemanları sırayla dolaşır
              for (final CollectionStatus s in CollectionStatus.values)
                // legend item fonksiyonunu çağırır
                _LegendItem(status: s, count: summary.countOf(s)),
            ],
          ),
        ],
      ),
    );
  }
}
// _DistributionBar sınıfını tanımlar
class _DistributionBar extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _DistributionBar({required this.summary});
  // summary bilgisini tutar
  final DashboardSummary summary;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // Koşul sağlanırsa ilgili işlemi yapar
    if (summary.total == 0) {
      // container değerini hesaplar veya döndürür
      return Container(
        // Yüksekliğini belirler
        height: 14,
        // Görünüm ayarlarını oluşturur
        decoration: BoxDecoration(
          // Rengini belirler
          color: theme.colorScheme.outline,
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    // semantics değerini hesaplar veya döndürür
    return Semantics(
      // Gösterilecek etiketi belirler
      label: 'Durum dağılımı çubuğu, toplam ${summary.total} kayıt',
      // İçeride gösterilecek widgetı belirler
      child: ClipRRect(
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(8),
        // İçeride gösterilecek widgetı belirler
        child: SizedBox(
          // Yüksekliğini belirler
          height: 14,
          // İçeride gösterilecek widgetı belirler
          child: Row(
            // Alt widgetları listeler
            children: <Widget>[
              // Listedeki elemanları sırayla dolaşır
              for (final CollectionStatus s in CollectionStatus.values)
                // Koşul sağlanırsa ilgili işlemi yapar
                if (summary.countOf(s) > 0)
                  // Kalan alanı doldurmasını sağlar
                  Expanded(
                    // esneklik oranı bilgisini belirler
                    flex: summary.countOf(s),
                    // İçeride gösterilecek widgetı belirler
                    child: AnimatedContainer(
                      // İşlemin süresini belirler
                      duration: const Duration(milliseconds: 300),
                      // Dış boşlukları belirler
                      margin: const EdgeInsets.only(right: 2),
                      // Rengini belirler
                      color: StatusColors.forVisit(context, s),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
// _LegendItem sınıfını tanımlar
class _LegendItem extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _LegendItem({required this.status, required this.count});
  // durum bilgisini tutar
  final CollectionStatus status;
  // sayı bilgisini tutar
  final int count;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // renk değerini tanımlar
    final Color color = StatusColors.forVisit(context, status);
    // row değerini hesaplar veya döndürür
    return Row(
      // Kaplayacağı ana eksen alanını belirler
      mainAxisSize: MainAxisSize.min,
      // Alt widgetları listeler
      children: <Widget>[
        // Simge gösterir
        Icon(status.icon, size: 14, color: StatusColors.readable(context, color)),
        // Constructor, yeni nesnenin bilgilerini alır
        const SizedBox(width: 4),
        // Metin gösterir
        Text('${status.label}: $count', style: theme.textTheme.bodySmall),
      ],
    );
  }
}

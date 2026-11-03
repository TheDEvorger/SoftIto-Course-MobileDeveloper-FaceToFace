// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import '../../../core/theme/app_theme.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// StatusTimeline sınıfını tanımlar
class StatusTimeline extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const StatusTimeline({super.key, required this.visit});
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // cancelled durumunu kontrol eder
    final bool cancelled = visit.status == CollectionStatus.cancelled;
    // steps listesini oluşturur
    final List<CollectionStatus> steps = <CollectionStatus>[
      // Önceki listedeki elemanları buraya ekler
      ...CollectionStatusX.flow,
      // Koşul sağlanırsa ilgili işlemi yapar
      if (cancelled) CollectionStatus.cancelled,
    ];
    // column değerini hesaplar veya döndürür
    return Column(
      // Alt widgetları listeler
      children: <Widget>[
        // Belirlenen sayı kadar döngüyü çalıştırır
        for (int i = 0; i < steps.length; i++)
          // timeline row fonksiyonunu çağırır
          _TimelineRow(
            // step bilgisini belirler
            step: steps[i],
            // reached at bilgisini belirler
            reachedAt: visit.statusHistory[steps[i]],
            // is güncel bilgisini belirler
            isCurrent: visit.status == steps[i],
            // is last bilgisini belirler
            isLast: i == steps.length - 1,
            // ipucu bilgisini belirler
            hint: _hintFor(steps[i]),
          ),
      ],
    );
  }
  // ipucu for değerini hesaplar veya döndürür
  String _hintFor(CollectionStatus step) => switch (step) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => 'Hasta kabul edildi, sıraya alındı',
        // collection durum bilgisini günceller
        CollectionStatus.called => 'Hasta kan alma odasına çağrıldı',
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => 'Kan alma işlemi sürüyor',
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => 'Kurgusal numune kaydı oluşturuldu',
        // collection durum bilgisini günceller
        CollectionStatus.delivered => 'Numune laboratuvara teslim edildi',
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => 'İşlem iptal edildi',
      };
}
// _TimelineRow sınıfını tanımlar
class _TimelineRow extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _TimelineRow({
    // step bilgisini zorunlu tutar
    required this.step,
    // reached at bilgisini zorunlu tutar
    required this.reachedAt,
    // is güncel bilgisini zorunlu tutar
    required this.isCurrent,
    // is last bilgisini zorunlu tutar
    required this.isLast,
    // ipucu bilgisini zorunlu tutar
    required this.hint,
  });
  // step bilgisini tutar
  final CollectionStatus step;
  // reached at bilgisini tutar
  final DateTime? reachedAt;
  // is güncel bilgisini tutar
  final bool isCurrent;
  // is last bilgisini tutar
  final bool isLast;
  // ipucu bilgisini tutar
  final String hint;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // reached değerini tanımlar
    final bool reached = reachedAt != null;
    // is cancel durumunu kontrol eder
    final bool isCancel = step == CollectionStatus.cancelled;
    // aktiflik değerini tanımlar
    final Color active =
        // İlgili alanın değerini veya görünümünü ayarlar
        isCancel ? context.palette.coral : theme.colorScheme.primary;
    // idle değerini tanımlar
    final Color idle = theme.colorScheme.outline;
    // intrinsic yükseklik değerini hesaplar veya döndürür
    return IntrinsicHeight(
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // Alt widgetları listeler
        children: <Widget>[
          // Sabit boyut veya boşluk oluşturur
          SizedBox(
            // Genişliğini belirler
            width: 36,
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Alt widgetları listeler
              children: <Widget>[
                // Değer değişince yumuşak geçiş yapar
                AnimatedContainer(
                  // İşlemin süresini belirler
                  duration: const Duration(milliseconds: 250),
                  // Genişliğini belirler
                  width: 32,
                  // Yüksekliğini belirler
                  height: 32,
                  // Görünüm ayarlarını oluşturur
                  decoration: BoxDecoration(
                    // Widgetın şeklini belirler
                    shape: BoxShape.circle,
                    // Rengini belirler
                    color: reached
                        // Koşul doğruysa bu değeri kullanır
                        ? active.withValues(alpha: isCurrent ? 1 : 0.15)
                        // Koşul yanlışsa bu değeri kullanır
                        : Colors.transparent,
                    // Kenarlık ayarlarını belirler
                    border: Border.all(
                        // Rengini belirler
                        color: reached ? active : idle, width: 2),
                  ),
                  // İçeride gösterilecek widgetı belirler
                  child: Icon(
                    // İlgili alanın değerini veya görünümünü ayarlar
                    reached && !isCurrent ? Icons.check_rounded : step.icon,
                    // boyut bilgisini belirler
                    size: 16,
                    // Rengini belirler
                    color: reached
                        // Koşul doğruysa bu değeri kullanır
                        ? (isCurrent ? theme.colorScheme.surface : active)
                        // Koşul yanlışsa bu değeri kullanır
                        : idle,
                  ),
                ),
                // Koşul sağlanırsa ilgili işlemi yapar
                if (!isLast)
                  // Kalan alanı doldurmasını sağlar
                  Expanded(
                    // İçeride gösterilecek widgetı belirler
                    child: Container(
                      // Genişliğini belirler
                      width: 2,
                      // Dış boşlukları belirler
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      // Rengini belirler
                      color: reached ? active.withValues(alpha: 0.4) : idle,
                    ),
                  ),
              ],
            ),
          ),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(width: 12),
          // Kalan alanı doldurmasını sağlar
          Expanded(
            // İçeride gösterilecek widgetı belirler
            child: Padding(
              // İç boşlukları belirler
              padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 18),
              // İçeride gösterilecek widgetı belirler
              child: Column(
                // Elemanların çapraz hizasını belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alt widgetları listeler
                children: <Widget>[
                  // Elemanları yan yana dizer
                  Row(
                    // Alt widgetları listeler
                    children: <Widget>[
                      // Kalan alanı doldurmasını sağlar
                      Expanded(
                        // İçeride gösterilecek widgetı belirler
                        child: Text(
                          // etiket değerini listeye ekler
                          step.label,
                          // style bilgisini belirler
                          style: theme.textTheme.titleSmall?.copyWith(
                            // Rengini belirler
                            color: reached
                                // Koşul doğruysa bu değeri kullanır
                                ? theme.colorScheme.onSurface
                                // Koşul yanlışsa bu değeri kullanır
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      // Metin gösterir
                      Text(
                        // İlgili alanın değerini veya görünümünü ayarlar
                        reached ? Formatters.time(reachedAt!) : '—',
                        // style bilgisini belirler
                        style: theme.textTheme.labelMedium?.copyWith(
                          // Rengini belirler
                          color: theme.colorScheme.onSurfaceVariant,
                          // font features bilgisini belirler
                          fontFeatures: const <FontFeature>[
                            // İlgili nesne üzerinden metodu çağırır
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Constructor, yeni nesnenin bilgilerini alır
                  const SizedBox(height: 2),
                  // Metin gösterir
                  Text(hint, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

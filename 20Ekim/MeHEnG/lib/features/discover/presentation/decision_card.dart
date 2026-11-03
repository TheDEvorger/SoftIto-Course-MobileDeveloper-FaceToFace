// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Karar modelini ekler
import '../domain/decision.dart';
// Kanıt modelini ekler
import '../domain/evidence.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// Stratejik karar kartı
class DecisionCard extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const DecisionCard({
    // Decision bilgisini zorunlu tutar
    required this.decision,
    // Girişimin ID bilgisini zorunlu tutar
    required this.ventureId,
    // Key bilgisini üst sınıfa gönderir
    super.key,
  });
  // Decision bilgisini tutar
  final Decision decision;
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Kararın durumuna göre rozet rengini ve simgeyi seçer
    final (badgeColor, badgeBg, icon) = switch (decision.outcome) {
      // Karar sonucunun görünen adını belirler
      DecisionOutcome.continueRun => (
          // Görünümde kullanılacak rengi belirler
          Colors.green.shade700,
          // Görünümde kullanılacak rengi belirler
          Colors.green.shade50,
          // Gösterilecek simgeyi belirler
          Icons.arrow_forward_rounded,
        ),
      // Karar sonucunun görünen adını belirler
      DecisionOutcome.pivot => (
          // Görünümde kullanılacak rengi belirler
          Colors.orange.shade800,
          // Görünümde kullanılacak rengi belirler
          Colors.orange.shade50,
          // Gösterilecek simgeyi belirler
          Icons.change_circle_outlined,
        ),
      // Karar sonucunun görünen adını belirler
      DecisionOutcome.stop => (
          // Görünümde kullanılacak rengi belirler
          Colors.red.shade700,
          // Görünümde kullanılacak rengi belirler
          Colors.red.shade50,
          // Gösterilecek simgeyi belirler
          Icons.cancel_outlined,
        ),
    };
    // Trace linked evidence records
    // Girişime ait hipotezleri dinler
    final hypotheses = ref.watch(hypothesesProvider(ventureId));
    // Linked evidence bilgisini oluşturur
    final linkedEvidence = <Evidence>[];
    // Listedeki elemanları sırayla dolaşır
    for (final h in hypotheses) {
      // Hipoteze ait deneyleri dinler
      final experiments = ref.watch(experimentsProvider(h.id));
      // Listedeki elemanları sırayla dolaşır
      for (final exp in experiments) {
        // Ev list listeyi Riverpod üzerinden dinler
        final evList = ref.watch(evidenceProvider(exp.id));
        // Listedeki elemanları sırayla dolaşır
        for (final ev in evList) {
          // Koşul doğruysa ilgili işlemi yapar
          if (decision.evidenceIds.contains(ev.id)) {
            // Linked evidence.add işlemini çağırır
            linkedEvidence.add(ev);
          }
        }
      }
    }
    // Kart görünümü oluşturur
    return Card(
      // Dış boşlukları ayarlar
      margin: const EdgeInsets.only(bottom: 12),
      // İçerideki widgetı belirler
      child: Padding(
        // İç boşlukları ayarlar
        padding: const EdgeInsets.all(16),
        // İçerideki widgetı belirler
        child: Column(
          // Çapraz eksen hizasını belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // İçeride gösterilecek elemanları listeler
          children: [
            // Elemanları yan yana dizer
            Row(
              // İçeride gösterilecek elemanları listeler
              children: [
                // Görünüm için kutu oluşturur
                Container(
                  // İç boşlukları ayarlar
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  // Görünüm ayarlarını belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: badgeBg,
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(16),
                    // Kenarlığı belirler
                    border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                  ),
                  // İçerideki widgetı belirler
                  child: Row(
                    // Ana eksende kaplanan alanı belirler
                    mainAxisSize: MainAxisSize.min,
                    // İçeride gösterilecek elemanları listeler
                    children: [
                      // Simgeyi gösterir
                      Icon(icon, size: 16, color: badgeColor),
                      // Constructor gerekli bilgileri alır
                      const SizedBox(width: 6),
                      // Metni ekranda gösterir
                      Text(
                        // Kararın görünen sonucunu gösterir
                        decision.outcome.label,
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Rengi belirler
                          color: badgeColor,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Yazı boyutunu belirler
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Constructor gerekli bilgileri alır
                const Spacer(),
                // Metni ekranda gösterir
                Text(
                  // Format date işlemini çağırır
                  _formatDate(decision.createdAt),
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        // Rengi belirler
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            // Constructor gerekli bilgileri alır
            const SizedBox(height: 12),
            // Metni ekranda gösterir
            Text(
              // Kararın gerekçesini ilgili işleme aktarır
              decision.rationale,
              // Görünüm stilini belirler
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w500,
                  ),
            ),
            // Liste veya metin boş değilse çalışır
            if (linkedEvidence.isNotEmpty) ...[
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 12),
              // Constructor gerekli bilgileri alır
              const Divider(height: 1),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 8),
              // Metni ekranda gösterir
              Text(
                // Gösterilecek metni belirler
                'Dayanak Kanıtlar (${linkedEvidence.length}):',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      // Rengi belirler
                      color: Theme.of(context).colorScheme.primary,
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 6),
              // Listedeki elemanları sırayla dolaşır
              for (final ev in linkedEvidence)
                // İçerik çevresine boşluk bırakır
                Padding(
                  // İç boşlukları ayarlar
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  // İçerideki widgetı belirler
                  child: Row(
                    // Çapraz eksen hizasını belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçeride gösterilecek elemanları listeler
                    children: [
                      // Simgeyi gösterir
                      Icon(
                        // Kanıtın yönüne göre simge veya renk seçer
                        ev.direction == EvidenceDirection.supports
                            // Koşul doğruysa bu değeri kullanır
                            ? Icons.check_circle_outline
                            // Koşul yanlışsa bu değeri kullanır
                            : ev.direction == EvidenceDirection.contradicts
                                // Koşul doğruysa bu değeri kullanır
                                ? Icons.highlight_off
                                // Koşul yanlışsa bu değeri kullanır
                                : Icons.help_outline,
                        // Size özelliğini belirler
                        size: 16,
                        // Rengi belirler
                        color: ev.direction == EvidenceDirection.supports
                            // Koşul doğruysa bu değeri kullanır
                            ? Colors.green
                            // Koşul yanlışsa bu değeri kullanır
                            : ev.direction == EvidenceDirection.contradicts
                                // Koşul doğruysa bu değeri kullanır
                                ? Colors.redAccent
                                // Koşul yanlışsa bu değeri kullanır
                                : Colors.grey,
                      ),
                      // Constructor gerekli bilgileri alır
                      const SizedBox(width: 8),
                      // Kalan alanı kullanır
                      Expanded(
                        // İçerideki widgetı belirler
                        child: Text(
                          // Gösterilecek metni belirler
                          '${ev.note}${ev.source != null ? " [${ev.source}]" : ""}',
                          // Görünüm stilini belirler
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
  // Format date metodunu tanımlar
  String _formatDate(DateTime dt) =>
      // İlgili metodu çalıştırır
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}

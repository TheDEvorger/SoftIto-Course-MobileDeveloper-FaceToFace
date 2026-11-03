// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Boş durum kartını ekler
import '../../../core/widgets/empty_state_card.dart';
// Decision card dosyasını ekler
import 'decision_card.dart';
// Decision dialog dosyasını ekler
import 'dialogs/decision_dialog.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// Stratejik kararların gösterildiği bölüm
class DecisionsSection extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const DecisionsSection({required this.ventureId, super.key});
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Decisions bilgisini Riverpod üzerinden dinler
    final decisions = ref.watch(decisionsProvider(ventureId));
    // Elemanları alt alta dizer
    return Column(
      // Çapraz eksen hizasını belirler
      crossAxisAlignment: CrossAxisAlignment.start,
      // İçeride gösterilecek elemanları listeler
      children: [
        // Elemanları yan yana dizer
        Row(
          // İçeride gösterilecek elemanları listeler
          children: [
            // Kalan alanı kullanır
            Expanded(
              // İçerideki widgetı belirler
              child: Text(
                // Gösterilecek metni belirler
                'Karar Günlüğü',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Erişilebilirlik bilgilerini ekler
            Semantics(
              // Button özelliğini belirler
              button: true,
              // Gösterilecek etiketi belirler
              label: 'Yeni stratejik karar ekleme diyaloğunu aç',
              // İçerideki widgetı belirler
              child: FilledButton.tonalIcon(
                // Butona basılınca çalışacak işlemi belirler
                onPressed: () => showDialog<void>(
                  // Ekran bağlamını gönderir
                  context: context,
                  // Alt widgetı oluşturan fonksiyonu tanımlar
                  builder: (_) => DecisionDialog(ventureId: ventureId),
                ),
                // Butonun simgesini gösterir
                icon: const Icon(Icons.add),
                // Butonun yazısını gösterir
                label: const Text('Karar ekle'),
              ),
            ),
          ],
        ),
        // Constructor gerekli bilgileri alır
        const SizedBox(height: 12),
        // Liste veya metin boşsa çalışır
        if (decisions.isEmpty)
          // Boş liste bilgilendirme kartı oluşturur
          EmptyStateCard(
            // Gösterilecek simgeyi belirler
            icon: Icons.psychology_outlined,
            // Başlık bilgisini belirler
            title: 'Henüz stratejik karar yok',
            // Description özelliğini belirler
            description:
                // Gösterilecek metni belirler
                'Toplanan kanıtlara dayanarak devam et, yön değiştir (pivot) veya sonlandır kararı kaydedin.',
            // Action label özelliğini belirler
            actionLabel: 'Karar ekle',
            // İşlem gerçekleşince çalışacak callbacki bağlar
            onAction: () => showDialog<void>(
              // Ekran bağlamını gönderir
              context: context,
              // Alt widgetı oluşturan fonksiyonu tanımlar
              builder: (_) => DecisionDialog(ventureId: ventureId),
            ),
          )
        // Önceki koşul gerçekleşmezse çalışır
        else
          // Listedeki elemanları sırayla dolaşır
          for (final decision in decisions)
            // Stratejik karar kartı oluşturur
            DecisionCard(decision: decision, ventureId: ventureId),
      ],
    );
  }
}

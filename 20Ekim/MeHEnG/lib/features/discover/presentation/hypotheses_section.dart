// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Boş durum kartını ekler
import '../../../core/widgets/empty_state_card.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// Hypothesis card dosyasını ekler
import 'hypothesis_card.dart';
// Hypothesis dialog dosyasını ekler
import 'dialogs/hypothesis_dialog.dart';
// Hipotezlerin gösterildiği bölüm
class HypothesesSection extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const HypothesesSection({required this.ventureId, super.key});
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Girişime ait hipotezleri dinler
    final hypotheses = ref.watch(hypothesesProvider(ventureId));
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
                'Hipotezler',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Erişilebilirlik bilgilerini ekler
            Semantics(
              // Button özelliğini belirler
              button: true,
              // Gösterilecek etiketi belirler
              label: 'Yeni hipotez ekleme diyaloğunu aç',
              // İçerideki widgetı belirler
              child: FilledButton.tonalIcon(
                // Butona basılınca çalışacak işlemi belirler
                onPressed: () => showDialog<void>(
                  // Ekran bağlamını gönderir
                  context: context,
                  // Alt widgetı oluşturan fonksiyonu tanımlar
                  builder: (_) => HypothesisDialog(ventureId: ventureId),
                ),
                // Butonun simgesini gösterir
                icon: const Icon(Icons.add),
                // Butonun yazısını gösterir
                label: const Text('Hipotez ekle'),
              ),
            ),
          ],
        ),
        // Constructor gerekli bilgileri alır
        const SizedBox(height: 12),
        // Liste veya metin boşsa çalışır
        if (hypotheses.isEmpty)
          // Boş liste bilgilendirme kartı oluşturur
          EmptyStateCard(
            // Gösterilecek simgeyi belirler
            icon: Icons.science_outlined,
            // Başlık bilgisini belirler
            title: 'Henüz hipotez yok',
            // Description özelliğini belirler
            description:
                // Gösterilecek metni belirler
                'Test edilebilir ilk varsayımını ve riskli kabullerini yaz.',
            // Action label özelliğini belirler
            actionLabel: 'Hipotez ekle',
            // İşlem gerçekleşince çalışacak callbacki bağlar
            onAction: () => showDialog<void>(
              // Ekran bağlamını gönderir
              context: context,
              // Alt widgetı oluşturan fonksiyonu tanımlar
              builder: (_) => HypothesisDialog(ventureId: ventureId),
            ),
          )
        // Önceki koşul gerçekleşmezse çalışır
        else
          // Listedeki elemanları sırayla dolaşır
          for (final hypothesis in hypotheses)
            // Hipotez kartı oluşturur
            HypothesisCard(hypothesis: hypothesis),
      ],
    );
  }
}

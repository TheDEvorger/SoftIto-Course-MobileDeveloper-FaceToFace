// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Hipotez modelini ekler
import '../domain/hypothesis.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// Experiment tile dosyasını ekler
import 'experiment_tile.dart';
// Experiment dialog dosyasını ekler
import 'dialogs/experiment_dialog.dart';
// Hipotez kartı
class HypothesisCard extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const HypothesisCard({required this.hypothesis, super.key});
  // Hypothesis bilgisini tutar
  final Hypothesis hypothesis;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Hipoteze ait deneyleri dinler
    final experiments = ref.watch(experimentsProvider(hypothesis.id));
    // Kart görünümü oluşturur
    return Card(
      // Dış boşlukları ayarlar
      margin: const EdgeInsets.only(bottom: 12),
      // İçerideki widgetı belirler
      child: ExpansionTile(
        // Initially expanded özelliğini belirler
        initiallyExpanded: true,
        // Başlık bilgisini belirler
        title: Text(hypothesis.statement),
        // Alt açıklamayı belirler
        subtitle: Text('${experiments.length} deney · doğrulanmayı bekliyor'),
        // Children padding özelliğini belirler
        childrenPadding: const EdgeInsets.all(12),
        // İçeride gösterilecek elemanları listeler
        children: [
          // Listedeki elemanları sırayla dolaşır
          for (final experiment in experiments)
            // Deney bilgilerini gösteren kart oluşturur
            ExperimentTile(experiment: experiment),
          // Liste veya metin boşsa çalışır
          if (experiments.isEmpty)
            // Constructor gerekli bilgileri alır
            const Padding(
              // İç boşlukları ayarlar
              padding: EdgeInsets.all(8),
              // İçerideki widgetı belirler
              child: Text('Bu hipotezi test etmek için bir deney planla.'),
            ),
          // Align sınıfını tanımlar oluşturur
          Align(
            // Elemanların hizasını belirler
            alignment: Alignment.centerRight,
            // İçerideki widgetı belirler
            child: TextButton.icon(
              // Butona basılınca çalışacak işlemi belirler
              onPressed: () => showDialog<void>(
                // Ekran bağlamını gönderir
                context: context,
                // Alt widgetı oluşturan fonksiyonu tanımlar
                builder: (_) => ExperimentDialog(hypothesisId: hypothesis.id),
              ),
              // Butonun simgesini gösterir
              icon: const Icon(Icons.add),
              // Butonun yazısını gösterir
              label: const Text('Deney oluştur'),
            ),
          ),
        ],
      ),
    );
  }
}

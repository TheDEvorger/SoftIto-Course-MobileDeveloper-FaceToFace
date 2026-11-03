// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Deney modelini ekler
import '../domain/experiment.dart';
// Kanıt modelini ekler
import '../domain/evidence.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// Evidence dialog dosyasını ekler
import 'dialogs/evidence_dialog.dart';
// Deney bilgilerini gösteren kart
class ExperimentTile extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const ExperimentTile({required this.experiment, super.key});
  // Experiment bilgisini tutar
  final Experiment experiment;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Records bilgisini Riverpod üzerinden dinler
    final records = ref.watch(evidenceProvider(experiment.id));
    // İşlemin sonucunu döndürür
    return Card.filled(
      // İçerideki widgetı belirler
      child: Padding(
        // İç boşlukları ayarlar
        padding: const EdgeInsets.all(12),
        // İçerideki widgetı belirler
        child: Column(
          // Çapraz eksen hizasını belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // İçeride gösterilecek elemanları listeler
          children: [
            // Metni ekranda gösterir
            Text(
              // Başlık bilgisini ilgili işleme aktarır
              experiment.title,
              // Görünüm stilini belirler
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Metni ekranda gösterir
            Text('Yöntem: ${experiment.method}'),
            // Constructor gerekli bilgileri alır
            const SizedBox(height: 12),
            // Listedeki elemanları sırayla dolaşır
            for (final record in records)
              // Hazır liste satırı oluşturur
              ListTile(
                // Dense özelliğini belirler
                dense: true,
                // Sol taraftaki elemanı belirler
                leading: Icon(_icon(record.direction)),
                // Başlık bilgisini belirler
                title: Text(record.note),
                // Alt açıklamayı belirler
                subtitle: Text(
                  // Kaynak bilgisinin boş olup olmadığını kontrol eder
                  record.source != null && record.source!.isNotEmpty
                      // Koşul doğruysa bu değeri kullanır
                      ? '${_label(record.direction)} · Kaynak: ${record.source}'
                      // Koşul yanlışsa bu değeri kullanır
                      : _label(record.direction),
                ),
              ),
            // Liste veya metin boşsa çalışır
            if (records.isEmpty) const Text('Henüz kaydedilmiş kanıt yok.'),
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
                  builder: (_) => EvidenceDialog(experimentId: experiment.id),
                ),
                // Butonun simgesini gösterir
                icon: const Icon(Icons.add),
                // Butonun yazısını gösterir
                label: const Text('Kanıt ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Label metodunu tanımlar
  String _label(EvidenceDirection d) => switch (d) {
    // Destekleyen kanıt seçeneğini belirler
    EvidenceDirection.supports => 'Destekliyor',
    // Çelişen kanıt seçeneğini belirler
    EvidenceDirection.contradicts => 'Çelişiyor',
    // Tarafsız kanıt seçeneğini belirler
    EvidenceDirection.neutral => 'Nötr',
  };
  // Icon metodunu tanımlar
  IconData _icon(EvidenceDirection d) => switch (d) {
    // Destekleyen kanıt seçeneğini belirler
    EvidenceDirection.supports => Icons.check_circle_outline,
    // Çelişen kanıt seçeneğini belirler
    EvidenceDirection.contradicts => Icons.report_outlined,
    // Tarafsız kanıt seçeneğini belirler
    EvidenceDirection.neutral => Icons.remove_circle_outline,
  };
}

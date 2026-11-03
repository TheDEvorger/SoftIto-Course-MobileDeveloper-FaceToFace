// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// demo numune dosyasını projeye ekler
import '../../../data/models/demo_specimen.dart';
// numune row dosyasını projeye ekler
import '../models/specimen_row.dart';
// SpecimenCard kartını oluşturan sınıf
class SpecimenCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const SpecimenCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // row bilgisini zorunlu tutar
    required this.row,
    // copy işlemi bilgisini zorunlu tutar
    required this.onCopy,
    // open detail işlemi bilgisini zorunlu tutar
    required this.onOpenDetail,
    // deliver işlemi bilgisini zorunlu tutar
    required this.onDeliver,
  });
  // row bilgisini tutar
  final SpecimenRow row;
  // copy işlemi bilgisini tutar
  final VoidCallback onCopy;
  // open detail işlemi bilgisini tutar
  final VoidCallback? onOpenDetail;
  // deliver işlemi bilgisini tutar
  final VoidCallback onDeliver;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // s değerini tanımlar
    final DemoSpecimen s = row.specimen;
    // accent değerini tanımlar
    final Color accent = StatusColors.forSpecimen(context, s.status);
    // related durumunu kontrol eder
    final String related = row.visit == null
        // Koşul doğruysa bu değeri kullanır
        ? 'İlişkili işlem bulunamadı'
        // Koşul yanlışsa bu değeri kullanır
        : '${Formatters.queueNumber(row.visit!.queueNumber)} · '
            // Bu metin değerini kullanır
            '${Formatters.shortName(row.patient?.displayName ?? '-')} · '
            // Bu metin değerini kullanır
            '${row.patient?.department ?? '-'}';
    // card değerini hesaplar veya döndürür
    return Card(
      // Taşan kısmın nasıl kesileceğini belirler
      clipBehavior: Clip.antiAlias,
      // İçeride gösterilecek widgetı belirler
      child: IntrinsicHeight(
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Elemanların çapraz hizasını belirler
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Alt widgetları listeler
          children: <Widget>[
            // Görünüm ve yerleşim için kutu oluşturur
            Container(width: 5, color: accent),
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: Padding(
                // İç boşlukları belirler
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
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
                        // Simge gösterir
                        Icon(Icons.science_outlined,
                            // boyut bilgisini belirler
                            size: 20, color: theme.colorScheme.primary),
                        // Constructor, yeni nesnenin bilgilerini alır
                        const SizedBox(width: 8),
                        // Kalan alanı doldurmasını sağlar
                        Expanded(
                          // İçeride gösterilecek widgetı belirler
                          child: Text(
                            // kod değerini listeye ekler
                            s.code,
                            // style bilgisini belirler
                            style: theme.textTheme.titleMedium?.copyWith(
                              // Yazı tipini belirler
                              fontFamily: 'monospace',
                              // Harfler arasındaki boşluğu ayarlar
                              letterSpacing: 0.5,
                            ),
                            // Uzun metnin taşmasını önler
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Simge butonu oluşturur
                        IconButton(
                          // Butonun açıklamasını belirler
                          tooltip: 'Numune kodunu kopyala',
                          // Basılınca çalışacak fonksiyonu belirler
                          onPressed: onCopy,
                          // Gösterilecek simgeyi belirler
                          icon: const Icon(Icons.copy_rounded, size: 20),
                        ),
                      ],
                    ),
                    // Metin gösterir
                    Text(related,
                        // style bilgisini belirler
                        style: theme.textTheme.bodyMedium,
                        // Giriş alanının satır sayısını belirler
                        maxLines: 1,
                        // Uzun metnin taşmasını önler
                        overflow: TextOverflow.ellipsis),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const SizedBox(height: 2),
                    // Metin gösterir
                    Text(_timeText(s), style: theme.textTheme.bodySmall),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const SizedBox(height: 10),
                    // Elemanları yan yana dizer, sığmayınca alt satıra geçirir
                    Wrap(
                      // Elemanların arasındaki boşluğu belirler
                      spacing: 8,
                      // Satırlar arasındaki boşluğu belirler
                      runSpacing: 8,
                      // Elemanların çapraz hizasını belirler
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // Alt widgetları listeler
                      children: <Widget>[
                        // Kaydın durumunu gösteren etiketi oluşturur
                        StatusChip.specimen(s.status),
                        // Değer null değilse işlemi çalıştırır
                        if (onOpenDetail != null)
                          // İlgili işlem butonunu oluşturur
                          TextButton.icon(
                            // Basılınca çalışacak fonksiyonu belirler
                            onPressed: onOpenDetail,
                            // Gösterilecek simgeyi belirler
                            icon: const Icon(Icons.open_in_new_rounded,
                                // boyut bilgisini belirler
                                size: 18),
                            // Gösterilecek etiketi belirler
                            label: const Text('Detay'),
                          ),
                        // Koşul sağlanırsa ilgili işlemi yapar
                        if (s.status == SpecimenStatus.awaitingDelivery)
                          // İlgili işlem butonunu oluşturur
                          FilledButton.tonalIcon(
                            // Basılınca çalışacak fonksiyonu belirler
                            onPressed: onDeliver,
                            // Gösterilecek simgeyi belirler
                            icon: const Icon(Icons.local_shipping_outlined,
                                // boyut bilgisini belirler
                                size: 18),
                            // Gösterilecek etiketi belirler
                            label: const Text('Teslim Et'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // saat metin değerini hesaplar veya döndürür
  String _timeText(DemoSpecimen s) {
    // created değerini tanımlar
    final String created = 'Alındı ${Formatters.time(s.createdAt)}';
    // Değer null ise işlemi çalıştırır
    if (s.deliveredAt == null) return created;
    // Hesaplanan sonucu döndürür
    return '$created · Teslim ${Formatters.time(s.deliveredAt!)}';
  }
}

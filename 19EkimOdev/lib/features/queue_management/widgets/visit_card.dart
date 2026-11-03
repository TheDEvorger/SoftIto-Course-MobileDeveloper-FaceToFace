// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// durum chip dosyasını projeye ekler
import '../../../core/widgets/status_chip.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// _VisitMenu için izin verilen seçenekleri tanımlar
enum _VisitMenu { detail, cancel }
// VisitCard kartını oluşturan sınıf
class VisitCard extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const VisitCard({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // ziyaret bilgisini zorunlu tutar
    required this.visit,
    // hasta bilgisini zorunlu tutar
    required this.patient,
    // açma işlemi bilgisini zorunlu tutar
    required this.onOpen,
    // durumu ilerletme işlemi bilgisini zorunlu tutar
    required this.onAdvance,
    // cancel işlemi bilgisini zorunlu tutar
    required this.onCancel,
  });
  // ziyaret bilgisini tutar
  final CollectionVisit visit;
  // hasta bilgisini tutar
  final DemoPatient? patient;
  // açma işlemi bilgisini tutar
  final VoidCallback onOpen;
  // durumu ilerletme işlemi bilgisini tutar
  final VoidCallback onAdvance;
  // cancel işlemi bilgisini tutar
  final VoidCallback onCancel;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // action etiket değerini tanımlar
    final String? actionLabel = visit.status.nextActionLabel;
    // muted değerini tanımlar
    final bool muted = visit.status.isTerminal;
    // card değerini hesaplar veya döndürür
    return Card(
      // Taşan kısmın nasıl kesileceğini belirler
      clipBehavior: Clip.antiAlias,
      // İçeride gösterilecek widgetı belirler
      child: InkWell(
        // Dokunulunca çalışacak fonksiyonu belirler
        onTap: onOpen,
        // İçeride gösterilecek widgetı belirler
        child: Opacity(
          // saydamlık bilgisini belirler
          opacity: muted ? 0.78 : 1,
          // İçeride gösterilecek widgetı belirler
          child: Padding(
            // İç boşlukları belirler
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Alt widgetları listeler
              children: <Widget>[
                // Elemanları yan yana dizer
                Row(
                  // Elemanların çapraz hizasını belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Alt widgetları listeler
                  children: <Widget>[
                    // QueueBadge nesnesini oluşturur veya kullanır
                    QueueBadge(label: Formatters.queueNumber(visit.queueNumber)),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const SizedBox(width: 12),
                    // Kalan alanı doldurmasını sağlar
                    Expanded(child: _PatientInfo(visit: visit, patient: patient)),
                    // build menu fonksiyonunu çağırır
                    _buildMenu(context),
                  ],
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 12),
                // İçeriğin çevresine boşluk bırakır
                Padding(
                  // İç boşlukları belirler
                  padding: const EdgeInsets.only(right: 8),
                  // İçeride gösterilecek widgetı belirler
                  child: Wrap(
                    // Hizalama şeklini belirler
                    alignment: WrapAlignment.spaceBetween,
                    // Elemanların çapraz hizasını belirler
                    crossAxisAlignment: WrapCrossAlignment.center,
                    // Elemanların arasındaki boşluğu belirler
                    spacing: 8,
                    // Satırlar arasındaki boşluğu belirler
                    runSpacing: 8,
                    // Alt widgetları listeler
                    children: <Widget>[
                      // Kaydın durumunu gösteren etiketi oluşturur
                      StatusChip.visit(visit.status),
                      // Değer null değilse işlemi çalıştırır
                      if (actionLabel != null)
                        // İlgili işlem butonunu oluşturur
                        FilledButton.tonalIcon(
                          // Basılınca çalışacak fonksiyonu belirler
                          onPressed: onAdvance,
                          // Gösterilecek simgeyi belirler
                          icon: Icon(visit.status.nextActionIcon, size: 18),
                          // Gösterilecek etiketi belirler
                          label: Text(actionLabel),
                        )
                      // Önceki koşul sağlanmazsa burası çalışır
                      else
                        // Metin gösterir
                        Text(
                          // finished metin fonksiyonunu çağırır
                          _finishedText(visit),
                          // style bilgisini belirler
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // build menu bölümünün arayüzünü oluşturur
  Widget _buildMenu(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return PopupMenuButton<_VisitMenu>(
      // Butonun açıklamasını belirler
      tooltip: 'Diğer işlemler',
      // Gösterilecek simgeyi belirler
      icon: const Icon(Icons.more_vert_rounded),
      // Seçilince çalışacak fonksiyonu belirler
      onSelected: (_VisitMenu item) {
        // Değere göre uygun işlem dalını seçer
        switch (item) {
          // Eşleşen durum için bu işlemi çalıştırır
          case _VisitMenu.detail:
            // açma işlemi fonksiyonunu çağırır
            onOpen();
          // Eşleşen durum için bu işlemi çalıştırır
          case _VisitMenu.cancel:
            // cancel işlemi fonksiyonunu çağırır
            onCancel();
        }
      },
      // Her liste elemanı için widget oluşturur
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_VisitMenu>>[
        // PopupMenuItem nesnesini oluşturur veya kullanır
        const PopupMenuItem<_VisitMenu>(
          // Gösterilen değeri belirler
          value: _VisitMenu.detail,
          // İçeride gösterilecek widgetı belirler
          child: ListTile(
            // Soldaki simge veya widgetı belirler
            leading: Icon(Icons.open_in_new_rounded),
            // Başlığını belirler
            title: Text('Detayı Aç'),
            // içerik iç boşluk bilgisini belirler
            contentPadding: EdgeInsets.zero,
          ),
        ),
        // PopupMenuItem nesnesini oluşturur veya kullanır
        PopupMenuItem<_VisitMenu>(
          // Gösterilen değeri belirler
          value: _VisitMenu.cancel,
          // Alanı etkin veya devre dışı yapar
          enabled: visit.status.canCancel,
          // İçeride gösterilecek widgetı belirler
          child: const ListTile(
            // Soldaki simge veya widgetı belirler
            leading: Icon(Icons.cancel_outlined),
            // Başlığını belirler
            title: Text('İptal Et'),
            // içerik iç boşluk bilgisini belirler
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
  // finished metin değerini hesaplar veya döndürür
  String _finishedText(CollectionVisit visit) {
    // at değerini tanımlar
    final DateTime? at = visit.statusHistory[visit.status];
    // Değer null ise işlemi çalıştırır
    if (at == null) return '';
    // Hesaplanan sonucu döndürür
    return '${visit.status.label} · ${Formatters.time(at)}';
  }
}
// _PatientInfo sınıfını tanımlar
class _PatientInfo extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _PatientInfo({required this.visit, required this.patient});
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
    // randevu değerini tanımlar
    final DateTime? appointment = visit.appointmentAt;
    // saat metin durumunu kontrol eder
    final String timeText = appointment == null
        // Koşul doğruysa bu değeri kullanır
        ? 'Kayıt ${Formatters.time(visit.createdAt)}'
        // Koşul yanlışsa bu değeri kullanır
        : 'Kayıt ${Formatters.time(visit.createdAt)} · '
            // Bu metin değerini kullanır
            'Randevu ${Formatters.time(appointment)}';
    // column değerini hesaplar veya döndürür
    return Column(
      // Elemanların çapraz hizasını belirler
      crossAxisAlignment: CrossAxisAlignment.start,
      // Alt widgetları listeler
      children: <Widget>[
        // Metin gösterir
        Text(
          // İlgili alanın değerini veya görünümünü ayarlar
          patient?.displayName ?? 'Bilinmeyen kayıt',
          // style bilgisini belirler
          style: theme.textTheme.titleMedium,
          // Giriş alanının satır sayısını belirler
          maxLines: 1,
          // Uzun metnin taşmasını önler
          overflow: TextOverflow.ellipsis,
        ),
        // Constructor, yeni nesnenin bilgilerini alır
        const SizedBox(height: 2),
        // Metin gösterir
        Text(
          // Bu metin değerini kullanır
          '${patient?.code ?? '-'} · ${patient?.department ?? '-'}',
          // style bilgisini belirler
          style: theme.textTheme.bodySmall,
          // Giriş alanının satır sayısını belirler
          maxLines: 1,
          // Uzun metnin taşmasını önler
          overflow: TextOverflow.ellipsis,
        ),
        // Constructor, yeni nesnenin bilgilerini alır
        const SizedBox(height: 2),
        // Metin gösterir
        Text(timeText, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

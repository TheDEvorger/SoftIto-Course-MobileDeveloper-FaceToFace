// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// kanıt taslak dosyasını ekler
import '../domain/evidence_draft.dart';
// kanıt template dosyasını ekler
import '../domain/evidence_template.dart';
/// 20 açılı araç inceleme simülasyon ekranı.
/// Kullanıcının 20 farklı açıdan kanıt yüklemesini ve insan incelemesi onayını simüle eder.
// kontrol örnek ekran ekranının değişen durumunu yönetir
class InspectionDemoScreen extends StatefulWidget {
  // kontrol örnek ekran nesnesi oluşturur
  const InspectionDemoScreen(
      // Veri alanlarını tanımlar
      {super.key, required this.draft, required this.onSave});
  /// Üzerinde çalışılan inceleme taslağı
  // taslak bilgisini tutar
  final EvidenceDraft draft;
  /// Değişiklikler olduğunda taslağı kaydeden geri çağırma
  // olay kaydetme bilgisini tutar
  final ValueChanged<EvidenceDraft> onSave;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<InspectionDemoScreen> createState() => _InspectionDemoScreenState();
}
// kontrol örnek ekran durum ekranının durumunu yöneten sınıf
class _InspectionDemoScreenState extends State<InspectionDemoScreen> {
  // Test amacıyla sonraki yüklemenin başarısız olmasını simüle eden bayrak
  // fail next değerini belirler
  bool _failNext = false;
  // taslak bilgisini döndürür
  EvidenceDraft get _draft => widget.draft;
  // change işlemini gerçekleştirir
  void _change(VoidCallback action) => setState(() {
        // İlgili fonksiyonu çalıştırır
        action();
        // Üst widgettan gelen bilgilere erişir
        widget.onSave(_draft);
      });
  // upload işlemini gerçekleştirir
  void _upload(int index) => _change(() {
        // İlgili işlemi çalıştırır
        _draft.startUpload(index);
        // Koşul doğruysa bu işlemi çalıştırır
        if (_failNext) {
          // İlgili işlemi çalıştırır
          _draft.fail(index);
          // fail next değerini günceller
          _failNext = false;
        // Önceki koşul sağlanmazsa bu bölümü çalıştırır
        } else {
          // İlgili işlemi çalıştırır
          _draft.receive(index, DateTime.now());
        }
      });
  // durum işlemini gerçekleştirir
  String _status(EvidenceSlot slot) => switch (slot.status) {
        // kanıt durum değerini günceller
        EvidenceStatus.missing => 'Eksik örnek',
        // kanıt durum değerini günceller
        EvidenceStatus.uploading => 'Örnek yükleme sürüyor',
        // kanıt durum değerini günceller
        EvidenceStatus.failed => 'Örnek yükleme başarısız • Yeniden deneyin',
        // kanıt durum değerini günceller
        EvidenceStatus.received => switch (slot.review) {
            // kanıt review değerini günceller
            EvidenceReview.pending =>
              // İlgili metin değerini belirler
              'Örnek alındı • İnsan inceleme demosu bekleniyor',
            // kanıt review değerini günceller
            EvidenceReview.accepted => 'İnsan inceleme demosu kabul etti',
            // kanıt review değerini günceller
            EvidenceReview.retake => 'Yeniden örnek yükleme gerekli',
          },
      };
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Scaffold(
        // Sayfanın üst menüsünü oluşturur
        appBar: AppBar(title: const Text('20 açılı inceleme • DEMO')),
        // Sayfanın ana içeriğini oluşturur
        body: ListView(padding: const EdgeInsets.all(20), children: [
          // Metni gösterir
          const Text(
              // İlgili metin değerini belirler
              'Gerçek fotoğraf çekilmez veya yüklenmez. Her düğme sentetik '
              // İlgili metin değerini belirler
              'bir kaydı simüle eder. AI, hasar sorumluluğu veya ceza kararı yok.'),
          // Metni gösterir
          Text('Şablon: $inspectionTemplateVersion • ${_draft.bookingId}'),
          // Metni gösterir
          const Text('Taslak bu oturumda korunur. Uygulama kapanınca silinir. '
              // İlgili metin değerini belirler
              'Alındı numarası ve zaman cihazda üretilen demo değerleridir.'),
          // semantics nesnesi oluşturur
          Semantics(
              // live region bilgisini belirler
              liveRegion: true,
              // İçerikte gösterilecek widgetı belirler
              child: Text('${_draft.acceptedCount}/20 örnek kabul edildi')),
          // switch liste tile nesnesi oluşturur
          SwitchListTile(
              // Başlığı belirler
              title: const Text('Sonraki örnek yükleme başarısız olsun'),
              // Kullanılacak değeri belirler
              value: _failNext,
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: (value) => setState(() => _failNext = value)),
          // Listedeki öğeleri veya indeksleri sırayla dolaşır
          for (var i = 0; i < evidenceAngles.length; i++) _slot(i),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // Dolgulu buton oluşturur
          FilledButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: _draft.isComplete
                  // Koşul doğruysa bu değeri seçer
                  ? () {
                      // Üst widgettan gelen bilgilere erişir
                      widget.onSave(_draft);
                      // Sayfa açma veya kapatma işlemini yapar
                      Navigator.of(context).pop(true);
                    }
                  // Koşul yanlışsa bu değeri seçer
                  : null,
              // İçerikte gösterilecek widgetı belirler
              child: const Text('20/20 inceleme demosunu tamamla')),
        ]),
      );
  // slot işlemini gerçekleştirir
  Widget _slot(int index) {
    // slot değerini belirler
    final slot = _draft.slots[index];
    // Kart görünümü oluşturur
    return Card(
        // Widget kimliğini belirler
        key: ValueKey('evidence-$index'),
        // İçerikte gösterilecek widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(16),
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Metni gösterir
            Text('${index + 1}. ${evidenceAngles[index]}',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.titleMedium),
            // Metni gösterir
            Text(_status(slot)),
            // Değer null değilse koşulu çalıştırır
            if (slot.demoReceipt != null)
              // Metni gösterir
              Text('Temsili alındı: ${slot.demoReceipt}'),
            // Sığmayan öğeleri alt satıra geçirir
            Wrap(spacing: 8, runSpacing: 8, children: [
              // Çerçeveli buton oluşturur
              OutlinedButton(
                  // Widget kimliğini belirler
                  key: ValueKey('upload-$index'),
                  // Butona basılınca çalışacak fonksiyonu belirler
                  onPressed: () => _upload(index),
                  // İçerikte gösterilecek widgetı belirler
                  child: const Text('Örnek yükle')),
              // Koşul doğruysa bu işlemi çalıştırır
              if (slot.status == EvidenceStatus.received) ...[
                // Çerçeveli buton oluşturur
                OutlinedButton(
                    // Widget kimliğini belirler
                    key: ValueKey('accept-$index'),
                    // Butona basılınca çalışacak fonksiyonu belirler
                    onPressed: slot.review == EvidenceReview.retake
                        // Koşul doğruysa bu değeri seçer
                        ? null
                        // Koşul yanlışsa bu değeri seçer
                        : () =>
                            // İlgili metodu çalıştırır
                            _change(() => _draft.review(index, accepted: true)),
                    // İçerikte gösterilecek widgetı belirler
                    child: const Text('İnceleme demosu: kabul')),
                // Metin butonu oluşturur
                TextButton(
                    // Butona basılınca çalışacak fonksiyonu belirler
                    onPressed: () =>
                        // İlgili metodu çalıştırır
                        _change(() => _draft.review(index, accepted: false)),
                    // İçerikte gösterilecek widgetı belirler
                    child: const Text('Yeniden örnek iste')),
              ],
            ]),
          ]),
        ));
  }
}

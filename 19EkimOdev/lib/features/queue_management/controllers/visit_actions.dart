// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import '../../../core/theme/app_theme.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// VisitActions sınıfını tanımlar
class VisitActions {
  // Constructor, yeni nesnenin bilgilerini alır
  const VisitActions(this.store);
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // call sonraki işlemini çalıştırır
  void callNext(BuildContext context) {
    // called bilgisini ilgili kaynaktan alır
    final CollectionVisit? called = store.callNext();
    // Değer null ise işlemi çalıştırır
    if (called == null) {
      // show mesaj fonksiyonunu çağırır
      _showMessage(context, 'Sırada bekleyen hasta yok.');
      // Metottan çıkar
      return;
    }
    // show mesaj fonksiyonunu çağırır
    _showMessage(
      // Metodun veya constructorın parametresini tanımlar
      context,
      // Bu metin değerini kullanır
      '${_label(called)} çağrıldı.',
      // with geri alma bilgisini belirler
      withUndo: true,
    );
  }
  // Ziyareti sıradaki işleme geçirir
  void advance(BuildContext context, CollectionVisit visit) {
    // sonraki değerini tanımlar
    final CollectionStatus? next = visit.status.next;
    // Değer null ise işlemi çalıştırır
    if (next == null || !store.advance(visit.id)) {
      // show mesaj fonksiyonunu çağırır
      _showMessage(context, 'Bu işlem için geçerli bir sonraki adım yok.');
      // Metottan çıkar
      return;
    }
    // show mesaj fonksiyonunu çağırır
    _showMessage(
      // Metodun veya constructorın parametresini tanımlar
      context,
      // Bu metin değerini kullanır
      '${_label(visit)} → ${next.label}',
      // with geri alma bilgisini belirler
      withUndo: true,
    );
  }
  // Ziyareti iptal etmeyi dener
  Future<void> cancel(BuildContext context, CollectionVisit visit) async {
    // Koşul sağlanırsa ilgili işlemi yapar
    if (!visit.status.canCancel) return;
    // confirmed durumunu kontrol eder
    final bool confirmed = await showDialog<bool>(
          // context bilgisini belirler
          context: context,
          // Güncel verilere göre arayüzü oluşturur
          builder: (BuildContext ctx) => _CancelDialog(label: _label(visit)),
        // Sonuç null ise varsayılan değeri kullanır
        ) ??
        // Mantıksal sonucu döndürür
        false;
    // Widget hâlâ ekrandaysa işleme devam eder
    if (!confirmed || !context.mounted) return;
    // Koşul sağlanırsa ilgili işlemi yapar
    if (store.cancel(visit.id)) {
      // show mesaj fonksiyonunu çağırır
      _showMessage(context, '${_label(visit)} iptal edildi.', withUndo: true);
    }
  }
  // etiket değerini hesaplar veya döndürür
  String _label(CollectionVisit visit) {
    // p bilgisini ilgili kaynaktan alır
    final DemoPatient? p = store.current.patientOf(visit);
    // numara değerini tanımlar
    final String number = Formatters.queueNumber(visit.queueNumber);
    // p değerini hesaplar veya döndürür
    return p == null
        // Koşul doğruysa bu değeri kullanır
        ? number
        // Koşul yanlışsa bu değeri kullanır
        : '$number · ${Formatters.shortName(p.displayName)}';
  }
  // show mesaj işlemini çalıştırır
  void _showMessage(BuildContext context, String text,
      // İlgili alanın değerini veya görünümünü ayarlar
      {bool withUndo = false}) {
    // messenger değerini tanımlar
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    // İlgili alanın değerini veya görünümünü ayarlar
    messenger
      // Aynı nesne üzerinde işlemi sürdürür
      ..hideCurrentSnackBar()
      // Ekranda kısa bilgilendirme mesajı gösterir
      ..showSnackBar(
        // Kısa bilgilendirme mesajı oluşturur
        SnackBar(
          // içerik yazısını gösterir
          content: Text(text),
          // İşlemin süresini belirler
          duration: const Duration(seconds: 4),
          // action bilgisini belirler
          action: withUndo
              // SnackBarAction nesnesini oluşturur veya kullanır
              ? SnackBarAction(
                  // Gösterilecek etiketi belirler
                  label: 'Geri Al',
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: () {
                    // Koşul sağlanırsa ilgili işlemi yapar
                    if (store.undo()) {
                      // Ekranda kısa bilgilendirme mesajı gösterir
                      messenger.showSnackBar(
                        // Constructor, yeni nesnenin bilgilerini alır
                        const SnackBar(content: Text('Son işlem geri alındı.')),
                      );
                    }
                  },
                )
              // Koşul yanlışsa bu değeri kullanır
              : null,
        ),
      );
  }
}
// _CancelDialog sınıfını tanımlar
class _CancelDialog extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _CancelDialog({required this.label});
  // etiket bilgisini tutar
  final String label;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // coral değerini tanımlar
    final Color coral = context.palette.coral;
    // alert dialog değerini hesaplar veya döndürür
    return AlertDialog(
      // Gösterilecek simgeyi belirler
      icon: Icon(Icons.cancel_outlined, color: coral, size: 32),
      // Başlığını belirler
      title: const Text('İşlem iptal edilsin mi?'),
      // içerik yazısını gösterir
      content: Text(
        // Bu metin değerini kullanır
        '$label kaydı "İptal" durumuna alınacak. '
        // Bu metin değerini kullanır
        'Varsa ilişkili kurgusal numune de iptal edilir.',
      ),
      // İşlem fonksiyonlarını widgeta gönderir
      actions: <Widget>[
        // Metin butonu oluşturur
        TextButton(
          // Basılınca çalışacak fonksiyonu belirler
          onPressed: () => Navigator.of(context).pop(false),
          // İçeride gösterilecek widgetı belirler
          child: const Text('Vazgeç'),
        ),
        // Dolu buton oluşturur
        FilledButton(
          // style bilgisini belirler
          style: FilledButton.styleFrom(
            // Arka plan rengini belirler
            backgroundColor: coral,
            // Yazı ve simge rengini belirler
            foregroundColor: Theme.of(context).colorScheme.surface,
          ),
          // Basılınca çalışacak fonksiyonu belirler
          onPressed: () => Navigator.of(context).pop(true),
          // İçeride gösterilecek widgetı belirler
          child: const Text('İptal Et'),
        ),
      ],
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// info banner dosyasını projeye ekler
import '../../../core/widgets/info_banner.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// hasta intake controller dosyasını projeye ekler
import '../controllers/patient_intake_controller.dart';
// birim selector dosyasını projeye ekler
import '../widgets/department_selector.dart';
// PatientIntakeView ekranını oluşturan sınıf
class PatientIntakeView extends StatefulWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const PatientIntakeView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // oluşturma sonrası işlem için varsayılan değeri belirler
    this.onCreated,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // Değişkeni tanımlar
  final ValueChanged<CollectionVisit>? onCreated;
  // open değerini hesaplar veya döndürür
  static Future<CollectionVisit?> open(
      // İlgili alanın değerini veya görünümünü ayarlar
      BuildContext context, DemoClinicStore store) {
    // Hesaplanan sonucu döndürür
    return Navigator.of(context).push<CollectionVisit>(
      // MaterialPageRoute nesnesini oluşturur veya kullanır
      MaterialPageRoute<CollectionVisit>(
        // Güncel verilere göre arayüzü oluşturur
        builder: (_) => PatientIntakeView(store: store),
        // fullscreen dialog bilgisini belirler
        fullscreenDialog: true,
      ),
    );
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın State sınıfını oluşturur
  State<PatientIntakeView> createState() => _PatientIntakeViewState();
}
// Widgetın değişen durumunu yöneten State sınıfı
class _PatientIntakeViewState extends State<PatientIntakeView> {
  // controller bilgisini tutar
  late final PatientIntakeController _controller;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda çalışır
  void initState() {
    // Üst sınıfın ilgili işlemini çağırır
    super.initState();
    // PatientIntakeController nesnesini oluşturur
    _controller = PatientIntakeController(widget.store);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    _controller.dispose();
    // Üst sınıfın ilgili işlemini çağırır
    super.dispose();
  }
  // submit işlemini çalıştırır
  void _submit() {
    // Metin alanının odağını kapatır
    FocusScope.of(context).unfocus();
    // ziyaret değerini tanımlar
    final CollectionVisit? visit = _controller.submit();
    // Değer null değilse işlemi çalıştırır
    if (visit != null) {
      // Callback varsa yeni ziyareti gönderir
      widget.onCreated?.call(visit);
      // Koşul sağlanırsa ilgili işlemi yapar
      if (Navigator.canPop(context)) {
        // İlgili nesne üzerinden metodu çağırır
        Navigator.of(context).pop(visit);
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // İlgili alan veya listeyi temizler
        _controller.clear();
        // İlgili nesne üzerinden metodu çağırır
        ScaffoldMessenger.of(context)
          // Aynı nesne üzerinde işlemi sürdürür
          ..hideCurrentSnackBar()
          // Ekranda kısa bilgilendirme mesajı gösterir
          ..showSnackBar(
            // Kısa bilgilendirme mesajı oluşturur
            SnackBar(
              // içerik yazısını gösterir
              content: Text(
                  // Bu metin değerini kullanır
                  '${Formatters.queueNumber(visit.queueNumber)} sıraya eklendi.'),
              // İşlemin süresini belirler
              duration: const Duration(seconds: 3),
            ),
          );
      }
    }
  }
  // pick saat işlemini asenkron çalıştırır
  Future<void> _pickTime() async {
    // picked değerini tanımlar
    final TimeOfDay? picked = await showTimePicker(
      // context bilgisini belirler
      context: context,
      // initial saat bilgisini belirler
      initialTime: _controller.appointment.value ?? TimeOfDay.now(),
      // help metin bilgisini belirler
      helpText: 'Randevu saati seçin',
      // cancel metin bilgisini belirler
      cancelText: 'Vazgeç',
      // confirm metin bilgisini belirler
      confirmText: 'Tamam',
      // hour etiket metin bilgisini belirler
      hourLabelText: 'Saat',
      // minute etiket metin bilgisini belirler
      minuteLabelText: 'Dakika',
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, Widget? child) => MediaQuery(
        // Mevcut nesnenin güncellenmiş kopyasını oluşturur
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        // İçeride gösterilecek widgetı belirler
        child: child!,
      ),
    );
    // Değer null değilse işlemi çalıştırır
    if (picked != null) _controller.setAppointment(picked);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // can pop değerini tanımlar
    final bool canPop = Navigator.canPop(context);
    // scaffold değerini hesaplar veya döndürür
    return Scaffold(
      // app bar bilgisini belirler
      appBar: AppBar(
        // Başlığını belirler
        title: const Text('Yeni Hasta Kabulü'),
        // Soldaki simge veya widgetı belirler
        leading: canPop
            // Simge butonu oluşturur
            ? IconButton(
                // Butonun açıklamasını belirler
                tooltip: 'Kapat',
                // Gösterilecek simgeyi belirler
                icon: const Icon(Icons.close_rounded),
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: () => Navigator.of(context).pop(),
              )
            // Koşul yanlışsa bu değeri kullanır
            : null,
      ),
      // body bilgisini belirler
      body: PageFrame(
        // En fazla genişliği belirler
        maxWidth: 680,
        // İçeride gösterilecek widgetı belirler
        child: Form(
          // Widgetın kimlik bilgisini belirler
          key: _controller.formKey,
          // İçeride gösterilecek widgetı belirler
          child: ListView(
            // İç boşlukları belirler
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            // Alt widgetları listeler
            children: <Widget>[
              // sıra preview fonksiyonunu çağırır
              _QueuePreview(store: widget.store),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // Constructor, yeni nesnenin bilgilerini alır
              const InfoBanner(
                // Gösterilecek simgeyi belirler
                icon: Icons.privacy_tip_outlined,
                // Başlığını belirler
                title: 'Yalnızca kurgusal veri girin',
                // mesaj bilgisini belirler
                message: 'TC kimlik no, adres, telefon, tahlil sonucu veya '
                    // Bu metin değerini kullanır
                    'herhangi bir sağlık bilgisi GİRMEYİN. Bu bir eğitim demosudur.',
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 24),
              // etiket fonksiyonunu çağırır
              _Label('Kurgusal hasta adı'),
              // Doğrulamalı metin giriş alanı oluşturur
              TextFormField(
                // Widgetın kimlik bilgisini belirler
                key: const Key('intake_name'),
                // İlgili controllerı widgeta gönderir
                controller: _controller.nameCtrl,
                // Girilen değerin geçerliliğini kontrol eder
                validator: _controller.validateName,
                // Büyük harf kullanımını ayarlar
                textCapitalization: TextCapitalization.words,
                // Klavye işlem tuşunu belirler
                textInputAction: TextInputAction.next,
                // otomatik doğrulama modu bilgisini belirler
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // Görünüm ayarlarını oluşturur
                decoration: const InputDecoration(
                  // Giriş alanının örnek yazısını belirler
                  hintText: 'Ör. Deniz Yıldırım',
                  // prefix simge bilgisini belirler
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // etiket fonksiyonunu çağırır
              _Label('Demo hasta kodu'),
              // Doğrulamalı metin giriş alanı oluşturur
              TextFormField(
                // Widgetın kimlik bilgisini belirler
                key: const Key('intake_code'),
                // İlgili controllerı widgeta gönderir
                controller: _controller.codeCtrl,
                // Girilen değerin geçerliliğini kontrol eder
                validator: _controller.validateCode,
                // Büyük harf kullanımını ayarlar
                textCapitalization: TextCapitalization.characters,
                // otomatik doğrulama modu bilgisini belirler
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // Görünüm ayarlarını oluşturur
                decoration: InputDecoration(
                  // prefix simge bilgisini belirler
                  prefixIcon: const Icon(Icons.badge_outlined),
                  // helper metin bilgisini belirler
                  helperText: 'Otomatik önerilir; gerçek kimlik numarası değildir.',
                  // suffix simge bilgisini belirler
                  suffixIcon: IconButton(
                    // Butonun açıklamasını belirler
                    tooltip: 'Yeni kod öner',
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: _controller.regenerateCode,
                    // Gösterilecek simgeyi belirler
                    icon: const Icon(Icons.autorenew_rounded),
                  ),
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // etiket fonksiyonunu çağırır
              _Label('Hizmet / birim'),
              // DepartmentSelector nesnesini oluşturur veya kullanır
              DepartmentSelector(
                // Seçili olup olmadığını belirler
                selected: _controller.department,
                // Seçilince çalışacak fonksiyonu belirler
                onSelected: _controller.selectDepartment,
                // Girilen değerin geçerliliğini kontrol eder
                validator: _controller.validateDepartment,
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 20),
              // etiket fonksiyonunu çağırır
              _Label('Randevu saati (opsiyonel)'),
              // randevu picker fonksiyonunu çağırır
              _AppointmentPicker(
                // randevu bilgisini belirler
                appointment: _controller.appointment,
                // pick işlemi fonksiyonunu bağlar
                onPick: _pickTime,
                // clear işlemi için callback gönderir
                onClear: () => _controller.setAppointment(null),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // Not nesnesini oluşturur veya kullanır
              _Label('Not (opsiyonel)'),
              // Doğrulamalı metin giriş alanı oluşturur
              TextFormField(
                // İlgili controllerı widgeta gönderir
                controller: _controller.noteCtrl,
                // Girilen değerin geçerliliğini kontrol eder
                validator: _controller.validateNote,
                // Girişte en fazla karakter sayısını belirler
                maxLength: PatientIntakeController.noteMaxLength,
                // Giriş alanının satır sayısını belirler
                maxLines: 2,
                // Görünüm ayarlarını oluşturur
                decoration: const InputDecoration(
                  // Giriş alanının örnek yazısını belirler
                  hintText: 'Ör. Tekerlekli sandalye ile geldi',
                  // prefix simge bilgisini belirler
                  prefixIcon: Icon(Icons.sticky_note_2_outlined),
                ),
              ),
              // Değer değişimlerini dinleyerek arayüzü günceller
              ValueListenableBuilder<String?>(
                // Değişimi takip edilecek değeri dinler
                valueListenable: _controller.submitError,
                // Güncel verilere göre arayüzü oluşturur
                builder: (BuildContext context, String? error, _) {
                  // Değer null ise işlemi çalıştırır
                  if (error == null) return const SizedBox.shrink();
                  // iç boşluk değerini hesaplar veya döndürür
                  return Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.only(top: 8),
                    // İçeride gösterilecek widgetı belirler
                    child: Text(error,
                        // style bilgisini belirler
                        style: theme.textTheme.bodyMedium
                            // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                            ?.copyWith(color: theme.colorScheme.error)),
                  );
                },
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // İlgili işlem butonunu oluşturur
              FilledButton.icon(
                // Widgetın kimlik bilgisini belirler
                key: const Key('intake_submit'),
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: _submit,
                // Gösterilecek simgeyi belirler
                icon: const Icon(Icons.how_to_reg_rounded),
                // Gösterilecek etiketi belirler
                label: const Text('Kaydet ve Sıraya Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// _Label sınıfını tanımlar
class _Label extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _Label(this.text);
  // metin bilgisini tutar
  final String text;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // iç boşluk değerini hesaplar veya döndürür
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      // İçeride gösterilecek widgetı belirler
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
// _QueuePreview sınıfını tanımlar
class _QueuePreview extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _QueuePreview({required this.store});
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<ClinicState>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: store.state,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, ClinicState state, _) {
        // card değerini hesaplar veya döndürür
        return Card(
          // İçeride gösterilecek widgetı belirler
          child: Padding(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(16),
            // İçeride gösterilecek widgetı belirler
            child: Row(
              // Alt widgetları listeler
              children: <Widget>[
                // QueueBadge nesnesini oluşturur veya kullanır
                QueueBadge(
                  // Gösterilecek etiketi belirler
                  label: Formatters.queueNumber(state.nextQueueNumber),
                  // large bilgisini belirler
                  large: true,
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(width: 16),
                // Kalan alanı doldurmasını sağlar
                Expanded(
                  // İçeride gösterilecek widgetı belirler
                  child: Column(
                    // Elemanların çapraz hizasını belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Alt widgetları listeler
                    children: <Widget>[
                      // Metin gösterir
                      Text('Atanacak sıra numarası',
                          // style bilgisini belirler
                          style: theme.textTheme.titleSmall),
                      // Constructor, yeni nesnenin bilgilerini alır
                      const SizedBox(height: 2),
                      // Metin gösterir
                      Text(
                        // Bu metin değerini kullanır
                        'Numaralar gün içinde tekrar kullanılmaz.',
                        // style bilgisini belirler
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// Uygulamanın ana widget sınıfı
class _AppointmentPicker extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _AppointmentPicker({
    // randevu bilgisini zorunlu tutar
    required this.appointment,
    // pick işlemi bilgisini zorunlu tutar
    required this.onPick,
    // clear işlemi bilgisini zorunlu tutar
    required this.onClear,
  });
  // randevu bilgisini tutar
  final ValueNotifier<TimeOfDay?> appointment;
  // pick işlemi bilgisini tutar
  final VoidCallback onPick;
  // clear işlemi bilgisini tutar
  final VoidCallback onClear;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<TimeOfDay?>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: appointment,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, TimeOfDay? time, _) {
        // metin durumunu kontrol eder
        final String text = time == null
            // Koşul doğruysa bu değeri kullanır
            ? 'Saat seçilmedi'
            // Koşul yanlışsa bu değeri kullanır
            : '${time.hour.toString().padLeft(2, '0')}:'
                // Bu metin değerini kullanır
                '${time.minute.toString().padLeft(2, '0')}';
        // row değerini hesaplar veya döndürür
        return Row(
          // Alt widgetları listeler
          children: <Widget>[
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: OutlinedButton.icon(
                // style bilgisini belirler
                style: OutlinedButton.styleFrom(
                  // Hizalama şeklini belirler
                  alignment: Alignment.centerLeft,
                ),
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: onPick,
                // Gösterilecek simgeyi belirler
                icon: const Icon(Icons.schedule_rounded),
                // Gösterilecek etiketi belirler
                label: Text(text),
              ),
            ),
            // Değer null değilse işlemi çalıştırır
            if (time != null) ...<Widget>[
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(width: 8),
              // Simge butonu oluşturur
              IconButton(
                // Butonun açıklamasını belirler
                tooltip: 'Randevu saatini temizle',
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: onClear,
                // Gösterilecek simgeyi belirler
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ],
        );
      },
    );
  }
}

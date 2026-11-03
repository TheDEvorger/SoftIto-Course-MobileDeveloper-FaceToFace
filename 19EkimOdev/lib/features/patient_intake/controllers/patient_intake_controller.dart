// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// PatientIntakeController işlemlerini yöneten sınıf
class PatientIntakeController {
  // Constructor, nesne oluşturmak için bilgileri alır
  PatientIntakeController(this.store)
      // TextEditingController nesnesini oluşturur
      : codeCtrl = TextEditingController(text: store.suggestPatientCode());
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // form widget anahtarı için GlobalKey oluşturur
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // ad ctrl için metin kontrolcüsü oluşturur
  final TextEditingController nameCtrl = TextEditingController();
  // kod ctrl bilgisini tutar
  final TextEditingController codeCtrl;
  // not ctrl için metin kontrolcüsü oluşturur
  final TextEditingController noteCtrl = TextEditingController();
  // birim için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<String?> department = ValueNotifier<String?>(null);
  // randevu için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<TimeOfDay?> appointment = ValueNotifier<TimeOfDay?>(null);
  // submit hata için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<String?> submitError = ValueNotifier<String?>(null);
  // not max uzunluk değerini tanımlar
  static const int noteMaxLength = 120;
  // ad reg exp değerini tanımlar
  static final RegExp _nameRegExp =
      // Constructor, nesne oluşturmak için bilgileri alır
      RegExp(r"^[a-zA-ZçÇğĞıİöÖşŞüÜâÂîÎûÛ\s.'-]+$");
  // kod reg exp değerini tanımlar
  static final RegExp _codeRegExp = RegExp(r'^[A-Z0-9-]{3,16}$');
  // validate ad değerini hesaplar veya döndürür
  String? validateName(String? value) {
    // v değerini tanımlar
    final String v = value?.trim() ?? '';
    // İlgili alan veya liste boşsa kontrol eder
    if (v.isEmpty) return 'Kurgusal hasta adı zorunludur.';
    // Koşul sağlanırsa ilgili işlemi yapar
    if (v.length < 3) return 'En az 3 karakter girin.';
    // Koşul sağlanırsa ilgili işlemi yapar
    if (!_nameRegExp.hasMatch(v)) return 'Yalnızca harf ve boşluk kullanın.';
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // validate kod değerini hesaplar veya döndürür
  String? validateCode(String? value) {
    // v değerini tanımlar
    final String v = value?.trim().toUpperCase() ?? '';
    // İlgili alan veya liste boşsa kontrol eder
    if (v.isEmpty) return 'Demo hasta kodu zorunludur.';
    // Koşul sağlanırsa ilgili işlemi yapar
    if (!_codeRegExp.hasMatch(v)) {
      // Hesaplanan sonucu döndürür
      return '3-16 karakter; harf, rakam ve "-" kullanın.';
    }
    // Koşul sağlanırsa ilgili işlemi yapar
    if (store.isPatientCodeTaken(v)) return 'Bu kod zaten kayıtlı.';
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // validate birim değerini hesaplar veya döndürür
  String? validateDepartment() =>
      // birim değerini değiştirip dinleyenleri günceller
      department.value == null ? 'Lütfen bir hizmet / birim seçin.' : null;
  // validate not değerini hesaplar veya döndürür
  String? validateNote(String? value) {
    // Koşul sağlanırsa ilgili işlemi yapar
    if ((value?.trim().length ?? 0) > noteMaxLength) {
      // Hesaplanan sonucu döndürür
      return 'Not en fazla $noteMaxLength karakter olabilir.';
    }
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // select birim işlemini çalıştırır
  void selectDepartment(String value) => department.value = value;
  // set randevu işlemini çalıştırır
  void setAppointment(TimeOfDay? time) => appointment.value = time;
  // regenerate kod işlemini çalıştırır
  void regenerateCode() => codeCtrl.text = store.suggestPatientCode();
  // Filtreleri veya alanları temizler
  void clear() {
    // İlgili alan veya listeyi temizler
    nameCtrl.clear();
    // kod ctrl bilgisini günceller
    codeCtrl.text = store.suggestPatientCode();
    // İlgili alan veya listeyi temizler
    noteCtrl.clear();
    // birim değerini değiştirip dinleyenleri günceller
    department.value = null;
    // randevu değerini değiştirip dinleyenleri günceller
    appointment.value = null;
    // submit hata değerini değiştirip dinleyenleri günceller
    submitError.value = null;
  }
  // Formu kontrol edip kaydeder
  CollectionVisit? submit() {
    // submit hata değerini değiştirip dinleyenleri günceller
    submitError.value = null;
    // geçerlilik değerini tanımlar
    final bool valid = formKey.currentState?.validate() ?? false;
    // Koşul sağlanırsa ilgili işlemi yapar
    if (!valid) return null;
    // Hata oluşturabilecek işlemleri dener
    try {
      // Hesaplanan sonucu döndürür
      return store.registerPatient(
        // görünen ad bilgisini belirler
        displayName: nameCtrl.text,
        // kod bilgisini belirler
        code: codeCtrl.text,
        // birim bilgisini belirler
        department: department.value!,
        // randevu zamanı için tarih bilgisini atar
        appointmentAt: _appointmentAsDateTime(),
        // not bilgisini belirler
        note: noteCtrl.text,
      );
    // Belirtilen hata oluşursa burası çalışır
    } on ArgumentError catch (e) {
      // submit hata değerini değiştirip dinleyenleri günceller
      submitError.value = e.message.toString();
      // Uygun sonuç yoksa null döndürür
      return null;
    }
  }
  // randevu as tarih saat değerini hesaplar veya döndürür
  DateTime? _appointmentAsDateTime() {
    // t değerini tanımlar
    final TimeOfDay? t = appointment.value;
    // Değer null ise işlemi çalıştırır
    if (t == null) return null;
    // Güncel tarih ve saati now değişkenine alır
    final DateTime now = DateTime.now();
    // tarih saat değerini hesaplar veya döndürür
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    nameCtrl.dispose();
    // İlgili controller veya notifierı temizler
    codeCtrl.dispose();
    // İlgili controller veya notifierı temizler
    noteCtrl.dispose();
    // İlgili controller veya notifierı temizler
    department.dispose();
    // İlgili controller veya notifierı temizler
    appointment.dispose();
    // İlgili controller veya notifierı temizler
    submitError.dispose();
  }
}

// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// formatters dosyasını projeye ekler
import '../../core/utils/formatters.dart';
// activity entry dosyasını projeye ekler
import '../models/activity_entry.dart';
// collection durum dosyasını projeye ekler
import '../models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../models/demo_patient.dart';
// demo numune dosyasını projeye ekler
import '../models/demo_specimen.dart';
// clinic durum dosyasını projeye ekler
import 'clinic_state.dart';
// demo seed dosyasını projeye ekler
import 'demo_seed.dart';
// DemoClinicStore verilerini yöneten sınıf
class DemoClinicStore {
  // Constructor, nesne oluşturmak için bilgileri alır
  DemoClinicStore({DateTime Function()? clock})
      // Constructor içindeki alanın başlangıç değerini belirler
      : _clock = clock ?? DateTime.now,
        // ValueNotifier nesnesini oluşturur veya kullanır
        state = ValueNotifier<ClinicState>(
            // Başlangıç için örnek klinik verileri oluşturur
            buildDemoSeed((clock ?? DateTime.now)()));
  // Function nesnesini oluşturur veya kullanır
  final DateTime Function() _clock;
  // durum bilgisini tutar
  final ValueNotifier<ClinicState> state;
  // geri alınabilirlik için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<bool> canUndo = ValueNotifier<bool>(false);
  // geri alma anlık görüntü parametresini alır
  ClinicState? _undoSnapshot;
  // max activities değerini tanımlar
  static const int _maxActivities = 40;
  // güncel bilgisini döndürür
  ClinicState get current => state.value;
  // Kullanılmayan yeni hasta kodunu önerir
  String suggestPatientCode() {
    // n değerini tanımlar
    int n = current.nextPatientCodeNumber;
    // Koşul devam ettiği sürece döngüyü çalıştırır
    while (isPatientCodeTaken('DEMO-$n')) {
      // n değerini bir artırır
      n++;
    }
    // Hesaplanan sonucu döndürür
    return 'DEMO-$n';
  }
  // Hasta kodunun daha önce kullanılıp kullanılmadığını kontrol eder
  bool isPatientCodeTaken(String code) {
    // normalized değerini tanımlar
    final String normalized = code.trim().toUpperCase();
    // Hesaplanan sonucu döndürür
    return current.patients.values
        // Koşula uyan en az bir eleman olup olmadığını kontrol eder
        .any((DemoPatient p) => p.code.toUpperCase() == normalized);
  }
  // Yeni hastayı kaydedip sıraya ekler
  CollectionVisit registerPatient({
    // Bu parametrenin verilmesini zorunlu tutar
    required String displayName,
    // Bu parametrenin verilmesini zorunlu tutar
    required String code,
    // Bu parametrenin verilmesini zorunlu tutar
    required String department,
    // Metodun veya constructorın parametresini tanımlar
    DateTime? appointmentAt,
    // Metodun veya constructorın parametresini tanımlar
    String? note,
  }) {
    // ad değerini tanımlar
    final String name = displayName.trim();
    // normalized kod değerini tanımlar
    final String normalizedCode = code.trim().toUpperCase();
    // İlgili alan veya liste boşsa kontrol eder
    if (name.isEmpty) throw ArgumentError('Hasta adı boş olamaz.');
    // İlgili alan veya liste boşsa kontrol eder
    if (normalizedCode.isEmpty) throw ArgumentError('Hasta kodu boş olamaz.');
    // İlgili alan veya liste boşsa kontrol eder
    if (department.trim().isEmpty) throw ArgumentError('Birim seçilmelidir.');
    // Koşul sağlanırsa ilgili işlemi yapar
    if (isPatientCodeTaken(normalizedCode)) {
      // Geçersiz işlem için hata fırlatır
      throw ArgumentError('Bu demo hasta kodu zaten kayıtlı.');
    }
    // s değerini tanımlar
    final ClinicState s = current;
    // now değerini tanımlar
    final DateTime now = _clock();
    // seed değerini tanımlar
    final int seed = s.idSeed + 1;
    // hasta ID değerini tanımlar
    final String patientId = 'p$seed';
    // ziyaret ID değerini tanımlar
    final String visitId = 'v$seed';
    // sıra numarası değerini tanımlar
    final int queueNumber = s.nextQueueNumber;
    // trimmed not değerini tanımlar
    final String trimmedNote = note?.trim() ?? '';
    // hasta değerini tanımlar
    final DemoPatient patient = DemoPatient(
      // ID bilgisini belirler
      id: patientId,
      // görünen ad bilgisini belirler
      displayName: name,
      // kod bilgisini belirler
      code: normalizedCode,
      // birim bilgisini belirler
      department: department,
    );
    // ziyaret değerini tanımlar
    final CollectionVisit visit = CollectionVisit(
      // ID bilgisini belirler
      id: visitId,
      // hasta ID bilgisini belirler
      patientId: patientId,
      // sıra numarası bilgisini belirler
      queueNumber: queueNumber,
      // oluşturulma zamanı bilgisini belirler
      createdAt: now,
      // durum bilgisini belirler
      status: CollectionStatus.waiting,
      // durum geçmişi için tarih bilgisini atar
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(
          // Verileri belirtilen tipte koleksiyona ekler
          <CollectionStatus, DateTime>{CollectionStatus.waiting: now}),
      // randevu zamanı bilgisini belirler
      appointmentAt: appointmentAt,
      // not bilgisini belirler
      note: trimmedNote.isEmpty ? null : trimmedNote,
    );
    // activity değerini tanımlar
    final ActivityEntry activity = ActivityEntry(
      // ID bilgisini belirler
      id: 'a$seed',
      // mesaj bilgisini belirler
      message: describeActivity(CollectionStatus.waiting, _label(visit, patient)),
      // zaman bilgisini belirler
      timestamp: now,
      // durum bilgisini belirler
      status: CollectionStatus.waiting,
      // ziyaret ID bilgisini belirler
      visitId: visitId,
    );
    // clear geri alma fonksiyonunu çağırır
    _clearUndo();
    // durum değerini değiştirip dinleyenleri günceller
    state.value = s.copyWith(
      // hastalar bilgisini belirler
      patients: Map<String, DemoPatient>.unmodifiable(
          // Verileri belirtilen tipte koleksiyona ekler
          <String, DemoPatient>{...s.patients, patientId: patient}),
      // ziyaretler bilgisini belirler
      visits: List<CollectionVisit>.unmodifiable(
          // Verileri belirtilen tipte listeye ekler
          <CollectionVisit>[...s.visits, visit]),
      // activities bilgisini belirler
      activities: _prependActivity(s.activities, activity),
      // sonraki sıra numarası bilgisini belirler
      nextQueueNumber: queueNumber + 1,
      // sonraki hasta kodu numarası bilgisini belirler
      nextPatientCodeNumber: s.nextPatientCodeNumber + 1,
      // ID seed bilgisini belirler
      idSeed: seed,
    );
    // Hesaplanan sonucu döndürür
    return visit;
  }
  // Ziyaretin durumunu kurallara göre değiştirir
  bool changeStatus(String visitId, CollectionStatus target) {
    // s değerini tanımlar
    final ClinicState s = current;
    // ziyaret değerini tanımlar
    final CollectionVisit? visit = s.visitById(visitId);
    // Değer null ise işlemi çalıştırır
    if (visit == null || !visit.status.canTransitionTo(target)) return false;
    // now değerini tanımlar
    final DateTime now = _clock();
    // hasta değerini tanımlar
    final DemoPatient? patient = s.patientOf(visit);
    // updated değerini tanımlar
    final CollectionVisit updated = visit.withStatus(target, now);
    // seed değerini tanımlar
    int seed = s.idSeed;
    // sonraki numune değerini tanımlar
    int nextSpecimen = s.nextSpecimenNumber;
    // numuneler değerini tanımlar
    List<DemoSpecimen> specimens = s.specimens;
    // Değere göre uygun işlem dalını seçer
    switch (target) {
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.sampleCollected:
        // seed değerini bir artırır
        seed++;
        // numuneler bilgisini günceller
        specimens = <DemoSpecimen>[
          // Önceki listedeki elemanları buraya ekler
          ...specimens,
          // Yeni DemoSpecimen nesnesi oluşturur
          DemoSpecimen(
            // ID bilgisini belirler
            id: 's$seed',
            // kod bilgisini belirler
            code: buildSpecimenCode(now, nextSpecimen),
            // ziyaret ID bilgisini belirler
            visitId: visitId,
            // oluşturulma zamanı bilgisini belirler
            createdAt: now,
            // durum bilgisini belirler
            status: SpecimenStatus.awaitingDelivery,
          ),
        ];
        // sonraki numune değerini bir artırır
        nextSpecimen++;
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.delivered:
        // numuneler bilgisini günceller
        specimens = _updateSpecimen(
          // Metodun veya constructorın parametresini tanımlar
          specimens,
          // Metodun veya constructorın parametresini tanımlar
          visitId,
          // Bu eleman için dönüşüm veya karşılaştırma yapar
          (DemoSpecimen sp) =>
              // Mevcut nesnenin güncellenmiş kopyasını oluşturur
              sp.copyWith(status: SpecimenStatus.delivered, deliveredAt: now),
        );
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.cancelled:
        // numuneler bilgisini günceller
        specimens = _updateSpecimen(
          // Metodun veya constructorın parametresini tanımlar
          specimens,
          // Metodun veya constructorın parametresini tanımlar
          visitId,
          // Mevcut nesnenin güncellenmiş kopyasını oluşturur
          (DemoSpecimen sp) => sp.copyWith(status: SpecimenStatus.cancelled),
        );
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.waiting:
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.called:
      // Eşleşen durum için bu işlemi çalıştırır
      case CollectionStatus.inProgress:
        // Bu işlem dalından çıkar
        break;
    }
    // seed değerini bir artırır
    seed++;
    // activity değerini tanımlar
    final ActivityEntry activity = ActivityEntry(
      // ID bilgisini belirler
      id: 'a$seed',
      // mesaj bilgisini belirler
      message: describeActivity(target, _label(visit, patient)),
      // zaman bilgisini belirler
      timestamp: now,
      // durum bilgisini belirler
      status: target,
      // ziyaret ID bilgisini belirler
      visitId: visitId,
    );
    // geri alma anlık görüntü bilgisini günceller
    _undoSnapshot = s;
    // geri alınabilirlik değerini değiştirip dinleyenleri günceller
    canUndo.value = true;
    // durum değerini değiştirip dinleyenleri günceller
    state.value = s.copyWith(
      // ziyaretler bilgisini belirler
      visits: List<CollectionVisit>.unmodifiable(
        // İlgili nesne üzerinden metodu çağırır
        s.visits.map((CollectionVisit v) => v.id == visitId ? updated : v),
      ),
      // numuneler bilgisini belirler
      specimens: List<DemoSpecimen>.unmodifiable(specimens),
      // activities bilgisini belirler
      activities: _prependActivity(s.activities, activity),
      // sonraki numune numara bilgisini belirler
      nextSpecimenNumber: nextSpecimen,
      // ID seed bilgisini belirler
      idSeed: seed,
    );
    // İşlem başarılıysa true döndürür
    return true;
  }
  // Ziyareti sıradaki işleme geçirir
  bool advance(String visitId) {
    // sonraki değerini tanımlar
    final CollectionStatus? next = current.visitById(visitId)?.status.next;
    // Değer null ise işlemi çalıştırır
    if (next == null) return false;
    // Ziyaretin durumunu kurallara göre değiştirir
    return changeStatus(visitId, next);
  }
  // Ziyareti iptal etmeyi dener
  bool cancel(String visitId) =>
      // Ziyaretin durumunu kurallara göre değiştirir
      changeStatus(visitId, CollectionStatus.cancelled);
  // call sonraki değerini hesaplar veya döndürür
  CollectionVisit? callNext() {
    // sonraki değerini tanımlar
    final CollectionVisit? next = current.nextWaiting;
    // Değer null ise işlemi çalıştırır
    if (next == null) return null;
    // Ziyaretin durumunu kurallara göre değiştirir
    changeStatus(next.id, CollectionStatus.called);
    // Hesaplanan sonucu döndürür
    return current.visitById(next.id);
  }
  // Son işlemden önceki duruma döndürür
  bool undo() {
    // anlık görüntü değerini tanımlar
    final ClinicState? snapshot = _undoSnapshot;
    // Değer null ise işlemi çalıştırır
    if (snapshot == null) return false;
    // clear geri alma fonksiyonunu çağırır
    _clearUndo();
    // durum değerini değiştirip dinleyenleri günceller
    state.value = snapshot;
    // İşlem başarılıysa true döndürür
    return true;
  }
  // reset işlemini çalıştırır
  void reset() {
    // clear geri alma fonksiyonunu çağırır
    _clearUndo();
    // durum değerini değiştirip dinleyenleri günceller
    state.value = buildDemoSeed(_clock());
  }
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    state.dispose();
    // İlgili controller veya notifierı temizler
    canUndo.dispose();
  }
  // clear geri alma işlemini çalıştırır
  void _clearUndo() {
    // geri alma anlık görüntü bilgisini günceller
    _undoSnapshot = null;
    // geri alınabilirlik değerini değiştirip dinleyenleri günceller
    canUndo.value = false;
  }
  // etiket değerini hesaplar veya döndürür
  String _label(CollectionVisit visit, DemoPatient? patient) {
    // numara değerini tanımlar
    final String number = Formatters.queueNumber(visit.queueNumber);
    // Değer null ise işlemi çalıştırır
    if (patient == null) return number;
    // Hesaplanan sonucu döndürür
    return '$number · ${Formatters.shortName(patient.displayName)}';
  }
  // prepend activity değerini hesaplar veya döndürür
  List<ActivityEntry> _prependActivity(
      // İlgili alanın değerini veya görünümünü ayarlar
      List<ActivityEntry> list, ActivityEntry entry) {
    // Hesaplanan sonucu döndürür
    return List<ActivityEntry>.unmodifiable(
      // Verileri belirtilen tipte listeye ekler
      <ActivityEntry>[entry, ...list].take(_maxActivities),
    );
  }
  // update numune değerini hesaplar veya döndürür
  List<DemoSpecimen> _updateSpecimen(
    // Metodun veya constructorın parametresini tanımlar
    List<DemoSpecimen> list,
    // Metodun veya constructorın parametresini tanımlar
    String visitId,
    // function değerini hesaplar veya döndürür
    DemoSpecimen Function(DemoSpecimen) update,
  ) {
    // Hesaplanan sonucu döndürür
    return list
        // Listedeki elemanları dönüştürür
        .map((DemoSpecimen sp) => sp.visitId == visitId ? update(sp) : sp)
        // Sonucu listeye çevirir
        .toList();
  }
}

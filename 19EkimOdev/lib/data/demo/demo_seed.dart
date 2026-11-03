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
// demo departments listesini oluşturur
const List<String> demoDepartments = <String>[
  // Bu metin değerini kullanır
  'Dahiliye',
  // Bu metin değerini kullanır
  'Kardiyoloji',
  // Bu metin değerini kullanır
  'Endokrinoloji',
  // Bu metin değerini kullanır
  'Nefroloji',
  // Bu metin değerini kullanır
  'Hematoloji',
  // Bu metin değerini kullanır
  'Genel Check-up',
];
// build numune kod değerini hesaplar veya döndürür
String buildSpecimenCode(DateTime date, int number) {
  // mm değerini tanımlar
  final String mm = date.month.toString().padLeft(2, '0');
  // dd değerini tanımlar
  final String dd = date.day.toString().padLeft(2, '0');
  // Hesaplanan sonucu döndürür
  return 'NM-$mm$dd-${number.toString().padLeft(4, '0')}';
}
// _SeedRow sınıfını tanımlar
class _SeedRow {
  // Constructor, yeni nesnenin bilgilerini alır
  const _SeedRow(this.name, this.department, this.status, this.minutesAgo);
  // ad bilgisini tutar
  final String name;
  // birim bilgisini tutar
  final String department;
  // durum bilgisini tutar
  final CollectionStatus status;
  // minutes ago bilgisini tutar
  final int minutesAgo;
}
// rows listesini oluşturur
const List<_SeedRow> _rows = <_SeedRow>[
  // seed row fonksiyonunu çağırır
  _SeedRow('Ada Kaya', 'Dahiliye', CollectionStatus.delivered, 95),
  // seed row fonksiyonunu çağırır
  _SeedRow('Deniz Çelik', 'Genel Check-up', CollectionStatus.delivered, 82),
  // seed row fonksiyonunu çağırır
  _SeedRow('Mert Aydın', 'Kardiyoloji', CollectionStatus.sampleCollected, 64),
  // seed row fonksiyonunu çağırır
  _SeedRow('Burak Yıldız', 'Kardiyoloji', CollectionStatus.cancelled, 55),
  // seed row fonksiyonunu çağırır
  _SeedRow('Elif Demir', 'Endokrinoloji', CollectionStatus.inProgress, 41),
  // seed row fonksiyonunu çağırır
  _SeedRow('Can Öztürk', 'Genel Check-up', CollectionStatus.called, 30),
  // seed row fonksiyonunu çağırır
  _SeedRow('Zeynep Arslan', 'Dahiliye', CollectionStatus.waiting, 22),
  // seed row fonksiyonunu çağırır
  _SeedRow('Emre Şahin', 'Nefroloji', CollectionStatus.waiting, 14),
  // seed row fonksiyonunu çağırır
  _SeedRow('Selin Koç', 'Hematoloji', CollectionStatus.waiting, 6),
];
// Başlangıç için örnek klinik verileri oluşturur
ClinicState buildDemoSeed(DateTime now) {
  // hastalar listesini oluşturur
  final Map<String, DemoPatient> patients = <String, DemoPatient>{};
  // ziyaretler listesini oluşturur
  final List<CollectionVisit> visits = <CollectionVisit>[];
  // numuneler listesini oluşturur
  final List<DemoSpecimen> specimens = <DemoSpecimen>[];
  // activities listesini oluşturur
  final List<ActivityEntry> activities = <ActivityEntry>[];
  // numune numara değerini tanımlar
  int specimenNumber = 1;
  // activity ID değerini tanımlar
  int activityId = 0;
  // Belirlenen sayı kadar döngüyü çalıştırır
  for (int i = 0; i < _rows.length; i++) {
    // row bilgisini hesaplayıp saklar
    final _SeedRow row = _rows[i];
    // sıra numarası değerini tanımlar
    final int queueNumber = i + 1;
    // hasta ID değerini tanımlar
    final String patientId = 'p$queueNumber';
    // ziyaret ID değerini tanımlar
    final String visitId = 'v$queueNumber';
    // oluşturulma zamanı değerini tanımlar
    final DateTime createdAt = now.subtract(Duration(minutes: row.minutesAgo));
    // Yeni DemoPatient nesnesi oluşturur
    patients[patientId] = DemoPatient(
      // ID bilgisini belirler
      id: patientId,
      // görünen ad bilgisini belirler
      displayName: row.name,
      // kod bilgisini belirler
      code: 'DEMO-${1000 + queueNumber}',
      // birim bilgisini belirler
      department: row.department,
    );
    // geçmiş değerini tanımlar
    final Map<CollectionStatus, DateTime> history =
        // Verileri belirtilen tipte koleksiyona ekler
        <CollectionStatus, DateTime>{CollectionStatus.waiting: createdAt};
    // Koşul sağlanırsa ilgili işlemi yapar
    if (row.status == CollectionStatus.cancelled) {
      // geçmiş bilgisini günceller
      history[CollectionStatus.cancelled] =
          // İlgili nesne üzerinden metodu çağırır
          createdAt.add(const Duration(minutes: 5));
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // Belirlenen sayı kadar döngüyü çalıştırır
      for (int step = 1; step <= row.status.flowIndex; step++) {
        // İlgili alanın değerini veya görünümünü ayarlar
        history[CollectionStatusX.flow[step]] =
            // İlgili nesne üzerinden metodu çağırır
            createdAt.add(Duration(minutes: step * 4));
      }
    }
    // İlgili nesne üzerinden metodu çağırır
    visits.add(CollectionVisit(
      // ID bilgisini belirler
      id: visitId,
      // hasta ID bilgisini belirler
      patientId: patientId,
      // sıra numarası bilgisini belirler
      queueNumber: queueNumber,
      // oluşturulma zamanı bilgisini belirler
      createdAt: createdAt,
      // durum bilgisini belirler
      status: row.status,
      // durum geçmişi için tarih bilgisini atar
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(history),
    ));
    // numune alınma zamanı değerini tanımlar
    final DateTime? collectedAt = history[CollectionStatus.sampleCollected];
    // Değer null değilse işlemi çalıştırır
    if (collectedAt != null) {
      // delivered durumunu kontrol eder
      final bool delivered = row.status == CollectionStatus.delivered;
      // İlgili nesne üzerinden metodu çağırır
      specimens.add(DemoSpecimen(
        // ID bilgisini belirler
        id: 's$specimenNumber',
        // kod bilgisini belirler
        code: buildSpecimenCode(now, specimenNumber),
        // ziyaret ID bilgisini belirler
        visitId: visitId,
        // oluşturulma zamanı bilgisini belirler
        createdAt: collectedAt,
        // durum bilgisini belirler
        status: delivered
            // Koşul doğruysa bu değeri kullanır
            ? SpecimenStatus.delivered
            // Koşul yanlışsa bu değeri kullanır
            : SpecimenStatus.awaitingDelivery,
        // teslim zamanı bilgisini belirler
        deliveredAt: history[CollectionStatus.delivered],
      ));
      // numune numara değerini bir artırır
      specimenNumber++;
    }
    // etiket değerini tanımlar
    final String label =
        // Bu metin değerini kullanır
        '${Formatters.queueNumber(queueNumber)} · ${Formatters.shortName(row.name)}';
    // Durum geçmişindeki kayıtları tek tek dolaşır
    history.forEach((CollectionStatus status, DateTime at) {
      // İlgili nesne üzerinden metodu çağırır
      activities.add(ActivityEntry(
        // ID bilgisini belirler
        id: 'a${activityId++}',
        // mesaj bilgisini belirler
        message: describeActivity(status, label),
        // zaman bilgisini belirler
        timestamp: at,
        // durum bilgisini belirler
        status: status,
        // ziyaret ID bilgisini belirler
        visitId: visitId,
      ));
    });
  }
  // Listeyi belirtilen kurala göre sıralar
  activities.sort(
      // Bu eleman için dönüşüm veya karşılaştırma yapar
      (ActivityEntry a, ActivityEntry b) => b.timestamp.compareTo(a.timestamp));
  // clinic durum değerini hesaplar veya döndürür
  return ClinicState(
    // hastalar bilgisini belirler
    patients: Map<String, DemoPatient>.unmodifiable(patients),
    // ziyaretler bilgisini belirler
    visits: List<CollectionVisit>.unmodifiable(visits),
    // numuneler bilgisini belirler
    specimens: List<DemoSpecimen>.unmodifiable(specimens),
    // activities bilgisini belirler
    activities: List<ActivityEntry>.unmodifiable(activities),
    // sonraki sıra numarası bilgisini belirler
    nextQueueNumber: _rows.length + 1,
    // sonraki numune numara bilgisini belirler
    nextSpecimenNumber: specimenNumber,
    // sonraki hasta kodu numarası bilgisini belirler
    nextPatientCodeNumber: 1000 + _rows.length + 1,
    // ID seed bilgisini belirler
    idSeed: 1000,
  );
}
// describe activity değerini hesaplar veya döndürür
String describeActivity(CollectionStatus status, String label) {
  // switch değerini hesaplar veya döndürür
  return switch (status) {
    // collection durum bilgisini günceller
    CollectionStatus.waiting => '$label sıraya eklendi',
    // collection durum bilgisini günceller
    CollectionStatus.called => '$label çağrıldı',
    // collection durum bilgisini günceller
    CollectionStatus.inProgress => '$label için kan alma işlemi başladı',
    // collection durum bilgisini günceller
    CollectionStatus.sampleCollected => '$label numunesi alındı',
    // collection durum bilgisini günceller
    CollectionStatus.delivered => '$label numunesi laboratuvara teslim edildi',
    // collection durum bilgisini günceller
    CollectionStatus.cancelled => '$label işlemi iptal edildi',
  };
}

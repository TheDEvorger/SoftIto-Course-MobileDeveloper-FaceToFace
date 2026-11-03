// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// demo numune dosyasını projeye ekler
import '../../../data/models/demo_specimen.dart';
// numune row dosyasını projeye ekler
import '../models/specimen_row.dart';
// SampleTrackingController işlemlerini yöneten sınıf
class SampleTrackingController {
  // arama metni için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<String> query = ValueNotifier<String>('');
  // filtre değerini tanımlar
  final ValueNotifier<SpecimenStatus?> filter =
      // ValueNotifier nesnesini oluşturur veya kullanır
      ValueNotifier<SpecimenStatus?>(null);
  // arama işlemini çalıştırır
  void search(String text) => query.value = text;
  // Aktif filtreyi değiştirir
  void setFilter(SpecimenStatus? status) => filter.value = status;
  // apply değerini hesaplar veya döndürür
  static List<SpecimenRow> apply(
    // İlgili alanın değerini veya görünümünü ayarlar
    ClinicState state, {
    // arama metni değerini hesaplar veya döndürür
    String query = '',
    // Metodun veya constructorın parametresini tanımlar
    SpecimenStatus? filter,
  }) {
    // q değerini tanımlar
    final String q = Formatters.searchKey(query);
    // rows listesini oluşturur
    final List<SpecimenRow> rows = <SpecimenRow>[];
    // Listedeki elemanları sırayla dolaşır
    for (final DemoSpecimen s in state.specimens) {
      // Değer null değilse işlemi çalıştırır
      if (filter != null && s.status != filter) continue;
      // ziyaret değerini tanımlar
      final CollectionVisit? visit = state.visitById(s.visitId);
      // hasta durumunu kontrol eder
      final DemoPatient? patient = visit == null ? null : state.patientOf(visit);
      // İlgili alan veya liste doluysa kontrol eder
      if (q.isNotEmpty) {
        // haystack durumunu kontrol eder
        final String haystack = Formatters.searchKey(<String>[
          // kod değerini listeye ekler
          s.code,
          // Değer null değilse işlemi çalıştırır
          if (visit != null) Formatters.queueNumber(visit.queueNumber),
          // İlgili alanın değerini veya görünümünü ayarlar
          patient?.displayName ?? '',
          // İlgili alanın değerini veya görünümünü ayarlar
          patient?.code ?? '',
        // İlgili alanın değerini veya görünümünü ayarlar
        ].join(' '));
        // Koşul sağlanırsa ilgili işlemi yapar
        if (!haystack.contains(q)) continue;
      }
      // İlgili nesne üzerinden metodu çağırır
      rows.add(SpecimenRow(specimen: s, visit: visit, patient: patient));
    }
    // Listeyi belirtilen kurala göre sıralar
    rows.sort((SpecimenRow a, SpecimenRow b) =>
        // İlgili nesne üzerinden metodu çağırır
        b.specimen.createdAt.compareTo(a.specimen.createdAt));
    // Hesaplanan sonucu döndürür
    return rows;
  }
  // sayı by durum değerini hesaplar veya döndürür
  static int countByStatus(ClinicState state, SpecimenStatus status) =>
      // Kayıtları verilen koşula göre filtreler
      state.specimens.where((DemoSpecimen s) => s.status == status).length;
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    query.dispose();
    // İlgili controller veya notifierı temizler
    filter.dispose();
  }
}

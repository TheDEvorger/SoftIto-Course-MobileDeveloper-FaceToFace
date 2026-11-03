// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// QueueController işlemlerini yöneten sınıf
class QueueController {
  // arama metni için değişiklikleri bildiren ValueNotifier oluşturur
  final ValueNotifier<String> query = ValueNotifier<String>('');
  // filtre değerini tanımlar
  final ValueNotifier<CollectionStatus?> filter =
      // ValueNotifier nesnesini oluşturur veya kullanır
      ValueNotifier<CollectionStatus?>(null);
  // arama işlemini çalıştırır
  void search(String text) => query.value = text;
  // Aktif filtreyi değiştirir
  void setFilter(CollectionStatus? status) => filter.value = status;
  // Filtreleri veya alanları temizler
  void clear() {
    // arama metni değerini değiştirip dinleyenleri günceller
    query.value = '';
    // filtre değerini değiştirip dinleyenleri günceller
    filter.value = null;
  }
  // apply değerini hesaplar veya döndürür
  static List<CollectionVisit> apply(
    // İlgili alanın değerini veya görünümünü ayarlar
    ClinicState state, {
    // arama metni değerini hesaplar veya döndürür
    String query = '',
    // Metodun veya constructorın parametresini tanımlar
    CollectionStatus? filter,
  }) {
    // q değerini tanımlar
    final String q = Formatters.searchKey(query);
    // result değerini tanımlar
    final List<CollectionVisit> result =
        // Kayıtları verilen koşula göre filtreler
        state.visits.where((CollectionVisit v) {
      // Değer null değilse işlemi çalıştırır
      if (filter != null && v.status != filter) return false;
      // İlgili alan veya liste boşsa kontrol eder
      if (q.isEmpty) return true;
      // p değerini tanımlar
      final DemoPatient? p = state.patientOf(v);
      // haystack durumunu kontrol eder
      final String haystack = Formatters.searchKey(<String>[
        // Değeri ekranda gösterilecek biçime çevirir
        Formatters.queueNumber(v.queueNumber),
        // İlgili nesne üzerinden metodu çağırır
        v.queueNumber.toString(),
        // İlgili alanın değerini veya görünümünü ayarlar
        p?.displayName ?? '',
        // İlgili alanın değerini veya görünümünü ayarlar
        p?.code ?? '',
        // İlgili alanın değerini veya görünümünü ayarlar
        p?.department ?? '',
      // İlgili alanın değerini veya görünümünü ayarlar
      ].join(' '));
      // Hesaplanan sonucu döndürür
      return haystack.contains(q);
    // İlgili alanın değerini veya görünümünü ayarlar
    }).toList();
    // Listeyi belirtilen kurala göre sıralar
    result.sort((CollectionVisit a, CollectionVisit b) {
      // group a değerini tanımlar
      final int groupA = a.status.isTerminal ? 1 : 0;
      // group b değerini tanımlar
      final int groupB = b.status.isTerminal ? 1 : 0;
      // Koşul sağlanırsa ilgili işlemi yapar
      if (groupA != groupB) return groupA.compareTo(groupB);
      // Hesaplanan sonucu döndürür
      return a.queueNumber.compareTo(b.queueNumber);
    });
    // Hesaplanan sonucu döndürür
    return result;
  }
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // İlgili controller veya notifierı temizler
    query.dispose();
    // İlgili controller veya notifierı temizler
    filter.dispose();
  }
}

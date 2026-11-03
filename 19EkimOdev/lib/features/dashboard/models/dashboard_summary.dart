// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// collection durum dosyasını projeye ekler
import '../../../data/models/collection_status.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// DashboardSummary bilgilerini tutan model sınıfı
class DashboardSummary {
  // Constructor, yeni nesnenin bilgilerini alır
  const DashboardSummary({
    // waiting bilgisini zorunlu tutar
    required this.waiting,
    // called bilgisini zorunlu tutar
    required this.called,
    // in ilerleme bilgisini zorunlu tutar
    required this.inProgress,
    // sample collected bilgisini zorunlu tutar
    required this.sampleCollected,
    // delivered bilgisini zorunlu tutar
    required this.delivered,
    // cancelled bilgisini zorunlu tutar
    required this.cancelled,
    // aktiflik ziyaretler bilgisini zorunlu tutar
    required this.activeVisits,
  });
  // DashboardSummary.fromState ile veriden yeni nesne oluşturur
  factory DashboardSummary.fromState(ClinicState state) {
    // dashboard summary değerini hesaplar veya döndürür
    return DashboardSummary(
      // waiting bilgisini belirler
      waiting: state.countByStatus(CollectionStatus.waiting),
      // called bilgisini belirler
      called: state.countByStatus(CollectionStatus.called),
      // in ilerleme bilgisini belirler
      inProgress: state.countByStatus(CollectionStatus.inProgress),
      // sample collected bilgisini belirler
      sampleCollected: state.countByStatus(CollectionStatus.sampleCollected),
      // delivered bilgisini belirler
      delivered: state.countByStatus(CollectionStatus.delivered),
      // cancelled bilgisini belirler
      cancelled: state.countByStatus(CollectionStatus.cancelled),
      // aktiflik ziyaretler bilgisini belirler
      activeVisits: state.visits
          // Koşula uyan elemanları filtreler
          .where((CollectionVisit v) =>
              // v bilgisini günceller
              v.status == CollectionStatus.called ||
              // v bilgisini günceller
              v.status == CollectionStatus.inProgress)
          // Sonucu listeye çevirir
          .toList(growable: false),
    );
  }
  // waiting bilgisini tutar
  final int waiting;
  // called bilgisini tutar
  final int called;
  // in ilerleme bilgisini tutar
  final int inProgress;
  // sample collected bilgisini tutar
  final int sampleCollected;
  // delivered bilgisini tutar
  final int delivered;
  // cancelled bilgisini tutar
  final int cancelled;
  // aktiflik ziyaretler bilgisini tutar
  final List<CollectionVisit> activeVisits;
  // aktiflik bilgisini döndürür
  int get active => called + inProgress;
  // toplam bilgisini döndürür
  int get total =>
      // İlgili alanın değerini veya görünümünü ayarlar
      waiting + called + inProgress + sampleCollected + delivered + cancelled;
  // completion rate bilgisini döndürür
  double get completionRate {
    // base değerini tanımlar
    final int base = total - cancelled;
    // Koşul sağlanırsa ilgili işlemi yapar
    if (base <= 0) return 0;
    // Hesaplanan sonucu döndürür
    return delivered / base;
  }
  // sayı of değerini hesaplar veya döndürür
  int countOf(CollectionStatus status) => switch (status) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => waiting,
        // collection durum bilgisini günceller
        CollectionStatus.called => called,
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => inProgress,
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => sampleCollected,
        // collection durum bilgisini günceller
        CollectionStatus.delivered => delivered,
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => cancelled,
      };
}

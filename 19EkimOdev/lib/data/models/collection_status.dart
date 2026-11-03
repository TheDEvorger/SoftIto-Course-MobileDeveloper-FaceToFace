// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// CollectionStatus için izin verilen seçenekleri tanımlar
enum CollectionStatus {
  // Metodun veya constructorın parametresini tanımlar
  waiting,
  // Metodun veya constructorın parametresini tanımlar
  called,
  // Metodun veya constructorın parametresini tanımlar
  inProgress,
  // Metodun veya constructorın parametresini tanımlar
  sampleCollected,
  // Metodun veya constructorın parametresini tanımlar
  delivered,
  // Metodun veya constructorın parametresini tanımlar
  cancelled,
}
// CollectionStatusX ile ilgili tipe yeni özellikler ekler
extension CollectionStatusX on CollectionStatus {
  // flow listesini oluşturur
  static const List<CollectionStatus> flow = <CollectionStatus>[
    // waiting değerini listeye ekler
    CollectionStatus.waiting,
    // called değerini listeye ekler
    CollectionStatus.called,
    // in ilerleme değerini listeye ekler
    CollectionStatus.inProgress,
    // sample collected değerini listeye ekler
    CollectionStatus.sampleCollected,
    // delivered değerini listeye ekler
    CollectionStatus.delivered,
  ];
  // etiket bilgisini döndürür
  String get label => switch (this) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => 'Bekliyor',
        // collection durum bilgisini günceller
        CollectionStatus.called => 'Çağrıldı',
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => 'İşlemde',
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => 'Numune Alındı',
        // collection durum bilgisini günceller
        CollectionStatus.delivered => 'Teslim Edildi',
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => 'İptal',
      };
  // simge bilgisini döndürür
  IconData get icon => switch (this) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => Icons.hourglass_top_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.called => Icons.campaign_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => Icons.vaccines_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => Icons.science_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.delivered => Icons.task_alt_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => Icons.cancel_rounded,
      };
  // sonraki bilgisini döndürür
  CollectionStatus? get next => switch (this) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => CollectionStatus.called,
        // collection durum bilgisini günceller
        CollectionStatus.called => CollectionStatus.inProgress,
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => CollectionStatus.sampleCollected,
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => CollectionStatus.delivered,
        // collection durum bilgisini günceller
        CollectionStatus.delivered => null,
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => null,
      };
  // sonraki action etiket bilgisini döndürür
  String? get nextActionLabel => switch (this) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => 'Çağır',
        // collection durum bilgisini günceller
        CollectionStatus.called => 'İşleme Al',
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => 'Numune Alındı',
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => 'Teslim Et',
        // collection durum bilgisini günceller
        CollectionStatus.delivered => null,
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => null,
      };
  // sonraki action simge bilgisini döndürür
  IconData? get nextActionIcon => switch (this) {
        // collection durum bilgisini günceller
        CollectionStatus.waiting => Icons.campaign_outlined,
        // collection durum bilgisini günceller
        CollectionStatus.called => Icons.play_arrow_rounded,
        // collection durum bilgisini günceller
        CollectionStatus.inProgress => Icons.science_outlined,
        // collection durum bilgisini günceller
        CollectionStatus.sampleCollected => Icons.local_shipping_outlined,
        // collection durum bilgisini günceller
        CollectionStatus.delivered => null,
        // collection durum bilgisini günceller
        CollectionStatus.cancelled => null,
      };
  // is terminal durumunu kontrol edip bool döndürür
  bool get isTerminal =>
      // this bilgisini günceller
      this == CollectionStatus.delivered || this == CollectionStatus.cancelled;
  // can cancel durumunu kontrol edip bool döndürür
  bool get canCancel => !isTerminal;
  // Durumun hedef duruma geçip geçemeyeceğini kontrol eder
  bool canTransitionTo(CollectionStatus target) {
    // Koşul sağlanırsa ilgili işlemi yapar
    if (target == CollectionStatus.cancelled) return canCancel;
    // sonraki değerini hesaplar veya döndürür
    return next == target;
  }
  // flow indeks bilgisini döndürür
  int get flowIndex => flow.indexOf(this);
}

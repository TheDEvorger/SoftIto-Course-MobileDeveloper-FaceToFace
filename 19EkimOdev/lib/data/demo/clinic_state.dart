// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
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
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// ClinicState bilgilerini tutan model sınıfı
class ClinicState {
  // Constructor, yeni nesnenin bilgilerini alır
  const ClinicState({
    // hastalar bilgisini zorunlu tutar
    required this.patients,
    // ziyaretler bilgisini zorunlu tutar
    required this.visits,
    // numuneler bilgisini zorunlu tutar
    required this.specimens,
    // activities bilgisini zorunlu tutar
    required this.activities,
    // sonraki sıra numarası bilgisini zorunlu tutar
    required this.nextQueueNumber,
    // sonraki numune numara bilgisini zorunlu tutar
    required this.nextSpecimenNumber,
    // sonraki hasta kodu numarası bilgisini zorunlu tutar
    required this.nextPatientCodeNumber,
    // ID seed bilgisini zorunlu tutar
    required this.idSeed,
  });
  // hastalar bilgisini tutar
  final Map<String, DemoPatient> patients;
  // ziyaretler bilgisini tutar
  final List<CollectionVisit> visits;
  // numuneler bilgisini tutar
  final List<DemoSpecimen> specimens;
  // activities bilgisini tutar
  final List<ActivityEntry> activities;
  // sonraki sıra numarası bilgisini tutar
  final int nextQueueNumber;
  // sonraki numune numara bilgisini tutar
  final int nextSpecimenNumber;
  // sonraki hasta kodu numarası bilgisini tutar
  final int nextPatientCodeNumber;
  // ID seed bilgisini tutar
  final int idSeed;
  // Ziyaretin hastasını getirir
  DemoPatient? patientOf(CollectionVisit visit) => patients[visit.patientId];
  // IDye göre ziyareti bulur
  CollectionVisit? visitById(String id) {
    // Listedeki elemanları sırayla dolaşır
    for (final CollectionVisit v in visits) {
      // Koşul sağlanırsa ilgili işlemi yapar
      if (v.id == id) return v;
    }
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // numune for ziyaret değerini hesaplar veya döndürür
  DemoSpecimen? specimenForVisit(String visitId) {
    // Listedeki elemanları sırayla dolaşır
    for (final DemoSpecimen s in specimens) {
      // Koşul sağlanırsa ilgili işlemi yapar
      if (s.visitId == visitId) return s;
    }
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // sayı by durum değerini hesaplar veya döndürür
  int countByStatus(CollectionStatus status) =>
      // İlgili nesne üzerinden metodu çağırır
      visits.where((CollectionVisit v) => v.status == status).length;
  // sonraki waiting bilgisini döndürür
  CollectionVisit? get nextWaiting {
    // Listedeki elemanları sırayla dolaşır
    for (final CollectionVisit v in visits) {
      // Koşul sağlanırsa ilgili işlemi yapar
      if (v.status == CollectionStatus.waiting) return v;
    }
    // Uygun sonuç yoksa null döndürür
    return null;
  }
  // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
  ClinicState copyWith({
    // Metodun veya constructorın parametresini tanımlar
    Map<String, DemoPatient>? patients,
    // Metodun veya constructorın parametresini tanımlar
    List<CollectionVisit>? visits,
    // Metodun veya constructorın parametresini tanımlar
    List<DemoSpecimen>? specimens,
    // Metodun veya constructorın parametresini tanımlar
    List<ActivityEntry>? activities,
    // Metodun veya constructorın parametresini tanımlar
    int? nextQueueNumber,
    // Metodun veya constructorın parametresini tanımlar
    int? nextSpecimenNumber,
    // Metodun veya constructorın parametresini tanımlar
    int? nextPatientCodeNumber,
    // Metodun veya constructorın parametresini tanımlar
    int? idSeed,
  }) {
    // clinic durum değerini hesaplar veya döndürür
    return ClinicState(
      // hastalar bilgisini belirler
      patients: patients ?? this.patients,
      // ziyaretler bilgisini belirler
      visits: visits ?? this.visits,
      // numuneler bilgisini belirler
      specimens: specimens ?? this.specimens,
      // activities bilgisini belirler
      activities: activities ?? this.activities,
      // Yeni değer yoksa mevcut değeri korur
      nextQueueNumber: nextQueueNumber ?? this.nextQueueNumber,
      // Yeni değer yoksa mevcut değeri korur
      nextSpecimenNumber: nextSpecimenNumber ?? this.nextSpecimenNumber,
      // sonraki hasta kodu numarası bilgisini belirler
      nextPatientCodeNumber:
          // Yeni değer yoksa mevcut değeri korur
          nextPatientCodeNumber ?? this.nextPatientCodeNumber,
      // ID seed bilgisini belirler
      idSeed: idSeed ?? this.idSeed,
    );
  }
}

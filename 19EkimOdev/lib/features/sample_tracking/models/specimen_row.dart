// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// demo numune dosyasını projeye ekler
import '../../../data/models/demo_specimen.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// SpecimenRow bilgilerini tutan model sınıfı
class SpecimenRow {
  // Constructor, yeni nesnenin bilgilerini alır
  const SpecimenRow({
    // numune bilgisini zorunlu tutar
    required this.specimen,
    // ziyaret bilgisini zorunlu tutar
    required this.visit,
    // hasta bilgisini zorunlu tutar
    required this.patient,
  });
  // numune bilgisini tutar
  final DemoSpecimen specimen;
  // ziyaret bilgisini tutar
  final CollectionVisit? visit;
  // hasta bilgisini tutar
  final DemoPatient? patient;
}

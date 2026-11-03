// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// collection durum dosyasını projeye ekler
import 'collection_status.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// ActivityEntry bilgilerini tutan model sınıfı
class ActivityEntry {
  // Constructor, yeni nesnenin bilgilerini alır
  const ActivityEntry({
    // ID bilgisini zorunlu tutar
    required this.id,
    // mesaj bilgisini zorunlu tutar
    required this.message,
    // zaman bilgisini zorunlu tutar
    required this.timestamp,
    // durum bilgisini zorunlu tutar
    required this.status,
    // ziyaret ID için varsayılan değeri belirler
    this.visitId,
  });
  // ID bilgisini tutar
  final String id;
  // mesaj bilgisini tutar
  final String message;
  // zaman bilgisini tutar
  final DateTime timestamp;
  // durum bilgisini tutar
  final CollectionStatus status;
  // ziyaret ID bilgisini tutar
  final String? visitId;
}

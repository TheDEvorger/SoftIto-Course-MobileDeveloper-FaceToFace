// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// collection durum dosyasını projeye ekler
import 'collection_status.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// CollectionVisit bilgilerini tutan model sınıfı
class CollectionVisit {
  // Constructor, yeni nesnenin bilgilerini alır
  const CollectionVisit({
    // ID bilgisini zorunlu tutar
    required this.id,
    // hasta ID bilgisini zorunlu tutar
    required this.patientId,
    // sıra numarası bilgisini zorunlu tutar
    required this.queueNumber,
    // oluşturulma zamanı bilgisini zorunlu tutar
    required this.createdAt,
    // durum bilgisini zorunlu tutar
    required this.status,
    // durum geçmişi bilgisini zorunlu tutar
    required this.statusHistory,
    // randevu zamanı için varsayılan değeri belirler
    this.appointmentAt,
    // not için varsayılan değeri belirler
    this.note,
  });
  // ID bilgisini tutar
  final String id;
  // hasta ID bilgisini tutar
  final String patientId;
  // sıra numarası bilgisini tutar
  final int queueNumber;
  // oluşturulma zamanı bilgisini tutar
  final DateTime createdAt;
  // durum bilgisini tutar
  final CollectionStatus status;
  // durum geçmişi bilgisini tutar
  final Map<CollectionStatus, DateTime> statusHistory;
  // randevu zamanı bilgisini tutar
  final DateTime? appointmentAt;
  // not bilgisini tutar
  final String? note;
  // Yeni duruma geçirilmiş ziyaret kopyası oluşturur
  CollectionVisit withStatus(CollectionStatus newStatus, DateTime at) {
    // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
    return copyWith(
      // durum bilgisini belirler
      status: newStatus,
      // durum geçmişi için tarih bilgisini atar
      statusHistory: Map<CollectionStatus, DateTime>.unmodifiable(
        // Verileri belirtilen tipte koleksiyona ekler
        <CollectionStatus, DateTime>{...statusHistory, newStatus: at},
      ),
    );
  }
  // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
  CollectionVisit copyWith({
    // Metodun veya constructorın parametresini tanımlar
    CollectionStatus? status,
    // Metodun veya constructorın parametresini tanımlar
    Map<CollectionStatus, DateTime>? statusHistory,
    // Metodun veya constructorın parametresini tanımlar
    String? note,
  }) {
    // collection ziyaret değerini hesaplar veya döndürür
    return CollectionVisit(
      // ID bilgisini belirler
      id: id,
      // hasta ID bilgisini belirler
      patientId: patientId,
      // sıra numarası bilgisini belirler
      queueNumber: queueNumber,
      // oluşturulma zamanı bilgisini belirler
      createdAt: createdAt,
      // durum bilgisini belirler
      status: status ?? this.status,
      // durum geçmişi bilgisini belirler
      statusHistory: statusHistory ?? this.statusHistory,
      // randevu zamanı bilgisini belirler
      appointmentAt: appointmentAt,
      // not bilgisini belirler
      note: note ?? this.note,
    );
  }
}

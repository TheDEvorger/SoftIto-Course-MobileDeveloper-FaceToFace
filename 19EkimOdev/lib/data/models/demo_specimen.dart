// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// SpecimenStatus için izin verilen seçenekleri tanımlar
enum SpecimenStatus { awaitingDelivery, delivered, cancelled }
// SpecimenStatusX ile ilgili tipe yeni özellikler ekler
extension SpecimenStatusX on SpecimenStatus {
  // etiket bilgisini döndürür
  String get label => switch (this) {
        // numune durum bilgisini günceller
        SpecimenStatus.awaitingDelivery => 'Teslim Bekliyor',
        // numune durum bilgisini günceller
        SpecimenStatus.delivered => 'Teslim Edildi',
        // numune durum bilgisini günceller
        SpecimenStatus.cancelled => 'İptal',
      };
  // simge bilgisini döndürür
  IconData get icon => switch (this) {
        // numune durum bilgisini günceller
        SpecimenStatus.awaitingDelivery => Icons.pending_actions_rounded,
        // numune durum bilgisini günceller
        SpecimenStatus.delivered => Icons.task_alt_rounded,
        // numune durum bilgisini günceller
        SpecimenStatus.cancelled => Icons.block_rounded,
      };
}
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// DemoSpecimen bilgilerini tutan model sınıfı
class DemoSpecimen {
  // Constructor, yeni nesnenin bilgilerini alır
  const DemoSpecimen({
    // ID bilgisini zorunlu tutar
    required this.id,
    // kod bilgisini zorunlu tutar
    required this.code,
    // ziyaret ID bilgisini zorunlu tutar
    required this.visitId,
    // oluşturulma zamanı bilgisini zorunlu tutar
    required this.createdAt,
    // durum bilgisini zorunlu tutar
    required this.status,
    // teslim zamanı için varsayılan değeri belirler
    this.deliveredAt,
  });
  // ID bilgisini tutar
  final String id;
  // kod bilgisini tutar
  final String code;
  // ziyaret ID bilgisini tutar
  final String visitId;
  // oluşturulma zamanı bilgisini tutar
  final DateTime createdAt;
  // durum bilgisini tutar
  final SpecimenStatus status;
  // teslim zamanı bilgisini tutar
  final DateTime? deliveredAt;
  // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
  DemoSpecimen copyWith({SpecimenStatus? status, DateTime? deliveredAt}) {
    // demo numune değerini hesaplar veya döndürür
    return DemoSpecimen(
      // ID bilgisini belirler
      id: id,
      // kod bilgisini belirler
      code: code,
      // ziyaret ID bilgisini belirler
      visitId: visitId,
      // oluşturulma zamanı bilgisini belirler
      createdAt: createdAt,
      // durum bilgisini belirler
      status: status ?? this.status,
      // teslim zamanı bilgisini belirler
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}

// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// rezervasyon için sınıf oluşturur
class Reservation {
  // rezervasyon nesnesi oluşturur
  const Reservation(
      // Veri alanlarını tanımlar
      {required this.id,
      // araç ID bilgisini zorunlu alır
      required this.vehicleId,
      // araç ad bilgisini zorunlu alır
      required this.vehicleName,
      // başlangıç bilgisini zorunlu alır
      required this.start,
      // bitiş bilgisini zorunlu alır
      required this.end,
      // toplam kuruş cinsinden tutar bilgisini zorunlu alır
      required this.totalMinor,
      // durum bilgisini zorunlu alır
      required this.status,
      // para birimi bilgisini zorunlu alır
      required this.currency});
  // para birimi bilgisini tutar
  final String id, vehicleId, vehicleName, status, currency;
  // bitiş bilgisini tutar
  final DateTime start, end;
  // toplam kuruş cinsinden tutar bilgisini tutar
  final int totalMinor;
  // cancelled bilgisini döndürür
  bool get cancelled => status == 'cancelled';
  // toplam etiket bilgisini döndürür
  String get totalLabel => moneyLabel(totalMinor, currency);
  // from json verisinden yeni nesne oluşturur
  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
      // ID bilgisini belirler
      id: json['id'] as String,
      // araç ID bilgisini belirler
      vehicleId: json['vehicle_id'] as String,
      // araç ad bilgisini belirler
      vehicleName: json['vehicle_name'] as String,
      // Başlangıç bilgisini belirler
      start: DateTime.parse(json['starts_on'] as String),
      // Bitiş bilgisini belirler
      end: DateTime.parse(json['ends_on'] as String),
      // Toplam tutarı kuruş cinsinden belirler
      totalMinor: json['total_minor'] as int,
      // Durum bilgisini belirler
      status: json['status'] as String,
      // para birimi bilgisini belirler
      currency: json['currency'] as String);
}

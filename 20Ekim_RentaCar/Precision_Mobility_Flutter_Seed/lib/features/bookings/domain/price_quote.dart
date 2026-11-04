// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// fiyat fiyat teklifi için sınıf oluşturur
class PriceQuote {
  // fiyat fiyat teklifi nesnesi oluşturur
  const PriceQuote(
      // Veri alanlarını tanımlar
      {required this.token,
      // rate kuruş cinsinden tutar bilgisini zorunlu alır
      required this.rateMinor,
      // toplam kuruş cinsinden tutar bilgisini zorunlu alır
      required this.totalMinor,
      // para birimi bilgisini zorunlu alır
      required this.currency,
      // sona erme at bilgisini zorunlu alır
      required this.expiresAt});
  // para birimi bilgisini tutar
  final String token, currency;
  // toplam kuruş cinsinden tutar bilgisini tutar
  final int rateMinor, totalMinor;
  // sona erme at bilgisini tutar
  final DateTime expiresAt;
  // expired bilgisini döndürür
  bool get expired => !expiresAt.isAfter(DateTime.now());
  // toplam etiket bilgisini döndürür
  String get totalLabel => moneyLabel(totalMinor, currency);
  // rate etiket bilgisini döndürür
  String get rateLabel => moneyLabel(rateMinor, currency);
  // from json verisinden yeni nesne oluşturur
  factory PriceQuote.fromJson(Map<String, dynamic> json) => PriceQuote(
      // erişim anahtarı bilgisini belirler
      token: json['token'] as String,
      // rate kuruş cinsinden tutar bilgisini belirler
      rateMinor: json['rate_minor'] as int,
      // Toplam tutarı kuruş cinsinden belirler
      totalMinor: json['total_minor'] as int,
      // para birimi bilgisini belirler
      currency: json['currency'] as String,
      // Son geçerlilik zamanını belirler
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
          // Koşul veya parametre ifadesini devam ettirir
          (json['expires_at'] as int) * 1000));
}

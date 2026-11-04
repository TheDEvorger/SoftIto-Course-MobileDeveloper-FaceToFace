// Matematiksel işlemleri ekler
import 'dart:math';
// Flutter temel veri ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// rezervasyon dosyasını ekler
import '../domain/reservation.dart';
// fiyat fiyat teklifi dosyasını ekler
import '../domain/price_quote.dart';
// rezervasyon controller için sınıf oluşturur
class ReservationController extends ChangeNotifier {
  // rezervasyon controller nesnesi oluşturur
  ReservationController(this.api);
  // API bilgisini tutar
  final ApiClient api;
  // Asenkron işlemi veya veri türünü tanımlar
  List<Reservation> records = [];
  // yükleme değerini belirler
  bool loading = false, _disposed = false;
  // hata bilgisini tutar
  String? error;
  // istek değerini belirler
  int _request = 0;
  // işlem anahtarı değerini tanımlar
  static String requestKey() {
    // random değerini belirler
    final random = Random.secure();
    // Hesaplanan sonucu geri döndürür
    return List.generate(
            // Önceki ifadeyi tamamlar
            24, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'))
        // Önceki ifade üzerinde ek işlem uygular
        .join();
  }
  // yükleme işlemini asenkron yürütür
  Future<void> load() async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (_disposed) return;
    // istek değerini belirler
    final request = ++_request;
    // yükleme değerini günceller
    loading = true;
    // hata değerini günceller
    error = null;
    // Değişiklikleri dinleyen widgetlara bildirir
    notifyListeners();
    // Hata oluşabilecek işlemleri dener
    try {
      // yanıt değerini belirler
      final response = await api.get('reservations');
      // sonuç değerini belirler
      final result = (response['reservations'] as List)
          // Listedeki elemanları dönüştürür
          .map((r) => Reservation.fromJson(r as Map<String, dynamic>))
          // Sonucu listeye dönüştürür
          .toList();
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed && request == _request) {
        // kayıtlar değerini günceller
        records = List.unmodifiable(result);
      }
    // İşlem hata verirse çalışır
    } catch (failure) {
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed && request == _request) {
        // kayıtlar değerini günceller
        records = [];
        // hata değerini günceller
        error = failure is ApiException
            // Koşul doğruysa bu değeri seçer
            ? failure.message
            // Koşul yanlışsa bu değeri seçer
            : 'Rezervasyonlar okunamadı.';
      }
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed && request == _request) {
        // yükleme değerini günceller
        loading = false;
        // Değişiklikleri dinleyen widgetlara bildirir
        notifyListeners();
      }
    }
  }
  // fiyat teklifi işlemini asenkron yürütür
  Future<PriceQuote> quote(String id, DateTime start, DateTime end) async {
    // yanıt değerini belirler
    final response = await api.request('POST', 'quotes', body: {
      // İlgili metin değerini belirler
      'vehicle_id': id,
      // İlgili metin değerini belirler
      'starts_on': dateKey(start),
      // İlgili metin değerini belirler
      'ends_on': dateKey(end)
    });
    // Hesaplanan sonucu geri döndürür
    return PriceQuote.fromJson(response['quote'] as Map<String, dynamic>);
  }
  // reserve işlemini asenkron yürütür
  Future<Reservation> reserve(String id, DateTime start, DateTime end,
      // Veri alanlarını tanımlar
      {required String requestKey, required String quoteToken}) async {
    // yanıt değerini belirler
    final response = await api
        // Önceki ifade üzerinde ek işlem uygular
        .request('POST', 'reservations', requestKey: requestKey, body: {
      // İlgili metin değerini belirler
      'vehicle_id': id,
      // İlgili metin değerini belirler
      'starts_on': dateKey(start),
      // İlgili metin değerini belirler
      'ends_on': dateKey(end),
      // İlgili metin değerini belirler
      'quote_token': quoteToken
    });
    // kayıt değerini belirler
    final record =
        // Önceki ifadeyi tamamlar
        Reservation.fromJson(response['reservation'] as Map<String, dynamic>);
    // Asenkron işlemin tamamlanmasını bekler
    await load();
    // kayıt bilgisini tutar
    return record;
  }
  // iptal işlemini asenkron yürütür
  Future<void> cancel(String id) async {
    // API isteğinin tamamlanmasını bekler
    await api.request('POST', 'reservations/$id/cancel');
    // Asenkron işlemin tamamlanmasını bekler
    await load();
  }
  // temizleme işlemini gerçekleştirir
  void clear() {
    // istek değerini günceller
    _request++;
    // kayıtlar değerini günceller
    records = [];
    // hata değerini günceller
    error = null;
    // yükleme değerini günceller
    loading = false;
    // Değişiklikleri dinleyen widgetlara bildirir
    notifyListeners();
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // disposed değerini günceller
    _disposed = true;
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
}

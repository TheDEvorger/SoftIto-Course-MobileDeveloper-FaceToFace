// Flutter temel veri ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// araç dosyasını ekler
import '../../discovery/domain/vehicle.dart';
// araç işlemler controller için sınıf oluşturur
class VehicleOperationsController extends ChangeNotifier {
  // araç işlemler controller nesnesi oluşturur
  VehicleOperationsController(this.api, this.vehicle)
      // Constructor alanlarını başlangıç değerleriyle ayarlar
      : published = vehicle.published;
  // API bilgisini tutar
  final ApiClient api;
  // araç bilgisini tutar
  final Vehicle vehicle;
  // Önceki ifadeyi tamamlar
  bool published, busy = false, _disposed = false;
  // hata bilgisini tutar
  String? error;
  // Asenkron işlemi veya veri türünü tanımlar
  List<Map<String, dynamic>> blocks = [], reservations = [];
  // yükleme işlemini asenkron yürütür
  Future<void> load() => _run(() async {
        // veri değerini belirler
        final data = await api.get('vehicles/${vehicle.id}/calendar');
        // Koşul doğruysa bu işlemi çalıştırır
        if (_disposed) return;
        // blocks değerini günceller
        blocks = (data['blocks'] as List).cast<Map<String, dynamic>>();
        // rezervasyonlar değerini günceller
        reservations =
            // Koşul veya parametre ifadesini devam ettirir
            (data['reservations'] as List).cast<Map<String, dynamic>>();
      });
  // publish işlemini asenkron yürütür
  Future<void> publish(bool value) => _run(() async {
        // API isteğinin tamamlanmasını bekler
        await api.request('PUT', 'vehicles/${vehicle.id}/publication',
            // Sayfanın ana içeriğini oluşturur
            body: {'published': value});
        // Koşul doğruysa bu işlemi çalıştırır
        if (!_disposed) published = value;
      });
  // block işlemini asenkron yürütür
  Future<void> block(DateTime start, DateTime end, String reason) async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (await _run(() async {
      // API isteğinin tamamlanmasını bekler
      await api.request('POST', 'vehicles/${vehicle.id}/calendar', body: {
        // İlgili metin değerini belirler
        'starts_on': dateKey(start),
        // İlgili metin değerini belirler
        'ends_on': dateKey(end),
        // İlgili metin değerini belirler
        'reason': reason
      });
    // İlgili işlemin kod bloğunu başlatır
    })) {
      // Asenkron işlemin tamamlanmasını bekler
      await load();
    }
  }
  // release işlemini asenkron yürütür
  Future<void> release(String id) async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (await _run(() async {
      // API isteğinin tamamlanmasını bekler
      await api.request('POST', 'vehicles/${vehicle.id}/calendar/$id/release');
    // İlgili işlemin kod bloğunu başlatır
    })) {
      // Asenkron işlemin tamamlanmasını bekler
      await load();
    }
  }
  // run işlemini asenkron yürütür
  Future<bool> _run(Future<void> Function() action) async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (_disposed || busy) return false;
    // meşguliyet değerini günceller
    busy = true;
    // hata değerini günceller
    error = null;
    // Değişiklikleri dinleyen widgetlara bildirir
    notifyListeners();
    // Hata oluşabilecek işlemleri dener
    try {
      // Asenkron işlemin tamamlanmasını bekler
      await action();
      // true bilgisini tutar
      return true;
    // İşlem hata verirse çalışır
    } catch (failure) {
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed) error = failure.toString();
      // false bilgisini tutar
      return false;
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed) {
        // meşguliyet değerini günceller
        busy = false;
        // Değişiklikleri dinleyen widgetlara bildirir
        notifyListeners();
      }
    }
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

// Flutter temel veri ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// araç dosyasını ekler
import '../domain/vehicle.dart';
// araç kataloğu controller için sınıf oluşturur
class CatalogController extends ChangeNotifier {
  // araç kataloğu controller nesnesi oluşturur
  CatalogController(this.api);
  // API bilgisini tutar
  final ApiClient api;
  // Asenkron işlemi veya veri türünü tanımlar
  List<Vehicle> vehicles = [];
  // yükleme değerini belirler
  bool loading = false;
  // hata bilgisini tutar
  String? error;
  // istek değerini belirler
  int _request = 0;
  // disposed değerini belirler
  bool _disposed = false, _workspace = false;
  // Önceki ifadeyi tamamlar
  DateTime? _start, _end;
  // yenileme işlemini asenkron yürütür
  Future<void> refresh() =>
      // İlgili fonksiyonu çalıştırır
      load(start: _start, end: _end, workspace: _workspace);
  // yükleme işlemini asenkron yürütür
  Future<void> load(
      // Veri alanlarını tanımlar
      {DateTime? start, DateTime? end, bool workspace = false}) async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (_disposed) return;
    // başlangıç değerini günceller
    _start = start;
    // bitiş değerini günceller
    _end = end;
    // çalışma alanı değerini günceller
    _workspace = workspace;
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
      // sonuç değerini belirler
      final result = await api.get(workspace ? 'workspace' : 'vehicles',
          // Arama veya istek parametresini belirler
          query: start == null || end == null
              // Koşul doğruysa bu değeri seçer
              ? null
              // Koşul yanlışsa bu değeri seçer
              : {'start': dateKey(start), 'end': dateKey(end)});
      // değerler değerini belirler
      final values = (result['vehicles'] as List)
          // Listedeki elemanları dönüştürür
          .map((v) => Vehicle.fromJson(v as Map<String, dynamic>))
          // Sonucu listeye dönüştürür
          .toList();
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed && request == _request) {
        // araçlar değerini günceller
        vehicles = List.unmodifiable(values);
      }
    // İşlem hata verirse çalışır
    } catch (failure) {
      // Koşul doğruysa bu işlemi çalıştırır
      if (!_disposed && request == _request) {
        // araçlar değerini günceller
        vehicles = [];
        // hata değerini günceller
        error = failure is ApiException
            // Koşul doğruysa bu değeri seçer
            ? failure.message
            // Koşul yanlışsa bu değeri seçer
            : 'Araç bilgileri okunamadı.';
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
  // kaydetme işlemini asenkron yürütür
  Future<Vehicle> save(Map<String, dynamic> body, {String? id}) async {
    // yanıt değerini belirler
    final response = await api.request(
        // ID değerini günceller
        id == null ? 'POST' : 'PUT', id == null ? 'vehicles' : 'vehicles/$id',
        // Sayfanın ana içeriğini oluşturur
        body: body);
    // Hesaplanan sonucu geri döndürür
    return Vehicle.fromJson(response['vehicle'] as Map<String, dynamic>);
  }
  // temizleme işlemini gerçekleştirir
  void clear() {
    // istek değerini günceller
    _request++;
    // araçlar değerini günceller
    vehicles = [];
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

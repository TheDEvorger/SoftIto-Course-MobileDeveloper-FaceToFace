// Flutter temel veri ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// device kiralama veri deposu dosyasını ekler
import '../data/device_rental_repository.dart';
// yerel rezervasyon dosyasını ekler
import '../domain/local_reservation.dart';
// kiralama controller için sınıf oluşturur
class RentalController extends ChangeNotifier {
  // kiralama controller nesnesi oluşturur
  RentalController(this.repository);
  // veri deposu bilgisini tutar
  final DeviceRentalRepository repository;
  // yükleme değerini belirler
  bool loading = true, busy = false, ready = false, _disposed = false;
  // hata bilgisini tutar
  String? error;
  // yükleme işlemini asenkron yürütür
  Future<void> load() async {
    // yükleme değerini günceller
    loading = true;
    // hata değerini günceller
    error = null;
    // İlgili metodu çalıştırır
    _notify();
    // Hata oluşabilecek işlemleri dener
    try {
      // Verilerin yüklenmesini bekler
      await repository.load();
      // hazırlık değerini günceller
      ready = true;
    // İşlem hata verirse çalışır
    } catch (failure) {
      // hazırlık değerini günceller
      ready = false;
      // hata değerini günceller
      error = failure.toString();
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // yükleme değerini günceller
      loading = false;
      // İlgili metodu çalıştırır
      _notify();
    }
  }
  // function işlemini asenkron yürütür
  Future<T> _act<T>(Future<T> Function() action) async {
    // kiralama failure constructorını tanımlar
    if (busy) throw const RentalFailure('Önceki işlem kaydediliyor.');
    // meşguliyet değerini günceller
    busy = true;
    // İlgili metodu çalıştırır
    _notify();
    // Hata oluşabilecek işlemleri dener
    try {
      // Hesaplanan sonucu geri döndürür
      return await action();
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // meşguliyet değerini günceller
      busy = false;
      // İlgili metodu çalıştırır
      _notify();
    }
  }
  // favori işlemini asenkron yürütür
  Future<void> favorite(String id) => _act(() => repository.favorite(id));
  // iptal işlemini asenkron yürütür
  Future<void> cancel(String id) => _act(() => repository.cancel(id));
  // reserve işlemini asenkron yürütür
  Future<LocalReservation> reserve(RentalQuote quote, String requestKey) =>
      // İlgili metodu çalıştırır
      _act(() => repository.reserve(quote, requestKey));
  // preferences işlemini asenkron yürütür
  Future<void> preferences({String? theme, String? city}) =>
      // İlgili metodu çalıştırır
      _act(() => repository.preferences(theme: theme, city: city));
  // notify işlemini gerçekleştirir
  void _notify() {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!_disposed) notifyListeners();
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

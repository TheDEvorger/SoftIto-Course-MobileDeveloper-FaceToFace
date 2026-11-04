// Cihazda veri saklama kütüphanesini ekler
import 'package:shared_preferences/shared_preferences.dart';
// kiralama depolama için temel sözleşmeyi tanımlar
abstract interface class RentalStorage {
  // read işlemini asenkron yürütür
  Future<String?> read();
  // write işlemini asenkron yürütür
  Future<void> write(String value);
}
/// Local planning data only: no customer identity, payment or supplier contract.
// device kiralama depolama sınıfını tanımlar ve belirtilen sözleşmeyi uygular
class DeviceRentalStorage implements RentalStorage {
  // preferences değerini belirler
  final _preferences = SharedPreferencesAsync();
  // anahtar değerini tanımlar
  static const key = 'precision.renter.v1';
  // Üst sınıftaki metodu yeniden uygular
  @override
  // read işlemini asenkron yürütür
  Future<String?> read() => _preferences.getString(key);
  // Üst sınıftaki metodu yeniden uygular
  @override
  // write işlemini asenkron yürütür
  Future<void> write(String value) => _preferences.setString(key, value);
}

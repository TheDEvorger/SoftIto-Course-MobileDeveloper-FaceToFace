// Verileri cihazda anahtar ve değer olarak saklamayı sağlar
import 'package:shared_preferences/shared_preferences.dart';
// Yerel veriyi okuma ve yazma sözleşmesini belirtir
abstract class RealmStore {
  // Cihazdaki kayıtlı krallık verisini metin olarak okur
  Future<String?> read();
  // Krallık verisini cihazda saklar
  Future<void> write(String encoded);
}
// Cihazdaki kayıtları SharedPreferences ile okuyup yazar
class LocalRealmStore implements RealmStore {
  // key bilgisini saklar
  static const _key = 'haegaruuetn_realm_v1';
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Cihazdaki kayıtlı krallık verisini metin olarak okur
  Future<String?> read() async {
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Hesaplanan değeri çağıran yere geri döndürür
    return prefs.getString(_key);
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Krallık verisini cihazda saklar
  Future<void> write(String encoded) async {
    // Cihazın yerel tercih kayıtlarını açar
    final prefs = await SharedPreferences.getInstance();
    // Metin değerini cihazdaki kayda yazar
    await prefs.setString(_key, encoded);
  }
}

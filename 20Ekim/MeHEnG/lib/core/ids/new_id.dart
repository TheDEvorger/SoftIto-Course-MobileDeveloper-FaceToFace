// Matematik işlemlerini ekler
import 'dart:math';
// Random bilgisini oluşturur
final _random = Random.secure();
// Yeni benzersiz ID üretir
String newId() {
  // Millis bilgisini geçerli zamana göre ayarlar
  final millis = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  // Salt bilgisini oluşturur
  final salt = _random.nextInt(1 << 30).toRadixString(36);
  // İşlemin sonucunu döndürür
  return '$millis-$salt';
}

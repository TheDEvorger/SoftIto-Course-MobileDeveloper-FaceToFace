// Flutter widget kütüphanesini ekler
import 'package:flutter/widgets.dart';
// app dosyasını kullanıma ekler
import 'app.dart';
// Uygulamanın giriş fonksiyonunu oluşturur
void main() {
  // Flutter bağlantısını başlatmaya hazırlar
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter uygulamasını çalıştırır
  runApp(const GardenYksApp());
}

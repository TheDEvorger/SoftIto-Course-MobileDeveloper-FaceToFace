// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// precision app dosyasını ekler
import 'app/precision_app.dart';
// Uygulamayı başlatan ana fonksiyon
void main() {
  // Flutter bağlantısını başlatır
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulamayı başlatır
  runApp(const PrecisionApp());
}

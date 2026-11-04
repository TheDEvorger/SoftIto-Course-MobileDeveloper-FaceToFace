// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// mobility app dosyasını ekler
import 'app/mobility_app.dart';
/// Optional historical operator workspace. The normal app is serverless.
// Uygulamayı başlatan ana fonksiyon
void main() {
  // Flutter bağlantısını başlatır
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulamayı başlatır
  runApp(const MobilityApp());
}

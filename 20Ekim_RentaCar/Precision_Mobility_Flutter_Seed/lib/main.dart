// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Flutter temel veri ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// Flutter sistem hizmetlerini ekler
import 'package:flutter/services.dart';
// kiralama app dosyasını ekler
import 'app/rental_app.dart';
/// Uygulamanın ana başlangıç noktası (Entrypoint).
// Uygulamayı başlatan ana fonksiyon
void main() {
  // Flutter widget bağlayıcılarının başlatıldığından emin olunur.
  // Flutter bağlantısını başlatır
  WidgetsFlutterBinding.ensureInitialized();
  // Yazı tipi lisansını sisteme ekler
  LicenseRegistry.addLicense(() async* {
    // Asenkron akışa yeni bir değer gönderir
    yield LicenseEntryWithLineBreaks(['Roboto'],
        // Verilerin yüklenmesini bekler
        await rootBundle.loadString('assets/fonts/Roboto_LICENSE.txt'));
  });
  // Kök uygulama bileşeni ayağa kaldırılır.
  // Uygulamayı başlatır
  runApp(const RentalApp());
}

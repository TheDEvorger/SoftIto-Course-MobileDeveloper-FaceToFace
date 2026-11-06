// FCM bildirimlerini kullanmak için Firebase Messaging paketini ekler
import 'package:firebase_messaging/firebase_messaging.dart';
// Arka plan bildirim işleyicisinin uygulama dışında da bulunmasını sağlar
@pragma('vm:entry-point')  // Arka plan mesajlarını işlemek için gerekli olan giriş noktası
// Arka planda gelen RemoteMessage bilgisini asenkron alır
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gelen bildirimin başlığını konsola yazdırmayı amaçlar ancak satırda yazım hatası var
  print('Arka planda mesaj alındı: ${message.notification?.title}');
}
// Firebase bildirim izni ve cihaz tokenıyla ilgilenen servis sınıfı
class BildirimServisi {
  // Firebase Messaging nesnesini alır ve _fcm alanında tutar
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // Bildirim iznini ve cihaz tokenını alma işlemlerini başlatır
  Future<void> baslat() async {
    // Kullanıcıdan bildirim izni ister ancak burada tanımsız bir değişken kullanılmış
    NotificationSettings settings = await _fcm.requestPermission(
      // Uyarı bildirimleri için izin ister
      alert: true,
      // Uygulama simgesindeki bildirim sayısı için izin ister
      badge: true,
      // Bildirim sesleri için izin ister
      sound: true,
    );
    // Bildirim izni verilmişse bloğa girer
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // İznin verildiğini konsola yazar
      print('Kullanıcı bildirim iznini verdi.');
    }
    // Firebase üzerinden bu cihazın FCM tokenını almaya çalışır
    final token = await _fcm.getToken();
    // Alınan tokenı konsola yazar
    print('Cihazın FCM Tokenı: $token');
  }
}

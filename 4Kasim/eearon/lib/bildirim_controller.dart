// Cihaz üzerinde yerel bildirim gösterebilmek için paketi ekler
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// FCM üzerinden gelen RemoteMessage tipini kullanmak için ekler
import 'package:firebase_messaging/firebase_messaging.dart';
// Yerel bildirimleri başlatan ve ekranda gösteren sınıf
class YerelBildirimYoneticisi {
  // Yerel bildirim eklentisini tüm sınıf için tek alanda tutar
  static final FlutterLocalNotificationsPlugin _yerelBildirim =
      // Yerel bildirim eklentisinin nesnesini oluşturur
      FlutterLocalNotificationsPlugin();
  // Android ve iOS için yerel bildirim kurulumunu yapar
  static Future<void> kurulum() async {
    // Android bildirim simgesi olarak uygulama simgesini seçer
    const androidAyarlar = AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS bildirimleri için başlangıç ayarlarını oluşturur
    const iosAyarlar = DarwinInitializationSettings();
    // Platform ayarlarını tek nesnede toplar
    const ayarlar = InitializationSettings(
      // Android ayarlarını ekler
      android: androidAyarlar,
      // iOS ayarlarını ekler
      iOS: iosAyarlar,
    );
    // Yerel bildirim eklentisini belirlenen ayarlarla başlatır
    await _yerelBildirim.initialize(settings: ayarlar);
  }
  // Gelen Firebase mesajından yerel bildirim gösterir
  static Future<void> bildirimGoster(RemoteMessage message) async {
    // Android bildirim kanalının özelliklerini oluşturur
    const androidDetay = AndroidNotificationDetails(
      // Bildirim kanalına sabit bir ID verir
      'softito_kanal_id',
      // Kanalın kullanıcıya görünen adını belirler
      'Softito Bildirimleri',
      // Bildirimin önem seviyesini en yüksek yapar
      importance: Importance.max,
      // Bildirimin önceliğini yüksek yapar
      priority: Priority.high,
      // Bildirim geldiğinde ses çalınmasını açar
      playSound: true,
    );
    // Android bildirim ayarlarını NotificationDetails içine koyar
    const detaylar = NotificationDetails(android: androidDetay);
    // Yerel bildirimin gösterilmesini bekler
    await _yerelBildirim.show(
      // Mesajın hashCode değerini bildirim IDsi olarak verir
      id: message.hashCode,
      // Bildirim başlığı yoksa Yeni Bildirim metnini kullanır
      title: message.notification?.title ?? 'Yeni Bildirim',
      // Mesaj gövdesi yoksa boş metin kullanır
      body: message.notification?.body ?? '',
      // Hazırlanan Android bildirim ayarlarını gönderir
      notificationDetails: detaylar,
    );
  }
}

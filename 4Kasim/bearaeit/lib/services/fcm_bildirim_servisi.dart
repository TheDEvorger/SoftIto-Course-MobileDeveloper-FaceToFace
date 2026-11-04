// Firebase Cloud Messaging kütüphanesini ekler
import 'package:firebase_messaging/firebase_messaging.dart';
// Telefon üzerinde bildirim göstermek için eklentiyi ekler
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Fonksiyonun arka plandan çağrılabilmesi için işaret koyar
@pragma(
  // Dartın bu fonksiyonu giriş noktası olarak korumasını ister
  'vm:entry-point',
) // Arka plan mesajlarını işlemek için gerekli olan giriş noktası
// Arka plan mesajını alır ancak içi boş olduğu için işlem yapmaz
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}
// FCM ve yerel bildirim işlemlerini bir arada tutan sınıf
class FcmBildirimServisi {
  // FirebaseMessaging nesnesini alır
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // Yerel bildirim eklentisini tutacak alanı tanımlar
  final FlutterLocalNotificationsPlugin _localPlugin =
      // Yerel bildirim eklentisinin nesnesini oluşturur
      FlutterLocalNotificationsPlugin();
  // Bildirim servisini asenkron başlatır
  Future<void> baslat({
    // Gelen mesajı üst tarafa iletmek için callback alır
    required Function(RemoteMessage message) onMesajGeldi,
  }) async {
    // Bildirim, rozet ve ses izinlerini kullanıcıdan ister
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    // iOS için bildirim başlangıç ayarlarını oluşturur
    const iosSettings = DarwinInitializationSettings();
    // İki platformun başlangıç ayarlarını birleştirir
    const initSettings = InitializationSettings(
      // Android ayarlarını atamayı dener fakat AndroidSettings tanımlı değil
      android: AndroidSettings,
      // iOS ayarlarını ekler
      iOS: iosSettings,
    );
    // Yerel bildirim eklentisini başlatır
    await _localPlugin.initialize(initSettings);
    // Uygulama açıkken gelen FCM mesajlarını dinler
    FirebaseMessaging.onMessage.listen((message) {
      // Yerel bildirim çağırır fakat bu isimle bir metot tanımlı değil
      yerelBildirimGoster(message);
      // Gelen mesajı dışarıdan verilen callbacke gönderir
      onMesajGeldi(message);
    });
    // Arka plan bildirimlerini işleyecek fonksiyonu kaydeder
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }
  // Verilen FCM konusuna abone olur
  Future<void> konuyaAboneOl(String konu) async {
    // Konu adıyla Firebase üzerinden abonelik başlatır
    await _fcm.subscribeToTopic(konu);
  }
  // Verilen FCM konusunun aboneliğinden çıkar
  Future<void> konudanAyril(String konu) async {
    // Firebase üzerinden konu aboneliğini iptal eder
    await _fcm.unsubscribeFromTopic(konu);
  }
  // Gelen mesaja göre telefon bildirimi hazırlayan özel metot
  Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    // Android bildirim kanalı ayarlarını oluşturur
    const androidDetails = AndroidNotificationDetails(
      // Kanal kimliği için tanımsız bir isim kullanılmış
      softit_fcm_channel_id,
      // Kanal adında tırnaksız metin var, bu satır hatalı
      Softito bildirimleri,
      // Bildirim kanalının açıklamasını belirler
      channelDescription: 'FCm bildirimleri için kanal',
      // Bildirim önemini en yüksek seviyeye çıkarır
      importance: Importance.max,
      // Bildirim önceliğini yüksek ayarlar
      priority: Priority.high,
    );
    // Android ve iOS bildirim ayrıntılarını birleştirir
    const details = NotificationDetails(
      // Android için tanımlanan bildirim ayarlarını kullanır
      android: androidDetails,
      // iOS bildirim ayrıntılarını oluşturur
      iOS: DarwinNotificationDetails(),
    );
    // Telefonun yerel bildirimini göstermeyi ister
    await _localPlugin.show(
      // Mesajın hash kodunu bildirim kimliği olarak kullanır
      message.hashCode,
      // Bildirim başlığını alır, yoksa varsayılan başlığı kullanır
      message.notification?.title ?? 'Yeni Bİldirim',
      // Bildirim gövdesi alınmak isteniyor fakat Notification adı hatalı
      message.Notification?.body ?? '',
      // Platform bildirim ayrıntılarını gönderir
      details,
    );
  }
}

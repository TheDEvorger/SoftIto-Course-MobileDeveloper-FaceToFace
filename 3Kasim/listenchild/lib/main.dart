// Flutter arayüz araçlarını projeye ekler
import 'package:flutter/material.dart';
// Firebase uygulamasını başlatmak için gereken paketi ekler
import 'package:firebase_core/firebase_core.dart';
// Firestore paketini ekler, bu dosyada doğrudan kullanılmıyor
import 'package:cloud_firestore/cloud_firestore.dart';
// Firebase hazırlanacağı için main asenkron çalışır
void main() async {
  // Flutter bağlantısını Firebase başlamadan hazırlar
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase uygulamasının açılmasını bekler
  await Firebase.initializeApp();
  // Ana uygulama widgetını çalıştırır
  runApp(const softitoFireStoreUygulamasi());
}
// Uygulamanın değişmeyen ana widget sınıfı
class softitoFireStoreUygulamasi extends StatelessWidget {
  // Üst widgettan gelen key bilgisini alır
  const softitoFireStoreUygulamasi({super.key});
  // StatelessWidget içindeki build metodunu yeniden yazar
  @override
  // Uygulama arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Material tasarım altyapısını kurar
    return MaterialApp(
      // Sağ üstteki debug etiketini gizler
      debugShowCheckedModeBanner: false,
      // Uygulamanın başlığını belirler
      title: "Cloud Firestore Uygulaması",
      // Renk ve tasarım ayarlarını oluşturur
      theme: ThemeData(
        // Turuncu rengi temel alan şema amaçlanır, fromseed yazımı hatalıdır
        colorScheme: ColorScheme.fromseed(seedColor: Colors.deepOrange),
        // Material 3 bileşenlerini kullanır
        useMaterial3: true,
      ),
      // İlk sayfa olarak Firestore yönetim ekranını açmak ister; import eksik
      home: const FirestoreYonetimEkrani(),
    );
  }
}

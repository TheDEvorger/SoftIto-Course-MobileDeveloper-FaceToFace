// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// hager app dosyasını projeye ekler
import 'app/hager_app.dart';
// Cihaz içi kayıt servisini projeye ekler
import 'core/data/local_realm_store.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import 'core/state/realm_controller.dart';
// Flutterı hazırlar, kayıtlı durumu yükleyip uygulamayı başlatır
Future<void> main() async {
  // Flutter altyapısını asenkron işlemler öncesinde hazırlar
  WidgetsFlutterBinding.ensureInitialized();
  // Krallık controllerını cihazdaki kayıt servisiyle oluşturur
  final controller = RealmController(LocalRealmStore());
  // Uygulama durumunun yüklenmesini bekler
  await controller.initialize();
  // Yüklenen krallık durumunu HagerApp ile ekranda başlatır
  runApp(HagerApp(controller: controller));
}

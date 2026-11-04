// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../core/state/realm_controller.dart';
// Krallık tema ayarlarını projeye ekler
import '../core/theme/realm_theme.dart';
// Alt menülü ana ekranı projeye ekler
import '../features/shell/realm_shell.dart';
// Uygulama temasını ve krallık ana sayfasını oluşturur
class HagerApp extends StatelessWidget {
  // HagerApp nesnesinin başlangıç bilgilerini alır
  const HagerApp({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // HagerApp için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => MaterialApp(
        // başlık alanına gösterilecek metni belirler
        title: 'HægæRûetn',
        // Debug şeridini gizler
        debugShowCheckedModeBanner: false,
        // tema alanına gelen değeri kullanır
        theme: buildRealmTheme(),
        // İlk açılacak ekranı belirler
        home: RealmShell(controller: controller),
      );
}

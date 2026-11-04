// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Garaj / Filo sekmesi için yer tutucu kabuk ekran.
/// Özellikler arası doğrudan bağımlılık oluşturmamak için dışarıdan enjekte edilen
/// çalışma alanı (workspace) bileşenini görüntüler (Dependency Injection).
// garage ekran görünümünü oluşturan widget sınıfı
class GarageScreen extends StatelessWidget {
  // garage ekran nesnesi oluşturur
  const GarageScreen({super.key, required this.workspace});
  /// Görüntülenecek çalışma alanı widget'ı
  // çalışma alanı bilgisini tutar
  final Widget workspace;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => workspace;
}

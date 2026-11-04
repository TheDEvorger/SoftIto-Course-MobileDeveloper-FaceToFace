// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa görünümünü oluşturan widget sınıfı
class StudioPage extends StatelessWidget {
  // studio sayfa nesnesi oluşturur
  const StudioPage({super.key, required this.children, this.width = 1280});
  // children bilgisini tutar
  final List<Widget> children;
  // genişlik bilgisini tutar
  final double width;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => LayoutBuilder(
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, constraints) => Align(
          // Hizalamayı belirler
          alignment: Alignment.topCenter,
          // İçerikte gösterilecek widgetı belirler
          child: ConstrainedBox(
              // constraints bilgisini belirler
              constraints: BoxConstraints(maxWidth: width),
              // İçerikte gösterilecek widgetı belirler
              child: SingleChildScrollView(
                  // keyboard dismiss behavior bilgisini belirler
                  keyboardDismissBehavior:
                      // Önceki ifadeyi tamamlar
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  // İç boşlukları ayarlar
                  padding: EdgeInsets.all(constraints.maxWidth < 600 ? 20 : 36),
                  // İçerikte gösterilecek widgetı belirler
                  child: Column(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      // İçerideki elemanları listeler
                      children: children)))));
}
// studio panel görünümünü oluşturan widget sınıfı
class StudioPanel extends StatelessWidget {
  // studio panel nesnesi oluşturur
  const StudioPanel(
      // Veri alanlarını tanımlar
      {super.key, required this.child, this.padding = 24, this.color});
  // child bilgisini tutar
  final Widget child;
  // iç boşluk bilgisini tutar
  final double padding;
  // renk bilgisini tutar
  final Color? color;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Card(
      // Rengi belirler
      color: color,
      // İçerikte gösterilecek widgetı belirler
      child: Padding(padding: EdgeInsets.all(padding), child: child));
}

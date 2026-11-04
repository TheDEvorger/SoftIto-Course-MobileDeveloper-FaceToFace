// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık tema ayarlarını projeye ekler
import '../theme/realm_theme.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import 'ornate_widgets.dart';
// İçeriği süslü kart içine yerleştirir
class RealmCard extends StatelessWidget {
  // RealmCard nesnesinin başlangıç bilgilerini alır
  const RealmCard(
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {super.key,
      // child parametresini zorunlu tutar
      required this.child,
      // padding için isteğe bağlı başlangıç değeri alır
      this.padding = const EdgeInsets.all(18),
      // color için isteğe bağlı başlangıç değeri alır
      this.color = Colors.white});
  // child bilgisini saklar
  final Widget child;
  // padding bilgisini saklar
  final EdgeInsets padding;
  // color bilgisini saklar
  final Color color;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // RealmCard için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => OrnateCard(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: padding,
        // Bu elemanın rengini belirler
        color: color,
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: child,
      );
}
// Bölüm başlığını ve isteğe bağlı simgesini gösterir
class SectionTitle extends StatelessWidget {
  // SectionTitle nesnesinin başlangıç bilgilerini alır
  const SectionTitle(this.label, {super.key, this.trailing, this.icon});
  // label bilgisini saklar
  final String label;
  // trailing bilgisini saklar
  final Widget? trailing;
  // Gösterilecek simgeyi tutar
  final IconData? icon;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // SectionTitle için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Yeni OrnateSectionTitle nesnesi oluşturur
      OrnateSectionTitle(label, trailing: trailing, icon: icon);
}
// Küçük bilgi etiketini oluşturur
class RealmPill extends StatelessWidget {
  // RealmPill nesnesinin başlangıç bilgilerini alır
  const RealmPill(
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {super.key,
      // label parametresini zorunlu tutar
      required this.label,
      // icon için isteğe bağlı başlangıç değeri alır
      this.icon,
      // color için isteğe bağlı başlangıç değeri alır
      this.color = const Color(0xFFE9F4EE)});
  // label bilgisini saklar
  final String label;
  // Gösterilecek simgeyi tutar
  final IconData? icon;
  // color bilgisini saklar
  final Color color;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // RealmPill için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => Container(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // Kutunun arka plan, kenar ve süslerini ayarlar
        decoration: BoxDecoration(
          // Bu elemanın rengini belirler
          color: color,
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(999),
          // Kutunun kenarlık çizgisini oluşturur
          border:
              // Kutunun dört kenarına çizgi ekler
              Border.all(color: const Color(0xFFDDCFB0).withValues(alpha: .85)),
          // Kutunun gölge ayarlarını belirler
          boxShadow: [
            // Kutunun düşen gölgesini tanımlar
            BoxShadow(
                // Rengin saydamlığını belirtilen oranda ayarlar
                color: const Color(0xFF503F22).withValues(alpha: .05),
                // Gölgenin ne kadar dağıtılacağını belirler
                blurRadius: 10,
                // Çizimin hangi yönde kaydırılacağını belirler
                offset: const Offset(0, 3)),
          ],
        ),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Row(
          // Ana yönde kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçeride sıralanacak widgetları listeler
          children: [
            // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
            if (icon != null) ...[
              // Ekrana bir simge yerleştirir
              Icon(icon, size: 14, color: RealmPalette.ink),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(width: 6),
            ],
            // İçeriğin esneyip mevcut alana sığmasını sağlar
            Flexible(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text(
                // Etikette gösterilecek metni aktarır
                label,
                // Yazının ya da butonun görünümünü belirler
                style: const TextStyle(
                    // Yazının kalınlığını belirler
                    fontWeight: FontWeight.w800,
                    // Yazının boyutunu belirler
                    fontSize: 11.3,
                    // Bu elemanın rengini belirler
                    color: RealmPalette.ink),
              ),
            ),
          ],
        ),
      );
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Standart arama giriş alanı (Search Field) bileşeni.
/// Arama ikonu ve temizle/filtreleme olaylarını yönetir.
// precision arama alan görünümünü oluşturan widget sınıfı
class PrecisionSearchField extends StatelessWidget {
  // precision arama alan nesnesi oluşturur
  const PrecisionSearchField({
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // etiket bilgisini zorunlu alır
    required this.label,
    // olay changed bilgisini zorunlu alır
    required this.onChanged,
    // controller parametresini alır
    this.controller,
  });
  /// Giriş alanı etiket metni
  // etiket bilgisini tutar
  final String label;
  /// Metin değiştikçe tetiklenen geri çağırma
  // olay changed bilgisini tutar
  final ValueChanged<String> onChanged;
  /// İsteğe bağlı metin denetleyicisi
  // controller bilgisini tutar
  final TextEditingController? controller;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => TextField(
        // İlgili controllerı bağlar
        controller: controller,
        // Değer değişince çalışacak fonksiyonu belirler
        onChanged: onChanged,
        // Klavye işlem tuşunu belirler
        textInputAction: TextInputAction.search,
        // Kutunun görünümünü ayarlar
        decoration: InputDecoration(
          // Metin kutusunun sol simgesini belirler
          prefixIcon: const Icon(Icons.search),
          // Giriş alanının etiketini belirler
          labelText: label,
        ),
      );
}

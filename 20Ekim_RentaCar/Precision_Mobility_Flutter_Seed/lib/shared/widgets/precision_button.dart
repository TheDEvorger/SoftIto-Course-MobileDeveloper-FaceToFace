// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Precision buton stil çeşitleri (birincil dolu veya ikincil kenarlıklı)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum PrecisionButtonStyle { primary, secondary }
/// Uygulama standardı düğme bileşeni.
/// Material 3 FilledButton ve OutlinedButton yapılarını tek bir arayüzde birleştirir.
// precision button görünümünü oluşturan widget sınıfı
class PrecisionButton extends StatelessWidget {
  // precision button nesnesi oluşturur
  const PrecisionButton({
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // etiket bilgisini zorunlu alır
    required this.label,
    // olay pressed bilgisini zorunlu alır
    required this.onPressed,
    // this değerini günceller
    this.style = PrecisionButtonStyle.primary,
  });
  /// Düğme üzerinde görüntülenecek metin
  // etiket bilgisini tutar
  final String label;
  /// Tıklama olayı geri çağırma fonksiyonu (null ise devre dışı kalır)
  // olay pressed bilgisini tutar
  final VoidCallback? onPressed;
  /// Düğme görsel stili
  // style bilgisini tutar
  final PrecisionButtonStyle style;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => switch (style) {
        // precision button style değerini günceller
        PrecisionButtonStyle.primary => FilledButton(
            // Butona basılınca çalışacak fonksiyonu belirler
            onPressed: onPressed,
            // İçerikte gösterilecek widgetı belirler
            child: Text(label, textAlign: TextAlign.center),
          ),
        // precision button style değerini günceller
        PrecisionButtonStyle.secondary => OutlinedButton(
            // Butona basılınca çalışacak fonksiyonu belirler
            onPressed: onPressed,
            // İçerikte gösterilecek widgetı belirler
            child: Text(label, textAlign: TextAlign.center),
          ),
      };
}

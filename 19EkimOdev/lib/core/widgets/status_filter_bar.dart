// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// FilterOption sınıfını tanımlar
class FilterOption<T> {
  // Constructor, yeni nesnenin bilgilerini alır
  const FilterOption({
    // değer bilgisini zorunlu tutar
    required this.value,
    // etiket bilgisini zorunlu tutar
    required this.label,
    // sayı bilgisini zorunlu tutar
    required this.count,
    // simge için varsayılan değeri belirler
    this.icon,
  });
  // değer bilgisini tutar
  final T? value;
  // etiket bilgisini tutar
  final String label;
  // sayı bilgisini tutar
  final int count;
  // simge bilgisini tutar
  final IconData? icon;
}
// StatusFilterBar sınıfını tanımlar
class StatusFilterBar<T> extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const StatusFilterBar({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // options bilgisini zorunlu tutar
    required this.options,
    // seçili bilgisini zorunlu tutar
    required this.selected,
    // seçim işlemi bilgisini zorunlu tutar
    required this.onSelected,
  });
  // options bilgisini tutar
  final List<FilterOption<T>> options;
  // seçili bilgisini tutar
  final T? selected;
  // seçim işlemi bilgisini tutar
  final ValueChanged<T?> onSelected;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // single alt eleman scroll view değerini hesaplar veya döndürür
    return SingleChildScrollView(
      // Kaydırma yönünü belirler
      scrollDirection: Axis.horizontal,
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // İçeride gösterilecek widgetı belirler
      child: Row(
        // Alt widgetları listeler
        children: <Widget>[
          // Listedeki elemanları sırayla dolaşır
          for (final FilterOption<T> option in options)
            // İçeriğin çevresine boşluk bırakır
            Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.only(right: 8),
              // İçeride gösterilecek widgetı belirler
              child: ChoiceChip(
                // avatar bilgisini belirler
                avatar: option.icon == null
                    // Koşul doğruysa bu değeri kullanır
                    ? null
                    // Simge gösterir
                    : Icon(option.icon, size: 18),
                // Gösterilecek etiketi belirler
                label: Text('${option.label}  ${option.count}'),
                // Seçili olup olmadığını belirler
                selected: option.value == selected,
                // show checkmark bilgisini belirler
                showCheckmark: false,
                // Seçilince çalışacak fonksiyonu belirler
                onSelected: (_) => onSelected(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

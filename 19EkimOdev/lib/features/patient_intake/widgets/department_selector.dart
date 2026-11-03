// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// demo seed dosyasını projeye ekler
import '../../../data/demo/demo_seed.dart';
// DepartmentSelector sınıfını tanımlar
class DepartmentSelector extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const DepartmentSelector({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // seçili bilgisini zorunlu tutar
    required this.selected,
    // seçim işlemi bilgisini zorunlu tutar
    required this.onSelected,
    // doğrulama fonksiyonu bilgisini zorunlu tutar
    required this.validator,
  });
  // seçili bilgisini tutar
  final ValueNotifier<String?> selected;
  // seçim işlemi bilgisini tutar
  final ValueChanged<String> onSelected;
  // Function nesnesini oluşturur veya kullanır
  final String? Function() validator;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // Hesaplanan sonucu döndürür
    return FormField<String>(
      // Girilen değerin geçerliliğini kontrol eder
      validator: (_) => validator(),
      // Güncel verilere göre arayüzü oluşturur
      builder: (FormFieldState<String> field) {
        // Hesaplanan sonucu döndürür
        return ValueListenableBuilder<String?>(
          // Değişimi takip edilecek değeri dinler
          valueListenable: selected,
          // Güncel verilere göre arayüzü oluşturur
          builder: (BuildContext context, String? value, _) {
            // column değerini hesaplar veya döndürür
            return Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Elemanları yan yana dizer, sığmayınca alt satıra geçirir
                Wrap(
                  // Elemanların arasındaki boşluğu belirler
                  spacing: 8,
                  // Satırlar arasındaki boşluğu belirler
                  runSpacing: 8,
                  // Alt widgetları listeler
                  children: <Widget>[
                    // Listedeki elemanları sırayla dolaşır
                    for (final String dep in demoDepartments)
                      // Seçilebilir filtre butonu oluşturur
                      ChoiceChip(
                        // Gösterilecek etiketi belirler
                        label: Text(dep),
                        // Seçili olup olmadığını belirler
                        selected: value == dep,
                        // Seçilince çalışacak fonksiyonu belirler
                        onSelected: (_) {
                          // seçim işlemi fonksiyonunu çağırır
                          onSelected(dep);
                          // Form alanının değiştiğini bildirir
                          field.didChange(dep);
                          // Koşul sağlanırsa ilgili işlemi yapar
                          if (field.hasError) field.validate();
                        },
                      ),
                  ],
                ),
                // Koşul sağlanırsa ilgili işlemi yapar
                if (field.hasError)
                  // İçeriğin çevresine boşluk bırakır
                  Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    // İçeride gösterilecek widgetı belirler
                    child: Text(
                      // İlgili alanın değerini veya görünümünü ayarlar
                      field.errorText!,
                      // style bilgisini belirler
                      style: theme.textTheme.bodySmall
                          // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

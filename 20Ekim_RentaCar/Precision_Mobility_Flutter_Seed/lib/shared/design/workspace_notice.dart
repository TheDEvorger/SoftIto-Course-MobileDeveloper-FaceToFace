// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// çalışma alanı notice görünümünü oluşturan widget sınıfı
class WorkspaceNotice extends StatelessWidget {
  // çalışma alanı notice nesnesi oluşturur
  const WorkspaceNotice(
      // Veri alanlarını tanımlar
      {super.key,
      // örnekler bilgisini zorunlu alır
      required this.examples,
      // yükleme bilgisini zorunlu alır
      required this.loading,
      // olay action bilgisini zorunlu alır
      required this.onAction,
      // Tema renklerinden uygun olanı kullanır
      this.error});
  // yükleme bilgisini tutar
  final bool examples, loading;
  // hata bilgisini tutar
  final String? error;
  // olay action bilgisini tutar
  final VoidCallback onAction;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Değer null ise koşulu çalıştırır
    if (!examples && !loading && error == null) return const SizedBox.shrink();
    // renkler değerini belirler
    final colors = Theme.of(context).colorScheme;
    // Görünüm için kutu oluşturur
    return Container(
      // Genişliği belirler
      width: double.infinity,
      // Rengi belirler
      color: colors.secondaryContainer,
      // İç boşlukları ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      // İçerikte gösterilecek widgetı belirler
      child: Row(children: [
        // Simgeyi gösterir
        Icon(error != null ? Icons.cloud_off_outlined : Icons.layers_outlined,
            // Boyutu belirler
            size: 18, color: colors.onSecondaryContainer),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(width: 10),
        // Kalan alanı doldurur
        Expanded(
            // İçerikte gösterilecek widgetı belirler
            child: Text(
                // Önceki ifadeyi tamamlar
                loading
                    // Koşul doğruysa bu değeri seçer
                    ? 'Çalışma alanı açılıyor…'
                    // Koşul yanlışsa bu değeri seçer
                    : error ??
                        // İlgili metin değerini belirler
                        'Örnek çalışma alanı · Kurgusal kayıtlar, kalıcı değişiklikler',
                // Görünüm stilini belirler
                style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 11, color: colors.onSecondaryContainer))),
        // Koşul doğruysa bu işlemi çalıştırır
        if (!loading)
          // Simge butonu oluşturur
          IconButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: onAction,
              // Butonun açıklama metnini belirler
              tooltip: error != null ? 'Yeniden dene' : 'Alanı değiştir',
              // Butonun veya öğenin simgesini belirler
              icon: Icon(error != null ? Icons.refresh : Icons.swap_horiz,
                  // Boyutu belirler
                  size: 20)),
      ]),
    );
  }
}

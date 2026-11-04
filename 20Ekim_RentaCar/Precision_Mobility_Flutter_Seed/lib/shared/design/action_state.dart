// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa dosyasını ekler
import 'studio_page.dart';
// action durum görünümünü oluşturan widget sınıfı
class ActionState extends StatelessWidget {
  // action durum nesnesi oluşturur
  const ActionState(
      // Veri alanlarını tanımlar
      {super.key,
      // başlık bilgisini zorunlu alır
      required this.title,
      // mesaj bilgisini zorunlu alır
      required this.message,
      // icon bilgisini zorunlu alır
      required this.icon,
      // action parametresini alır
      this.action,
      // etiket parametresini alır
      this.label});
  // mesaj bilgisini tutar
  final String title, message;
  // icon bilgisini tutar
  final IconData icon;
  // action bilgisini tutar
  final VoidCallback? action;
  // etiket bilgisini tutar
  final String? label;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => StudioPanel(
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Görünüm için kutu oluşturur
        Container(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.all(16),
            // Kutunun görünümünü ayarlar
            decoration: BoxDecoration(
                // Rengi belirler
                color: Theme.of(context).colorScheme.primaryContainer,
                // Köşeleri yuvarlar
                borderRadius: BorderRadius.circular(20)),
            // İçerikte gösterilecek widgetı belirler
            child: Icon(icon,
                // Boyutu belirler
                size: 30,
                // Rengi belirler
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 22),
        // Metni gösterir
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 10),
        // Metni gösterir
        Text(message,
            // Görünüm stilini belirler
            style: TextStyle(
                // Rengi belirler
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        // Değer null değilse koşulu çalıştırır
        if (action != null && label != null) ...[
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 22),
          // Dolgulu buton oluşturur
          FilledButton.icon(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: action,
              // Butonun veya öğenin simgesini belirler
              icon: const Icon(Icons.arrow_forward, size: 18),
              // Görünen etiketi belirler
              label: Text(label!)),
        ],
      ]));
}

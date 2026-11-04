// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// precision tokens dosyasını ekler
import '../../core/theme/precision_tokens.dart';
/// Veri bulunamadığında veya arama sonucu boş döndüğünde gösterilen boş durum (Empty State) bileşeni.
/// Ekran okuyucular için Semantics (canlı bölge ve kapsayıcı) desteği içerir.
// precision empty durum görünümünü oluşturan widget sınıfı
class PrecisionEmptyState extends StatelessWidget {
  // precision empty durum nesnesi oluşturur
  const PrecisionEmptyState({
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // başlık bilgisini zorunlu alır
    required this.title,
    // mesaj bilgisini zorunlu alır
    required this.message,
    // this değerini günceller
    this.icon = Icons.search_off_outlined,
  });
  /// Boş durum başlığı
  // başlık bilgisini tutar
  final String title;
  /// Kullanıcıya rehberlik eden açıklama mesajı
  // mesaj bilgisini tutar
  final String message;
  /// Gösterilecek ikon
  // icon bilgisini tutar
  final IconData icon;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Semantics(
        // container bilgisini belirler
        container: true,
        // live region bilgisini belirler
        liveRegion: true,
        // İçerikte gösterilecek widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(PrecisionSpace.xl),
          // İçerikte gösterilecek widgetı belirler
          child: Column(
            // Ana eksende kaplanan alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçerideki elemanları listeler
            children: [
              // exclude semantics nesnesi oluşturur
              ExcludeSemantics(child: Icon(icon, size: 40)),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: PrecisionSpace.md),
              // Metni gösterir
              Text(title,
                  // Metnin hizasını ayarlar
                  textAlign: TextAlign.center,
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleLarge),
              // Belirtilen boyutta boşluk veya kutu oluşturur
              const SizedBox(height: PrecisionSpace.sm),
              // Metni gösterir
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

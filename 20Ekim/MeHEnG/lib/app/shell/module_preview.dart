// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Modül önizleme ekranı
class ModulePreview extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const ModulePreview({required this.index, super.key});
  // Index bilgisini tutar
  final int index;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Items bilgisini oluşturur
    const items = [
      // Seçenek için gerekli değerleri tanımlar
      ('', '', Icons.home),
      // İlgili fonksiyonun parametrelerini belirler
      (
        // Gösterilecek metni belirler
        'MeHEnG Discover',
        // Gösterilecek metni belirler
        'Doğrulama akışı için Girişimler bölümünden bir proje aç. '
            // Gösterilecek metni belirler
            'Hipotez, deney ve kanıt zinciri artık kullanılabilir.',
        // Gösterilecek simgeyi belirler
        Icons.science,
      ),
      // İlgili fonksiyonun parametrelerini belirler
      (
        // Gösterilecek metni belirler
        'MeHEnG Network',
        // Gösterilecek metni belirler
        'Ekip bulma, mentorluk ve işbirliği alanı. '
            // Gösterilecek metni belirler
            'Kimlik, izinler ve moderasyon kurulduktan sonra açılacak.',
        // Gösterilecek simgeyi belirler
        Icons.groups,
      ),
      // İlgili fonksiyonun parametrelerini belirler
      (
        // Gösterilecek metni belirler
        'MeHEnG Growth',
        // Gösterilecek metni belirler
        'Lansman, metrikler ve büyüme deneyleri. '
            // Gösterilecek metni belirler
            'Kanıtlanan girişimler için adım adım eklenecek.',
        // Gösterilecek simgeyi belirler
        Icons.trending_up,
      ),
    ];
    // Item bilgisini oluşturur
    final item = items[index];
    // İçeriği ortalar
    return Center(
      // İçerideki widgetı belirler
      child: ConstrainedBox(
        // Boyut sınırlarını belirler
        constraints: const BoxConstraints(maxWidth: 590),
        // İçerideki widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(24),
          // İçerideki widgetı belirler
          child: Column(
            // Ana eksende kaplanan alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçeride gösterilecek elemanları listeler
            children: [
              // Simgeyi gösterir
              Icon(item.$3, size: 56),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 18),
              // Metni ekranda gösterir
              Text(
                // $1 bilgisini kayda ekler
                item.$1,
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.headlineMedium,
                // Metnin hizasını belirler
                textAlign: TextAlign.center,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 12),
              // Metni ekranda gösterir
              Text(item.$2, textAlign: TextAlign.center),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 20),
              // Constructor gerekli bilgileri alır
              const Chip(label: Text('Yol haritasında')),
            ],
          ),
        ),
      ),
    );
  }
}

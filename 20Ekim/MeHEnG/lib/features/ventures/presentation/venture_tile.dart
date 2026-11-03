// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Sayfa yönlendirme kütüphanesini ekler
import 'package:go_router/go_router.dart';
// Girişim modelini ekler
import '../domain/venture.dart';
// Tek girişim kartı
class VentureTile extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const VentureTile({required this.venture, super.key});
  // Venture bilgisini tutar
  final Venture venture;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => Semantics(
    // Button özelliğini belirler
    button: true,
    // Gösterilecek etiketi belirler
    label: '${venture.name} girişim çalışma alanını aç',
    // İçerideki widgetı belirler
    child: Card(
      // Dış boşlukları ayarlar
      margin: const EdgeInsets.only(bottom: 12),
      // İçerideki widgetı belirler
      child: InkWell(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(12),
        // Dokunulduğunda çalışacak işlemi belirler
        onTap: () => context.go('/venture/${venture.id}'),
        // İçerideki widgetı belirler
        child: Padding(
          // İç boşlukları ayarlar
          padding: const EdgeInsets.all(18),
          // İçerideki widgetı belirler
          child: Row(
            // İçeride gösterilecek elemanları listeler
            children: [
              // Circle avatar sınıfını tanımlar oluşturur
              CircleAvatar(
                // Arka plan rengini belirler
                backgroundColor: venture.isArchived
                    // Koşul doğruysa bu değeri kullanır
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    // Koşul yanlışsa bu değeri kullanır
                    : null,
                // İçerideki widgetı belirler
                child: Icon(
                  // Arşiv durumunu ilgili işleme aktarır
                  venture.isArchived
                      // Koşul doğruysa bu değeri kullanır
                      ? Icons.archive_outlined
                      // Koşul yanlışsa bu değeri kullanır
                      : Icons.lightbulb_outline,
                ),
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(width: 14),
              // Kalan alanı kullanır
              Expanded(
                // İçerideki widgetı belirler
                child: Column(
                  // Çapraz eksen hizasını belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçeride gösterilecek elemanları listeler
                  children: [
                    // Elemanları yan yana dizer
                    Row(
                      // İçeride gösterilecek elemanları listeler
                      children: [
                        // Kalan alanı kullanır
                        Expanded(
                          // İçerideki widgetı belirler
                          child: Text(
                            // Girişim adını ilgili işleme aktarır
                            venture.name,
                            // Görünüm stilini belirler
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        // Koşul doğruysa ilgili işlemi yapar
                        if (venture.isArchived)
                          // Constructor gerekli bilgileri alır
                          const Padding(
                            // İç boşlukları ayarlar
                            padding: EdgeInsets.only(left: 8),
                            // İçerideki widgetı belirler
                            child: Chip(
                              // Butonun yazısını gösterir
                              label: Text('Arşivlendi'),
                              // Visual density özelliğini belirler
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                    // Constructor gerekli bilgileri alır
                    const SizedBox(height: 4),
                    // Metni ekranda gösterir
                    Text(
                      // Problem bilgisi boşsa açıklamayı değiştirir
                      venture.problem.isEmpty
                          // Koşul doğruysa bu değeri kullanır
                          ? 'Problemi henüz tanımlanmadı.'
                          // Koşul yanlışsa bu değeri kullanır
                          : venture.problem,
                      // Giriş alanındaki satır sayısını belirler
                      maxLines: 2,
                      // Overflow özelliğini belirler
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(width: 8),
              // Constructor gerekli bilgileri alır
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

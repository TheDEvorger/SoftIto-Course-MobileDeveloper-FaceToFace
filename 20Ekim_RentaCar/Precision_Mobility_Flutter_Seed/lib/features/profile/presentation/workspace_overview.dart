// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// rezervasyon controller dosyasını ekler
import '../../bookings/application/reservation_controller.dart';
// araç kataloğu controller dosyasını ekler
import '../../discovery/application/catalog_controller.dart';
// çalışma alanı overview görünümünü oluşturan widget sınıfı
class WorkspaceOverview extends StatelessWidget {
  // çalışma alanı overview nesnesi oluşturur
  const WorkspaceOverview(
      // Veri alanlarını tanımlar
      {super.key, required this.inventory, required this.reservations});
  // araç envanteri bilgisini tutar
  final CatalogController inventory;
  // rezervasyonlar bilgisini tutar
  final ReservationController reservations;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
        // listenable bilgisini belirler
        listenable: Listenable.merge([inventory, reservations]),
        // İçeriği oluşturan fonksiyonu belirler
        builder: (context, _) => StudioPanel(
            // İçerikte gösterilecek widgetı belirler
            child:
                // Elemanları alt alta dizer
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Metni gösterir
          Text('Çalışma alanına genel bakış',
              // Görünüm stilini belirler
              style: Theme.of(context).textTheme.titleLarge),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 18),
          // Koşul doğruysa bu işlemi çalıştırır
          if (inventory.loading || reservations.loading)
            // Yatay ilerleme çubuğu oluşturur
            const LinearProgressIndicator()
          // Önceki koşul sağlanmazsa diğer koşulu kontrol eder
          else if (inventory.error != null || reservations.error != null)
            // Metni gösterir
            Text(inventory.error ?? reservations.error!)
          // Önceki ifadeyi tamamlar
          else
            // Sığmayan öğeleri alt satıra geçirir
            Wrap(spacing: 28, runSpacing: 20, children: [
              // Listedeki öğeleri veya indeksleri sırayla dolaşır
              for (final metric in [
                // Koşul veya parametre ifadesini devam ettirir
                ('${inventory.vehicles.length}', 'Kayıtlı araç'),
                // Koşul veya parametre ifadesini devam ettirir
                (
                  // İlgili metin değerini belirler
                  '${inventory.vehicles.where((v) => v.published && !v.inMaintenance).length}',
                  // İlgili metin değerini belirler
                  'Yayında'
                ),
                // Koşul veya parametre ifadesini devam ettirir
                (
                  // İlgili metin değerini belirler
                  '${reservations.records.where((r) => !r.cancelled).length}',
                  // İlgili metin değerini belirler
                  'Rezervasyon'
                ),
                // Koşul veya parametre ifadesini devam ettirir
                (
                  // İlgili metin değerini belirler
                  '${reservations.records.where((r) => r.cancelled).length}',
                  // İlgili metin değerini belirler
                  'İptal kaydı'
                ),
              ])
                // Elemanları alt alta dizer
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Metni gösterir
                  Text(metric.$1,
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.headlineMedium),
                  // Metni gösterir
                  Text(metric.$2, style: Theme.of(context).textTheme.bodySmall),
                ]),
            ]),
        ])),
      );
}

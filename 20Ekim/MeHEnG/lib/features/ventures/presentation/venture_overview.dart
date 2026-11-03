// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Boş durum kartını ekler
import '../../../core/widgets/empty_state_card.dart';
// Girişim providerlarını ekler
import 'venture_providers.dart';
// Venture tile dosyasını ekler
import 'venture_tile.dart';
// Create venture dialog dosyasını ekler
import 'create_venture_dialog.dart';
// Girişim özet ekranı
class VentureOverview extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const VentureOverview({super.key});
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Ventures bilgisini Riverpod üzerinden dinler
    final ventures = ref.watch(venturesProvider);
    // Show archived bilgisini Riverpod üzerinden dinler
    final showArchived = ref.watch(showArchivedVenturesProvider);
    // Width bilgisini oluşturur
    final width = MediaQuery.sizeOf(context).width;
    // Padding bilgisini oluşturur
    final padding = width < 600 ? 16.0 : 24.0;
    // Kaydırılabilir liste oluşturur
    return ListView(
      // İç boşlukları ayarlar
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
      // İçeride gösterilecek elemanları listeler
      children: [
        // İçeriği ortalar
        Center(
          // İçerideki widgetı belirler
          child: ConstrainedBox(
            // Boyut sınırlarını belirler
            constraints: const BoxConstraints(maxWidth: 850),
            // İçerideki widgetı belirler
            child: Column(
              // Çapraz eksen hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçeride gösterilecek elemanları listeler
              children: [
                // Metni ekranda gösterir
                Text(
                  // Gösterilecek metni belirler
                  'Fikirlerini geliştir, kanıtla, büyüt.',
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 12),
                // Constructor gerekli bilgileri alır
                const Text(
                  // Gösterilecek metni belirler
                  'Her girişim bir soruyla başlar. MeHEnG, cevabı '
                  // Gösterilecek metni belirler
                  'hipotezlerle ve gerçek deneylerle bulmana yardımcı olur.',
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 22),
                // Erişilebilirlik bilgilerini ekler
                Semantics(
                  // Button özelliğini belirler
                  button: true,
                  // Gösterilecek etiketi belirler
                  label: 'Yeni girişim oluşturma diyaloğunu aç',
                  // İçerideki widgetı belirler
                  child: FilledButton.icon(
                    // Butona basılınca çalışacak işlemi belirler
                    onPressed: () => showDialog<void>(
                      // Ekran bağlamını gönderir
                      context: context,
                      // Alt widgetı oluşturan fonksiyonu tanımlar
                      builder: (_) => const CreateVentureDialog(),
                    ),
                    // Butonun simgesini gösterir
                    icon: const Icon(Icons.add),
                    // Butonun yazısını gösterir
                    label: const Text('Yeni girişim oluştur'),
                  ),
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 32),
                // Sığmayan elemanları alt satıra geçirir
                Wrap(
                  // Elemanların hizasını belirler
                  alignment: WrapAlignment.spaceBetween,
                  // Çapraz eksen hizasını belirler
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // Elemanlar arasındaki yatay boşluğu belirler
                  spacing: 12,
                  // Satırlar arasındaki boşluğu belirler
                  runSpacing: 8,
                  // İçeride gösterilecek elemanları listeler
                  children: [
                    // Metni ekranda gösterir
                    Text(
                      // Gösterilecek metni belirler
                      'Girişimlerin',
                      // Görünüm stilini belirler
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // Filter chip sınıfını tanımlar oluşturur
                    FilterChip(
                      // Seçili olup olmadığını belirler
                      selected: showArchived,
                      // Butonun yazısını gösterir
                      label: const Text('Arşivlenenler'),
                      // İşlem gerçekleşince çalışacak callbacki bağlar
                      onSelected: (_) => ref
                          // Providerdan güncel değeri okur
                          .read(showArchivedVenturesProvider.notifier)
                          // İlgili metodu çalıştırır
                          .toggle(),
                    ),
                  ],
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 12),
                // Liste veya metin boşsa çalışır
                if (ventures.isEmpty)
                  // Boş liste bilgilendirme kartı oluşturur
                  EmptyStateCard(
                    // Gösterilecek simgeyi belirler
                    icon: Icons.lightbulb_outline,
                    // Başlık bilgisini belirler
                    title: showArchived
                        // Koşul doğruysa bu değeri kullanır
                        ? 'Arşivlenmiş girişim yok'
                        // Koşul yanlışsa bu değeri kullanır
                        : 'Henüz bir girişim yok',
                    // Description özelliğini belirler
                    description: showArchived
                        // Koşul doğruysa bu değeri kullanır
                        ? 'Daha önce arşivlediğin girişimler burada listelenir.'
                        // Koşul yanlışsa bu değeri kullanır
                        : 'İlk fikrini oluşturarak ve hipotezlerini tanımlayarak başla.',
                    // Action label özelliğini belirler
                    actionLabel: showArchived ? null : 'Yeni girişim oluştur',
                    // İşlem gerçekleşince çalışacak callbacki bağlar
                    onAction: showArchived
                        // Koşul doğruysa bu değeri kullanır
                        ? null
                        // Koşul yanlışsa bu değeri kullanır
                        : () => showDialog<void>(
                            // Ekran bağlamını gönderir
                            context: context,
                            // Alt widgetı oluşturan fonksiyonu tanımlar
                            builder: (_) => const CreateVentureDialog(),
                          ),
                  )
                // Önceki koşul gerçekleşmezse çalışır
                else
                  // Listedeki elemanları sırayla dolaşır
                  for (final venture in ventures) VentureTile(venture: venture),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 28),
                // Metni ekranda gösterir
                Text(
                  // Gösterilecek metni belirler
                  'MeHEnG yolculuğu',
                  // Görünüm stilini belirler
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 12),
                // Constructor gerekli bilgileri alır
                const Wrap(
                  // Elemanlar arasındaki yatay boşluğu belirler
                  spacing: 8,
                  // Satırlar arasındaki boşluğu belirler
                  runSpacing: 8,
                  // İçeride gösterilecek elemanları listeler
                  children: [
                    // Küçük bilgi etiketi oluşturur
                    Chip(label: Text('01 · Keşfet')),
                    // Küçük bilgi etiketi oluşturur
                    Chip(label: Text('02 · Doğrula')),
                    // Küçük bilgi etiketi oluşturur
                    Chip(label: Text('03 · İnşa et')),
                    // Küçük bilgi etiketi oluşturur
                    Chip(label: Text('04 · Büyüt')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

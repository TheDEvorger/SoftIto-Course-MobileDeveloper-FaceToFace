// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Sayfa yönlendirme kütüphanesini ekler
import 'package:go_router/go_router.dart';
// Discover dosyasını ekler
import '../../features/discover/discover.dart';
// Edit venture dialog dosyasını ekler
import '../../features/ventures/presentation/edit_venture_dialog.dart';
// Ventures dosyasını ekler
import '../../features/ventures/ventures.dart';
// Girişim çalışma alanı ekranı
class VentureWorkspacePage extends ConsumerWidget {
  // Constructor gerekli bilgileri alır
  const VentureWorkspacePage({required this.ventureId, super.key});
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // İşlem öncesinde kullanıcıdan onay ister
  void _confirmArchive(BuildContext context, WidgetRef ref) {
    // Kullanıcıya onay penceresi açar
    showDialog<void>(
      // Ekran bağlamını gönderir
      context: context,
      // Alt widgetı oluşturan fonksiyonu tanımlar
      builder: (ctx) => AlertDialog(
        // Başlık bilgisini belirler
        title: const Text('Girişimi arşivle'),
        // Pencere içeriğini belirler
        content: const Text(
          // Gösterilecek metni belirler
          'Bu girişim ana listeden gizlenecektir. Tüm hipotez, deney ve kanıt '
          // Gösterilecek metni belirler
          'kayıtlarınız güvenle korunur ve dilediğiniz zaman geri yüklenebilir.',
        ),
        // Buton ve işlemleri listeler
        actions: [
          // Yazılı buton oluşturur
          TextButton(
            // Basılınca pencereyi kapatır
            onPressed: () => Navigator.pop(ctx),
            // İçerideki widgetı belirler
            child: const Text('Vazgeç'),
          ),
          // Dolu buton oluşturur
          FilledButton(
            // Butona basılınca çalışacak işlemi belirler
            onPressed: () {
              // Açık sayfayı veya pencereyi kapatır
              Navigator.pop(ctx);
              // Riverpod üzerinden ilgili işlemi çalıştırır
              ref.read(ventureViewModelProvider).archive(ventureId);
              // Ekranda kısa bildirim mesajı gösterir
              ScaffoldMessenger.of(context).showSnackBar(
                // Kullanıcıya gösterilecek bildirim oluşturur
                SnackBar(
                  // Pencere içeriğini belirler
                  content: const Text('Girişim arşivlendi.'),
                  // Action özelliğini belirler
                  action: SnackBarAction(
                    // Gösterilecek etiketi belirler
                    label: 'Geri al',
                    // Butona basılınca çalışacak işlemi belirler
                    onPressed: () =>
                        // Riverpod üzerinden ilgili işlemi çalıştırır
                        ref.read(ventureViewModelProvider).restore(ventureId),
                  ),
                ),
              );
            },
            // İçerideki widgetı belirler
            child: const Text('Arşivle'),
          ),
        ],
      ),
    );
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context, WidgetRef ref) {
    // Seçilen girişimin bilgilerini getirir
    final venture = ref.watch(ventureProvider(ventureId));
    // Değerin boş olup olmadığını kontrol eder
    if (venture == null) {
      // Sayfanın temel iskeletini oluşturur
      return Scaffold(
        // Üst menüyü belirler
        appBar: AppBar(),
        // Sayfanın ana içeriğini oluşturur
        body: const Center(child: Text('Girişim bulunamadı.')),
      );
    }
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Sol taraftaki elemanı belirler
        leading: IconButton(
          // Butonun simgesini gösterir
          icon: const Icon(Icons.arrow_back),
          // Buton açıklamasını belirler
          tooltip: 'Ana sayfa',
          // Butona basılınca çalışacak işlemi belirler
          onPressed: () => context.go('/'),
        ),
        // Başlık bilgisini belirler
        title: const Text('MeHEnG · Discover'),
        // Buton ve işlemleri listeler
        actions: [
          // Simge butonu oluşturur
          IconButton(
            // Butonun simgesini gösterir
            icon: const Icon(Icons.edit_outlined),
            // Buton açıklamasını belirler
            tooltip: 'Girişimi düzenle',
            // Butona basılınca çalışacak işlemi belirler
            onPressed: () => showDialog<void>(
              // Ekran bağlamını gönderir
              context: context,
              // Alt widgetı oluşturan fonksiyonu tanımlar
              builder: (_) => EditVentureDialog(venture: venture),
            ),
          ),
          // Simge butonu oluşturur
          IconButton(
            // Butonun simgesini gösterir
            icon: Icon(
              // Arşiv durumunu ilgili işleme aktarır
              venture.isArchived
                  // Koşul doğruysa bu değeri kullanır
                  ? Icons.unarchive_outlined
                  // Koşul yanlışsa bu değeri kullanır
                  : Icons.archive_outlined,
            ),
            // Buton açıklamasını belirler
            tooltip: venture.isArchived ? 'Geri yükle' : 'Arşivle',
            // Butona basılınca çalışacak işlemi belirler
            onPressed: () {
              // Koşul doğruysa ilgili işlemi yapar
              if (venture.isArchived) {
                // Riverpod üzerinden ilgili işlemi çalıştırır
                ref.read(ventureViewModelProvider).restore(ventureId);
              // Önceki koşul gerçekleşmezse çalışır
              } else {
                // Confirm archive işlemini çağırır
                _confirmArchive(context, ref);
              }
            },
          ),
          // Constructor gerekli bilgileri alır
          const SizedBox(width: 8),
        ],
      ),
      // Sayfanın ana içeriğini oluşturur
      body: Center(
        // İçerideki widgetı belirler
        child: ConstrainedBox(
          // Boyut sınırlarını belirler
          constraints: const BoxConstraints(maxWidth: 980),
          // İçerideki widgetı belirler
          child: ListView(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.all(20),
            // İçeride gösterilecek elemanları listeler
            children: [
              // Koşul doğruysa ilgili işlemi yapar
              if (venture.isArchived) ...[
                // Kart görünümü oluşturur
                Card(
                  // Rengi belirler
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  // İçerideki widgetı belirler
                  child: Padding(
                    // İç boşlukları ayarlar
                    padding: const EdgeInsets.symmetric(
                      // Horizontal özelliğini belirler
                      horizontal: 16,
                      // Vertical özelliğini belirler
                      vertical: 12,
                    ),
                    // İçerideki widgetı belirler
                    child: Row(
                      // İçeride gösterilecek elemanları listeler
                      children: [
                        // Constructor gerekli bilgileri alır
                        const Icon(Icons.info_outline, size: 20),
                        // Constructor gerekli bilgileri alır
                        const SizedBox(width: 12),
                        // Constructor gerekli bilgileri alır
                        const Expanded(
                          // İçerideki widgetı belirler
                          child: Text(
                            // Gösterilecek metni belirler
                            'Bu girişim arşivlendi. Verileriniz korunmaktadır.',
                          ),
                        ),
                        // Yazılı buton oluşturur
                        TextButton(
                          // Butona basılınca çalışacak işlemi belirler
                          onPressed: () => ref
                              // Providerdan güncel değeri okur
                              .read(ventureViewModelProvider)
                              // Girişimi arşivden geri çıkarır
                              .restore(ventureId),
                          // İçerideki widgetı belirler
                          child: const Text('Geri Yükle'),
                        ),
                      ],
                    ),
                  ),
                ),
                // Constructor gerekli bilgileri alır
                const SizedBox(height: 16),
              ],
              // Metni ekranda gösterir
              Text(
                // Girişim adını ilgili işleme aktarır
                venture.name,
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 12),
              // Metni ekranda gösterir
              Text(
                // Gösterilecek metni belirler
                'Problem: ${venture.problem.isEmpty ? "Henüz tanımlanmadı" : venture.problem}',
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 8),
              // Metni ekranda gösterir
              Text(
                // Gösterilecek metni belirler
                'Hedef kitle: ${venture.audience.isEmpty ? "Henüz tanımlanmadı" : venture.audience}',
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 24),
              // Hipotezlerin gösterildiği bölüm oluşturur
              HypothesesSection(ventureId: ventureId),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 32),
              // Stratejik kararların gösterildiği bölüm oluşturur
              DecisionsSection(ventureId: ventureId),
            ],
          ),
        ),
      ),
    );
  }
}

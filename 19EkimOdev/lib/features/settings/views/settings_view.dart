// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// tema controller dosyasını projeye ekler
import '../../../core/theme/theme_controller.dart';
// info banner dosyasını projeye ekler
import '../../../core/widgets/info_banner.dart';
// sayfa parts dosyasını projeye ekler
import '../../../core/widgets/page_parts.dart';
// clinic durum dosyasını projeye ekler
import '../../../data/demo/clinic_state.dart';
// demo clinic veri deposu dosyasını projeye ekler
import '../../../data/demo/demo_clinic_store.dart';
// SettingsView ekranını oluşturan sınıf
class SettingsView extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const SettingsView({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // veri deposu bilgisini zorunlu tutar
    required this.store,
    // tema controllerı bilgisini zorunlu tutar
    required this.themeController,
  });
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // tema controllerı bilgisini tutar
  final ThemeController themeController;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // sayfa frame değerini hesaplar veya döndürür
    return PageFrame(
      // İçeride gösterilecek widgetı belirler
      child: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
        // Alt widgetları listeler
        children: <Widget>[
          // Constructor, yeni nesnenin bilgilerini alır
          const PageHeader(
            // Başlığını belirler
            title: 'Ayarlar ve Sistem',
            // Alt başlığını belirler
            subtitle: 'Görünüm, kurgusal demo yönetimi ve yasal bilgilendirme',
          ),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 12),
          // tema section fonksiyonunu çağırır
          _ThemeSection(themeController: themeController),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 16),
          // demo data section fonksiyonunu çağırır
          _DemoDataSection(store: store),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 16),
          // Constructor, yeni nesnenin bilgilerini alır
          const _MedicalDisclaimerSection(),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 16),
          // about section fonksiyonunu çağırır
          _AboutSection(theme: theme),
        ],
      ),
    );
  }
}
// _ThemeSection sınıfını tanımlar
class _ThemeSection extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _ThemeSection({required this.themeController});
  // tema controllerı bilgisini tutar
  final ThemeController themeController;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<ThemeMode>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: themeController.mode,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, ThemeMode currentMode, _) {
        // section card değerini hesaplar veya döndürür
        return SectionCard(
          // Başlığını belirler
          title: 'Görünüm ve Tema',
          // Gösterilecek simgeyi belirler
          icon: Icons.palette_outlined,
          // İçeride gösterilecek widgetı belirler
          child: Column(
            // Elemanların çapraz hizasını belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Alt widgetları listeler
            children: <Widget>[
              // Metin gösterir
              Text(
                // Bu metin değerini kullanır
                'Uygulama arayüzünün tema modunu belirleyin:',
                // style değerini aktif temadan alır
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 12),
              // SegmentedButton butonunu oluşturur
              SegmentedButton<ThemeMode>(
                // segments bilgisini belirler
                segments: const <ButtonSegment<ThemeMode>>[
                  // ButtonSegment butonunu oluşturur
                  ButtonSegment<ThemeMode>(
                    // Gösterilen değeri belirler
                    value: ThemeMode.system,
                    // Gösterilecek etiketi belirler
                    label: Text('Sistem'),
                    // Gösterilecek simgeyi belirler
                    icon: Icon(Icons.brightness_auto_outlined),
                  ),
                  // ButtonSegment butonunu oluşturur
                  ButtonSegment<ThemeMode>(
                    // Gösterilen değeri belirler
                    value: ThemeMode.light,
                    // Gösterilecek etiketi belirler
                    label: Text('Aydınlık'),
                    // Gösterilecek simgeyi belirler
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  // ButtonSegment butonunu oluşturur
                  ButtonSegment<ThemeMode>(
                    // Gösterilen değeri belirler
                    value: ThemeMode.dark,
                    // Gösterilecek etiketi belirler
                    label: Text('Karanlık'),
                    // Gösterilecek simgeyi belirler
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                ],
                // Seçili olup olmadığını belirler
                selected: <ThemeMode>{currentMode},
                // selection changed işlemi fonksiyonunu bağlar
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  // Seçilen tema modunu ayarlar
                  themeController.setMode(newSelection.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
// _DemoDataSection sınıfını tanımlar
class _DemoDataSection extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _DemoDataSection({required this.store});
  // veri deposu bilgisini tutar
  final DemoClinicStore store;
  // show reset dialog işlemini asenkron çalıştırır
  Future<void> _showResetDialog(BuildContext context) async {
    // confirmed bilgisini hesaplayıp saklar
    final bool? confirmed = await showDialog<bool>(
      // context bilgisini belirler
      context: context,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext ctx) => AlertDialog(
        // Gösterilecek simgeyi belirler
        icon: const Icon(Icons.restart_alt_rounded, size: 36),
        // Başlığını belirler
        title: const Text('Demoyu Sıfırla'),
        // içerik yazısını gösterir
        content: const Text(
          // Bu metin değerini kullanır
          'Tüm kurgusal hasta, sıra ve numune hareketleri ilk başlangıç durumuna '
          // Bu metin değerini kullanır
          'döndürülecektir. Devam etmek istiyor musunuz?',
        ),
        // İşlem fonksiyonlarını widgeta gönderir
        actions: <Widget>[
          // Metin butonu oluşturur
          TextButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(false),
            // İçeride gösterilecek widgetı belirler
            child: const Text('Vazgeç'),
          ),
          // Dolu buton oluşturur
          FilledButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(true),
            // İçeride gösterilecek widgetı belirler
            child: const Text('Evet, Sıfırla'),
          ),
        ],
      ),
    );
    // Widget hâlâ ekrandaysa işleme devam eder
    if (confirmed == true && context.mounted) {
      // İlgili nesne üzerinden metodu çağırır
      store.reset();
      // İlgili nesne üzerinden metodu çağırır
      ScaffoldMessenger.of(context)
        // Aynı nesne üzerinde işlemi sürdürür
        ..hideCurrentSnackBar()
        // Ekranda kısa bilgilendirme mesajı gösterir
        ..showSnackBar(
          // Constructor, yeni nesnenin bilgilerini alır
          const SnackBar(
            // içerik yazısını gösterir
            content: Text('Demo verileri ilk durumuna başarıyla döndürüldü.'),
            // İşlemin süresini belirler
            duration: Duration(seconds: 3),
          ),
        );
    }
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return ValueListenableBuilder<ClinicState>(
      // Değişimi takip edilecek değeri dinler
      valueListenable: store.state,
      // Güncel verilere göre arayüzü oluşturur
      builder: (BuildContext context, ClinicState state, _) {
        // section card değerini hesaplar veya döndürür
        return SectionCard(
          // Başlığını belirler
          title: 'Kurgusal Demo Verisi',
          // Gösterilecek simgeyi belirler
          icon: Icons.storage_outlined,
          // İçeride gösterilecek widgetı belirler
          child: Column(
            // Elemanların çapraz hizasını belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // Alt widgetları listeler
            children: <Widget>[
              // Metin gösterir
              Text(
                // Bu metin değerini kullanır
                'Aktif bellek veritabanında ${state.patients.length} kayıtlı kurgusal hasta, '
                // Bu metin değerini kullanır
                '${state.visits.length} işlem kaydı ve ${state.specimens.length} numune bulunuyor.',
                // style değerini aktif temadan alır
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(height: 16),
              // İlgili işlem butonunu oluşturur
              OutlinedButton.icon(
                // Widgetın kimlik bilgisini belirler
                key: const Key('reset_demo_button'),
                // Gösterilecek simgeyi belirler
                icon: const Icon(Icons.refresh_rounded),
                // Gösterilecek etiketi belirler
                label: const Text('Tüm Demo Verilerini Sıfırla'),
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: () => _showResetDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
// _MedicalDisclaimerSection sınıfını tanımlar
class _MedicalDisclaimerSection extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _MedicalDisclaimerSection();
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Hesaplanan sonucu döndürür
    return const InfoBanner(
      // Gösterilecek simgeyi belirler
      icon: Icons.verified_user_outlined,
      // Başlığını belirler
      title: 'Tıbbi Uyarı ve Eğitim Bildirimi',
      // mesaj bilgisini belirler
      message:
          // Bu metin değerini kullanır
          'VenaFlow, SoftIto Mobil Geliştirici Eğitimi kapsamında kurgusal olarak '
          // Bu metin değerini kullanır
          'hazırlanmış bir arayüz ve akış prototipidir. Tıbbi karar desteği, gerçek tahlil '
          // Bu metin değerini kullanır
          'sonucu veya tedavi tavsiyesi sunmaz. Gerçek klinik operasyonlar için '
          // Bu metin değerini kullanır
          'kullanılamaz. Tüm kimlik ve işlem verileri yapaydır.',
    );
  }
}
// _AboutSection sınıfını tanımlar
class _AboutSection extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _AboutSection({required this.theme});
  // tema bilgisini tutar
  final ThemeData theme;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // section card değerini hesaplar veya döndürür
    return SectionCard(
      // Başlığını belirler
      title: 'Uygulama Bilgisi',
      // Gösterilecek simgeyi belirler
      icon: Icons.info_outline_rounded,
      // İçeride gösterilecek widgetı belirler
      child: Column(
        // Elemanların çapraz hizasını belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // Alt widgetları listeler
        children: <Widget>[
          // Elemanları yan yana dizer
          Row(
            // Alt widgetları listeler
            children: <Widget>[
              // Simge gösterir
              Icon(
                // bloodtype rounded değerini listeye ekler
                Icons.bloodtype_rounded,
                // Rengini belirler
                color: theme.colorScheme.primary,
                // boyut bilgisini belirler
                size: 28,
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(width: 8),
              // Metin gösterir
              Text(
                // Bu metin değerini kullanır
                'VenaFlow',
                // style bilgisini belirler
                style: theme.textTheme.titleMedium?.copyWith(
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.bold,
                  // Rengini belirler
                  color: theme.colorScheme.primary,
                ),
              ),
              // Constructor, yeni nesnenin bilgilerini alır
              const SizedBox(width: 8),
              // Görünüm ve yerleşim için kutu oluşturur
              Container(
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                // Görünüm ayarlarını oluşturur
                decoration: BoxDecoration(
                  // Rengini belirler
                  color: theme.colorScheme.primaryContainer,
                  // Köşeleri yuvarlar
                  borderRadius: BorderRadius.circular(6),
                ),
                // İçeride gösterilecek widgetı belirler
                child: Text(
                  // Bu metin değerini kullanır
                  'v1.0.0 Demo',
                  // style bilgisini belirler
                  style: theme.textTheme.labelSmall?.copyWith(
                    // Rengini belirler
                    color: theme.colorScheme.onPrimaryContainer,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Constructor, yeni nesnenin bilgilerini alır
          const SizedBox(height: 8),
          // Metin gösterir
          Text(
            // Bu metin değerini kullanır
            'Kan Alma Birimi ve Numune Takip Sistemi Arayüz Demosu.\n'
            // Bu metin değerini kullanır
            'Material 3 mimarisi ve reaktif durum yönetimi ile hazırlanmıştır.',
            // style bilgisini belirler
            style: theme.textTheme.bodySmall?.copyWith(
              // Rengini belirler
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// araç kataloğu controller dosyasını ekler
import '../../discovery/application/catalog_controller.dart';
// rezervasyon controller dosyasını ekler
import '../../bookings/application/reservation_controller.dart';
// çalışma alanı erişim panel dosyasını ekler
import 'workspace_access_panel.dart';
// çalışma alanı overview dosyasını ekler
import 'workspace_overview.dart';
// çalışma alanı ekran ekranının değişen durumunu yönetir
class WorkspaceScreen extends StatefulWidget {
  // çalışma alanı ekran nesnesi oluşturur
  const WorkspaceScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // API bilgisini zorunlu alır
      required this.api,
      // olay örnekler bilgisini zorunlu alır
      required this.onExamples,
      // araç envanteri bilgisini zorunlu alır
      required this.inventory,
      // rezervasyonlar bilgisini zorunlu alır
      required this.reservations,
      // olay oturum changed bilgisini zorunlu alır
      required this.onSessionChanged,
      // tema mod bilgisini zorunlu alır
      required this.themeMode,
      // olay tema changed bilgisini zorunlu alır
      required this.onThemeChanged});
  // API bilgisini tutar
  final ApiClient api;
  // olay örnekler bilgisini tutar
  final VoidCallback onExamples;
  // araç envanteri bilgisini tutar
  final CatalogController inventory;
  // rezervasyonlar bilgisini tutar
  final ReservationController reservations;
  // olay oturum changed bilgisini tutar
  final VoidCallback onSessionChanged;
  // tema mod bilgisini tutar
  final ThemeMode themeMode;
  // olay tema changed bilgisini tutar
  final ValueChanged<ThemeMode> onThemeChanged;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}
// çalışma alanı ekran durum ekranının durumunu yöneten sınıf
class _WorkspaceScreenState extends State<WorkspaceScreen> {
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => StudioPage(width: 1180, children: [
        // sayfa heading nesnesi oluşturur
        const PageHeading(
            // eyebrow bilgisini belirler
            eyebrow: 'Kişisel alan / Ayarlar',
            // Başlığı belirler
            title: 'Sizin alanınız. Sizin tercihleriniz.',
            // açıklama bilgisini belirler
            description:
                // İlgili metin değerini belirler
                'Çalışma alanınızı açın ve Precision deneyimini kendinize göre düzenleyin.'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 32),
        // Oturum doğrulandıysa işlemi yapar
        if (widget.api.authenticated) ...[
          // çalışma alanı overview nesnesi oluşturur
          WorkspaceOverview(
              // araç envanteri bilgisini belirler
              inventory: widget.inventory, reservations: widget.reservations),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
        ],
        // Alan genişliğine göre içeriği düzenler
        LayoutBuilder(builder: (context, constraints) {
          // bağlantı değerini belirler
          final connection = WorkspaceAccessPanel(
              // API bilgisini belirler
              api: widget.api,
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: widget.onSessionChanged,
              // örnekler için callback belirler
              onExamples: widget.onExamples);
          // preferences değerini belirler
          final preferences =
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // İlgili metodu çalıştırır
            _appearance(context),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(height: 20),
            // İlgili metodu çalıştırır
            _help(context),
          ]);
          // Koşul doğruysa bu işlemi çalıştırır
          if (constraints.maxWidth < 850 ||
              // Ekran ölçülerini alır
              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
            // Elemanları alt alta dizer
            return Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // İçerideki elemanları listeler
                children: [
                  // Önceki ifadeyi tamamlar
                  connection,
                  // Belirtilen boyutta boşluk veya kutu oluşturur
                  const SizedBox(height: 20),
                  // Önceki ifadeyi tamamlar
                  preferences
                ]);
          }
          // Elemanları yan yana dizer
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Kalan alanı doldurur
            Expanded(child: connection),
            // Belirtilen boyutta boşluk veya kutu oluşturur
            const SizedBox(width: 24),
            // Kalan alanı doldurur
            Expanded(child: preferences)
          ]);
        }),
      ]);
  // appearance işlemini gerçekleştirir
  Widget _appearance(BuildContext context) => StudioPanel(
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Metni gösterir
        Text('Görünüm', style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 8),
        // Metni gösterir
        const Text('Gününüzün ritmine uyan bir arayüz.'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 20),
        // Sığmayan öğeleri alt satıra geçirir
        Wrap(spacing: 10, runSpacing: 10, children: [
          // Listedeki öğeleri veya indeksleri sırayla dolaşır
          for (final mode in [
            // Koşul veya parametre ifadesini devam ettirir
            (ThemeMode.system, Icons.brightness_auto_outlined, 'Sistem'),
            // Koşul veya parametre ifadesini devam ettirir
            (ThemeMode.light, Icons.light_mode_outlined, 'Açık'),
            // Koşul veya parametre ifadesini devam ettirir
            (ThemeMode.dark, Icons.dark_mode_outlined, 'Koyu')
          ])
            // Seçilebilir filtre etiketi oluşturur
            ChoiceChip(
                // Görünen etiketi belirler
                label: Text(mode.$3),
                // avatar bilgisini belirler
                avatar: Icon(mode.$2, size: 18),
                // Seçili olup olmadığını belirler
                selected: widget.themeMode == mode.$1,
                // Seçim değişince çalışacak fonksiyonu belirler
                onSelected: (_) => widget.onThemeChanged(mode.$1)),
        ]),
      ]));
  // help işlemini gerçekleştirir
  Widget _help(BuildContext context) => StudioPanel(
      // İç boşlukları ayarlar
      padding: 12,
      // İçerikte gösterilecek widgetı belirler
      child: Column(children: [
        // expansion tile nesnesi oluşturur
        const ExpansionTile(
            // Sol taraftaki elemanı belirler
            leading: Icon(Icons.route_outlined),
            // Başlığı belirler
            title: Text('İlk yolculuğunuzu planlayın'),
            // İçerideki elemanları listeler
            children: [
              // İçerik etrafına boşluk bırakır
              Padding(
                  // İç boşlukları ayarlar
                  padding: EdgeInsets.all(20),
                  // İçerikte gösterilecek widgetı belirler
                  child: Text(
                      // İlgili metin değerini belirler
                      'Araçlar → Araç ekle ile envanteri oluşturun. Keşfet '
                      // İlgili metin değerini belirler
                      'üzerinden araç ve tarih seçerek rezervasyon kaydı oluşturun. Sürüşlerim üzerinden kayıtları '
                      // İlgili metin değerini belirler
                      'görüntüleyebilir veya iptal edebilirsiniz. Araç düzenleme ekranından yayın durumunu ve kapalı tarihleri yönetebilirsiniz.')),
            ]),
        // expansion tile nesnesi oluşturur
        const ExpansionTile(
            // Sol taraftaki elemanı belirler
            leading: Icon(Icons.privacy_tip_outlined),
            // Başlığı belirler
            title: Text('Veriler ve hizmetler'),
            // İçerideki elemanları listeler
            children: [
              // İçerik etrafına boşluk bırakır
              Padding(
                  // İç boşlukları ayarlar
                  padding: EdgeInsets.all(20),
                  // İçerikte gösterilecek widgetı belirler
                  child: Text(
                      // İlgili metin değerini belirler
                      'Örnek ve özel çalışma alanları ayrı SQLite dosyalarında '
                      // İlgili metin değerini belirler
                      'kalıcı olarak saklanır. Örnek araç adları, fiyatlar ve rezervasyonlar kurgusaldır. İptal edilen kayıtlar geçmişte tutulur. Müşteri kimliği, kart bilgisi '
                      // İlgili metin değerini belirler
                      've GPS verisi toplanmaz. Kimlik doğrulama, ödeme ve teslim hizmetleri henüz bağlı değildir.')),
            ]),
        // İçerik etrafına boşluk bırakır
        Padding(
            // İç boşlukları ayarlar
            padding: const EdgeInsets.all(16),
            // İçerikte gösterilecek widgetı belirler
            child: Text('PRECISION / MOBILITY, REFINED.',
                // Görünüm stilini belirler
                style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 9,
                    // Harfler arasındaki boşluğu ayarlar
                    letterSpacing: 1.6,
                    // Rengi belirler
                    color: Theme.of(context).colorScheme.onSurfaceVariant))),
      ]));
}

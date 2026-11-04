// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// sayfa heading dosyasını ekler
import '../../../shared/design/page_heading.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// kiralama controller dosyasını ekler
import '../application/rental_controller.dart';
// kiralama actions dosyasını ekler
import 'rental_actions.dart';
// kiralama profile ekran görünümünü oluşturan widget sınıfı
class RentalProfileScreen extends StatelessWidget {
  // kiralama profile ekran nesnesi oluşturur
  const RentalProfileScreen(
      // Veri alanlarını tanımlar
      {super.key,
      // controller bilgisini zorunlu alır
      required this.controller,
      // olay planlar bilgisini zorunlu alır
      required this.onPlans,
      // olay favoriler bilgisini zorunlu alır
      required this.onFavorites});
  // controller bilgisini tutar
  final RentalController controller;
  // olay favoriler bilgisini tutar
  final VoidCallback onPlans, onFavorites;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListenableBuilder(
      // listenable bilgisini belirler
      listenable: controller,
      // İçeriği oluşturan fonksiyonu belirler
      builder: (context, _) {
        // veri değerini belirler
        final data = controller.repository.data;
        // etkinlik değerini belirler
        final enabled = controller.ready && !controller.busy;
        // Hesaplanan sonucu geri döndürür
        return StudioPage(width: 1080, children: [
          // sayfa heading nesnesi oluşturur
          const PageHeading(
              // eyebrow bilgisini belirler
              eyebrow: 'Size özel',
              // Başlığı belirler
              title: 'İyi yolculuklar.',
              // açıklama bilgisini belirler
              description:
                  // İlgili metin değerini belirler
                  'Favorilerinizi, yolculuk planlarınızı ve tercihlerinizi bir arada tutun.'),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 28),
          // studio panel nesnesi oluşturur
          StudioPanel(
              // İçerikte gösterilecek widgetı belirler
              child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçerideki elemanları listeler
                  children: [
                // Metni gösterir
                Text('Yolculuk alanınız',
                    // Görünüm stilini belirler
                    style: Theme.of(context).textTheme.titleLarge),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 16),
                // Liste satırı oluşturur
                ListTile(
                    // content iç boşluk bilgisini belirler
                    contentPadding: EdgeInsets.zero,
                    // Sol taraftaki elemanı belirler
                    leading: const Icon(Icons.calendar_month_outlined),
                    // Başlığı belirler
                    title: const Text('Rezervasyonlarım'),
                    // Alt başlığı belirler
                    subtitle: Text(
                        // İlgili metin değerini belirler
                        '${data.plans.where((r) => !r.cancelled).length} plan · ${data.plans.where((r) => r.cancelled).length} iptal kaydı'),
                    // Sağ taraftaki elemanı belirler
                    trailing: const Icon(Icons.chevron_right),
                    // Dokununca çalışacak fonksiyonu belirler
                    onTap: onPlans),
                // Ayırıcı çizgi oluşturur
                const Divider(),
                // Liste satırı oluşturur
                ListTile(
                    // content iç boşluk bilgisini belirler
                    contentPadding: EdgeInsets.zero,
                    // Sol taraftaki elemanı belirler
                    leading: const Icon(Icons.favorite_border),
                    // Başlığı belirler
                    title: const Text('Favorilerim'),
                    // Alt başlığı belirler
                    subtitle: Text('${data.favorites.length} kaydedilen araç'),
                    // Sağ taraftaki elemanı belirler
                    trailing: const Icon(Icons.chevron_right),
                    // Dokununca çalışacak fonksiyonu belirler
                    onTap: onFavorites),
              ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 22),
          // studio panel nesnesi oluşturur
          StudioPanel(
              // İçerikte gösterilecek widgetı belirler
              child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // İçerideki elemanları listeler
                  children: [
                // Metni gösterir
                Text('Tercihleriniz',
                    // Görünüm stilini belirler
                    style: Theme.of(context).textTheme.titleLarge),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 12),
                // Metni gösterir
                const Text('Görünüm'),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 12),
                // Sığmayan öğeleri alt satıra geçirir
                Wrap(spacing: 10, runSpacing: 10, children: [
                  // Listedeki öğeleri veya indeksleri sırayla dolaşır
                  for (final theme in [
                    // Koşul veya parametre ifadesini devam ettirir
                    ('system', 'Sistem', Icons.brightness_auto_outlined),
                    // Koşul veya parametre ifadesini devam ettirir
                    ('light', 'Açık', Icons.light_mode_outlined),
                    // Koşul veya parametre ifadesini devam ettirir
                    ('dark', 'Koyu', Icons.dark_mode_outlined)
                  ])
                    // Seçilebilir filtre etiketi oluşturur
                    ChoiceChip(
                        // Görünen etiketi belirler
                        label: Text(theme.$2),
                        // avatar bilgisini belirler
                        avatar: Icon(theme.$3, size: 17),
                        // Seçili olup olmadığını belirler
                        selected: data.theme == theme.$1,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: !enabled
                            // Koşul doğruysa bu değeri seçer
                            ? null
                            // Koşul yanlışsa bu değeri seçer
                            : (_) => rentalAction(context,
                                // Bu eleman için oluşturulacak değeri belirler
                                () => controller.preferences(theme: theme.$1))),
                ]),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 24),
                // İfadeye karşılaştırma koşulu ekler
                DropdownButtonFormField<String>(
                    // Widget kimliğini belirler
                    key: ValueKey(data.city),
                    // Başlangıç değerini belirler
                    initialValue: data.city,
                    // durum genişletme bilgisini belirler
                    isExpanded: true,
                    // Kutunun görünümünü ayarlar
                    decoration:
                        // Giriş alanının görünümünü belirler
                        const InputDecoration(labelText: 'Tercih edilen şehir'),
                    // Seçenekleri listeler
                    items: [
                      // Listedeki öğeleri veya indeksleri sırayla dolaşır
                      for (final city in [
                        // İlgili metin değerini belirler
                        'Tüm şehirler',
                        // İlgili metin değerini belirler
                        'İstanbul',
                        // İlgili metin değerini belirler
                        'Ankara',
                        // İlgili metin değerini belirler
                        'İzmir'
                      ])
                        // Seçim listesine seçenek ekler
                        DropdownMenuItem(value: city, child: Text(city))
                    ],
                    // Değer değişince çalışacak fonksiyonu belirler
                    onChanged: !enabled
                        // Koşul doğruysa bu değeri seçer
                        ? null
                        // Koşul yanlışsa bu değeri seçer
                        : (city) => rentalAction(
                            // Önceki ifadeyi tamamlar
                            context, () => controller.preferences(city: city))),
                // Belirtilen boyutta boşluk veya kutu oluşturur
                const SizedBox(height: 14),
                // Metni gösterir
                const Text('Tercihleriniz bu cihazda hatırlanır.',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 12)),
              ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 22),
          // studio panel nesnesi oluşturur
          const StudioPanel(
              // İç boşlukları ayarlar
              padding: 12,
              // İçerikte gösterilecek widgetı belirler
              child: Column(children: [
                // expansion tile nesnesi oluşturur
                ExpansionTile(
                    // Sol taraftaki elemanı belirler
                    leading: Icon(Icons.help_outline),
                    // Başlığı belirler
                    title: Text('Rezervasyon nasıl çalışır?'),
                    // İçerideki elemanları listeler
                    children: [
                      // İçerik etrafına boşluk bırakır
                      Padding(
                          // İç boşlukları ayarlar
                          padding: EdgeInsets.all(20),
                          // İçerikte gösterilecek widgetı belirler
                          child: Text(
                              // İlgili metin değerini belirler
                              'Keşfet bölümünden bir araç seçin. 1–7 günlük tarih aralığını ve '
                              // İlgili metin değerini belirler
                              'fiyat özetini kontrol edip rezervasyonu kaydedin. Planlarım bölümünden ayrıntılarını görebilir, '
                              // İlgili metin değerini belirler
                              'özetini kopyalayabilir veya iptal edebilirsiniz. Dönüş günü kiralama ücretine dahil değildir.'))
                    ]),
                // expansion tile nesnesi oluşturur
                ExpansionTile(
                    // Sol taraftaki elemanı belirler
                    leading: Icon(Icons.phone_iphone_outlined),
                    // Başlığı belirler
                    title: Text('Verilerim nerede?'),
                    // İçerideki elemanları listeler
                    children: [
                      // İçerik etrafına boşluk bırakır
                      Padding(
                          // İç boşlukları ayarlar
                          padding: EdgeInsets.all(20),
                          // İçerikte gösterilecek widgetı belirler
                          child: Text(
                              // İlgili metin değerini belirler
                              'Favorileriniz, rezervasyonlarınız ve tercihleriniz bu cihazda saklanır. '
                              // İlgili metin değerini belirler
                              'Ayrı sunucu, anahtar veya oturum açma gerekmez. Tarayıcı verilerini silmek yerel kayıtları kaldırır; '
                              // İlgili metin değerini belirler
                              'farklı bir tarayıcı adresi veya cihaz kendi kayıtlarını kullanır. Kart, kimlik belgesi veya konum toplanmaz.'))
                    ]),
                // expansion tile nesnesi oluşturur
                ExpansionTile(
                    // Sol taraftaki elemanı belirler
                    leading: Icon(Icons.info_outline),
                    // Başlığı belirler
                    title: Text('Koleksiyon ve kiralama hakkında'),
                    // İçerideki elemanları listeler
                    children: [
                      // İçerik etrafına boşluk bırakır
                      Padding(
                          // İç boşlukları ayarlar
                          padding: EdgeInsets.all(20),
                          // İçerikte gösterilecek widgetı belirler
                          child: Text(
                              // İlgili metin değerini belirler
                              'Bu sürümde araç bilgileri ve fiyatlar hazır örnek koleksiyondur; '
                              // İlgili metin değerini belirler
                              'görseller yapay zekâ ile üretilmiş temsilî görsellerdir. Rezervasyonlar cihazda bir yolculuk planı oluşturur. '
                              // İlgili metin değerini belirler
                              'Gerçek tedarikçiye iletim, ödeme, sürücü doğrulaması veya araç teslim onayı yapılmaz.'))
                    ]),
              ])),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 24),
          // Metin butonu oluşturur
          TextButton(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: () => showLicensePage(
                  // context bilgisini belirler
                  context: context,
                  // application ad bilgisini belirler
                  applicationName: 'Precision',
                  // application version bilgisini belirler
                  applicationVersion: '0.1.0'),
              // İçerikte gösterilecek widgetı belirler
              child: const Text('Açık kaynak lisansları')),
          // Metni gösterir
          const Text('PRECISION · YENİ ROTALAR SİZİ BEKLİYOR.',
              // Metnin hizasını ayarlar
              textAlign: TextAlign.center,
              // Görünüm stilini belirler
              style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
        ]);
      });
}

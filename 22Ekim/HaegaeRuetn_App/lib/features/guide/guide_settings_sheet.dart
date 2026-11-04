// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Sohbet controllerını projeye ekler
import '../../core/services/ai/ai_chat_controller.dart';
// Krallık tema ayarlarını projeye ekler
import '../../core/theme/realm_theme.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Bottom sheet dialog for configuring AI connection, privacy, and custom instructions.
// AI bağlantısı ve sohbet tercihlerini düzenleme alanıdır
class GuideSettingsSheet extends StatefulWidget {
  // GuideSettingsSheet nesnesinin başlangıç bilgilerini alır
  const GuideSettingsSheet({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final AiChatController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<GuideSettingsSheet> createState() => _GuideSettingsSheetState();
}
// guide settings sheet state bilgilerini ve ilgili davranışları tanımlar
class _GuideSettingsSheetState extends State<GuideSettingsSheet> {
  // adres controller alanının değişikliklerini kontrol eder
  late final TextEditingController _urlController;
  // instructions controller alanının değişikliklerini kontrol eder
  late final TextEditingController _instructionsController;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // init state için gerekli sonucu hesaplar
  void initState() {
    // Üst sınıfın başlangıç işlemlerini çalıştırır
    super.initState();
    // adres controller bilgisini yeni değerle günceller
    _urlController = TextEditingController(text: widget.controller.workerUrl);
    // instructions controller bilgisini yeni değerle günceller
    _instructionsController =
        // text editing controller bileşenini oluşturur
        TextEditingController(text: widget.controller.customInstructions ?? '');
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Artık kullanılmayan controller kaynaklarını temizler
    _urlController.dispose();
    // Artık kullanılmayan controller kaynaklarını temizler
    _instructionsController.dispose();
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Formdaki bilgileri doğrulayıp vazifeyi kaydeder
  void _save() {
    // Seçilen değeri cihazın yerel tercihlerine kaydeder
    widget.controller.setWorkerUrl(_urlController.text.trim());
    // Krallık işlemlerini yöneten controllerı gönderir
    widget.controller
        // Seçilen değeri cihazın yerel tercihlerine kaydeder
        .setCustomInstructions(_instructionsController.text.trim());
    // navigator.of bileşenini oluşturur
    Navigator.of(context).pop();
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _GuideSettingsSheetState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Güncel krallık durumunu yerel değişkene alır
    final c = widget.controller;
    // İçeriğin çevresine boşluk ekler
    return Padding(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: EdgeInsets.only(
        // left alanına 18 değerini kullanır
        left: 18,
        // right alanına 18 değerini kullanır
        right: 18,
        // top alanına 10 değerini kullanır
        top: 10,
        // bottom alanına gelen değeri kullanır
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: SingleChildScrollView(
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Column(
          // Ana yönde kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // Ana eksene dik yöndeki hizalamayı belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // İçeride sıralanacak widgetları listeler
          children: [
            // Elemanları yatay yönde sıralar
            Row(
              // İçeride sıralanacak widgetları listeler
              children: [
                // Ekrana bir simge yerleştirir
                const Icon(Icons.tune_rounded,
                    // Bu elemanın rengini belirler
                    color: RealmPalette.gold, size: 24),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(width: 8),
                // İçeriğin kalan alanı doldurmasını sağlar
                Expanded(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Text(
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    'Rehber & Yapay Zekâ Ayarları',
                    // Yazının ya da butonun görünümünü belirler
                    style: Theme.of(context)
                        // Aktif temanın metin stillerini kullanır
                        .textTheme
                        // Temadan ilgili yazı stilini seçer
                        .titleLarge
                        // Nesne null değilse bu işleme devam eder
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                // Simgeyle çalışan bir buton oluşturur
                IconButton(
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: const Icon(Icons.close_rounded),
                  // Butona basılınca çalışacak fonksiyonu bağlar
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 12),
            // Cloudflare Worker URL field
            // Ekrana metin yerleştirir
            const Text(
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'Cloudflare Worker URL (Güvenli Geçit):',
              // Yazının ya da butonun görünümünü belirler
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 4),
            // Kullanıcının yazı girebileceği alanı oluşturur
            TextField(
              // Metin veya liste kontrolcüsünü ilgili alana bağlar
              controller: _urlController,
              // Kutunun arka plan, kenar ve süslerini ayarlar
              decoration: const InputDecoration(
                // Alan boşken kullanıcıya örnek giriş metnini gösterir
                hintText: 'https://haegaruuetn-proxy.your-name.workers.dev',
                // prefix icon alanına uygun simgeyi gösterir
                prefixIcon: Icon(Icons.cloud_outlined, size: 20),
                // İçeriğin kendi içindeki boşluğunu belirler
                contentPadding:
                    // edge insets.symmetric bileşenini oluşturur
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 6),
            // Ekrana metin yerleştirir
            const Text(
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'GroqCloud API anahtarınız bu Worker üzerinde saklanır; mobil uygulamaya hiçbir secret gömülmez.',
              // Yazının ya da butonun görünümünü belirler
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 16),
            // Kullanıcı izniyle paylaşılacak bağlamı düzenler
            // switch liste tile.adaptive bileşenini oluşturur
            SwitchListTile.adaptive(
              // İçeriğin kendi içindeki boşluğunu belirler
              contentPadding: EdgeInsets.zero,
              // aktif track color alanına gelen değeri kullanır
              activeTrackColor: RealmPalette.gold,
              // başlık alanına gelen değeri kullanır
              title: const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Alışkanlık Bağlamını Paylaş',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              // subtitle alanına gelen değeri kullanır
              subtitle: const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Yalnızca mevcut rütbe ve aktif vazife özetini rehbere iletir. Tam veritabanı asla gönderilmez.',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
              // Gösterilecek güncel değeri atar
              value: c.shareHabitContext,
              // Değer değişince çalışacak fonksiyonu bağlar
              onChanged: (val) {
                // Değişen bilgiyi ekrana yansıtmak için Statei günceller
                setState(() => c.toggleShareHabitContext(val));
              },
            ),
            // İçerikler arasına ince çizgi koyar
            const Divider(height: 16),
            // Plain Turkish Mode
            // switch liste tile.adaptive bileşenini oluşturur
            SwitchListTile.adaptive(
              // İçeriğin kendi içindeki boşluğunu belirler
              contentPadding: EdgeInsets.zero,
              // aktif track color alanına gelen değeri kullanır
              activeTrackColor: RealmPalette.gold,
              // başlık alanına gelen değeri kullanır
              title: const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Sade Türkçe Yanıtlar',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              // subtitle alanına gelen değeri kullanır
              subtitle: const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Fantezi krallık lisanı yerine modern, doğrudan Türkçe ile yanıt verir.',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
              // Gösterilecek güncel değeri atar
              value: c.usePlainTurkish,
              // Değer değişince çalışacak fonksiyonu bağlar
              onChanged: (val) {
                // Değişen bilgiyi ekrana yansıtmak için Statei günceller
                setState(() => c.togglePlainTurkish(val));
              },
            ),
            // İçerikler arasına ince çizgi koyar
            const Divider(height: 16),
            // Custom instructions
            // Ekrana metin yerleştirir
            const Text(
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'Özel Talimatlar (İsteğe bağlı):',
              // Yazının ya da butonun görünümünü belirler
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 4),
            // Kullanıcının yazı girebileceği alanı oluşturur
            TextField(
              // Metin veya liste kontrolcüsünü ilgili alana bağlar
              controller: _instructionsController,
              // Metnin veya giriş alanının en fazla satır sayısını belirler
              maxLines: 2,
              // Kutunun arka plan, kenar ve süslerini ayarlar
              decoration: const InputDecoration(
                // Alan boşken kullanıcıya örnek giriş metnini gösterir
                hintText:
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    'Örn: Yanıtlarını hep 2 cümleden kısa tut, her seferinde beni adımla an...',
                // İçeriğin kendi içindeki boşluğunu belirler
                contentPadding:
                    // edge insets.symmetric bileşenini oluşturur
                    EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 18),
            // Elemanları yatay yönde sıralar
            Row(
              // İçeride sıralanacak widgetları listeler
              children: [
                // İçeriğin kalan alanı doldurmasını sağlar
                Expanded(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: OutlinedButton.icon(
                    // Yazının ya da butonun görünümünü belirler
                    style: OutlinedButton.styleFrom(
                      // İçeriğin kenarlara olan uzaklığını ayarlar
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      // Kutunun veya butonun geometrik biçimini belirler
                      shape: RoundedRectangleBorder(
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(16)),
                      // Dış çerçeve çizgisini belirler
                      side: const BorderSide(color: Color(0xFFC7BBA5)),
                    ),
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: const Text('Sohbeti Sil'),
                    // Butona basılınca çalışacak fonksiyonu bağlar
                    onPressed: () {
                      // İlgili koleksiyonu veya metin alanını temizler
                      c.clearChat();
                      // navigator.of bileşenini oluşturur
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(width: 12),
                // İçeriğin kalan alanı doldurmasını sağlar
                Expanded(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: OrnateButton(
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: 'Kaydet',
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.check_rounded,
                    // Basılınca doğrulanan veriyi kaydetmeye çalışır
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

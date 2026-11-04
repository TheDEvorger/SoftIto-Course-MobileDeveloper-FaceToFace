// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// API istemci dosyasını ekler
import '../../../core/network/api_client.dart';
// studio sayfa dosyasını ekler
import '../../../shared/design/studio_page.dart';
// çalışma alanı erişim panel ekranının değişen durumunu yönetir
class WorkspaceAccessPanel extends StatefulWidget {
  // çalışma alanı erişim panel nesnesi oluşturur
  const WorkspaceAccessPanel(
      // Veri alanlarını tanımlar
      {super.key,
      // API bilgisini zorunlu alır
      required this.api,
      // olay changed bilgisini zorunlu alır
      required this.onChanged,
      // olay örnekler bilgisini zorunlu alır
      required this.onExamples});
  // API bilgisini tutar
  final ApiClient api;
  // olay örnekler bilgisini tutar
  final VoidCallback onChanged, onExamples;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<WorkspaceAccessPanel> createState() => _WorkspaceAccessPanelState();
}
// çalışma alanı erişim panel durum ekranının durumunu yöneten sınıf
class _WorkspaceAccessPanelState extends State<WorkspaceAccessPanel> {
  // anahtar değerini belirler
  final _key = TextEditingController();
  // meşguliyet değerini belirler
  bool _busy = false;
  // hata bilgisini tutar
  String? _error;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan controller veya kaynağı temizler
    _key.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // connect işlemini asenkron yürütür
  Future<void> _connect() async {
    // Liste veya metin boşsa koşulu çalıştırır
    if (_key.text.trim().isEmpty) {
      // Değişen verileri ekrana bildirir
      setState(() => _error = 'Çalışma alanı anahtarını girin.');
      // Önceki ifadeyi tamamlar
      return;
    }
    // Değişen verileri ekrana bildirir
    setState(() {
      // meşguliyet değerini günceller
      _busy = true;
      // hata değerini günceller
      _error = null;
    });
    // Hata oluşabilecek işlemleri dener
    try {
      // Asenkron işlemin tamamlanmasını bekler
      await widget.api.connectWorkspace(_key.text.trim());
      // Verileri temizler
      _key.clear();
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) widget.onChanged();
    // İşlem hata verirse çalışır
    } catch (error) {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _error = error.toString());
    // İşlem başarılı olsa da hata verse de çalışır
    } finally {
      // Widget hâlâ ekrandaysa işlemi sürdürür
      if (mounted) setState(() => _busy = false);
    }
  }
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => StudioPanel(
          // İçerikte gösterilecek widgetı belirler
          child:
              // Elemanları alt alta dizer
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Simgeyi gösterir
        Icon(widget.api.examples ? Icons.layers_outlined : Icons.key_outlined,
            // Boyutu belirler
            size: 32, color: Theme.of(context).colorScheme.primary),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 20),
        // Metni gösterir
        Text(widget.api.examples ? 'Örnek çalışma alanı' : 'Çalışma alanınız',
            // Görünüm stilini belirler
            style: Theme.of(context).textTheme.titleLarge),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 10),
        // Metni gösterir
        Text(widget.api.examples
            // Koşul doğruysa bu değeri seçer
            ? 'Koleksiyonu keşfedin, rezervasyon oluşturun ve araçları yönetin. '
                // İlgili metin değerini belirler
                'Buradaki tüm kayıtlar kurgusaldır. Yaptığınız değişiklikler ayrı örnek veritabanında saklanır.'
            // Koşul yanlışsa bu değeri seçer
            : widget.api.authenticated
                // Koşul doğruysa bu değeri seçer
                ? 'Özel çalışma alanınıza bağlısınız.'
                // Koşul yanlışsa bu değeri seçer
                : 'Özel envanterinize erişin veya hazır örnek kayıtlarla başlayın.'),
        // Belirtilen boyutta boşluk veya kutu oluşturur
        const SizedBox(height: 24),
        // Oturum doğrulandıysa işlemi yapar
        if (!widget.api.authenticated || widget.api.examples) ...[
          // Metin giriş alanı oluşturur
          TextField(
              // İlgili controllerı bağlar
              controller: _key,
              // Girilen metnin gizlenmesini belirler
              obscureText: true,
              // enable suggestions bilgisini belirler
              enableSuggestions: false,
              // autocorrect bilgisini belirler
              autocorrect: false,
              // Etkinlik durumunu belirler
              enabled: !_busy,
              // Kutunun görünümünü ayarlar
              decoration: const InputDecoration(
                  // Giriş alanının etiketini belirler
                  labelText: 'Çalışma alanı anahtarı',
                  // Metin kutusunun sol simgesini belirler
                  prefixIcon: Icon(Icons.lock_outline)),
              // Gönderilince çalışacak fonksiyonu belirler
              onSubmitted: _busy ? null : (_) => _connect()),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 14),
          // Dolgulu buton oluşturur
          FilledButton.icon(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: _busy ? null : _connect,
              // Butonun veya öğenin simgesini belirler
              icon: const Icon(Icons.arrow_forward, size: 18),
              // Görünen etiketi belirler
              label: Text(_busy ? 'Bağlanıyor…' : 'Çalışma alanına bağlan')),
        ],
        // Oturum doğrulandıysa işlemi yapar
        if (widget.api.authenticated) ...[
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Çerçeveli buton oluşturur
          OutlinedButton.icon(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: _busy
                  // Koşul doğruysa bu değeri seçer
                  ? null
                  // Koşul yanlışsa bu değeri seçer
                  : () {
                      // widget değerini günceller
                      widget.api.workspaceKey = null;
                      // Verileri temizler
                      _key.clear();
                      // Üst widgettan gelen bilgilere erişir
                      widget.onChanged();
                    },
              // Butonun veya öğenin simgesini belirler
              icon: const Icon(Icons.logout, size: 18),
              // Görünen etiketi belirler
              label: const Text('Bağlantıyı kapat')),
        ],
        // Koşul doğruysa bu işlemi çalıştırır
        if (!widget.api.examples) ...[
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Çerçeveli buton oluşturur
          OutlinedButton.icon(
              // Butona basılınca çalışacak fonksiyonu belirler
              onPressed: _busy ? null : widget.onExamples,
              // Butonun veya öğenin simgesini belirler
              icon: const Icon(Icons.layers_outlined, size: 18),
              // Görünen etiketi belirler
              label: const Text('Örnek çalışma alanını aç')),
        ],
        // Değer null değilse koşulu çalıştırır
        if (_error != null)
          // İçerik etrafına boşluk bırakır
          Padding(
              // İç boşlukları ayarlar
              padding: const EdgeInsets.only(top: 12),
              // İçerikte gösterilecek widgetı belirler
              child: Semantics(
                  // live region bilgisini belirler
                  liveRegion: true,
                  // İçerikte gösterilecek widgetı belirler
                  child: Text(_error!,
                      // Görünüm stilini belirler
                      style: TextStyle(
                          // Rengi belirler
                          color: Theme.of(context).colorScheme.error)))),
        // Ayırıcı çizgi oluşturur
        const Divider(height: 40),
        // Metni gösterir
        const Text('Anahtar yalnızca bu oturumda kullanılır.',
            // Görünüm stilini belirler
            style: TextStyle(fontSize: 12)),
        // expansion tile nesnesi oluşturur
        const ExpansionTile(
            // tile iç boşluk bilgisini belirler
            tilePadding: EdgeInsets.zero,
            // Başlığı belirler
            title: Text('Özel çalışma alanına bağlantı'),
            // İçerideki elemanları listeler
            children: [
              // İçerik etrafına boşluk bırakır
              Padding(
                  // İç boşlukları ayarlar
                  padding: EdgeInsets.only(bottom: 16),
                  // İçerikte gösterilecek widgetı belirler
                  child: Text(
                      // İlgili metin değerini belirler
                      'Proje dizinindeki .local/operator.key dosyasının içeriğini anahtar alanına girin. '
                      // İlgili metin değerini belirler
                      'Anahtar özel çalışma alanındaki tüm kayıtlara erişir; paylaşmayın. '
                      // İlgili metin değerini belirler
                      'Örnek alanın erişimi özel verilerinize ulaşamaz.')),
            ]),
      ]));
}

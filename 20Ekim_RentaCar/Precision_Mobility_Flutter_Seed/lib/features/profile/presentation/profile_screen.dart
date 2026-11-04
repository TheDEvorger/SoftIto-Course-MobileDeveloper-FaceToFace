// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// section heading dosyasını ekler
import '../../../shared/widgets/section_heading.dart';
/// "Hesabım" profili ve ayarlar ekranı.
/// Tema modu seçimi (Sistem, Açık, Koyu) ve kimlik/gizlilik bilgilendirmelerini içerir.
// profile ekran görünümünü oluşturan widget sınıfı
class ProfileScreen extends StatelessWidget {
  // profile ekran nesnesi oluşturur
  const ProfileScreen({super.key, required this.themeMode, required this.onThemeChanged});
  /// Seçili tema modu
  // tema mod bilgisini tutar
  final ThemeMode themeMode;
  /// Tema modu değiştiğinde çağrılan geri çağırma
  // olay tema changed bilgisini tutar
  final ValueChanged<ThemeMode> onThemeChanged;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => ListView(
    // İç boşlukları ayarlar
    padding: const EdgeInsets.all(24), children: [
      // section heading nesnesi oluşturur
      const SectionHeading(title: 'Hesabım',
        // Alt başlığı belirler
        subtitle: 'Tema, doğrulama ve kişisel ayarlar'),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 20),
      // Kart görünümü oluşturur
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
        // Çapraz eksendeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Metni gösterir
          const Text('Görünüm', style: TextStyle(fontWeight: FontWeight.bold)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // İfadeye karşılaştırma koşulu ekler
          SegmentedButton<ThemeMode>(
            // segments bilgisini belirler
            segments: const [
              // button segment nesnesi oluşturur
              ButtonSegment(value: ThemeMode.system, label: Text('Sistem')),
              // button segment nesnesi oluşturur
              ButtonSegment(value: ThemeMode.light, label: Text('Açık')),
              // button segment nesnesi oluşturur
              ButtonSegment(value: ThemeMode.dark, label: Text('Koyu')),
            ],
            // Seçili olup olmadığını belirler
            selected: {themeMode},
            // selection changed için callback belirler
            onSelectionChanged: (value) => onThemeChanged(value.first)),
        ]))),
      // Belirtilen boyutta boşluk veya kutu oluşturur
      const SizedBox(height: 12),
      // Kart görünümü oluşturur
      const Card(child: ListTile(leading: Icon(Icons.verified_user_outlined),
        // Başlığı belirler
        title: Text('Kimlik doğrulama'),
        // Alt başlığı belirler
        subtitle: Text('Henüz gerçek belge toplanmıyor'))),
      // Kart görünümü oluşturur
      const Card(child: ListTile(leading: Icon(Icons.lock_outline),
        // Başlığı belirler
        title: Text('Gizlilik'),
        // Alt başlığı belirler
        subtitle: Text('Veriler ve izinler için tasarım aşaması'))),
    ]);
}

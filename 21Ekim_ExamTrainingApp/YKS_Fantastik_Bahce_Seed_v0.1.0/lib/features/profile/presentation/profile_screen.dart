// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// services dosyasını kullanıma ekler
import 'package:flutter/services.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// app copy dosyasını kullanıma ekler
import '../../../core/content/app_copy.dart';
// backup servis dosyasını kullanıma ekler
import '../../../core/database/backup_service.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// tema controller dosyasını kullanıma ekler
import '../../../core/theme/theme_controller.dart';
// student preferences dosyasını kullanıma ekler
import '../../../domain/models/student_preferences.dart';
// preferences repository dosyasını kullanıma ekler
import '../../../domain/repositories/preferences_repository.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// preferences pencere dosyasını kullanıma ekler
import '../../../shared/widgets/preferences_dialog.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// profile ekran için değişen verileri yöneten StatefulWidget kullanılır
class ProfileScreen extends StatefulWidget {
  // profile ekran sayfasını gösterir
  const ProfileScreen({
    // preferences repository bilgisini isteğe bağlı alır
    this.preferencesRepository,
    // backup servis bilgisini isteğe bağlı alır
    this.backupService,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // preferences repository bilgisini tutar
  final PreferencesRepository? preferencesRepository;
  // backup servis bilgisini tutar
  final BackupService? backupService;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<ProfileScreen> createState() => _ProfileScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _ProfileScreenState extends State<ProfileScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  StudentPreferences? _preferences;
  // İlgili değeri veya görünüm ayarını belirler
  PreferencesRepository? _prefRepo;
  // İlgili değeri veya görünüm ayarını belirler
  BackupService? _backupService;
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // repos bilgisini başlatır
    _initRepos();
  }
  // repos bilgisini başlatır
  Future<void> _initRepos() async {
    // Hata oluşturabilecek işlemleri dener
    try {
      // İlgili değer null değilse kontrol eder
      if (widget.preferencesRepository != null &&
          // İlgili değeri veya görünüm ayarını belirler
          widget.backupService != null) {
        // pref repo değerini günceller
        _prefRepo = widget.preferencesRepository;
        // backup servis değerini günceller
        _backupService = widget.backupService;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // Değer null ise varsayılanı kullanır
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
        // Değer null ise varsayılanı kullanır
        _backupService = widget.backupService ?? BackupService(db);
      }
      // preferences bilgisini yükler
      await _loadPreferences();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // preferences bilgisini yükler
  Future<void> _loadPreferences() async {
    // İlgili değer null ise kontrol eder
    if (_prefRepo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // tercihler verisini asenkron işlemin sonucundan alır
    final prefs = await _prefRepo!.getPreferences();
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // kullanıcı tercihleri değerini günceller
        _preferences = prefs;
        // yükleme durumu değerini günceller
        _loading = false;
      });
      // from preference bilgisini günceller
      AppThemeController.instance.updateFromPreference(prefs.themeMode);
    }
  }
  // preferences bilgisini açar
  Future<void> _openPreferences() async {
    // İlgili değer null ise kontrol eder
    if (_prefRepo == null) return;
    // updated verisini asenkron işlemin sonucundan alır
    final updated = await PreferencesDialog.show(
      // İlgili değeri veya görünüm ayarını belirler
      context,
      // repository bilgisini belirler
      repository: _prefRepo!,
      // initial preferences bilgisini belirler
      initialPreferences: _preferences,
    );
    // Widget artık açık değilse işlemi durdurur
    if (updated != null && mounted) {
      // Değişen verileri arayüze bildirir
      setState(() => _preferences = updated);
      // from preference bilgisini günceller
      AppThemeController.instance.updateFromPreference(updated.themeMode);
    }
  }
  // tema mode bilgisini seçer
  Future<void> _selectThemeMode() async {
    // İlgili değer null ise kontrol eder
    if (_prefRepo == null || _preferences == null) return;
    // seçili olma durumu verisini asenkron işlemin sonucundan alır
    final selected = await showDialog<ThemeModePreference>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (ctx) => SimpleDialog(
        // Başlığı belirler
        title: const Text('Tema Modu Seç'),
        // İçerideki widgetları listeler
        children: [
          // simple pencere option nesnesini oluşturur
          SimpleDialogOption(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.system),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('📱 Sistem Teması'),
          ),
          // simple pencere option nesnesini oluşturur
          SimpleDialogOption(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.light),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('🌿 Açık Doğa Bahçesi'),
          ),
          // simple pencere option nesnesini oluşturur
          SimpleDialogOption(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(ThemeModePreference.dark),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('🌙 Gece Bahçesi'),
          ),
        ],
      ),
    );
    // İlgili değer null değilse kontrol eder
    if (selected != null) {
      // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
      final updated = _preferences!.copyWith(themeMode: selected);
      // preferences bilgisini kaydeder
      await _prefRepo!.savePreferences(updated);
      // from preference bilgisini günceller
      AppThemeController.instance.updateFromPreference(selected);
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Değişen verileri arayüze bildirir
        setState(() => _preferences = updated);
      }
    }
  }
  // humorous exit bilgisini değiştirir
  Future<void> _toggleHumorousExit(bool value) async {
    // İlgili değer null ise kontrol eder
    if (_prefRepo == null || _preferences == null) return;
    // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
    final updated = _preferences!.copyWith(humorousExitEnabled: value);
    // preferences bilgisini kaydeder
    await _prefRepo!.savePreferences(updated);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() => _preferences = updated);
    }
  }
  // data bilgisini dışa aktarır
  Future<void> _exportData() async {
    // İlgili değer null ise kontrol eder
    if (_backupService == null) return;
    // json str verisini asenkron işlemin sonucundan alır
    final jsonStr = await _backupService!.exportAllDataAsJson();
    // Widget artık açık değilse işlemi durdurur
    if (!mounted) return;
    // Kullanıcıya açılır pencere gösterir
    await showDialog<void>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (ctx) => AlertDialog(
        // Başlığı belirler
        title: const Text('📦 Yerel Veri Yedeği (JSON)'),
        // Gösterilecek içeriği belirler
        content: SizedBox(
          // Genişliği belirler
          width: double.maxFinite,
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // Ana eksende kaplanacak alanı belirler
            mainAxisSize: MainAxisSize.min,
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              const Text(
                // "Tüm profil, konu ilerlemeleri, deneme ve od…" metnini kullanır
                'Tüm profil, konu ilerlemeleri, deneme ve odak verilerin başarıyla dışa aktarıldı:',
                // Görünüm stilini belirler
                style: TextStyle(fontSize: 13),
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 10),
              // Görsel bir kutu oluşturur
              Container(
                // Yüksekliği belirler
                height: 160,
                // İç boşlukları belirler
                padding: const EdgeInsets.all(10),
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Rengi belirler
                  color: Colors.black12,
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(8),
                ),
                // İçine yerleştirilecek widgetı belirler
                child: SingleChildScrollView(
                  // İçine yerleştirilecek widgetı belirler
                  child: SelectableText(
                    // İlgili değeri veya görünüm ayarını belirler
                    jsonStr,
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı tipini belirler
                      fontFamily: 'monospace',
                      // Yazı boyutunu belirler
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // actions bilgisini belirler
        actions: [
          // Simge ve metin içeren buton oluşturur
          TextButton.icon(
            // simge bilgisini belirler
            icon: const Icon(Icons.copy, size: 16),
            // Buton veya alan yazısını belirler
            label: const Text('Panoya Kopyala'),
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () {
              // clipboard.set data verisi oluşturur
              Clipboard.setData(ClipboardData(text: jsonStr));
              // navigator.of nesnesini oluşturur
              Navigator.of(ctx).pop();
              // Ekranda kısa bilgilendirme mesajı gösterir
              ScaffoldMessenger.of(context).showSnackBar(
                // Kısa bildirim mesajı oluşturur
                const SnackBar(
                  // Gösterilecek içeriği belirler
                  content: Text('✅ Yedek panoya kopyalandı.'),
                  // Arka plan rengini belirler
                  backgroundColor: GardenPalette.mossEmerald,
                ),
              );
            },
          ),
          // Dolu buton oluşturur
          FilledButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
  // confirm clear data işlemini yapar
  Future<void> _confirmClearData() async {
    // İlgili değer null ise kontrol eder
    if (_backupService == null) return;
    // confirmed verisini asenkron işlemin sonucundan alır
    final confirmed = await showDialog<bool>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (ctx) => AlertDialog(
        // Başlığı belirler
        title: const Text('⚠️ Tüm Verileri Sıfırla'),
        // Gösterilecek içeriği belirler
        content: const Text(
          // "Bu işlem geri alınamaz.  Tüm deneme kayıtla…" metnini kullanır
          'Bu işlem geri alınamaz.\n\nTüm deneme kayıtların, konu tamamlama verilerin, günlük planların ve odak oturumların kalıcı olarak silinecektir.\n\nEmin misiniz?',
        ),
        // actions bilgisini belirler
        actions: [
          // Metin butonu oluşturur
          TextButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(false),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('Vazgeç'),
          ),
          // Dolu buton oluşturur
          FilledButton(
            // Görünüm stilini belirler
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(true),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('Evet, Tümünü Sil'),
          ),
        ],
      ),
    );
    // Belirtilen koşul doğruysa işlemi yapar
    if (confirmed == true) {
      // all user data bilgisini temizler
      await _backupService!.clearAllUserData();
      // preferences bilgisini yükler
      await _loadPreferences();
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Ekranda kısa bilgilendirme mesajı gösterir
        ScaffoldMessenger.of(context).showSnackBar(
          // Kısa bildirim mesajı oluşturur
          const SnackBar(
            // Gösterilecek içeriği belirler
            content: Text('🧹 Tüm yerel veriler sıfırlandı.'),
          ),
        );
      }
    }
  }
  // tema mode label işlemini yapar
  String get _themeModeLabel {
    // Değere göre uygun durumu seçer
    switch (_preferences?.themeMode) {
      // tema mode preference.light durumu için çalışır
      case ThemeModePreference.light:
        // "🌿 Açık Doğa Bahçesi" metnini kullanır
        return '🌿 Açık Doğa Bahçesi';
      // tema mode preference.dark durumu için çalışır
      case ThemeModePreference.dark:
        // "🌙 Gece Bahçesi" metnini kullanır
        return '🌙 Gece Bahçesi';
      // tema mode preference.system durumu için çalışır
      case ThemeModePreference.system:
      // Diğer durumlar için çalışır
      default:
        // "📱 Sistem Teması" metnini kullanır
        return '📱 Sistem Teması';
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Belirtilen koşul doğruysa işlemi yapar
    if (_loading) {
      // İçeriği ortalar
      return const Center(
        // İçine yerleştirilecek widgetı belirler
        child: CircularProgressIndicator(color: GardenPalette.mossEmerald),
      );
    }
    // ad bilgisini hesaplayıp saklar
    final name = _preferences?.displayName ?? 'Bahçıvan Öğrenci';
    // field bilgisini hesaplayıp saklar
    final field = _preferences?.field ?? 'Sayısal';
    // hedef net değerini tanımlar
    final targetNet =
        // Değer null ise varsayılanı kullanır
        _preferences?.targetNet?.toStringAsFixed(1) ?? 'Belirlenmedi';
    // hedef tarihi bilgisini hesaplayıp saklar
    final targetDate = _preferences?.targetDate;
    // Material görünüm katmanı oluşturur
    return Material(
      // Rengi belirler
      color: Colors.transparent,
      // İçine yerleştirilecek widgetı belirler
      child: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.all(16),
        // İçerideki widgetları listeler
        children: [
          // forest hero kart kartını oluşturur
          ForestHeroCard(
            // görsel dosya yolu bilgisini belirler
            assetPath: GardenScenes.terrace,
            // tag bilgisini belirler
            tag: '🌻 Bahçıvan Profili',
            // Başlığı belirler
            title: name,
            // Alt başlığı belirler
            subtitle: 'Hedef: $field Alanı • Net Hedefi: $targetNet',
            // Yüksekliği belirler
            height: 220,
            // action label bilgisini belirler
            actionLabel: 'Profili Düzenle ✍️',
            // on action olayındaki fonksiyonu belirler
            onAction: _openPreferences,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // seed notice nesnesini oluşturur
          const SeedNotice(),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // YKS Goal Header & Card
          // botanical section header nesnesini oluşturur
          BotanicalSectionHeader(
            // Başlığı belirler
            title: 'YKS Hedefin',
            // Alt başlığı belirler
            subtitle: 'Hedeflenen alan ve puan/net eşikleri',
            // simge bilgisini belirler
            icon: Icons.flag_outlined,
            // action metin bilgisini belirler
            actionText: 'Hedefi Değiştir',
            // on action olayındaki fonksiyonu belirler
            onAction: _openPreferences,
          ),
          // golden achievement kart kartını oluşturur
          GoldenAchievementCard(
            // Başlığı belirler
            title: 'Hedef Alan: $field',
            // Alt başlığı belirler
            subtitle: targetDate != null
                // Koşul doğruysa bu değeri kullanır
                ? 'Sınav Tarihi: ${targetDate.day}.${targetDate.month}.${targetDate.year}'
                // Koşul yanlışsa bu değeri kullanır
                : 'Sınav tarihi henüz ayarlanmadı.',
            // badge metin bilgisini belirler
            badgeText: '$targetNet Net',
            // simge bilgisini belirler
            icon: Icons.military_tech_outlined,
            // Dokunulunca çalışacak fonksiyonu belirler
            onTap: _openPreferences,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Preferences and App Settings Header
          // botanical section header nesnesini oluşturur
          const BotanicalSectionHeader(
            // Başlığı belirler
            title: 'Bahçe Tercihleri ve Ayarlar',
            // Alt başlığı belirler
            subtitle: 'Görünüm, mizah ve yerel veri yönetimi',
            // simge bilgisini belirler
            icon: Icons.tune_outlined,
          ),
          // garden kart kartını oluşturur
          GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Column(
              // İçerideki widgetları listeler
              children: [
                // Theme Mode Selector
                // Hazır liste satırı oluşturur
                ListTile(
                  // content padding bilgisini belirler
                  contentPadding: EdgeInsets.zero,
                  // Sol tarafta gösterilecek öğeyi belirler
                  leading: Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(8),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.mossEmerald.withAlpha(25),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(
                      // Gösterilecek simgeyi belirler
                      Icons.palette_outlined,
                      // Rengi belirler
                      color: GardenPalette.mossEmerald,
                      // Boyutu belirler
                      size: 22,
                    ),
                  ),
                  // Başlığı belirler
                  title: const Text(
                    // "Tema Modu" metnini kullanır
                    'Tema Modu',
                    // Görünüm stilini belirler
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  // Alt başlığı belirler
                  subtitle: Text(_themeModeLabel),
                  // Sağ tarafta gösterilecek öğeyi belirler
                  trailing: const Icon(Icons.chevron_right),
                  // Dokunulunca çalışacak fonksiyonu belirler
                  onTap: _selectThemeMode,
                ),
                // Ayırıcı çizgi gösterir
                const Divider(height: 16),
                // Humorous Farewell Switch
                // Hazır liste satırı oluşturur
                ListTile(
                  // content padding bilgisini belirler
                  contentPadding: EdgeInsets.zero,
                  // Sol tarafta gösterilecek öğeyi belirler
                  leading: Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(8),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.peachCoral.withAlpha(25),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(
                      // Gösterilecek simgeyi belirler
                      Icons.sentiment_satisfied_alt,
                      // Rengi belirler
                      color: GardenPalette.peachCoral,
                      // Boyutu belirler
                      size: 22,
                    ),
                  ),
                  // Başlığı belirler
                  title: const Text(
                    // "Mizahi Çıkış Sözü" metnini kullanır
                    'Mizahi Çıkış Sözü',
                    // Görünüm stilini belirler
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  // Alt başlığı belirler
                  subtitle: const Text(
                    // "Kullanıcının tercihine bağlı mizahi söz" metnini kullanır
                    'Kullanıcının tercihine bağlı mizahi söz',
                  ),
                  // Sağ tarafta gösterilecek öğeyi belirler
                  trailing: Switch(
                    // Kullanılacak değeri belirler
                    value: _preferences?.humorousExitEnabled ?? false,
                    // active track renk bilgisini belirler
                    activeTrackColor: GardenPalette.mossEmerald,
                    // Değer değişince çalışacak fonksiyonu belirler
                    onChanged: _toggleHumorousExit,
                  ),
                ),
                // Preview card if enabled
                // Belirtilen koşul doğruysa işlemi yapar
                if (_preferences?.humorousExitEnabled == true) ...[
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 8),
                  // Görsel bir kutu oluşturur
                  Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(12),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.peachCoral.withAlpha(20),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(12),
                      // Kenarlığı belirler
                      border: Border.all(
                        // Rengi belirler
                        color: GardenPalette.peachCoral.withAlpha(60),
                      ),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Row(
                      // İçerideki widgetları listeler
                      children: [
                        // Simge gösterir
                        Icon(
                          // Gösterilecek simgeyi belirler
                          Icons.format_quote,
                          // Rengi belirler
                          color: GardenPalette.peachCoral,
                          // Boyutu belirler
                          size: 20,
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        SizedBox(width: 8),
                        // Kalan boşluğu kullanacak alan oluşturur
                        Expanded(
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            AppCopy.optionalFarewell,
                            // Görünüm stilini belirler
                            style: TextStyle(
                              // Yazının italik olup olmadığını belirler
                              fontStyle: FontStyle.italic,
                              // Yazı boyutunu belirler
                              fontSize: 12,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Data Privacy & Management Section
          // botanical section header nesnesini oluşturur
          const BotanicalSectionHeader(
            // Başlığı belirler
            title: 'Yerel Veri ve Gizlilik',
            // Alt başlığı belirler
            subtitle: 'Kişisel verilerin yalnızca cihazında saklanır',
            // simge bilgisini belirler
            icon: Icons.security_outlined,
          ),
          // garden kart kartını oluşturur
          GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Column(
              // İçerideki widgetları listeler
              children: [
                // Hazır liste satırı oluşturur
                ListTile(
                  // content padding bilgisini belirler
                  contentPadding: EdgeInsets.zero,
                  // Sol tarafta gösterilecek öğeyi belirler
                  leading: Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(8),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.streamTurquoise.withAlpha(25),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(
                      // Gösterilecek simgeyi belirler
                      Icons.file_download_outlined,
                      // Rengi belirler
                      color: GardenPalette.streamTurquoise,
                      // Boyutu belirler
                      size: 22,
                    ),
                  ),
                  // Başlığı belirler
                  title: const Text(
                    // "Yerel Verileri Dışa Aktar (JSON)" metnini kullanır
                    'Yerel Verileri Dışa Aktar (JSON)',
                    // Görünüm stilini belirler
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  // Alt başlığı belirler
                  subtitle: const Text(
                    // "Tüm kayıtlarını kayıpsız JSON formatında ye…" metnini kullanır
                    'Tüm kayıtlarını kayıpsız JSON formatında yedekle',
                  ),
                  // Sağ tarafta gösterilecek öğeyi belirler
                  trailing: const Icon(Icons.chevron_right),
                  // Dokunulunca çalışacak fonksiyonu belirler
                  onTap: _exportData,
                ),
                // Ayırıcı çizgi gösterir
                const Divider(height: 16),
                // Hazır liste satırı oluşturur
                ListTile(
                  // content padding bilgisini belirler
                  contentPadding: EdgeInsets.zero,
                  // Sol tarafta gösterilecek öğeyi belirler
                  leading: Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(8),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: Colors.redAccent.withAlpha(25),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(
                      // Gösterilecek simgeyi belirler
                      Icons.delete_forever_outlined,
                      // Rengi belirler
                      color: Colors.redAccent,
                      // Boyutu belirler
                      size: 22,
                    ),
                  ),
                  // Başlığı belirler
                  title: const Text(
                    // "Tüm Verileri Sıfırla" metnini kullanır
                    'Tüm Verileri Sıfırla',
                    // Görünüm stilini belirler
                    style: TextStyle(
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.w600,
                      // Rengi belirler
                      color: Colors.redAccent,
                    ),
                  ),
                  // Alt başlığı belirler
                  subtitle: const Text(
                    // "Denemeleri, hedefleri ve konu kayıtlarını sil" metnini kullanır
                    'Denemeleri, hedefleri ve konu kayıtlarını sil',
                  ),
                  // Sağ tarafta gösterilecek öğeyi belirler
                  trailing: const Icon(Icons.chevron_right),
                  // Dokunulunca çalışacak fonksiyonu belirler
                  onTap: _confirmClearData,
                ),
              ],
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Privacy Guarantee Card
          // water info kart kartını oluşturur
          const WaterInfoCard(
            // Başlığı belirler
            title: 'Gizlilik ve Sıfır Takip Taahhüdü',
            // mesaj bilgisini belirler
            message:
                // "Fantastik Bahçe YKS, verilerini üçüncü tara…" metnini kullanır
                'Fantastik Bahçe YKS, verilerini üçüncü taraf sunuculara göndermez. Reklam SDK’sı, kullanıcı takip kodu veya gizli veri toplama içermez.',
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Asenkron işlemler için kütüphaneyi ekler
import 'dart:async';
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// focus record dosyasını kullanıma ekler
import '../../../domain/models/focus_record.dart';
// focus repository dosyasını kullanıma ekler
import '../../../domain/repositories/focus_repository.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden ilerleme dosyasını kullanıma ekler
import '../../../shared/widgets/garden_progress.dart';
// pomodoro mode dosyasını kullanıma ekler
import '../domain/pomodoro_mode.dart';
// focus ekran için değişen verileri yöneten StatefulWidget kullanılır
class FocusScreen extends StatefulWidget {
  // focus ekran sayfasını gösterir
  const FocusScreen({
    // repository bilgisini isteğe bağlı alır
    this.repository,
    // custom duration seconds bilgisini isteğe bağlı alır
    this.customDurationSeconds,
    // now provider bilgisini isteğe bağlı alır
    this.nowProvider,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // repository bilgisini tutar
  final FocusRepository? repository;
  // custom duration seconds bilgisini tutar
  final int? customDurationSeconds;
  // Fonksiyonun aldığı parametreleri tanımlar
  final DateTime Function()? nowProvider;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<FocusScreen> createState() => FocusScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class FocusScreenState extends State<FocusScreen> with WidgetsBindingObserver {
  // İlgili değeri veya görünüm ayarını belirler
  FocusRepository? _repo;
  // İlgili değeri veya görünüm ayarını belirler
  PomodoroMode _mode = PomodoroMode.focus;
  // initial seconds bilgisini tutar
  late int _initialSeconds;
  // remaining seconds bilgisini tutar
  late int _remainingSeconds;
  // İlgili değeri veya görünüm ayarını belirler
  Timer? _timer;
  // deadline bilgisini tutar
  DateTime? _deadline;
  // session started at bilgisini tutar
  DateTime? _sessionStartedAt;
  // history için boş koleksiyon oluşturur
  List<FocusSession> _history = [];
  // toplam elapsed seconds için başlangıç sayısını belirler
  int _totalElapsedSeconds = 0;
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // şimdiki zaman işlemini yapar
  DateTime get _now =>
      // Güncel tarih ve saati alır
      widget.nowProvider != null ? widget.nowProvider!() : DateTime.now();
  // running bilgisini kontrol eder
  bool get isRunning => _timer != null;
  // remaining seconds işlemini yapar
  int get remainingSeconds => _remainingSeconds;
  // güncel mode işlemini yapar
  PomodoroMode get currentMode => _mode;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // observer bilgisini ekler
    WidgetsBinding.instance.addObserver(this);
    // Değer null ise varsayılanı kullanır
    _initialSeconds = widget.customDurationSeconds ?? _mode.defaultSeconds;
    // remaining seconds değerini günceller
    _remainingSeconds = _initialSeconds;
    // repo bilgisini başlatır
    _initRepo();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // observer bilgisini kaldırır
    WidgetsBinding.instance.removeObserver(this);
    // cancel işlemini yapar
    _timer?.cancel();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // did change app lifecycle durum işlemini yapar
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // İlgili değer null değilse kontrol eder
    if (state == AppLifecycleState.resumed && isRunning && _deadline != null) {
      // sync with wall clock işlemini yapar
      _syncWithWallClock();
    }
  }
  // sync with wall clock işlemini yapar
  void _syncWithWallClock() {
    // İlgili değer null ise kontrol eder
    if (_deadline == null) return;
    // diff bilgisini hesaplayıp saklar
    final diff = _deadline!.difference(_now).inSeconds;
    // Belirtilen koşul doğruysa işlemi yapar
    if (diff <= 0) {
      // complete session işlemini yapar
      _completeSession();
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // Değişen verileri arayüze bildirir
      setState(() {
        // Değeri belirtilen aralıkta sınırlar
        _remainingSeconds = diff.clamp(0, _initialSeconds);
      });
    }
  }
  // repo bilgisini başlatır
  Future<void> _initRepo() async {
    // Hata oluşturabilecek işlemleri dener
    try {
      // İlgili değer null değilse kontrol eder
      if (widget.repository != null) {
        // repo değerini günceller
        _repo = widget.repository;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // focus repository işlemini yapar
        _repo = FocusRepository(db);
      }
      // history bilgisini yükler
      await _loadHistory();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // history bilgisini yükler
  Future<void> _loadHistory() async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // history verisini asenkron işlemin sonucundan alır
    final history = await _repo!.getAllSessions();
    // toplam secs verisini asenkron işlemin sonucundan alır
    final totalSecs = await _repo!.getTotalElapsedSeconds();
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // history değerini günceller
        _history = history;
        // toplam elapsed seconds değerini günceller
        _totalElapsedSeconds = totalSecs;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // switch mode işlemini yapar
  void switchMode(PomodoroMode newMode) {
    // Belirtilen koşul doğruysa işlemi yapar
    if (_mode == newMode && !isRunning) return;
    // cancel işlemini yapar
    _timer?.cancel();
    // zamanlayıcı değerini günceller
    _timer = null;
    // deadline değerini günceller
    _deadline = null;
    // Değişen verileri arayüze bildirir
    setState(() {
      // mod değerini günceller
      _mode = newMode;
      // initial seconds değerini günceller
      _initialSeconds = newMode.defaultSeconds;
      // remaining seconds değerini günceller
      _remainingSeconds = _initialSeconds;
    });
  }
  // custom minutes bilgisini ayarlar
  void setCustomMinutes(int minutes) {
    // cancel işlemini yapar
    _timer?.cancel();
    // zamanlayıcı değerini günceller
    _timer = null;
    // deadline değerini günceller
    _deadline = null;
    // Değişen verileri arayüze bildirir
    setState(() {
      // initial seconds değerini günceller
      _initialSeconds = minutes * 60;
      // remaining seconds değerini günceller
      _remainingSeconds = _initialSeconds;
    });
  }
  // start işlemini yapar
  void start() {
    // Belirtilen koşul doğruysa işlemi yapar
    if (isRunning || _remainingSeconds <= 0) return;
    // session started at değerini günceller
    _sessionStartedAt = _now;
    // add işlemini yapar
    _deadline = _now.add(Duration(seconds: _remainingSeconds));
    // periodic işlemini yapar
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      // Widget artık açık değilse işlemi durdurur
      if (!mounted) return;
      // diff bilgisini hesaplayıp saklar
      final diff = _deadline!.difference(_now).inSeconds;
      // Belirtilen koşul doğruysa işlemi yapar
      if (diff <= 0) {
        // complete session işlemini yapar
        _completeSession();
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // Değişen verileri arayüze bildirir
        setState(() {
          // Değeri belirtilen aralıkta sınırlar
          _remainingSeconds = diff.clamp(0, _initialSeconds);
        });
      }
    });
    // Değişen verileri arayüze bildirir
    setState(() {});
  }
  // pause işlemini yapar
  void pause() {
    // Belirtilen koşul doğruysa işlemi yapar
    if (!isRunning) return;
    // sync with wall clock işlemini yapar
    _syncWithWallClock();
    // cancel işlemini yapar
    _timer?.cancel();
    // zamanlayıcı değerini günceller
    _timer = null;
    // deadline değerini günceller
    _deadline = null;
    // Değişen verileri arayüze bildirir
    setState(() {});
  }
  // reset işlemini yapar
  void reset() {
    // cancel işlemini yapar
    _timer?.cancel();
    // zamanlayıcı değerini günceller
    _timer = null;
    // deadline değerini günceller
    _deadline = null;
    // Değişen verileri arayüze bildirir
    setState(() {
      // remaining seconds değerini günceller
      _remainingSeconds = _initialSeconds;
    });
  }
  // complete session işlemini yapar
  Future<void> _completeSession() async {
    // cancel işlemini yapar
    _timer?.cancel();
    // zamanlayıcı değerini günceller
    _timer = null;
    // deadline değerini günceller
    _deadline = null;
    // geçen süre bilgisini hesaplayıp saklar
    final elapsed = _initialSeconds;
    // Değişen verileri arayüze bildirir
    setState(() {
      // remaining seconds değerini günceller
      _remainingSeconds = 0;
    });
    // İlgili değer null değilse kontrol eder
    if (_repo != null) {
      // session bilgisini hesaplayıp saklar
      final session = FocusSession(
        // ID bilgisini belirler
        id: 'focus_${_now.millisecondsSinceEpoch}',
        // başlangıç zamanı bilgisini belirler
        startedAt: _sessionStartedAt ?? _now,
        // saniye cinsinden süre bilgisini belirler
        durationSeconds: _initialSeconds,
        // elapsed seconds bilgisini belirler
        elapsedSeconds: elapsed,
        // Ders ID bilgisini belirler
        subjectId: _mode.name,
        // tamamlananlar bilgisini belirler
        completed: true,
      );
      // focus session bilgisini kaydeder
      await _repo!.saveFocusSession(session);
      // history bilgisini yükler
      await _loadHistory();
    }
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Ekranda kısa bilgilendirme mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        // Kısa bildirim mesajı oluşturur
        SnackBar(
          // Gösterilecek içeriği belirler
          content: Text(
            // "🌟 Tebrikler! ${_mode.label} oturumunu başar…" metnini kullanır
            '🌟 Tebrikler! ${_mode.label} oturumunu başarıyla tamamladın.',
          ),
          // Arka plan rengini belirler
          backgroundColor: GardenPalette.mossEmerald,
          // Animasyonun süresini belirler
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // disable animations bilgisini ekran ölçüsünden hesaplar
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // minutes bilgisini hesaplayıp saklar
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    // seconds bilgisini hesaplayıp saklar
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    // ilerleme bilgisini hesaplayıp saklar
    final progress = _initialSeconds > 0
        // Koşul doğruysa bu değeri kullanır
        ? ((_initialSeconds - _remainingSeconds) / _initialSeconds)
            // Değeri belirtilen aralıkta sınırlar
            .clamp(0.0, 1.0)
        // Koşul yanlışsa bu değeri kullanır
        : 0.0;
    // toplam minutes bilgisini hesaplayıp saklar
    final totalMinutes = _totalElapsedSeconds ~/ 60;
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: const Text('Orman Çalışma Kulübesi'),
        // center title bilgisini belirler
        centerTitle: false,
      ),
      // Sayfanın ana içeriğini belirler
      body: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.all(16),
        // İçerideki widgetları listeler
        children: [
          // forest hero kart kartını oluşturur
          const ForestHeroCard(
            // görsel dosya yolu bilgisini belirler
            assetPath: GardenScenes.cottage,
            // tag bilgisini belirler
            tag: '⏳ Pomodoro & Odaklanma',
            // Başlığı belirler
            title: 'Sessiz Çalışma Kulübesi',
            // Alt başlığı belirler
            subtitle: 'Dış dünyayı unut; sadece öğrenmeye ve hedefine odaklan.',
            // Yüksekliği belirler
            height: 190,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Total focus time badge
          // Belirtilen koşul doğruysa işlemi yapar
          if (!_loading && totalMinutes > 0)
            // İç boşluk ekler
            Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.only(bottom: 12),
              // İçine yerleştirilecek widgetı belirler
              child: WaterInfoCard(
                // Başlığı belirler
                title: 'Toplam Odaklanma Başarın',
                // mesaj bilgisini belirler
                message:
                    // "Bugüne kadar kulübede toplam $totalMinutes …" metnini kullanır
                    'Bugüne kadar kulübede toplam $totalMinutes dakika boyunca dikkatin dağılmadan çalıştın.',
              ),
            ),
          // Mode Selector
          // nature segmented control nesnesini oluşturur
          NatureSegmentedControl<PomodoroMode>(
            // Listelenecek öğeleri belirler
            items: const {
              // İlgili değeri veya görünüm ayarını belirler
              PomodoroMode.focus: '25 dk Odak',
              // İlgili değeri veya görünüm ayarını belirler
              PomodoroMode.shortBreak: '5 dk Mola',
              // İlgili değeri veya görünüm ayarını belirler
              PomodoroMode.longBreak: '15 dk Uzun Mola',
            },
            // seçili olma durumu bilgisini belirler
            selected: _mode,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: switchMode,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Timer Card
          // garden kart kartını oluşturur
          GardenCard(
            // İç boşlukları belirler
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            // İçine yerleştirilecek widgetı belirler
            child: Column(
              // İçerideki widgetları listeler
              children: [
                // Mode indicator tag
                // Görsel bir kutu oluşturur
                Container(
                  // İç boşlukları belirler
                  padding:
                      // Yatay ve dikey boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: isRunning
                        // Koşul doğruysa bu değeri kullanır
                        ? GardenPalette.peachCoral.withAlpha(25)
                        // Koşul yanlışsa bu değeri kullanır
                        : _mode.accentColor.withAlpha(25),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(12),
                    // Kenarlığı belirler
                    border: Border.all(
                      // Rengi belirler
                      color: isRunning
                          // Koşul doğruysa bu değeri kullanır
                          ? GardenPalette.peachCoral.withAlpha(60)
                          // Koşul yanlışsa bu değeri kullanır
                          : _mode.accentColor.withAlpha(60),
                    ),
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // Ana eksende kaplanacak alanı belirler
                    mainAxisSize: MainAxisSize.min,
                    // İçerideki widgetları listeler
                    children: [
                      // Simge gösterir
                      Icon(
                        // İlgili değeri veya görünüm ayarını belirler
                        _mode.icon,
                        // Boyutu belirler
                        size: 16,
                        // Rengi belirler
                        color: isRunning
                            // Koşul doğruysa bu değeri kullanır
                            ? GardenPalette.peachCoral
                            // Koşul yanlışsa bu değeri kullanır
                            : _mode.accentColor,
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 6),
                      // Metni ekranda gösterir
                      Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        isRunning
                            // Koşul doğruysa bu değeri kullanır
                            ? '🌿 ${_mode.label} Devam Ediyor'
                            // Koşul yanlışsa bu değeri kullanır
                            : '🌱 ${_mode.label} Hazır',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 13,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: isRunning
                              // Koşul doğruysa bu değeri kullanır
                              ? GardenPalette.peachCoral
                              // Koşul yanlışsa bu değeri kullanır
                              : _mode.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 20),
                // Progress Ring with Countdown Center
                // Elemanları üst üste yerleştirir
                Stack(
                  // İçeriğin hizalanmasını belirler
                  alignment: Alignment.center,
                  // İçerideki widgetları listeler
                  children: [
                    // organic ilerleme ring nesnesini oluşturur
                    OrganicProgressRing(
                      // ilerleme bilgisini belirler
                      progress: progress,
                      // Boyutu belirler
                      size: 180,
                      // Çizgi kalınlığını belirler
                      strokeWidth: 10,
                      // center metin bilgisini belirler
                      centerText: '',
                      // Etkin durum rengini belirler
                      activeColor: isRunning
                          // Koşul doğruysa bu değeri kullanır
                          ? GardenPalette.peachCoral
                          // Koşul yanlışsa bu değeri kullanır
                          : _mode.accentColor,
                    ),
                    // Erişilebilirlik açıklaması ekler
                    Semantics(
                      // Buton veya alan yazısını belirler
                      label:
                          // "Kalan odak süresi $minutes dakika $seconds …" metnini kullanır
                          'Kalan odak süresi $minutes dakika $seconds saniye',
                      // İçine yerleştirilecek widgetı belirler
                      child: Text(
                        // "$minutes:$seconds" metnini kullanır
                        '$minutes:$seconds',
                        // Yazıyı hizalar
                        textAlign: TextAlign.center,
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 48,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.w900,
                          // Harfler arasındaki boşluğu belirler
                          letterSpacing: 2,
                          // Rengi belirler
                          color: isDark
                              // Koşul doğruysa bu değeri kullanır
                              ? const Color(0xFFF8F2E8)
                              // Koşul yanlışsa bu değeri kullanır
                              : GardenPalette.inkPlum,
                        ),
                      ),
                    ),
                  ],
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 24),
                // Controls: Start/Pause and Reset
                // Elemanları yan yana dizer
                Row(
                  // Ana eksendeki hizalamayı belirler
                  mainAxisAlignment: MainAxisAlignment.center,
                  // İçerideki widgetları listeler
                  children: [
                    // Esneyebilen alan oluşturur
                    Flexible(
                      // İçine yerleştirilecek widgetı belirler
                      child: GardenPrimaryButton(
                        // Buton veya alan yazısını belirler
                        label: isRunning ? 'Duraklat' : 'Başlat',
                        // simge bilgisini belirler
                        icon: isRunning ? Icons.pause : Icons.play_arrow,
                        // Basılınca çalışacak fonksiyonu belirler
                        onPressed: isRunning ? pause : start,
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(width: 14),
                    // botanical icon button nesnesini oluşturur
                    BotanicalIconButton(
                      // simge bilgisini belirler
                      icon: Icons.refresh,
                      // tooltip bilgisini belirler
                      tooltip: 'Sıfırla',
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: reset,
                      // Boyutu belirler
                      size: 48,
                      // icon size bilgisini belirler
                      iconSize: 22,
                    ),
                  ],
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 14),
                // Quick Minutes Selector
                // Öğeleri sığmadıkça alt satıra geçirir
                Wrap(
                  // spacing bilgisini belirler
                  spacing: 8,
                  // run spacing bilgisini belirler
                  runSpacing: 6,
                  // İçeriğin hizalanmasını belirler
                  alignment: WrapAlignment.center,
                  // İçerideki widgetları listeler
                  children: [15, 25, 45, 60].map((m) {
                    // is güncel bilgisini iki değeri karşılaştırarak hesaplar
                    final isCurrent = _initialSeconds == m * 60;
                    // Tıklanabilir alan oluşturur
                    return InkWell(
                      // Dokunulunca çalışacak fonksiyonu belirler
                      onTap: () => setCustomMinutes(m),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                      // İçine yerleştirilecek widgetı belirler
                      child: AnimatedContainer(
                        // Animasyonun süresini belirler
                        duration: disableAnimations
                            // Koşul doğruysa bu değeri kullanır
                            ? Duration.zero
                            // Koşul yanlışsa bu değeri kullanır
                            : const Duration(milliseconds: 150),
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(
                            // horizontal bilgisini belirler
                            horizontal: 10, vertical: 4),
                        // Kutu ve kenarlık görünümünü belirler
                        decoration: BoxDecoration(
                          // Rengi belirler
                          color: isCurrent
                              // Koşul doğruysa bu değeri kullanır
                              ? GardenPalette.mossEmerald
                              // Koşul yanlışsa bu değeri kullanır
                              : (isDark
                                  // Koşul doğruysa bu değeri kullanır
                                  ? GardenPalette.nightCard
                                  // Koşul yanlışsa bu değeri kullanır
                                  : GardenPalette.gardenPaper),
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(10),
                          // Kenarlığı belirler
                          border: Border.all(
                            // Rengi belirler
                            color: isCurrent
                                // Koşul doğruysa bu değeri kullanır
                                ? GardenPalette.mossEmerald
                                // Koşul yanlışsa bu değeri kullanır
                                : GardenPalette.mossEmerald.withAlpha(40),
                          ),
                        ),
                        // İçine yerleştirilecek widgetı belirler
                        child: Text(
                          // "$m dk" metnini kullanır
                          '$m dk',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Yazı kalınlığını belirler
                            fontWeight:
                                // Koşula göre iki değerden birini seçer
                                isCurrent ? FontWeight.bold : FontWeight.w500,
                            // Rengi belirler
                            color: isCurrent
                                // Koşul doğruysa bu değeri kullanır
                                ? Colors.white
                                // Koşul yanlışsa bu değeri kullanır
                                : (isDark
                                    // Koşul doğruysa bu değeri kullanır
                                    ? Colors.white70
                                    // Koşul yanlışsa bu değeri kullanır
                                    : GardenPalette.inkPlum),
                          ),
                        ),
                      ),
                    );
                  // Sonuçları listeye çevirir
                  }).toList(),
                ),
              ],
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 20),
          // Session History
          // botanical section header nesnesini oluşturur
          const BotanicalSectionHeader(
            // Başlığı belirler
            title: 'Tamamlanan Odak Oturumları',
            // Alt başlığı belirler
            subtitle: 'Kulübede kaydettiğin gerçek çalışma süreleri',
            // simge bilgisini belirler
            icon: Icons.history,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 10),
          // Liste veya metin boşsa bu koşul çalışır
          if (_history.isEmpty)
            // garden kart kartını oluşturur
            GardenCard(
              // İç boşlukları belirler
              padding: const EdgeInsets.all(20),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.hourglass_empty,
                    // Boyutu belirler
                    size: 32,
                    // Rengi belirler
                    color: Colors.grey.shade400,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 14),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Column(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçerideki widgetları listeler
                      children: [
                        // Metni ekranda gösterir
                        const Text(
                          // "Henüz Kayıtlı Oturum Yok" metnini kullanır
                          'Henüz Kayıtlı Oturum Yok',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.bold,
                            // Yazı boyutunu belirler
                            fontSize: 14,
                          ),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 2),
                        // Metni ekranda gösterir
                        Text(
                          // "Başlat butonuna basarak ilk odak seansını t…" metnini kullanır
                          'Başlat butonuna basarak ilk odak seansını tamamlayabilirsin.',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Rengi belirler
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          // Önceki koşul sağlanmazsa çalışır
          else
            // Öğeleri tek tek dönüştürür
            ..._history.take(6).map((item) {
              // dur min bilgisini hesaplayıp saklar
              final durMin = item.elapsedSeconds ~/ 60;
              // dur sec bilgisini hesaplayıp saklar
              final durSec = item.elapsedSeconds % 60;
              // tarih str değerini tanımlar
              final dateStr =
                  // "${item.startedAt.day}.${item.startedAt.mont…" metnini kullanır
                  '${item.startedAt.day}.${item.startedAt.month}.${item.startedAt.year} ${item.startedAt.hour.toString().padLeft(2, '0')}:${item.startedAt.minute.toString().padLeft(2, '0')}';
              // İç boşluk ekler
              return Padding(
                // İç boşlukları belirler
                padding: const EdgeInsets.only(bottom: 8),
                // İçine yerleştirilecek widgetı belirler
                child: GardenCard(
                  // İç boşlukları belirler
                  padding:
                      // Yatay ve dikey boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // İçerideki widgetları listeler
                    children: [
                      // Görsel bir kutu oluşturur
                      Container(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.all(8),
                        // Kutu ve kenarlık görünümünü belirler
                        decoration: BoxDecoration(
                          // Rengi belirler
                          color: GardenPalette.mossEmerald.withAlpha(25),
                          // Widgetın kenar şeklini belirler
                          shape: BoxShape.circle,
                        ),
                        // İçine yerleştirilecek widgetı belirler
                        child: const Icon(
                          // Gösterilecek simgeyi belirler
                          Icons.check_circle,
                          // Boyutu belirler
                          size: 18,
                          // Rengi belirler
                          color: GardenPalette.mossEmerald,
                        ),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 12),
                      // Kalan boşluğu kullanacak alan oluşturur
                      Expanded(
                        // İçine yerleştirilecek widgetı belirler
                        child: Column(
                          // Çapraz eksendeki hizalamayı belirler
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // İçerideki widgetları listeler
                          children: [
                            // Metni ekranda gösterir
                            Text(
                              // item.ders id değerini günceller
                              item.subjectId == PomodoroMode.shortBreak.name
                                  // Koşul doğruysa bu değeri kullanır
                                  ? 'Kısa Mola'
                                  // Koşul yanlışsa bu değeri kullanır
                                  : (item.subjectId ==
                                          // İlgili değeri veya görünüm ayarını belirler
                                          PomodoroMode.longBreak.name
                                      // Koşul doğruysa bu değeri kullanır
                                      ? 'Uzun Mola'
                                      // Koşul yanlışsa bu değeri kullanır
                                      : 'Odak Seansı'),
                              // Görünüm stilini belirler
                              style: const TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 13,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Metni ekranda gösterir
                            Text(
                              // İlgili değeri veya görünüm ayarını belirler
                              dateStr,
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 11,
                                // Rengi belirler
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Görsel bir kutu oluşturur
                      Container(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(
                            // horizontal bilgisini belirler
                            horizontal: 10, vertical: 4),
                        // Kutu ve kenarlık görünümünü belirler
                        decoration: BoxDecoration(
                          // Rengi belirler
                          color: GardenPalette.gardenPaper,
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(8),
                          // Kenarlığı belirler
                          border: Border.all(
                            // Rengi belirler
                            color: GardenPalette.mossEmerald.withAlpha(50),
                          ),
                        ),
                        // İçine yerleştirilecek widgetı belirler
                        child: Text(
                          // Koşula göre iki değerden birini seçer
                          durMin > 0 ? '$durMin dk' : '$durSec sn',
                          // Görünüm stilini belirler
                          style: const TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.bold,
                            // Rengi belirler
                            color: GardenPalette.inkPlum,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

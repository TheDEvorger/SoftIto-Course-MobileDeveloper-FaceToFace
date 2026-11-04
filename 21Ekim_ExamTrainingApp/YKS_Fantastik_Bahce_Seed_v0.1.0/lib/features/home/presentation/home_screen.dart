// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// app copy dosyasını kullanıma ekler
import '../../../core/content/app_copy.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// daily görev dosyasını kullanıma ekler
import '../../../domain/models/daily_task.dart';
// student preferences dosyasını kullanıma ekler
import '../../../domain/models/student_preferences.dart';
// planning repository dosyasını kullanıma ekler
import '../../../domain/repositories/planning_repository.dart';
// preferences repository dosyasını kullanıma ekler
import '../../../domain/repositories/preferences_repository.dart';
// countdown kart dosyasını kullanıma ekler
import '../../../shared/widgets/countdown_card.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden ilerleme dosyasını kullanıma ekler
import '../../../shared/widgets/garden_progress.dart';
// preferences pencere dosyasını kullanıma ekler
import '../../../shared/widgets/preferences_dialog.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// mentors ekran dosyasını kullanıma ekler
import '../../mentors/presentation/mentors_screen.dart';
// daily plan ekran dosyasını kullanıma ekler
import '../../planning/presentation/daily_plan_screen.dart';
// görev entry pencere dosyasını kullanıma ekler
import '../../planning/presentation/task_entry_dialog.dart';
// home ekran için değişen verileri yöneten StatefulWidget kullanılır
class HomeScreen extends StatefulWidget {
  // home ekran sayfasını gösterir
  const HomeScreen({
    // odaklanmayı başlatma bilgisini zorunlu tutar
    required this.onStartFocus,
    // preferences repository bilgisini isteğe bağlı alır
    this.preferencesRepository,
    // planning repository bilgisini isteğe bağlı alır
    this.planningRepository,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // odaklanmayı başlatma bilgisini tutar
  final VoidCallback onStartFocus;
  // preferences repository bilgisini tutar
  final PreferencesRepository? preferencesRepository;
  // planning repository bilgisini tutar
  final PlanningRepository? planningRepository;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<HomeScreen> createState() => _HomeScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _HomeScreenState extends State<HomeScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  StudentPreferences? _preferences;
  // İlgili değeri veya görünüm ayarını belirler
  PreferencesRepository? _prefRepo;
  // İlgili değeri veya görünüm ayarını belirler
  PlanningRepository? _planRepo;
  // bugünkü görevler için boş koleksiyon oluşturur
  List<DailyTask> _todayTasks = [];
  // İlgili değeri veya görünüm ayarını belirler
  DailyPlanSummary _planSummary = const DailyPlanSummary(
    // toplam tasks bilgisini belirler
    totalTasks: 0,
    // completed tasks bilgisini belirler
    completedTasks: 0,
    // Hedef soru sayısını belirler
    targetQuestions: 0,
    // tamamlanan soru sayısı bilgisini belirler
    completedQuestions: 0,
  );
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // data bilgisini başlatır
    _initData();
  }
  // data bilgisini başlatır
  Future<void> _initData() async {
    // Hata oluşturabilecek işlemleri dener
    try {
      // İlgili değer null değilse kontrol eder
      if (widget.preferencesRepository != null &&
          // İlgili değeri veya görünüm ayarını belirler
          widget.planningRepository != null) {
        // pref repo değerini günceller
        _prefRepo = widget.preferencesRepository;
        // plan repo değerini günceller
        _planRepo = widget.planningRepository;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // Değer null ise varsayılanı kullanır
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
        // Değer null ise varsayılanı kullanır
        _planRepo = widget.planningRepository ?? PlanningRepository(db);
      }
      // content bilgisini yükler
      await _loadContent();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // content bilgisini yükler
  Future<void> _loadContent() async {
    // İlgili değer null ise kontrol eder
    if (_prefRepo == null || _planRepo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // tercihler verisini asenkron işlemin sonucundan alır
    final prefs = await _prefRepo!.getPreferences();
    // bugünün tarihi için güncel tarih ve saati alır
    final today = DateTime.now();
    // görevler verisini asenkron işlemin sonucundan alır
    final tasks = await _planRepo!.getTasksForDate(today);
    // summary verisini asenkron işlemin sonucundan alır
    final summary = await _planRepo!.getSummaryForDate(today);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // kullanıcı tercihleri değerini günceller
        _preferences = prefs;
        // bugünkü görevler değerini günceller
        _todayTasks = tasks;
        // plan summary değerini günceller
        _planSummary = summary;
        // yükleme durumu değerini günceller
        _loading = false;
      });
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
    }
  }
  // daily plan bilgisini açar
  Future<void> _openDailyPlan() async {
    // Yeni sayfaya geçiş yapar
    await Navigator.of(context).push(
      // material sayfa route nesnesini oluşturur
      MaterialPageRoute(
        // Gelen verilerle arayüzü oluşturur
        builder: (_) => DailyPlanScreen(
          // planning repository bilgisini belirler
          planningRepository: _planRepo,
        ),
      ),
    );
    // content bilgisini yükler
    _loadContent();
  }
  // add görev bilgisini açar
  Future<void> _openAddTask() async {
    // görev verisini asenkron işlemin sonucundan alır
    final task = await TaskEntryDialog.show(
      // İlgili değeri veya görünüm ayarını belirler
      context,
      // Başlangıç tarihini belirler
      initialDate: DateTime.now(),
    );
    // İlgili değer null değilse kontrol eder
    if (task != null && _planRepo != null) {
      // görev bilgisini kaydeder
      await _planRepo!.saveTask(task);
      // content bilgisini yükler
      await _loadContent();
    }
  }
  // görev bilgisini değiştirir
  Future<void> _toggleTask(DailyTask task) async {
    // İlgili değer null ise kontrol eder
    if (_planRepo == null) return;
    // görev done bilgisini değiştirir
    await _planRepo!.toggleTaskDone(task.id, !task.isDone);
    // content bilgisini yükler
    await _loadContent();
  }
  // mentors bilgisini açar
  void _openMentors() {
    // navigator.of nesnesini oluşturur
    Navigator.of(context).push(
      // material sayfa route nesnesini oluşturur
      MaterialPageRoute<void>(builder: (_) => const MentorsScreen()),
    );
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // ad bilgisini hesaplayıp saklar
    final name = _preferences?.displayName;
    // welcome title bilgisini iki değeri karşılaştırarak hesaplar
    final welcomeTitle = name != null && name.isNotEmpty
        // Koşul doğruysa bu değeri kullanır
        ? 'Merhaba, $name! 🌱'
        // Koşul yanlışsa bu değeri kullanır
        : 'Bugün senin günün! 🌱';
    // field bilgisini hesaplayıp saklar
    final field = _preferences?.field ?? 'Sayısal';
    // ilerleme ratio bilgisini hesaplayıp saklar
    final progressRatio = _planSummary.targetQuestions > 0
        // Koşul doğruysa bu değeri kullanır
        ? _planSummary.questionProgress
        // Koşul yanlışsa bu değeri kullanır
        : _planSummary.taskProgress;
    // Kaydırılabilir liste oluşturur
    return ListView(
      // Widget anahtarını belirler
      key: const PageStorageKey<String>('home'),
      // İç boşlukları belirler
      padding: const EdgeInsets.all(16),
      // İçerideki widgetları listeler
      children: [
        // forest hero kart kartını oluşturur
        ForestHeroCard(
          // görsel dosya yolu bilgisini belirler
          assetPath: GardenScenes.sunrise,
          // tag bilgisini belirler
          tag: '🌿 $field Alanı',
          // Başlığı belirler
          title: welcomeTitle,
          // Alt başlığı belirler
          subtitle: AppCopy.welcome,
          // action label bilgisini belirler
          actionLabel: 'Odak Odasına Gir ⏳',
          // on action olayındaki fonksiyonu belirler
          onAction: widget.onStartFocus,
          // Yüksekliği belirler
          height: 220,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // Kadim Akademi & Canlı Dersler Özel Kartı
        // Tıklanabilir alan oluşturur
        InkWell(
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(20),
          // Dokunulunca çalışacak fonksiyonu belirler
          onTap: _openMentors,
          // İçine yerleştirilecek widgetı belirler
          child: Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(14),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Renk geçişini belirler
              gradient: const LinearGradient(
                // renkler bilgisini belirler
                colors: [Color(0xFF203A43), Color(0xFF2C5364)],
              ),
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(20),
              // Gölge ayarlarını belirler
              boxShadow: [
                // Kutuya gölge ayarı ekler
                BoxShadow(
                  // Rengi belirler
                  color: Colors.black.withValues(alpha: 0.15),
                  // Gölgenin bulanıklığını belirler
                  blurRadius: 10,
                  // Gölgenin konumunu belirler
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // Görsel bir kutu oluşturur
                Container(
                  // Genişliği belirler
                  width: 52,
                  // Yüksekliği belirler
                  height: 52,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(14),
                    // görsel bilgisini belirler
                    image: const DecorationImage(
                      // görsel bilgisini belirler
                      image: AssetImage('assets/illustrations/mentors/mentor_theron.jpg'),
                      // Görselin alana nasıl sığacağını belirler
                      fit: BoxFit.cover,
                    ),
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
                      // Elemanları yan yana dizer
                      Row(
                        // İçerideki widgetları listeler
                        children: [
                          // Görsel bir kutu oluşturur
                          Container(
                            // İç boşlukları belirler
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            // Kutu ve kenarlık görünümünü belirler
                            decoration: BoxDecoration(
                              // Rengi belirler
                              color: Colors.redAccent,
                              // Köşelerin yuvarlaklığını belirler
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // İçine yerleştirilecek widgetı belirler
                            child: const Text(
                              // "CANLI DERS" metnini kullanır
                              'CANLI DERS',
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Rengi belirler
                                color: Colors.white,
                                // Yazı boyutunu belirler
                                fontSize: 9,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(width: 6),
                          // Kalan boşluğu kullanacak alan oluşturur
                          const Expanded(
                            // İçine yerleştirilecek widgetı belirler
                            child: Text(
                              // "Kadim Bilge Hocalar" metnini kullanır
                              'Kadim Bilge Hocalar',
                              // Gösterilecek en fazla satır sayısını belirler
                              maxLines: 1,
                              // Uzun yazının taşma şeklini belirler
                              overflow: TextOverflow.ellipsis,
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Rengi belirler
                                color: Colors.white,
                                // Yazı boyutunu belirler
                                fontSize: 13,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 3),
                      // Metni ekranda gösterir
                      const Text(
                        // "Theron, Sylva, Ignis ve Valerius yayında! S…" metnini kullanır
                        'Theron, Sylva, Ignis ve Valerius yayında! Soru sor ve taktik al.',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Rengi belirler
                          color: Colors.white70,
                          // Yazı boyutunu belirler
                          fontSize: 11,
                        ),
                        // Gösterilecek en fazla satır sayısını belirler
                        maxLines: 1,
                        // Uzun yazının taşma şeklini belirler
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(width: 8),
                // Simge gösterir
                const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
              ],
            ),
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // seed notice nesnesini oluşturur
        const SeedNotice(),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // YKS Countdown Header & Card
        // botanical section header nesnesini oluşturur
        BotanicalSectionHeader(
          // Başlığı belirler
          title: 'YKS Geri Sayım Sayacı',
          // Alt başlığı belirler
          subtitle: 'Kişiselleştirilmiş hedef sınav tarihi',
          // simge bilgisini belirler
          icon: Icons.hourglass_top,
          // action metin bilgisini belirler
          actionText: 'Tarihi Ayarla',
          // on action olayındaki fonksiyonu belirler
          onAction: _openPreferences,
        ),
        // Belirtilen koşul doğruysa işlemi yapar
        if (_loading)
          // garden kart kartını oluşturur
          const GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Center(
              // İçine yerleştirilecek widgetı belirler
              child: Padding(
                // İç boşlukları belirler
                padding: EdgeInsets.all(16),
                // İçine yerleştirilecek widgetı belirler
                child: CircularProgressIndicator(),
              ),
            ),
          )
        // Önceki koşul sağlanmazsa çalışır
        else
          // yks countdown kart kartını oluşturur
          YksCountdownCard(
            // hedef tarihi bilgisini belirler
            targetDate: _preferences?.targetDate,
            // on edit tarih olayındaki fonksiyonu belirler
            onEditDate: _openPreferences,
          ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 14),
        // Today's Goals Section
        // botanical section header nesnesini oluşturur
        BotanicalSectionHeader(
          // Başlığı belirler
          title: 'Günün Hedefleri',
          // Alt başlığı belirler
          subtitle: '${_todayTasks.length} adet planlanan görev',
          // simge bilgisini belirler
          icon: Icons.check_circle_outline,
          // action metin bilgisini belirler
          actionText: 'Tüm Planı Gör',
          // on action olayındaki fonksiyonu belirler
          onAction: _openDailyPlan,
        ),
        // garden kart kartını oluşturur
        GardenCard(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçerideki widgetları listeler
            children: [
              // Elemanları yan yana dizer
              Row(
                // Ana eksendeki hizalamayı belirler
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // İçerideki widgetları listeler
                children: [
                  // Kalan boşluğu kullanacak alan oluşturur
                  const Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // "Bugünkü Hedef İlerlemesi" metnini kullanır
                      'Bugünkü Hedef İlerlemesi',
                      // Uzun yazının taşma şeklini belirler
                      overflow: TextOverflow.ellipsis,
                      // Görünüm stilini belirler
                      style:
                          // Yazının görünümünü ayarlar
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Metni ekranda gösterir
                  Text(
                    // İlgili değeri veya görünüm ayarını belirler
                    _planSummary.targetQuestions > 0
                        // Koşul doğruysa bu değeri kullanır
                        ? '${_planSummary.completedQuestions} / ${_planSummary.targetQuestions} Soru'
                        // Koşul yanlışsa bu değeri kullanır
                        : '${_planSummary.completedTasks} / ${_planSummary.totalTasks} Görev',
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 12,
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.bold,
                      // Rengi belirler
                      color: GardenPalette.mossEmerald,
                    ),
                  ),
                ],
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 10),
              // leaf ilerleme bar nesnesini oluşturur
              LeafProgressBar(
                // ilerleme bilgisini belirler
                progress: progressRatio,
                // Buton veya alan yazısını belirler
                label: 'Günün Tamamlanma Oranı',
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 12),
              // Liste veya metin boşsa bu koşul çalışır
              if (_todayTasks.isEmpty) ...[
                // Elemanları yan yana dizer
                Row(
                  // İçerideki widgetları listeler
                  children: [
                    // Kalan boşluğu kullanacak alan oluşturur
                    const Expanded(
                      // İçine yerleştirilecek widgetı belirler
                      child: Text(
                        // "Bugün için henüz görev eklemedin. Birkaç kü…" metnini kullanır
                        'Bugün için henüz görev eklemedin. Birkaç küçük hedef koyarak başla.',
                        // Görünüm stilini belirler
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(width: 8),
                    // Çerçeveli simgeli buton oluşturur
                    OutlinedButton.icon(
                      // Görünüm stilini belirler
                      style: OutlinedButton.styleFrom(
                        // Widgetın kenar şeklini belirler
                        shape: RoundedRectangleBorder(
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _openAddTask,
                      // simge bilgisini belirler
                      icon: const Icon(Icons.add, size: 16),
                      // Buton veya alan yazısını belirler
                      label: const Text('Hedef Ekle'),
                    ),
                  ],
                ),
              // İlgili değeri veya görünüm ayarını belirler
              ] else ...[
                // Öğeleri tek tek dönüştürür
                ..._todayTasks.take(3).map((task) {
                  // İç boşluk ekler
                  return Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    // İçine yerleştirilecek widgetı belirler
                    child: Row(
                      // İçerideki widgetları listeler
                      children: [
                        // İşaretleme kutusu oluşturur
                        Checkbox(
                          // Kullanılacak değeri belirler
                          value: task.isDone,
                          // Etkin durum rengini belirler
                          activeColor: GardenPalette.mossEmerald,
                          // Widgetın kenar şeklini belirler
                          shape: RoundedRectangleBorder(
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(4),
                          ),
                          // Değer değişince çalışacak fonksiyonu belirler
                          onChanged: (_) => _toggleTask(task),
                        ),
                        // Kalan boşluğu kullanacak alan oluşturur
                        Expanded(
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            task.description,
                            // Görünüm stilini belirler
                            style: TextStyle(
                              // Yazı boyutunu belirler
                              fontSize: 13,
                              // Kutu ve kenarlık görünümünü belirler
                              decoration: task.isDone
                                  // Koşul doğruysa bu değeri kullanır
                                  ? TextDecoration.lineThrough
                                  // Koşul yanlışsa bu değeri kullanır
                                  : null,
                              // Rengi belirler
                              color: task.isDone ? Colors.grey : null,
                            ),
                          ),
                        ),
                        // Belirtilen koşul doğruysa işlemi yapar
                        if (task.targetQuestions > 0)
                          // Görsel bir kutu oluşturur
                          Container(
                            // İç boşlukları belirler
                            padding: const EdgeInsets.symmetric(
                                // horizontal bilgisini belirler
                                horizontal: 6, vertical: 2),
                            // Kutu ve kenarlık görünümünü belirler
                            decoration: BoxDecoration(
                              // Rengi belirler
                              color: GardenPalette.gardenPaper,
                              // Köşelerin yuvarlaklığını belirler
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // İçine yerleştirilecek widgetı belirler
                            child: Text(
                              // "${task.targetQuestions} S" metnini kullanır
                              '${task.targetQuestions} S',
                              // Görünüm stilini belirler
                              style: const TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 11,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                                // Rengi belirler
                                color: GardenPalette.mossEmerald,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 8),
                // Elemanları yan yana dizer
                Row(
                  // Ana eksendeki hizalamayı belirler
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // İçerideki widgetları listeler
                  children: [
                    // Simge ve metin içeren buton oluşturur
                    TextButton.icon(
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _openAddTask,
                      // simge bilgisini belirler
                      icon: const Icon(Icons.add, size: 16),
                      // Buton veya alan yazısını belirler
                      label: const Text('Yeni Hedef Ekle'),
                    ),
                    // Metin butonu oluşturur
                    TextButton(
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _openDailyPlan,
                      // İçine yerleştirilecek widgetı belirler
                      child: const Text('Tümünü Yönet →'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 14),
        // Achievement Target Card
        // golden achievement kart kartını oluşturur
        GoldenAchievementCard(
          // Başlığı belirler
          title:
              // "Hedef Net: ${_preferences?.targetNet?.toStr…" metnini kullanır
              'Hedef Net: ${_preferences?.targetNet?.toStringAsFixed(1) ?? 'Belirlenmedi'}',
          // Alt başlığı belirler
          subtitle:
              // "İlk denemeni kaydettiğinde ve konu bitirdiğ…" metnini kullanır
              'İlk denemeni kaydettiğinde ve konu bitirdiğinde burada parlayacak.',
          // badge metin bilgisini belirler
          badgeText: field,
          // ilerleme metin bilgisini belirler
          progressText: _preferences?.targetDate != null
              // Koşul doğruysa bu değeri kullanır
              ? 'Hedef takvimi devrede'
              // Koşul yanlışsa bu değeri kullanır
              : 'Tarih ve net hedefini belirle',
          // Dokunulunca çalışacak fonksiyonu belirler
          onTap: _openPreferences,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 20),
        // garden primary button nesnesini oluşturur
        GardenPrimaryButton(
          // Buton veya alan yazısını belirler
          label: 'Odak Odasını Başlat (Pomodoro)',
          // simge bilgisini belirler
          icon: Icons.timer_outlined,
          // Basılınca çalışacak fonksiyonu belirler
          onPressed: widget.onStartFocus,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 32),
      ],
    );
  }
}

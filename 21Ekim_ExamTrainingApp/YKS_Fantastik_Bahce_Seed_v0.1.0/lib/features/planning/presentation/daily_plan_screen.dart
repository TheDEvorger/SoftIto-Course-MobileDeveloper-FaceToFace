// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// daily görev dosyasını kullanıma ekler
import '../../../domain/models/daily_task.dart';
// curriculum repository dosyasını kullanıma ekler
import '../../../domain/repositories/curriculum_repository.dart';
// planning repository dosyasını kullanıma ekler
import '../../../domain/repositories/planning_repository.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden ilerleme dosyasını kullanıma ekler
import '../../../shared/widgets/garden_progress.dart';
// görev entry pencere dosyasını kullanıma ekler
import 'task_entry_dialog.dart';
// daily plan ekran için değişen verileri yöneten StatefulWidget kullanılır
class DailyPlanScreen extends StatefulWidget {
  // daily plan ekran sayfasını gösterir
  const DailyPlanScreen({
    // planning repository bilgisini isteğe bağlı alır
    this.planningRepository,
    // curriculum repository bilgisini isteğe bağlı alır
    this.curriculumRepository,
    // başlangıç tarihi bilgisini isteğe bağlı alır
    this.initialDate,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // planning repository bilgisini tutar
  final PlanningRepository? planningRepository;
  // curriculum repository bilgisini tutar
  final CurriculumRepository? curriculumRepository;
  // başlangıç tarihi bilgisini tutar
  final DateTime? initialDate;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _DailyPlanScreenState extends State<DailyPlanScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  PlanningRepository? _planRepo;
  // İlgili değeri veya görünüm ayarını belirler
  CurriculumRepository? _currRepo;
  // güncel tarih bilgisini tutar
  late DateTime _currentDate;
  // görevler için boş koleksiyon oluşturur
  List<DailyTask> _tasks = [];
  // İlgili değeri veya görünüm ayarını belirler
  DailyPlanSummary _summary = const DailyPlanSummary(
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
    // Güncel tarih ve saati alır
    _currentDate = widget.initialDate ?? DateTime.now();
    // repos bilgisini başlatır
    _initRepos();
  }
  // repos bilgisini başlatır
  Future<void> _initRepos() async {
    // Hata oluşturabilecek işlemleri dener
    try {
      // İlgili değer null değilse kontrol eder
      if (widget.planningRepository != null) {
        // plan repo değerini günceller
        _planRepo = widget.planningRepository;
        // curr repo değerini günceller
        _currRepo = widget.curriculumRepository;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // planning repository işlemini yapar
        _planRepo = PlanningRepository(db);
        // curriculum repository işlemini yapar
        _currRepo = CurriculumRepository(db);
      }
      // tasks bilgisini yükler
      await _loadTasks();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // tasks bilgisini yükler
  Future<void> _loadTasks() async {
    // İlgili değer null ise kontrol eder
    if (_planRepo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // görevler verisini asenkron işlemin sonucundan alır
    final tasks = await _planRepo!.getTasksForDate(_currentDate);
    // summary verisini asenkron işlemin sonucundan alır
    final summary = await _planRepo!.getSummaryForDate(_currentDate);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // görevler değerini günceller
        _tasks = tasks;
        // summary değerini günceller
        _summary = summary;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // change tarih işlemini yapar
  void _changeDate(int dayOffset) {
    // Değişen verileri arayüze bildirir
    setState(() {
      // add işlemini yapar
      _currentDate = _currentDate.add(Duration(days: dayOffset));
    });
    // tasks bilgisini yükler
    _loadTasks();
  }
  // pick tarih işlemini yapar
  Future<void> _pickDate() async {
    // picked verisini asenkron işlemin sonucundan alır
    final picked = await showDatePicker(
      // context bilgisini belirler
      context: context,
      // Başlangıç tarihini belirler
      initialDate: _currentDate,
      // Seçilebilecek ilk tarihi belirler
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      // Seçilebilecek son tarihi belirler
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    // Widget artık açık değilse işlemi durdurur
    if (picked != null && mounted) {
      // Değişen verileri arayüze bildirir
      setState(() => _currentDate = picked);
      // tasks bilgisini yükler
      _loadTasks();
    }
  }
  // add görev bilgisini açar
  Future<void> _openAddTask() async {
    // görev verisini asenkron işlemin sonucundan alır
    final task = await TaskEntryDialog.show(
      // İlgili değeri veya görünüm ayarını belirler
      context,
      // Başlangıç tarihini belirler
      initialDate: _currentDate,
      // curriculum repository bilgisini belirler
      curriculumRepository: _currRepo,
    );
    // İlgili değer null değilse kontrol eder
    if (task != null && _planRepo != null) {
      // görev bilgisini kaydeder
      await _planRepo!.saveTask(task);
      // tasks bilgisini yükler
      await _loadTasks();
    }
  }
  // edit görev bilgisini açar
  Future<void> _openEditTask(DailyTask task) async {
    // updated verisini asenkron işlemin sonucundan alır
    final updated = await TaskEntryDialog.show(
      // İlgili değeri veya görünüm ayarını belirler
      context,
      // existing görev bilgisini belirler
      existingTask: task,
      // Başlangıç tarihini belirler
      initialDate: task.scheduledDate,
      // curriculum repository bilgisini belirler
      curriculumRepository: _currRepo,
    );
    // İlgili değer null değilse kontrol eder
    if (updated != null && _planRepo != null) {
      // görev bilgisini kaydeder
      await _planRepo!.saveTask(updated);
      // tasks bilgisini yükler
      await _loadTasks();
    }
  }
  // görev bilgisini değiştirir
  Future<void> _toggleTask(DailyTask task) async {
    // İlgili değer null ise kontrol eder
    if (_planRepo == null) return;
    // görev done bilgisini değiştirir
    await _planRepo!.toggleTaskDone(task.id, !task.isDone);
    // tasks bilgisini yükler
    await _loadTasks();
  }
  // görev bilgisini siler
  Future<void> _deleteTask(DailyTask task) async {
    // İlgili değer null ise kontrol eder
    if (_planRepo == null) return;
    // görev bilgisini siler
    await _planRepo!.deleteTask(task.id);
    // tasks bilgisini yükler
    await _loadTasks();
  }
  // today bilgisini kontrol eder
  bool get _isToday {
    // şimdiki zaman için güncel tarih ve saati alır
    final now = DateTime.now();
    // Birden fazla koşulu birlikte kontrol eder
    return _currentDate.year == now.year &&
        // Birden fazla koşulu birlikte kontrol eder
        _currentDate.month == now.month &&
        // güncel tarih.day değerini günceller
        _currentDate.day == now.day;
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // tarih title bilgisini hesaplayıp saklar
    final dateTitle = _isToday
        // Koşul doğruysa bu değeri kullanır
        ? 'Bugün, ${_formatDate(_currentDate)}'
        // Koşul yanlışsa bu değeri kullanır
        : _formatDate(_currentDate);
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: const Text('Günlük Çalışma Planı'),
        // center title bilgisini belirler
        centerTitle: false,
        // actions bilgisini belirler
        actions: [
          // Simgeli buton oluşturur
          IconButton(
            // tooltip bilgisini belirler
            tooltip: 'Yeni Görev Ekle',
            // simge bilgisini belirler
            icon: const Icon(Icons.add),
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: _openAddTask,
          ),
        ],
      ),
      // Yüzen işlem butonunu belirler
      floatingActionButton: FloatingActionButton.extended(
        // Arka plan rengini belirler
        backgroundColor: GardenPalette.mossEmerald,
        // Yazı ve simge rengini belirler
        foregroundColor: Colors.white,
        // Basılınca çalışacak fonksiyonu belirler
        onPressed: _openAddTask,
        // simge bilgisini belirler
        icon: const Icon(Icons.add),
        // Buton veya alan yazısını belirler
        label: const Text('Görev Ekle'),
      ),
      // Sayfanın ana içeriğini belirler
      body: _loading
          // Koşul doğruysa bu değeri kullanır
          ? const Center(
              // İçine yerleştirilecek widgetı belirler
              child:
                  // Dairesel ilerleme göstergesi oluşturur
                  CircularProgressIndicator(color: GardenPalette.mossEmerald),
            )
          // Koşul yanlışsa bu değeri kullanır
          : RefreshIndicator(
              // Rengi belirler
              color: GardenPalette.mossEmerald,
              // on refresh olayındaki fonksiyonu belirler
              onRefresh: _loadTasks,
              // İçine yerleştirilecek widgetı belirler
              child: ListView(
                // İç boşlukları belirler
                padding: const EdgeInsets.all(16),
                // İçerideki widgetları listeler
                children: [
                  // forest hero kart kartını oluşturur
                  const ForestHeroCard(
                    // görsel dosya yolu bilgisini belirler
                    assetPath: GardenScenes.clearing,
                    // tag bilgisini belirler
                    tag: '🌱 Günlük Hedefler',
                    // Başlığı belirler
                    title: 'Her Gün Bir Adım',
                    // Alt başlığı belirler
                    subtitle:
                        // "Büyük başarılar, her gün atılan sabırlı adı…" metnini kullanır
                        'Büyük başarılar, her gün atılan sabırlı adımların toplamıdır.',
                    // Yüksekliği belirler
                    height: 190,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 14),
                  // Date Navigator Bar
                  // tarih navigator bilgisini oluşturur
                  _buildDateNavigator(dateTitle),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 14),
                  // Progress Summary Card
                  // summary kart bilgisini oluşturur
                  _buildSummaryCard(),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 16),
                  // Tasks Section Header
                  // botanical section header nesnesini oluşturur
                  BotanicalSectionHeader(
                    // Başlığı belirler
                    title: 'Planlanan Görevler',
                    // Alt başlığı belirler
                    subtitle: '${_tasks.length} adet görev listelendi',
                    // simge bilgisini belirler
                    icon: Icons.checklist,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 10),
                  // Task list or empty state
                  // Liste veya metin boşsa bu koşul çalışır
                  if (_tasks.isEmpty)
                    // empty durum bilgisini oluşturur
                    _buildEmptyState()
                  // Önceki koşul sağlanmazsa çalışır
                  else
                    // Öğeleri tek tek dönüştürür
                    ..._tasks.map(_buildTaskItem),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 70), // padding for FAB
                ],
              ),
            ),
    );
  }
  // tarih navigator bilgisini oluşturur
  Widget _buildDateNavigator(String dateTitle) {
    // Görsel bir kutu oluşturur
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: Theme.of(context).cardColor,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(16),
        // Kenarlığı belirler
        border: Border.all(color: GardenPalette.mossEmerald.withAlpha(40)),
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // Ana eksendeki hizalamayı belirler
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // İçerideki widgetları listeler
        children: [
          // Simgeli buton oluşturur
          IconButton(
            // simge bilgisini belirler
            icon: const Icon(Icons.chevron_left),
            // tooltip bilgisini belirler
            tooltip: 'Önceki Gün',
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => _changeDate(-1),
          ),
          // Tıklanabilir alan oluşturur
          InkWell(
            // Dokunulunca çalışacak fonksiyonu belirler
            onTap: _pickDate,
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(10),
            // İçine yerleştirilecek widgetı belirler
            child: Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  const Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.calendar_month,
                    // Boyutu belirler
                    size: 18,
                    // Rengi belirler
                    color: GardenPalette.mossEmerald,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Metni ekranda gösterir
                  Text(
                    // İlgili değeri veya görünüm ayarını belirler
                    dateTitle,
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.bold,
                      // Yazı boyutunu belirler
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Simgeli buton oluşturur
          IconButton(
            // simge bilgisini belirler
            icon: const Icon(Icons.chevron_right),
            // tooltip bilgisini belirler
            tooltip: 'Sonraki Gün',
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }
  // summary kart bilgisini oluşturur
  Widget _buildSummaryCard() {
    // pct bilgisini hesaplayıp saklar
    final pct = (_summary.taskProgress * 100).toInt();
    // garden kart kartını oluşturur
    return GardenCard(
      // İçine yerleştirilecek widgetı belirler
      child: Column(
        // İçerideki widgetları listeler
        children: [
          // Elemanları yan yana dizer
          Row(
            // İçerideki widgetları listeler
            children: [
              // organic ilerleme ring nesnesini oluşturur
              OrganicProgressRing(
                // ilerleme bilgisini belirler
                progress: _summary.taskProgress,
                // Boyutu belirler
                size: 78,
                // Çizgi kalınlığını belirler
                strokeWidth: 8,
                // center metin bilgisini belirler
                centerText: '%$pct',
                // sub metin bilgisini belirler
                subText: 'Tamamlandı',
                // Etkin durum rengini belirler
                activeColor: GardenPalette.mossEmerald,
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 16),
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
                      // "${_summary.completedTasks} / ${_summary.tot…" metnini kullanır
                      '${_summary.completedTasks} / ${_summary.totalTasks} Görev Bitti',
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 15,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(height: 4),
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      _summary.targetQuestions > 0
                          // Koşul doğruysa bu değeri kullanır
                          ? '${_summary.completedQuestions} / ${_summary.targetQuestions} Soru Hedefi'
                          // Koşul yanlışsa bu değeri kullanır
                          : 'Soru hedefi belirlenmedi',
                      // Görünüm stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Rengi belirler
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(height: 8),
                    // leaf ilerleme bar nesnesini oluşturur
                    LeafProgressBar(
                      // ilerleme bilgisini belirler
                      progress: _summary.questionProgress > 0
                          // Koşul doğruysa bu değeri kullanır
                          ? _summary.questionProgress
                          // Koşul yanlışsa bu değeri kullanır
                          : _summary.taskProgress,
                      // Buton veya alan yazısını belirler
                      label: 'Günün Tamamlanma Oranı',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // empty durum bilgisini oluşturur
  Widget _buildEmptyState() {
    // garden kart kartını oluşturur
    return GardenCard(
      // İç boşlukları belirler
      padding: const EdgeInsets.all(24),
      // İçine yerleştirilecek widgetı belirler
      child: Column(
        // İçerideki widgetları listeler
        children: [
          // Simge gösterir
          Icon(
            // Gösterilecek simgeyi belirler
            Icons.spa_outlined,
            // Boyutu belirler
            size: 40,
            // Rengi belirler
            color: GardenPalette.mossEmerald.withAlpha(120),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 10),
          // Metni ekranda gösterir
          const Text(
            // "Bu Gün İçin Görev Yok" metnini kullanır
            'Bu Gün İçin Görev Yok',
            // Görünüm stilini belirler
            style: TextStyle(
              // Yazı kalınlığını belirler
              fontWeight: FontWeight.bold,
              // Yazı boyutunu belirler
              fontSize: 15,
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 4),
          // Metni ekranda gösterir
          Text(
            // "Aşağıdaki "Görev Ekle" butonuna basarak gün…" metnini kullanır
            'Aşağıdaki "Görev Ekle" butonuna basarak gününü planlamaya başla.',
            // Yazıyı hizalar
            textAlign: TextAlign.center,
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
    );
  }
  // görev item bilgisini oluşturur
  Widget _buildTaskItem(DailyTask task) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // İç boşluk ekler
    return Padding(
      // İç boşlukları belirler
      padding: const EdgeInsets.only(bottom: 8),
      // İçine yerleştirilecek widgetı belirler
      child: GardenCard(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        // İçine yerleştirilecek widgetı belirler
        child: Row(
          // İçerideki widgetları listeler
          children: [
            // Checkbox
            // İşaretleme kutusu oluşturur
            Checkbox(
              // Kullanılacak değeri belirler
              value: task.isDone,
              // Etkin durum rengini belirler
              activeColor: GardenPalette.mossEmerald,
              // Widgetın kenar şeklini belirler
              shape: RoundedRectangleBorder(
                // Köşelerin yuvarlaklığını belirler
                borderRadius: BorderRadius.circular(6),
              ),
              // Değer değişince çalışacak fonksiyonu belirler
              onChanged: (_) => _toggleTask(task),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(width: 8),
            // Details
            // Kalan boşluğu kullanacak alan oluşturur
            Expanded(
              // İçine yerleştirilecek widgetı belirler
              child: GestureDetector(
                // Dokunulunca çalışacak fonksiyonu belirler
                onTap: () => _toggleTask(task),
                // İçine yerleştirilecek widgetı belirler
                child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçerideki widgetları listeler
                  children: [
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      task.description,
                      // Görünüm stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 14,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w600,
                        // Kutu ve kenarlık görünümünü belirler
                        decoration:
                            // Koşula göre iki değerden birini seçer
                            task.isDone ? TextDecoration.lineThrough : null,
                        // Rengi belirler
                        color: task.isDone
                            // Koşul doğruysa bu değeri kullanır
                            ? Colors.grey
                            // Koşul yanlışsa bu değeri kullanır
                            : (isDark
                                // Koşul doğruysa bu değeri kullanır
                                ? const Color(0xFFF8F2E8)
                                // Koşul yanlışsa bu değeri kullanır
                                : GardenPalette.inkPlum),
                      ),
                    ),
                    // Belirtilen koşul doğruysa işlemi yapar
                    if (task.targetQuestions > 0)
                      // Metni ekranda gösterir
                      Text(
                        // "${task.targetQuestions} Soru Hedefi" metnini kullanır
                        '${task.targetQuestions} Soru Hedefi',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 11,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: task.isDone
                              // Koşul doğruysa bu değeri kullanır
                              ? Colors.grey
                              // Koşul yanlışsa bu değeri kullanır
                              : GardenPalette.mossEmerald,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Edit & Delete actions
            // Simgeli buton oluşturur
            IconButton(
              // simge bilgisini belirler
              icon: const Icon(Icons.edit_outlined, size: 18),
              // tooltip bilgisini belirler
              tooltip: 'Düzenle',
              // Basılınca çalışacak fonksiyonu belirler
              onPressed: () => _openEditTask(task),
            ),
            // Simgeli buton oluşturur
            IconButton(
              // simge bilgisini belirler
              icon: const Icon(Icons.delete_outline, size: 18),
              // Rengi belirler
              color: Colors.redAccent,
              // tooltip bilgisini belirler
              tooltip: 'Sil',
              // Basılınca çalışacak fonksiyonu belirler
              onPressed: () => _deleteTask(task),
            ),
          ],
        ),
      ),
    );
  }
  // tarih bilgisini biçimlendirir
  String _formatDate(DateTime dt) {
    // "${dt.day.toString().padLeft(2, '0')}.${dt.m…" metnini kullanır
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}

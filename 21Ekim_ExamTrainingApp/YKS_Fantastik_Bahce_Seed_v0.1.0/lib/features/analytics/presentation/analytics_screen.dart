// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// deneme record dosyasını kullanıma ekler
import '../../../domain/models/exam_record.dart';
// student preferences dosyasını kullanıma ekler
import '../../../domain/models/student_preferences.dart';
// deneme repository dosyasını kullanıma ekler
import '../../../domain/repositories/exam_repository.dart';
// preferences repository dosyasını kullanıma ekler
import '../../../domain/repositories/preferences_repository.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden inputs dosyasını kullanıma ekler
import '../../../shared/widgets/garden_inputs.dart';
// garden ilerleme dosyasını kullanıma ekler
import '../../../shared/widgets/garden_progress.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// analytics models dosyasını kullanıma ekler
import '../domain/analytics_models.dart';
// score simulator ekran dosyasını kullanıma ekler
import 'score_simulator_screen.dart';
// garden line chart dosyasını kullanıma ekler
import 'widgets/garden_line_chart.dart';
// analytics ekran için değişen verileri yöneten StatefulWidget kullanılır
class AnalyticsScreen extends StatefulWidget {
  // analytics ekran sayfasını gösterir
  const AnalyticsScreen({
    // deneme repository bilgisini isteğe bağlı alır
    this.examRepository,
    // preferences repository bilgisini isteğe bağlı alır
    this.preferencesRepository,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // deneme repository bilgisini tutar
  final ExamRepository? examRepository;
  // preferences repository bilgisini tutar
  final PreferencesRepository? preferencesRepository;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  ExamRepository? _examRepo;
  // İlgili değeri veya görünüm ayarını belirler
  PreferencesRepository? _prefRepo;
  // aşama için metin değeri belirler
  String _stage = 'TYT';
  // Hesaplamada kullanılacak sayısal değeri belirler
  String? _selectedSubjectId; // null = Genel Toplam
  // exams için boş koleksiyon oluşturur
  List<ExamSession> _exams = [];
  // İlgili değeri veya görünüm ayarını belirler
  StudentPreferences? _preferences;
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
      if (widget.examRepository != null &&
          // İlgili değeri veya görünüm ayarını belirler
          widget.preferencesRepository != null) {
        // deneme repo değerini günceller
        _examRepo = widget.examRepository;
        // pref repo değerini günceller
        _prefRepo = widget.preferencesRepository;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // Değer null ise varsayılanı kullanır
        _examRepo = widget.examRepository ?? ExamRepository(db);
        // Değer null ise varsayılanı kullanır
        _prefRepo = widget.preferencesRepository ?? PreferencesRepository(db);
      }
      // data bilgisini yükler
      await _loadData();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // data bilgisini yükler
  Future<void> _loadData() async {
    // İlgili değer null ise kontrol eder
    if (_examRepo == null || _prefRepo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // exams verisini asenkron işlemin sonucundan alır
    final exams = await _examRepo!.getExams(stage: _stage);
    // tercihler verisini asenkron işlemin sonucundan alır
    final prefs = await _prefRepo!.getPreferences();
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // exams değerini günceller
        _exams = exams;
        // kullanıcı tercihleri değerini günceller
        _preferences = prefs;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // stage changed bilgisini işler
  void _onStageChanged(String newStage) {
    // Belirtilen koşul doğruysa işlemi yapar
    if (_stage == newStage) return;
    // Değişen verileri arayüze bildirir
    setState(() {
      // aşama değerini günceller
      _stage = newStage;
      // seçilen ders id değerini günceller
      _selectedSubjectId = null; // Reset subject filter on stage switch
    });
    // data bilgisini yükler
    _loadData();
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
    // chart points bilgisini hesaplayıp saklar
    final chartPoints = AnalyticsCalculator.extractPoints(
      // exams bilgisini belirler
      exams: _exams,
      // Ders ID bilgisini belirler
      subjectId: _selectedSubjectId,
    );
    // trend bilgisini hesaplayıp saklar
    final trend = AnalyticsCalculator.calculateTrend(chartPoints);
    // ders stats bilgisini hesaplayıp saklar
    final subjectStats = AnalyticsCalculator.extractSubjectStats(_exams);
    // hedef net bilgisini hesaplayıp saklar
    final targetNet = _preferences?.targetNet ?? 90.0;
    // Aşağı çekerek yenilemeyi sağlar
    return RefreshIndicator(
      // Rengi belirler
      color: GardenPalette.mossEmerald,
      // on refresh olayındaki fonksiyonu belirler
      onRefresh: _loadData,
      // İçine yerleştirilecek widgetı belirler
      child: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.all(16),
        // İçerideki widgetları listeler
        children: [
          // forest hero kart kartını oluşturur
          ForestHeroCard(
            // görsel dosya yolu bilgisini belirler
            assetPath: GardenScenes.valley,
            // tag bilgisini belirler
            tag: '📊 Net ve Başarı Analizi',
            // Başlığı belirler
            title: 'Gelişiminin Yolculuğu',
            // Alt başlığı belirler
            subtitle: 'Grafiklerin, gerçek denemelerin geldikçe çiçek açacak.',
            // Yüksekliği belirler
            height: 200,
            // action label bilgisini belirler
            actionLabel: 'Puan Simülatörü 🎯',
            // on action olayındaki fonksiyonu belirler
            onAction: () {
              // navigator.of nesnesini oluşturur
              Navigator.of(context).push(
                // material sayfa route nesnesini oluşturur
                MaterialPageRoute<void>(
                  // Gelen verilerle arayüzü oluşturur
                  builder: (_) =>
                      // score simulator ekran sayfasını gösterir
                      ScoreSimulatorScreen(examRepository: _examRepo),
                ),
              );
            },
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // seed notice nesnesini oluşturur
          const SeedNotice(),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // Stage Selector (TYT / AYT)
          // nature segmented control nesnesini oluşturur
          NatureSegmentedControl<String>(
            // Listelenecek öğeleri belirler
            items: const {
              // "TYT': 'TYT Net Analizi" metnini kullanır
              'TYT': 'TYT Net Analizi',
              // "AYT': 'AYT Net Analizi" metnini kullanır
              'AYT': 'AYT Net Analizi',
            },
            // seçili olma durumu bilgisini belirler
            selected: _stage,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: _onStageChanged,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Subject filter chips
          // ders filter bar bilgisini oluşturur
          _buildSubjectFilterBar(subjectStats),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 14),
          // Trend and Target Summary Card
          // summary kart bilgisini oluşturur
          _buildSummaryCard(trend, targetNet),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // Line Chart Header
          // botanical section header nesnesini oluşturur
          BotanicalSectionHeader(
            // Başlığı belirler
            title: _selectedSubjectId == null
                // Koşul doğruysa bu değeri kullanır
                ? '$_stage Toplam Net Eğrisi'
                // Koşul yanlışsa bu değeri kullanır
                : '${_getSubjectTitle(subjectStats)} Net Eğrisi',
            // Alt başlığı belirler
            subtitle: '${chartPoints.length} deneme kaydı baz alınmıştır',
            // simge bilgisini belirler
            icon: Icons.show_chart,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 10),
          // Garden Line Chart
          // garden line chart nesnesini oluşturur
          GardenLineChart(
            // noktalar bilgisini belirler
            points: chartPoints,
            // Yüksekliği belirler
            height: 220,
            // çizgi rengi bilgisini belirler
            lineColor: _selectedSubjectId == null
                // Koşul doğruysa bu değeri kullanır
                ? GardenPalette.mossEmerald
                // Koşul yanlışsa bu değeri kullanır
                : GardenPalette.peachCoral,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 20),
          // Subject Breakdown Section
          // Liste veya metin doluysa bu koşul çalışır
          if (_exams.isNotEmpty && subjectStats.isNotEmpty) ...[
            // botanical section header nesnesini oluşturur
            const BotanicalSectionHeader(
              // Başlığı belirler
              title: 'Ders Bazında Başarı Dağılımı',
              // Alt başlığı belirler
              subtitle: 'Son netler ve ders ortalamaları',
              // simge bilgisini belirler
              icon: Icons.pie_chart_outline,
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 10),
            // ders breakdown bilgisini oluşturur
            _buildSubjectBreakdown(subjectStats),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
          ],
          // Truth in measurement note
          // water info kart kartını oluşturur
          const WaterInfoCard(
            // Başlığı belirler
            title: 'Gerçekçi Ölçüm İlkesi',
            // mesaj bilgisini belirler
            message:
                // "Fantastik Bahçe’de uydurma veri ve sahte tr…" metnini kullanır
                'Fantastik Bahçe’de uydurma veri ve sahte trend çizgisi bulunmaz. Trend eğrisi ve artış oranları yalnızca kaydettiğin gerçek denemelerle şekillenir.',
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  // ders filter bar bilgisini oluşturur
  Widget _buildSubjectFilterBar(List<SubjectNetStat> subjectStats) {
    // Sayfayı kaydırılabilir yapar
    return SingleChildScrollView(
      // Kaydırma yönünü belirler
      scrollDirection: Axis.horizontal,
      // İçine yerleştirilecek widgetı belirler
      child: Row(
        // İçerideki widgetları listeler
        children: [
          // nature filter chip nesnesini oluşturur
          NatureFilterChip(
            // Buton veya alan yazısını belirler
            label: 'Genel Net',
            // seçili olma durumu bilgisini belirler
            selected: _selectedSubjectId == null,
            // Seçim değişince çalışacak fonksiyonu belirler
            onSelected: (_) {
              // Değişen verileri arayüze bildirir
              setState(() => _selectedSubjectId = null);
            },
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(width: 8),
          // Öğeleri tek tek dönüştürür
          ...subjectStats.map((stat) {
            // is seçilen bilgisini iki değeri karşılaştırarak hesaplar
            final isSelected = _selectedSubjectId == stat.subjectId;
            // İç boşluk ekler
            return Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.only(right: 8),
              // İçine yerleştirilecek widgetı belirler
              child: NatureFilterChip(
                // Buton veya alan yazısını belirler
                label: stat.subjectName,
                // seçili olma durumu bilgisini belirler
                selected: isSelected,
                // Seçim değişince çalışacak fonksiyonu belirler
                onSelected: (_) {
                  // Değişen verileri arayüze bildirir
                  setState(() => _selectedSubjectId = stat.subjectId);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
  // summary kart bilgisini oluşturur
  Widget _buildSummaryCard(TrendSummary trend, double targetNet) {
    // has data bilgisini hesaplayıp saklar
    final hasData = trend.totalExams > 0;
    // ilerleme to hedef bilgisini hesaplayıp saklar
    final progressToTarget = hasData && targetNet > 0
        // Koşul doğruysa bu değeri kullanır
        ? (trend.averageNet / targetNet).clamp(0.0, 1.0)
        // Koşul yanlışsa bu değeri kullanır
        : 0.0;
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
                progress: progressToTarget,
                // Boyutu belirler
                size: 78,
                // Çizgi kalınlığını belirler
                strokeWidth: 8,
                // center metin bilgisini belirler
                centerText:
                    // Koşula göre iki değerden birini seçer
                    hasData ? trend.averageNet.toStringAsFixed(1) : '0.0',
                // sub metin bilgisini belirler
                subText: 'Ort. Net',
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
                    // Elemanları yan yana dizer
                    Row(
                      // Ana eksendeki hizalamayı belirler
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // İçerideki widgetları listeler
                      children: [
                        // Kalan boşluğu kullanacak alan oluşturur
                        Expanded(
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // "$_stage Hedefi" metnini kullanır
                            '$_stage Hedefi',
                            // Uzun yazının taşma şeklini belirler
                            overflow: TextOverflow.ellipsis,
                            // Görünüm stilini belirler
                            style: const TextStyle(
                              // Yazı boyutunu belirler
                              fontSize: 13,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.w600,
                              // Rengi belirler
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(width: 6),
                        // Görsel bir kutu oluşturur
                        Container(
                          // İç boşlukları belirler
                          padding: const EdgeInsets.symmetric(
                            // horizontal bilgisini belirler
                            horizontal: 8,
                            // vertical bilgisini belirler
                            vertical: 3,
                          ),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: GardenPalette.harvestGold.withAlpha(40),
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(6),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // "Hedef: ${targetNet.toStringAsFixed(0)} Net" metnini kullanır
                            'Hedef: ${targetNet.toStringAsFixed(0)} Net',
                            // Görünüm stilini belirler
                            style: const TextStyle(
                              // Yazı boyutunu belirler
                              fontSize: 11,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.bold,
                              // Rengi belirler
                              color: GardenPalette.inkPlum,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(height: 6),
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      hasData
                          // Koşul doğruysa bu değeri kullanır
                          ? '${trend.totalExams} Deneme Bazında'
                          // Koşul yanlışsa bu değeri kullanır
                          : 'Henüz Deneme Kaydedilmedi',
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
                    // Trend status text
                    // Metni ekranda gösterir
                    Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      trend.changeText,
                      // Görünüm stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.w600,
                        // Rengi belirler
                        color: trend.netChange != null && trend.netChange! > 0
                            // Koşul doğruysa bu değeri kullanır
                            ? GardenPalette.mossEmerald
                            // Koşul yanlışsa bu değeri kullanır
                            : (trend.netChange != null && trend.netChange! < 0
                                // Koşul doğruysa bu değeri kullanır
                                ? Colors.redAccent
                                // Koşul yanlışsa bu değeri kullanır
                                : Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Belirtilen koşul doğruysa işlemi yapar
          if (hasData) ...[
            // Ayırıcı çizgi gösterir
            const Divider(height: 24),
            // Elemanları yan yana dizer
            Row(
              // Ana eksendeki hizalamayı belirler
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // İçerideki widgetları listeler
              children: [
                // İlgili fonksiyonu çalıştırır
                _buildStatMiniItem(
                  // Buton veya alan yazısını belirler
                  label: 'En Yüksek',
                  // Kullanılacak değeri belirler
                  value: '${trend.highestNet.toStringAsFixed(2)} N',
                  // Rengi belirler
                  color: GardenPalette.mossEmerald,
                ),
                // İlgili fonksiyonu çalıştırır
                _buildStatMiniItem(
                  // Buton veya alan yazısını belirler
                  label: 'Son Net',
                  // Kullanılacak değeri belirler
                  value: trend.latestNet != null
                      // Koşul doğruysa bu değeri kullanır
                      ? '${trend.latestNet!.toStringAsFixed(2)} N'
                      // Koşul yanlışsa bu değeri kullanır
                      : '-',
                  // Rengi belirler
                  color: GardenPalette.streamTurquoise,
                ),
                // İlgili fonksiyonu çalıştırır
                _buildStatMiniItem(
                  // Buton veya alan yazısını belirler
                  label: 'En Düşük',
                  // Kullanılacak değeri belirler
                  value: '${trend.lowestNet.toStringAsFixed(2)} N',
                  // Rengi belirler
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  // stat mini item bilgisini oluşturur
  Widget _buildStatMiniItem({
    // etiket bilgisini zorunlu tutar
    required String label,
    // değer bilgisini zorunlu tutar
    required String value,
    // renk bilgisini zorunlu tutar
    required Color color,
  }) {
    // Elemanları alt alta dizer
    return Column(
      // İçerideki widgetları listeler
      children: [
        // Metni ekranda gösterir
        Text(
          // İlgili değeri veya görünüm ayarını belirler
          label,
          // Görünüm stilini belirler
          style: TextStyle(
            // Yazı boyutunu belirler
            fontSize: 11,
            // Rengi belirler
            color: Colors.grey.shade600,
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 2),
        // Metni ekranda gösterir
        Text(
          // İlgili değeri veya görünüm ayarını belirler
          value,
          // Görünüm stilini belirler
          style: TextStyle(
            // Yazı boyutunu belirler
            fontSize: 14,
            // Yazı kalınlığını belirler
            fontWeight: FontWeight.bold,
            // Rengi belirler
            color: color,
          ),
        ),
      ],
    );
  }
  // ders breakdown bilgisini oluşturur
  Widget _buildSubjectBreakdown(List<SubjectNetStat> subjectStats) {
    // Elemanları alt alta dizer
    return Column(
      // İçerideki widgetları listeler
      children: subjectStats.map((stat) {
        // İç boşluk ekler
        return Padding(
          // İç boşlukları belirler
          padding: const EdgeInsets.only(bottom: 8),
          // İçine yerleştirilecek widgetı belirler
          child: GardenCard(
            // İç boşlukları belirler
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // Görsel bir kutu oluşturur
                Container(
                  // Genişliği belirler
                  width: 36,
                  // Yüksekliği belirler
                  height: 36,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: GardenPalette.mossEmerald.withAlpha(30),
                    // Widgetın kenar şeklini belirler
                    shape: BoxShape.circle,
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: const Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.auto_stories,
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
                        // İlgili değeri veya görünüm ayarını belirler
                        stat.subjectName,
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
                        // "Ortalama: ${stat.averageNet.toStringAsFixed…" metnini kullanır
                        'Ortalama: ${stat.averageNet.toStringAsFixed(1)} Net (${stat.examCount} deneme)',
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
                    horizontal: 10,
                    // vertical bilgisini belirler
                    vertical: 4,
                  ),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: GardenPalette.mossEmerald.withAlpha(25),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(8),
                    // Kenarlığı belirler
                    border: Border.all(
                      // Rengi belirler
                      color: GardenPalette.mossEmerald.withAlpha(60),
                    ),
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Text(
                    // "${stat.latestNet.toStringAsFixed(1)} Net" metnini kullanır
                    '${stat.latestNet.toStringAsFixed(1)} Net',
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 13,
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
      // Sonuçları listeye çevirir
      }).toList(),
    );
  }
  // ders title bilgisini getirir
  String _getSubjectTitle(List<SubjectNetStat> stats) {
    // İlgili değer null ise kontrol eder
    if (_selectedSubjectId == null) return 'Genel';
    // match için koşula uyan kayıtları filtreler
    final match = stats.where((s) => s.subjectId == _selectedSubjectId);
    // Liste veya metin doluysa bu koşul çalışır
    if (match.isNotEmpty) return match.first.subjectName;
    // "Ders" metnini kullanır
    return 'Ders';
  }
}

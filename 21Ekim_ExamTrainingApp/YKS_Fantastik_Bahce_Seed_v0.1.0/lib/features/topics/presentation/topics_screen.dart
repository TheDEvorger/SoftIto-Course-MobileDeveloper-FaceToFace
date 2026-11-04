// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// müfredat dosyasını kullanıma ekler
import '../../../domain/models/curriculum.dart';
// curriculum repository dosyasını kullanıma ekler
import '../../../domain/repositories/curriculum_repository.dart';
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
// ders detail ekran dosyasını kullanıma ekler
import 'subject_detail_screen.dart';
// konu map ekran dosyasını kullanıma ekler
import 'topic_map_screen.dart';
// topics ekran için değişen verileri yöneten StatefulWidget kullanılır
class TopicsScreen extends StatefulWidget {
  // topics ekran sayfasını gösterir
  const TopicsScreen({this.repository, super.key});
  // repository bilgisini tutar
  final CurriculumRepository? repository;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<TopicsScreen> createState() => _TopicsScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _TopicsScreenState extends State<TopicsScreen> {
  // aşama için metin değeri belirler
  String stage = 'TYT';
  // search controller metnini yönetir
  final searchController = TextEditingController();
  // İlgili değeri veya görünüm ayarını belirler
  CurriculumRepository? _repo;
  // dersler için boş koleksiyon oluşturur
  List<Subject> _subjects = [];
  // ders stats için boş koleksiyon oluşturur
  Map<String, Map<String, int>> _subjectStats = {};
  // stage summary bilgisini hesaplayıp saklar
  Map<String, int> _stageSummary = {
    // "totalTopics': 0" metnini kullanır
    'totalTopics': 0,
    // "completedTopics': 0" metnini kullanır
    'completedTopics': 0,
    // "inProgressTopics': 0" metnini kullanır
    'inProgressTopics': 0,
  };
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // search query için metin değeri belirler
  String _searchQuery = '';
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // curriculum bilgisini başlatır
    _initCurriculum();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    searchController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // curriculum bilgisini başlatır
  Future<void> _initCurriculum() async {
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
        // curriculum repository işlemini yapar
        _repo = CurriculumRepository(db);
      }
      // initial curriculum if empty bilgisini örnek verileri ekler
      await _repo!.seedInitialCurriculumIfEmpty();
      // stage data bilgisini yükler
      await _loadStageData();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // stage data bilgisini yükler
  Future<void> _loadStageData() async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // dersler verisini asenkron işlemin sonucundan alır
    final subjects = await _repo!.getSubjects(stage);
    // summary verisini asenkron işlemin sonucundan alır
    final summary = await _repo!.getStageSummary(stage);
    // stats verisini asenkron işlemin sonucundan alır
    final stats = await _repo!.getSubjectStatsForStage(stage);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // dersler değerini günceller
        _subjects = subjects;
        // stage summary değerini günceller
        _stageSummary = summary;
        // ders stats değerini günceller
        _subjectStats = stats;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // ders bilgisini açar
  void _openSubject(Subject subject) async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // Yeni sayfaya geçiş yapar
    await Navigator.of(context).push<void>(
      // material sayfa route nesnesini oluşturur
      MaterialPageRoute(
        // Gelen verilerle arayüzü oluşturur
        builder: (_) => SubjectDetailScreen(
          // ders bilgisini belirler
          subject: subject,
          // repository bilgisini belirler
          repository: _repo!,
        ),
      ),
    );
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // stage data bilgisini yükler
      _loadStageData();
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // filtered subjects için koşula uyan kayıtları filtreler
    final filteredSubjects = _subjects.where((s) {
      // Liste veya metin boşsa bu koşul çalışır
      if (_searchQuery.isEmpty) return true;
      // lower case bilgisini dönüştürür
      return s.name.toLowerCase().contains(_searchQuery.toLowerCase());
    // Sonuçları listeye çevirir
    }).toList();
    // toplam konular bilgisini hesaplayıp saklar
    final totalTopics = _stageSummary['totalTopics'] ?? 0;
    // tamamlanan konular bilgisini hesaplayıp saklar
    final completedTopics = _stageSummary['completedTopics'] ?? 0;
    // overall ratio değerini koşula göre hesaplar
    final overallRatio = totalTopics > 0 ? completedTopics / totalTopics : 0.0;
    // Kaydırılabilir liste oluşturur
    return ListView(
      // Widget anahtarını belirler
      key: const PageStorageKey<String>('topics'),
      // İç boşlukları belirler
      padding: const EdgeInsets.all(16),
      // İçerideki widgetları listeler
      children: [
        // forest hero kart kartını oluşturur
        ForestHeroCard(
          // görsel dosya yolu bilgisini belirler
          assetPath: GardenScenes.glasshouse,
          // tag bilgisini belirler
          tag: '📚 Konu ve Ders Takibi',
          // Başlığı belirler
          title: 'Botanik Bilgi Bahçesi',
          // Alt başlığı belirler
          subtitle: 'Bitirdiğin her konu bahçende yeni bir yaprak açar.',
          // Yüksekliği belirler
          height: 200,
          // action label bilgisini belirler
          actionLabel: 'Konu Ağacı & Tekrar 🗺️',
          // on action olayındaki fonksiyonu belirler
          onAction: () {
            // navigator.of nesnesini oluşturur
            Navigator.of(context).push(
              // material sayfa route nesnesini oluşturur
              MaterialPageRoute<void>(
                // Gelen verilerle arayüzü oluşturur
                builder: (_) => TopicMapScreen(repository: _repo),
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
        // nature segmented control nesnesini oluşturur
        NatureSegmentedControl<String>(
          // Listelenecek öğeleri belirler
          items: const {
            // "TYT': 'TYT Müfredatı" metnini kullanır
            'TYT': 'TYT Müfredatı',
            // "AYT': 'AYT Müfredatı" metnini kullanır
            'AYT': 'AYT Müfredatı',
          },
          // seçili olma durumu bilgisini belirler
          selected: stage,
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (newStage) {
            // Değişen verileri arayüze bildirir
            setState(() => stage = newStage);
            // stage data bilgisini yükler
            _loadStageData();
          },
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 14),
        // nature search field nesnesini oluşturur
        NatureSearchField(
          // Veriyi yöneten controllerı bağlar
          controller: searchController,
          // Giriş alanında ipucu gösterir
          hintText: '$stage dersi ara...',
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (val) => setState(() => _searchQuery = val),
          // on clear olayındaki fonksiyonu belirler
          onClear: () => setState(() => _searchQuery = ''),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 14),
        // Genel İlerleme Özeti
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
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // "$stage Genel Müfredat İlerlemesi" metnini kullanır
                      '$stage Genel Müfredat İlerlemesi',
                      // Uzun yazının taşma şeklini belirler
                      overflow: TextOverflow.ellipsis,
                      // Görünüm stilini belirler
                      style: const TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Metni ekranda gösterir
                  Text(
                    // "$completedTopics / $totalTopics Konu" metnini kullanır
                    '$completedTopics / $totalTopics Konu',
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 13,
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
                progress: overallRatio,
                // Yüksekliği belirler
                height: 12,
                // show leaf tip bilgisini belirler
                showLeafTip: true,
                // Etkin durum rengini belirler
                activeColor: GardenPalette.mossEmerald,
              ),
            ],
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 14),
        // botanical section header nesnesini oluşturur
        BotanicalSectionHeader(
          // Başlığı belirler
          title: '$stage Dersleri ve Konu Detayları',
          // Alt başlığı belirler
          subtitle: 'Ders seçerek alt konuları incele ve tamamla',
          // simge bilgisini belirler
          icon: Icons.eco_outlined,
        ),
        // Belirtilen koşul doğruysa işlemi yapar
        if (_loading)
          // İçeriği ortalar
          const Center(
            // İçine yerleştirilecek widgetı belirler
            child: Padding(
              // İç boşlukları belirler
              padding: EdgeInsets.all(24),
              // İçine yerleştirilecek widgetı belirler
              child: CircularProgressIndicator(),
            ),
          )
        // Önceki koşul sağlanmazsa yeni koşulu kontrol eder
        else if (filteredSubjects.isEmpty)
          // İç boşluk ekler
          const Padding(
            // İç boşlukları belirler
            padding: EdgeInsets.all(32),
            // İçine yerleştirilecek widgetı belirler
            child: Center(child: Text('Aradığın ders bulunamadı.')),
          )
        // Önceki koşul sağlanmazsa çalışır
        else
          // Öğeleri tek tek dönüştürür
          ...filteredSubjects.map((s) {
            // stats değerini koşula göre hesaplar
            final stats = _subjectStats[s.id] ?? {'total': 0, 'completed': 0};
            // toplam bilgisini hesaplayıp saklar
            final total = stats['total'] ?? 0;
            // tamamlananlar bilgisini hesaplayıp saklar
            final completed = stats['completed'] ?? 0;
            // İç boşluk ekler
            return Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.only(bottom: 10),
              // İçine yerleştirilecek widgetı belirler
              child: SubjectProgressBadge(
                // ders adı bilgisini belirler
                subjectName: '${s.name} (~${s.questionCount} Soru)',
                // tamamlanan konular bilgisini belirler
                completedTopics: completed,
                // toplam konular bilgisini belirler
                totalTopics: total,
                // Rengi belirler
                color: s.id.contains('mat')
                    // Koşul doğruysa bu değeri kullanır
                    ? GardenPalette.mossEmerald
                    // Koşul yanlışsa bu değeri kullanır
                    : (s.id.contains('fen') || s.id.contains('fizik')
                        // Koşul doğruysa bu değeri kullanır
                        ? GardenPalette.streamTurquoise
                        // Koşul yanlışsa bu değeri kullanır
                        : (s.id.contains('turkce') || s.id.contains('edebiyat')
                            // Koşul doğruysa bu değeri kullanır
                            ? GardenPalette.peachCoral
                            // Koşul yanlışsa bu değeri kullanır
                            : GardenPalette.harvestGold)),
                // Dokunulunca çalışacak fonksiyonu belirler
                onTap: () => _openSubject(s),
              ),
            );
          }),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 32),
      ],
    );
  }
}

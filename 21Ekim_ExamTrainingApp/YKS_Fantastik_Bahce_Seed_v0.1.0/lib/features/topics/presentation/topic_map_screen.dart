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
// konu relation dosyasını kullanıma ekler
import '../../../domain/models/topic_relation.dart';
// curriculum repository dosyasını kullanıma ekler
import '../../../domain/repositories/curriculum_repository.dart';
// konu map servis dosyasını kullanıma ekler
import '../../../domain/services/topic_map_service.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// konu map painter dosyasını kullanıma ekler
import 'topic_map_painter.dart';
// konu map ekran için değişen verileri yöneten StatefulWidget kullanılır
class TopicMapScreen extends StatefulWidget {
  // konu map ekran sayfasını gösterir
  const TopicMapScreen({
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // repository bilgisini isteğe bağlı alır
    this.repository,
    // map servis bilgisini isteğe bağlı alır
    this.mapService,
  });
  // repository bilgisini tutar
  final CurriculumRepository? repository;
  // map servis bilgisini tutar
  final TopicMapService? mapService;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<TopicMapScreen> createState() => _TopicMapScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _TopicMapScreenState extends State<TopicMapScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  CurriculumRepository? _repo;
  // servis bilgisini tutar
  TopicMapService? _service;
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // seçilen branch değerini tanımlar
  String _selectedBranch =
      // "matematik'; // 'matematik', 'fizik', 'kimya…" metnini kullanır
      'matematik'; // 'matematik', 'fizik', 'kimya', 'biyoloji'
  // ekran mode için metin değeri belirler
  String _viewMode = 'map'; // 'map' or 'list'
  // güncel nodes için boş koleksiyon oluşturur
  List<TopicNodeInfo> _currentNodes = [];
  // review recommendations için boş koleksiyon oluşturur
  List<TopicNodeInfo> _reviewRecommendations = [];
  // seçilen node bilgisini tutar
  TopicNodeInfo? _selectedNode;
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
      if (widget.repository != null) {
        // repo değerini günceller
        _repo = widget.repository;
        // Değer null ise varsayılanı kullanır
        _service = widget.mapService ?? TopicMapService(_repo!);
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // curriculum repository işlemini yapar
        _repo = CurriculumRepository(db);
        // konu map servis işlemini yapar
        _service = TopicMapService(_repo!);
      }
      // branch data bilgisini yükler
      await _loadBranchData();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // branch data bilgisini yükler
  Future<void> _loadBranchData() async {
    // İlgili değer null ise kontrol eder
    if (_service == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // düğümler verisini asenkron işlemin sonucundan alır
    final nodes = await _service!.getTopicNodesForBranch(
      // branch key bilgisini belirler
      branchKey: _selectedBranch,
    );
    // reviews verisini asenkron işlemin sonucundan alır
    final reviews = await _service!.getReviewRecommendations();
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // güncel nodes değerini günceller
        _currentNodes = nodes;
        // review recommendations değerini günceller
        _reviewRecommendations = reviews;
        // Liste veya metnin dolu olup olmadığını kontrol eder
        _selectedNode = nodes.isNotEmpty ? nodes.first : null;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // node status bilgisini günceller
  Future<void> _updateNodeStatus(
      // İlgili değeri veya görünüm ayarını belirler
      TopicNodeInfo node, TopicStatus newStatus) async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // ilerleme bilgisini hesaplayıp saklar
    final progress = TopicProgress(
      // Konu ID bilgisini belirler
      topicId: node.topicId,
      // durum bilgisini belirler
      status: newStatus,
      // çözülen soru sayısı bilgisini belirler
      answeredCount: node.answeredCount,
      // last studied at bilgisini belirler
      lastStudiedAt: DateTime.now(),
    );
    // konu ilerleme bilgisini günceller
    await _repo!.updateTopicProgress(progress);
    // branch data bilgisini yükler
    await _loadBranchData();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: const Text('Konu Ağacı & Tekrar Haritası'),
        // Arka plan rengini belirler
        backgroundColor: Colors.transparent,
        // Gölge yüksekliğini belirler
        elevation: 0,
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
          : ListView(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // İçerideki widgetları listeler
              children: [
                // forest hero kart kartını oluşturur
                ForestHeroCard(
                  // görsel dosya yolu bilgisini belirler
                  assetPath: GardenScenes.waterfall,
                  // tag bilgisini belirler
                  tag: '🌊 Doğrulanmış MEB Önkoşul Haritası',
                  // Başlığı belirler
                  title: 'Konu Bağlantıları ve Tekrar',
                  // Alt başlığı belirler
                  subtitle:
                      // "Konuların pedagojik önkoşul zincirini izle,…" metnini kullanır
                      'Konuların pedagojik önkoşul zincirini izle, unutma eğrisine karşı zamanında tekrar et.',
                  // Yüksekliği belirler
                  height: 200,
                  // action label bilgisini belirler
                  actionLabel: _viewMode == 'map'
                      // Koşul doğruysa bu değeri kullanır
                      ? 'Liste Görünümü 📋'
                      // Koşul yanlışsa bu değeri kullanır
                      : 'Ağ Haritası 🗺️',
                  // on action olayındaki fonksiyonu belirler
                  onAction: () {
                    // Değişen verileri arayüze bildirir
                    setState(() {
                      // Koşula göre iki değerden birini seçer
                      _viewMode = _viewMode == 'map' ? 'list' : 'map';
                    });
                  },
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 12),
                // seed notice nesnesini oluşturur
                const SeedNotice(),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 12),
                // Branş Seçici Segmented Control
                // nature segmented control nesnesini oluşturur
                NatureSegmentedControl<String>(
                  // Listelenecek öğeleri belirler
                  items: const {
                    // "matematik': 'Matematik" metnini kullanır
                    'matematik': 'Matematik',
                    // "fizik': 'Fizik" metnini kullanır
                    'fizik': 'Fizik',
                    // "kimya': 'Kimya" metnini kullanır
                    'kimya': 'Kimya',
                    // "biyoloji': 'Biyoloji" metnini kullanır
                    'biyoloji': 'Biyoloji',
                  },
                  // seçili olma durumu bilgisini belirler
                  selected: _selectedBranch,
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: (newBranch) {
                    // Değişen verileri arayüze bildirir
                    setState(() => _selectedBranch = newBranch);
                    // branch data bilgisini yükler
                    _loadBranchData();
                  },
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 12),
                // Görünüm Modu Değiştirici
                // nature segmented control nesnesini oluşturur
                NatureSegmentedControl<String>(
                  // Listelenecek öğeleri belirler
                  items: const {
                    // "map': '🗺️ Botanik Ağ Haritası" metnini kullanır
                    'map': '🗺️ Botanik Ağ Haritası',
                    // "list': '📋 Erişilebilir Liste Modu" metnini kullanır
                    'list': '📋 Erişilebilir Liste Modu',
                  },
                  // seçili olma durumu bilgisini belirler
                  selected: _viewMode,
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: (newMode) => setState(() => _viewMode = newMode),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 16),
                // Tekrar Önerileri Bölümü (Spaced Repetition Banners)
                // Liste veya metin doluysa bu koşul çalışır
                if (_reviewRecommendations.isNotEmpty) ...[
                  // botanical section header nesnesini oluşturur
                  const BotanicalSectionHeader(
                    // Başlığı belirler
                    title: 'Tekrar Önerileri (Aralıklı Tekrar)',
                    // Alt başlığı belirler
                    subtitle:
                        // "Unutma eğrisini yenilemek için tazelemeye i…" metnini kullanır
                        'Unutma eğrisini yenilemek için tazelemeye ihtiyaç duyan konular',
                    // simge bilgisini belirler
                    icon: Icons.history_edu_outlined,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  SizedBox(
                    // Yüksekliği belirler
                    height: 115,
                    // İçine yerleştirilecek widgetı belirler
                    child: ListView.separated(
                      // Kaydırma yönünü belirler
                      scrollDirection: Axis.horizontal,
                      // Listede gösterilecek öğe sayısını belirler
                      itemCount: _reviewRecommendations.length,
                      // Liste elemanları arasındaki ayırıcıyı oluşturur
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      // Her liste elemanının nasıl gösterileceğini belirler
                      itemBuilder: (ctx, i) {
                        // öğe bilgisini hesaplayıp saklar
                        final item = _reviewRecommendations[i];
                        // Görsel bir kutu oluşturur
                        return Container(
                          // Genişliği belirler
                          width: 250,
                          // İç boşlukları belirler
                          padding: const EdgeInsets.all(12),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: GardenPalette.peachCoral.withAlpha(25),
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(12),
                            // Kenarlığı belirler
                            border: Border.all(
                              // Rengi belirler
                              color: GardenPalette.peachCoral.withAlpha(80),
                            ),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Column(
                            // Çapraz eksendeki hizalamayı belirler
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Ana eksendeki hizalamayı belirler
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // İçerideki widgetları listeler
                            children: [
                              // Elemanları yan yana dizer
                              Row(
                                // İçerideki widgetları listeler
                                children: [
                                  // Simge gösterir
                                  const Icon(
                                    // Gösterilecek simgeyi belirler
                                    Icons.alarm_on,
                                    // Boyutu belirler
                                    size: 16,
                                    // Rengi belirler
                                    color: GardenPalette.peachCoral,
                                  ),
                                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                  const SizedBox(width: 6),
                                  // Kalan boşluğu kullanacak alan oluşturur
                                  Expanded(
                                    // İçine yerleştirilecek widgetı belirler
                                    child: Text(
                                      // İlgili değeri veya görünüm ayarını belirler
                                      item.topicName,
                                      // Gösterilecek en fazla satır sayısını belirler
                                      maxLines: 1,
                                      // Uzun yazının taşma şeklini belirler
                                      overflow: TextOverflow.ellipsis,
                                      // Görünüm stilini belirler
                                      style: const TextStyle(
                                        // Yazı kalınlığını belirler
                                        fontWeight: FontWeight.bold,
                                        // Yazı boyutunu belirler
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Metni ekranda gösterir
                              Text(
                                // Değer null ise varsayılanı kullanır
                                item.reviewMessage ?? 'Tekrar zamanı',
                                // Gösterilecek en fazla satır sayısını belirler
                                maxLines: 2,
                                // Uzun yazının taşma şeklini belirler
                                overflow: TextOverflow.ellipsis,
                                // Görünüm stilini belirler
                                style: TextStyle(
                                  // Yazı boyutunu belirler
                                  fontSize: 11,
                                  // Rengi belirler
                                  color:
                                      // Koşula göre iki değerden birini seçer
                                      isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              // Elemanları yan yana dizer
                              Row(
                                // Ana eksendeki hizalamayı belirler
                                mainAxisAlignment: MainAxisAlignment.end,
                                // İçerideki widgetları listeler
                                children: [
                                  // Tıklanabilir alan oluşturur
                                  InkWell(
                                    // Dokunulunca çalışacak fonksiyonu belirler
                                    onTap: () => _updateNodeStatus(
                                      // İlgili değeri veya görünüm ayarını belirler
                                      item,
                                      // İlgili değeri veya görünüm ayarını belirler
                                      TopicStatus.completed,
                                    ),
                                    // İçine yerleştirilecek widgetı belirler
                                    child: const Text(
                                      // "Tekrar Ettim ✓" metnini kullanır
                                      'Tekrar Ettim ✓',
                                      // Görünüm stilini belirler
                                      style: TextStyle(
                                        // Rengi belirler
                                        color: GardenPalette.mossEmerald,
                                        // Yazı boyutunu belirler
                                        fontSize: 11,
                                        // Yazı kalınlığını belirler
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 16),
                ],
                // Ana İçerik: Harita Modu veya Liste Modu
                // Belirtilen koşul doğruysa işlemi yapar
                if (_viewMode == 'map')
                  // map canvas ekran bilgisini oluşturur
                  _buildMapCanvasView(isDark)
                // Önceki koşul sağlanmazsa çalışır
                else
                  // accessible list ekran bilgisini oluşturur
                  _buildAccessibleListView(isDark),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 24),
              ],
            ),
    );
  }
  // map canvas ekran bilgisini oluşturur
  Widget _buildMapCanvasView(bool isDark) {
    // Liste veya metin boşsa bu koşul çalışır
    if (_currentNodes.isEmpty) {
      // İç boşluk ekler
      return const Padding(
        // İç boşlukları belirler
        padding: EdgeInsets.all(32),
        // İçine yerleştirilecek widgetı belirler
        child: Center(child: Text('Bu branşta haritalanmış konu bulunmuyor.')),
      );
    }
    // max y değerini tanımlar
    final maxY =
        // Öğeleri tek tek dönüştürür
        _currentNodes.map((n) => n.y).reduce((a, b) => a > b ? a : b) + 80.0;
    // Elemanları alt alta dizer
    return Column(
      // Çapraz eksendeki hizalamayı belirler
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // İçerideki widgetları listeler
      children: [
        // Bilgilendirme Rozetleri
        // Öğeleri sığmadıkça alt satıra geçirir
        Wrap(
          // spacing bilgisini belirler
          spacing: 12,
          // run spacing bilgisini belirler
          runSpacing: 6,
          // İçerideki widgetları listeler
          children: [
            // legend item bilgisini oluşturur
            _buildLegendItem('✓ Tamamlandı', GardenPalette.mossEmerald),
            // legend item bilgisini oluşturur
            _buildLegendItem('🌱 Çalışılıyor', GardenPalette.harvestGold),
            // İlgili fonksiyonu çalıştırır
            _buildLegendItem(
                // "🔓 Önkoşulu Hazır', GardenPalette.streamTurq…" metnini kullanır
                '🔓 Önkoşulu Hazır', GardenPalette.streamTurquoise),
            // legend item bilgisini oluşturur
            _buildLegendItem('🔒 Önkoşul Eksik', Colors.grey),
          ],
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // Zoom & Pan Destekli Interactive Canvas
        // Görsel bir kutu oluşturur
        Container(
          // Yüksekliği belirler
          height: 380,
          // Kutu ve kenarlık görünümünü belirler
          decoration: BoxDecoration(
            // Rengi belirler
            color: isDark ? const Color(0xFF1E272E) : const Color(0xFFF1F5F9),
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(16),
            // Kenarlığı belirler
            border: Border.all(
              // Rengi belirler
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          // İçine yerleştirilecek widgetı belirler
          child: ClipRRect(
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(16),
            // İçine yerleştirilecek widgetı belirler
            child: InteractiveViewer(
              // constrained bilgisini belirler
              constrained: false,
              // boundary margin bilgisini belirler
              boundaryMargin: const EdgeInsets.all(50),
              // min scale bilgisini belirler
              minScale: 0.5,
              // max scale bilgisini belirler
              maxScale: 2.0,
              // İçine yerleştirilecek widgetı belirler
              child: GestureDetector(
                // on tap up olayındaki fonksiyonu belirler
                onTapUp: (details) {
                  // tap pos bilgisini hesaplayıp saklar
                  final tapPos = details.localPosition;
                  // Listedeki öğeleri tek tek dolaşır
                  for (final node in _currentNodes) {
                    // dist bilgisini hesaplayıp saklar
                    final dist = (Offset(node.x, node.y) - tapPos).distance;
                    // Belirtilen koşul doğruysa işlemi yapar
                    if (dist <= 30) {
                      // Değişen verileri arayüze bildirir
                      setState(() => _selectedNode = node);
                      // Bulunduğu döngü veya switch bölümünden çıkar
                      break;
                    }
                  }
                },
                // İçine yerleştirilecek widgetı belirler
                child: CustomPaint(
                  // Boyutu belirler
                  size: Size(380, maxY),
                  // painter bilgisini belirler
                  painter: TopicMapPainter(
                    // düğümler bilgisini belirler
                    nodes: _currentNodes,
                    // seçilen konu ID bilgisini belirler
                    selectedTopicId: _selectedNode?.topicId,
                    // Koyu tema durumunu belirler
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // Seçili Düğüm Alt Bilgi Kartı
        // İlgili değer null değilse kontrol eder
        if (_selectedNode != null)
          // seçilen node kart bilgisini oluşturur
          _buildSelectedNodeCard(_selectedNode!, isDark),
      ],
    );
  }
  // seçilen node kart bilgisini oluşturur
  Widget _buildSelectedNodeCard(TopicNodeInfo node, bool isDark) {
    // garden kart kartını oluşturur
    return GardenCard(
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
                padding: const EdgeInsets.all(8),
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Rengi belirler
                  color: GardenPalette.mossEmerald.withAlpha(30),
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(8),
                ),
                // İçine yerleştirilecek widgetı belirler
                child: Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  node.stage,
                  // Görünüm stilini belirler
                  style: const TextStyle(
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                    // Rengi belirler
                    color: GardenPalette.mossEmerald,
                    // Yazı boyutunu belirler
                    fontSize: 12,
                  ),
                ),
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 8),
              // Kalan boşluğu kullanacak alan oluşturur
              Expanded(
                // İçine yerleştirilecek widgetı belirler
                child: Text(
                  // İlgili değeri veya görünüm ayarını belirler
                  node.topicName,
                  // Görünüm stilini belirler
                  style: const TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 16,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Metni ekranda gösterir
              Text(
                // İlgili değeri veya görünüm ayarını belirler
                node.status.label,
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w600,
                  // Rengi belirler
                  color: node.status == TopicStatus.completed
                      // Koşul doğruysa bu değeri kullanır
                      ? GardenPalette.mossEmerald
                      // Koşul yanlışsa bu değeri kullanır
                      : (node.status == TopicStatus.inProgress
                          // Koşul doğruysa bu değeri kullanır
                          ? GardenPalette.harvestGold
                          // Koşul yanlışsa bu değeri kullanır
                          : Colors.grey),
                ),
              ),
            ],
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 8),
          // İlgili değer null değilse kontrol eder
          if (node.reviewMessage != null) ...[
            // Metni ekranda gösterir
            Text(
              // İlgili değeri veya görünüm ayarını belirler
              node.reviewMessage!,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 12,
                // Rengi belirler
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
          ],
          // Liste veya metin doluysa bu koşul çalışır
          if (node.prerequisiteIds.isNotEmpty) ...[
            // Metni ekranda gösterir
            Text(
              // Öğeleri tek tek dönüştürür
              'Önkoşul Konuları: ${node.prerequisiteIds.map(_getTopicNameById).join(', ')}',
              // Görünüm stilini belirler
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 10),
          ],
          // Öğeleri sığmadıkça alt satıra geçirir
          Wrap(
            // İçeriğin hizalanmasını belirler
            alignment: WrapAlignment.end,
            // spacing bilgisini belirler
            spacing: 8,
            // run spacing bilgisini belirler
            runSpacing: 4,
            // İçerideki widgetları listeler
            children: [
              // Metin butonu oluşturur
              TextButton(
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: () =>
                    // node status bilgisini günceller
                    _updateNodeStatus(node, TopicStatus.notStarted),
                // İçine yerleştirilecek widgetı belirler
                child: const Text('Eksik'),
              ),
              // Metin butonu oluşturur
              TextButton(
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: () =>
                    // node status bilgisini günceller
                    _updateNodeStatus(node, TopicStatus.inProgress),
                // İçine yerleştirilecek widgetı belirler
                child: const Text('Çalışılıyor'),
              ),
              // Yükseltilmiş buton oluşturur
              ElevatedButton(
                // Görünüm stilini belirler
                style: ElevatedButton.styleFrom(
                  // Arka plan rengini belirler
                  backgroundColor: GardenPalette.mossEmerald,
                  // Yazı ve simge rengini belirler
                  foregroundColor: Colors.white,
                ),
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: () => _updateNodeStatus(node, TopicStatus.completed),
                // İçine yerleştirilecek widgetı belirler
                child: const Text('Tamamla ✓'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // accessible list ekran bilgisini oluşturur
  Widget _buildAccessibleListView(bool isDark) {
    // Liste veya metin boşsa bu koşul çalışır
    if (_currentNodes.isEmpty) {
      // İçeriği ortalar
      return const Center(child: Text('Konu bulunmuyor.'));
    }
    // Elemanları alt alta dizer
    return Column(
      // İçerideki widgetları listeler
      children: _currentNodes.map((node) {
        // prereqs metin bilgisini hesaplayıp saklar
        final prereqsText = node.prerequisiteIds.isEmpty
            // Koşul doğruysa bu değeri kullanır
            ? 'Temel Başlangıç Konusu (Önkoşulsuz)'
            // Koşul yanlışsa bu değeri kullanır
            : 'Önkoşullar: ${node.prerequisiteIds.map(_getTopicNameById).join(', ')}';
        // Erişilebilirlik açıklaması ekler
        return Semantics(
          // Buton veya alan yazısını belirler
          label:
              // "${node.stage} ${node.topicName}, Durum: ${n…" metnini kullanır
              '${node.stage} ${node.topicName}, Durum: ${node.status.label}, $prereqsText',
          // İçine yerleştirilecek widgetı belirler
          child: Container(
            // Dış boşlukları belirler
            margin: const EdgeInsets.only(bottom: 8),
            // İç boşlukları belirler
            padding: const EdgeInsets.all(12),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Rengi belirler
              color: isDark ? const Color(0xFF242C35) : Colors.white,
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(12),
              // Kenarlığı belirler
              border: Border.all(
                // Rengi belirler
                color: node.status == TopicStatus.completed
                    // Koşul doğruysa bu değeri kullanır
                    ? GardenPalette.mossEmerald.withAlpha(120)
                    // Koşul yanlışsa bu değeri kullanır
                    : (isDark ? Colors.white10 : Colors.black12),
              ),
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // Simge gösterir
                Icon(
                  // node.status değerini günceller
                  node.status == TopicStatus.completed
                      // Koşul doğruysa bu değeri kullanır
                      ? Icons.check_circle
                      // Koşul yanlışsa bu değeri kullanır
                      : (node.status == TopicStatus.inProgress
                          // Koşul doğruysa bu değeri kullanır
                          ? Icons.play_circle_fill
                          // Koşul yanlışsa bu değeri kullanır
                          : (node.isReady
                              // Koşul doğruysa bu değeri kullanır
                              ? Icons.lock_open
                              // Koşul yanlışsa bu değeri kullanır
                              : Icons.lock_outline)),
                  // Rengi belirler
                  color: node.status == TopicStatus.completed
                      // Koşul doğruysa bu değeri kullanır
                      ? GardenPalette.mossEmerald
                      // Koşul yanlışsa bu değeri kullanır
                      : (node.status == TopicStatus.inProgress
                          // Koşul doğruysa bu değeri kullanır
                          ? GardenPalette.harvestGold
                          // Koşul yanlışsa bu değeri kullanır
                          : Colors.grey),
                  // Boyutu belirler
                  size: 24,
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
                        // "${node.stage} • ${node.topicName}" metnini kullanır
                        '${node.stage} • ${node.topicName}',
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Yazı boyutunu belirler
                          fontSize: 14,
                        ),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 3),
                      // Metni ekranda gösterir
                      Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        prereqsText,
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 11,
                          // Rengi belirler
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      // İlgili değer null değilse kontrol eder
                      if (node.reviewMessage != null) ...[
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 2),
                        // Metni ekranda gösterir
                        Text(
                          // İlgili değeri veya görünüm ayarını belirler
                          node.reviewMessage!,
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 11,
                            // Rengi belirler
                            color: node.needsReview
                                // Koşul doğruysa bu değeri kullanır
                                ? GardenPalette.peachCoral
                                // Koşul yanlışsa bu değeri kullanır
                                : GardenPalette.mossEmerald,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Simgeli buton oluşturur
                IconButton(
                  // simge bilgisini belirler
                  icon: const Icon(Icons.check),
                  // tooltip bilgisini belirler
                  tooltip: 'Tamamlandı Olarak İşaretle',
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: () =>
                      // node status bilgisini günceller
                      _updateNodeStatus(node, TopicStatus.completed),
                ),
              ],
            ),
          ),
        );
      // Sonuçları listeye çevirir
      }).toList(),
    );
  }
  // konu adı by id bilgisini getirir
  String _getTopicNameById(String id) {
    // found için koşula uyan kayıtları filtreler
    final found = _currentNodes.where((n) => n.topicId == id);
    // Liste veya metin doluysa bu koşul çalışır
    if (found.isNotEmpty) return found.first.topicName;
    // Hesaplanan sonucu döndürür
    return id;
  }
  // legend item bilgisini oluşturur
  Widget _buildLegendItem(String label, Color color) {
    // Elemanları yan yana dizer
    return Row(
      // Ana eksende kaplanacak alanı belirler
      mainAxisSize: MainAxisSize.min,
      // İçerideki widgetları listeler
      children: [
        // Görsel bir kutu oluşturur
        Container(
          // Genişliği belirler
          width: 10,
          // Yüksekliği belirler
          height: 10,
          // Kutu ve kenarlık görünümünü belirler
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(width: 4),
        // Metni ekranda gösterir
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

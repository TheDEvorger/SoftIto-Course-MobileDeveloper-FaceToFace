// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// net calculator dosyasını kullanıma ekler
import '../../../domain/exam/net_calculator.dart';
// deneme record dosyasını kullanıma ekler
import '../../../domain/models/exam_record.dart';
// deneme repository dosyasını kullanıma ekler
import '../../../domain/repositories/exam_repository.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden inputs dosyasını kullanıma ekler
import '../../../shared/widgets/garden_inputs.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// deneme entry pencere dosyasını kullanıma ekler
import 'exam_entry_dialog.dart';
// exams ekran için değişen verileri yöneten StatefulWidget kullanılır
class ExamsScreen extends StatefulWidget {
  // exams ekran sayfasını gösterir
  const ExamsScreen({this.repository, super.key});
  // repository bilgisini tutar
  final ExamRepository? repository;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<ExamsScreen> createState() => _ExamsScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _ExamsScreenState extends State<ExamsScreen> {
  // correct controller metnini yönetir
  final correctController = TextEditingController(text: '30');
  // wrong controller metnini yönetir
  final wrongController = TextEditingController(text: '8');
  // quick soru sayı controller metnini yönetir
  final quickQuestionCountController = TextEditingController(text: '40');
  // quick title controller değerini tanımlar
  final quickTitleController =
      // metin editing controller nesnesini oluşturur
      TextEditingController(text: 'Hızlı Branş Denemesi');
  // aşama için metin değeri belirler
  String stage = 'TYT';
  // İlgili değeri veya görünüm ayarını belirler
  ExamRepository? _repo;
  // exams için boş koleksiyon oluşturur
  List<ExamSession> _exams = [];
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // repo bilgisini başlatır
    _initRepo();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    correctController.dispose();
    // Kullanılan kaynakları temizler
    wrongController.dispose();
    // Kullanılan kaynakları temizler
    quickQuestionCountController.dispose();
    // Kullanılan kaynakları temizler
    quickTitleController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
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
        // deneme repository işlemini yapar
        _repo = ExamRepository(db);
      }
      // exams bilgisini yükler
      await _loadExams();
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _loading = false);
    }
  }
  // exams bilgisini yükler
  Future<void> _loadExams() async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // Değişen verileri arayüze bildirir
    setState(() => _loading = true);
    // exams verisini asenkron işlemin sonucundan alır
    final exams = await _repo!.getExams(stage: stage);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // exams değerini günceller
        _exams = exams;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // add deneme bilgisini açar
  Future<void> _openAddExam() async {
    // sonuç verisini asenkron işlemin sonucundan alır
    final result = await showDialog<ExamSession>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (_) => ExamEntryDialog(initialStage: stage),
    );
    // İlgili değer null değilse kontrol eder
    if (result != null && _repo != null) {
      // deneme bilgisini kaydeder
      await _repo!.saveExam(result);
      // exams bilgisini yükler
      await _loadExams();
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Ekranda kısa bilgilendirme mesajı gösterir
        ScaffoldMessenger.of(context).showSnackBar(
          // Kısa bildirim mesajı oluşturur
          SnackBar(
            // Gösterilecek içeriği belirler
            content: Text('🌿 "${result.title}" denemesi kaydedildi!'),
            // Arka plan rengini belirler
            backgroundColor: GardenPalette.mossEmerald,
          ),
        );
      }
    }
  }
  // edit deneme bilgisini açar
  Future<void> _openEditExam(ExamSession exam) async {
    // sonuç verisini asenkron işlemin sonucundan alır
    final result = await showDialog<ExamSession>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (_) => ExamEntryDialog(
        // existing session bilgisini belirler
        existingSession: exam,
        // initial stage bilgisini belirler
        initialStage: exam.stage,
      ),
    );
    // İlgili değer null değilse kontrol eder
    if (result != null && _repo != null) {
      // deneme bilgisini kaydeder
      await _repo!.saveExam(result);
      // exams bilgisini yükler
      await _loadExams();
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Ekranda kısa bilgilendirme mesajı gösterir
        ScaffoldMessenger.of(context).showSnackBar(
          // Kısa bildirim mesajı oluşturur
          SnackBar(
            // Gösterilecek içeriği belirler
            content: Text('✨ "${result.title}" güncellendi.'),
            // Arka plan rengini belirler
            backgroundColor: GardenPalette.mossEmerald,
          ),
        );
      }
    }
  }
  // confirm delete deneme işlemini yapar
  Future<void> _confirmDeleteExam(ExamSession exam) async {
    // confirmed verisini asenkron işlemin sonucundan alır
    final confirmed = await showDialog<bool>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (ctx) => AlertDialog(
        // Başlığı belirler
        title: const Text('Denemeyi Sil'),
        // Gösterilecek içeriği belirler
        content: Text(
          // "${exam.title}" denemesini silmek istediğine…" metnini kullanır
          '"${exam.title}" denemesini silmek istediğine emin misin? Bu işlem geri alınamaz.',
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    // İlgili değer null değilse kontrol eder
    if (confirmed == true && _repo != null) {
      // deneme bilgisini siler
      await _repo!.deleteExam(exam.id);
      // exams bilgisini yükler
      await _loadExams();
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Ekranda kısa bilgilendirme mesajı gösterir
        ScaffoldMessenger.of(context).showSnackBar(
          // Kısa bildirim mesajı oluşturur
          const SnackBar(content: Text('Deneme silindi.')),
        );
      }
    }
  }
  // quick deneme bilgisini kaydeder
  Future<void> _saveQuickExam(double net, int correct, int wrong) async {
    // İlgili değer null ise kontrol eder
    if (_repo == null) return;
    // q sayı bilgisini hesaplayıp saklar
    final qCount = int.tryParse(quickQuestionCountController.text) ?? 40;
    // boş sayısı değerini belirli aralıkta sınırlar
    final blank = (qCount - correct - wrong).clamp(0, qCount);
    // başlık bilgisini hesaplayıp saklar
    final title = quickTitleController.text.trim().isNotEmpty
        // Koşul doğruysa bu değeri kullanır
        ? quickTitleController.text.trim()
        // Koşul yanlışsa bu değeri kullanır
        : 'Hızlı $stage Denemesi';
    // deneme ID için güncel tarih ve saati alır
    final examId = 'quick_${DateTime.now().millisecondsSinceEpoch}';
    // session bilgisini hesaplayıp saklar
    final session = ExamSession(
      // ID bilgisini belirler
      id: examId,
      // Öğrenme veya sınav aşamasını belirler
      stage: stage,
      // Başlığı belirler
      title: title,
      // occurred at bilgisini belirler
      occurredAt: DateTime.now(),
      // scope bilgisini belirler
      scope: 'branch',
      // toplam correct bilgisini belirler
      totalCorrect: correct,
      // toplam wrong bilgisini belirler
      totalWrong: wrong,
      // toplam blank bilgisini belirler
      totalBlank: blank,
      // toplam net bilgisini belirler
      totalNet: double.parse(net.toStringAsFixed(2)),
      // scores bilgisini belirler
      scores: [
        // deneme score nesnesini oluşturur
        ExamScore(
          // ID bilgisini belirler
          id: '${examId}_score',
          // Deneme ID bilgisini belirler
          examId: examId,
          // Ders ID bilgisini belirler
          subjectId: stage == 'TYT' ? 'tyt_hizli' : 'ayt_hizli',
          // ders adı bilgisini belirler
          subjectName: '$stage Hızlı Branş',
          // Doğru sayısını belirler
          correct: correct,
          // Yanlış sayısını belirler
          wrong: wrong,
          // Boş sayısını belirler
          blank: blank,
          // Neti belirler
          net: net,
        ),
      ],
    );
    // deneme bilgisini kaydeder
    await _repo!.saveExam(session);
    // exams bilgisini yükler
    await _loadExams();
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Ekranda kısa bilgilendirme mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        // Kısa bildirim mesajı oluşturur
        SnackBar(
          // Gösterilecek içeriği belirler
          content: Text('🌸 "$title" başarıyla eklendi!'),
          // Arka plan rengini belirler
          backgroundColor: GardenPalette.mossEmerald,
        ),
      );
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // doğru sayısı bilgisini hesaplayıp saklar
    final correct = int.tryParse(correctController.text);
    // yanlış sayısı bilgisini hesaplayıp saklar
    final wrong = int.tryParse(wrongController.text);
    // soru sayısı bilgisini hesaplayıp saklar
    final questionCount = int.tryParse(quickQuestionCountController.text) ?? 40;
    // is valid bilgisini iki değeri karşılaştırarak hesaplar
    final isValid = correct != null &&
        // Birden fazla koşulu birlikte kontrol eder
        wrong != null &&
        // net calculator.fits deneme nesnesini oluşturur
        NetCalculator.fitsExam(
          // Doğru sayısını belirler
          correct: correct,
          // Yanlış sayısını belirler
          wrong: wrong,
          // Soru sayısını belirler
          questionCount: questionCount,
        );
    // net bilgisini hesaplayıp saklar
    final net = isValid
        // Koşul doğruysa bu değeri kullanır
        ? NetCalculator.calculate(correct: correct, wrong: wrong)
        // Koşul yanlışsa bu değeri kullanır
        : null;
    // boş sayısı değerini koşula göre hesaplar
    final blank = isValid ? questionCount - correct - wrong : null;
    // Exam statistics
    // deneme sayı bilgisini hesaplayıp saklar
    final examCount = _exams.length;
    // max net bilgisini hesaplayıp saklar
    final maxNet = _exams.isNotEmpty
        // Koşul doğruysa bu değeri kullanır
        ? _exams.map((e) => e.totalNet).reduce((a, b) => a > b ? a : b)
        // Koşul yanlışsa bu değeri kullanır
        : 0.0;
    // avg net bilgisini hesaplayıp saklar
    final avgNet = _exams.isNotEmpty
        // Koşul doğruysa bu değeri kullanır
        ? _exams.map((e) => e.totalNet).reduce((a, b) => a + b) / examCount
        // Koşul yanlışsa bu değeri kullanır
        : 0.0;
    // Kaydırılabilir liste oluşturur
    return ListView(
      // İç boşlukları belirler
      padding: const EdgeInsets.all(16),
      // İçerideki widgetları listeler
      children: [
        // forest hero kart kartını oluşturur
        const ForestHeroCard(
          // görsel dosya yolu bilgisini belirler
          assetPath: GardenScenes.river,
          // tag bilgisini belirler
          tag: '📝 Deneme ve Netler',
          // Başlığı belirler
          title: 'Deneme Takip Masası',
          // Alt başlığı belirler
          subtitle: 'Her net, hedefine doğru akan berrak bir su gibi.',
          // Yüksekliği belirler
          height: 190,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // seed notice nesnesini oluşturur
        const SeedNotice(),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 12),
        // Stage selector
        // nature segmented control nesnesini oluşturur
        NatureSegmentedControl<String>(
          // Listelenecek öğeleri belirler
          items: const {
            // "TYT': 'TYT Denemeleri" metnini kullanır
            'TYT': 'TYT Denemeleri',
            // "AYT': 'AYT Denemeleri" metnini kullanır
            'AYT': 'AYT Denemeleri',
          },
          // seçili olma durumu bilgisini belirler
          selected: stage,
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (newStage) {
            // Değişen verileri arayüze bildirir
            setState(() => stage = newStage);
            // exams bilgisini yükler
            _loadExams();
          },
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 16),
        // Add exam primary button
        // golden action button nesnesini oluşturur
        GoldenActionButton(
          // Buton veya alan yazısını belirler
          label: 'Yeni $stage Denemesi Ekle',
          // simge bilgisini belirler
          icon: Icons.add_circle_outline,
          // Basılınca çalışacak fonksiyonu belirler
          onPressed: _openAddExam,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 16),
        // Statistics overview card
        // Belirtilen koşul doğruysa işlemi yapar
        if (examCount > 0)
          // garden kart kartını oluşturur
          GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // Ana eksendeki hizalamayı belirler
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // İçerideki widgetları listeler
              children: [
                // İlgili fonksiyonu çalıştırır
                _buildStat('Kayıtlı Deneme', '$examCount Adet',
                    // Temadan renk veya görünüm değeri alır
                    GardenPalette.mossEmerald),
                // stat bilgisini oluşturur
                _buildStat('Ortalama Net', avgNet.toStringAsFixed(2),
                    // Temadan renk veya görünüm değeri alır
                    GardenPalette.streamTurquoise),
                // stat bilgisini oluşturur
                _buildStat('En Yüksek Net', maxNet.toStringAsFixed(2),
                    // Temadan renk veya görünüm değeri alır
                    GardenPalette.harvestGold),
              ],
            ),
          ),
        // Belirtilen koşul doğruysa işlemi yapar
        if (examCount > 0) const SizedBox(height: 16),
        // Section header
        // botanical section header nesnesini oluşturur
        BotanicalSectionHeader(
          // Başlığı belirler
          title: '$stage Deneme Geçmişi',
          // Alt başlığı belirler
          subtitle: '$examCount deneme kaydı listeleniyor',
          // simge bilgisini belirler
          icon: Icons.history_edu_outlined,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 8),
        // Exam list or empty state
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
        else if (_exams.isEmpty)
          // garden kart kartını oluşturur
          GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              // İçine yerleştirilecek widgetı belirler
              child: Column(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.park_outlined,
                    // Boyutu belirler
                    size: 48,
                    // Rengi belirler
                    color: GardenPalette.mossEmerald.withAlpha(150),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 12),
                  // Metni ekranda gösterir
                  Text(
                    // "Henüz Kayıtlı $stage Denemen Yok" metnini kullanır
                    'Henüz Kayıtlı $stage Denemen Yok',
                    // Görünüm stilini belirler
                    style: const TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 16,
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 6),
                  // Metni ekranda gösterir
                  const Text(
                    // "İlk denemeni ekle; netlerinin berrak sular …" metnini kullanır
                    'İlk denemeni ekle; netlerinin berrak sular gibi adım adım yükselişini izle.',
                    // Yazıyı hizalar
                    textAlign: TextAlign.center,
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 16),
                  // garden primary button nesnesini oluşturur
                  GardenPrimaryButton(
                    // Buton veya alan yazısını belirler
                    label: 'İlk Denemeni Ekle',
                    // simge bilgisini belirler
                    icon: Icons.add,
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: _openAddExam,
                  ),
                ],
              ),
            ),
          )
        // Önceki koşul sağlanmazsa çalışır
        else
          // Öğeleri tek tek dönüştürür
          ..._exams.map((exam) => _buildExamCard(exam, isDark)),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 20),
        // Quick calculator header & card
        // botanical section header nesnesini oluşturur
        const BotanicalSectionHeader(
          // Başlığı belirler
          title: 'Hızlı Net Hesaplayıcı',
          // Alt başlığı belirler
          subtitle: 'Tek bir test veya branş netini anında hesapla ve kaydet',
          // simge bilgisini belirler
          icon: Icons.calculate_outlined,
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 8),
        // garden kart kartını oluşturur
        GardenCard(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçerideki widgetları listeler
            children: [
              // Metin giriş alanı oluşturur
              TextField(
                // Veriyi yöneten controllerı bağlar
                controller: quickTitleController,
                // Kutu ve kenarlık görünümünü belirler
                decoration: InputDecoration(
                  // Giriş alanının etiketini belirler
                  labelText: 'Branş / Deneme Başlığı',
                  // is dense bilgisini belirler
                  isDense: true,
                  // Kenarlığı belirler
                  border: OutlineInputBorder(
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 12),
              // Elemanları yan yana dizer
              Row(
                // İçerideki widgetları listeler
                children: [
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: TextField(
                      // Veriyi yöneten controllerı bağlar
                      controller: quickQuestionCountController,
                      // Klavye tipini belirler
                      keyboardType: TextInputType.number,
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: InputDecoration(
                        // Giriş alanının etiketini belirler
                        labelText: 'Soru Sayısı',
                        // is dense bilgisini belirler
                        isDense: true,
                        // Kenarlığı belirler
                        border: OutlineInputBorder(
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // Değer değişince çalışacak fonksiyonu belirler
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 10),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: GardenExamScoreField(
                      // Veriyi yöneten controllerı bağlar
                      controller: correctController,
                      // type bilgisini belirler
                      type: ScoreFieldType.correct,
                      // Değer değişince çalışacak fonksiyonu belirler
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 10),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: GardenExamScoreField(
                      // Veriyi yöneten controllerı bağlar
                      controller: wrongController,
                      // type bilgisini belirler
                      type: ScoreFieldType.wrong,
                      // Değer değişince çalışacak fonksiyonu belirler
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 14),
              // İlgili değer null ise kontrol eder
              if (net == null)
                // Görsel bir kutu oluşturur
                Container(
                  // İç boşlukları belirler
                  padding: const EdgeInsets.all(12),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: Colors.red.shade50,
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(12),
                    // Kenarlığı belirler
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // İçerideki widgetları listeler
                    children: [
                      // Simge gösterir
                      const Icon(Icons.error_outline,
                          // Rengi belirler
                          color: Colors.red, size: 20),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 8),
                      // Kalan boşluğu kullanacak alan oluşturur
                      Expanded(
                        // İçine yerleştirilecek widgetı belirler
                        child: Text(
                          // "0 veya pozitif sayı gir; doğru + yanlış en …" metnini kullanır
                          '0 veya pozitif sayı gir; doğru + yanlış en fazla $questionCount olabilir.',
                          // Görünüm stilini belirler
                          style: const TextStyle(
                            // Rengi belirler
                            color: Colors.redAccent,
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              // Önceki koşul sağlanmazsa çalışır
              else
                // Görsel bir kutu oluşturur
                Container(
                  // İç boşlukları belirler
                  padding:
                      // Yatay ve dikey boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: GardenPalette.mossEmerald.withAlpha(20),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(14),
                    // Kenarlığı belirler
                    border: Border.all(
                      // Rengi belirler
                      color: GardenPalette.mossEmerald.withAlpha(60),
                      // Genişliği belirler
                      width: 1.2,
                    ),
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // Ana eksendeki hizalamayı belirler
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // İçerideki widgetları listeler
                    children: [
                      // Metni ekranda gösterir
                      Text(
                        // "Net: ${net.toStringAsFixed(2)}  •  Boş: $blank" metnini kullanır
                        'Net: ${net.toStringAsFixed(2)}  •  Boş: $blank',
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 16,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: GardenPalette.inkPlum,
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
                          color: GardenPalette.mossEmerald,
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // İçine yerleştirilecek widgetı belirler
                        child: const Text(
                          // "Doğru Formül" metnini kullanır
                          'Doğru Formül',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Rengi belirler
                            color: Colors.white,
                            // Yazı boyutunu belirler
                            fontSize: 11,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 12),
              // garden primary button nesnesini oluşturur
              GardenPrimaryButton(
                // Buton veya alan yazısını belirler
                label: 'Bu Neti Denemelerime Ekle',
                // simge bilgisini belirler
                icon: Icons.save_outlined,
                // Basılınca çalışacak fonksiyonu belirler
                onPressed: net != null
                    // Koşul doğruysa bu değeri kullanır
                    ? () => _saveQuickExam(net, correct!, wrong!)
                    // Koşul yanlışsa bu değeri kullanır
                    : null,
              ),
            ],
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 16),
        // water info kart kartını oluşturur
        const WaterInfoCard(
          // Başlığı belirler
          title: 'Resmî YKS Net Formülü',
          // mesaj bilgisini belirler
          message:
              // "Net = Doğru - (Yanlış / 4). Her 4 yanlış 1 …" metnini kullanır
              'Net = Doğru - (Yanlış / 4). Her 4 yanlış 1 doğruyu götürür. Denemelerin yerel SQLite veri tabanında güvenle saklanır.',
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 32),
      ],
    );
  }
  // stat bilgisini oluşturur
  Widget _buildStat(String label, String value, Color color) {
    // Elemanları alt alta dizer
    return Column(
      // İçerideki widgetları listeler
      children: [
        // Metni ekranda gösterir
        Text(
          // İlgili değeri veya görünüm ayarını belirler
          value,
          // Görünüm stilini belirler
          style: TextStyle(
            // Yazı boyutunu belirler
            fontSize: 18,
            // Yazı kalınlığını belirler
            fontWeight: FontWeight.bold,
            // Rengi belirler
            color: color,
          ),
        ),
        // Sabit boyutlu veya boşluk bırakan alan oluşturur
        const SizedBox(height: 2),
        // Metni ekranda gösterir
        Text(
          // İlgili değeri veya görünüm ayarını belirler
          label,
          // Görünüm stilini belirler
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
  // deneme kart bilgisini oluşturur
  Widget _buildExamCard(ExamSession exam, bool isDark) {
    // tarih str değerini tanımlar
    final dateStr =
        // "${exam.occurredAt.day}.${exam.occurredAt.mo…" metnini kullanır
        '${exam.occurredAt.day}.${exam.occurredAt.month}.${exam.occurredAt.year}';
    // Görsel bir kutu oluşturur
    return Container(
      // Dış boşlukları belirler
      margin: const EdgeInsets.only(bottom: 12),
      // İçine yerleştirilecek widgetı belirler
      child: GardenCard(
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // Çapraz eksendeki hizalamayı belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // İçerideki widgetları listeler
          children: [
            // Elemanları yan yana dizer
            Row(
              // Çapraz eksendeki hizalamayı belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // İçerideki widgetları listeler
              children: [
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
                            padding: const EdgeInsets.symmetric(
                                // horizontal bilgisini belirler
                                horizontal: 8, vertical: 2),
                            // Kutu ve kenarlık görünümünü belirler
                            decoration: BoxDecoration(
                              // Rengi belirler
                              color: exam.scope == 'branch'
                                  // Koşul doğruysa bu değeri kullanır
                                  ? GardenPalette.peachCoral.withAlpha(35)
                                  // Koşul yanlışsa bu değeri kullanır
                                  : GardenPalette.mossEmerald.withAlpha(35),
                              // Köşelerin yuvarlaklığını belirler
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // İçine yerleştirilecek widgetı belirler
                            child: Text(
                              // Koşula göre iki değerden birini seçer
                              exam.scope == 'branch' ? 'Branş' : 'Genel',
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 11,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                                // Rengi belirler
                                color: exam.scope == 'branch'
                                    // Koşul doğruysa bu değeri kullanır
                                    ? GardenPalette.peachCoral
                                    // Koşul yanlışsa bu değeri kullanır
                                    : GardenPalette.mossEmerald,
                              ),
                            ),
                          ),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(width: 8),
                          // Metni ekranda gösterir
                          Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            dateStr,
                            // Görünüm stilini belirler
                            style: const TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 6),
                      // Metni ekranda gösterir
                      Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        exam.title,
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 16,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toplam Net Badge
                // Görsel bir kutu oluşturur
                Container(
                  // İç boşlukları belirler
                  padding:
                      // Yatay ve dikey boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Renk geçişini belirler
                    gradient: const LinearGradient(
                      // renkler bilgisini belirler
                      colors: [
                        // Temadan renk veya görünüm değeri alır
                        GardenPalette.mossEmerald,
                        // Temadan renk veya görünüm değeri alır
                        GardenPalette.streamTurquoise,
                      ],
                    ),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(14),
                    // Gölge ayarlarını belirler
                    boxShadow: [
                      // Kutuya gölge ayarı ekler
                      BoxShadow(
                        // Rengi belirler
                        color: GardenPalette.mossEmerald.withAlpha(60),
                        // Gölgenin konumunu belirler
                        offset: const Offset(0, 3),
                        // Gölgenin bulanıklığını belirler
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: Column(
                    // İçerideki widgetları listeler
                    children: [
                      // Metni ekranda gösterir
                      Text(
                        // string as fixed bilgisini dönüştürür
                        exam.totalNet.toStringAsFixed(2),
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 18,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.w900,
                          // Rengi belirler
                          color: Colors.white,
                        ),
                      ),
                      // Metni ekranda gösterir
                      const Text(
                        // "Net" metnini kullanır
                        'Net',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 10,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 12),
            // Scores overview
            // Elemanları yan yana dizer
            Row(
              // İçerideki widgetları listeler
              children: [
                // Metni ekranda gösterir
                Text(
                  // "${exam.totalCorrect} Doğru • ${exam.totalWr…" metnini kullanır
                  '${exam.totalCorrect} Doğru • ${exam.totalWrong} Yanlış • ${exam.totalBlank} Boş',
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 13,
                    // Rengi belirler
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // Elemanlar arasındaki boşluğu doldurur
                const Spacer(),
                // Simgeli buton oluşturur
                IconButton(
                  // simge bilgisini belirler
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  // tooltip bilgisini belirler
                  tooltip: 'Düzenle',
                  // Rengi belirler
                  color: GardenPalette.mossEmerald,
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: () => _openEditExam(exam),
                ),
                // Simgeli buton oluşturur
                IconButton(
                  // simge bilgisini belirler
                  icon: const Icon(Icons.delete_outline, size: 20),
                  // tooltip bilgisini belirler
                  tooltip: 'Sil',
                  // Rengi belirler
                  color: Colors.redAccent,
                  // Basılınca çalışacak fonksiyonu belirler
                  onPressed: () => _confirmDeleteExam(exam),
                ),
              ],
            ),
            // Ders bazlı skor dökümü
            // Liste veya metin doluysa bu koşul çalışır
            if (exam.scores.isNotEmpty) ...[
              // Ayırıcı çizgi gösterir
              const Divider(height: 16),
              // Öğeleri sığmadıkça alt satıra geçirir
              Wrap(
                // spacing bilgisini belirler
                spacing: 8,
                // run spacing bilgisini belirler
                runSpacing: 6,
                // İçerideki widgetları listeler
                children: exam.scores.map((s) {
                  // Görsel bir kutu oluşturur
                  return Container(
                    // İç boşlukları belirler
                    padding:
                        // Yatay ve dikey boşlukları belirler
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: isDark
                          // Koşul doğruysa bu değeri kullanır
                          ? Colors.white10
                          // Koşul yanlışsa bu değeri kullanır
                          : GardenPalette.sandyPorcelain,
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(8),
                      // Kenarlığı belirler
                      border: Border.all(color: Colors.grey.withAlpha(40)),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // "${s.subjectName}: ${s.net.toStringAsFixed(1…" metnini kullanır
                      '${s.subjectName}: ${s.net.toStringAsFixed(1)}N (${s.correct}D ${s.wrong}Y)',
                      // Görünüm stilini belirler
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                // Sonuçları listeye çevirir
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

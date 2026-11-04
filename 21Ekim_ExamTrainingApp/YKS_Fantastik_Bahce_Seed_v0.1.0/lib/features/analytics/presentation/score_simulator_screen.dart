// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden scenes dosyasını kullanıma ekler
import '../../../core/assets/garden_scenes.dart';
// database provider dosyasını kullanıma ekler
import '../../../core/database/database_provider.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// score simulation dosyasını kullanıma ekler
import '../../../domain/models/score_simulation.dart';
// deneme repository dosyasını kullanıma ekler
import '../../../domain/repositories/exam_repository.dart';
// score simulator dosyasını kullanıma ekler
import '../../../domain/services/score_simulator.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// seed notice dosyasını kullanıma ekler
import '../../../shared/widgets/seed_notice.dart';
// score simulator ekran için değişen verileri yöneten StatefulWidget kullanılır
class ScoreSimulatorScreen extends StatefulWidget {
  // score simulator ekran sayfasını gösterir
  const ScoreSimulatorScreen({
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // deneme repository bilgisini isteğe bağlı alır
    this.examRepository,
    // simulator bilgisini isteğe bağlı alır
    this.simulator = const ScoreSimulator(),
  });
  // deneme repository bilgisini tutar
  final ExamRepository? examRepository;
  // simulator bilgisini tutar
  final ScoreSimulator simulator;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<ScoreSimulatorScreen> createState() => _ScoreSimulatorScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _ScoreSimulatorScreenState extends State<ScoreSimulatorScreen> {
  // İlgili değeri veya görünüm ayarını belirler
  ExamRepository? _examRepo;
  // İlgili değeri veya görünüm ayarını belirler
  SimulationInput _input = const SimulationInput(
    // field bilgisini belirler
    field: SimulationField.sayisal,
    // tyt turkce bilgisini belirler
    tytTurkce: 28.0,
    // tyt matematik bilgisini belirler
    tytMatematik: 25.0,
    // tyt sosyal bilgisini belirler
    tytSosyal: 13.0,
    // tyt fen bilgisini belirler
    tytFen: 12.0,
    // ayt matematik bilgisini belirler
    aytMatematik: 22.0,
    // ayt fizik bilgisini belirler
    aytFizik: 8.0,
    // ayt kimya bilgisini belirler
    aytKimya: 7.0,
    // ayt biyoloji bilgisini belirler
    aytBiyoloji: 8.0,
    // diploma grade bilgisini belirler
    diplomaGrade: 85.0,
  );
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // repo bilgisini başlatır
    _initRepo();
  }
  // repo bilgisini başlatır
  Future<void> _initRepo() async {
    // Hata oluşturabilecek işlemleri dener
    try {
      // İlgili değer null değilse kontrol eder
      if (widget.examRepository != null) {
        // deneme repo değerini günceller
        _examRepo = widget.examRepository;
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // veritabanı verisini asenkron işlemin sonucundan alır
        final db = await GardenDatabaseProvider.instance.database;
        // deneme repository işlemini yapar
        _examRepo = ExamRepository(db);
      }
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {}
  }
  // latest deneme nets bilgisini yükler
  Future<void> _loadLatestExamNets() async {
    // İlgili değer null ise kontrol eder
    if (_examRepo == null) return;
    // tyt exams verisini asenkron işlemin sonucundan alır
    final tytExams = await _examRepo!.getExams(stage: 'TYT');
    // ayt exams verisini asenkron işlemin sonucundan alır
    final aytExams = await _examRepo!.getExams(stage: 'AYT');
    // tyt turkce bilgisini hesaplayıp saklar
    double tytTurkce = _input.tytTurkce;
    // tyt mat bilgisini hesaplayıp saklar
    double tytMat = _input.tytMatematik;
    // tyt sos bilgisini hesaplayıp saklar
    double tytSos = _input.tytSosyal;
    // tyt fen bilgisini hesaplayıp saklar
    double tytFen = _input.tytFen;
    // Liste veya metin doluysa bu koşul çalışır
    if (tytExams.isNotEmpty) {
      // latest tyt bilgisini hesaplayıp saklar
      final latestTyt = tytExams.first;
      // Listedeki öğeleri tek tek dolaşır
      for (final sub in latestTyt.scores) {
        // net bilgisini hesaplayıp saklar
        final net = sub.net;
        // ad bilgisini hesaplayıp saklar
        final name = sub.subjectName.toLowerCase();
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('türkçe')) tytTurkce = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('matematik')) tytMat = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('sosyal')) tytSos = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('fen')) tytFen = net;
      }
    }
    // ayt mat bilgisini hesaplayıp saklar
    double aytMat = _input.aytMatematik;
    // ayt fiz bilgisini hesaplayıp saklar
    double aytFiz = _input.aytFizik;
    // ayt kim bilgisini hesaplayıp saklar
    double aytKim = _input.aytKimya;
    // ayt bio bilgisini hesaplayıp saklar
    double aytBio = _input.aytBiyoloji;
    // ayt edb bilgisini hesaplayıp saklar
    double aytEdb = _input.aytEdebiyat;
    // ayt tar bilgisini hesaplayıp saklar
    double aytTar = _input.aytTarih1;
    // ayt cog bilgisini hesaplayıp saklar
    double aytCog = _input.aytCografya1;
    // Liste veya metin doluysa bu koşul çalışır
    if (aytExams.isNotEmpty) {
      // latest ayt bilgisini hesaplayıp saklar
      final latestAyt = aytExams.first;
      // Listedeki öğeleri tek tek dolaşır
      for (final sub in latestAyt.scores) {
        // net bilgisini hesaplayıp saklar
        final net = sub.net;
        // ad bilgisini hesaplayıp saklar
        final name = sub.subjectName.toLowerCase();
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('matematik')) aytMat = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('fizik')) aytFiz = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('kimya')) aytKim = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('biyoloji')) aytBio = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('edebiyat')) aytEdb = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('tarih')) aytTar = net;
        // Belirtilen koşul doğruysa işlemi yapar
        if (name.contains('coğrafya')) aytCog = net;
      }
    }
    // Değişen verileri arayüze bildirir
    setState(() {
      // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
      _input = _input.copyWith(
        // tyt turkce bilgisini belirler
        tytTurkce: tytTurkce,
        // tyt matematik bilgisini belirler
        tytMatematik: tytMat,
        // tyt sosyal bilgisini belirler
        tytSosyal: tytSos,
        // tyt fen bilgisini belirler
        tytFen: tytFen,
        // ayt matematik bilgisini belirler
        aytMatematik: aytMat,
        // ayt fizik bilgisini belirler
        aytFizik: aytFiz,
        // ayt kimya bilgisini belirler
        aytKimya: aytKim,
        // ayt biyoloji bilgisini belirler
        aytBiyoloji: aytBio,
        // ayt edebiyat bilgisini belirler
        aytEdebiyat: aytEdb,
        // ayt tarih1 bilgisini belirler
        aytTarih1: aytTar,
        // ayt cografya1 bilgisini belirler
        aytCografya1: aytCog,
      );
    });
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Ekranda kısa bilgilendirme mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        // Kısa bildirim mesajı oluşturur
        const SnackBar(
          // Gösterilecek içeriği belirler
          content: Text('⚡ Son denemelerindeki netler simülatöre yüklendi.'),
          // Animasyonun süresini belirler
          duration: Duration(seconds: 2),
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
    // sonuç bilgisini hesaplayıp saklar
    final result = widget.simulator.simulate(_input);
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: const Text('YKS Puan & Sıralama Simülatörü'),
        // Arka plan rengini belirler
        backgroundColor: Colors.transparent,
        // Gölge yüksekliğini belirler
        elevation: 0,
      ),
      // Sayfanın ana içeriğini belirler
      body: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // İçerideki widgetları listeler
        children: [
          // forest hero kart kartını oluşturur
          ForestHeroCard(
            // görsel dosya yolu bilgisini belirler
            assetPath: GardenScenes.rainbow,
            // tag bilgisini belirler
            tag: '🎯 YKS ${ScoreSimulator.curriculumYear} Puan Tahmini',
            // Başlığı belirler
            title: 'Puan & OBP Simülatörü',
            // Alt başlığı belirler
            subtitle:
                // "ÖSYM kılavuz ağırlıklarına dayalı yerleştir…" metnini kullanır
                'ÖSYM kılavuz ağırlıklarına dayalı yerleştirme ve ham puan tahmini.',
            // Yüksekliği belirler
            height: 200,
            // action label bilgisini belirler
            actionLabel: 'Denemelerimden Yükle ⚡',
            // on action olayındaki fonksiyonu belirler
            onAction: _loadLatestExamNets,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // seed notice nesnesini oluşturur
          const SeedNotice(),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // Yasal ve Metodoloji Sınırlılık Uyarısı
          // water info kart kartını oluşturur
          WaterInfoCard(
            // Başlığı belirler
            title: 'Resmî Sınav Bilgilendirmesi',
            // mesaj bilgisini belirler
            message: result.disclaimer,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // Canlı Sonuç Kartı
          // golden achievement kart kartını oluşturur
          GoldenAchievementCard(
            // Başlığı belirler
            title:
                // "Yerleştirme Puanı: ${result.placementScore.…" metnini kullanır
                'Yerleştirme Puanı: ${result.placementScore.toStringAsFixed(2)}',
            // Alt başlığı belirler
            subtitle:
                // "${result.field.title} Ham: ${result.fieldRa…" metnini kullanır
                '${result.field.title} Ham: ${result.fieldRawScore.toStringAsFixed(2)} • TYT Ham: ${result.tytScore.toStringAsFixed(2)}',
            // badge metin bilgisini belirler
            badgeText: '+${result.obpContribution.toStringAsFixed(1)} OBP',
            // simge bilgisini belirler
            icon: Icons.auto_awesome,
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // Alan Seçici
          // botanical section header nesnesini oluşturur
          const BotanicalSectionHeader(
            // Başlığı belirler
            title: 'Hedef Puan Türü',
            // Alt başlığı belirler
            subtitle: 'Hesaplanacak YKS alanını seç',
            // simge bilgisini belirler
            icon: Icons.category_outlined,
          ),
          // nature segmented control nesnesini oluşturur
          NatureSegmentedControl<SimulationField>(
            // Listelenecek öğeleri belirler
            items: const {
              // İlgili değeri veya görünüm ayarını belirler
              SimulationField.sayisal: 'Sayısal',
              // İlgili değeri veya görünüm ayarını belirler
              SimulationField.esitAgirlik: 'Eşit Ağırlık',
              // İlgili değeri veya görünüm ayarını belirler
              SimulationField.sozel: 'Sözel',
              // İlgili değeri veya görünüm ayarını belirler
              SimulationField.tytOnly: 'TYT',
            },
            // seçili olma durumu bilgisini belirler
            selected: _input.field,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (field) =>
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(field: field)),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // OBP ve Diploma Notu Ayarları
          // obp kart bilgisini oluşturur
          _buildObpCard(isDark, result),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // TYT Netleri Bölümü
          // botanical section header nesnesini oluşturur
          BotanicalSectionHeader(
            // Başlığı belirler
            title:
                // "TYT Netleri (Toplam: ${_input.totalTytNet.t…" metnini kullanır
                'TYT Netleri (Toplam: ${_input.totalTytNet.toStringAsFixed(1)} Net)',
            // Alt başlığı belirler
            subtitle: '120 Soru Üzerinden Net Dağılımı',
            // simge bilgisini belirler
            icon: Icons.checklist_outlined,
          ),
          // garden kart kartını oluşturur
          GardenCard(
            // İçine yerleştirilecek widgetı belirler
            child: Column(
              // İçerideki widgetları listeler
              children: [
                // net slider bilgisini oluşturur
                _buildNetSlider('Türkçe (40 Soru)', _input.tytTurkce, 40.0,
                    // Yeni değer veya liste oluşturur
                    (v) {
                  // Değişen verileri arayüze bildirir
                  setState(() => _input = _input.copyWith(tytTurkce: v));
                }),
                // Ayırıcı çizgi gösterir
                const Divider(),
                // İlgili fonksiyonu çalıştırır
                _buildNetSlider(
                    // "Temel Matematik (40 Soru)', _input.tytMatem…" metnini kullanır
                    'Temel Matematik (40 Soru)', _input.tytMatematik, 40.0,
                    // Yeni değer veya liste oluşturur
                    (v) {
                  // Değişen verileri arayüze bildirir
                  setState(() => _input = _input.copyWith(tytMatematik: v));
                }),
                // Ayırıcı çizgi gösterir
                const Divider(),
                // İlgili fonksiyonu çalıştırır
                _buildNetSlider(
                    // "Sosyal Bilimler (20 Soru)', _input.tytSosya…" metnini kullanır
                    'Sosyal Bilimler (20 Soru)', _input.tytSosyal, 20.0, (v) {
                  // Değişen verileri arayüze bildirir
                  setState(() => _input = _input.copyWith(tytSosyal: v));
                }),
                // Ayırıcı çizgi gösterir
                const Divider(),
                // net slider bilgisini oluşturur
                _buildNetSlider('Fen Bilimleri (20 Soru)', _input.tytFen, 20.0,
                    // Yeni değer veya liste oluşturur
                    (v) {
                  // Değişen verileri arayüze bildirir
                  setState(() => _input = _input.copyWith(tytFen: v));
                }),
              ],
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 16),
          // AYT Netleri (Seçili Alana Göre)
          // Belirtilen koşul doğruysa işlemi yapar
          if (_input.field != SimulationField.tytOnly) ...[
            // botanical section header nesnesini oluşturur
            BotanicalSectionHeader(
              // Başlığı belirler
              title: 'AYT Netleri (${_input.field.title})',
              // Alt başlığı belirler
              subtitle: 'Alanına Özel Soru Grupları',
              // simge bilgisini belirler
              icon: Icons.assignment_outlined,
            ),
            // ayt inputs kart bilgisini oluşturur
            _buildAytInputsCard(),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
  // obp kart bilgisini oluşturur
  Widget _buildObpCard(bool isDark, SimulationResult result) {
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
            // Ana eksendeki hizalamayı belirler
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              const Text(
                // "🎓 Diploma Notu (OBP)" metnini kullanır
                '🎓 Diploma Notu (OBP)',
                // Görünüm stilini belirler
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              // Metni ekranda gösterir
              Text(
                // "${_input.diplomaGrade.toStringAsFixed(1)} /…" metnini kullanır
                '${_input.diplomaGrade.toStringAsFixed(1)} / 100',
                // Görünüm stilini belirler
                style: const TextStyle(
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.bold,
                  // Rengi belirler
                  color: GardenPalette.mossEmerald,
                ),
              ),
            ],
          ),
          // Kaydırılarak değer seçilen alan oluşturur
          Slider(
            // Kullanılacak değeri belirler
            value: _input.diplomaGrade,
            // min bilgisini belirler
            min: 50.0,
            // max bilgisini belirler
            max: 100.0,
            // divisions bilgisini belirler
            divisions: 50,
            // Etkin durum rengini belirler
            activeColor: GardenPalette.mossEmerald,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (val) =>
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(diplomaGrade: val)),
          ),
          // Elemanları yan yana dizer
          Row(
            // Ana eksendeki hizalamayı belirler
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // İçerideki widgetları listeler
            children: [
              // Metni ekranda gösterir
              Text(
                // "OBP Puanı: ${result.obpScore.toStringAsFixe…" metnini kullanır
                'OBP Puanı: ${result.obpScore.toStringAsFixed(1)} (Katkı: +${result.obpContribution.toStringAsFixed(1)})',
                // Görünüm stilini belirler
                style: TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 12,
                  // Rengi belirler
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
          // Ayırıcı çizgi gösterir
          const Divider(height: 20),
          // switch list tile öğesini gösterir
          SwitchListTile(
            // content padding bilgisini belirler
            contentPadding: EdgeInsets.zero,
            // Başlığı belirler
            title: const Text(
              // "Önceki yıl yerleştim (Kırık OBP)" metnini kullanır
              'Önceki yıl yerleştim (Kırık OBP)',
              // Görünüm stilini belirler
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            // Alt başlığı belirler
            subtitle: const Text(
              // "OBP katsayısı 0.12 yerine 0.06 olarak yarıy…" metnini kullanır
              'OBP katsayısı 0.12 yerine 0.06 olarak yarıya iner.',
              // Görünüm stilini belirler
              style: TextStyle(fontSize: 11),
            ),
            // Kullanılacak değeri belirler
            value: _input.isPreviousYearPlaced,
            // active track renk bilgisini belirler
            activeTrackColor: GardenPalette.mossEmerald,
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (val) => setState(
                // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
                () => _input = _input.copyWith(isPreviousYearPlaced: val)),
          ),
        ],
      ),
    );
  }
  // ayt inputs kart bilgisini oluşturur
  Widget _buildAytInputsCard() {
    // Değere göre uygun durumu seçer
    switch (_input.field) {
      // simulation field.sayisal durumu için çalışır
      case SimulationField.sayisal:
        // garden kart kartını oluşturur
        return GardenCard(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // İçerideki widgetları listeler
            children: [
              // İlgili fonksiyonu çalıştırır
              _buildNetSlider(
                  // "AYT Matematik (40 Soru)', _input.aytMatemat…" metnini kullanır
                  'AYT Matematik (40 Soru)', _input.aytMatematik, 40.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytMatematik: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Fizik (14 Soru)', _input.aytFizik, 14.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytFizik: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Kimya (13 Soru)', _input.aytKimya, 13.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytKimya: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Biyoloji (13 Soru)', _input.aytBiyoloji, 13.0,
                  // Yeni değer veya liste oluşturur
                  (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytBiyoloji: v));
              }),
            ],
          ),
        );
      // simulation field.esit agirlik durumu için çalışır
      case SimulationField.esitAgirlik:
        // garden kart kartını oluşturur
        return GardenCard(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // İçerideki widgetları listeler
            children: [
              // İlgili fonksiyonu çalıştırır
              _buildNetSlider(
                  // "AYT Matematik (40 Soru)', _input.aytMatemat…" metnini kullanır
                  'AYT Matematik (40 Soru)', _input.aytMatematik, 40.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytMatematik: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // İlgili fonksiyonu çalıştırır
              _buildNetSlider(
                  // "Türk Dili ve Edb. (24 Soru)', _input.aytEde…" metnini kullanır
                  'Türk Dili ve Edb. (24 Soru)', _input.aytEdebiyat, 24.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytEdebiyat: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Tarih-1 (10 Soru)', _input.aytTarih1, 10.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytTarih1: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Coğrafya-1 (6 Soru)', _input.aytCografya1, 6.0,
                  // Yeni değer veya liste oluşturur
                  (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytCografya1: v));
              }),
            ],
          ),
        );
      // simulation field.sozel durumu için çalışır
      case SimulationField.sozel:
        // garden kart kartını oluşturur
        return GardenCard(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // İçerideki widgetları listeler
            children: [
              // İlgili fonksiyonu çalıştırır
              _buildNetSlider(
                  // "Türk Dili ve Edb. (24 Soru)', _input.aytEde…" metnini kullanır
                  'Türk Dili ve Edb. (24 Soru)', _input.aytEdebiyat, 24.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytEdebiyat: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Tarih-1 (10 Soru)', _input.aytTarih1, 10.0, (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytTarih1: v));
              }),
              // Ayırıcı çizgi gösterir
              const Divider(),
              // net slider bilgisini oluşturur
              _buildNetSlider('Coğrafya-1 (6 Soru)', _input.aytCografya1, 6.0,
                  // Yeni değer veya liste oluşturur
                  (v) {
                // Değişen verileri arayüze bildirir
                setState(() => _input = _input.copyWith(aytCografya1: v));
              }),
            ],
          ),
        );
      // simulation field.tyt only durumu için çalışır
      case SimulationField.tytOnly:
        // sized box.shrink nesnesini oluşturur
        return const SizedBox.shrink();
    }
  }
  // net slider bilgisini oluşturur
  Widget _buildNetSlider(
    // İlgili değeri veya görünüm ayarını belirler
    String label,
    // İlgili değeri veya görünüm ayarını belirler
    double value,
    // İlgili değeri veya görünüm ayarını belirler
    double max,
    // Değerleri karşılaştırır
    ValueChanged<double> onChanged,
  ) {
    // Elemanları alt alta dizer
    return Column(
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
            // Metni ekranda gösterir
            Text(label,
                // Görünüm stilini belirler
                style:
                    // Yazının görünümünü ayarlar
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            // Metni ekranda gösterir
            Text(
              // "${value.toStringAsFixed(1)} Net" metnini kullanır
              '${value.toStringAsFixed(1)} Net',
              // Görünüm stilini belirler
              style: const TextStyle(
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Rengi belirler
                color: GardenPalette.mossEmerald,
              ),
            ),
          ],
        ),
        // Kaydırılarak değer seçilen alan oluşturur
        Slider(
          // Kullanılacak değeri belirler
          value: value.clamp(0.0, max),
          // min bilgisini belirler
          min: 0.0,
          // max bilgisini belirler
          max: max,
          // divisions bilgisini belirler
          divisions: (max * 4).toInt(), // 0.25'lik adımlar
          // Etkin durum rengini belirler
          activeColor: GardenPalette.mossEmerald,
          // Değer değişince çalışacak fonksiyonu belirler
          onChanged: (v) => onChanged((v * 4).round() / 4),
        ),
      ],
    );
  }
}

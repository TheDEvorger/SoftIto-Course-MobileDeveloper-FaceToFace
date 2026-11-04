// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// net calculator dosyasını kullanıma ekler
import '../../../domain/exam/net_calculator.dart';
// deneme record dosyasını kullanıma ekler
import '../../../domain/models/exam_record.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// garden inputs dosyasını kullanıma ekler
import '../../../shared/widgets/garden_inputs.dart';
// ders entry data bilgilerini veya işlemlerini tutan sınıf
class SubjectEntryData {
  // ders entry data verisi oluşturur
  SubjectEntryData({
    // ders ID bilgisini zorunlu tutar
    required this.subjectId,
    // ders adı bilgisini zorunlu tutar
    required this.subjectName,
    // soru sayısı bilgisini zorunlu tutar
    required this.questionCount,
    // initial correct için başlangıç sayısını belirler
    int initialCorrect = 0,
    // initial wrong için başlangıç sayısını belirler
    int initialWrong = 0,
  // İlgili değeri veya görünüm ayarını belirler
  })  : correctController =
            // metin editing controller nesnesini oluşturur
            TextEditingController(text: initialCorrect.toString()),
        // metin editing controller işlemini yapar
        wrongController = TextEditingController(text: initialWrong.toString());
  // ders ID bilgisini tutar
  final String subjectId;
  // ders adı bilgisini tutar
  final String subjectName;
  // soru sayısı bilgisini tutar
  final int questionCount;
  // correct controller bilgisini tutar
  final TextEditingController correctController;
  // wrong controller bilgisini tutar
  final TextEditingController wrongController;
  // doğru sayısı işlemini yapar
  int get correct => int.tryParse(correctController.text) ?? 0;
  // yanlış sayısı işlemini yapar
  int get wrong => int.tryParse(wrongController.text) ?? 0;
  // valid bilgisini kontrol eder
  bool get isValid =>
      // net calculator.fits deneme nesnesini oluşturur
      NetCalculator.fitsExam(
        // Doğru sayısını belirler
        correct: correct,
        // Yanlış sayısını belirler
        wrong: wrong,
        // Soru sayısını belirler
        questionCount: questionCount,
      // Birden fazla koşulu birlikte kontrol eder
      ) &&
      // Birden fazla koşulu birlikte kontrol eder
      correct >= 0 &&
      // İlgili değeri veya görünüm ayarını belirler
      wrong >= 0;
  // boş sayısı işlemini yapar
  int get blank =>
      // Değeri belirtilen aralıkta sınırlar
      isValid ? (questionCount - correct - wrong).clamp(0, questionCount) : 0;
  // net işlemini yapar
  double get net =>
      // Koşula göre iki değerden birini seçer
      isValid ? NetCalculator.calculate(correct: correct, wrong: wrong) : 0.0;
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    correctController.dispose();
    // Kullanılan kaynakları temizler
    wrongController.dispose();
  }
}
// deneme entry pencere için değişen verileri yöneten StatefulWidget kullanılır
class ExamEntryDialog extends StatefulWidget {
  // deneme entry pencere penceresini oluşturur
  const ExamEntryDialog({
    // existing session bilgisini isteğe bağlı alır
    this.existingSession,
    // initial stage bilgisini isteğe bağlı alır
    this.initialStage = 'TYT',
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // existing session bilgisini tutar
  final ExamSession? existingSession;
  // initial stage bilgisini tutar
  final String initialStage;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<ExamEntryDialog> createState() => _ExamEntryDialogState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _ExamEntryDialogState extends State<ExamEntryDialog> {
  // title controller bilgisini tutar
  late TextEditingController _titleController;
  // seçilen tarih bilgisini tutar
  late DateTime _selectedDate;
  // aşama bilgisini tutar
  late String _stage;
  // Hesaplamada kullanılacak sayısal değeri belirler
  late String _scope; // 'general' or 'branch'
  // ders entries bilgisini tutar
  late List<SubjectEntryData> _subjectEntries;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // session bilgisini hesaplayıp saklar
    final session = widget.existingSession;
    // title controller değerini günceller
    _titleController = TextEditingController(
      // Gösterilecek metni belirler
      text: session?.title ?? '',
    );
    // Güncel tarih ve saati alır
    _selectedDate = session?.occurredAt ?? DateTime.now();
    // Değer null ise varsayılanı kullanır
    _stage = session?.stage ?? widget.initialStage;
    // Değer null ise varsayılanı kullanır
    _scope = session?.scope ?? 'general';
    // ders entries bilgisini başlatır
    _initSubjectEntries(session);
  }
  // ders entries bilgisini başlatır
  void _initSubjectEntries(ExamSession? session) {
    // Belirtilen koşul doğruysa işlemi yapar
    if (_scope == 'branch') {
      // initial score değerini tanımlar
      final initialScore =
          // Liste veya metnin dolu olup olmadığını kontrol eder
          session?.scores.isNotEmpty == true ? session!.scores.first : null;
      // ders entries değerini günceller
      _subjectEntries = [
        // ders entry data verisi oluşturur
        SubjectEntryData(
          // Ders ID bilgisini belirler
          subjectId: initialScore?.subjectId ??
              // Yeni değer veya liste oluşturur
              (_stage == 'TYT' ? 'tyt_turkce' : 'ayt_mat'),
          // ders adı bilgisini belirler
          subjectName: initialScore?.subjectName ??
              // Yeni değer veya liste oluşturur
              (_stage == 'TYT' ? 'Türkçe' : 'Matematik'),
          // Soru sayısını belirler
          questionCount: 40,
          // initial correct bilgisini belirler
          initialCorrect: initialScore?.correct ?? 0,
          // initial wrong bilgisini belirler
          initialWrong: initialScore?.wrong ?? 0,
        ),
      ];
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // General Exam
      // Belirtilen koşul doğruysa işlemi yapar
      if (_stage == 'TYT') {
        // score map bilgisini hesaplayıp saklar
        final scoreMap = {
          // Listedeki öğeleri tek tek dolaşır
          for (final s in session?.scores ?? <ExamScore>[]) s.subjectId: s,
        };
        // ders entries değerini günceller
        _subjectEntries = [
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'tyt_turkce',
            // ders adı bilgisini belirler
            subjectName: 'Türkçe',
            // Soru sayısını belirler
            questionCount: 40,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['tyt_turkce']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['tyt_turkce']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'tyt_mat',
            // ders adı bilgisini belirler
            subjectName: 'Temel Matematik',
            // Soru sayısını belirler
            questionCount: 40,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['tyt_mat']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['tyt_mat']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'tyt_sosyal',
            // ders adı bilgisini belirler
            subjectName: 'Sosyal Bilimler',
            // Soru sayısını belirler
            questionCount: 20,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['tyt_sosyal']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['tyt_sosyal']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'tyt_fen',
            // ders adı bilgisini belirler
            subjectName: 'Fen Bilimleri',
            // Soru sayısını belirler
            questionCount: 20,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['tyt_fen']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['tyt_fen']?.wrong ?? 0,
          ),
        ];
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // AYT General (Sayısal + EA ortak ders havuzu)
        // score map bilgisini hesaplayıp saklar
        final scoreMap = {
          // Listedeki öğeleri tek tek dolaşır
          for (final s in session?.scores ?? <ExamScore>[]) s.subjectId: s,
        };
        // ders entries değerini günceller
        _subjectEntries = [
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_mat',
            // ders adı bilgisini belirler
            subjectName: 'Matematik',
            // Soru sayısını belirler
            questionCount: 40,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_mat']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_mat']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_fizik',
            // ders adı bilgisini belirler
            subjectName: 'Fizik',
            // Soru sayısını belirler
            questionCount: 14,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_fizik']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_fizik']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_kimya',
            // ders adı bilgisini belirler
            subjectName: 'Kimya',
            // Soru sayısını belirler
            questionCount: 13,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_kimya']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_kimya']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_biyo',
            // ders adı bilgisini belirler
            subjectName: 'Biyoloji',
            // Soru sayısını belirler
            questionCount: 13,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_biyo']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_biyo']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_edebiyat',
            // ders adı bilgisini belirler
            subjectName: 'Edebiyat',
            // Soru sayısını belirler
            questionCount: 24,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_edebiyat']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_edebiyat']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_tarih1',
            // ders adı bilgisini belirler
            subjectName: 'Tarih-1',
            // Soru sayısını belirler
            questionCount: 10,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_tarih1']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_tarih1']?.wrong ?? 0,
          ),
          // ders entry data verisi oluşturur
          SubjectEntryData(
            // Ders ID bilgisini belirler
            subjectId: 'ayt_cografya1',
            // ders adı bilgisini belirler
            subjectName: 'Coğrafya-1',
            // Soru sayısını belirler
            questionCount: 6,
            // initial correct bilgisini belirler
            initialCorrect: scoreMap['ayt_cografya1']?.correct ?? 0,
            // initial wrong bilgisini belirler
            initialWrong: scoreMap['ayt_cografya1']?.wrong ?? 0,
          ),
        ];
      }
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    _titleController.dispose();
    // Listedeki öğeleri tek tek dolaşır
    for (final e in _subjectEntries) {
      // Kullanılan kaynakları temizler
      e.dispose();
    }
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // stage or scope changed bilgisini işler
  void _onStageOrScopeChanged(String newStage, String newScope) {
    // Listedeki öğeleri tek tek dolaşır
    for (final e in _subjectEntries) {
      // Kullanılan kaynakları temizler
      e.dispose();
    }
    // Değişen verileri arayüze bildirir
    setState(() {
      // aşama değerini günceller
      _stage = newStage;
      // scope değerini günceller
      _scope = newScope;
      // ders entries bilgisini başlatır
      _initSubjectEntries(null);
    });
  }
  // pick tarih işlemini yapar
  Future<void> _pickDate() async {
    // picked verisini asenkron işlemin sonucundan alır
    final picked = await showDatePicker(
      // context bilgisini belirler
      context: context,
      // Başlangıç tarihini belirler
      initialDate: _selectedDate,
      // Seçilebilecek ilk tarihi belirler
      firstDate: DateTime(2020),
      // Seçilebilecek son tarihi belirler
      lastDate: DateTime(2035),
    );
    // İlgili değer null değilse kontrol eder
    if (picked != null) {
      // Değişen verileri arayüze bildirir
      setState(() => _selectedDate = picked);
    }
  }
  // all valid bilgisini kontrol eder
  bool get _isAllValid {
    // Liste veya metin boşsa bu koşul çalışır
    if (_titleController.text.trim().isEmpty) return false;
    // Listedeki öğeleri tek tek dolaşır
    for (final e in _subjectEntries) {
      // Belirtilen koşul doğruysa işlemi yapar
      if (!e.isValid) return false;
    }
    // Açık kapalı durumunu belirler
    return true;
  }
  // submit işlemini yapar
  void _submit() {
    // Belirtilen koşul doğruysa işlemi yapar
    if (!_isAllValid) return;
    // deneme ID bilgisini hesaplayıp saklar
    final examId = widget.existingSession?.id ??
        // Güncel tarih ve saati alır
        'exam_${DateTime.now().millisecondsSinceEpoch}';
    // toplam correct için başlangıç sayısını belirler
    var totalCorrect = 0;
    // toplam wrong için başlangıç sayısını belirler
    var totalWrong = 0;
    // toplam blank için başlangıç sayısını belirler
    var totalBlank = 0;
    // toplam net için başlangıç sayısını belirler
    var totalNet = 0.0;
    // scores için boş koleksiyon oluşturur
    final scores = <ExamScore>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final e in _subjectEntries) {
      // toplam correct değerine yeni miktarı ekler
      totalCorrect += e.correct;
      // toplam wrong değerine yeni miktarı ekler
      totalWrong += e.wrong;
      // toplam blank değerine yeni miktarı ekler
      totalBlank += e.blank;
      // toplam net değerine yeni miktarı ekler
      totalNet += e.net;
      // İlgili fonksiyonu çalıştırır
      scores.add(
        // deneme score nesnesini oluşturur
        ExamScore(
          // ID bilgisini belirler
          id: '${examId}_${e.subjectId}',
          // Deneme ID bilgisini belirler
          examId: examId,
          // Ders ID bilgisini belirler
          subjectId: e.subjectId,
          // ders adı bilgisini belirler
          subjectName: e.subjectName,
          // Doğru sayısını belirler
          correct: e.correct,
          // Yanlış sayısını belirler
          wrong: e.wrong,
          // Boş sayısını belirler
          blank: e.blank,
          // Neti belirler
          net: e.net,
        ),
      );
    }
    // session bilgisini hesaplayıp saklar
    final session = ExamSession(
      // ID bilgisini belirler
      id: examId,
      // Öğrenme veya sınav aşamasını belirler
      stage: _stage,
      // Başlığı belirler
      title: _titleController.text.trim(),
      // occurred at bilgisini belirler
      occurredAt: _selectedDate,
      // scope bilgisini belirler
      scope: _scope,
      // toplam correct bilgisini belirler
      totalCorrect: totalCorrect,
      // toplam wrong bilgisini belirler
      totalWrong: totalWrong,
      // toplam blank bilgisini belirler
      totalBlank: totalBlank,
      // toplam net bilgisini belirler
      totalNet: double.parse(totalNet.toStringAsFixed(2)),
      // scores bilgisini belirler
      scores: scores,
    );
    // navigator.of nesnesini oluşturur
    Navigator.of(context).pop(session);
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // live toplam correct için başlangıç sayısını belirler
    var liveTotalCorrect = 0;
    // live toplam wrong için başlangıç sayısını belirler
    var liveTotalWrong = 0;
    // live toplam blank için başlangıç sayısını belirler
    var liveTotalBlank = 0;
    // live toplam net için başlangıç sayısını belirler
    var liveTotalNet = 0.0;
    // Listedeki öğeleri tek tek dolaşır
    for (final e in _subjectEntries) {
      // Belirtilen koşul doğruysa işlemi yapar
      if (e.isValid) {
        // live toplam correct değerine yeni miktarı ekler
        liveTotalCorrect += e.correct;
        // live toplam wrong değerine yeni miktarı ekler
        liveTotalWrong += e.wrong;
        // live toplam blank değerine yeni miktarı ekler
        liveTotalBlank += e.blank;
        // live toplam net değerine yeni miktarı ekler
        liveTotalNet += e.net;
      }
    }
    // Açılır pencere oluşturur
    return Dialog(
      // inset padding bilgisini belirler
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      // Arka plan rengini belirler
      backgroundColor:
          // Koşula göre iki değerden birini seçer
          isDark ? GardenPalette.nightCard : GardenPalette.gardenPaper,
      // Widgetın kenar şeklini belirler
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // İçine yerleştirilecek widgetı belirler
      child: ConstrainedBox(
        // constraints bilgisini belirler
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // İçerideki widgetları listeler
          children: [
            // Header
            // İç boşluk ekler
            Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
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
                      color: GardenPalette.mossEmerald.withAlpha(30),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(Icons.edit_note,
                        // Rengi belirler
                        color: GardenPalette.mossEmerald, size: 24),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 12),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      widget.existingSession != null
                          // Koşul doğruysa bu değeri kullanır
                          ? 'Denemeyi Düzenle'
                          // Koşul yanlışsa bu değeri kullanır
                          : 'Yeni Deneme Ekle',
                      // Görünüm stilini belirler
                      style: const TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 18,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Simgeli buton oluşturur
                  IconButton(
                    // simge bilgisini belirler
                    icon: const Icon(Icons.close),
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Ayırıcı çizgi gösterir
            const Divider(height: 1),
            // Content List
            // Kalan boşluğu kullanacak alan oluşturur
            Expanded(
              // İçine yerleştirilecek widgetı belirler
              child: ListView(
                // İç boşlukları belirler
                padding: const EdgeInsets.all(20),
                // İçerideki widgetları listeler
                children: [
                  // Title input
                  // Metin giriş alanı oluşturur
                  TextField(
                    // Veriyi yöneten controllerı bağlar
                    controller: _titleController,
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: InputDecoration(
                      // Giriş alanının etiketini belirler
                      labelText: 'Deneme Adı / Yayın',
                      // Giriş alanında ipucu gösterir
                      hintText: 'Örn: Özdebir TYT-1, 3D Türkiye Geneli',
                      // Kenarlığı belirler
                      border: OutlineInputBorder(
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(14),
                      ),
                      // prefix icon bilgisini belirler
                      prefixIcon: const Icon(Icons.bookmark_outline),
                    ),
                    // Değer değişince çalışacak fonksiyonu belirler
                    onChanged: (_) => setState(() {}),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 14),
                  // Stage & Scope Selector
                  // Elemanları yan yana dizer
                  Row(
                    // İçerideki widgetları listeler
                    children: [
                      // Kalan boşluğu kullanacak alan oluşturur
                      Expanded(
                        // İçine yerleştirilecek widgetı belirler
                        child: NatureSegmentedControl<String>(
                          // Listelenecek öğeleri belirler
                          items: const {
                            // "TYT': 'TYT" metnini kullanır
                            'TYT': 'TYT',
                            // "AYT': 'AYT" metnini kullanır
                            'AYT': 'AYT',
                          },
                          // seçili olma durumu bilgisini belirler
                          selected: _stage,
                          // Değer değişince çalışacak fonksiyonu belirler
                          onChanged: (newStage) =>
                              // stage or scope changed bilgisini işler
                              _onStageOrScopeChanged(newStage, _scope),
                        ),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 10),
                      // Kalan boşluğu kullanacak alan oluşturur
                      Expanded(
                        // İçine yerleştirilecek widgetı belirler
                        child: NatureSegmentedControl<String>(
                          // Listelenecek öğeleri belirler
                          items: const {
                            // "general': 'Genel" metnini kullanır
                            'general': 'Genel',
                            // "branch': 'Branş" metnini kullanır
                            'branch': 'Branş',
                          },
                          // seçili olma durumu bilgisini belirler
                          selected: _scope,
                          // Değer değişince çalışacak fonksiyonu belirler
                          onChanged: (newScope) =>
                              // stage or scope changed bilgisini işler
                              _onStageOrScopeChanged(_stage, newScope),
                        ),
                      ),
                    ],
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 14),
                  // Date button
                  // Tıklanabilir alan oluşturur
                  InkWell(
                    // Dokunulunca çalışacak fonksiyonu belirler
                    onTap: _pickDate,
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(14),
                    // İçine yerleştirilecek widgetı belirler
                    child: Container(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.symmetric(
                          // horizontal bilgisini belirler
                          horizontal: 14, vertical: 12),
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: BoxDecoration(
                        // Kenarlığı belirler
                        border: Border.all(color: Colors.grey.withAlpha(100)),
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(14),
                      ),
                      // İçine yerleştirilecek widgetı belirler
                      child: Row(
                        // İçerideki widgetları listeler
                        children: [
                          // Simge gösterir
                          const Icon(Icons.calendar_month_outlined,
                              // Boyutu belirler
                              size: 20, color: GardenPalette.mossEmerald),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(width: 10),
                          // Metni ekranda gösterir
                          Text(
                            // "Sınav Tarihi: ${_selectedDate.day}.${_selec…" metnini kullanır
                            'Sınav Tarihi: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                            // Görünüm stilini belirler
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          // Elemanlar arasındaki boşluğu doldurur
                          const Spacer(),
                          // Metni ekranda gösterir
                          const Text('Değiştir',
                              // Görünüm stilini belirler
                              style: TextStyle(
                                  // Rengi belirler
                                  color: GardenPalette.mossEmerald,
                                  // Yazı boyutunu belirler
                                  fontSize: 12,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 16),
                  // Canlı Net Özeti Kartı
                  // Görsel bir kutu oluşturur
                  Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(14),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Renk geçişini belirler
                      gradient: LinearGradient(
                        // renkler bilgisini belirler
                        colors: [
                          // Rengin saydamlık değerini ayarlar
                          GardenPalette.mossEmerald.withAlpha(30),
                          // Rengin saydamlık değerini ayarlar
                          GardenPalette.streamTurquoise.withAlpha(20),
                        ],
                      ),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(16),
                      // Kenarlığı belirler
                      border: Border.all(
                        // Rengi belirler
                        color: GardenPalette.mossEmerald.withAlpha(60),
                      ),
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: Row(
                      // Ana eksendeki hizalamayı belirler
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // İçerideki widgetları listeler
                      children: [
                        // İlgili fonksiyonu çalıştırır
                        _buildSummaryColumn(
                            // "Toplam Net" metnini kullanır
                            'Toplam Net',
                            // string as fixed bilgisini dönüştürür
                            liveTotalNet.toStringAsFixed(2),
                            // Temadan renk veya görünüm değeri alır
                            GardenPalette.mossEmerald),
                        // İlgili fonksiyonu çalıştırır
                        _buildSummaryColumn('Doğru', '$liveTotalCorrect',
                            // Temadan renk veya görünüm değeri alır
                            GardenPalette.mossEmerald),
                        // İlgili fonksiyonu çalıştırır
                        _buildSummaryColumn('Yanlış', '$liveTotalWrong',
                            // Temadan renk veya görünüm değeri alır
                            GardenPalette.peachCoral),
                        // İlgili fonksiyonu çalıştırır
                        _buildSummaryColumn(
                            // "Boş', '$liveTotalBlank', Colors.grey.shade600)" metnini kullanır
                            'Boş', '$liveTotalBlank', Colors.grey.shade600),
                      ],
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 16),
                  // Metni ekranda gösterir
                  const Text(
                    // "Ders Bazlı Sonuçlar (Doğru / Yanlış):" metnini kullanır
                    'Ders Bazlı Sonuçlar (Doğru / Yanlış):',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 10),
                  // Subject score rows
                  // Öğeleri tek tek dönüştürür
                  ..._subjectEntries.map((e) {
                    // Görsel bir kutu oluşturur
                    return Container(
                      // Dış boşlukları belirler
                      margin: const EdgeInsets.only(bottom: 12),
                      // İç boşlukları belirler
                      padding: const EdgeInsets.all(12),
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: BoxDecoration(
                        // Rengi belirler
                        color: isDark
                            // Koşul doğruysa bu değeri kullanır
                            ? Colors.black12
                            // Koşul yanlışsa bu değeri kullanır
                            : GardenPalette.sandyPorcelain.withAlpha(140),
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(14),
                        // Kenarlığı belirler
                        border: Border.all(
                          // Rengi belirler
                          color: e.isValid
                              // Koşul doğruysa bu değeri kullanır
                              ? Colors.grey.withAlpha(40)
                              // Koşul yanlışsa bu değeri kullanır
                              : Colors.red.withAlpha(120),
                        ),
                      ),
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
                              Text(
                                // "${e.subjectName} (${e.questionCount} Soru)" metnini kullanır
                                '${e.subjectName} (${e.questionCount} Soru)',
                                // Görünüm stilini belirler
                                style: const TextStyle(
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.bold,
                                  // Yazı boyutunu belirler
                                  fontSize: 13,
                                ),
                              ),
                              // Metni ekranda gösterir
                              Text(
                                // İlgili değeri veya görünüm ayarını belirler
                                e.isValid
                                    // Koşul doğruysa bu değeri kullanır
                                    ? 'Net: ${e.net.toStringAsFixed(2)} • Boş: ${e.blank}'
                                    // Koşul yanlışsa bu değeri kullanır
                                    : 'Geçersiz giriş!',
                                // Görünüm stilini belirler
                                style: TextStyle(
                                  // Yazı boyutunu belirler
                                  fontSize: 12,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.bold,
                                  // Rengi belirler
                                  color: e.isValid
                                      // Koşul doğruysa bu değeri kullanır
                                      ? GardenPalette.mossEmerald
                                      // Koşul yanlışsa bu değeri kullanır
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(height: 8),
                          // Elemanları yan yana dizer
                          Row(
                            // İçerideki widgetları listeler
                            children: [
                              // Kalan boşluğu kullanacak alan oluşturur
                              Expanded(
                                // İçine yerleştirilecek widgetı belirler
                                child: GardenExamScoreField(
                                  // Veriyi yöneten controllerı bağlar
                                  controller: e.correctController,
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
                                  controller: e.wrongController,
                                  // type bilgisini belirler
                                  type: ScoreFieldType.wrong,
                                  // Değer değişince çalışacak fonksiyonu belirler
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Footer actions
            // İç boşluk ekler
            Padding(
              // İç boşlukları belirler
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // İçerideki widgetları listeler
                children: [
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: OutlinedButton(
                      // Görünüm stilini belirler
                      style: OutlinedButton.styleFrom(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        // Widgetın kenar şeklini belirler
                        shape: RoundedRectangleBorder(
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => Navigator.of(context).pop(),
                      // İçine yerleştirilecek widgetı belirler
                      child: const Text('İptal'),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 12),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: GardenPrimaryButton(
                      // Buton veya alan yazısını belirler
                      label: widget.existingSession != null
                          // Koşul doğruysa bu değeri kullanır
                          ? 'Güncelle'
                          // Koşul yanlışsa bu değeri kullanır
                          : 'Kaydet',
                      // simge bilgisini belirler
                      icon: Icons.check,
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _isAllValid ? _submit : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // summary column bilgisini oluşturur
  Widget _buildSummaryColumn(String label, String value, Color color) {
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
}

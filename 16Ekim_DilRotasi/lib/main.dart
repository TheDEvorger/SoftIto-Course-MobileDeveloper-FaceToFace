// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Uygulamanın renk ayarlarını ekler
import 'core/palette.dart';
// Kelime kayıt işlemlerini ekler
import 'data/word_repository.dart';
// Kelime modelini ekler
import 'models/vocabulary_word.dart';
// Ana ekranı projeye ekler
import 'screens/dashboard_screen.dart';
// Kelime defteri ekranını ekler
import 'screens/dictionary_screen.dart';
// Kelime ekleme ekranını ekler
import 'screens/add_word_screen.dart';
// Ortak arayüz elemanlarını ekler
import 'widgets/ui_parts.dart';

// Uygulamanın ana fonksiyonu
void main() {
  // Flutter bağlantısının hazır olmasını sağlar
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulamayı çalıştırır
  runApp(const DilRotasiApp());
}

// Durum değişmediği için StatelessWidget kullanılır
class DilRotasiApp extends StatelessWidget {
  // Constructor, repository parametresi isteğe bağlıdır
  const DilRotasiApp({super.key, this.repository});
  // Repository bilgisini tutar, null olabilir
  final WordRepository? repository;
  // Üstteki build metodunu yeniden yazar
  @override
  // Uygulamanın Material yapısını oluşturur
  Widget build(BuildContext context) => MaterialApp(
    // Uygulamanın başlığı
    title: 'Dil Rotası • Kelime Atölyesi',
    // Debug yazısını kaldırır
    debugShowCheckedModeBanner: false,
    // Uygulamanın temasını çağırır
    theme: buildAppTheme(),
    // Repository yoksa varsayılan yerel kayıt sistemini kullanır
    home: MainShell(repository: repository ?? PreferencesWordRepository()),
  );
}

// Ortak verileri yönettiği için StatefulWidget kullanılır
class MainShell extends StatefulWidget {
  // Repository verilmesini zorunlu tutar
  const MainShell({super.key, required this.repository});
  // Kelime işlemlerini yapacak repository bilgisini tutar
  final WordRepository repository;
  // Üstteki createState metodunu uygular
  @override
  // State sınıfını oluşturur
  State<MainShell> createState() => _MainShellState();
}

// Ekranların ortak durumunu yöneten State sınıfı
class _MainShellState extends State<MainShell> {
  // Aktif sekmeyi tutar, başlangıçta ilk ekran
  int _currentTab = 0;
  // Formu sıfırlamak için kullanılan sürüm bilgisi
  int _formVersion = 0;
  // Günlük kelime hedefi başlangıçta 5
  int _dailyGoal = 5;
  // Verilerin yüklenme durumunu tutar
  bool _loading = true;
  // Yükleme hatasını tutar, hata yoksa null
  String? _loadWarning;
  // Kelimeleri tutan liste
  List<VocabularyWord> _words = [];
  // Kayıt işlemlerini sıraya almak için Future oluşturur
  Future<void> _saveQueue = Future<void>.value();
  // Üstteki initState metodunu yeniden yazar
  @override
  // Widget ilk açıldığında bir kere çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // Kayıtlı verileri yükler
    _load();
  }

  // Kelimeleri ve günlük hedefi asenkron yükler
  Future<void> _load() async {
    // Hata oluşabilecek işlemleri dener
    try {
      // Kayıtlı kelimeleri getirir ve bekler
      final words = await widget.repository.loadWords();
      // Günlük hedefi getirir ve bekler
      final goal = await widget.repository.loadDailyGoal();
      // Widget kaldırılmışsa işlemi durdurur
      if (!mounted) return;
      // State değişikliğini ekrana bildirir
      setState(() {
        // Gelen kelimeleri listeye aktarır
        _words = words;
        // Hedefi 1 ile 30 arasında sınırlar
        _dailyGoal = goal.clamp(1, 30).toInt();
        // Yükleme durumunu kapatır
        _loading = false;
      });
      // İşlemlerden biri hata verirse çalışır
    } catch (_) {
      // Widget kaldırılmışsa işlemi durdurur
      if (!mounted) return;
      // Hata sonrası ekranı günceller
      setState(() {
        // Örnek kelimeleri getirir
        _words = demoWords();
        // Yüklemeyi tamamlanmış kabul eder
        _loading = false;
        // Kullanıcıya gösterilecek uyarıyı belirler
        _loadWarning = 'Yerel kayıt okunamadı. Örnek kelimeler gösteriliyor.';
      });
    }
  }

  // Ekranın altında kısa mesaj gösteren metot
  void _message(String value) {
    // Widget kaldırılmışsa işlem yapmaz
    if (!mounted) return;
    // ScaffoldMessenger üzerinden mesaj gösterir
    ScaffoldMessenger.of(context)
      // Önceki mesajı gizler
      ..hideCurrentSnackBar()
      // Yeni SnackBar mesajını gösterir
      ..showSnackBar(SnackBar(content: Text(value)));
  }

  // Seçilen sekmeyi değiştirip ekranı günceller
  void _selectTab(int tab) => setState(() => _currentTab = tab);
  // Kelimeleri cihaza kaydetmek için kullanılan metot
  void _persistWords() {
    // Listenin o anki kopyasını alır
    final snapshot = List<VocabularyWord>.of(_words);
    // Kayıt işlemlerini sırayla çalıştırır
    _saveQueue = _saveQueue
        // Önceki kayıt bitince yeni listeyi kaydeder
        .then((_) => widget.repository.saveWords(snapshot))
        // Kayıt başarısız olursa hata mesajı gösterir
        .catchError((Object _) => _message('Kelimeler cihaza kaydedilemedi.'));
  }

  // Yeni kelime ekleme metodu
  void _addWord(VocabularyWord word) {
    // Kelime listesini ve ekranı günceller
    setState(() {
      // Yeni kelimeyi listenin başına ekler
      _words.insert(0, word);
      // Kelime defteri sekmesine geçer
      _currentTab = 1;
      // Formun yeniden oluşturulması için sayacı artırır
      _formVersion++;
    });
    // Güncel kelime listesini kaydeder
    _persistWords();
    // Eklenen kelimeyi mesaj olarak gösterir
    _message('“${word.word}” defterine eklendi.');
  }

  // Kelimenin tekrar çalışılmasını sağlayan metot
  void _reviewWord(String id) {
    // IDye göre kelimenin listedeki yerini bulur
    final index = _words.indexWhere((word) => word.id == id);
    // Kelime bulunamazsa işlemi durdurur
    if (index < 0) return;
    // Kelimenin durumunu günceller
    setState(() {
      // Eski kelime bilgisini alır
      final old = _words[index];
      // copyWith ile güncellenmiş kelimeyi oluşturur
      _words[index] = old.copyWith(
        // Öğrenme aşamasını bir sonraki seviyeye geçirir
        stage: old.stage.next,
        // Tekrar sayısını 1 artırır
        reviewCount: old.reviewCount + 1,
        // Son çalışma zamanını kaydeder
        lastReviewedAt: DateTime.now(),
      );
    });
    // Güncel listeyi kaydeder
    _persistWords();
    // İşlemin tamamlandığını bildirir
    _message('Çalışman kaydedildi.');
  }

  // Kelimenin öğrenme aşamasını değiştiren metot
  void _changeStage(String id, WordStage stage) {
    // IDye göre kelimeyi arar
    final index = _words.indexWhere((word) => word.id == id);
    // Kelime yoksa işlemi durdurur
    if (index < 0) return;
    // copyWith ile aşamayı değiştirip ekranı günceller
    setState(() => _words[index] = _words[index].copyWith(stage: stage));
    // Değişiklikleri kaydeder
    _persistWords();
    // Bilgilendirme mesajını gösterir
    _message('Öğrenme aşaması güncellendi.');
  }

  // Kelime silme metodu
  void _deleteWord(String id) {
    // Silinecek kelimenin indeksini bulur
    final index = _words.indexWhere((word) => word.id == id);
    // Kelime bulunamazsa işlem yapmaz
    if (index < 0) return;
    // Silinecek kelimeyi geçici olarak tutar
    final removed = _words[index];
    // Kelimeyi listeden silip ekranı günceller
    setState(() => _words.removeAt(index));
    // Güncel listeyi kaydeder
    _persistWords();
    // Silinen kelimenin adını gösterir
    _message('“${removed.word}” silindi.');
  }

  // Günlük kelime hedefini değiştiren metot
  void _setGoal(int goal) {
    // Günlük hedefi günceller
    setState(() => _dailyGoal = goal);
    // Yeni hedefi kaydeder, hata olursa mesaj gösterir
    widget.repository
        .saveDailyGoal(goal)
        .catchError((Object _) => _message('Hedef kaydedilemedi.'));
    // Yeni hedefi kullanıcıya bildirir
    _message('Günlük hedefin: $goal kelime.');
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ekranın genişliğini alır
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Genişlik 940 ve üzerindeyse true olur
    final wide = screenWidth >= 940;
    // Uygulamadaki ekranları Widget listesinde tutar
    final screens = <Widget>[
      // Ana ekranı oluşturur
      DashboardScreen(
        // Kelime listesini ana ekrana gönderir
        words: _words,
        // Günlük hedefi gönderir
        dailyGoal: _dailyGoal,
        // Kelime ekle butonuyla üçüncü sekmeye geçer
        onAdd: () => _selectTab(2),
        // Kelime defterine geçer
        onLibrary: () => _selectTab(1),
        // Kelime tekrar metodunu gönderir
        onReview: _reviewWord,
        // Hedef değiştirme metodunu gönderir
        onChangeGoal: _setGoal,
      ),
      // Kelime defteri ekranını oluşturur
      DictionaryScreen(
        // Kelime listesini gönderir
        words: _words,
        // Kelime tekrar metodunu gönderir
        onReview: _reviewWord,
        // Kelimeyi öğrenildi olarak işaretler
        onMarkMastered: (id) => _changeStage(id, WordStage.mastered),
        // Kelimeyi başlangıç aşamasına döndürür
        onReset: (id) => _changeStage(id, WordStage.newWord),
        // Kelime silme metodunu gönderir
        onDelete: _deleteWord,
        // Kelime ekleme ekranına geçer
        onAdd: () => _selectTab(2),
      ),
      // Form sürümünü key olarak kullanır, kelime eklenince form yenilenir
      AddWordScreen(key: ValueKey(_formVersion), onSubmit: _addWord),
    ];
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Geniş ekranda AppBar gizlenir
      appBar: wide
          ? null
          : AppBar(
              // Üst menünün yüksekliği
              toolbarHeight: 70,
              // Başlığın kenar boşluğu
              titleSpacing: 17,
              // Logo ve başlığı yan yana dizer
              title: const Row(
                children: [
                  // Uygulamanın logosunu gösterir
                  BrandMark(size: 38),
                  // Logo ile yazı arasına boşluk bırakır
                  SizedBox(width: 10),
                  // Uygulamanın adını gösterir
                  Text(
                    'Dil Rotası',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Üst menünün sağındaki butonlar
              actions: [
                // Hakkında butonu oluşturur
                IconButton(
                  // Butonun açıklaması
                  tooltip: 'Hakkında',
                  // Butona basılınca hakkında penceresini açar
                  onPressed: () => _about(context),
                  // Bilgi simgesini gösterir
                  icon: const Icon(Icons.info_outline_rounded, size: 21),
                ),
                // Sağ tarafta boşluk bırakır
                const SizedBox(width: 8),
              ],
              // AppBar altına ince çizgi ekler
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1),
              ),
            ),
      // Yükleme durumuna göre içerik gösterir
      body: _loading
          // Yükleniyorsa dönen yükleme simgesi gösterir
          ? const Center(child: CircularProgressIndicator())
          // Yükleme bittiyse ekran içeriğini gösterir
          : SafeArea(
              // Geniş ekranda üst güvenli alanı kullanır
              top: wide,
              // Alt güvenli alan boşluğunu kullanmaz
              bottom: false,
              // Yan menüyle ana içeriği yan yana dizer
              child: Row(
                children: [
                  // Geniş ekranda yan menü gösterilir
                  if (wide)
                    // Yan menünün genişliğini belirler
                    SizedBox(
                      // Ekran büyüdükçe yan menüyü genişletir
                      width: screenWidth >= 1180 ? 250 : 208,
                      // Masaüstü yan menüsünü oluşturur
                      child: _DeskSidebar(
                        selected: _currentTab,
                        onSelect: _selectTab,
                        onAbout: () => _about(context),
                      ),
                    ),
                  // Kalan alanı ana içeriğe ayırır
                  Expanded(
                    child: Column(
                      children: [
                        // Yükleme uyarısı varsa gösterir
                        if (_loadWarning != null)
                          // Ekranın üstünde uyarı mesajı oluşturur
                          MaterialBanner(
                            // Uyarı simgesini gösterir
                            leading: const Icon(Icons.warning_amber_rounded),
                            // Hata mesajını gösterir
                            content: Text(_loadWarning!),
                            // Kapat butonuyla uyarıyı temizler
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    setState(() => _loadWarning = null),
                                child: const Text('Kapat'),
                              ),
                            ],
                          ),
                        // Aktif ekranı gösterir, diğer ekranların durumunu korur
                        Expanded(
                          child: IndexedStack(
                            index: _currentTab,
                            children: screens,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // Geniş ekranda veya yüklenirken alt menüyü gizler
      bottomNavigationBar: wide || _loading
          ? null
          : NavigationBar(
              // Aktif sekmenin indeksini belirler
              selectedIndex: _currentTab,
              // Sekme değişince _selectTab metodunu çağırır
              onDestinationSelected: _selectTab,
              // Alt menüdeki sekmeleri tutar
              destinations: const [
                // Başlangıç sekmesi
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Başlangıç',
                ),
                // Kelime defteri sekmesi
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  selectedIcon: Icon(Icons.menu_book_rounded),
                  label: 'Defterim',
                ),
                // Kelime ekleme sekmesi
                NavigationDestination(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  selectedIcon: Icon(Icons.add_circle_rounded),
                  label: 'Kelime ekle',
                ),
              ],
            ),
    );
  }

  // Uygulama hakkında bilgi penceresi açar
  void _about(BuildContext context) => showAboutDialog(
    // Pencerenin açılacağı context
    context: context,
    // Uygulamanın adı
    applicationName: 'Dil Rotası | Kelime Atölyesi',
    // Uygulamanın sürüm bilgisi
    applicationVersion: '2.0.0',
    // Uygulama açıklamasını gösterir
    applicationLegalese: 'Flutter ile hazırlanmış üç ekranlı eğitim projesi.',
    // Pencereye ek bilgi metni koyar
    children: [
      const Text(
        'Kelimeler yalnızca bu cihazda kaydedilir. Hesap, takip veya otomatik eşitleme bulunmaz.',
      ),
    ],
  );
}

// Masaüstü için yan menü oluşturur
class _DeskSidebar extends StatelessWidget {
  // Constructor, menü bilgilerini zorunlu alır
  const _DeskSidebar({
    required this.selected,
    required this.onSelect,
    required this.onAbout,
  });
  // Seçili sekmenin indeksini tutar
  final int selected;
  // Sekme seçilince int alan callback çalışır
  final ValueChanged<int> onSelect;
  // Hakkında butonu için parametresiz callback
  final VoidCallback onAbout;
  // Üstteki build metodunu yeniden yazar
  @override
  // Yan menünün arayüzünü oluşturur
  Widget build(BuildContext context) => Container(
    // Yan menünün arka planını ve kenarlığını belirler
    decoration: const BoxDecoration(
      color: Palette.forestDeep,
      border: Border(right: BorderSide(color: Palette.forest)),
    ),
    // Menü elemanlarını alt alta dizer
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo ve başlık alanına boşluk verir
        const Padding(
          // Dört taraftaki boşlukları belirler
          padding: EdgeInsets.fromLTRB(22, 28, 14, 32),
          // Logo ve yazıları yan yana dizer
          child: Row(
            children: [
              // Uygulama logosunu gösterir
              BrandMark(size: 42),
              // Logo ile yazı arasına boşluk bırakır
              SizedBox(width: 12),
              // Yazı alanının kalan genişliği kullanmasını sağlar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Uygulama adını gösterir
                    Text(
                      'Dil Rotası',
                      style: TextStyle(
                        color: Palette.paper,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    // Alt başlığı gösterir
                    Text(
                      'KELİME ATÖLYESİ',
                      style: TextStyle(
                        color: Palette.olive,
                        fontSize: 9,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Menü bölüm başlığını gösterir
        const Padding(
          padding: EdgeInsets.only(left: 23, bottom: 13),
          child: Kicker('ÇALIŞMA MASASI', dark: true),
        ),
        // Başlangıç sekmesinin menü elemanı
        _NavItem(
          index: 0,
          selected: selected,
          icon: Icons.space_dashboard_outlined,
          label: 'Başlangıç',
          onSelect: onSelect,
        ),
        // Kelime defteri sekmesinin menü elemanı
        _NavItem(
          index: 1,
          selected: selected,
          icon: Icons.book_outlined,
          label: 'Kelime defterim',
          onSelect: onSelect,
        ),
        // Kelime ekleme sekmesinin menü elemanı
        _NavItem(
          index: 2,
          selected: selected,
          icon: Icons.edit_note_rounded,
          label: 'Kelime ekle',
          onSelect: onSelect,
        ),
        // Kalan boşluğu doldurup alt elemanları aşağı iter
        const Spacer(),
        // Alt bölümün üstüne ayırıcı çizgi koyar
        const Padding(
          padding: EdgeInsets.fromLTRB(22, 8, 22, 13),
          child: Divider(color: Color(0xFF4A6055)),
        ),
        // Simge ve yazı içeren hakkında butonu
        TextButton.icon(
          // Butona basılınca hakkında fonksiyonunu çağırır
          onPressed: onAbout,
          // Butonun bilgi simgesi
          icon: const Icon(
            Icons.info_outline_rounded,
            color: Palette.olive,
            size: 17,
          ),
          // Butonun yazısı
          label: const Text(
            'Uygulama hakkında',
            style: TextStyle(color: Palette.paper),
          ),
          // Butonun iç boşluğunu belirler
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          ),
        ),
        // Alt bilgi alanına boşluk verir
        const Padding(
          // Alt bilgi alanının boşlukları
          padding: EdgeInsets.fromLTRB(22, 6, 22, 25),
          // Alt bilgi ve sürüm yazısını gösterir
          child: Text(
            'DİL ROTASI   /   02.00\nHer kelime bir iz bırakır.',
            style: TextStyle(
              fontSize: 10,
              height: 1.8,
              letterSpacing: 1,
              color: Color(0xFFA8BAA7),
            ),
          ),
        ),
      ],
    ),
  );
}

// Yan menüdeki tek bir sekmeyi oluşturur
class _NavItem extends StatelessWidget {
  // Constructor, sekme bilgilerini zorunlu alır
  const _NavItem({
    required this.index,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onSelect,
  });
  // Sekmenin indeksini tutar
  final int index;
  // Aktif sekmenin indeksini tutar
  final int selected;
  // Sekmenin simgesini tutar
  final IconData icon;
  // Sekmenin adını tutar
  final String label;
  // Sekme seçilince çalışacak callback
  final ValueChanged<int> onSelect;
  // Üstteki build metodunu yeniden yazar
  @override
  // Sekme elemanının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Bu sekme seçiliyse true olur
    final active = index == selected;
    // Sekmenin dış boşluklarını belirler
    return Padding(
      // Yatay ve dikey boşluk verir
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      // Sekmeye Material yapısı verir
      child: Material(
        // Seçiliyse arka plan rengi verir
        color: active ? const Color(0xFF3B5547) : Colors.transparent,
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(11),
        // Tıklama özelliği ekler
        child: InkWell(
          // Tıklama alanının köşelerini yuvarlar
          borderRadius: BorderRadius.circular(11),
          // Tıklanınca seçilen sekmenin indeksini gönderir
          onTap: () => onSelect(index),
          // Sekmenin iç boşluklarını belirler
          child: Padding(
            // Yatayda 15 dikeyde 15 boşluk bırakır
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            // Simge ve yazıyı yan yana dizer
            child: Row(
              children: [
                // Seçili olmasına göre simge rengini belirler
                Icon(
                  icon,
                  color: active ? Palette.mustard : Palette.olive,
                  size: 21,
                ),
                // Simgeyle yazı arasına boşluk bırakır
                const SizedBox(width: 12),
                // Sekme yazısını gösterir, seçiliyse kalın olur
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Palette.paper,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                // Seçili sekmenin yanında küçük nokta gösterir
                if (active)
                  const Icon(Icons.circle, size: 6, color: Palette.mustard),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

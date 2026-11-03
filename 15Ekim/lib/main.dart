// Flutterın arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Layout ekranını projeye dahil eder
import 'screens/01_layout_screen.dart';
// Piyasalar ekranını dahil eder
import 'screens/02_markets_list_screen.dart';
// Transfer ekranını dahil eder
import 'screens/03_transfer_form_screen.dart';

// Uygulamanın ana fonksiyonu
void main() {
  // DtmMasteryApp sınıfını çalıştırır
  runApp(const DtmMasteryApp());
}

// Durum değişmeyeceği için StatelessWidget kullanılır
class DtmMasteryApp extends StatelessWidget {
  // Constructor ve üst sınıfa key gönderir
  const DtmMasteryApp({super.key});
  // Üstteki build metodunun üzerine yazar
  @override
  // Ekranda gösterilecek widgetları döndürür
  Widget build(BuildContext context) {
    // Material tasarımını kullanır
    return MaterialApp(
      // Debug yazısını kaldırır
      debugShowCheckedModeBanner: false,
      // Uygulamanın başlığı
      title: 'DTM Flutter Mastery Studio',
      // Genel tema ayarları
      theme: ThemeData(
        // Material 3 tasarımını açar
        useMaterial3: true,
        // Yazı tipini belirler
        fontFamily: 'sans-serif',
        // Verilen renkten tema oluşturur
        colorScheme: ColorScheme.fromSeed(
          // Ana tema rengini belirler
          seedColor: const Color(0xFF6366F1),
          // Açık tema kullanır
          brightness: Brightness.light,
        ),
        // Sayfanın arka plan rengi
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        // Üst menünün tema ayarları
        appBarTheme: const AppBarTheme(
          // Üst menüyü beyaz yapar
          backgroundColor: Colors.white,
          // Gölgeyi sıfırlar
          elevation: 0,
          // Yüzeydeki renk etkisini kaldırır
          surfaceTintColor: Colors.transparent,
          // Başlığı ortaya alır
          centerTitle: true,
          // Başlığın yazı ayarları
          titleTextStyle: TextStyle(
            // Yazı boyutu 18
            fontSize: 18,
            // Yazıyı kalın yapar
            fontWeight: FontWeight.bold,
            // Yazı rengini belirler
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      // İlk açılacak ekranı belirler
      home: const MainMasteryNavigationHub(),
    );
  }
}

// Sekmeler değişeceği için StatefulWidget kullanılır
class MainMasteryNavigationHub extends StatefulWidget {
  // Sınıfın constructorı
  const MainMasteryNavigationHub({super.key});
  // Üstteki createState metodunun üzerine yazar
  @override
  // Bu widgetın State sınıfını çağırır
  State<MainMasteryNavigationHub> createState() =>
      _MainMasteryNavigationHubState();
}

// Ekranın değişen durumlarını burada tutar
class _MainMasteryNavigationHubState extends State<MainMasteryNavigationHub> {
  // Hangi sekmede olduğumuzu tutar, ilk sekme 0
  int _currentIndex = 0;
  // Ekranları Widget listesinde tutar
  final List<Widget> _screens = const [
    // Layout ekranı
    LayoutScreen(),
    // Piyasalar ekranı
    MarketsListScreen(),
    // Transfer ekranı
    TransferFormScreen(),
  ];
  // Ekranların başlıklarını tutan String listesi
  final List<String> _titles = const [
    // İlk ekranın başlığı
    'DTM 1. Bölüm: Layout & Styling',
    // İkinci ekranın başlığı
    'DTM 2. Bölüm: Piyasalar & Listeler',
    // Üçüncü ekranın başlığı
    'DTM 3. Bölüm: Transfer & Formlar',
  ];
  // Üstteki build metodunun üzerine yazar
  @override
  // Ekranın güncel halini oluşturur
  Widget build(BuildContext context) {
    // Sayfanın ana iskeleti
    return Scaffold(
      // Üst menüyü oluşturur
      appBar: AppBar(
        // Aktif sekmenin başlığını listeden çeker
        title: Text(_titles[_currentIndex]),
        // Üst menünün sağındaki butonlar
        actions: [
          // Bilgi butonu
          IconButton(
            // Butonun açıklaması
            tooltip: 'Bilgi',
            // Bilgi simgesini ve rengini belirler
            icon: const Icon(Icons.info_outline, color: Color(0xFF6366F1)),
            // Butona basılınca çalışır
            onPressed: () {
              // Ekranda açılır pencere gösterir
              showDialog(
                // Bulunduğu ekranın context bilgisi
                context: context,
                // Açılacak pencereyi oluşturur
                builder: (ctx) => AlertDialog(
                  // Pencerenin başlığı
                  title: const Text('DTM Flutter Mastery'),
                  // Pencerenin içindeki yazılar
                  content: const Text(
                    // Dersin açıklaması
                    '14 ve 15 Ekim birleştirilmiş canlı ders projesidir.\n\n'
                    // İlk sekmede işlenen konular
                    '• Sekme 1: Container, Row, Column, Expanded, Stack\n'
                    // İkinci sekmede işlenen konular
                    '• Sekme 2: GridView.builder, ListView.separated\n'
                    // Üçüncü sekmede işlenen konular
                    '• Sekme 3: Form Validasyonu, ModalBottomSheet, SnackBar',
                    // Yazının boyutu ve satır aralığı
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                  // Pencerenin altındaki butonlar
                  actions: [
                    // Yazılı buton oluşturur
                    TextButton(
                        // Navigator.pop ile pencereyi kapatır
                        onPressed: () => Navigator.pop(ctx),
                        // Butonun yazısı
                        child: const Text('Anladım')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      // Sekmeleri gösterir, diğer ekranların durumunu korur
      body: IndexedStack(
        // Gösterilecek ekranın indeksini alır
        index: _currentIndex,
        // Ekran listesini kullanır
        children: _screens,
      ),
      // Alttaki sekme menüsü
      bottomNavigationBar: NavigationBar(
        // Seçili sekmenin indeksini alır
        selectedIndex: _currentIndex,
        // Sekme seçilince yeni indeksi alır
        onDestinationSelected: (index) {
          // Değişiklik olunca ekranı yeniden günceller
          setState(() {
            // Seçilen sekmenin indeksini kaydeder
            _currentIndex = index;
          });
        },
        // Alt menünün arka plan rengi
        backgroundColor: Colors.white,
        // Alt menünün gölge değeri
        elevation: 2,
        // Seçili sekmenin arka plan rengi
        indicatorColor: const Color(0x266366F1),
        // Alt menüdeki sekmelerin listesi
        destinations: const [
          // Layout sekmesi
          NavigationDestination(
            // Normal durumda gösterilen simge
            icon: Icon(Icons.dashboard_outlined),
            // Seçilince gösterilen simge ve rengi
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF6366F1)),
            // Sekmenin ismi
            label: 'Layout',
          ),
          // Piyasalar sekmesi
          NavigationDestination(
            // Normal durumdaki simge
            icon: Icon(Icons.candlestick_chart_outlined),
            // Seçili durumdaki simge
            selectedIcon:
                Icon(Icons.candlestick_chart, color: Color(0xFF6366F1)),
            // Sekmenin ismi
            label: 'Piyasalar',
          ),
          // Cüzdan ve form sekmesi
          NavigationDestination(
            // Normal durumdaki simge
            icon: Icon(Icons.account_balance_wallet_outlined),
            // Seçili durumdaki simge
            selectedIcon:
                Icon(Icons.account_balance_wallet, color: Color(0xFF6366F1)),
            // Sekmenin ismi
            label: 'Cüzdan/Form',
          ),
        ],
      ),
    );
  }
}

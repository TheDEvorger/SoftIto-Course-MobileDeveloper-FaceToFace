// Future ve zamanlayıcı gibi asenkron yapıları ekler
import 'dart:async';
// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Kronik ekranını projeye ekler
import '../chronicle/chronicle_screen.dart';
// Rehber sohbet ekranını projeye ekler
import '../guide/guide_screen.dart';
// Vazifeler ekranını projeye ekler
import '../habits/habits_screen.dart';
// Ahitler ekranını projeye ekler
import '../pacts/pacts_screen.dart';
// Meydan ekranını projeye ekler
import '../plaza/plaza_screen.dart';
// Alt menüyü, çağ görünümünü ve krallık duyurularını yönetir
class RealmShell extends StatefulWidget {
  // RealmShell nesnesinin başlangıç bilgilerini alır
  const RealmShell({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<RealmShell> createState() => _RealmShellState();
}
// realm shell state bilgilerini ve ilgili davranışları tanımlar
class _RealmShellState extends State<RealmShell> {
  // Seçili menü veya öğenin indeksini tutar
  int selected = 0;
  // Son işlenen olayın numarasını tutar
  int lastEvent = 0;
  // Kutlama sırasında gösterilecek geçici mesajı tutar
  String? burstMessage;
  // Duyuru metnini değiştiren zamanlayıcıyı tutar, null olabilir
  Timer? _heraldTimer;
  // Duyurular arasında geçiş için sıra sayacını tutar
  int _heraldIndex = 0;
  // Duyuru alanında sırayla gösterilecek ipuçlarını tutar
  static const _tips = [
    // Gösterilecek veya kullanılacak metin parçasını ekler
    'Bir küçük adım, üç kâtip ve bir ferman kadar değerlidir.',
    // Gösterilecek veya kullanılacak metin parçasını ekler
    'Ahitlerin seni bekliyor. Hükümdarlar da takvim kullanır.',
    // Gösterilecek veya kullanılacak metin parçasını ekler
    'Bugün çok mu yoğun? Vazifeyi küçültmek de bir stratejidir.',
  ];
  // Alt menüdeki sayfa adlarını tutar
  static const labels = ['Vazifeler', 'Ahitler', 'Meydan', 'Rehber', 'Kronik'];
  // Alt menü sayfalarına ait simgeleri tutar
  static const icons = [
    // Menüde kullanılacak simgeyi seçer
    Icons.task_alt_rounded,
    // Menüde kullanılacak simgeyi seçer
    Icons.history_edu_rounded,
    // Menüde kullanılacak simgeyi seçer
    Icons.local_florist_rounded,
    // Menüde kullanılacak simgeyi seçer
    Icons.auto_awesome_rounded,
    // Menüde kullanılacak simgeyi seçer
    Icons.auto_stories_rounded,
  ];
  // Duyuru metniyle kısa ipuçlarını dönüşümlü gösterir
  String _heraldText(RealmController c) => _heraldIndex % 4 == 0
      // Koşul doğruysa kullanılacak sonucu belirler
      ? c.herald
      // Constructorın kullanılacak başlangıç nesnelerini ayarlar
      : _tips[(_heraldIndex - 1) % _tips.length];
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // init state için gerekli sonucu hesaplar
  void initState() {
    // Üst sınıfın başlangıç işlemlerini çalıştırır
    super.initState();
    // Mevcut olay numarasını başlangıç değeri yapar
    lastEvent = widget.controller.eventNumber;
    // Krallık olaylarını takip eden dinleyiciyi ekler
    widget.controller.addListener(_onRealmEvent);
    // herald zamanlayıcı bilgisini yeni değeriyle günceller
    _heraldTimer = Timer.periodic(const Duration(seconds: 18), (_) {
      // Widget açıksa duyuru sırasını bir artırıp ekranı yeniler
      if (mounted) setState(() => _heraldIndex++);
    });
  }
  // Yeni krallık olayı geldiğinde duyuruyu ve kutlamayı günceller
  void _onRealmEvent() {
    // Güncel krallık durumunu yerel değişkene alır
    final c = widget.controller;
    // Widget hâlâ açıksa veya kapandıysa işleme buna göre devam eder
    if (!mounted || c.eventNumber == lastEvent) return;
    // last event bilgisini yeni değeriyle günceller
    lastEvent = c.eventNumber;
    // Değişen bilgiyi ekrana yansıtmak için Statei günceller
    setState(() => _heraldIndex = 0);
    // Yeni olay kutlama gerektirmiyorsa kutlama göstermez
    if (c.celebration == null) return;
    // Değişen bilgiyi ekrana yansıtmak için Statei günceller
    setState(() => burstMessage = c.celebration);
    // captured bilgisini saklar
    final captured = lastEvent;
    // Kutlama mesajını belirli bir süre sonra kaldırmak için bekler
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      // Widget hâlâ açıksa veya kapandıysa işleme buna göre devam eder
      if (mounted && captured == lastEvent) setState(() => burstMessage = null);
    });
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Ekran kapanırken duyuru zamanlayıcısını iptal eder
    _heraldTimer?.cancel();
    // Ekran kapanırken krallık dinleyicisini kaldırır
    widget.controller.removeListener(_onRealmEvent);
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _RealmShellState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Dinlenen değişiklikte ilgili arayüzü yeniden oluşturur
    return AnimatedBuilder(
      // Arayüzü yeniden çizecek değişiklik kaynağını dinler
      animation: widget.controller,
      // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
      builder: (context, _) {
        // Güncel krallık durumunu yerel değişkene alır
        final c = widget.controller;
        // Vurgu rengini tutar
        final accent = c.era.primary;
        // keyboard visible bilgisini saklar
        final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
        // Ekranın üst menü ve gövde iskeletini oluşturur
        return Scaffold(
          // Ekranın içeriğini veya HTTP isteğinin gövdesini belirler
          body: Stack(
            // İçeride sıralanacak widgetları listeler
            children: [
              // Arka plana fantastik krallık görselini yerleştirir
              // Öğeyi mevcut alanın tamamına yayar
              Positioned.fill(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Image.asset(
                  // Krallık arka plan görselinin dosya yolunu kullanır
                  ArtAssets.wallpaper,
                  // Görselin ayrılan alana nasıl sığacağını belirler
                  fit: BoxFit.cover,
                  // İçeriğin hangi tarafa hizalanacağını belirler
                  alignment: Alignment.center,
                ),
              ),
              // Görselin üzerine yarı saydam açık renk katman ekler
              // Öğeyi mevcut alanın tamamına yayar
              Positioned.fill(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: DecoratedBox(
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: BoxDecoration(
                    // Birden fazla rengin geçişini tanımlar
                    gradient: LinearGradient(
                      // Renk geçişinin başlayacağı yönü belirler
                      begin: Alignment.topCenter,
                      // Renk geçişinin biteceği yönü belirler
                      end: Alignment.bottomCenter,
                      // Renk geçişinde kullanılacak renkleri listeler
                      colors: [
                        // Renk tonuna belirtilen saydamlık oranını uygular
                        Colors.black.withValues(alpha: 0.15),
                        // Hex kodundan sabit renk oluşturur
                        const Color(0xFFFBF7EF).withValues(alpha: 0.85),
                        // Hex kodundan sabit renk oluşturur
                        const Color(0xFFF4ECE0).withValues(alpha: 0.92),
                      ],
                      // Renklerin geçiş noktalarını belirler
                      stops: const [0.0, 0.18, 1.0],
                    ),
                  ),
                ),
              ),
              // Çağa göre değişen ışık efekti ekler
              // Öğeyi Stack içinde belirli konuma yerleştirir
              Positioned(
                // top alanına 0 değerini kullanır
                top: 0,
                // left alanına 0 değerini kullanır
                left: 0,
                // right alanına 0 değerini kullanır
                right: 0,
                // Elemanın veya satırın yüksekliğini ayarlar
                height: 180,
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: DecoratedBox(
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: BoxDecoration(
                    // Birden fazla rengin geçişini tanımlar
                    gradient: RadialGradient(
                      // Çizim veya geçiş merkezini belirler
                      center: Alignment.topCenter,
                      // Yuvarlak şeklin yarıçapını belirler
                      radius: 1.1,
                      // Renk geçişinde kullanılacak renkleri listeler
                      colors: [
                        // Çağın vurgu rengine saydamlık uygular
                        accent.withValues(alpha: 0.22),
                        // Katmanda tam saydam renk kullanır
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Etkileşimli içeriği ekranın güvenli alanına yerleştirir
              // İçeriği ekranın çentik ve sistem çubuklarından uzak tutar
              SafeArea(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Stack(
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Elemanları dikey yönde sıralar
                    Column(
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // Belirtilen koşul sağlanırsa bu işlemi uygular
                        if (!keyboardVisible)
                          // İçeriğin çevresine boşluk ekler
                          Padding(
                            // İçeriğin kenarlara olan uzaklığını ayarlar
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                            // Bu widgetın içinde gösterilecek elemanı yerleştirir
                            child: Row(
                              // İçeride sıralanacak widgetları listeler
                              children: [
                                // İçeriğin kalan alanı doldurmasını sağlar
                                Expanded(
                                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                  child: Column(
                                    // Ana eksene dik yöndeki hizalamayı belirler
                                    crossAxisAlignment:
                                        // İçeriği başlangıç tarafına hizalar
                                        CrossAxisAlignment.start,
                                    // İçeride sıralanacak widgetları listeler
                                    children: [
                                      // Elemanları yatay yönde sıralar
                                      Row(
                                        // İçeride sıralanacak widgetları listeler
                                        children: [
                                          // Ekrana bir simge yerleştirir
                                          const Icon(
                                              // Menüde kullanılacak simgeyi seçer
                                              Icons.workspace_premium_rounded,
                                              // Bu elemanın rengini belirler
                                              color: Color(0xFFD4AF37),
                                              // Simgenin veya şeklin boyutunu belirler
                                              size: 22),
                                          // Belirtilen ölçülerde boşluk veya alan oluşturur
                                          const SizedBox(width: 5),
                                          // İçeriğin kalan alanı doldurmasını sağlar
                                          Expanded(
                                            // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                            child: Text(
                                              // Gösterilecek veya kullanılacak metin parçasını ekler
                                              'HægæRûetn',
                                              // Metnin veya giriş alanının en fazla satır sayısını belirler
                                              maxLines: 1,
                                              // Uzun metnin alana sığmayınca nasıl davranacağını belirler
                                              overflow: TextOverflow.ellipsis,
                                              // Yazının ya da butonun görünümünü belirler
                                              style: Theme.of(context)
                                                  // Aktif temanın metin stillerini kullanır
                                                  .textTheme
                                                  // Temadan ilgili yazı stilini seçer
                                                  .headlineSmall
                                                  // Nesne null değilse bu işleme devam eder
                                                  ?.copyWith(
                                                    // Yazının boyutunu belirler
                                                    fontSize: 26,
                                                    // Bu elemanın rengini belirler
                                                    color: accent,
                                                    // Yazının kalınlığını belirler
                                                    fontWeight: FontWeight.w900,
                                                    // Harfler arasındaki uzaklığı ayarlar
                                                    letterSpacing: -0.5,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                                      const SizedBox(height: 2),
                                      // Elemanları yatay yönde sıralar
                                      Row(
                                        // İçeride sıralanacak widgetları listeler
                                        children: [
                                          // Arka plan ve ölçüleri olan bir kutu oluşturur
                                          Container(
                                            // Elemanın genişliğini belirler
                                            width: 6,
                                            // Elemanın veya satırın yüksekliğini ayarlar
                                            height: 6,
                                            // Kutunun arka plan, kenar ve süslerini ayarlar
                                            decoration: BoxDecoration(
                                              // Kutunun veya butonun geometrik biçimini belirler
                                              shape: BoxShape.circle,
                                              // Bu elemanın rengini belirler
                                              color: accent,
                                            ),
                                          ),
                                          // Belirtilen ölçülerde boşluk veya alan oluşturur
                                          const SizedBox(width: 5),
                                          // İçeriğin kalan alanı doldurmasını sağlar
                                          Expanded(
                                            // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                            child: Text(
                                              // Gösterilecek veya kullanılacak metin parçasını ekler
                                              'Ałek’ryŧhæ • ${c.era.name} Çağı',
                                              // Metnin veya giriş alanının en fazla satır sayısını belirler
                                              maxLines: 1,
                                              // Uzun metnin alana sığmayınca nasıl davranacağını belirler
                                              overflow: TextOverflow.ellipsis,
                                              // Yazının ya da butonun görünümünü belirler
                                              style: const TextStyle(
                                                // Yazının boyutunu belirler
                                                fontSize: 11.5,
                                                // Yazının kalınlığını belirler
                                                fontWeight: FontWeight.w800,
                                                // Bu elemanın rengini belirler
                                                color: Color(0xFF5E5445),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Yeni FramedIconBadge nesnesi oluşturur
                                FramedIconBadge(
                                  // Buton veya kartta kullanılacak simgeyi seçer
                                  icon: Icons.shield_outlined,
                                  // Butonun ya da etiketin görünen yazısını belirler
                                  label: 'Seviye',
                                  // Gösterilecek güncel değeri atar
                                  value: '${c.level}',
                                  // Bu elemanın rengini belirler
                                  color: c.era.primary,
                                ),
                                // Belirtilen ölçülerde boşluk veya alan oluşturur
                                const SizedBox(width: 8),
                                // Arka plan ve ölçüleri olan bir kutu oluşturur
                                Container(
                                  // Elemanın genişliğini belirler
                                  width: 44,
                                  // Elemanın veya satırın yüksekliğini ayarlar
                                  height: 44,
                                  // Kutunun arka plan, kenar ve süslerini ayarlar
                                  decoration: BoxDecoration(
                                    // Kutunun veya butonun geometrik biçimini belirler
                                    shape: BoxShape.circle,
                                    // Birden fazla rengin geçişini tanımlar
                                    gradient: LinearGradient(
                                      // Renk geçişinde kullanılacak renkleri listeler
                                      colors: [
                                        // Mevcut çağın vurgu rengini kullanır
                                        c.era.accent,
                                        // Verilen iki renk arasında yumuşak geçiş hesaplar
                                        Color.lerp(
                                            // Çağın vurgu rengini yüzde 30 beyazla karıştırır
                                            c.era.accent, Colors.white, .3)!,
                                      ],
                                    ),
                                    // Kutunun kenarlık çizgisini oluşturur
                                    border: Border.all(
                                        // Bu elemanın rengini belirler
                                        color: const Color(0xFFE5C368),
                                        // Elemanın genişliğini belirler
                                        width: 1.5),
                                    // Kutunun gölge ayarlarını belirler
                                    boxShadow: [
                                      // Kutunun düşen gölgesini tanımlar
                                      BoxShadow(
                                        // Bu elemanın rengini belirler
                                        color: const Color(0xFF4A3816)
                                            // Rengin saydamlığını yüzde 12 yapar
                                            .withValues(alpha: 0.12),
                                        // Gölgenin ne kadar dağıtılacağını belirler
                                        blurRadius: 8,
                                        // Çizimin hangi yönde kaydırılacağını belirler
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                  child: Icon(
                                      // Menüde kullanılacak simgeyi seçer
                                      Icons.notifications_active_outlined,
                                      // Bu elemanın rengini belirler
                                      color: c.era.primary,
                                      // Simgenin veya şeklin boyutunu belirler
                                      size: 20),
                                ),
                              ],
                            ),
                          ),
                        // Belirtilen koşul sağlanırsa bu işlemi uygular
                        if (!keyboardVisible)
                          // İçeriğin çevresine boşluk ekler
                          Padding(
                            // İçeriğin kenarlara olan uzaklığını ayarlar
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                            // Bu widgetın içinde gösterilecek elemanı yerleştirir
                            child: AnimatedSwitcher(
                              // Animasyonun veya zaman aşımının süresini belirler
                              duration: const Duration(milliseconds: 450),
                              // Bu widgetın içinde gösterilecek elemanı yerleştirir
                              child: HeraldBanner(
                                // Widgetın kimliğini belirler
                                key: ValueKey<String>(_heraldText(c)),
                                // Kullanıcıya gösterilecek mesajı belirler
                                message: _heraldText(c),
                                // accent alanına gelen değeri kullanır
                                accent: c.era.primary,
                              ),
                            ),
                          ),
                        // İçeriğin kalan alanı doldurmasını sağlar
                        Expanded(
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: IndexedStack(
                            // Aktif sekme veya öğenin sıra numarasını belirler
                            index: selected,
                            // İçeride sıralanacak widgetları listeler
                            children: [
                              // Yeni HabitsScreen nesnesi oluşturur
                              HabitsScreen(controller: c),
                              // Yeni PactsScreen nesnesi oluşturur
                              PactsScreen(controller: c),
                              // Yeni PlazaScreen nesnesi oluşturur
                              PlazaScreen(controller: c),
                              // Yeni GuideScreen nesnesi oluşturur
                              GuideScreen(controller: c),
                              // Yeni ChronicleScreen nesnesi oluşturur
                              ChronicleScreen(controller: c),
                            ],
                          ),
                        ),
                        // Beş krallık bölümü arasında geçiş menüsü oluşturur
                        _BottomRealmNavigation(
                          // Öğenin aktif seçili durumda olup olmadığını belirler
                          selected: selected,
                          // labels alanına gelen değeri kullanır
                          labels: labels,
                          // icons alanına gelen değeri kullanır
                          icons: icons,
                          // accent alanına gelen değeri kullanır
                          accent: c.era.primary,
                          // highlight alanına gelen değeri kullanır
                          highlight: c.era.accent,
                          // Dokunulunca seçili öğeyi değiştirip ekranı günceller
                          onTap: (index) => setState(() => selected = index),
                        ),
                      ],
                    ),
                    // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
                    if (burstMessage != null)
                      // Öğeyi mevcut alanın tamamına yayar
                      Positioned.fill(
                        // Bu widgetın içinde gösterilecek elemanı yerleştirir
                        child: GestureDetector(
                          // Dokunulunca seçili öğeyi değiştirip ekranı günceller
                          onTap: () => setState(() => burstMessage = null),
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: Container(
                            // Bu elemanın rengini belirler
                            color:
                                // Hex kodundan sabit renk oluşturur
                                const Color(0xFF173832).withValues(alpha: .34),
                            // İçeriğin hangi tarafa hizalanacağını belirler
                            alignment: Alignment.center,
                            // Bu widgetın içinde gösterilecek elemanı yerleştirir
                            child: TweenAnimationBuilder<double>(
                              // tween alanına gelen değeri kullanır
                              tween: Tween(begin: .45, end: 1),
                              // Animasyonun veya zaman aşımının süresini belirler
                              duration: const Duration(milliseconds: 500),
                              // Animasyonun hız değişimini belirler
                              curve: Curves.elasticOut,
                              // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
                              builder: (context, scale, child) =>
                                  // transform.scale bileşenini oluşturur
                                  Transform.scale(scale: scale, child: child),
                              // Bu widgetın içinde gösterilecek elemanı yerleştirir
                              child: OrnateCard(
                                // Bu elemanın rengini belirler
                                color: const Color(0xFFFFF7DF),
                                // border color alanına gelen değeri kullanır
                                borderColor: c.era.accent,
                                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                child: Padding(
                                  // İçeriğin kenarlara olan uzaklığını ayarlar
                                  padding: const EdgeInsets.symmetric(
                                      // horizontal alanına 14, vertical: 10) değerini kullanır
                                      horizontal: 14, vertical: 10),
                                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                                  child: Column(
                                    // Ana yönde kaplanacak alanı belirler
                                    mainAxisSize: MainAxisSize.min,
                                    // İçeride sıralanacak widgetları listeler
                                    children: [
                                      // Ekrana bir simge yerleştirir
                                      Icon(Icons.auto_awesome,
                                          // Bu elemanın rengini belirler
                                          color: c.era.primary, size: 68),
                                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                                      const SizedBox(height: 14),
                                      // Ekrana metin yerleştirir
                                      Text(
                                        // Gösterilecek veya kullanılacak metin parçasını ekler
                                        'FERMAN!',
                                        // Yazının ya da butonun görünümünü belirler
                                        style: TextStyle(
                                            // Bu elemanın rengini belirler
                                            color: c.era.primary,
                                            // Yazının kalınlığını belirler
                                            fontWeight: FontWeight.w900,
                                            // Yazının boyutunu belirler
                                            fontSize: 28),
                                      ),
                                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                                      const SizedBox(height: 10),
                                      // Ekrana metin yerleştirir
                                      Text(
                                        // Kazanılan başarı için geçici kutlama mesajını gösterir
                                        burstMessage!,
                                        // text align alanına gelen değeri kullanır
                                        textAlign: TextAlign.center,
                                        // Yazının ya da butonun görünümünü belirler
                                        style: const TextStyle(
                                            // Yazının kalınlığını belirler
                                            fontWeight: FontWeight.w700),
                                      ),
                                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                                      const SizedBox(height: 12),
                                      // Ekrana metin yerleştirir
                                      const Text(
                                        // Gösterilecek veya kullanılacak metin parçasını ekler
                                        'Dokun ve sefere devam et',
                                        // Yazının ya da butonun görünümünü belirler
                                        style: TextStyle(
                                            // Yazının boyutunu belirler
                                            fontSize: 11,
                                            // Bu elemanın rengini belirler
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// Krallık ekranları arasında geçiş için alt menü oluşturur
class _BottomRealmNavigation extends StatelessWidget {
  // _BottomRealmNavigation nesnesinin başlangıç bilgilerini alır
  const _BottomRealmNavigation({
    // seçilenler parametresini zorunlu tutar
    required this.selected,
    // labels parametresini zorunlu tutar
    required this.labels,
    // icons parametresini zorunlu tutar
    required this.icons,
    // accent parametresini zorunlu tutar
    required this.accent,
    // highlight parametresini zorunlu tutar
    required this.highlight,
    // on tap parametresini zorunlu tutar
    required this.onTap,
  });
  // Seçili menü veya öğenin indeksini tutar
  final int selected;
  // labels bilgisini saklar
  final List<String> labels;
  // icons bilgisini saklar
  final List<IconData> icons;
  // Vurgu rengini tutar
  final Color accent;
  // highlight bilgisini saklar
  final Color highlight;
  // on tap bilgisini saklar
  final ValueChanged<int> onTap;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _BottomRealmNavigation için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Bu elemanın rengini belirler
        color: const Color(0xFFF7F2E4),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border(
          // top alanına gelen değeri kullanır
          top: BorderSide(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFFDEC582).withValues(alpha: 0.95),
            // Elemanın genişliğini belirler
            width: 1.8,
          ),
        ),
        // Kutunun gölge ayarlarını belirler
        boxShadow: [
          // Kutunun düşen gölgesini tanımlar
          BoxShadow(
            // Rengin saydamlığını belirtilen oranda ayarlar
            color: const Color(0xFF3E311A).withValues(alpha: 0.12),
            // Gölgenin ne kadar dağıtılacağını belirler
            blurRadius: 20,
            // Çizimin hangi yönde kaydırılacağını belirler
            offset: const Offset(0, -6),
          ),
        ],
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Row(
        // Ana eksene dik yöndeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.end,
        // İçeride sıralanacak widgetları listeler
        children: List.generate(labels.length, (index) {
          // center bilgisini saklar
          final isCenter = index == 2;
          // seçilenler bilgisini saklar
          final isSelected = selected == index;
          // İçeriğin kalan alanı doldurmasını sağlar
          return Expanded(
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: InkWell(
              // Dokunulduğunda çalışacak işlemi bağlar
              onTap: () => onTap(index),
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(20),
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Padding(
                // İçeriğin kenarlara olan uzaklığını ayarlar
                padding: EdgeInsets.only(top: isCenter ? 0 : 6),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Column(
                  // Ana yönde kaplanacak alanı belirler
                  mainAxisSize: MainAxisSize.min,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Arka plan ve ölçüleri olan bir kutu oluşturur
                    Container(
                      // Elemanın genişliğini belirler
                      width: isCenter ? 72 : 50,
                      // Elemanın veya satırın yüksekliğini ayarlar
                      height: isCenter ? 72 : 50,
                      // Kutunun arka plan, kenar ve süslerini ayarlar
                      decoration: BoxDecoration(
                        // Kutunun veya butonun geometrik biçimini belirler
                        shape: BoxShape.circle,
                        // Kutunun kenarlık çizgisini oluşturur
                        border: Border.all(
                          // Bu elemanın rengini belirler
                          color: isSelected
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? const Color(0xFFE5C568)
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : const Color(0xFFD7CCB7),
                          // Elemanın genişliğini belirler
                          width: isCenter ? 2.4 : 1.4,
                        ),
                        // Birden fazla rengin geçişini tanımlar
                        gradient: LinearGradient(
                          // Renk geçişinin başlayacağı yönü belirler
                          begin: Alignment.topCenter,
                          // Renk geçişinin biteceği yönü belirler
                          end: Alignment.bottomCenter,
                          // Renk geçişinde kullanılacak renkleri listeler
                          colors: isSelected
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? [
                                  // Verilen iki renk arasında yumuşak geçiş hesaplar
                                  Color.lerp(highlight, Colors.white, .22)!,
                                  // Bu öğenin menünün merkezinde olup olmadığını kullanır
                                  isCenter
                                      // Koşul doğruysa kullanılacak sonucu belirler
                                      ? accent
                                      // Koşul yanlışsa kullanılacak sonucu belirler
                                      : Color.lerp(accent, Colors.black, .08)!
                                ]
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : [Colors.white, const Color(0xFFF0E7D4)],
                        ),
                        // Kutunun gölge ayarlarını belirler
                        boxShadow: [
                          // Kutunun düşen gölgesini tanımlar
                          BoxShadow(
                            // Bu elemanın rengini belirler
                            color: isCenter
                                // Koşul doğruysa kullanılacak sonucu belirler
                                ? accent.withValues(alpha: 0.28)
                                // Koşul yanlışsa kullanılacak sonucu belirler
                                : const Color(0xFF41351C)
                                    // Rengin saydamlığını yüzde 8 yapar
                                    .withValues(alpha: .08),
                            // Gölgenin ne kadar dağıtılacağını belirler
                            blurRadius: isCenter ? 14 : 8,
                            // Çizimin hangi yönde kaydırılacağını belirler
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      // Bu widgetın içinde gösterilecek elemanı yerleştirir
                      child: Icon(
                        // Seçilen sekmenin simgesini gösterir
                        icons[index],
                        // Bu elemanın rengini belirler
                        color: isSelected
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? (isCenter ? Colors.white : accent)
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : const Color(0xFF777466),
                        // Simgenin veya şeklin boyutunu belirler
                        size: isCenter ? 32 : 24,
                      ),
                    ),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 5),
                    // Ekrana metin yerleştirir
                    Text(
                      // Seçilen sekmenin adını gösterir
                      labels[index],
                      // Yazının ya da butonun görünümünü belirler
                      style: TextStyle(
                        // Yazının boyutunu belirler
                        fontSize: isCenter ? 11.5 : 10.5,
                        // Yazının kalınlığını belirler
                        fontWeight:
                            // Aktif sekmenin yazısını daha kalın yapar
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                        // Bu elemanın rengini belirler
                        color: isSelected ? accent : const Color(0xFF726B5F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

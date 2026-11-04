// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Ortak krallık kartlarını projeye ekler
import '../../core/widgets/realm_card.dart';
// Meydanda destek mesajları taslağı hazırlatır
class PlazaScreen extends StatefulWidget {
  // PlazaScreen nesnesinin başlangıç bilgilerini alır
  const PlazaScreen({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<PlazaScreen> createState() => _PlazaScreenState();
}
// plaza screen state bilgilerini ve ilgili davranışları tanımlar
class _PlazaScreenState extends State<PlazaScreen> {
  // encouragement öğelerini içeren listeyi hazırlar
  final encouragement = const [
    (
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Gezgin Lâvren',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Bugün ancak beş dakika çalışabildim. Yine de defteri açmış olmak güzel.'
    ),
    (
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Mühürdar Eril',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Yedi gün hedefimi tamamladım! Küçük adımlardan koca yol çıktı.'
    ),
    (
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'İzci Sylra',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Dün aksattım, bugün daha küçük bir hedefle yeniden başladım.'
    ),
  ];
  // mesajlar öğelerini içeren listeyi hazırlar
  final messages = <String>[];
  // draft metin girişini kontrol eder
  final draft = TextEditingController();
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Artık kullanılmayan controller kaynaklarını temizler
    draft.dispose();
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _PlazaScreenState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Vurgu rengini tutar
    final accent = widget.controller.era.primary;
    // Kaydırılabilir öğe listesi oluşturur
    return ListView(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      // İçeride sıralanacak widgetları listeler
      children: [
        // Yeni FancyHeroHeader nesnesi oluşturur
        FancyHeroHeader(
          // başlık alanına gösterilecek metni belirler
          title: 'Gayret Meydanı',
          // subtitle alanına değerini belirler
          subtitle:
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'Yoldaşını güçlendir; kendi yolunu da aydınlat. Yardım ettikçe erdemin artsın.',
          // Gösterilecek görselin dosya yolunu belirler
          assetPath: ArtAssets.plaza,
          // Elemanın veya satırın yüksekliğini ayarlar
          height: 185,
          // rozet alanına gelen değeri kullanır
          badge: FramedIconBadge(
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.volunteer_activism_outlined,
            // Butonun ya da etiketin görünen yazısını belirler
            label: 'Erdem',
            // Gösterilecek güncel değeri atar
            value: '—',
            // Bu elemanın rengini belirler
            color: accent,
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 15),
        // RealmCard nesnesinin başlangıç bilgilerini alır
        const RealmCard(
          // Bu elemanın rengini belirler
          color: Color(0xFFFFEDCD),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Row(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Ekrana bir simge yerleştirir
              Icon(Icons.groups_2_outlined, size: 32, color: Color(0xFF9B6229)),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              SizedBox(width: 12),
              // İçeriğin kalan alanı doldurmasını sağlar
              Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Column(
                  // Ana eksene dik yöndeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Ekrana metin yerleştirir
                    Text('Topluluk önizlemesi',
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(
                            // Yazının kalınlığını belirler
                            fontWeight: FontWeight.w900, fontSize: 17)),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    SizedBox(height: 5),
                    // Ekrana metin yerleştirir
                    Text(
                        // Gösterilecek veya kullanılacak metin parçasını ekler
                        'Bu meydandaki kişiler ve iletiler kurgusaldır. Mesajların sadece bu oturumda gösterilir, başka kullanıcılara gönderilmez. Gerçek topluluk özelliği henüz bağlı değil.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 18),
        // SectionTitle nesnesinin başlangıç bilgilerini alır
        const SectionTitle('Meydandan sesler',
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.record_voice_over_rounded),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 9),
        // Aynı nesnede ek çizim ayarını yapar
        ...encouragement.map(
          // Her meydan mesajı için boşluklu bir alan oluşturur
          (entry) => Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.only(bottom: 9),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: RealmCard(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Column(
                // Ana eksene dik yöndeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // İçeride sıralanacak widgetları listeler
                children: [
                  // Elemanları yatay yönde sıralar
                  Row(
                    // İçeride sıralanacak widgetları listeler
                    children: [
                      // Yuvarlak arka planda simge veya görsel gösterir
                      const CircleAvatar(
                          // Yuvarlak şeklin yarıçapını belirler
                          radius: 15, child: Icon(Icons.person, size: 16)),
                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                      const SizedBox(width: 9),
                      // Ekrana metin yerleştirir
                      Text(entry.$1,
                          // Yazının ya da butonun görünümünü belirler
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                  // Belirtilen ölçülerde boşluk veya alan oluşturur
                  const SizedBox(height: 9),
                  // Ekrana metin yerleştirir
                  Text(entry.$2),
                  // Belirtilen ölçülerde boşluk veya alan oluşturur
                  const SizedBox(height: 9),
                  // RealmPill nesnesinin başlangıç bilgilerini alır
                  const RealmPill(
                      // Butonun ya da etiketin görünen yazısını belirler
                      label: 'Örnek karakter',
                      // Buton veya kartta kullanılacak simgeyi seçer
                      icon: Icons.theater_comedy_outlined),
                ],
              ),
            ),
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 8),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Ekrana metin yerleştirir
              const Text('Bir destek mesajı taslağı yaz',
                  // Yazının ya da butonun görünümünü belirler
                  style: TextStyle(fontWeight: FontWeight.w900)),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 10),
              // Kullanıcının yazı girebileceği alanı oluşturur
              TextField(
                // Metin veya liste kontrolcüsünü ilgili alana bağlar
                controller: draft,
                // Metnin veya giriş alanının en fazla satır sayısını belirler
                maxLines: 3,
                // Yazılabilecek en fazla karakter sayısını belirler
                maxLength: 280,
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: const InputDecoration(
                    // Alan boşken kullanıcıya örnek giriş metnini gösterir
                    hintText: 'Örn. Küçük adım da ilerlemedir, devam!'),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 5),
              // Yeni OrnateButton nesnesi oluşturur
              OrnateButton(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'Taslağı burada göster',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.edit_note,
                // İçeriğin açık olup olmadığını belirler
                expanded: true,
                // Butona basılınca çalışacak fonksiyonu bağlar
                onPressed: () {
                  // Gerekli liste ya da metin boşsa işlem yapmaz
                  if (draft.text.trim().isEmpty) return;
                  // Değişen bilgiyi ekrana yansıtmak için Statei günceller
                  setState(() {
                    // Yeni destek mesajı taslağını listenin başına ekler
                    messages.insert(0, draft.text.trim());
                    // İlgili koleksiyonu veya metin alanını temizler
                    draft.clear();
                  });
                },
              ),
            ],
          ),
        ),
        // Kullanılabilir veri varsa devam eder
        if (messages.isNotEmpty) ...[
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 14),
          // SectionTitle nesnesinin başlangıç bilgilerini alır
          const SectionTitle('Bu oturumdaki taslakların',
              // Buton veya kartta kullanılacak simgeyi seçer
              icon: Icons.forum_outlined),
          // Aynı nesnede ek çizim ayarını yapar
          ...messages.map((m) => Padding(
              // İçeriğin kenarlara olan uzaklığını ayarlar
              padding: const EdgeInsets.only(top: 8),
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: RealmCard(child: Text(m)))),
        ],
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 17),
        // Ekrana metin yerleştirir
        const Text(
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Erdem rozetleri, yalnızca gerçek topluluk servisi bağlandıktan sonra doğrulanmış yardımlarla kazanılacak.',
          // Yazının ya da butonun görünümünü belirler
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}

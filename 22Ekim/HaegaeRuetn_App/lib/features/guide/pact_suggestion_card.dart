// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// AI ahit önerisi modelini projeye ekler
import '../../core/services/ai/pact_suggestion.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Krallık tema ayarlarını projeye ekler
import '../../core/theme/realm_theme.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Interactive preview card for AI-suggested pacts.
// Requires explicit user confirmation to sign the pact.
// Önerilen ahdi önizleyip kullanıcı onayıyla ekler
class PactSuggestionCard extends StatefulWidget {
  // PactSuggestionCard nesnesinin başlangıç bilgilerini alır
  const PactSuggestionCard({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // suggestion parametresini zorunlu tutar
    required this.suggestion,
    // realm controller için isteğe bağlı başlangıç değeri alır
    this.realmController,
    // on ahit signed için isteğe bağlı başlangıç değeri alır
    this.onPactSigned,
  });
  // suggestion bilgisini saklar
  final PactSuggestion suggestion;
  // realm controller bilgisini saklar
  final RealmController? realmController;
  // on ahit signed bilgisini saklar
  final VoidCallback? onPactSigned;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<PactSuggestionCard> createState() => _PactSuggestionCardState();
}
// ahit suggestion card state bilgilerini ve ilgili davranışları tanımlar
class _PactSuggestionCardState extends State<PactSuggestionCard> {
  // signed bilgisini saklar
  bool _signed = false;
  // Önerideki geçerli vazifelerle kullanıcı onaylı ahit oluşturur
  void _signPact() {
    // c bilgisini saklar
    final c = widget.realmController;
    // Gerekli veri yoksa alternatif işlem yolunu kullanır
    if (c == null) return;
    // s bilgisini saklar
    final s = widget.suggestion;
    // Map habit IDs or find active ones
    // kullanılabilir bilgisini saklar
    final available = c.activeHabits;
    // valid ids öğelerini içeren listeyi hazırlar
    final validIds = <String>[];
    // Vazifeleri tek tek dolaşıp durumlarını kontrol eder
    for (final id in s.habitIds) {
      // Belirtilen koşul sağlanırsa bu işlemi uygular
      if (available.any((h) => h.id == id)) {
        // Yeni öğeyi ilgili listeye veya kümeye ekler
        validIds.add(id);
      }
    }
    // Gerekli liste ya da metin boşsa işlem yapmaz
    if (validIds.isEmpty && available.isNotEmpty) {
      // Yeni öğeyi ilgili listeye veya kümeye ekler
      validIds.add(available.first.id);
    }
    // Geçerli vazife bulunamadığında kullanıcıyı uyarır
    if (validIds.isEmpty) {
      // scaffold messenger.of bileşenini oluşturur
      ScaffoldMessenger.of(context).showSnackBar(
        // Ekranın altında kısa bilgilendirme mesajı gösterir
        const SnackBar(
          // Mesajın veya pencerenin içeriğini belirler
          content:
              // Ekrana metin yerleştirir
              Text('Ahit imzalamak için önce en az bir aktif vazifen olmalı.'),
        ),
      );
      // Kalan işlemleri çalıştırmadan çıkar
      return;
    }
    // Yeni öğeyi ilgili listeye veya kümeye ekler
    c.addPact(s.title, validIds, s.targetDays);
    // Değişen bilgiyi ekrana yansıtmak için Statei günceller
    setState(() => _signed = true);
    // Değer null değilse ilgili özelliğini kullanır
    widget.onPactSigned?.call();
    // scaffold messenger.of bileşenini oluşturur
    ScaffoldMessenger.of(context).showSnackBar(
      // Ekranın altında kısa bilgilendirme mesajı gösterir
      SnackBar(
        // Arka plan rengini belirler
        backgroundColor: const Color(0xFF1B4332),
        // Mesajın veya pencerenin içeriğini belirler
        content: Row(
          // İçeride sıralanacak widgetları listeler
          children: [
            // Ekrana bir simge yerleştirir
            const Icon(Icons.verified_rounded, color: Color(0xFFFFD166)),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(width: 8),
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text('“${s.title}” ahdi mühürlendi ve deftere işlendi!'),
            ),
          ],
        ),
      ),
    );
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _PactSuggestionCardState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // s bilgisini saklar
    final s = widget.suggestion;
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // Bileşenin dışındaki boşluğu belirler
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: OrnateCard(
        // Bu elemanın rengini belirler
        color: const Color(0xFFFFFBF2),
        // border color alanına belirtilen renk değerini kullanır
        borderColor: const Color(0xFFE2C988),
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: const EdgeInsets.all(14),
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
                // HeraldicSeal nesnesinin başlangıç bilgilerini alır
                const HeraldicSeal(
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: Icons.history_edu_rounded,
                  // Simgenin veya şeklin boyutunu belirler
                  size: 34,
                  // Bu elemanın rengini belirler
                  color: Color(0xFF7D2224),
                  // border color alanına belirtilen renk değerini kullanır
                  borderColor: Color(0xFFFFD166),
                ),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(width: 10),
                // İçeriğin kalan alanı doldurmasını sağlar
                Expanded(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Column(
                    // Ana eksene dik yöndeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçeride sıralanacak widgetları listeler
                    children: [
                      // Ekrana metin yerleştirir
                      const Text(
                        // Gösterilecek veya kullanılacak metin parçasını ekler
                        'ÖNERİLEN KRALLIK AHDİ',
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(
                          // Yazının boyutunu belirler
                          fontSize: 9.5,
                          // Yazının kalınlığını belirler
                          fontWeight: FontWeight.w900,
                          // Bu elemanın rengini belirler
                          color: Color(0xFF8B6415),
                          // Harfler arasındaki uzaklığı ayarlar
                          letterSpacing: 0.5,
                        ),
                      ),
                      // Ekrana metin yerleştirir
                      Text(
                        // Önerilen ahdin başlığını ekranda gösterir
                        s.title,
                        // Yazının ya da butonun görünümünü belirler
                        style: const TextStyle(
                          // Yazının boyutunu belirler
                          fontSize: 15,
                          // Yazının kalınlığını belirler
                          fontWeight: FontWeight.w900,
                          // Bu elemanın rengini belirler
                          color: RealmPalette.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                // Belirtilen koşul sağlanırsa bu işlemi uygular
                if (_signed)
                  // Arka plan ve ölçüleri olan bir kutu oluşturur
                  Container(
                    // İçeriğin kenarlara olan uzaklığını ayarlar
                    padding:
                        // EdgeInsets nesnesi için başlangıç değerlerini alır
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Bu elemanın rengini belirler
                      color: const Color(0xFFE2F4EA),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(12),
                      // Kutunun kenarlık çizgisini oluşturur
                      border: Border.all(color: const Color(0xFF8FCFA9)),
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: const Row(
                      // Ana yönde kaplanacak alanı belirler
                      mainAxisSize: MainAxisSize.min,
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // Ekrana bir simge yerleştirir
                        Icon(Icons.check_circle_rounded,
                            // Simgenin veya şeklin boyutunu belirler
                            size: 12, color: Color(0xFF1B6B3E)),
                        // Belirtilen ölçülerde boşluk veya alan oluşturur
                        SizedBox(width: 3),
                        // Ekrana metin yerleştirir
                        Text(
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          'MÜHÜRLENDİ',
                          // Yazının ya da butonun görünümünü belirler
                          style: TextStyle(
                            // Yazının boyutunu belirler
                            fontSize: 9,
                            // Yazının kalınlığını belirler
                            fontWeight: FontWeight.w900,
                            // Bu elemanın rengini belirler
                            color: Color(0xFF1B6B3E),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Kullanılabilir veri varsa devam eder
            if (s.description.isNotEmpty) ...[
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Ekrana metin yerleştirir
              Text(
                // AI önerisinin açıklamasını kartta gösterir
                s.description,
                // Yazının ya da butonun görünümünü belirler
                style: const TextStyle(
                    // Yazının boyutunu belirler
                    fontSize: 12, height: 1.35, color: Color(0xFF4C4538)),
              ),
            ],
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 8),
            // Sığmayan öğeleri bir sonraki satıra geçirir
            Wrap(
              // spacing alanına 6 değerini kullanır
              spacing: 6,
              // run spacing alanına 4 değerini kullanır
              runSpacing: 4,
              // İçeride sıralanacak widgetları listeler
              children: [
                // Arka plan ve ölçüleri olan bir kutu oluşturur
                Container(
                  // İçeriğin kenarlara olan uzaklığını ayarlar
                  padding:
                      // EdgeInsets nesnesi için başlangıç değerlerini alır
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: BoxDecoration(
                    // Bu elemanın rengini belirler
                    color: const Color(0xFFFFEDCD),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(10),
                    // Kutunun kenarlık çizgisini oluşturur
                    border: Border.all(color: const Color(0xFFE8C888)),
                  ),
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Text(
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    '🎯 ${s.targetDays} Günlük Hedef',
                    // Yazının ya da butonun görünümünü belirler
                    style: const TextStyle(
                        // Yazının boyutunu belirler
                        fontSize: 10.5, fontWeight: FontWeight.w800),
                  ),
                ),
                // Kullanılabilir veri varsa devam eder
                if (s.habitNames.isNotEmpty)
                  // Arka plan ve ölçüleri olan bir kutu oluşturur
                  Container(
                    // İçeriğin kenarlara olan uzaklığını ayarlar
                    padding:
                        // EdgeInsets nesnesi için başlangıç değerlerini alır
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Bu elemanın rengini belirler
                      color: const Color(0xFFE8F0FE),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(10),
                      // Kutunun kenarlık çizgisini oluşturur
                      border: Border.all(color: const Color(0xFFB5D1F8)),
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Text(
                      // Gösterilecek veya kullanılacak metin parçasını ekler
                      '🛡️ ${s.habitNames.join(", ")}',
                      // Yazının ya da butonun görünümünü belirler
                      style: const TextStyle(
                          // Yazının boyutunu belirler
                          fontSize: 10.5, fontWeight: FontWeight.w800),
                    ),
                  ),
              ],
            ),
            // Kullanılabilir veri varsa devam eder
            if (s.rationale.isNotEmpty) ...[
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Arka plan ve ölçüleri olan bir kutu oluşturur
              Container(
                // İçeriğin kenarlara olan uzaklığını ayarlar
                padding:
                    // EdgeInsets nesnesi için başlangıç değerlerini alır
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: BoxDecoration(
                  // Bu elemanın rengini belirler
                  color: const Color(0xFFF7F3E6),
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(8),
                  // Kutunun kenarlık çizgisini oluşturur
                  border: const Border(
                      // left alanına gelen değeri kullanır
                      left: BorderSide(color: RealmPalette.gold, width: 2.5)),
                ),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Text(
                  // Gösterilecek veya kullanılacak metin parçasını ekler
                  '“${s.rationale}”',
                  // Yazının ya da butonun görünümünü belirler
                  style: const TextStyle(
                    // Yazının boyutunu belirler
                    fontSize: 11,
                    // Yazının normal veya italik olmasını belirler
                    fontStyle: FontStyle.italic,
                    // Bu elemanın rengini belirler
                    color: Color(0xFF5E5445),
                  ),
                ),
              ),
            ],
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(height: 10),
            // Belirtilen koşul sağlanırsa bu işlemi uygular
            if (!_signed)
              // Yeni OrnateButton nesnesi oluşturur
              OrnateButton(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'Bu Ahdi İmzala ve Başlat',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.history_edu_rounded,
                // İçeriğin açık olup olmadığını belirler
                expanded: true,
                // Basılınca doğrulanan veriyi kaydetmeye çalışır
                onPressed: widget.realmController != null ? _signPact : null,
              ),
          ],
        ),
      ),
    );
  }
}

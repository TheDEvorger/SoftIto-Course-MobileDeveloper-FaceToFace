// Asenkron işlemler için kütüphaneyi ekler
import 'dart:async';
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
// countdown calculator dosyasını kullanıma ekler
import '../../domain/countdown/countdown_calculator.dart';
// garden buttons dosyasını kullanıma ekler
import 'garden_buttons.dart';
// garden cards dosyasını kullanıma ekler
import 'garden_cards.dart';
// yks countdown kart için değişen verileri yöneten StatefulWidget kullanılır
class YksCountdownCard extends StatefulWidget {
  // yks countdown kart kartını oluşturur
  const YksCountdownCard({
    // hedef tarihi bilgisini zorunlu tutar
    required this.targetDate,
    // on edit tarih bilgisini zorunlu tutar
    required this.onEditDate,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // hedef tarihi bilgisini tutar
  final DateTime? targetDate;
  // on edit tarih bilgisini tutar
  final VoidCallback onEditDate;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<YksCountdownCard> createState() => _YksCountdownCardState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _YksCountdownCardState extends State<YksCountdownCard> {
  // İlgili değeri veya görünüm ayarını belirler
  Timer? _ticker;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // ticker if needed bilgisini başlatır
    _startTickerIfNeeded();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widgetın yeni bilgileri geldiğinde çalışır
  void didUpdateWidget(covariant YksCountdownCard oldWidget) {
    // Üst sınıfın ilgili metodunu çalıştırır
    super.didUpdateWidget(oldWidget);
    // Belirtilen koşul doğruysa işlemi yapar
    if (oldWidget.targetDate != widget.targetDate) {
      // cancel işlemini yapar
      _ticker?.cancel();
      // ticker if needed bilgisini başlatır
      _startTickerIfNeeded();
    }
  }
  // ticker if needed bilgisini başlatır
  void _startTickerIfNeeded() {
    // İlgili değer null değilse kontrol eder
    if (widget.targetDate != null) {
      // periodic işlemini yapar
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        // Widget hâlâ ekrandaysa işlemi yapar
        if (mounted) setState(() {});
      });
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // cancel işlemini yapar
    _ticker?.cancel();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // time box bilgisini oluşturur
  Widget _buildTimeBox({
    // değer bilgisini zorunlu tutar
    required String value,
    // etiket bilgisini zorunlu tutar
    required String label,
    // renk bilgisini zorunlu tutar
    required Color color,
    // koyu tema durumu bilgisini zorunlu tutar
    required bool isDark,
  }) {
    // Kalan boşluğu kullanacak alan oluşturur
    return Expanded(
      // İçine yerleştirilecek widgetı belirler
      child: Container(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(vertical: 10),
        // Kutu ve kenarlık görünümünü belirler
        decoration: BoxDecoration(
          // Rengi belirler
          color: isDark ? GardenPalette.nightBackdrop : Colors.white,
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(14),
          // Kenarlığı belirler
          border: Border.all(color: color.withAlpha(isDark ? 90 : 60)),
          // Gölge ayarlarını belirler
          boxShadow: [
            // Kutuya gölge ayarı ekler
            BoxShadow(
              // Rengi belirler
              color: color.withAlpha(isDark ? 20 : 15),
              // Gölgenin konumunu belirler
              offset: const Offset(0, 2),
              // Gölgenin bulanıklığını belirler
              blurRadius: 6,
            ),
          ],
        ),
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // İçerideki widgetları listeler
          children: [
            // Metni ekranda gösterir
            Text(
              // İlgili değeri veya görünüm ayarını belirler
              value,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 22,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.w900,
                // Rengi belirler
                color: color,
                // Harfler arasındaki boşluğu belirler
                letterSpacing: 0.5,
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 2),
            // Metni ekranda gösterir
            Text(
              // İlgili değeri veya görünüm ayarını belirler
              label,
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 11,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Rengi belirler
                color: isDark ? const Color(0xFFC7BDC8) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // sonuç bilgisini hesaplayıp saklar
    final result = CountdownCalculator.calculate(
      // hedef tarihi bilgisini belirler
      targetDate: widget.targetDate,
      // şimdiki zaman bilgisini belirler
      now: DateTime.now(),
    );
    // Belirtilen koşul doğruysa işlemi yapar
    if (result.isNotSet) {
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
                    color: GardenPalette.peachCoral.withAlpha(25),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: const Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.event_available_outlined,
                    // Rengi belirler
                    color: GardenPalette.peachCoral,
                    // Boyutu belirler
                    size: 22,
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(width: 12),
                // Kalan boşluğu kullanacak alan oluşturur
                const Expanded(
                  // İçine yerleştirilecek widgetı belirler
                  child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki widgetları listeler
                    children: [
                      // Metni ekranda gösterir
                      Text(
                        // "Sınav Tarihi Henüz Belirlenmedi" metnini kullanır
                        'Sınav Tarihi Henüz Belirlenmedi',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 15,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Metni ekranda gösterir
                      Text(
                        // "Resmî YKS tarihini veya hedef tarihini beli…" metnini kullanır
                        'Resmî YKS tarihini veya hedef tarihini belirle.',
                        // Görünüm stilini belirler
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 14),
            // garden primary button nesnesini oluşturur
            GardenPrimaryButton(
              // Buton veya alan yazısını belirler
              label: 'Sınav Tarihini Belirle',
              // simge bilgisini belirler
              icon: Icons.calendar_month,
              // Basılınca çalışacak fonksiyonu belirler
              onPressed: widget.onEditDate,
              // Yüksekliği belirler
              height: 44,
            ),
          ],
        ),
      );
    }
    // Belirtilen koşul doğruysa işlemi yapar
    if (result.isCompleted) {
      // garden kart kartını oluşturur
      return GardenCard(
        // border renk bilgisini belirler
        borderColor: GardenPalette.harvestGold,
        // İçine yerleştirilecek widgetı belirler
        child: Row(
          // İçerideki widgetları listeler
          children: [
            // Görsel bir kutu oluşturur
            Container(
              // İç boşlukları belirler
              padding: const EdgeInsets.all(10),
              // Kutu ve kenarlık görünümünü belirler
              decoration: const BoxDecoration(
                // Widgetın kenar şeklini belirler
                shape: BoxShape.circle,
                // Rengi belirler
                color: GardenPalette.harvestGold,
              ),
              // İçine yerleştirilecek widgetı belirler
              child:
                  // Simge gösterir
                  const Icon(Icons.celebration, color: Colors.white, size: 26),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(width: 14),
            // Kalan boşluğu kullanacak alan oluşturur
            Expanded(
              // İçine yerleştirilecek widgetı belirler
              child: Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // İçerideki widgetları listeler
                children: [
                  // Metni ekranda gösterir
                  const Text(
                    // "Sınav Günü Geldi! 🌱" metnini kullanır
                    'Sınav Günü Geldi! 🌱',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 2),
                  // Metni ekranda gösterir
                  const Text(
                    // "Ektiğin tüm tohumlar filizlendi. Başarılar …" metnini kullanır
                    'Ektiğin tüm tohumlar filizlendi. Başarılar dileriz!',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(height: 6),
                  // Dokunma hareketlerini dinler
                  GestureDetector(
                    // Dokunulunca çalışacak fonksiyonu belirler
                    onTap: widget.onEditDate,
                    // İçine yerleştirilecek widgetı belirler
                    child: const Text(
                      // "Tarihi Güncelle" metnini kullanır
                      'Tarihi Güncelle',
                      // Görünüm stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 12,
                        // Yazı kalınlığını belirler
                        fontWeight: FontWeight.bold,
                        // Rengi belirler
                        color: GardenPalette.mossEmerald,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // d bilgisini hesaplayıp saklar
    final d = widget.targetDate!;
    // tarih string değerini tanımlar
    final dateString =
        // "${d.day.toString().padLeft(2, '0')}.${d.mon…" metnini kullanır
        '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
              // Elemanları yan yana dizer
              Row(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  const Icon(
                    // Gösterilecek simgeyi belirler
                    Icons.hourglass_top,
                    // Boyutu belirler
                    size: 18,
                    // Rengi belirler
                    color: GardenPalette.peachCoral,
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // Metni ekranda gösterir
                  Text(
                    // "YKS Geri Sayımı" metnini kullanır
                    'YKS Geri Sayımı',
                    // Görünüm stilini belirler
                    style: TextStyle(
                      // Yazı boyutunu belirler
                      fontSize: 14,
                      // Yazı kalınlığını belirler
                      fontWeight: FontWeight.bold,
                      // Rengi belirler
                      color: isDark
                          // Koşul doğruysa bu değeri kullanır
                          ? const Color(0xFFF8F2E8)
                          // Koşul yanlışsa bu değeri kullanır
                          : GardenPalette.inkPlum,
                    ),
                  ),
                ],
              ),
              // Tıklanabilir alan oluşturur
              InkWell(
                // Dokunulunca çalışacak fonksiyonu belirler
                onTap: widget.onEditDate,
                // Köşelerin yuvarlaklığını belirler
                borderRadius: BorderRadius.circular(8),
                // İçine yerleştirilecek widgetı belirler
                child: Padding(
                  // İç boşlukları belirler
                  padding:
                      // Yatay ve dikey boşlukları belirler
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // İçerideki widgetları listeler
                    children: [
                      // Simge gösterir
                      Icon(Icons.edit_calendar,
                          // Boyutu belirler
                          size: 15,
                          // Rengi belirler
                          color: isDark
                              // Koşul doğruysa bu değeri kullanır
                              ? const Color(0xFFA4D49B)
                              // Koşul yanlışsa bu değeri kullanır
                              : GardenPalette.mossEmerald),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 4),
                      // Metni ekranda gösterir
                      Text(
                        // "Değiştir" metnini kullanır
                        'Değiştir',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 12,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: isDark
                              // Koşul doğruysa bu değeri kullanır
                              ? const Color(0xFFA4D49B)
                              // Koşul yanlışsa bu değeri kullanır
                              : GardenPalette.mossEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // Elemanları yan yana dizer
          Row(
            // İçerideki widgetları listeler
            children: [
              // İlgili fonksiyonu çalıştırır
              _buildTimeBox(
                // Kullanılacak değeri belirler
                value: '${result.days}',
                // Buton veya alan yazısını belirler
                label: 'GÜN',
                // Rengi belirler
                color: GardenPalette.peachCoral,
                // Koyu tema durumunu belirler
                isDark: isDark,
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 8),
              // İlgili fonksiyonu çalıştırır
              _buildTimeBox(
                // Kullanılacak değeri belirler
                value: '${result.hours}',
                // Buton veya alan yazısını belirler
                label: 'SAAT',
                // Rengi belirler
                color: GardenPalette.harvestGold,
                // Koyu tema durumunu belirler
                isDark: isDark,
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 8),
              // İlgili fonksiyonu çalıştırır
              _buildTimeBox(
                // Kullanılacak değeri belirler
                value: '${result.minutes}',
                // Buton veya alan yazısını belirler
                label: 'DAKİKA',
                // Rengi belirler
                color: GardenPalette.mossEmerald,
                // Koyu tema durumunu belirler
                isDark: isDark,
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(width: 8),
              // İlgili fonksiyonu çalıştırır
              _buildTimeBox(
                // Kullanılacak değeri belirler
                value: '${result.seconds}',
                // Buton veya alan yazısını belirler
                label: 'SANİYE',
                // Rengi belirler
                color: GardenPalette.streamTurquoise,
                // Koyu tema durumunu belirler
                isDark: isDark,
              ),
            ],
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 10),
          // İçeriği ortalar
          Center(
            // İçine yerleştirilecek widgetı belirler
            child: Text(
              // "Hedef: $dateString" metnini kullanır
              'Hedef: $dateString',
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 11,
                // Rengi belirler
                color: isDark ? Colors.white54 : Colors.grey.shade600,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

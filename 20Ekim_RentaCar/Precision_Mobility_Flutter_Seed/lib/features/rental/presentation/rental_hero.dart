// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// kiralama giriş alanı görünümünü oluşturan widget sınıfı
class RentalHero extends StatelessWidget {
  // kiralama giriş alanı nesnesi oluşturur
  const RentalHero({super.key});
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // compact değerini belirler
        final compact = constraints.maxWidth < 600;
        // Köşeleri yuvarlayarak içeriği keser
        return ClipRRect(
            // Köşeleri yuvarlar
            borderRadius: BorderRadius.circular(26),
            // İçerikte gösterilecek widgetı belirler
            child: ConstrainedBox(
                // constraints bilgisini belirler
                constraints: BoxConstraints(minHeight: compact ? 150 : 220),
                // İçerikte gösterilecek widgetı belirler
                child: Stack(children: [
                  // Öğeyi Stack içinde konumlandırır
                  Positioned.fill(
                      // İçerikte gösterilecek widgetı belirler
                      child: Image.asset(
                          // İlgili metin değerini belirler
                          'assets/images/precision-editorial-hero.png',
                          // Görselin yerleşme biçimini belirler
                          fit: BoxFit.cover,
                          // Hizalamayı belirler
                          alignment: Alignment.centerRight,
                          // exclude from semantics bilgisini belirler
                          excludeFromSemantics: true)),
                  // Öğeyi Stack içinde konumlandırır
                  Positioned.fill(
                      // İçerikte gösterilecek widgetı belirler
                      child: DecoratedBox(
                          // Kutunun görünümünü ayarlar
                          decoration: BoxDecoration(
                              // gradient bilgisini belirler
                              gradient: LinearGradient(colors: [
                    // Sabit renk değeri oluşturur
                    const Color(0xFF142A20),
                    // Sabit renk değeri oluşturur
                    const Color(0xFF142A20).withValues(alpha: .65),
                    // Hazır Flutter rengini kullanır
                    Colors.transparent
                  // Eleman listesini başlatır
                  ], stops: const [
                    // Önceki ifadeyi tamamlar
                    0,
                    // Önceki ifade üzerinde ek işlem uygular
                    .5,
                    // Önceki ifadeyi tamamlar
                    1
                  ])))),
                  // İçerik etrafına boşluk bırakır
                  Padding(
                      // İç boşlukları ayarlar
                      padding: EdgeInsets.all(compact ? 20 : 28),
                      // İçerikte gösterilecek widgetı belirler
                      child: ConstrainedBox(
                          // box constraints constructorını tanımlar
                          constraints: const BoxConstraints(maxWidth: 480),
                          // İçerikte gösterilecek widgetı belirler
                          child: Column(
                              // Çapraz eksendeki hizalamayı belirler
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // İçerideki elemanları listeler
                              children: [
                                // Metni gösterir
                                const Text('PRECISION / ARAÇ KİRALAMA',
                                    // Görünüm stilini belirler
                                    style: TextStyle(
                                        // Rengi belirler
                                        color: Color(0xFFD8ECDE),
                                        // Harfler arasındaki boşluğu ayarlar
                                        letterSpacing: 1.8,
                                        // Yazı boyutunu belirler
                                        fontSize: 10)),
                                // Belirtilen boyutta boşluk veya kutu oluşturur
                                SizedBox(height: compact ? 12 : 20),
                                // Metni gösterir
                                Text('Rotanız hazır.\nAracınızı seçin.',
                                    // Görünüm stilini belirler
                                    style: Theme.of(context)
                                        // Önceki ifade üzerinde ek işlem uygular
                                        .textTheme
                                        // Önceki ifade üzerinde ek işlem uygular
                                        .displaySmall
                                        // Değer null değilse ilgili işlemi yapar
                                        ?.copyWith(
                                            // Rengi belirler
                                            color: Colors.white,
                                            // Yazı boyutunu belirler
                                            fontSize: compact ? 28 : 36)),
                                // Koşul doğruysa bu işlemi çalıştırır
                                if (!compact) ...[
                                  // Belirtilen boyutta boşluk veya kutu oluşturur
                                  const SizedBox(height: 18),
                                  // Metni gösterir
                                  const Text(
                                      // İlgili metin değerini belirler
                                      'Şehir içinde, hafta sonunda, yeni bir yolda.',
                                      // Görünüm stilini belirler
                                      style: TextStyle(
                                          // Rengi belirler
                                          color: Color(0xFFE3EBE6),
                                          // Yazı boyutunu belirler
                                          fontSize: 13)),
                                ],
                                // Belirtilen boyutta boşluk veya kutu oluşturur
                                const SizedBox(height: 16),
                                // Metni gösterir
                                const Text('Temsili marka görseli · Yapay zekâ',
                                    // Görünüm stilini belirler
                                    style: TextStyle(
                                        // Rengi belirler
                                        color: Color(0xFFE3EBE6), fontSize: 9)),
                              ]))),
                ])));
      });
}

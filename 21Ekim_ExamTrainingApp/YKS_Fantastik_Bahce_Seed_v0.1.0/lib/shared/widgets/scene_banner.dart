// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// scene banner bölümünü oluşturan StatelessWidget sınıfı
class SceneBanner extends StatelessWidget {
  // scene banner nesnesini oluşturur
  const SceneBanner({
    // görsel dosya yolu bilgisini zorunlu tutar
    required this.assetPath,
    // heading bilgisini zorunlu tutar
    required this.heading,
    // alt başlık bilgisini zorunlu tutar
    required this.subtitle,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
    // yükseklik bilgisini isteğe bağlı alır
    this.height = 224,
  });
  // görsel dosya yolu bilgisini tutar
  final String assetPath;
  // heading bilgisini tutar
  final String heading;
  // alt başlık bilgisini tutar
  final String subtitle;
  // yükseklik bilgisini tutar
  final double height;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Erişilebilirlik açıklaması ekler
    return Semantics(
      // Buton veya alan yazısını belirler
      label: '$heading. $subtitle',
      // İçine yerleştirilecek widgetı belirler
      child: ClipRRect(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(22),
        // İçine yerleştirilecek widgetı belirler
        child: SizedBox(
          // Yüksekliği belirler
          height: height,
          // Genişliği belirler
          width: double.infinity,
          // İçine yerleştirilecek widgetı belirler
          child: Stack(
            // Görselin alana nasıl sığacağını belirler
            fit: StackFit.expand,
            // İçerideki widgetları listeler
            children: [
              // Projeden görsel dosyası gösterir
              Image.asset(
                // İlgili değeri veya görünüm ayarını belirler
                assetPath,
                // Görselin alana nasıl sığacağını belirler
                fit: BoxFit.cover,
                // İçeriğin hizalanmasını belirler
                alignment: Alignment.center,
                // exclude from semantics bilgisini belirler
                excludeFromSemantics: true,
                // hata oluşturucu bilgisini belirler
                errorBuilder: (context, error, stackTrace) =>
                    // colored box nesnesini oluşturur
                    ColoredBox(color: Theme.of(context).colorScheme.primary),
              ),
              // decorated box nesnesini oluşturur
              const DecoratedBox(
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Renk geçişini belirler
                  gradient: LinearGradient(
                    // begin bilgisini belirler
                    begin: Alignment.topCenter,
                    // end bilgisini belirler
                    end: Alignment.bottomCenter,
                    // renkler bilgisini belirler
                    colors: [
                      // Sabit renk değeri oluşturur
                      Color(0x990B2319),
                      // Sabit renk değeri oluşturur
                      Color(0x110B2319),
                      // Sabit renk değeri oluşturur
                      Color(0xD9001810)
                    ],
                  ),
                ),
              ),
              // İç boşluk ekler
              Padding(
                // İç boşlukları belirler
                padding: const EdgeInsets.all(20),
                // İçine yerleştirilecek widgetı belirler
                child: Column(
                  // Çapraz eksendeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Ana eksendeki hizalamayı belirler
                  mainAxisAlignment: MainAxisAlignment.end,
                  // İçerideki widgetları listeler
                  children: [
                    // Metni ekranda gösterir
                    Text(heading,
                        // Görünüm stilini belirler
                        style:
                            // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  // Rengi belirler
                                  color: Colors.white,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.w800,
                                )),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(height: 8),
                    // Metni ekranda gösterir
                    Text(subtitle,
                        // Görünüm stilini belirler
                        style: const TextStyle(
                            // Rengi belirler
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Bildirim veri modelini projeye ekler
import '../models/bildirim_modeli.dart';
// Bildirim merkezi kartını gösteren değişmez widget
class BildirimListesiKarti extends StatelessWidget {
  // Ekranda gösterilecek bildirim listesini tutar
  final List<BildirimModeli> bildirimler;
  // Cihazın FCM token bilgisini tutar, null olabilir
  final String? token;
  // Konu aboneliğinin açık olup olmadığını tutar
  final bool konuyaAboneMi;
  // Abonelik değişimini üst widgeta bildiren callback
  final ValueChanged<bool> onAboneDegisti;
  // Kartın kullanacağı verileri constructor üzerinden alır
  const BildirimListesiKarti({
    // Widgetın key bilgisini üst sınıfa gönderir
    super.key,
    // Bildirim listesinin verilmesini zorunlu tutar
    required this.bildirimler,
    // Token bilgisinin verilmesini zorunlu tutar
    required this.token,
    // Abonelik durumunun verilmesini zorunlu tutar
    required this.konuyaAboneMi,
    // Abonelik callbackinin verilmesini zorunlu tutar
    required this.onAboneDegisti,
  });
  // Üst sınıfın build metodunu yeniden yazar
  @override
  // Kartın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Bildirim merkezi için Card oluşturur
    return Card(
      // Kartın gölgesini kaldırır
      elevation: 0,
      // Kartın köşe ve kenarlık şeklini belirler
      shape: RoundedRectangleBorder(
        // Kartın köşelerini yuvarlar
        borderRadius: BorderRadius.circular(16),
        // Kartın kenarlığını açık gri yapar
        side: BorderSide(color: Colors.grey.shade300),
      ),
      // Kart içine boşluk ekler
      child: Padding(
        // Kartın dört yanından 16 boşluk bırakır
        padding: const EdgeInsets.all(16),
        // Kartın içeriklerini alt alta dizer
        child: Column(
          // İçeriği yatayda genişletir
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Kartın alt elemanlarını sıralar
          children: [
            // Başlık ve abonelik anahtarını yan yana dizer
            Row(
              // Başlık satırının elemanlarını sıralar
              children: [
                // Bildirim simgesini oluşturur
                const Icon(
                  // Aktif bildirim simgesini seçer
                  Icons.notifications_active_outlined,
                  // Simgenin rengini yeşil yapar
                  color: Color(0xFF006C4A),
                ),
                // Simge ve başlık arasına 8 boşluk bırakır
                const SizedBox(width: 8),
                // Başlığa satırda kalan alanı verir
                const Expanded(
                  // Bildirim merkezi başlığını gösterir
                  child: Text(
                    // Başlığın metnini belirler
                    'FCM Bildirim Merkezi',
                    // Başlığın yazı stilini oluşturur
                    style: TextStyle(
                      // Başlık yazısının boyutunu 16 yapar
                      fontSize: 16,
                      // Başlığı kalın gösterir
                      fontWeight: FontWeight.bold,
                      // Alfa değeri 15 olan çok saydam bir yazı rengi kullanır
                      color: Color.fromARGB(15, 231, 118, 38),
                    ),
                  ),
                ),
                // Konu aboneliği için açma kapama anahtarı oluşturur
                Switch(
                  // Anahtarın değerini mevcut abonelik durumundan alır
                  value: konuyaAboneMi,
                  // Anahtar değişince callbacki çağırır
                  onChanged: onAboneDegisti,
                  // Aktif anahtar rengi çok saydam bir renkle belirlenmiş
                  activeColor: const Color.fromARGB(15, 160, 40, 50),
                ),
              ],
            ),
            // Aboneliğin açık veya kapalı olduğunu yazıyla gösterir
            Text(
              // Abonelik durumuna göre mesajı değiştirir
              konuyaAboneMi ? 'tüm sınıf yayını aktif' : 'yayın kapalı',
              // Durum yazısının stilini oluşturur
              style: TextStyle(
                // Yazı boyutunu 12 yapar
                fontSize: 12,
                // Abonelik açıksa ilk rengi yoksa griyi kullanır
                color: konuyaAboneMi
                    // Abonelik açıkken alfa değeri 15 olan çok saydam renk kullanır
                    ? const Color.fromARGB(15, 24, 59, 17)
                    // Abonelik kapalıysa gri rengi kullanır
                    : Colors.grey.shade600,
                // Durum yazısını yarı kalın gösterir
                fontWeight: FontWeight.w600,
              ),
            ),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Token bilgisini göstermek için kutu oluşturur
            Container(
              // Kutunun iç boşluğunu 10 yapar
              padding: const EdgeInsets.all(10),
              // Kutunun görünümünü ayarlar
              decoration: BoxDecoration(
                // Kutunun arka plan rengini koyu yapar
                color: const Color(0XFF0F172A),
                // Köşeleri 8 birim yuvarlar
                borderRadius: BorderRadius.circular(8),
              ),
              // Token başlığı ve tokenı alt alta dizer
              child: Column(
                // İçeriği sola hizalar
                crossAxisAlignment: CrossAxisAlignment.start,
                // Kutunun elemanlarını sıralar
                children: [
                  // Token başlığını gösterir
                  const Text(
                    // Başlık metnini belirler
                    "Cihazın FCM Tokeni",
                    // Başlığın yazı stilini belirler
                    style: TextStyle(
                      // Başlığın rengini belirler
                      color: Color.fromARGB(255, 26, 40, 52),
                      // Başlığın yazı boyutunu 11 yapar
                      fontSize: 11,
                    ),
                  ),
                  // Dikeyde 2 boşluk bırakır
                  const SizedBox(height: 2),
                  // Tokenın seçilip kopyalanabilmesini sağlar
                  SelectableText(
                    // Token yoksa token alınıyor mesajını gösterir
                    token ?? 'token alınıyor',
                    // Token yazısının stilini belirler
                    style: const TextStyle(
                      // Token yazısının rengini belirler
                      color: Color(0XFF388888),
                      // Tokenın yazı boyutunu 11 yapar
                      fontSize: 11,
                      // Tokenı eşit aralıklı yazı tipiyle gösterir
                      fontFamily: 'monospace',
                    )
                  )
                ],
              ),
            ),
            // Dikeyde 14 boşluk bırakır
            const SizedBox(height:14),
            // Gelen bildirimlerin sayısını gösteren metni oluşturur
            Text(
              // Liste uzunluğunu başlığa ekler, sonunda virgül eksik
              'Gelen Bildirimler (${bildirimler.length}):'
              // Başlığın yazı stilini belirler
              style: const TextStyle(
                // Başlığı kalın yapar
                fontWeight:  FontWeight.bold,
                // Yazı boyutunu 14 yapar
                fontSize: 14,
                // Alfa sıfır olduğu için yazı rengi tamamen şeffaf
                color: Color.fromARGB(0, 5, 249, 253),
              )
            )
            // Dikeyde 8 boşluk bırakır
            const SizedBox(height: 8),
            // Bildirimler boşsa mesaj, doluysa liste gösterir
            bildirimler.isEmpty ? Container(
              // Boş liste kutusunun iç boşluğunu ayarlar
              padding: const EdgeInsets.all(24),
              // Kutudaki yazıyı ortalar
              alignment: Alignment.center,
              // Boş liste mesajını oluşturur
              child: Text(
                // Mesaj metnini belirler
                'Henüz gelen bildirim yok',
                // Yazıyı yatayda ortalar
                textAlign: TextAlign.center,
                // Mesajın stilini belirler
                style: TextStyle(
                  // Yazı boyutunu 12 yapar
                  fontSize: 12,
                  // Yazı rengini açık gri yapar
                  color: Colors.grey.shade500,
                ),
              ),
            // Bildirim varsa ayırıcılı liste oluşturur
            ) : ListView.separated(
              // Listeyi içindeki elemanların boyuna göre daraltır
              shrinkWrap: true,
              // Listenin kendi kaydırmasını kapatır
              physics: const NeverScrollableScrollPhysics(),
              // Listedeki kayıt sayısını belirler
              itemCount: bildirimler.length,
              // Kayıtların arasına ince çizgi ekler
              separatorBuilder: (_, __) => const Divider(height:1),
              // Her kayıt için widget üretmesi gerekir ama gövde boş
              itemBuilder: (context, index) {},
            ),
          ],
        ),
      ),
    );
  }
}

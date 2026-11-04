// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Ürün modelini kullanmak için ekler
import '../models/urun.dart';
// Stok miktarını gösteren widgetı ekler
import 'stok_rozeti.dart';
// Tek bir ürünün bilgilerini gösteren kart sınıfı
class UrunKarti extends StatelessWidget {
  // Kartta gösterilecek ürünü tutar
  final Urun urun;
  // Favoriye basılınca çalışacak callbacki tutar
  final VoidCallback onFavoriTiklandi;
  // Kart detayına basılınca çalışacak callbacki tutar
  final VoidCallback onDetayTiklandi;
  // Ürünü ve iki tıklama fonksiyonunu alan constructor
  const UrunKarti({
    // Üst sınıfa key bilgisini gönderir
    super.key,
    // Ürün nesnesini zorunlu alır
    required this.urun,
    // Favori tıklama fonksiyonunu zorunlu alır
    required this.onFavoriTiklandi,
    // Detay tıklama fonksiyonunu zorunlu alır
    required this.onDetayTiklandi,
  });
  // Üst sınıfın build metodunu yeniden yazar
  @override
  // Ürünün kart arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ürün bilgilerini Card içinde gösterir
    return Card(
      // Kartın dış boşluklarını ayarlar
      margin: const EdgeInsets.symmetric(
        // Yatay dış boşluğu 16 yapar
        horizontal: 16,
        // Dikey dış boşluğu 8 yapar
        vertical: 8,
      ),
      // Karta hafif gölge verir
      elevation: 2,
      // Kartın köşe şeklini belirler
      shape: RoundedRectangleBorder(
        // Köşeleri 12 birim yuvarlar
        borderRadius: BorderRadius.circular(12),
      ),
      // Karta dokunma efekti ve tıklama ekler
      child: InkWell(
        // Tıklama alanının köşelerini yuvarlar
        borderRadius: BorderRadius.circular(12),
        // Kart tıklanınca detay callbackini çalıştırır
        onTap: onDetayTiklandi,
        // Kart içeriğine boşluk ekler
        child: Padding(
          // Her taraftan 12 boşluk bırakır
          padding: const EdgeInsets.all(12.0),
          // Görsel, bilgiler ve favoriyi yan yana dizer
          child: Row(
            // Elemanları üstten hizalar
            crossAxisAlignment: CrossAxisAlignment.start,
            // Yan yana gösterilecek öğeleri başlatır
            children: [
              // Ürün görselinin köşelerini kırpar
              ClipRRect(
                // Görselin köşelerini 10 birim yuvarlar
                borderRadius: BorderRadius.circular(10),
                // Görseli internet adresinden yükler
                child:Image.network(
  // Ürünün görsel URL adresini kullanır
  urun.resimUrl,
  // Görsel yüksekliğini 90 yapar
  height: 90,
  // Görsel genişliğini 90 yapar
  width: 90,
  // Görseli alanı kaplayacak şekilde kırpar
  fit: BoxFit.cover,
  // Görsel yüklenirken gösterilecek içeriği belirler
  loadingBuilder: (context, child, progress) {
    // Yükleme tamamlandıysa kontrol eder
    if (progress == null) {
      // Yüklenen görseli doğrudan gösterir
      return child;
    }
    // Yükleme devam ederken yer tutucu kutu oluşturur
    return Container(
      // Yer tutucu genişliğini 90 yapar
      width: 90,
      // Yer tutucu yüksekliğini 90 yapar
      height: 90,
      // Kutuyu açık gri renkte gösterir
      color: Colors.grey.shade300,
      // Yüklenme simgesini ortaya yerleştirir
      child: const Center(
        // Dönen yükleme simgesi oluşturur
        child: CircularProgressIndicator(
          // Çizgi kalınlığını 2 yapar
          strokeWidth: 2,
        ),
      ),
    );
  },
  // Görsel yüklenemezse çalışacak içeriği belirler
  errorBuilder: (context, error, stackTrace) {
    // Hata durumunda yer tutucu kutu gösterir
    return Container(
      // Hata kutusunun genişliği 90 olur
      width: 90,
      // Hata kutusunun yüksekliği 90 olur
      height: 90,
      // Hata kutusunun arka planı açık gri olur
      color: Colors.grey.shade300,
      // Hata simgesini kutunun ortasına yerleştirir
      child: const Center(
        // Görsel bulunamadı simgesi oluşturur
        child: Icon(
          // Desteklenmeyen görsel simgesini kullanır
          Icons.image_not_supported_outlined,
          // Simgeyi gri yapar
          color: Colors.grey,
        ),
      ),
    );
  },
),
              ),
              // Görsel ile metin arasına 12 boşluk bırakır
              const SizedBox(width: 12),
              // Ürün bilgilerine kalan yatay alanı ayırır
              Expanded(
                // Ürün bilgilerini alt alta dizer
                child: Column(
                  // Ürün bilgilerini sola hizalar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Bilgi bölümünün elemanlarını başlatır
                  children: [
                    // Kategori ve stok etiketini yan yana dizer
                    Row(
                      // Kategoriyi sola, stok bilgisini sağa yerleştirir
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Satırdaki öğeleri başlatır
                      children: [
                        // Kategori yazısına kalan alanı ayırır
                        Expanded(
                          // Kategori bilgisini metin olarak gösterir
                          child: Text(
                            // Kategori ikonu ve başlığı kullanılır; bu alanlar mevcut enumda tanımlı değil
                            '${urun.kategori.ikon} ${urun.kategori.baslik}',
                            // Kategori metnini bir satırla sınırlar
                            maxLines: 1,
                            // Uzun metnin sonunu üç noktayla keser
                            overflow: TextOverflow.ellipsis,
                            // Kategori yazısının görünümünü belirler
                            style: TextStyle(
                              // Metni gri renkte gösterir
                              color: Colors.grey.shade600,
                              // Metin boyutunu 12 yapar
                              fontSize: 12,
                              // Metin kalınlığını 600 yapar
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Kategori ile stok etiketi arasına 4 boşluk bırakır
                        const SizedBox(width: 4),
                        // Ürünün stok etiketini oluşturur
                        StokRozeti(
                          // Stok miktarını etikete gönderir
                          stok: urun.stokAdedi,
                        ),
                      ],
                    ),
                    // Dikeyde 6 boşluk bırakır
                    const SizedBox(height: 6),
                    // Ürün başlığını metin olarak oluşturur
                    Text(
                      // Ürünün başlığını gösterir
                      urun.baslik,
                      // Başlığı tek satırla sınırlar
                      maxLines: 1,
                      // Uzun başlığın sonunu üç noktayla keser
                      overflow: TextOverflow.ellipsis,
                      // Başlığın yazı stilini belirler
                      style: const TextStyle(
                        // Başlık boyutunu 15 yapar
                        fontSize: 15,
                        // Başlığı kalın yapar
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Dikeyde 4 boşluk bırakır
                    const SizedBox(height: 4),
                    // Ürün açıklamasını metin olarak oluşturur
                    Text(
                      // Ürünün açıklamasını gösterir
                      urun.aciklama,
                      // Açıklamayı iki satırla sınırlar
                      maxLines: 2,
                      // Taşan metnin sonuna üç nokta koyar
                      overflow: TextOverflow.ellipsis,
                      // Açıklamanın yazı stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu 12 yapar
                        fontSize: 12,
                        // Açıklama rengini gri yapar
                        color: Colors.grey.shade700,
                        // Satır yüksekliğini 1,2 yapar
                        height: 1.2,
                      ),
                    ),
                    // Dikeyde 8 boşluk bırakır
                    const SizedBox(height: 8),
                    // Fiyat metnini oluşturur
                    Text(
                      // Fiyatı iki ondalık basamak ve TL simgesiyle gösterir
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      // Fiyat yazısının stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu 16 yapar
                        fontSize: 16,
                        // Fiyatı çok kalın yapar
                        fontWeight: FontWeight.w900,
                        // Fiyat rengini aktif temanın ana renginden alır
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Favorilere ekleme butonunu oluşturur
              IconButton(
                // Favori durumuna göre simge belirler
                icon: Icon(
                  // Ürünün favori durumunu kontrol eder
                  urun.favoriMi
                      // Favoriyse dolu kalp kullanır
                      ? Icons.favorite
                      // Değilse boş kalp kullanır
                      : Icons.favorite_border,
                  // Favori durumuna göre renk belirler
                  color: urun.favoriMi
                      // Favoriyse kalbi kırmızı yapar
                      ? Colors.red
                      // Değilse kalbi gri yapar
                      : Colors.grey,
                ),
                // Butona basılınca favori callbackini çağırır
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

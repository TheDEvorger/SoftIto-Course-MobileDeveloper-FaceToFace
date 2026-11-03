// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Varlık modelini projeye ekler
import '../models/asset_model.dart';
// İşlem modelini projeye ekler
import '../models/transation_model.dart';

// Değişen durum olmadığı için StatelessWidget kullanılır
class MarketsListScreen extends StatelessWidget {
  // Sınıfın constructorı
  const MarketsListScreen({super.key});
  // Varlıkları tutan sabit Asset listesi
  static const List<Asset> assets = [
    // Bitcoin bilgilerini tutar
    Asset(
        // Bitcoin sembolü
        symbol: 'BTC',
        // Varlığın adı
        name: 'Bitcoin',
        // Güncel fiyat bilgisi
        price: 67420.50,
        // 24 saatlik yüzdelik değişim
        change24h: 4.25,
        // Kullanıcının BTC miktarı
        balance: 0.428),
    // Ethereum bilgilerini tutar
    Asset(
        // Ethereum sembolü
        symbol: 'ETH',
        // Varlığın adı
        name: 'Ethereum',
        // Güncel fiyat bilgisi
        price: 3520.10,
        // 24 saatlik negatif değişim
        change24h: -1.80,
        // Kullanıcının ETH miktarı
        balance: 4.250),
    // Solana bilgilerini tutar
    Asset(
        // Solana sembolü
        symbol: 'SOL',
        // Varlığın adı
        name: 'Solana',
        // Güncel fiyat bilgisi
        price: 154.20,
        // 24 saatlik yüzdelik değişim
        change24h: 12.40,
        // Kullanıcının SOL miktarı
        balance: 85.00),
    // Avalanche bilgilerini tutar
    Asset(
        // Avalanche sembolü
        symbol: 'AVAX',
        // Varlığın adı
        name: 'Avalanche',
        // Güncel fiyat bilgisi
        price: 28.40,
        // 24 saatlik yüzdelik değişim
        change24h: 0.50,
        // Kullanıcının AVAX miktarı
        balance: 340.00),
  ];
  // Son işlemleri tutan sabit liste
  static const List<TransactionItem> transactions = [
    // İlk işlem kaydı
    TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_1',
      // İşlem başlığı
      title: 'Apple Store Zorlu Center',
      // İşlemin kategorisi
      category: 'Teknoloji / Donanım',
      // İşlemin tarihi
      date: 'Bugün, 14:20',
      // İşlem tutarı
      amount: 64999.00,
      // Gider olduğu için true
      isExpense: true,
      // İşleme ait simge
      icon: Icons.laptop_mac,
    ),
    // İkinci işlem kaydı
    TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_2',
      // İşlem başlığı
      title: 'Yazılım Danışmanlık Hakediş',
      // İşlemin kategorisi
      category: 'Kurumsal Gelir',
      // İşlemin tarihi
      date: 'Dün, 09:00',
      // İşlem tutarı
      amount: 125000.00,
      // Gelir olduğu için false
      isExpense: false,
      // İşleme ait simge
      icon: Icons.account_balance,
    ),
    // Üçüncü işlem kaydı
    TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_3',
      // İşlem başlığı
      title: 'Starbucks Coffee Kadıköy',
      // İşlemin kategorisi
      category: 'Yeme & İçme',
      // İşlemin tarihi
      date: '13 Ekim, 16:45',
      // İşlem tutarı
      amount: 185.50,
      // Gider olduğu için true
      isExpense: true,
      // İşleme ait simge
      icon: Icons.coffee,
    ),
    // Dördüncü işlem kaydı
    TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_4',
      // İşlem başlığı
      title: 'Temettü / Hisse Dağıtımı',
      // İşlemin kategorisi
      category: 'Yatırım Getirisi',
      // İşlemin tarihi
      date: '12 Ekim, 11:30',
      // İşlem tutarı
      amount: 3420.75,
      // Gelir olduğu için false
      isExpense: false,
      // İşleme ait simge
      icon: Icons.trending_up,
    ),
  ];
  // Üstteki build metodunu yeniden yazar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfanın kaydırılmasını sağlar
    return SingleChildScrollView(
      // Kaydırma sonunda esneme efekti verir
      physics: const BouncingScrollPhysics(),
      // Üstten ve alttan 16 boşluk bırakır
      padding: const EdgeInsets.symmetric(vertical: 16),
      // Elemanları alt alta sıralar
      child: Column(
        // Elemanları sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        // Column içindeki elemanları tutar
        children: [
          // Başlık için boşluk bırakır
          const Padding(
            // Yatayda 20 dikeyde 8 boşluk verir
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // Portföy başlığını gösterir
            child: Text(
              // Başlık metni
              'Canlı Portföy Varlıkları (GridView)',
              // Başlığın yazı ayarları
              style: TextStyle(
                  // Yazı boyutu
                  fontSize: 16,
                  // Yazıyı kalın yapar
                  fontWeight: FontWeight.bold,
                  // Yazı rengini belirler
                  color: Color(0xFF0F172A)),
            ),
          ),
          // Varlıkları tablo şeklinde listelemek için GridView.builder kullanılır
          GridView.builder(
            // GridView içeriği kadar yer kaplar
            shrinkWrap: true,
            // Kendi kaydırmasını kapatır
            physics: const NeverScrollableScrollPhysics(),
            // GridView çevresine boşluk verir
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // Grid elemanlarının yerleşimini ayarlar
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // Her satırda 2 eleman gösterir
              crossAxisCount: 2,
              // Kartların genişlik yükseklik oranı
              childAspectRatio: 1.35,
              // Kartlar arasında yatay boşluk
              crossAxisSpacing: 12,
              // Kartlar arasında dikey boşluk
              mainAxisSpacing: 12,
            ),
            // Liste uzunluğu kadar kart oluşturur
            itemCount: assets.length,
            // Her indeks için kart oluşturur
            itemBuilder: (context, index) {
              // İlgili indeksteki varlığı alır
              final a = assets[index];
              // Değişim sıfır veya pozitifse true olur
              final isPositive = a.change24h >= 0;
              // Her varlık için kutu oluşturur
              return Container(
                // Kutunun iç boşluğu
                padding: const EdgeInsets.all(14),
                // Kutunun görünüm ayarları
                decoration: BoxDecoration(
                  // Arka planı beyaz yapar
                  color: Colors.white,
                  // Köşeleri yuvarlar
                  borderRadius: BorderRadius.circular(18),
                  // İnce kenarlık oluşturur
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  // Kutuya gölge ekler
                  boxShadow: const [
                    // Gölgenin ayarlarını yapar
                    BoxShadow(
                        // Gölge rengi
                        color: Color(0x05000000),
                        // Gölgeyi aşağı kaydırır
                        offset: Offset(0, 4),
                        // Gölgenin bulanıklığı
                        blurRadius: 10),
                  ],
                ),
                // Kart içindeki verileri alt alta dizer
                child: Column(
                  // Elemanları sola hizalar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Elemanları dikeyde aralıklı yerleştirir
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Kartın içindeki elemanlar
                  children: [
                    // Sembol ve değişimi yan yana gösterir
                    Row(
                      // Elemanları iki yana dağıtır
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Row içindeki elemanlar
                      children: [
                        // Varlığın sembolünü gösterir
                        Text(a.symbol,
                            // Yazının stilini belirler
                            style: const TextStyle(
                                // Yazıyı kalın yapar
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        // 24 saatlik değişimi gösterir
                        Text(
                          // Pozitifse başına + ekler, yüzde olarak yazar
                          '${isPositive ? '+' : ''}${a.change24h}%',
                          // Değişimin yazı ayarları
                          style: TextStyle(
                            // Pozitif veya negatif olmasına göre renk seçer
                            color: isPositive
                                // Pozitifse yeşil yapar
                                ? const Color(0xFF10B981)
                                // Negatifse kırmızı yapar
                                : const Color(0xFFEF4444),
                            // Yazıyı kalın yapar
                            fontWeight: FontWeight.bold,
                            // Yazı boyutu
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Varlığın fiyatını gösterir
                    Text(
                      // Fiyatı virgülden sonra 2 basamakla yazar
                      '\$${a.price.toStringAsFixed(2)}',
                      // Fiyatın yazı ayarları
                      style: const TextStyle(
                          // Yazı boyutu
                          fontSize: 18,
                          // Yazıyı kalın yapar
                          fontWeight: FontWeight.bold,
                          // Yazı rengini belirler
                          color: Color(0xFF0F172A)),
                    ),
                    // Kullanıcının varlık miktarını gösterir
                    Text('${a.balance} ${a.symbol}',
                        // Yazının stilini belirler
                        style: const TextStyle(
                            // Yazı boyutu ve rengi
                            fontSize: 11,
                            color: Color(0xFF64748B))),
                  ],
                ),
              );
            },
          ),
          // Dikeyde 16 boşluk bırakır
          const SizedBox(height: 16),
          // Son işlemler başlığına boşluk verir
          const Padding(
            // Yatayda 20 dikeyde 8 boşluk bırakır
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // Son işlemler başlığını gösterir
            child: Text(
              // Başlık metni
              'Son İşlemler (ListView.separated)',
              // Yazının stilini belirler
              style: TextStyle(
                  // Yazı boyutu
                  fontSize: 16,
                  // Yazıyı kalın yapar
                  fontWeight: FontWeight.bold,
                  // Yazı rengi
                  color: Color(0xFF0F172A)),
            ),
          ),
          // İşlemleri aralarında çizgi olacak şekilde listeler
          ListView.separated(
            // Liste içeriği kadar yer kaplar
            shrinkWrap: true,
            // Listenin kendi kaydırmasını kapatır
            physics: const NeverScrollableScrollPhysics(),
            // İşlem sayısı kadar eleman oluşturur
            itemCount: transactions.length,
            // Liste elemanlarının arasına çizgi koyar
            separatorBuilder: (context, index) => const Divider(
              // Çizginin kapladığı yükseklik
              height: 1,
              // Çizginin kalınlığı
              thickness: 0.8,
              // Çizgiyi soldan 72 kaydırır
              indent: 72,
              // Çizginin rengi
              color: Color(0xFFF1F5F9),
            ),
            // Her işlem için liste elemanı oluşturur
            itemBuilder: (context, index) {
              // İlgili indeksteki işlemi alır
              final t = transactions[index];
              // Hazır liste satırı oluşturur
              return ListTile(
                // Liste elemanının iç boşlukları
                contentPadding:
                    // Yatayda 20 dikeyde 4 boşluk bırakır
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                // Satırın solundaki simge alanı
                leading: Container(
                  // Simge kutusunun genişliği
                  width: 46,
                  // Simge kutusunun yüksekliği
                  height: 46,
                  // Simge kutusunun görünümü
                  decoration: BoxDecoration(
                    // Gider veya gelire göre renk belirler
                    color: t.isExpense
                        // Giderse açık kırmızı
                        ? const Color(0x1FEF4444)
                        // Gelirse açık yeşil
                        : const Color(0x1F10B981),
                    // Köşeleri yuvarlar
                    borderRadius: BorderRadius.circular(14),
                  ),
                  // İşleme ait simgeyi gösterir
                  child: Icon(
                    // Modelden gelen simgeyi kullanır
                    t.icon,
                    // Gider veya gelire göre simge rengi
                    color: t.isExpense
                        // Giderse kırmızı
                        ? const Color(0xFFEF4444)
                        // Gelirse yeşil
                        : const Color(0xFF10B981),
                    // Simgenin boyutu
                    size: 22,
                  ),
                ),
                // İşlemin başlığını gösterir
                title: Text(t.title,
                    // Başlığın yazı stilini belirler
                    style: const TextStyle(
                        // Yazı kalınlığı ve boyutu
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5)),
                // Başlığın altında kategori ve tarih gösterir
                subtitle: Text('${t.category} • ${t.date}',
                    // Alt yazının stilini belirler
                    style: const TextStyle(
                        // Yazı boyutu ve rengi
                        fontSize: 11.5,
                        color: Color(0xFF64748B))),
                // Satırın sağ tarafında tutarı gösterir
                trailing: Text(
                  // Giderse eksi, gelirse artı işareti ekler
                  '${t.isExpense ? '-' : '+'}₺${t.amount.toStringAsFixed(2)}',
                  // Tutarın yazı ayarları
                  style: TextStyle(
                    // Yazıyı kalın yapar
                    fontWeight: FontWeight.bold,
                    // Yazı boyutunu belirler
                    fontSize: 13.5,
                    // Gider ve gelire göre renk belirler
                    color: t.isExpense
                        // Giderse koyu renk kullanır
                        ? const Color(0xFF0F172A)
                        // Gelirse yeşil kullanır
                        : const Color(0xFF10B981),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

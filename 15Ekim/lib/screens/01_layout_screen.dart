// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';

// Ekranda değişen veriler olduğu için StatefulWidget kullanılır
class LayoutScreen extends StatefulWidget {
  // Sınıfın constructorı
  const LayoutScreen({super.key});
  // Üstteki createState metodunu uygular
  @override
  // Ekranın State sınıfını oluşturur
  State<LayoutScreen> createState() => _LayoutScreenState();
}

// Ekranın değişen durumlarını tutan State sınıfı
class _LayoutScreenState extends State<LayoutScreen> {
  // Bakiyenin görünür olup olmadığını tutar
  bool _isBalanceVisible = true;
  // Son yapılan işlemin bilgisini tutar
  String _lastAction = 'Hazır - Butonlara tıklayabilirsiniz';
  // Üstteki build metodunu yeniden yazar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ekranın kaydırılmasını sağlar
    return SingleChildScrollView(
      // Kaydırma sonunda esneme efekti verir
      physics: const BouncingScrollPhysics(),
      // Alt taraftan 32 boşluk bırakır
      padding: const EdgeInsets.only(bottom: 32),
      // Elemanları alt alta dizer
      child: Column(
        // Elemanları sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        // Column içindeki elemanları tutar
        children: [
          // Profil bölümünü getirir
          _buildProfileHeader(),
          // Bakiye kartını getirir
          _buildPremiumWalletCard(),
          // İşlem butonlarını getirir
          _buildQuickActions(),
          // Bildirim alanını getirir
          _buildSafeNotificationBanner(),
          // İstatistik kartlarını getirir
          _buildFlexStatistics(),
          // Son işlem bilgisini ortaya alır
          Center(
            // İçeriğe boşluk verir
            child: Padding(
              // Her taraftan 16 boşluk bırakır
              padding: const EdgeInsets.all(16.0),
              // Son yapılan işlemi ekrana yazar
              child: Text(
                // Değişkeni metnin içinde gösterir
                'Son İşlem: $_lastAction',
                // Yazının stilini ayarlar
                style: const TextStyle(
                  // Yazı boyutunu belirler
                  fontSize: 13,
                  // Yazı rengini belirler
                  color: Color(0xFF64748B),
                  // Yazıyı italik yapar
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Profil kısmını oluşturan metot
  Widget _buildProfileHeader() {
    // Profil alanına boşluk verir
    return Padding(
      // Sol üst sağ alt boşluklarını belirler
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      // Profil elemanlarını yan yana dizer
      child: Row(
        // Row içindeki elemanları tutar
        children: [
          // Elemanları üst üste yerleştirir
          Stack(
            // Taşan elemanların görünmesini sağlar
            clipBehavior: Clip.none,
            // Stack içindeki elemanları tutar
            children: [
              // Profil simgesi için kutu oluşturur
              Container(
                // Kutunun genişliği
                width: 56,
                // Kutunun yüksekliği
                height: 56,
                // Kutunun görünümünü ayarlar
                decoration: BoxDecoration(
                  // Kutuyu daire yapar
                  shape: BoxShape.circle,
                  // Arka plan rengini belirler
                  color: const Color(0x1F6366F1),
                  // Dairenin kenarlığını oluşturur
                  border: Border.all(color: const Color(0xFF6366F1), width: 2),
                ),
                // Kutunun içine kullanıcı simgesi koyar
                child: const Icon(Icons.person,
                    // Simgenin rengini ve boyutunu belirler
                    color: Color(0xFF6366F1),
                    size: 32),
              ),
              // Küçük durum simgesini konumlandırır
              Positioned(
                // Alt kenara sıfırlar
                bottom: 0,
                // Sağ kenara sıfırlar
                right: 0,
                // Durum simgesi için kutu oluşturur
                child: Container(
                  // Kutunun genişliği
                  width: 16,
                  // Kutunun yüksekliği
                  height: 16,
                  // Kutunun görünümünü ayarlar
                  decoration: BoxDecoration(
                    // Yeşil renk verir
                    color: const Color(0xFF10B981),
                    // Daire şeklinde gösterir
                    shape: BoxShape.circle,
                    // Beyaz kenarlık ekler
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          // Yatayda 14 boşluk bırakır
          const SizedBox(width: 14),
          // Profil yazılarını alt alta dizer
          const Column(
            // Yazıları sola hizalar
            crossAxisAlignment: CrossAxisAlignment.start,
            // Column içindeki yazıları tutar
            children: [
              // Karşılama yazısını gösterir
              Text(
                // Kullanıcı adı
                'Hoş Geldin, Selahaddin',
                // Yazının stilini belirler
                style: TextStyle(
                  // Yazı boyutu
                  fontSize: 17,
                  // Yazıyı kalın yapar
                  fontWeight: FontWeight.bold,
                  // Yazı rengi
                  color: Color(0xFF0F172A),
                ),
              ),
              // Dikeyde 2 boşluk bırakır
              SizedBox(height: 2),
              // Grup bilgisini gösterir
              Text(
                // Kullanıcının grup bilgisi
                'SoftITO Mobile Developer - Grup 3',
                // Yazı boyutunu ve rengini belirler
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bakiye kartını oluşturan metot
  Widget _buildPremiumWalletCard() {
    // Kart için Container oluşturur
    return Container(
      // Yatay ve dikey dış boşluk verir
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // Kartın içinden 24 boşluk bırakır
      padding: const EdgeInsets.all(24),
      // Kartın genişliğini mümkün olduğu kadar büyütür
      width: double.infinity,
      // Kartın görünümünü ayarlar
      decoration: BoxDecoration(
        // Kartın arka planına renk geçişi verir
        gradient: const LinearGradient(
          // Geçişte kullanılacak renkleri belirler
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF9333EA)],
          // Renk geçişinin başlangıç noktası
          begin: Alignment.topLeft,
          // Renk geçişinin bitiş noktası
          end: Alignment.bottomRight,
        ),
        // Kartın köşelerini yuvarlar
        borderRadius: BorderRadius.circular(24),
        // Kartın gölge listesini oluşturur
        boxShadow: const [
          // Karta gölge verir
          BoxShadow(
            // Gölgenin rengini belirler
            color: Color(0x597C3AED),
            // Gölgeyi aşağı doğru kaydırır
            offset: Offset(0, 12),
            // Gölgenin bulanıklığını belirler
            blurRadius: 24,
            // Gölgenin yayılma miktarı
            spreadRadius: -4,
          ),
        ],
        // Kartın kenarlığını oluşturur
        border: Border.all(color: const Color(0x33FFFFFF), width: 1.5),
      ),
      // Kart içindeki elemanları alt alta dizer
      child: Column(
        // Elemanları sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        // Kartın içindeki elemanları tutar
        children: [
          // Kart başlığı ile göz simgesini yan yana dizer
          Row(
            // Elemanları iki yana dağıtır
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Row içindeki elemanları tutar
            children: [
              // Kartın adını gösterir
              const Text(
                // Kart adı
                'Kodvance Platinum',
                // Yazının görünümünü ayarlar
                style: TextStyle(
                  // Yazı rengini belirler
                  color: Colors.white70,
                  // Yazı boyutu
                  fontSize: 13,
                  // Harfler arası boşluk
                  letterSpacing: 1.2,
                  // Yazıyı yarı kalın yapar
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Bakiyeyi gizlemek için buton oluşturur
              IconButton(
                // Bakiye durumuna göre göz simgesini değiştirir
                icon: Icon(
                  // Görünürse açık göz, değilse kapalı göz gösterir
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  // Simgenin rengi
                  color: Colors.white70,
                  // Simgenin boyutu
                  size: 20,
                ),
                // Butona basılınca çalışır
                onPressed: () {
                  // Değişiklik olduğunda ekranı günceller
                  setState(() {
                    // true ise false, false ise true yapar
                    _isBalanceVisible = !_isBalanceVisible;
                    // Yapılan işleme göre mesaj belirler
                    _lastAction =
                        // Bakiye durumuna göre yazıyı değiştirir
                        _isBalanceVisible ? 'Bakiye açıldı' : 'Bakiye gizlendi';
                  });
                },
              ),
            ],
          ),
          // Dikeyde 12 boşluk bırakır
          const SizedBox(height: 12),
          // Bakiye açıklamasını gösterir
          const Text(
            // Bakiye başlığı
            'Kullanılabilir Toplam Bakiye',
            // Yazının rengi ve boyutunu belirler
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          // Dikeyde 4 boşluk bırakır
          const SizedBox(height: 4),
          // Bakiye tutarını gösterir
          Text(
            // Bakiye açıksa tutarı gösterir değilse gizler
            _isBalanceVisible ? '₺148.950,50' : '••••••••••',
            // Bakiye yazısının stilini ayarlar
            style: const TextStyle(
              // Yazı rengi
              color: Colors.white,
              // Yazı boyutu
              fontSize: 32,
              // Yazıyı kalın yapar
              fontWeight: FontWeight.bold,
              // Harfler arasını biraz daraltır
              letterSpacing: -0.5,
            ),
          ),
          // Dikeyde 20 boşluk bırakır
          const SizedBox(height: 20),
          // Kart numarası ile tarihi yan yana dizer
          const Row(
            // Elemanları iki yana dağıtır
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Row içindeki elemanları tutar
            children: [
              // Maskelenmiş kart numarasını gösterir
              Text(
                // Kart numarasının son dört hanesi
                '•••• •••• •••• 4289',
                // Kart numarasının yazı stilini ayarlar
                style: TextStyle(
                  // Yazı rengini belirler
                  color: Colors.white70,
                  // Yazı boyutu
                  fontSize: 15,
                  // Karakter aralığını artırır
                  letterSpacing: 2,
                  // Sabit genişlikli yazı tipi kullanır
                  fontFamily: 'monospace',
                ),
              ),
              // Kartın son kullanma tarihini gösterir
              Text(
                // Ay ve yıl bilgisi
                '10/28',
                // Yazının rengini ve boyutunu belirler
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hızlı işlem butonlarını oluşturan metot
  Widget _buildQuickActions() {
    // Butonların dış boşluğunu ayarlar
    return Padding(
      // Yatayda 20 dikeyde 8 boşluk bırakır
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      // Butonları yan yana dizer
      child: Row(
        // Butonları aralıklı yerleştirir
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Butonların listesi
        children: [
          // Para gönder butonunu oluşturur
          _buildActionButton(Icons.send_rounded, 'Para Gönder', () {
            // Basılınca son işlem bilgisini günceller
            setState(() => _lastAction = 'Para Gönder tıklandı');
          }),
          // Para yükle butonunu oluşturur
          _buildActionButton(Icons.account_balance_wallet, 'Para Yükle', () {
            // Basılınca son işlem bilgisini günceller
            setState(() => _lastAction = 'Para Yükle tıklandı');
          }),
          // QR işlem butonunu oluşturur
          _buildActionButton(Icons.qr_code_scanner, 'QR İşlem', () {
            // Basılınca son işlem bilgisini günceller
            setState(() => _lastAction = 'QR İşlem tıklandı');
          }),
          // Diğer işlemler butonunu oluşturur
          _buildActionButton(Icons.more_horiz, 'Diğer', () {
            // Basılınca son işlem bilgisini günceller
            setState(() => _lastAction = 'Diğer Menü tıklandı');
          }),
        ],
      ),
    );
  }

  // Ortak buton tasarımı, simge yazı ve tıklama fonksiyonu alır
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    // Butona Material yapısı verir
    return Material(
      // Arka planı beyaz yapar
      color: Colors.white,
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(16),
      // Butona tıklama efekti ekler
      child: InkWell(
        // Tıklanınca gönderilen fonksiyonu çalıştırır
        onTap: onTap,
        // Tıklama alanının köşelerini yuvarlar
        borderRadius: BorderRadius.circular(16),
        // Butonun kutusunu oluşturur
        child: Container(
          // Butonun genişliği
          width: 76,
          // Dikey iç boşluk verir
          padding: const EdgeInsets.symmetric(vertical: 14),
          // Butonun kenarlık ayarları
          decoration: BoxDecoration(
            // Köşeleri yuvarlar
            borderRadius: BorderRadius.circular(16),
            // Butona ince kenarlık ekler
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          // Simge ve yazıyı alt alta dizer
          child: Column(
            // Column sadece içeriği kadar yer kaplar
            mainAxisSize: MainAxisSize.min,
            // Column içindeki elemanları tutar
            children: [
              // Gelen simgeyi renk ve boyutuyla gösterir
              Icon(icon, color: const Color(0xFF6366F1), size: 24),
              // Simge ile yazı arasında boşluk bırakır
              const SizedBox(height: 6),
              // Butonun yazısını gösterir
              Text(
                // Parametreden gelen buton adı
                label,
                // Yazının stilini belirler
                style: const TextStyle(
                  // Yazı boyutu
                  fontSize: 11,
                  // Yazıyı yarı kalın yapar
                  fontWeight: FontWeight.w600,
                  // Yazı rengini belirler
                  color: Color(0xFF1E293B),
                ),
                // Yazıyı ortalar
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bildirim kutusunu oluşturan metot
  Widget _buildSafeNotificationBanner() {
    // Bildirim için kutu oluşturur
    return Container(
      // Yatay ve dikey dış boşluk verir
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // Her taraftan iç boşluk verir
      padding: const EdgeInsets.all(14),
      // Kutunun görünümünü belirler
      decoration: BoxDecoration(
        // Açık sarı arka plan verir
        color: const Color(0xFFFEF3C7),
        // Kutunun köşelerini yuvarlar
        borderRadius: BorderRadius.circular(14),
        // Sarı kenarlık oluşturur
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      // Bildirim elemanlarını yan yana dizer
      child: Row(
        // Row içindeki elemanları tutar
        children: [
          // Bildirim simgesini gösterir
          const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 24),
          // Yatayda 10 boşluk bırakır
          const SizedBox(width: 10),
          // Metnin kalan alana yayılmasını sağlar
          const Expanded(
            // Bildirim metnini gösterir
            child: Text(
              // Ders hakkında bilgi verir
              'Bugün 14-15 Ekim dersleri birleştirilmiştir. Canlı Flutter UI geliştirmeleri yapılmaktadır.',
              // Bildirim yazısının stilini ayarlar
              style: TextStyle(
                // Yazı boyutu
                fontSize: 12,
                // Yazı rengini belirler
                color: Color(0xFF92400E),
                // Satır yüksekliğini ayarlar
                height: 1.3,
              ),
            ),
          ),
          // Yatayda 8 boşluk bırakır
          const SizedBox(width: 8),
          // Bildirimi onaylamak için buton oluşturur
          TextButton(
            // Butona basılınca çalışır
            onPressed: () {
              // Son işlem bilgisini günceller
              setState(() => _lastAction = 'Bildirim onaylandı');
            },
            // Butonun yazısını oluşturur
            child: const Text(
              // Butonun adı
              'Tamam',
              // Yazının stilini ayarlar
              style: TextStyle(
                  // Yazıyı kalın yapar ve rengini belirler
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB45309)),
            ),
          ),
        ],
      ),
    );
  }

  // İstatistik kartlarını oluşturan metot
  Widget _buildFlexStatistics() {
    // İstatistik alanına boşluk verir
    return Padding(
      // Yatayda 20 dikeyde 4 boşluk bırakır
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      // İstatistik kartlarını yan yana dizer
      child: Row(
        // Row içindeki kartları tutar
        children: [
          // İlk karta 2 birimlik esnek alan verir
          Expanded(
            // Diğer karta göre iki kat alan ayırır
            flex: 2,
            // Harcama kartını oluşturur
            child: Container(
              // Kartın içinden 16 boşluk bırakır
              padding: const EdgeInsets.all(16),
              // Kartın görünümünü ayarlar
              decoration: BoxDecoration(
                // Arka planı beyaz yapar
                color: Colors.white,
                // Köşeleri yuvarlar
                borderRadius: BorderRadius.circular(16),
                // İnce kenarlık ekler
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              // Kart içindeki yazıları alt alta dizer
              child: const Column(
                // Yazıları sola hizalar
                crossAxisAlignment: CrossAxisAlignment.start,
                // Column içindeki elemanları tutar
                children: [
                  // Harcama başlığını gösterir
                  Text('Aylık Harcama',
                      // Başlığın rengini ve boyutunu belirler
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  // Dikeyde 4 boşluk bırakır
                  SizedBox(height: 4),
                  // Harcama miktarını gösterir
                  Text('₺24.450',
                      // Tutarın yazı stilini ayarlar
                      style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 20,
                          // Yazıyı kalın yapar
                          fontWeight: FontWeight.bold,
                          // Yazı rengini belirler
                          color: Color(0xFF0F172A))),
                ],
              ),
            ),
          ),
          // İki kart arasında 12 boşluk bırakır
          const SizedBox(width: 12),
          // İkinci karta 1 birimlik esnek alan verir
          Expanded(
            // İlk kartın yarısı kadar alan ayırır
            flex: 1,
            // Puan kartını oluşturur
            child: Container(
              // Kartın içinden 16 boşluk bırakır
              padding: const EdgeInsets.all(16),
              // Kartın görünümünü ayarlar
              decoration: BoxDecoration(
                // Arka planı beyaz yapar
                color: Colors.white,
                // Köşeleri yuvarlar
                borderRadius: BorderRadius.circular(16),
                // İnce kenarlık ekler
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              // Puan bilgilerini alt alta dizer
              child: const Column(
                // Yazıları sola hizalar
                crossAxisAlignment: CrossAxisAlignment.start,
                // Column içindeki elemanları tutar
                children: [
                  // Puan başlığını gösterir
                  Text('Puan',
                      // Başlığın rengini ve boyutunu belirler
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  // Dikeyde 4 boşluk bırakır
                  SizedBox(height: 4),
                  // Puan miktarını gösterir
                  Text('4.850',
                      // Puanın yazı stilini ayarlar
                      style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 20,
                          // Yazıyı kalın yapar
                          fontWeight: FontWeight.bold,
                          // Yazı rengini mor yapar
                          color: Color(0xFF6366F1))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

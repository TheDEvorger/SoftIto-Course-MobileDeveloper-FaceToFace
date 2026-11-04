// Flutter arayüz elemanlarını projeye ekler
import 'package:flutter/material.dart';
// Firestore sorgularını ve akışını kullanmak için ekler
import 'package:cloud_firestore/cloud_firestore.dart';
// Öğrenci modeli ve servisini projeye ekler
import 'package:listenchild/models/ogrenci_model.dart';
// Form ve öğrenci listesini barındıran StatefulWidget
class FirestoreYonetimEkrani extends StatefulWidget {
  // Constructor yazımı hatalı; super.key süslü parantez içinde olmalı
  const FirestoreYonetimEkrani(super.key);
  // Üst sınıftaki createState metodunu yeniden yazar
  @override
  // Döndürülen State sınıfının adı aşağıdaki tanımla uyuşmuyor
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}
// Ekranın state sınıfı; yukarıdaki createState farklı isim bekliyor
class FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  // Firestore öğrenci işlemleri için servis nesnesi oluşturur
  final FirestoreOgrenciServisi _servis = FirestoreOgrenciServisi();
  // Ad soyad kutusundaki metni yönetir
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  // Proje adı kutusundaki metni yönetir, arayüzde alanı eksik
  final TextEditingController _projeKontrolcusu = TextEditingController();
  // Not kutusundaki metni yönetir
  final TextEditingController _notKontrolcusu = TextEditingController();
  // Üst sınıfın dispose metodunu yeniden yazar
  @override
  // Ekran kaldırılırken çalışan temizlik metodu
  void dispose() {
    // Ad soyad controllerının kaynaklarını bırakır
    _adSoyadKontrolcusu.dispose();
    // Not controllerının kaynaklarını bırakır
    _notKontrolcusu.dispose();
    // Proje controllerının kaynaklarını bırakır
    _projeKontrolcusu.dispose();
    // Üst sınıfın dispose metodunu çağırır
    super.dispose();
  }
  // Üst sınıftaki build metodunu yeniden yazar
  @override
  // Sayfanın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Üst menü ve ana içeriği sağlayan Scaffold kurar
    return Scaffold(
      // Üst menüyü oluşturur
      appBar: AppBar(
        // Üst menünün başlığını gösterir
        title: const Text('Canlı Firestore Ekranı'),
        // Üst menünün rengini amber yapar
        backgroundColor: Colors.amber.shade600, 
      ),   
      // Ana içerikleri alt alta dizmeyi amaçlar
      body:Column(
        // Column içindeki çocukların listesi
        children: [
          // children listesine padding adında named argüman yazılamaz
          padding: const EdgeInsets.all(12.0),
          // Form alanlarının çevresine boşluk bırakmayı amaçlar
          child: Padding(
            // Her taraftan 12 birim boşluk verir
            padding: const EdgeInsets.all(12.0),
            // Form alanlarını alt alta dizer
            child: Column(
              // Formdaki elemanlar
              children: [
                // Ad soyad için yazı giriş alanı oluşturur
                TextField(
                  // Ad soyad controllerını giriş alanına bağlar
                  controller: _adSoyadKontrolcusu,
                  // Giriş alanının görünümünü ayarlar
                  decoration: const InputDecoration(
                    // Ad soyad alanının etiketini belirler
                    labelText: 'Öğrenci Adı Soyadı',
                    // İnsan simgesini giriş alanının başına koyar
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                // Giriş alanları arasına 8 birim boşluk bırakır
                const SizedBox(height: 8.0),
                // Not alanına sabit genişlik verir
                SizedBox(
                  // Not alanını 90 birim genişliğinde tutar
                  width: 90,
                  // Not için yazı giriş alanı oluşturur
                  child: TextField(
                    // Not controllerını bağlar
                    controller: _notKontrolcusu,
                    // Sayısal klavyenin açılmasını ister
                    keyboardType: TextInputType.number,
                    // Not alanının görünümünü ayarlar
                    decoration: const InputDecoration(
                      // Notun 0 ile 100 arasında girileceğini etiket olarak gösterir
                      labelText: 'Not (0-100)',
                      // Not alanına not simgesi ekler
                      prefixIcon: Icon(Icons.grade),
                    ),
                  ),
                ),
              ],
            ),
            // Bu satırın konumunda üstteki Padding kapanışı henüz uyumlu değil
            const SizedBox(height: 12.0),
            // Buluta kaydet butonunu oluşturur
            ElevatedButton.icon(
              // ElevatedButton yanlış yazılmış, ElavatedButton bulunamaz
              style: ElavatedButton.styleFrom(
                // Butonun arka plan rengini pembe yapar
                backgroundColor: Colors.pink, 
                // Buton üzerindeki yazı ve simgeyi kahverengi yapar
                foregroundColor: Colors.brown,
                // Butonun minimum yüksekliğini 44 yapar
                minimumSize: const Size.fromHeight(44),
              ),
              // Butona basılınca kaydetme metodunu çağırır
              onPressed: _yeniOgrenciKaydet,
              // Butona yükleme simgesi koyar
              icon: const Icon(Icons.cloud_upload),
              // Butonun yazısını gösterir
              label: const Text('Buluta kaydet'),
            ),
          ),
        ]
      )
      // Ayırıcı çizgi amaçlanır ancak mevcut konumda sözdizimi hatalı
      const Divider(thickness:2),
      // Öğrenci listesine kalan dikey alanı ayırır
      Expanded(
        // Firestore sorgusunun değişimlerini dinleyen widget
        child: StreamBuilder<QuerySnapshot>(
          // Firestore örneğinden canlı akış oluşturur
          stream: FirebaseFirestore.instance
            // ogrenciler koleksiyonunu seçer
            .collection('ogrenciler')
            // Öğrencileri nota göre azalan sırada listeler
            .orderBy('notu',descending: true)
            // snapshots ile canlı belge değişim akışını açar
            .snapshots(),
            // Akış güncellendikçe ekran içeriğini oluşturur
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // Firestore akışında hata olup olmadığını kontrol eder
              if (snapshot.hasError) {
                // Hata varsa sebebini ekranda gösterir
                return Center(child: Text('Bulut hatası: ${snapshot.error}'));
              }
              // İlk bağlantı devam ederken bekleme durumunu kontrol eder
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Veriler gelene kadar yükleme simgesi gösterir
                return const Center(child: CircularProgressIndicator());
              }
              // Veri yoksa veya belge listesi boşsa kontrol eder
              if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                // Ortalanmış boş liste mesajı oluşturur
                return const Center(
                  // Henüz kayıt yok yazısını gösterir
                  child: Text('Henüz kayıt yok'),
                );
              }
              // Gelen Firestore belgelerini listeye alır
              final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;
              // Kayıt sayısı kadar satır oluşturacak listeyi kurar
              return ListView.builder(
                // Listeye gelecek eleman sayısını belirler
                itemCount: dokumanlar.length,
                // Her belge için satırı oluşturur
                itemBuilder: (context, index) {
                  // Listedeki sıradaki Firestore belgesini alır
                  final doc = dokumanlar[index];
                  // Modelde fromFireStore tanımlı; buradaki fromFirestore ismi uyuşmuyor
                  final ogrenci = OgrenciModel.fromFirestore(doc);
                  // Kaydırarak silinebilen liste elemanı oluşturur
                  return Dismissible(
                    // Kartın anahtarı olarak belge IDsini kullanır
                    key: Key(ogrenci.id),
                    // Sağdan sola kaydırma yönünü seçer
                    direction: DismissDirection.endToStart,
                    // Silme sırasında görünen arka planı oluşturur
                    background: Container(
                      // Silme simgesini sağ tarafa hizalar
                      alignment: Alignment.centerRight,
                      // Sağdan 20 birim boşluk bırakır
                      padding: const EdgeInsets.only(right: 20.0),
                      // Silme arka planını kırmızı yapar
                      color: Colors.red,
                      // Beyaz çöp kutusu simgesi gösterir
                      child: const Icon(Icons.delete_forever, color: Colors.white),
                    ),
                    // Eleman kaydırılarak kaldırılınca çalışır
                    onDismissed: (direction) {
                      // Öğrencinin belgesini silme işlemini başlatır
                      _servis.ogrenciSil(ogrenci.id);
                      // Ekranın altına kısa bilgilendirme mesajı çıkarır
                      ScaffoldMessenger.of(context).showSnackBar(
                        // Silinen öğrencinin adını mesajda gösterir
                        SnackBar(content: Text('${ogrenci.adSoyad} silindi')),
                      );
                    },
                    // Öğrenci bilgilerini ListTile içinde gösterir
                    child: ListTile(
                      // Notu göstermek için yuvarlak alan oluşturur
                      leading: CircleAvatar(
                        // Nota göre yeşil, turuncu veya kırmızı renk seçer
                        backgroundColor: ogrenci.notu >= 80 ? Colors.green : (ogrenci.notu >= 50 ? Colors.orange : Colors.red),
                        // Öğrencinin notunu metin olarak gösterir
                        child: Text(
                          // Sayısal notu Stringe çevirir
                          '${ogrenci.notu}',
                          // Not yazısını beyaz ve kalın yapar
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Öğrencinin adını başlık olarak gösterir
                      title: Text(
                        // Ad soyadı bilgisi; arkasında virgül eksik
                        ogrenci.adSoyad
                        // Başlık yazısını kalın yapar
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Öğrencinin proje adını alt metinde gösterir
                      subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                      // Not düzenleme butonunu oluşturur
                      trailing: IconButton(
                        // Tanımlanmayan notGuncelleDialog metodunu çağırmayı amaçlar
                        onPressed: () => notGuncelleDialog(ogrenci),
                        // Butonda düzenleme simgesini gösterir
                        icon: const Icon(
                          // Kalem simgesini belirler
                          Icons.edit,
                          // Simgenin rengini amber yapar
                          color: Colors.amberAccent,
                        ),
                      ),
                    ),
                  );
                }
              );
            },
        ),
      ),
    );
  }
  // Yeni öğrenci için formdaki değerleri okuyan metot
  void _yeniOgrenciKaydet() {
    // Girilen ad soyadın kenar boşluklarını temizler
    final adSoyad = _adSoyadKontrolcusu.text.trim();
    // Proje adı controllerındaki metni alır; formda alan eksik
    final proje = _projeKontrolcusu.text.trim();
    // Notu sayıya çevirir, geçersizse sıfır kullanır
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;
    // projeAdi diye değişken yok, burada proje kullanılmalıydı
    if (adSoyad.isEmpty || projeAdi.isEmpty) {
      // Hata mesajını göstermek için ScaffoldMessenger kullanır
      ScaffoldMessenger.of(context).showSnackBar(
        // Ad veya proje adı eksikse uyarı gösterir
        const SnackBar(content: Text('Lütfen ad-soayd ve proje adını girin.')),
      );
      // Geçersiz formda kaydetme işlemini durdurur
      return;
    }
    // Girilen bilgileri Firestore ekleme servisine gönderir
    _servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);
    // Kaydetme çağrısından sonra ad soyad alanını temizler
    _adSoyadKontrolcusu.clear();
    // Proje adı metnini temizler
    _projeKontrolcusu.clear();
    // Not alanındaki metni temizler
    _notKontrolcusu.clear();
  }
  // Yapılacaklar başlığı Dart kodu değil, yorum içine alınmamış
  Yapılacaklar
  // Proje adı için giriş alanı ekleme notu, kod dışında duruyor
  1 expanded içinde projeadı inputu açılacak
  // Not güncelleme penceresini yazma notu, kod dışında duruyor
  2 _notGuncelleDialog fonksiyonu yazılacak
  // Sayfa ve dönüşümleri tamamlama notu, kod dışında duruyor
  3 sayfalar parse edilecek ve sistem çalışır hale getirilecek
  // Sınıfta uygulamayı gösterme hatırlatması, kod dışında duruyor
  4 yarın rastgele biri seçilip ekranında sınıfa gösterecek

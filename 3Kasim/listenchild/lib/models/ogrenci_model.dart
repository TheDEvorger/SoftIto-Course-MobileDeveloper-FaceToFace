// Firestore öğrencisine ait alanları tutan model sınıfı
class OgrenciModel {
  // Firestore belgesinin ID bilgisini tutar
  final String id;
  // Öğrencinin ad soyadını tutar
  final String adSoyad;
  // Öğrencinin proje adını tutar
  final String projeAdi;
  // Öğrencinin notunu tam sayı olarak tutar
  final int notu;
  // Kaydın tarih ve saatini tutar
  final DateTime kayitTarihi;
  // Öğrenci nesnesi oluştururken gerekli bilgileri alır
  const OgrenciModel({
    // Belge IDsi verilmesini zorunlu tutar
    required this.id,
    // Öğrenci adının verilmesini zorunlu tutar
    required this.adSoyad,
    // Proje adının verilmesini zorunlu tutar
    required this.projeAdi,
    // Notun verilmesini zorunlu tutar
    required this.notu,
    // Kayıt tarihinin verilmesini zorunlu tutar
    required this.kayitTarihi,
  });
  // Firestore belgesinden öğrenci nesnesi üretir
  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    // Belge verisini Map olarak alır, null ise boş Map kullanır
    final veri = doc.data() as Map<String, dynamic>? ?? {};
    // Belgedeki alanlarla yeni öğrenci nesnesi oluşturur
    return OgrenciModel(
      // Belge kimliğini modelin ID alanına aktarır
      id: doc.id,
      // Ad soyadı String olarak alır, yoksa varsayılan metni kullanır
      adSoyad: veri['adSoyad'] as String? ?? 'isimsiz Öğrenci ',
      // Proje adını okur, yoksa belirtilmemiş metnini kullanır
      projeAdi: veri['projeAdi'] as String? ?? 'proje adı belirtilmemiş',
      // Notu sayısal veriden int tipine çevirir, yoksa sıfır olur
      notu: (veri['notu'] as num?)?.toInt() ?? 0,
      // Kayıt tarihi alanının değerini sonraki satırda belirler
      kayitTarihi: 
        // Firestore Timestamp değerini DateTime yapar, yoksa şimdiki zamanı alır
        (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
// Firestore üzerinde öğrenci işlemlerini toplayan servis sınıfı
class FirestoreOgrenciServisi {
  // Firebase bağlantısından öğrenci koleksiyonuna erişir
  final CollectionReference ogrencilerKoleksiyonu = FirebaseFirestore.instance
      // İşlemleri ogrenciler koleksiyonunda yapar
      .collection('ogrenciler');
      // Yeni öğrenci ekleyen asenkron metodu tanımlar
      Future<void> ogrenciEkle({
        // Ad soyad parametresini zorunlu alır
        required String adSoyad,
        // Proje adını zorunlu alır
        required String projeAdi,
        // Öğrencinin notunu zorunlu alır
        required int notu,
      // Metot sonucu değer döndürmez, işlem bitişi beklenebilir
      }) async {
        // Ekleme sırasında hata oluşup oluşmadığını denetler
        try {
          // Yeni belgeyi otomatik ID ile koleksiyona ekler
          await ogrencilerKoleksiyonu.add({
            // Ad soyadı alanını belgeye yazar
            'adSoyad': adSoyad,
            // Proje adını belgeye yazar
            'projeAdi': projeAdi,
            // Notu belgeye yazar
            'notu': notu,
            // Kayıt tarihini sunucu saatinden alır
            'kayitTarihi': FieldValue.serverTimestamp(),
          });
          // Belge eklenince konsola başarı mesajı yazar
          print('Öğrenci Başarıyla Eklendi');
        // Ekleme sırasında hata oluşursa burası çalışır
        } catch (e) {
          // Hata ayrıntısını konsola yazar
          print('Öğrenci ekleme sırasında hata oluştu: $e');
          // Hatayı çağıran koda tekrar iletir
          rethrow;
        }
        // Belirli belge IDsiyle kayıt oluşturmayı amaçlar; şu an ogrenciEkle içinde kalmış
        Future<void> ogrenciIdileKaydet({
          // Belgenin IDsi olarak kullanılacak değeri alır
          required String tcNo,
          // Öğrenci adını zorunlu alır
          required String adSoyad,
          // Proje adını zorunlu alır
          required String projeAdi,
          // Not parametresini alır ama bu metotta belgeye yazılmıyor
          required int notu,
        // Kimliği verilmiş belgeyi kaydetmeye hazırlanan asenkron metot
        }) async {
          // tcNo değerini belge IDsi yapar ve set ile kaydeder
          await ogrencilerKoleksiyonu.doc(tcNo).set({
            // Öğrenci adını kaydeder
            'adSoyad': adSoyad,
            // Proje adını kaydeder
            'projeAdi': projeAdi,
            // Güncelleme zamanını sunucudan alır
            'guncellemeTarihi': FieldValue.serverTimestamp(),
        // merge true ile diğer belge alanlarını korumayı amaçlar
        }, SetOptions(merge: true));
      }
      // Öğrencileri liste olarak getirmeyi amaçlar; şu an iç içe tanımlı
      Future<List<OgrenciModel>> tumogrencileriGetir() async {
        // Veri getirme sırasında hata yakalamak için dener
        try {
          // Koleksiyondaki belgeleri sorgular
          final QuerySnapshot snapshot = await ogrencilerKoleksiyonu
          // Not alanına göre büyükten küçüğe sıralar
          .orderBy('notu', descending: true)
          // Sorgu sonucunun gelmesini bekler
          .get();
          // Gelen belgeleri dönüştürmeye başlar
          return snapshot.docs
              // Her belgeyi OgrenciModel nesnesine çevirir
              .map((doc) => OgrenciModel.fromFireStore(doc))
              // Dönüştürülen öğrencileri listeye toplar
              .toList();
        // Sorgu hata verirse burası çalışır
        } catch (e) {
          // Hata mesajını konsola yazar
          print('Öğrencileri getirme sırasında hata oluştu: $e');
          // Hata durumunda boş öğrenci listesi döndürür
          return [];
        }
      }
      // Belirtilen öğrencinin notunu değiştirmeyi amaçlar
      Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async { 
        // _ogrencilerKoleksiyonu tanımlı olmadığı için bu satır hatalıdır
        await _ogrencilerKoleksiyonu.doc(documanId).update({
          // Belgedeki not alanını yeni notla değiştirir
          'notu': yeniNot,
          // Son düzenleme zamanını sunucudan alır
          'sonDuzenleme': FieldValue.serverTimestamp(),
        });
      }
      // Belirtilen belgeyi Firestore koleksiyonundan siler
      Future<void> ogrenciSil(String documanId) async {
        // Belge IDsiyle silme işleminin tamamlanmasını bekler
        await ogrencilerKoleksiyonu.doc(documanId).delete();
        // Silinen belgenin IDsini konsola yazar
        print('Öğrenci başarıyla silindi: $documanId');
      }
}

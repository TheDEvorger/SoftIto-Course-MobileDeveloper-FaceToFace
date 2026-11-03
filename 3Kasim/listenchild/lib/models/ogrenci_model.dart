class OgrenciModel {
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModel({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  factory OgrenciModel.fromFireStore(DocumentSnapshot doc) {
    final veri = doc.data() as Map<String, dynamic>? ?? {};

    return OgrenciModel(
      id: doc.id,
      adSoyad: veri['adSoyad'] as String? ?? 'isimsiz Öğrenci ',
      projeAdi: veri['projeAdi'] as String? ?? 'proje adı belirtilmemiş',
      notu: (veri['notu'] as num?)?.toInt() ?? 0,
      kayitTarihi: 
        (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class FirestoreOgrenciServisi {
  final CollectionReference ogrencilerKoleksiyonu = FirebaseFirestore.instance
      .collection('ogrenciler');
      Future<void> ogrenciEkle({
        required String adSoyad,
        required String projeAdi,
        required int notu,
      }) async {
        try {
          await ogrencilerKoleksiyonu.add({
            'adSoyad': adSoyad,
            'projeAdi': projeAdi,
            'notu': notu,
            'kayitTarihi': FieldValue.serverTimestamp(),
          });
          print('Öğrenci Başarıyla Eklendi');
        } catch (e) {
          print('Öğrenci ekleme sırasında hata oluştu: $e');
          rethrow;
        }

        Future<void> ogrenciIdileKaydet({
          required String tcNo,
          required String adSoyad,
          required String projeAdi,
          required int notu,
        }) async {
          await ogrencilerKoleksiyonu.doc(tcNo).set({
            'adSoyad': adSoyad,
            'projeAdi': projeAdi,
            'guncellemeTarihi': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      Future<List<OgrenciModel>> tumogrencileriGetir() async {
        try {
          final QuerySnapshot snapshot = await ogrencilerKoleksiyonu
          .orderBy('notu', descending: true)
          .get();
          return snapshot.docs
              .map((doc) => OgrenciModel.fromFireStore(doc))
              .toList();
        } catch (e) {
          print('Öğrencileri getirme sırasında hata oluştu: $e');
          return [];
        }
      }

      Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async { 
        await _ogrencilerKoleksiyonu.doc(documanId).update({
          'notu': yeniNot,
          'sonDuzenleme': FieldValue.serverTimestamp(),
        });
      }

      Future<void> ogrenciSil(String documanId) async {
        await ogrencilerKoleksiyonu.doc(documanId).delete();
        print('Öğrenci başarıyla silindi: $documanId');
      }
}

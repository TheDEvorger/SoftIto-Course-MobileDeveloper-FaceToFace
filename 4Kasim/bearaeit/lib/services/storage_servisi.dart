// Byte dizisi (Uint8List) tipini kullanmak için ekler (web + mobil uyumlu)
import 'dart:typed_data';
// Firebase Storage kütüphanesini ekler
import 'package:firebase_storage/firebase_storage.dart';
// Kamera ve galeriden görsel seçmek için eklentiyi ekler
import 'package:image_picker/image_picker.dart';

// Görsel seçme ve bulut depolama işlemlerini tutan sınıf
class StorageServisi {
  // Firebase Storage nesnesini alır
  FirebaseStorage get _storage => FirebaseStorage.instance;
  // Görsel seçici nesnesini oluşturur
  final ImagePicker _picker = ImagePicker();

  // Kameradan parametresine göre görsel seçer, byte olarak döner (web'de dart:io File çalışmaz)
  Future<Uint8List?> gorselSec({bool kameradan = false}) async {
    // Görsel seçiciyi açıp seçilen dosyayı bekler
    final XFile? xFile = await _picker.pickImage(
      // True ise kamerayı, false ise galeriyi kullanır
      source: kameradan ? ImageSource.camera : ImageSource.gallery,
      // Seçilen görselin kalitesini 80 olarak ayarlar
      imageQuality: 80,
      // Görsel genişliğini en fazla 1200 yapar
      maxWidth: 1200,
    );
    // Görsel seçilmediyse null döndürür
    if (xFile == null) return null;
    // Seçilen dosyanın içeriğini byte olarak döndürür
    return await xFile.readAsBytes();
  }

  // Firebase Storage'a byte verisi yükleme görevini başlatan metot
  UploadTask yuklemeBaslat({
    // Yüklenecek verinin verilmesini zorunlu tutar
    required Uint8List veri,
    // Dosyanın adının verilmesini zorunlu tutar
    required String dosyaAdi,
    // Klasör adı için varsayılan değer
    String klasor = 'yuklemeler',
  }) {
    // Klasör ve dosya adından Storage dosya yolunu oluşturur
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');
    // Yüklenen dosyanın bilgilerini oluşturur
    final metadata = SettableMetadata(
      // image_picker JPEG ürettiği için türü JPEG olarak işaretler
      contentType: 'image/jpeg',
      // Dosyanın özel meta verisine ekleyen bilgisini koyar
      customMetadata: {'ekleyen': 'Bearaeit'},
    );
    // putData hem web'de hem mobilde çalışır
    return ref.putData(veri, metadata);
  }

  // Dosyanın indirme bağlantısını getirir
  Future<String> urlGetir(Reference ref) async {
    // Firebase Storage üzerinden dosyanın indirme adresini alır
    return await ref.getDownloadURL();
  }

  // Storage dosyasını siler
  Future<void> dosyaSil(String dosyaYolu) async {
    // Silinecek dosyanın Storage referansını oluşturur
    final Reference ref = _storage.ref().child(dosyaYolu);
    // Dosyayı Firebase Storage'dan siler
    await ref.delete();
  }
}

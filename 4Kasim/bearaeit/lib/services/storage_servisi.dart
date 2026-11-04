// Dosyalarla çalışmak için dart:io kütüphanesini ekler
import 'dart:io';
// Firebase Storage kütüphanesini ekler
import 'package:firebase_storage/firebase_storage.dart';
// Kamera ve galeriden görsel seçmek için eklentiyi ekler
import 'package:image_picker/image_picker.dart';
// Görsel seçme ve bulut depolama işlemlerini tutan sınıf
class StorageServisi {
  // Firebase Storage nesnesini alır
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Görsel seçici nesnesini oluşturur
  final ImagePicker _picker = ImagePicker();
  // Kameradan parametresine göre görsel seçer, işlem iptal edilirse null döner
  Future<File?> gorselSec({bool kameradan=false}) async {
    // Görsel seçiciyi açıp seçilen dosyayı bekler
    final XFile? xFile = await _picker.pickImage(
      // True ise kamerayı, false ise galeriyi kullanır
      source:kameradan ? ImageSource.camera : ImageSource.gallery,
      // Seçilen görselin kalitesini 80 olarak ayarlar
      imageQuality: 80,
      // Görsel genişliğini en fazla 1200 yapar
      maxWidth: 1200,
    );
    // Görsel seçilmediyse null döndürür
    if (xFile == null) return null;
      // Seçilen dosyanın yoluyla File nesnesi döndürür
      return File(xFile.path);
  }
  // Firebase Storagea dosya yükleme görevini başlatan metot
  UploadTask yüklemeBaslat({
    // Yüklenecek dosyanın verilmesini zorunlu tutar
    required File dosya,
    // Dosyanın adının verilmesini zorunlu tutar
    required String dosyaAdi,
    // Klasör adı için varsayılan değer var fakat string tipi yanlış yazılmış
    string klasor = 'yuklemeler',
  }) {
    // Klasör ve dosya adından Storage dosya yolunu oluşturur
    final Reference ref = _storage.ref().child('$klasor/$dosyaAdi');
    // Yüklenen dosyanın bilgilerini oluşturur
    final metadata = SettableMetadata(
      // Dosyayı her durumda PNG olarak işaretler
      contentType: 'image/png',
      // Dosyanın özel meta verisine ekleyen bilgisini koyar
      customMetadata: {'ekleyen': 'Bearaeit'},
    );
    // Dosya yüklemesini başlatıp UploadTask döndürür
    return ref.putFile(dosya, metadata);
  }
  // Dosyanın indirme bağlantısını getirmek ister, ref parametresinin tanımı hatalı
  Future<String> urlGetir({Reference ref}) async {
    // Firebase Storage üzerinden dosyanın indirme adresini alır
    return await ref.getDownloadURL();
  }
  // Storage dosyasını silmek ister, parametre parantezi hatalı
  Future<void> dosyaSil(String dosyaYolu}) async {
    // Silinecek dosyanın Storage referansını oluşturur
    final Reference ref = _storage.ref().child(dosyaYolu);
    // Dosyayı Firebase Storagedan siler
    await ref.delete();
  }
}

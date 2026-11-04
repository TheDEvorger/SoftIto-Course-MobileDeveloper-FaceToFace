// Seçilen medya dosyasını File tipinde kullanmak için ekler
import 'dart:io';
// Galeriden ve kameradan görsel seçmeyi sağlayan paketi ekler
import 'package:image_picker/image_picker.dart';
// Galeriden veya kameradan görsel seçen servis sınıfı
class MedyaSeciciServisi{
  // Görsel seçim işlemleri için ImagePicker nesnesi oluşturur
  final ImagePicker _picker = ImagePicker();
  // Galeriden görsel seçer, seçim iptal edilirse null döndürür
  Future<File?> galeridenSec() async {
    // Kullanıcıdan görsel seçmesini bekler
    final XFile? secilen = await _picker.pickImage(
      // Görsel kaynağını galeri olarak belirler
      source: ImageSource.gallery,
      // Görsel kalitesini 80 olarak ayarlar ancak satırın sonunda virgül eksik
      imageQuality: 80
      // Seçilen görselin genişliğini en fazla 1200 ile sınırlar
      maxWidth: 1200,
    );
    // Seçim yapılmadıysa null döndürür ancak satırda fazladan kapatma parantezi var
    if (secilen == null) return null;    }
    // Seçilen görselin yolundan File oluşturup döndürür
    return File(secilen.path);
  }
  // Kameradan fotoğraf çeker, işlem iptal edilirse null döndürür
  Future<File?> kameradanCec() async {
    // Kamera üzerinden görsel alınmasını bekler
    final XFile? secilen = await _picker.pickImage(
      // Görsel kaynağını kamera olarak belirler
      source: ImageSource.camera,
      // Çekilen görselin kalitesini 80 olarak ayarlar
      imageQuality: 80,
      // Görsel genişliğini en fazla 1200 ile sınırlar
      maxWidth: 1200,
    );
    // Kamerada seçim iptal edilmişse null döndürür
    if (secilen == null) return null;
    // Çekilen fotoğrafın yolundan File oluşturup döndürür
    return File(secilen.path);
  }
}

// Yüklenecek dosyayı File tipinde kullanmak için ekler
import 'dart:io';
// Dosyaları Firebase Storage alanına göndermek için paketi ekler
import 'package:firebase_storage/firebase_storage.dart';
// Dosyaları Firebase Storagea yükleyen servis sınıfı
class StorageServisi {
  // Firebase Storage nesnesini alır
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Dosya yüklemesini başlatır ve UploadTask döndürür
  UploadTask yuklemeBaslat({
    // Yüklenecek dosyanın verilmesini zorunlu tutar
    required File dosya,
    // Dosyanın kaydedileceği dizini zorunlu tutar
    required String hedefDizin,
    // Dosyanın Storage içindeki adını zorunlu tutar
    required String dosyaAdi,
  }) {
    // Hedef dizin ve dosya adından Storage dosya yolunu oluşturur
    final Reference ref= _storage.ref().child('$hedefDizin/$dosyaAdi');
    // Yüklenecek dosyanın ek bilgilerini hazırlar
    final metadata = SettableMetadata(
      // Dosyanın türünü JPEG olarak belirler fakat devamına virgül eksik
      contentType: 'image/jpeg',
      // Dosyaya özel metadata alanı oluşturur
      customMetadata: {
      // Yükleyici bilgisini metadata içine ekler
      'yukleyen': 'eeAron App giantteam'
      },
    );
    // Dosyayı metadata ile yüklemeye başlar ve UploadTask döndürür
    final UploadTask task = ref.putFile(dosya, metadata);
    // Yükleme durumunu dinlemeyi amaçlar ancak task burada tanımlı değil
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      // Gönderilen bayt miktarını toplam bayt miktarına bölerek ilerlemeyi hesaplar
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      // Yükleme yüzdesini yazdırmayı amaçlar ancak yuzde değişkeni tanımlı değil
      print('yükleniyor %${(progress * 100).toStringAsFixed(1)}');
    });
    return task;
  }
}


//Asenkron tamamlanan, geriye değer döndürmeyen fonksiyon
Future<void> fetchDashboardData() async {
  //Hata oluşabilecek kodları çalıştırır
  try {
    //3 adet asenkron fonksiyonu aynı anda çalıştırır 
    final result = await Future.wait([
      //Kullanıcı profili verilerini çeker
      fetchUserProfile(),
      //Kullanıcının hesap bakiyesini çeker
      fetchAccountBalance(),
      //Kullanıcının bildirimlerini çeker
      fetchNotification(),
      //ilk hatada beklemeksizin hatayı gönderir.
    ], eagerError: true);
    //işlem olumluysa ekrana yazı basar.
    print("Tüm veriler geldi $result");
    //Hata oluşursa catch bloğuna girer.
  } catch (e) {
    //Hata oluştuğunda burası çalışır ve yazıyı ekrana basar.
    print("isteklerden Biri başarısız oldu $e");
  }
}



//Future:Tek bşr kere verş çekileceği zaman kullanılır ya da hata yada değer döndürüp bitirir.
//Stream:Bir boru hattı şeklinde çalışır (pipe), Zaman içinde 1 10 100 ya da sonsuz sayıda veri sağlanabilir.
//(Borsa fiyatları GPS konum güncelleme,Firebase canlı dinleme)

//dartın asenkron yapısını kullanmak için kütüphane ekledik
import 'dart:async';

//uygulamayı çalıştıran ana fonksiyondur
void main() {
  //controller oluşturma
  final controller = StreamController<int>.broadcast();
  //dinleyici (listener) bağlama
  final subscription = controller.stream.listen(
    //dinleyici gelen data veririni basar
    (data) => print("yeni Veri: $data"),
    //hata gerçekleştiğinde bu yazıyı basar
    onError: (err) => print("Hata Oluştu: $err"),
    //tamamlandığında bu yazıyı basar
    onDone: () => print("yayın Tamamlandı"),
  );

  //stream için veri ekleme yapar
  controller.sink.add(10);
  //stream için veri ekleme yapar
  controller.sink.add(20);
  //stream için veri ekleme yapar
  controller.sink.add(30);

  //bbirden fazla dinleyiciye veri yollarız
  final broadcastStream = controller.stream.asBroadcastStream();
  //Dinleneme yapar d datasını alıp ekrana yazar.
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
  //yine dinleneme yapar d datasını alıp ekrana yazar.
  broadcastStream.listen((d) => print("Analitik Servisi Ekranı: $d"));

 //streami kapatır
  controller.close();
}

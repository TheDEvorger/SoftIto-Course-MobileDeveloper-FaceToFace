// ValueNotifier kullanmak için foundation ekler
import 'package:flutter/foundation.dart';
// Sepetteki ürün adedini tutan sınıf
class SepetKontrolu {
  // Uygulamada paylaşılan tekil controllerı oluşturur
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  // Dışarıdan nesne oluşturmayı kısıtlayan private constructor
  SepetKontrolu._dahili();
  // Ürün sayısını sıfırdan başlayan ValueNotifierda tutar
  final ValueNotifier<int> _urunSayisi = ValueNotifier<int>(0);
  // Özel sayacı dışarıya dinlenebilir olarak verir
  ValueNotifier<int> get urunSayisi => _urunSayisi;
  // Sepete ekleme için sayacı artıran metot
  void sepeteEkle() {
    // Sayıyı bir artırıp dinleyenlere bildirir
    _urunSayisi.value++;
  }
  // Sepet sayacını sıfırlayan metot
  void sepetiSifirla() {
    // Sayıyı sıfırlayıp dinleyenlere bildirir
    _urunSayisi.value = 0;
  }
}

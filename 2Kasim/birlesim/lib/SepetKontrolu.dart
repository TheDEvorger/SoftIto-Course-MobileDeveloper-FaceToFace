import 'package:flutter/foundation.dart';

// 2. SEPET KONTROLCÜSÜ
class SepetKontrolu {
  static final SepetKontrolu ornek = SepetKontrolu._dahili();

  SepetKontrolu._dahili();

  final ValueNotifier<int> _urunSayisi = ValueNotifier<int>(0);

  ValueNotifier<int> get urunSayisi => _urunSayisi;

  void sepeteEkle() {
    _urunSayisi.value++;
  }

  void sepetiSifirla() {
    _urunSayisi.value = 0;
  }
}

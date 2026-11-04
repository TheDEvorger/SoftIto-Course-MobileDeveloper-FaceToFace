// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Uygulamanın lüks otomotiv ve hassas mobilite tasarım dili için renk paleti.
/// Siyah-beyaz monokrom ağırlıklı olup dengeli metalik ve zeytin aksanlar içerir.
// palette sabitlerini tutan sınıf, nesne oluşturulamaz
abstract final class Palette {
  /// Koyu arka plan ve derin kontrast rengi
  // carbon black değerini tanımlar
  static const carbonBlack = Color(0xFF101216);
  /// Koyu tema yüzey ve kart rengi
  // smoked graphite değerini tanımlar
  static const smokedGraphite = Color(0xFF2A2C2F);
  /// Açık tema genel arka plan rengi
  // arctic white değerini tanımlar
  static const arcticWhite = Color(0xFFF4F6F8);
  /// Açık tema ikincil yüzey ve ayrım rengi
  // titanium white değerini tanımlar
  static const titaniumWhite = Color(0xFFE8ECF0);
  /// Ana tohum rengi ve ikon aksanı
  // precision blue grey değerini tanımlar
  static const precisionBlueGrey = Color(0xFF6B7C86);
  /// Koyu temada birincil buton ve vurgu rengi
  // cold platinum değerini tanımlar
  static const coldPlatinum = Color(0xFFA9B0B6);
  /// Özel vurgu ve metalik şampanya tonu
  // champagne metal değerini tanımlar
  static const champagneMetal = Color(0xFFB79B6C);
  /// Açık tema ikincil metin ve kontrast rengi
  // deep noble olive değerini tanımlar
  static const deepNobleOlive = Color(0xFF505A46);
}

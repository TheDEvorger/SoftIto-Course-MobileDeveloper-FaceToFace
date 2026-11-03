// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// AppColors sabitlerini tutar, nesne oluşturulamaz
abstract final class AppColors {
  // light ana renk değerini tanımlar
  static const Color lightPrimary = Color(0xFF087F8C);
  // light ana renk dark değerini tanımlar
  static const Color lightPrimaryDark = Color(0xFF143348);
  // light background değerini tanımlar
  static const Color lightBackground = Color(0xFFF5F8FA);
  // light yüzey rengi değerini tanımlar
  static const Color lightSurface = Color(0xFFFFFFFF);
  // light ikincil renk metin değerini tanımlar
  static const Color lightSecondaryText = Color(0xFF627584);
  // light amber değerini tanımlar
  static const Color lightAmber = Color(0xFFE7A84B);
  // light coral değerini tanımlar
  static const Color lightCoral = Color(0xFFD96572);
  // light başarı değerini tanımlar
  static const Color lightSuccess = Color(0xFF27836A);
  // light dış çizgi rengi değerini tanımlar
  static const Color lightOutline = Color(0xFFDCE5EA);
  // dark ana renk değerini tanımlar
  static const Color darkPrimary = Color(0xFF5DD3D5);
  // dark ana renk dark değerini tanımlar
  static const Color darkPrimaryDark = Color(0xFFDDEDF0);
  // dark background değerini tanımlar
  static const Color darkBackground = Color(0xFF0E1921);
  // dark yüzey rengi değerini tanımlar
  static const Color darkSurface = Color(0xFF172833);
  // dark ikincil renk metin değerini tanımlar
  static const Color darkSecondaryText = Color(0xFFACBFCA);
  // dark amber değerini tanımlar
  static const Color darkAmber = Color(0xFFF1BC6F);
  // dark coral değerini tanımlar
  static const Color darkCoral = Color(0xFFFF8996);
  // dark başarı değerini tanımlar
  static const Color darkSuccess = Color(0xFF64D6AC);
  // dark dış çizgi rengi değerini tanımlar
  static const Color darkOutline = Color(0xFF26404F);
  // hero start light değerini tanımlar
  static const Color heroStartLight = Color(0xFF087F8C);
  // hero end light değerini tanımlar
  static const Color heroEndLight = Color(0xFF143348);
  // hero start dark değerini tanımlar
  static const Color heroStartDark = Color(0xFF0C5560);
  // hero end dark değerini tanımlar
  static const Color heroEndDark = Color(0xFF112A3A);
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
/// Uygulama genelinde tutarlı boşluk (spacing) ve boyutlandırma sabitleri.
// precision space sabitlerini tutan sınıf, nesne oluşturulamaz
abstract final class PrecisionSpace {
  /// Ekstra küçük boşluk: 4.0 dp
  // xs değerini tanımlar
  static const xs = 4.0;
  /// Küçük boşluk: 8.0 dp
  // sm değerini tanımlar
  static const sm = 8.0;
  /// Orta boşluk: 12.0 dp
  // md değerini tanımlar
  static const md = 12.0;
  /// Büyük boşluk: 16.0 dp
  // lg değerini tanımlar
  static const lg = 16.0;
  /// Ekstra büyük boşluk: 24.0 dp
  // xl değerini tanımlar
  static const xl = 24.0;
  /// 2X büyük boşluk: 32.0 dp
  // xxl değerini tanımlar
  static const xxl = 32.0;
  /// Butonlar ve giriş alanları için standart kontrol yüksekliği: 48.0 dp
  // control yükseklik değerini tanımlar
  static const controlHeight = 48.0;
}
/// Tipografi hiyerarşisi ve stil yapılandırması.
// precision typography sabitlerini tutan sınıf, nesne oluşturulamaz
abstract final class PrecisionTypography {
  /// Taban metin temasına özel ağırlık ve satır yüksekliği kurallarını uygular.
  // apply değerini tanımlar
  static TextTheme apply(TextTheme base) => base.copyWith(
        // headline medium bilgisini belirler
        headlineMedium: base.headlineMedium?.copyWith(
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.w700,
          // Yüksekliği belirler
          height: 1.2,
        ),
        // başlık large bilgisini belirler
        titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        // gövde large bilgisini belirler
        bodyLarge: base.bodyLarge?.copyWith(height: 1.5),
        // gövde medium bilgisini belirler
        bodyMedium: base.bodyMedium?.copyWith(height: 1.5),
        // etiket large bilgisini belirler
        labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      );
}

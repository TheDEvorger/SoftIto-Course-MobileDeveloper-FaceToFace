// Flutter renk kütüphanesini ekler
import 'package:flutter/material.dart';

// Koyu ve açık tema renklerini tanımlayan sınıf
abstract final class AppColors {
  // Koyu temanın ana arka plan rengi
  static const Color obsidian = Color(0xFF0B0D12);
  // Koyu temanın kart yüzey rengi
  static const Color obsidianSurface = Color(0xFF151922);
  // Koyu temanın mavi vurgu rengi
  static const Color neonCyan = Color(0xFF00E5FF);
  // Koyu temanın yeşil vurgu rengi
  static const Color neonLime = Color(0xFFB6FF3B);
  // Koyu temanın yazı rengi
  static const Color darkOnSurface = Color(0xFFE6EAF2);
  // Açık temanın ana arka plan rengi
  static const Color frost = Color(0xFFF5F8FC);
  // Açık temanın kart yüzey rengi
  static const Color frostSurface = Color(0xFFFFFFFF);
  // Açık temanın ana vurgu rengi
  static const Color deepWater = Color(0xFF006C80);
  // Açık temanın yeşil vurgu rengi
  static const Color freshLime = Color(0xFF4C7A00);
  // Açık temanın yazı rengi
  static const Color lightOnSurface = Color(0xFF12161F);
  // İki temada da kullanılan hata rengi
  static const Color error = Color(0xFFFF4D6D);
}

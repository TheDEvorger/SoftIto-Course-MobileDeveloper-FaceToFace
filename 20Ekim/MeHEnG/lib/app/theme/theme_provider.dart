// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Theme mode verisini sağlayan provider oluşturur
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  // Tema notifierını gerektiğinde oluşturur
  ThemeModeNotifier.new,
);
// Theme mode durumunu yöneten notifier
class ThemeModeNotifier extends Notifier<ThemeMode> {
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  ThemeMode build() => ThemeMode.system;
  // Set theme mode metodunu tanımlar
  void setThemeMode(ThemeMode mode) => state = mode;
  // Toggle metodunu tanımlar
  void toggle(bool isDark) => state = isDark ? ThemeMode.light : ThemeMode.dark;
}

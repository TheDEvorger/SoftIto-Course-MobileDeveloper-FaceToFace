// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum PomodoroMode {
  // İlgili değeri veya görünüm ayarını belirler
  focus,
  // İlgili değeri veya görünüm ayarını belirler
  shortBreak,
  // İlgili değeri veya görünüm ayarını belirler
  longBreak,
}
// Var olan tipe yeni getter ve metotlar ekler
extension PomodoroModeX on PomodoroMode {
  // etiket işlemini yapar
  String get label {
    // Değere göre uygun durumu seçer
    switch (this) {
      // pomodoro mode.focus durumu için çalışır
      case PomodoroMode.focus:
        // "Odaklanma" metnini kullanır
        return 'Odaklanma';
      // pomodoro mode.short break durumu için çalışır
      case PomodoroMode.shortBreak:
        // "Kısa Mola" metnini kullanır
        return 'Kısa Mola';
      // pomodoro mode.long break durumu için çalışır
      case PomodoroMode.longBreak:
        // "Uzun Mola" metnini kullanır
        return 'Uzun Mola';
    }
  }
  // default seconds işlemini yapar
  int get defaultSeconds {
    // Değere göre uygun durumu seçer
    switch (this) {
      // pomodoro mode.focus durumu için çalışır
      case PomodoroMode.focus:
        // Hesaplanan sonucu döndürür
        return 25 * 60;
      // pomodoro mode.short break durumu için çalışır
      case PomodoroMode.shortBreak:
        // Hesaplanan sonucu döndürür
        return 5 * 60;
      // pomodoro mode.long break durumu için çalışır
      case PomodoroMode.longBreak:
        // Hesaplanan sonucu döndürür
        return 15 * 60;
    }
  }
  // simge işlemini yapar
  IconData get icon {
    // Değere göre uygun durumu seçer
    switch (this) {
      // pomodoro mode.focus durumu için çalışır
      case PomodoroMode.focus:
        // Gösterilecek simgeyi belirler
        return Icons.self_improvement;
      // pomodoro mode.short break durumu için çalışır
      case PomodoroMode.shortBreak:
        // Gösterilecek simgeyi belirler
        return Icons.coffee_outlined;
      // pomodoro mode.long break durumu için çalışır
      case PomodoroMode.longBreak:
        // Gösterilecek simgeyi belirler
        return Icons.nature_people_outlined;
    }
  }
  // accent renk işlemini yapar
  Color get accentColor {
    // Değere göre uygun durumu seçer
    switch (this) {
      // pomodoro mode.focus durumu için çalışır
      case PomodoroMode.focus:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.mossEmerald;
      // pomodoro mode.short break durumu için çalışır
      case PomodoroMode.shortBreak:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.streamTurquoise;
      // pomodoro mode.long break durumu için çalışır
      case PomodoroMode.longBreak:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.peachCoral;
    }
  }
}

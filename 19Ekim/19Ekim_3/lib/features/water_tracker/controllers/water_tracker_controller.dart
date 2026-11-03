// ValueNotifier kullanmak için foundation ekler
import 'package:flutter/foundation.dart';

// Su miktarını yöneten controller sınıfı
class WaterTrackerController {
  // İçilen su miktarını tutar ve değişiklikleri bildirir
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  // Günlük su hedefini 2000 ml olarak belirler
  final int dailyGoalWater = 2000; // 2 litre
  // Su ekleme metodu
  void addWater() {
    // Mevcut su miktarına 250 ml ekler
    currentWater.value += 250;
  }

  // Günlük su miktarını sıfırlayan metot
  void resetWater() {
    // Su miktarını sıfır yapar
    currentWater.value = 0;
  }

  // Controllerın kullandığı kaynakları temizler
  void dispose() {
    // ValueNotifierı temizler
    currentWater.dispose();
  }
}

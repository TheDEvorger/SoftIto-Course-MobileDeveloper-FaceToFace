// ValueNotifier kullanmak için Flutter foundation ekler
import 'package:flutter/foundation.dart';
// Su kayıt modelini ekler
import '../models/water_intake.dart';

// Su miktarını ve kayıtları yöneten controller sınıfı
class WaterTrackerController {
  // Constructor isteğe bağlı saat fonksiyonu alır
  WaterTrackerController({DateTime Function()? clock})
      // Saat fonksiyonu verilmezse DateTime.now kullanır
      : _clock = clock ?? DateTime.now;
  // Günlük su hedefini 2500 ml olarak belirler
  static const int dailyGoalMl = 2500;
  // Bir bardak su miktarını 250 ml olarak belirler
  static const int defaultServingMl = 250;
  // Geçerli tarih ve saati veren fonksiyonu tutar
  final DateTime Function() _clock;
  // Güncel su miktarını tutar ve değişiklikleri bildirir
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  // Su kayıt listesini tutan ValueNotifier
  final ValueNotifier<List<WaterIntake>> intakes =
      // Başlangıçta boş kayıt listesi oluşturur
      ValueNotifier<List<WaterIntake>>([]);
  // Su ekler, miktar verilmezse 250 ml kullanır
  void addWater([int amountMl = defaultServingMl]) {
    // Miktar sıfır veya negatifse hata verir
    if (amountMl <= 0) {
      // Geçersiz miktar için ArgumentError oluşturur
      throw ArgumentError.value(amountMl, 'amountMl', 'Must be positive.');
    }
    // İçilen suyu mevcut miktara ekler ve dinleyenlere bildirir
    currentWater.value += amountMl;
    // Su kayıt listesini yeni listeyle günceller
    intakes.value = [
      // Yeni su kaydını tarih bilgisiyle oluşturur
      WaterIntake(amountMl: amountMl, recordedAt: _clock()),
      // Önceki kayıtların hepsini yeni listenin sonuna ekler
      ...intakes.value,
    ];
  }

  // Günlük su miktarını ve kayıtları sıfırlar
  void resetDay() {
    // İçilen toplam suyu sıfırlar
    currentWater.value = 0;
    // Kayıt listesini boşaltır
    intakes.value = [];
  }

  // Controllerın kullandığı kaynakları temizler
  void dispose() {
    // Su miktarı notifierını temizler
    currentWater.dispose();
    // Su kayıtları notifierını temizler
    intakes.dispose();
  }
}

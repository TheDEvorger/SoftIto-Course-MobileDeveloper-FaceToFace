// Immutable yapısı için Flutter foundation ekler
import 'package:flutter/foundation.dart';

// Sınıftaki verilerin değiştirilememesi gerektiğini belirtir
@immutable
// Su tüketim bilgilerini tutan model sınıfı
class WaterTrackerModel {
  // Constructor, varsayılan su miktarı ve hedefi alır
  const WaterTrackerModel({
    // Miktar verilmezse sıfır kullanır
    this.currentWater = 0,
    // Hedef verilmezse 2000 ml kullanır
    this.dailyGoal = 2000,
  });
  // JSON verisinden model nesnesi oluşturur
  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    // Gelen bilgilerle yeni nesne döndürür
    return WaterTrackerModel(
      // JSONdaki su miktarını alır, yoksa sıfır kullanır
      currentWater: json['currentWater'] as int? ?? 0,
      // JSONdaki hedefi alır, yoksa 2000 kullanır
      dailyGoal: json['dailyGoal'] as int? ?? 2000,
    );
  }
  // İçilen su miktarını tutar
  final int currentWater;
  // Günlük su hedefini tutar
  final int dailyGoal;
  // Mevcut nesneyi değiştirmeden yeni kopyasını oluşturur
  WaterTrackerModel copyWith({
    // Yeni su miktarı isteğe bağlıdır
    int? currentWater,
    // Yeni günlük hedef isteğe bağlıdır
    int? dailyGoal,
  }) {
    // Güncellenmiş bilgilerle yeni nesne oluşturur
    return WaterTrackerModel(
      // Yeni miktar varsa onu, yoksa eskisini kullanır
      currentWater: currentWater ?? this.currentWater,
      // Yeni hedef varsa onu, yoksa eskisini kullanır
      dailyGoal: dailyGoal ?? this.dailyGoal,
    );
  }

  // Modeli JSONa uygun Map yapısına dönüştürür
  Map<String, dynamic> toJson() => <String, dynamic>{
    // İçilen su miktarını kaydeder
    'currentWater': currentWater,
    // Günlük su hedefini kaydeder
    'dailyGoal': dailyGoal,
  };
  // Üstteki eşitlik operatörünü yeniden tanımlar
  @override
  // İki modelin içindeki değerleri karşılaştırır
  bool operator ==(Object other) =>
      // Diğer nesnenin WaterTrackerModel olup olmadığını kontrol eder
      other is WaterTrackerModel &&
      // Su miktarlarının eşitliğini kontrol eder
      other.currentWater == currentWater &&
      // Günlük hedeflerin eşitliğini kontrol eder
      other.dailyGoal == dailyGoal;
  // Üstteki hashCode getterını yeniden tanımlar
  @override
  // Su miktarı ve hedeften hash kodu oluşturur
  int get hashCode => Object.hash(currentWater, dailyGoal);
}

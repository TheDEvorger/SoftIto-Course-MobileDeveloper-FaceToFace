// Flutter durum dinleme ve temel tipleri ekler
import 'package:flutter/foundation.dart';
// Nesnenin değişmez olması gerektiğini belirtir
@immutable
// DemoPatient bilgilerini tutan model sınıfı
class DemoPatient {
  // Constructor, yeni nesnenin bilgilerini alır
  const DemoPatient({
    // ID bilgisini zorunlu tutar
    required this.id,
    // görünen ad bilgisini zorunlu tutar
    required this.displayName,
    // kod bilgisini zorunlu tutar
    required this.code,
    // birim bilgisini zorunlu tutar
    required this.department,
  });
  // ID bilgisini tutar
  final String id;
  // görünen ad bilgisini tutar
  final String displayName;
  // kod bilgisini tutar
  final String code;
  // birim bilgisini tutar
  final String department;
  // initials bilgisini döndürür
  String get initials {
    // parts değerini tanımlar
    final List<String> parts = displayName
        // Metnin başındaki ve sonundaki boşlukları kaldırır
        .trim()
        // RegExp nesnesini oluşturur veya kullanır
        .split(RegExp(r'\s+'))
        // Koşula uyan elemanları filtreler
        .where((String p) => p.isNotEmpty)
        // Sonucu listeye çevirir
        .toList();
    // İlgili alan veya liste boşsa kontrol eder
    if (parts.isEmpty) return '?';
    // Koşul sağlanırsa ilgili işlemi yapar
    if (parts.length == 1) return parts.first[0].toUpperCase();
    // Hesaplanan sonucu döndürür
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

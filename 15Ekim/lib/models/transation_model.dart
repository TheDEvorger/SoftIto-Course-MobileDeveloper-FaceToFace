// Flutter simgelerini kullanmak için
import 'package:flutter/material.dart';

// Para işlemlerinin bilgilerini tutan model sınıfı
class TransactionItem {
  // İşlemin benzersiz ID bilgisini tutar
  final String id;
  // İşlemin başlığını tutar
  final String title;
  // İşlemin kategorisini tutar
  final String category;
  // İşlemin tarih bilgisini tutar
  final String date;
  // İşlem tutarını double olarak tutar
  final double amount;
  // Gelir mi gider mi olduğunu bool olarak tutar
  final bool isExpense;
  // İşleme ait simgeyi tutar
  final IconData icon;
  // Constructor, işlem bilgilerini alarak nesne oluşturur
  const TransactionItem({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Başlık bilgisini zorunlu tutar
    required this.title,
    // Kategori bilgisini zorunlu tutar
    required this.category,
    // Tarih bilgisini zorunlu tutar
    required this.date,
    // İşlem tutarını zorunlu tutar
    required this.amount,
    // Gelir gider bilgisini zorunlu tutar
    required this.isExpense,
    // Simge bilgisini zorunlu tutar
    required this.icon,
  });
}

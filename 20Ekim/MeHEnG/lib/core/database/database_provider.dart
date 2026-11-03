// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Veritabanı bağlantı sınıfını ekler
import 'app_database.dart';
// Database verisini sağlayan provider oluşturur
final databaseProvider = Provider<AppDatabase>((ref) {
  // Geçersiz bilgi için hata fırlatır
  throw StateError('AppDatabase must be injected by ProviderScope.');
});

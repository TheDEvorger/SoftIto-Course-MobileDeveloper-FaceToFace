// Dosya ve işletim sistemi işlemlerini ekler
import 'dart:io';
// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama klasörünü bulmak için kütüphane ekler
import 'package:path_provider/path_provider.dart';
// Ana uygulama widgetını ekler
import 'app/meheng_app.dart';
// Veritabanı bağlantı sınıfını ekler
import 'core/database/app_database.dart';
// Veritabanı providerını ekler
import 'core/database/database_provider.dart';
// Uygulamayı başlatır
Future<void> main() async {
  // Flutter bağlantısını hazırlar
  WidgetsFlutterBinding.ensureInitialized();
  // Uygulamanın veri klasörünü bulur
  final directory = await getApplicationSupportDirectory();
  // SQLite dosyasının yolunu oluşturur
  final file = '${directory.path}${Platform.pathSeparator}meheng.sqlite';
  // Veritabanı bağlantısını oluşturur
  final database = AppDatabase.open(file);
  // Flutter uygulamasını çalıştırır
  runApp(
    // Riverpod providerlarını uygulamaya bağlar
    ProviderScope(
      // Veritabanı providerına oluşturulan bağlantıyı verir
      overrides: [databaseProvider.overrideWithValue(database)],
      // MeHEnG ana uygulamasını başlatır
      child: const MehengApp(),
    ),
  );
}

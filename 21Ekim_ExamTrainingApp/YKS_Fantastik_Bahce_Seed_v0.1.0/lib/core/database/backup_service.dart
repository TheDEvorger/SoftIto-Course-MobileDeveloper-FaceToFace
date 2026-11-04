// JSON dönüştürme araçlarını ekler
import 'dart:convert';
// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import 'schema.dart';
// backup servis bilgilerini veya işlemlerini tutan sınıf
class BackupService {
  // backup servis nesnesini oluşturur
  BackupService(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  /// Tüm kullanıcı verilerini kayıpsız JSON olarak dışa aktarır.
  // all data as json bilgisini dışa aktarır
  Future<String> exportAllDataAsJson() async {
    // tercihler verisini asenkron işlemin sonucundan alır
    final prefs = await db.query(GardenDatabaseSchema.tablePreferences);
    // exams verisini asenkron işlemin sonucundan alır
    final exams = await db.query(GardenDatabaseSchema.tableExamSessions);
    // scores verisini asenkron işlemin sonucundan alır
    final scores = await db.query(GardenDatabaseSchema.tableExamScores);
    // ilerleme verisini asenkron işlemin sonucundan alır
    final progress = await db.query(GardenDatabaseSchema.tableTopicProgress);
    // görevler verisini asenkron işlemin sonucundan alır
    final tasks = await db.query(GardenDatabaseSchema.tableDailyTasks);
    // odaklanma verisini asenkron işlemin sonucundan alır
    final focus = await db.query(GardenDatabaseSchema.tableFocusSessions);
    // export data bilgisini hesaplayıp saklar
    final exportData = {
      // "metadata': {" metnini kullanır
      'metadata': {
        // "app': 'Fantastik Bahçe YKS" metnini kullanır
        'app': 'Fantastik Bahçe YKS',
        // "version': GardenDatabaseSchema.currentVersion" metnini kullanır
        'version': GardenDatabaseSchema.currentVersion,
        // Güncel tarih ve saati alır
        'exportedAt': DateTime.now().toIso8601String(),
      },
      // "preferences': prefs" metnini kullanır
      'preferences': prefs,
      // "exam_sessions': exams" metnini kullanır
      'exam_sessions': exams,
      // "exam_scores': scores" metnini kullanır
      'exam_scores': scores,
      // "topic_progress': progress" metnini kullanır
      'topic_progress': progress,
      // "daily_tasks': tasks" metnini kullanır
      'daily_tasks': tasks,
      // "focus_sessions': focus" metnini kullanır
      'focus_sessions': focus,
    };
    // json encoder.with indent nesnesini oluşturur
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }
  /// Kullanıcının tüm verilerini yerel veritabanından kalıcı olarak siler.
  // all user data bilgisini temizler
  Future<void> clearAllUserData() async {
    // Veritabanı işlemlerini birlikte çalıştırır
    await db.transaction((txn) async {
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tableExamScores);
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tableExamSessions);
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tableTopicProgress);
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tableDailyTasks);
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tableFocusSessions);
      // Tercihleri varsayılan boş duruma getir
      // Veritabanından kayıt siler
      await txn.delete(GardenDatabaseSchema.tablePreferences);
      // Veritabanına kayıt ekler
      await txn.insert(
        // tercihler tablosu adını kullanır
        GardenDatabaseSchema.tablePreferences,
        {
          // "id': 'current" metnini kullanır
          'id': 'current',
          // "display_name': null" metnini kullanır
          'display_name': null,
          // "field': 'Sayısal" metnini kullanır
          'field': 'Sayısal',
          // "target_date': null" metnini kullanır
          'target_date': null,
          // "target_net': null" metnini kullanır
          'target_net': null,
          // "theme_mode': 'system" metnini kullanır
          'theme_mode': 'system',
          // "humorous_exit_enabled': 0" metnini kullanır
          'humorous_exit_enabled': 0,
        },
        // Aynı kayıt varsa ne yapılacağını belirler
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}

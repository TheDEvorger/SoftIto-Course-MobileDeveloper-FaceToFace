// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import '../../core/database/schema.dart';
// daily görev dosyasını kullanıma ekler
import '../models/daily_task.dart';
// daily plan summary bilgilerini veya işlemlerini tutan sınıf
class DailyPlanSummary {
  // daily plan summary nesnesini oluşturur
  const DailyPlanSummary({
    // toplam tasks bilgisini zorunlu tutar
    required this.totalTasks,
    // completed tasks bilgisini zorunlu tutar
    required this.completedTasks,
    // hedef soru sayısı bilgisini zorunlu tutar
    required this.targetQuestions,
    // tamamlanan soru sayısı bilgisini zorunlu tutar
    required this.completedQuestions,
  });
  // toplam tasks bilgisini tutar
  final int totalTasks;
  // completed tasks bilgisini tutar
  final int completedTasks;
  // hedef soru sayısı bilgisini tutar
  final int targetQuestions;
  // tamamlanan soru sayısı bilgisini tutar
  final int completedQuestions;
  // görev ilerleme işlemini yapar
  double get taskProgress =>
      // Değeri belirtilen aralıkta sınırlar
      totalTasks > 0 ? (completedTasks / totalTasks).clamp(0.0, 1.0) : 0.0;
  // soru ilerleme işlemini yapar
  double get questionProgress => targetQuestions > 0
      // Koşul doğruysa bu değeri kullanır
      ? (completedQuestions / targetQuestions).clamp(0.0, 1.0)
      // Koşul yanlışsa bu değeri kullanır
      : 0.0;
}
// planning repository bilgilerini veya işlemlerini tutan sınıf
class PlanningRepository {
  // planning repository nesnesini oluşturur
  PlanningRepository(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  // tarih bilgisini biçimlendirir
  String _formatDate(DateTime date) {
    // "${date.year.toString().padLeft(4, '0')}-${d…" metnini kullanır
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  // tasks for tarih bilgisini getirir
  Future<List<DailyTask>> getTasksForDate(DateTime date) async {
    // tarih string bilgisini hesaplayıp saklar
    final dateString = _formatDate(date);
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // günlük görevler tablosu adını kullanır
      GardenDatabaseSchema.tableDailyTasks,
      // Sorgunun filtre koşulunu belirler
      where: 'scheduled_date = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [dateString],
      // Kayıtların sıralanma şeklini belirler
      orderBy: 'is_done ASC, id ASC',
    );
    // Öğeleri tek tek dönüştürür
    return maps.map(DailyTask.fromMap).toList();
  }
  // summary for tarih bilgisini getirir
  Future<DailyPlanSummary> getSummaryForDate(DateTime date) async {
    // görevler verisini asenkron işlemin sonucundan alır
    final tasks = await getTasksForDate(date);
    // completed tasks için başlangıç sayısını belirler
    int completedTasks = 0;
    // hedef soru sayısı için başlangıç sayısını belirler
    int targetQuestions = 0;
    // tamamlanan soru sayısı için başlangıç sayısını belirler
    int completedQuestions = 0;
    // Listedeki öğeleri tek tek dolaşır
    for (final t in tasks) {
      // hedef soru sayısı değerine yeni miktarı ekler
      targetQuestions += t.targetQuestions;
      // Belirtilen koşul doğruysa işlemi yapar
      if (t.isDone) {
        // completed tasks değerini 1 artırır
        completedTasks++;
        // tamamlanan soru sayısı değerine yeni miktarı ekler
        completedQuestions += t.targetQuestions;
      }
    }
    // daily plan summary nesnesini oluşturur
    return DailyPlanSummary(
      // toplam tasks bilgisini belirler
      totalTasks: tasks.length,
      // completed tasks bilgisini belirler
      completedTasks: completedTasks,
      // Hedef soru sayısını belirler
      targetQuestions: targetQuestions,
      // tamamlanan soru sayısı bilgisini belirler
      completedQuestions: completedQuestions,
    );
  }
  // görev bilgisini kaydeder
  Future<void> saveTask(DailyTask task) async {
    // Veritabanına kayıt ekler
    await db.insert(
      // günlük görevler tablosu adını kullanır
      GardenDatabaseSchema.tableDailyTasks,
      // Nesnenin verilerini Map yapısına dönüştürür
      task.toMap(),
      // Aynı kayıt varsa ne yapılacağını belirler
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // görev done bilgisini değiştirir
  Future<void> toggleTaskDone(String taskId, bool isDone) async {
    // Veritabanı kaydını günceller
    await db.update(
      // günlük görevler tablosu adını kullanır
      GardenDatabaseSchema.tableDailyTasks,
      // Yeni değer veya liste oluşturur
      {'is_done': isDone ? 1 : 0},
      // Sorgunun filtre koşulunu belirler
      where: 'id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [taskId],
    );
  }
  // görev bilgisini siler
  Future<void> deleteTask(String taskId) async {
    // Veritabanından kayıt siler
    await db.delete(
      // günlük görevler tablosu adını kullanır
      GardenDatabaseSchema.tableDailyTasks,
      // Sorgunun filtre koşulunu belirler
      where: 'id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [taskId],
    );
  }
}

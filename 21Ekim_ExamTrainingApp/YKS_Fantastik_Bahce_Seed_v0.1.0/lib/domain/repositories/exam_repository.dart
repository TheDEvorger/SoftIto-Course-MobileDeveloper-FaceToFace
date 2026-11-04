// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import '../../core/database/schema.dart';
// deneme record dosyasını kullanıma ekler
import '../models/exam_record.dart';
// deneme repository bilgilerini veya işlemlerini tutan sınıf
class ExamRepository {
  // deneme repository nesnesini oluşturur
  ExamRepository(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  // deneme bilgisini kaydeder
  Future<void> saveExam(ExamSession session) async {
    // Veritabanı işlemlerini birlikte çalıştırır
    await db.transaction((txn) async {
      // Veritabanına kayıt ekler
      await txn.insert(
        // deneme oturumları tablosu adını kullanır
        GardenDatabaseSchema.tableExamSessions,
        // Nesnenin verilerini Map yapısına dönüştürür
        session.toMap(),
        // Aynı kayıt varsa ne yapılacağını belirler
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // Eski skorları temizle (güncelleme durumunda)
      // Veritabanından kayıt siler
      await txn.delete(
        // deneme puanları tablosu adını kullanır
        GardenDatabaseSchema.tableExamScores,
        // Sorgunun filtre koşulunu belirler
        where: 'exam_id = ?',
        // Sorguya filtre değerlerini güvenli biçimde gönderir
        whereArgs: [session.id],
      );
      // Listedeki öğeleri tek tek dolaşır
      for (final score in session.scores) {
        // Veritabanına kayıt ekler
        await txn.insert(
          // deneme puanları tablosu adını kullanır
          GardenDatabaseSchema.tableExamScores,
          // Nesnenin verilerini Map yapısına dönüştürür
          score.toMap(),
          // Aynı kayıt varsa ne yapılacağını belirler
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
  // exams bilgisini getirir
  Future<List<ExamSession>> getExams({String? stage}) async {
    // session maps verisini asenkron işlemin sonucundan alır
    final sessionMaps = await db.query(
      // deneme oturumları tablosu adını kullanır
      GardenDatabaseSchema.tableExamSessions,
      // Sorgunun filtre koşulunu belirler
      where: stage != null ? 'stage = ?' : null,
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: stage != null ? [stage] : null,
      // Kayıtların sıralanma şeklini belirler
      orderBy: 'occurred_at DESC',
    );
    // sonuçlar için boş koleksiyon oluşturur
    final results = <ExamSession>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final sMap in sessionMaps) {
      // deneme ID bilgisini hesaplayıp saklar
      final examId = sMap['id'] as String;
      // score maps verisini asenkron işlemin sonucundan alır
      final scoreMaps = await db.query(
        // deneme puanları tablosu adını kullanır
        GardenDatabaseSchema.tableExamScores,
        // Sorgunun filtre koşulunu belirler
        where: 'exam_id = ?',
        // Sorguya filtre değerlerini güvenli biçimde gönderir
        whereArgs: [examId],
      );
      // scores için listedeki öğeleri dönüştürür
      final scores = scoreMaps.map(ExamScore.fromMap).toList();
      // Map verisinden model nesnesi oluşturur
      results.add(ExamSession.fromMap(sMap, scores: scores));
    }
    // Hesaplanan sonucu döndürür
    return results;
  }
  // deneme by id bilgisini getirir
  Future<ExamSession?> getExamById(String id) async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // deneme oturumları tablosu adını kullanır
      GardenDatabaseSchema.tableExamSessions,
      // Sorgunun filtre koşulunu belirler
      where: 'id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [id],
      // Getirilecek kayıt sayısını sınırlar
      limit: 1,
    );
    // Liste veya metin boşsa bu koşul çalışır
    if (maps.isEmpty) return null;
    // score maps verisini asenkron işlemin sonucundan alır
    final scoreMaps = await db.query(
      // deneme puanları tablosu adını kullanır
      GardenDatabaseSchema.tableExamScores,
      // Sorgunun filtre koşulunu belirler
      where: 'exam_id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [id],
    );
    // scores için listedeki öğeleri dönüştürür
    final scores = scoreMaps.map(ExamScore.fromMap).toList();
    // deneme session.from map nesnesini oluşturur
    return ExamSession.fromMap(maps.first, scores: scores);
  }
  // deneme bilgisini siler
  Future<void> deleteExam(String id) async {
    // Veritabanı işlemlerini birlikte çalıştırır
    await db.transaction((txn) async {
      // Veritabanından kayıt siler
      await txn.delete(
        // deneme puanları tablosu adını kullanır
        GardenDatabaseSchema.tableExamScores,
        // Sorgunun filtre koşulunu belirler
        where: 'exam_id = ?',
        // Sorguya filtre değerlerini güvenli biçimde gönderir
        whereArgs: [id],
      );
      // Veritabanından kayıt siler
      await txn.delete(
        // deneme oturumları tablosu adını kullanır
        GardenDatabaseSchema.tableExamSessions,
        // Sorgunun filtre koşulunu belirler
        where: 'id = ?',
        // Sorguya filtre değerlerini güvenli biçimde gönderir
        whereArgs: [id],
      );
    });
  }
  // deneme sayı bilgisini getirir
  Future<int> getExamCount({String? stage}) async {
    // sayı bilgisini hesaplayıp saklar
    final count = Sqflite.firstIntValue(
      // SQL sorgusunu çalıştırır
      await db.rawQuery(
        // "SELECT COUNT(*) FROM ${GardenDatabaseSchema…" metnini kullanır
        'SELECT COUNT(*) FROM ${GardenDatabaseSchema.tableExamSessions} ${stage != null ? "WHERE stage = ?" : ""}',
        // Koşula göre iki değerden birini seçer
        stage != null ? [stage] : null,
      ),
    );
    // Değer null ise varsayılanı kullanır
    return count ?? 0;
  }
}

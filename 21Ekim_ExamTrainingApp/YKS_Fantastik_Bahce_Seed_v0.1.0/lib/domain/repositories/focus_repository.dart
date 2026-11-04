// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import '../../core/database/schema.dart';
// focus record dosyasını kullanıma ekler
import '../models/focus_record.dart';
// focus repository bilgilerini veya işlemlerini tutan sınıf
class FocusRepository {
  // focus repository nesnesini oluşturur
  FocusRepository(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  // focus session bilgisini kaydeder
  Future<void> saveFocusSession(FocusSession session) async {
    // Veritabanına kayıt ekler
    await db.insert(
      // odaklanma kayıtları tablosu adını kullanır
      GardenDatabaseSchema.tableFocusSessions,
      // Nesnenin verilerini Map yapısına dönüştürür
      session.toMap(),
      // Aynı kayıt varsa ne yapılacağını belirler
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // all sessions bilgisini getirir
  Future<List<FocusSession>> getAllSessions() async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // odaklanma kayıtları tablosu adını kullanır
      GardenDatabaseSchema.tableFocusSessions,
      // Kayıtların sıralanma şeklini belirler
      orderBy: 'started_at DESC',
    );
    // Öğeleri tek tek dönüştürür
    return maps.map(FocusSession.fromMap).toList();
  }
  // toplam elapsed seconds bilgisini getirir
  Future<int> getTotalElapsedSeconds() async {
    // sonuç verisini asenkron işlemin sonucundan alır
    final result = await db.rawQuery(
      // "SELECT SUM(elapsed_seconds) as total FROM $…" metnini kullanır
      'SELECT SUM(elapsed_seconds) as total FROM ${GardenDatabaseSchema.tableFocusSessions}',
    );
    // Liste veya metin doluysa bu koşul çalışır
    if (result.isNotEmpty && result.first['total'] != null) {
      // Sayıyı int tipine çevirir
      return (result.first['total'] as num).toInt();
    }
    // Hesaplanan sonucu döndürür
    return 0;
  }
}

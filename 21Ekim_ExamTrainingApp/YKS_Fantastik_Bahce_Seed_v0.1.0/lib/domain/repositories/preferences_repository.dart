// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import '../../core/database/schema.dart';
// student preferences dosyasını kullanıma ekler
import '../models/student_preferences.dart';
// preferences repository bilgilerini veya işlemlerini tutan sınıf
class PreferencesRepository {
  // preferences repository nesnesini oluşturur
  PreferencesRepository(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  // preferences bilgisini getirir
  Future<StudentPreferences> getPreferences() async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // tercihler tablosu adını kullanır
      GardenDatabaseSchema.tablePreferences,
      // Sorgunun filtre koşulunu belirler
      where: 'id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: ['current'],
      // Getirilecek kayıt sayısını sınırlar
      limit: 1,
    );
    // Liste veya metin doluysa bu koşul çalışır
    if (maps.isNotEmpty) {
      // student preferences.from map nesnesini oluşturur
      return StudentPreferences.fromMap(maps.first);
    }
    // default prefs bilgisini hesaplayıp saklar
    const defaultPrefs = StudentPreferences(id: 'current');
    // preferences bilgisini kaydeder
    await savePreferences(defaultPrefs);
    // Hesaplanan sonucu döndürür
    return defaultPrefs;
  }
  // preferences bilgisini kaydeder
  Future<void> savePreferences(StudentPreferences preferences) async {
    // Veritabanına kayıt ekler
    await db.insert(
      // tercihler tablosu adını kullanır
      GardenDatabaseSchema.tablePreferences,
      // Nesnenin verilerini Map yapısına dönüştürür
      preferences.toMap(),
      // Aynı kayıt varsa ne yapılacağını belirler
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

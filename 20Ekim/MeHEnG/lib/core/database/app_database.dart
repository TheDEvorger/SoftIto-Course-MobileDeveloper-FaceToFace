// SQLite veritabanı kütüphanesini ekler
import 'package:sqlite3/sqlite3.dart';
// İkinci veritabanı şemasını ekler
import 'schema_v2.dart';
// Üçüncü veritabanı şemasını ekler
import 'schema_v3.dart';
// SQLite veritabanı bağlantı sınıfı
class AppDatabase {
  // Dışarıdan çağrılamayan private constructor
  AppDatabase._(this.db);
  // Db bilgisini tutar
  final Database db;
  // Veritabanı nesnesi oluşturur
  factory AppDatabase.open(String path) {
    // Result bilgisini oluşturur
    final result = AppDatabase._(sqlite3.open(path));
    // Result. initialize işlemini çağırır
    result._initialize();
    // İşlemin sonucunu döndürür
    return result;
  }
  // Veritabanı nesnesi oluşturur
  factory AppDatabase.inMemory() {
    // Result bilgisini oluşturur
    final result = AppDatabase._(sqlite3.openInMemory());
    // Result. initialize işlemini çağırır
    result._initialize();
    // İşlemin sonucunu döndürür
    return result;
  }
  // Veritabanının sürümünü ve tablolarını hazırlar
  void _initialize() {
    // Yabancı anahtar denetimini açar
    db.execute('PRAGMA foreign_keys = ON');
    // Version bilgisini oluşturur
    final version = db.select('PRAGMA user_version').first.values.first as int;
    // Veritabanı sürümüne göre işlem yapar
    if (version > 3) {
      // Geçersiz bilgi için hata fırlatır
      throw StateError('Database version $version is newer than app.');
    }
    // Veritabanı sürümüne göre işlem yapar
    if (version == 0) {
      // Veritabanı işlemini başlatır
      db.execute('BEGIN TRANSACTION');
      // Hata oluşabilecek işlemleri dener
      try {
        // Create schema v3 işlemini çağırır
        createSchemaV3(db);
        // Veritabanının sürüm numarasını günceller
        db.execute('PRAGMA user_version = 3');
        // Veritabanı değişikliklerini onaylar
        db.execute('COMMIT');
      // İşlem hata verirse çalışır
      } catch (_) {
        // Hatalı işlemleri geri alır
        db.execute('ROLLBACK');
        // Yakalanan hatayı yeniden fırlatır
        rethrow;
      }
    // Önceki koşul gerçekleşmezse çalışır
    } else {
      // Veritabanı sürümüne göre işlem yapar
      if (version == 1) {
        // Veritabanı işlemini başlatır
        db.execute('BEGIN TRANSACTION');
        // Hata oluşabilecek işlemleri dener
        try {
          // Migrate v1 to v2 işlemini çağırır
          migrateV1ToV2(db);
          // Migrate v2 to v3 işlemini çağırır
          migrateV2ToV3(db);
          // Veritabanının sürüm numarasını günceller
          db.execute('PRAGMA user_version = 3');
          // Veritabanı değişikliklerini onaylar
          db.execute('COMMIT');
        // İşlem hata verirse çalışır
        } catch (_) {
          // Hatalı işlemleri geri alır
          db.execute('ROLLBACK');
          // Yakalanan hatayı yeniden fırlatır
          rethrow;
        }
      // Önceki koşul gerçekleşmezse çalışır
      } else if (version == 2) {
        // Veritabanı işlemini başlatır
        db.execute('BEGIN TRANSACTION');
        // Hata oluşabilecek işlemleri dener
        try {
          // Migrate v2 to v3 işlemini çağırır
          migrateV2ToV3(db);
          // Veritabanının sürüm numarasını günceller
          db.execute('PRAGMA user_version = 3');
          // Veritabanı değişikliklerini onaylar
          db.execute('COMMIT');
        // İşlem hata verirse çalışır
        } catch (_) {
          // Hatalı işlemleri geri alır
          db.execute('ROLLBACK');
          // Yakalanan hatayı yeniden fırlatır
          rethrow;
        }
      }
    }
  }
  // Kullanılan kaynakları temizler
  void dispose() => db.close();
}

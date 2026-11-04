// Dosya işlemleri kütüphanesini ekler
import 'dart:io';
// Flutter durum ve bildirim yapılarını ekler
import 'package:flutter/foundation.dart';
// Dosya yollarını düzenlemek için ekler
import 'package:path/path.dart' as p;
// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// schema dosyasını kullanıma ekler
import 'schema.dart';
// garden database provider bilgilerini veya işlemlerini tutan sınıf
class GardenDatabaseProvider {
  // garden database provider.  nesnesini oluşturur
  GardenDatabaseProvider._();
  // instance bilgisini hesaplayıp saklar
  static final GardenDatabaseProvider instance = GardenDatabaseProvider._();
  // veritabanı bilgisini tutar
  Database? _database;
  // initialize ffi if required işlemini yapar
  static void initializeFfiIfRequired() {
    // Belirtilen koşul doğruysa işlemi yapar
    if (!kIsWeb &&
        // Yeni değer veya liste oluşturur
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // sqflite ffi init işlemini yapar
      sqfliteFfiInit();
      // database factory değerini günceller
      databaseFactory = databaseFactoryFfi;
    }
  }
  // Değerleri karşılaştırır
  Future<Database> get database async {
    // İlgili değer null değilse kontrol eder
    if (_database != null && _database!.isOpen) {
      // Hesaplanan sonucu döndürür
      return _database!;
    }
    // open işlemini yapar
    _database = await open();
    // Hesaplanan sonucu döndürür
    return _database!;
  }
  // open işlemini yapar
  Future<Database> open({
    // db adı için metin değeri belirler
    String dbName = 'fantastik_bahce.db',
    // version bilgisini hesaplayıp saklar
    int version = GardenDatabaseSchema.currentVersion,
    // İlgili değeri veya görünüm ayarını belirler
    DatabaseFactory? customFactory,
  }) async {
    // initialize ffi if required işlemini yapar
    initializeFfiIfRequired();
    // factory bilgisini hesaplayıp saklar
    final factory = customFactory ?? databaseFactory;
    // db path verisini asenkron işlemin sonucundan alır
    final dbPath = await factory.getDatabasesPath();
    // çizim yolu bilgisini hesaplayıp saklar
    final path = p.join(dbPath, dbName);
    // Hesaplanan sonucu döndürür
    return await factory.openDatabase(
      // İlgili değeri veya görünüm ayarını belirler
      path,
      // options bilgisini belirler
      options: OpenDatabaseOptions(
        // version bilgisini belirler
        version: version,
        // on configure olayındaki fonksiyonu belirler
        onConfigure: (db) async {
          // SQL komutunu çalıştırır
          await db.execute('PRAGMA foreign_keys = ON');
        },
        // on create olayındaki fonksiyonu belirler
        onCreate: (db, ver) async {
          // tables bilgisini oluşturur
          await GardenDatabaseSchema.createTables(db);
        },
        // on upgrade olayındaki fonksiyonu belirler
        onUpgrade: (db, oldVer, newVer) async {
          // upgrade bilgisini işler
          await GardenDatabaseSchema.onUpgrade(db, oldVer, newVer);
        },
      ),
    );
  }
  /// Birim ve widget testlerinde izole bellek içi veritabanı açar.
  // in memory bilgisini açar
  static Future<Database> openInMemory({
    // version bilgisini hesaplayıp saklar
    int version = GardenDatabaseSchema.currentVersion,
  }) async {
    // initialize ffi if required işlemini yapar
    initializeFfiIfRequired();
    // Hesaplanan sonucu döndürür
    return await databaseFactoryFfi.openDatabase(
      // İlgili değeri veya görünüm ayarını belirler
      inMemoryDatabasePath,
      // options bilgisini belirler
      options: OpenDatabaseOptions(
        // version bilgisini belirler
        version: version,
        // on configure olayındaki fonksiyonu belirler
        onConfigure: (db) async {
          // SQL komutunu çalıştırır
          await db.execute('PRAGMA foreign_keys = ON');
        },
        // on create olayındaki fonksiyonu belirler
        onCreate: (db, ver) async {
          // tables bilgisini oluşturur
          await GardenDatabaseSchema.createTables(db);
        },
        // on upgrade olayındaki fonksiyonu belirler
        onUpgrade: (db, oldVer, newVer) async {
          // upgrade bilgisini işler
          await GardenDatabaseSchema.onUpgrade(db, oldVer, newVer);
        },
      ),
    );
  }
  // Sınıf veya metoda ek özellik tanımlar
  @visibleForTesting
  // database for testing bilgisini ayarlar
  void setDatabaseForTesting(Database? db) {
    // veritabanı değerini günceller
    _database = db;
  }
  // close işlemini yapar
  Future<void> close() async {
    // İlgili değer null değilse kontrol eder
    if (_database != null && _database!.isOpen) {
      // close işlemini yapar
      await _database!.close();
      // veritabanı değerini günceller
      _database = null;
    }
  }
}

// SQLite veritabanı kütüphanesini ekler
import 'package:sqlite3/sqlite3.dart';
// Veritabanı tablolarını oluşturur
void createSchemaV2(Database db) {
  // ventures tablosunu oluşturur
  db.execute('''CREATE TABLE ventures (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    problem TEXT NOT NULL,
    audience TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    is_archived INTEGER NOT NULL DEFAULT 0
  )''');
  // hypotheses tablosunu oluşturur
  db.execute('''CREATE TABLE hypotheses (
    id TEXT PRIMARY KEY NOT NULL,
    venture_id TEXT NOT NULL REFERENCES ventures(id) ON DELETE CASCADE,
    statement TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  // experiments tablosunu oluşturur
  db.execute('''CREATE TABLE experiments (
    id TEXT PRIMARY KEY NOT NULL,
    hypothesis_id TEXT NOT NULL REFERENCES hypotheses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    method TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  // evidence tablosunu oluşturur
  db.execute('''CREATE TABLE evidence (
    id TEXT PRIMARY KEY NOT NULL,
    experiment_id TEXT NOT NULL REFERENCES experiments(id) ON DELETE CASCADE,
    note TEXT NOT NULL,
    direction TEXT NOT NULL CHECK(direction IN ('supports','contradicts','neutral')),
    created_at INTEGER NOT NULL,
    source TEXT,
    recorded_at INTEGER,
    has_consent INTEGER NOT NULL DEFAULT 1
  )''');
  // Sorguları hızlandırmak için indeks oluşturur
  db.execute('CREATE INDEX idx_hypotheses_venture ON hypotheses(venture_id)');
  // Sorguları hızlandıran indeks oluşturur
  db.execute(
    // Oluşturulacak indeksin SQL komutunu belirler
    'CREATE INDEX idx_experiments_hypothesis ON experiments(hypothesis_id)',
  );
  // Sorguları hızlandırmak için indeks oluşturur
  db.execute('CREATE INDEX idx_evidence_experiment ON evidence(experiment_id)');
}
// Veritabanını yeni şema sürümüne geçirir
void migrateV1ToV2(Database db) {
  // SQLite komutunu çalıştırır
  db.execute('ALTER TABLE evidence ADD COLUMN source TEXT');
  // SQLite komutunu çalıştırır
  db.execute('ALTER TABLE evidence ADD COLUMN recorded_at INTEGER');
  // SQLite komutunu çalıştırır
  db.execute(
    // Gösterilecek metni belirler
    'ALTER TABLE evidence ADD COLUMN has_consent INTEGER NOT NULL DEFAULT 1',
  );
}

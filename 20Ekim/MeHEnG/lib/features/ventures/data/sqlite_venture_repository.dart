// SQLite veritabanı kütüphanesini ekler
import 'package:sqlite3/sqlite3.dart';
// Veritabanı bağlantı sınıfını ekler
import '../../../core/database/app_database.dart';
// Girişim modelini ekler
import '../domain/venture.dart';
// Girişim repository sözleşmesini ekler
import '../domain/venture_repository.dart';
// Girişim kayıtlarını SQLite içinde yöneten sınıf
class SqliteVentureRepository implements VentureRepository {
  // Constructor gelen bilgileri nesneye aktarır
  SqliteVentureRepository(this.database);
  // Veritabanı bağlantısını tutar
  final AppDatabase database;
  // Decode metodunu tanımlar
  Venture _decode(Row row) => Venture(
    // ID bilgisini gönderir
    id: row['id'] as String,
    // İsim bilgisini belirler
    name: row['name'] as String,
    // Problem bilgisini gönderir
    problem: row['problem'] as String,
    // Hedef kitleyi gönderir
    audience: row['audience'] as String,
    // Oluşturulma tarihini gönderir
    createdAt: DateTime.fromMicrosecondsSinceEpoch(row['created_at'] as int),
    // Arşiv durumunu gönderir
    isArchived: (row['is_archived'] as int? ?? 0) == 1,
  );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Girişim kayıtlarını listeler
  List<Venture> all({bool includeArchived = false}) {
    // Sql bilgisini oluşturur
    final sql = includeArchived
        // Koşul doğruysa bu değeri kullanır
        ? 'SELECT * FROM ventures ORDER BY created_at DESC'
        // Koşul yanlışsa bu değeri kullanır
        : 'SELECT * FROM ventures WHERE is_archived = 0 ORDER BY created_at DESC';
    // Sonuçları listeye çevirip döndürür
    return database.db.select(sql).map(_decode).toList();
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // IDye göre girişim kaydını bulur
  Venture? find(String id) {
    // Rows bilgisini oluşturur
    final rows = database.db.select('SELECT * FROM ventures WHERE id = ?', [
      // Sorguda kullanılacak ID bilgisini gönderir
      id,
    ]);
    // İşlemin sonucunu döndürür
    return rows.isEmpty ? null : _decode(rows.first);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Yeni  kaydeder
  void add(Venture venture) => database.db.execute(
    // Gösterilecek metni belirler
    '''INSERT INTO ventures(id,name,problem,audience,created_at,is_archived)
           VALUES (?,?,?,?,?,?)''',
    // Sorgu parametrelerini liste halinde verir
    [
      // ID bilgisini ilgili işleme aktarır
      venture.id,
      // Girişim adını ilgili işleme aktarır
      venture.name,
      // Çözülecek problemi ilgili işleme aktarır
      venture.problem,
      // Hedef kitleyi ilgili işleme aktarır
      venture.audience,
      // İlgili değeri veya işlemi tanımlar
      venture.createdAt.microsecondsSinceEpoch,
      // Girişimin arşiv durumuna göre işlem seçer
      venture.isArchived ? 1 : 0,
    ],
  );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Mevcut girişim bilgilerini günceller
  void update(Venture venture) => database.db.execute(
    // Gösterilecek metni belirler
    '''UPDATE ventures SET name = ?, problem = ?, audience = ?, is_archived = ?
           WHERE id = ?''',
    // Sorgu parametrelerini liste halinde verir
    [
      // Girişim adını ilgili işleme aktarır
      venture.name,
      // Çözülecek problemi ilgili işleme aktarır
      venture.problem,
      // Hedef kitleyi ilgili işleme aktarır
      venture.audience,
      // Girişimin arşiv durumuna göre işlem seçer
      venture.isArchived ? 1 : 0,
      // ID bilgisini ilgili işleme aktarır
      venture.id,
    ],
  );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Girişimi arşivler
  void archive(String id) => database.db.execute(
    // Kayıtları güncelleyen SQL sorgusunu belirler
    'UPDATE ventures SET is_archived = 1 WHERE id = ?',
    // Sorgu parametrelerini liste halinde verir
    [id],
  );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Girişimi arşivden çıkarır
  void restore(String id) => database.db.execute(
    // Kayıtları güncelleyen SQL sorgusunu belirler
    'UPDATE ventures SET is_archived = 0 WHERE id = ?',
    // Sorgu parametrelerini liste halinde verir
    [id],
  );
}

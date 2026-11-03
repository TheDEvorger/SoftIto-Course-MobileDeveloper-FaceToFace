// JSON dönüştürme işlemlerini ekler
import 'dart:convert';
// Veritabanı bağlantı sınıfını ekler
import '../../../core/database/app_database.dart';
// Hipotez modelini ekler
import '../domain/hypothesis.dart';
// Deney modelini ekler
import '../domain/experiment.dart';
// Kanıt modelini ekler
import '../domain/evidence.dart';
// Karar modelini ekler
import '../domain/decision.dart';
// Doğrulama repository sözleşmesini ekler
import '../domain/discover_repository.dart';
// SQLite veri okuyucusunu ekler
import 'sqlite_discover_reader.dart';
// Doğrulama kayıtlarını SQLite içinde yöneten sınıf
class SqliteDiscoverRepository implements DiscoverRepository {
  // Doğrulama kayıtlarını SQLite içinde yöneten sınıf oluşturur
  SqliteDiscoverRepository(this.database)
      // Koşul yanlışsa bu değeri kullanır
      : reader = SqliteDiscoverReader(database);
  // Veritabanı bağlantısını tutar
  final AppDatabase database;
  // Veri okuma sınıfını tutar
  final SqliteDiscoverReader reader;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Girişime ait hipotezleri getirir
  List<Hypothesis> hypotheses(String id) => reader.hypotheses(id);
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Hipoteze ait deneyleri getirir
  List<Experiment> experiments(String id) => reader.experiments(id);
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Deneye ait kanıtları getirir
  List<Evidence> evidence(String id) => reader.evidence(id);
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Girişime ait kararları getirir
  List<Decision> decisions(String ventureId) => reader.decisions(ventureId);
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Yeni hipotez kaydeder
  void addHypothesis(Hypothesis item) => database.db.execute(
        // Yeni kayıt ekleyen SQL sorgusunu belirler
        'INSERT INTO hypotheses (id,venture_id,statement,created_at) VALUES (?,?,?,?)',
        // Sorgu parametrelerini liste halinde verir
        [
          // ID bilgisini ilgili işleme aktarır
          item.id,
          // Girişimin ID bilgisini ilgili işleme aktarır
          item.ventureId,
          // Hipotez ifadesini ilgili işleme aktarır
          item.statement,
          // Oluşturulma tarihini kayda ekler
          item.createdAt.microsecondsSinceEpoch,
        ],
      );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Yeni deney kaydeder
  void addExperiment(Experiment item) => database.db.execute(
        // Yeni kayıt ekleyen SQL sorgusunu belirler
        'INSERT INTO experiments (id,hypothesis_id,title,method,created_at) VALUES (?,?,?,?,?)',
        // Sorgu parametrelerini liste halinde verir
        [
          // ID bilgisini ilgili işleme aktarır
          item.id,
          // Hipotezin ID bilgisini ilgili işleme aktarır
          item.hypothesisId,
          // Başlık bilgisini ilgili işleme aktarır
          item.title,
          // Deney yöntemini ilgili işleme aktarır
          item.method,
          // Oluşturulma tarihini kayda ekler
          item.createdAt.microsecondsSinceEpoch,
        ],
      );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Yeni kanıt kaydeder
  void addEvidence(Evidence item) => database.db.execute(
        // Gösterilecek metni belirler
        '''INSERT INTO evidence (id,experiment_id,note,direction,created_at,source,recorded_at,has_consent)
           VALUES (?,?,?,?,?,?,?,?)''',
        // Sorgu parametrelerini liste halinde verir
        [
          // ID bilgisini ilgili işleme aktarır
          item.id,
          // Deneyin ID bilgisini ilgili işleme aktarır
          item.experimentId,
          // Kanıt açıklamasını ilgili işleme aktarır
          item.note,
          // Kanıtın yönünü kayda ekler
          item.direction.name,
          // Oluşturulma tarihini kayda ekler
          item.createdAt.microsecondsSinceEpoch,
          // Bilgi kaynağını ilgili işleme aktarır
          item.source,
          // Recorded at? bilgisini ilgili işleme aktarır
          item.recordedAt?.microsecondsSinceEpoch,
          // Has consent ? 1 : 0 bilgisini kayda ekler
          item.hasConsent ? 1 : 0,
        ],
      );
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Yeni karar kaydeder
  void addDecision(Decision item) => database.db.execute(
        // Gösterilecek metni belirler
        '''INSERT INTO decisions (id,venture_id,hypothesis_id,outcome,rationale,evidence_ids,created_at)
           VALUES (?,?,?,?,?,?,?)''',
        // Sorgu parametrelerini liste halinde verir
        [
          // ID bilgisini ilgili işleme aktarır
          item.id,
          // Girişimin ID bilgisini ilgili işleme aktarır
          item.ventureId,
          // Hipotezin ID bilgisini ilgili işleme aktarır
          item.hypothesisId,
          // Karar sonucunu kayda ekler
          item.outcome.name,
          // Kararın gerekçesini ilgili işleme aktarır
          item.rationale,
          // Json encode işlemini çağırır
          jsonEncode(item.evidenceIds),
          // Oluşturulma tarihini kayda ekler
          item.createdAt.microsecondsSinceEpoch,
        ],
      );
}

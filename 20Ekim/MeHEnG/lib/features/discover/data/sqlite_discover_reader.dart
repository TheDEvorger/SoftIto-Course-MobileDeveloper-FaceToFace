// JSON dönüştürme işlemlerini ekler
import 'dart:convert';
// SQLite veritabanı kütüphanesini ekler
import 'package:sqlite3/sqlite3.dart';
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
// Hipotez deney kanıt ve kararları okuyan sınıf
class SqliteDiscoverReader {
  // Constructor gelen bilgileri nesneye aktarır
  SqliteDiscoverReader(this.database);
  // Veritabanı bağlantısını tutar
  final AppDatabase database;
  // Girişime ait hipotezleri getirir
  List<Hypothesis> hypotheses(String id) => database.db
      // Veritabanından kayıtları sorgular
      .select(
        // İstenen kayıtları seçen SQL sorgusunu belirler
        'SELECT * FROM hypotheses WHERE venture_id=? ORDER BY created_at DESC',
        // Sorgu parametrelerini liste halinde verir
        [id],
      )
      // Elemanları yeni nesnelere dönüştürür
      .map(
        // İlgili fonksiyonun parametrelerini belirler
        (r) => Hypothesis(
          // ID bilgisini gönderir
          id: r['id'] as String,
          // Girişim ID bilgisini gönderir
          ventureId: r['venture_id'] as String,
          // Hipotez metnini gönderir
          statement: r['statement'] as String,
          // Oluşturulma tarihini gönderir
          createdAt: DateTime.fromMicrosecondsSinceEpoch(
            // SQL sonucundaki alanı alır
            r['created_at'] as int,
          ),
        ),
      )
      // Sonuçları listeye dönüştürür
      .toList();
  // Hipoteze ait deneyleri getirir
  List<Experiment> experiments(String id) => database.db
      // Veritabanından kayıtları sorgular
      .select(
        // İstenen kayıtları seçen SQL sorgusunu belirler
        'SELECT * FROM experiments WHERE hypothesis_id=? ORDER BY created_at DESC',
        // Sorgu parametrelerini liste halinde verir
        [id],
      )
      // Elemanları yeni nesnelere dönüştürür
      .map(
        // İlgili fonksiyonun parametrelerini belirler
        (r) => Experiment(
          // ID bilgisini gönderir
          id: r['id'] as String,
          // Hipotez ID bilgisini gönderir
          hypothesisId: r['hypothesis_id'] as String,
          // Başlık bilgisini belirler
          title: r['title'] as String,
          // Deney yöntemini gönderir
          method: r['method'] as String,
          // Oluşturulma tarihini gönderir
          createdAt: DateTime.fromMicrosecondsSinceEpoch(
            // SQL sonucundaki alanı alır
            r['created_at'] as int,
          ),
        ),
      )
      // Sonuçları listeye dönüştürür
      .toList();
  // Deneye ait kanıtları getirir
  List<Evidence> evidence(String id) => database.db
      // Veritabanından kayıtları sorgular
      .select(
        // İstenen kayıtları seçen SQL sorgusunu belirler
        'SELECT * FROM evidence WHERE experiment_id=? ORDER BY created_at DESC',
        // Sorgu parametrelerini liste halinde verir
        [id],
      )
      // Elemanları yeni nesnelere dönüştürür
      .map(_decodeEvidence)
      // Sonuçları listeye dönüştürür
      .toList();
  // Girişime ait kararları getirir
  List<Decision> decisions(String ventureId) => database.db
      // Veritabanından kayıtları sorgular
      .select(
        // İstenen kayıtları seçen SQL sorgusunu belirler
        'SELECT * FROM decisions WHERE venture_id=? ORDER BY created_at DESC',
        // Sorgu parametrelerini liste halinde verir
        [ventureId],
      )
      // Elemanları yeni nesnelere dönüştürür
      .map(_decodeDecision)
      // Sonuçları listeye dönüştürür
      .toList();
  // Decode evidence metodunu tanımlar
  Evidence _decodeEvidence(Row r) => Evidence(
        // ID bilgisini gönderir
        id: r['id'] as String,
        // Deney ID bilgisini gönderir
        experimentId: r['experiment_id'] as String,
        // Kanıt açıklamasını gönderir
        note: r['note'] as String,
        // Kanıt yönünü gönderir
        direction: EvidenceDirection.values.byName(r['direction'] as String),
        // Oluşturulma tarihini gönderir
        createdAt: DateTime.fromMicrosecondsSinceEpoch(r['created_at'] as int),
        // Kanıtın kaynağını gönderir
        source: r['source'] as String?,
        // Kayıt tarihini gönderir
        recordedAt: r['recorded_at'] != null
            // Koşul doğruysa bu değeri kullanır
            ? DateTime.fromMicrosecondsSinceEpoch(r['recorded_at'] as int)
            // Koşul yanlışsa bu değeri kullanır
            : null,
        // İzin bilgisini gönderir
        hasConsent: (r['has_consent'] as int? ?? 1) == 1,
      );
  // Decode decision metodunu tanımlar
  Decision _decodeDecision(Row r) => Decision(
        // ID bilgisini gönderir
        id: r['id'] as String,
        // Girişim ID bilgisini gönderir
        ventureId: r['venture_id'] as String,
        // Hipotez ID bilgisini gönderir
        hypothesisId: r['hypothesis_id'] as String?,
        // Karar sonucunu gönderir
        outcome: DecisionOutcome.values.byName(r['outcome'] as String),
        // Karar gerekçesini gönderir
        rationale: r['rationale'] as String,
        // Kanıt IDlerini gönderir
        evidenceIds: List<String>.from(
          // Json decode işlemini çağırır
          jsonDecode(r['evidence_ids'] as String) as List,
        ),
        // Oluşturulma tarihini gönderir
        createdAt: DateTime.fromMicrosecondsSinceEpoch(r['created_at'] as int),
      );
}

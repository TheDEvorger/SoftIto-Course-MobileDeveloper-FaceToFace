// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Benzersiz ID fonksiyonunu ekler
import '../../../core/ids/new_id.dart';
// Hipotez modelini ekler
import '../domain/hypothesis.dart';
// Deney modelini ekler
import '../domain/experiment.dart';
// Kanıt modelini ekler
import '../domain/evidence.dart';
// Karar modelini ekler
import '../domain/decision.dart';
// Doğrulama providerlarını ekler
import 'discover_providers.dart';
// ViewModele erişmek için Riverpod provider oluşturur
final discoverViewModelProvider = Provider<DiscoverViewModel>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref) => DiscoverViewModel(ref),
);
// Doğrulama işlemlerini yöneten ViewModel
class DiscoverViewModel {
  // Constructor gelen bilgileri nesneye aktarır
  DiscoverViewModel(this.ref);
  // Riverpod referansını tutar
  final Ref ref;
  // Yeni hipotez kaydeder
  void addHypothesis(String ventureId, String text) {
    // Metnin karakter sayısını kontrol eder
    if (text.trim().length < 5) {
      // Geçersiz bilgi için hata fırlatır
      throw ArgumentError('En az 5 karakter gerekli.');
    }
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(discoverRepositoryProvider).addHypothesis(
          // Hipotez bilgilerini tutan model oluşturur
          Hypothesis(
            // ID bilgisini gönderir
            id: newId(),
            // Girişim ID bilgisini gönderir
            ventureId: ventureId,
            // Hipotez metnini gönderir
            statement: text.trim(),
            // Oluşturulma tarihini gönderir
            createdAt: DateTime.now(),
          ),
        );
    // İlgili providerın verisini yeniler
    ref.invalidate(hypothesesProvider(ventureId));
  }
  // Yeni deney kaydeder
  void addExperiment(String hypothesisId, String title, String method) {
    // Metnin karakter sayısını kontrol eder
    if (title.trim().length < 3 || method.trim().length < 3) {
      // Geçersiz bilgi için hata fırlatır
      throw ArgumentError('Başlık ve yöntem en az 3 karakter olmalı.');
    }
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(discoverRepositoryProvider).addExperiment(
          // Deney bilgilerini tutan model oluşturur
          Experiment(
            // ID bilgisini gönderir
            id: newId(),
            // Hipotez ID bilgisini gönderir
            hypothesisId: hypothesisId,
            // Başlık bilgisini belirler
            title: title.trim(),
            // Deney yöntemini gönderir
            method: method.trim(),
            // Oluşturulma tarihini gönderir
            createdAt: DateTime.now(),
          ),
        );
    // İlgili providerın verisini yeniler
    ref.invalidate(experimentsProvider(hypothesisId));
  }
  // Yeni kanıt kaydeder
  void addEvidence(
    // Metin bilgisini parametre olarak alır
    String experimentId,
    // Metin bilgisini parametre olarak alır
    String note,
    // Kanıtın yönünü parametre olarak alır
    EvidenceDirection direction, {
    // Bilgi kaynağını parametre olarak alır
    String? source,
    // Kaydedilme tarihini parametre olarak alır
    DateTime? recordedAt,
    // Doğru yanlış değerini tanımlar
    bool hasConsent = true,
  }) {
    // Metnin karakter sayısını kontrol eder
    if (note.trim().length < 5) {
      // Geçersiz bilgi için hata fırlatır
      throw ArgumentError('Gözlem en az 5 karakter olmalı.');
    }
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(discoverRepositoryProvider).addEvidence(
          // Kanıt bilgilerini tutan model oluşturur
          Evidence(
            // ID bilgisini gönderir
            id: newId(),
            // Deney ID bilgisini gönderir
            experimentId: experimentId,
            // Kanıt açıklamasını gönderir
            note: note.trim(),
            // Kanıt yönünü gönderir
            direction: direction,
            // Oluşturulma tarihini gönderir
            createdAt: DateTime.now(),
            // Kanıtın kaynağını gönderir
            source: source?.trim().isEmpty == true ? null : source?.trim(),
            // Kayıt tarihini gönderir
            recordedAt: recordedAt,
            // İzin bilgisini gönderir
            hasConsent: hasConsent,
          ),
        );
    // İlgili providerın verisini yeniler
    ref.invalidate(evidenceProvider(experimentId));
  }
  // Yeni karar kaydeder
  void addDecision({
    // Girişimin ID bilgisini zorunlu alır
    required String ventureId,
    // Karar sonucunu zorunlu alır
    required DecisionOutcome outcome,
    // Kararın gerekçesini zorunlu alır
    required String rationale,
    // Kanıt ID listesini zorunlu alır
    required List<String> evidenceIds,
    // Hipotezin ID bilgisini parametre olarak alır
    String? hypothesisId,
  }) {
    // Metnin karakter sayısını kontrol eder
    if (rationale.trim().length < 5) {
      // Geçersiz bilgi için hata fırlatır
      throw ArgumentError('Karar gerekçesi en az 5 karakter olmalı.');
    }
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(discoverRepositoryProvider).addDecision(
          // Karar bilgilerini tutan model oluşturur
          Decision(
            // ID bilgisini gönderir
            id: newId(),
            // Girişim ID bilgisini gönderir
            ventureId: ventureId,
            // Hipotez ID bilgisini gönderir
            hypothesisId: hypothesisId,
            // Karar sonucunu gönderir
            outcome: outcome,
            // Karar gerekçesini gönderir
            rationale: rationale.trim(),
            // Kanıt IDlerini gönderir
            evidenceIds: List.unmodifiable(evidenceIds),
            // Oluşturulma tarihini gönderir
            createdAt: DateTime.now(),
          ),
        );
    // İlgili providerın verisini yeniler
    ref.invalidate(decisionsProvider(ventureId));
  }
}

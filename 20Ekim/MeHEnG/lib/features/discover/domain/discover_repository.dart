// Hipotez modelini ekler
import 'hypothesis.dart';
// Deney modelini ekler
import 'experiment.dart';
// Kanıt modelini ekler
import 'evidence.dart';
// Karar modelini ekler
import 'decision.dart';
// Discover kayıtlarını yöneten repository sınıfı
abstract class DiscoverRepository {
  // Girişime ait hipotezleri getirir
  List<Hypothesis> hypotheses(String ventureId);
  // Hipoteze ait deneyleri getirir
  List<Experiment> experiments(String hypothesisId);
  // Deneye ait kanıtları getirir
  List<Evidence> evidence(String experimentId);
  // Girişime ait kararları getirir
  List<Decision> decisions(String ventureId);
  // Yeni hipotez kaydeder
  void addHypothesis(Hypothesis item);
  // Yeni deney kaydeder
  void addExperiment(Experiment item);
  // Yeni kanıt kaydeder
  void addEvidence(Evidence item);
  // Yeni karar kaydeder
  void addDecision(Decision item);
}

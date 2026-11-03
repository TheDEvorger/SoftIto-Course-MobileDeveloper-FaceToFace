// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Veritabanı providerını ekler
import '../../../core/database/database_provider.dart';
// Sqlite discover repository dosyasını ekler
import '../data/sqlite_discover_repository.dart';
// Doğrulama repository sözleşmesini ekler
import '../domain/discover_repository.dart';
// Hipotez modelini ekler
import '../domain/hypothesis.dart';
// Deney modelini ekler
import '../domain/experiment.dart';
// Kanıt modelini ekler
import '../domain/evidence.dart';
// Karar modelini ekler
import '../domain/decision.dart';
// Repositoryye erişmek için Riverpod provider oluşturur
final discoverRepositoryProvider = Provider<DiscoverRepository>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref) => SqliteDiscoverRepository(ref.watch(databaseProvider)),
);
// Hypotheses verisini sağlayan provider oluşturur
final hypothesesProvider = Provider.family<List<Hypothesis>, String>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref, ventureId) =>
      // Providerın verisini dinler
      ref.watch(discoverRepositoryProvider).hypotheses(ventureId),
);
// Experiments verisini sağlayan provider oluşturur
final experimentsProvider = Provider.family<List<Experiment>, String>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref, hypothesisId) =>
      // Providerın verisini dinler
      ref.watch(discoverRepositoryProvider).experiments(hypothesisId),
);
// Evidence verisini sağlayan provider oluşturur
final evidenceProvider = Provider.family<List<Evidence>, String>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref, experimentId) =>
      // Providerın verisini dinler
      ref.watch(discoverRepositoryProvider).evidence(experimentId),
);
// Decisions verisini sağlayan provider oluşturur
final decisionsProvider = Provider.family<List<Decision>, String>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref, ventureId) =>
      // Providerın verisini dinler
      ref.watch(discoverRepositoryProvider).decisions(ventureId),
);

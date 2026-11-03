// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Veritabanı providerını ekler
import '../../../core/database/database_provider.dart';
// Benzersiz ID fonksiyonunu ekler
import '../../../core/ids/new_id.dart';
// SQLite girişim repositorysini ekler
import '../data/sqlite_venture_repository.dart';
// Girişim modelini ekler
import '../domain/venture.dart';
// Girişim repository sözleşmesini ekler
import '../domain/venture_repository.dart';
// Repositoryye erişmek için Riverpod provider oluşturur
final ventureRepositoryProvider = Provider<VentureRepository>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref) => SqliteVentureRepository(ref.watch(databaseProvider)),
);
// Show archived ventures verisini sağlayan provider oluşturur
final showArchivedVenturesProvider =
    // Değişen arşiv durumunu sağlayan provider oluşturur
    NotifierProvider<ShowArchivedNotifier, bool>(ShowArchivedNotifier.new);
// Arşivdekileri gösterme durumunu yöneten sınıf
class ShowArchivedNotifier extends Notifier<bool> {
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Arşivdekileri başlangıçta gizler
  bool build() => false;
  // Arşiv görünürlüğünü tersine çevirir
  void toggle() => state = !state;
  // Arşiv görünürlüğünü belirtilen değere ayarlar
  void set(bool value) => state = value;
}
// Ventures verisini sağlayan provider oluşturur
final venturesProvider = Provider<List<Venture>>((ref) {
  // Show archived bilgisini Riverpod üzerinden dinler
  final showArchived = ref.watch(showArchivedVenturesProvider);
  // Riverpod üzerinden kayıtlara erişir
  return ref
      // Provider değişikliklerini dinler
      .watch(ventureRepositoryProvider)
      // Girişimlerin tamamını getirir
      .all(includeArchived: showArchived);
});
// Venture verisini sağlayan provider oluşturur
final ventureProvider = Provider.family<Venture?, String>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref, id) => ref.watch(ventureRepositoryProvider).find(id),
);
// ViewModele erişmek için Riverpod provider oluşturur
final ventureViewModelProvider = Provider<VentureViewModel>(
  // Provider oluşturulurken Riverpod referansını kullanır
  (ref) => VentureViewModel(ref),
);
// Girişim işlemlerini yöneten ViewModel
class VentureViewModel {
  // Constructor gelen bilgileri nesneye aktarır
  VentureViewModel(this.ref);
  // Riverpod referansını tutar
  final Ref ref;
  // Yeni girişim kaydeder
  void create({
    // Girişim adını zorunlu alır
    required String name,
    // Çözülecek problemi zorunlu alır
    required String problem,
    // Hedef kitleyi zorunlu alır
    required String audience,
  }) {
    // Gönderilen verinin doğrulama hatasını kontrol eder
    final error = Venture.validateName(name);
    // Değerin boş olup olmadığını kontrol eder
    if (error != null) throw ArgumentError(error);
    // Riverpod referansı üzerinden işleme devam eder
    ref
        // Providerdan güncel değeri okur
        .read(ventureRepositoryProvider)
        // Yeni kaydı repository üzerinden ekler
        .add(
          // Girişim bilgilerini tutan model oluşturur
          Venture(
            // ID bilgisini gönderir
            id: newId(),
            // İsim bilgisini belirler
            name: name.trim(),
            // Problem bilgisini gönderir
            problem: problem.trim(),
            // Hedef kitleyi gönderir
            audience: audience.trim(),
            // Oluşturulma tarihini gönderir
            createdAt: DateTime.now(),
          ),
        );
    // İlgili providerın verisini yeniler
    ref.invalidate(venturesProvider);
  }
  // Mevcut girişim bilgilerini günceller
  void update({
    // ID bilgisini zorunlu alır
    required String id,
    // Girişim adını zorunlu alır
    required String name,
    // Çözülecek problemi zorunlu alır
    required String problem,
    // Hedef kitleyi zorunlu alır
    required String audience,
  }) {
    // Gönderilen verinin doğrulama hatasını kontrol eder
    final error = Venture.validateName(name);
    // Değerin boş olup olmadığını kontrol eder
    if (error != null) throw ArgumentError(error);
    // Repo bilgisini Riverpod üzerinden okur
    final repo = ref.read(ventureRepositoryProvider);
    // Mevcut kaydı oluşturur
    final current = repo.find(id);
    // Değerin boş olup olmadığını kontrol eder
    if (current == null) throw StateError('Girişim bulunamadı.');
    // Repo.update işlemini çağırır
    repo.update(
      // Current.copy with işlemini çağırır
      current.copyWith(
        // İsim bilgisini belirler
        name: name.trim(),
        // Problem bilgisini gönderir
        problem: problem.trim(),
        // Hedef kitleyi gönderir
        audience: audience.trim(),
      ),
    );
    // İlgili providerın verisini yeniler
    ref.invalidate(venturesProvider);
    // İlgili providerın verisini yeniler
    ref.invalidate(ventureProvider(id));
  }
  // Girişimi arşivler
  void archive(String id) {
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(ventureRepositoryProvider).archive(id);
    // İlgili providerın verisini yeniler
    ref.invalidate(venturesProvider);
    // İlgili providerın verisini yeniler
    ref.invalidate(ventureProvider(id));
  }
  // Girişimi arşivden çıkarır
  void restore(String id) {
    // Riverpod üzerinden ilgili işlemi çalıştırır
    ref.read(ventureRepositoryProvider).restore(id);
    // İlgili providerın verisini yeniler
    ref.invalidate(venturesProvider);
    // İlgili providerın verisini yeniler
    ref.invalidate(ventureProvider(id));
  }
}

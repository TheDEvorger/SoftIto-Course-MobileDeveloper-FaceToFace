// kanıt taslak dosyasını ekler
import '../domain/evidence_draft.dart';
/// Oturum süresince denetim taslaklarını bellekte saklayan depo sınıfı.
/// Gerçek fotoğraf dosyaları veya kalıcı veritabanı kullanmaz.
// örnek kontrol depo için sınıf oluşturur
class DemoInspectionStore {
  // Rezervasyon kimliğine göre taslak anlık görüntüleri (snapshots)
  // snapshots değerini tanımlar
  final Map<String, Map<String, Object?>> _snapshots = {};
  /// Rezervasyon kimliği için mevcut taslağı geri yükler veya yeni bir taslak açar.
  // open işlemini gerçekleştirir
  EvidenceDraft open(String bookingId) => _snapshots.containsKey(bookingId)
      // Koşul doğruysa bu değeri seçer
      ? EvidenceDraft.restore(_snapshots[bookingId]!,
          // expected rezervasyon ID bilgisini belirler
          expectedBookingId: bookingId)
      // Koşul yanlışsa bu değeri seçer
      : EvidenceDraft(bookingId);
  /// Taslağı anlık görüntü olarak belleğe kaydeder.
  // kaydetme işlemini gerçekleştirir
  void save(EvidenceDraft draft) =>
      // snapshots değerini günceller
      _snapshots[draft.bookingId] = draft.toJson();
}

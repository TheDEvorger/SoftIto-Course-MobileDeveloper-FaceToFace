// Girişim modelini ekler
import 'venture.dart';
// Venture kayıtlarını yöneten repository sınıfı
abstract class VentureRepository {
  // Girişim kayıtlarını listeler
  List<Venture> all({bool includeArchived = false});
  // IDye göre girişim kaydını bulur
  Venture? find(String id);
  // Yeni  kaydeder
  void add(Venture venture);
  // Mevcut girişim bilgilerini günceller
  void update(Venture venture);
  // Girişimi arşivler
  void archive(String id);
  // Girişimi arşivden çıkarır
  void restore(String id);
}

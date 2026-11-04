// Çağ ve rütbe modelini projeye ekler
import '../models/era.dart';
// Vazife modelini projeye ekler
import '../models/habit.dart';
// XP, seviye, rütbe ve günlük tarih hesaplarını merkezileştirir
class ProgressionEngine {
  // Bir sonraki seviye için gereken XP miktarını hesaplar
  static int xpThreshold(int level) {
    // indeks için güncel toplamı hesaplar
    final index = (level - 1).clamp(0, 23);
    // Hesaplanan değeri çağıran yere geri döndürür
    return 45 * index * index + 30 * index;
  }
  // Toplam XPye göre kazanılan seviyeyi hesaplar
  static int levelForXp(int xp) {
    // seviye bilgisini saklar
    var level = 1;
    // Belirtilen koşul sürdükçe tarih veya seviye sayacını ilerletir
    while (level < 24 && xp >= xpThreshold(level + 1)) {
      // seviye sayacını bir artırır
      level++;
    }
    // Hesaplanan değeri çağıran yere geri döndürür
    return level;
  }
  // XP ve itibara göre görünen seviyeyi sınırlar
  static int titleLevel(int xp, int reputation) {
    // Kazanılan rozet IDlerini tekrarsız saklayan küme oluşturur
    final earned = levelForXp(xp);
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (reputation < 16) return (earned - 5).clamp(1, 24).toInt();
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (reputation < 36) return (earned - 2).clamp(1, 24).toInt();
    // Kazanılan rozetlerin ID kümesini döndürür
    return earned;
  }
  // Vazifenin zorluğuna göre kazanılacak XPyi döndürür
  static int rewardFor(Habit habit) =>
      // Vazife zorluğunun her derecesine altı XP ekler
      12 + habit.difficulty.clamp(1, 3).toInt() * 6;
  // Tarihi gün anahtarı olacak String biçimine çevirir
  static String dayKey(DateTime d) =>
      // Gösterilecek veya kullanılacak metin parçasını ekler
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  // Sınıf üzerinden kullanılacak sabit bilgi veya yardımcı işlevi tanımlar
  static DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
  // era sayı bilgisini dışarıya okuma amaçlı sunar
  static int get eraCount => eras.length;
}

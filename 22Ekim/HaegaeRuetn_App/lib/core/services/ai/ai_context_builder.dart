// Krallık verilerini yöneten controllerı projeye ekler
import '../../state/realm_controller.dart';
// İzin verilen vazife ve ahitlerden kısa bir durum özeti hazırlar
// Kullanıcı paylaşımı kapatırsa hiçbir kişisel özet döndürmez
// İzin verilen vazife ve ahit verilerini kısa bir metne dönüştürür
class AiContextBuilder {
  // AiContextBuilder nesnesinin başlangıç bilgilerini alır
  const AiContextBuilder();
  // Kullanıcı izniyle paylaşılacak bağlamı düzenler
  // İzin verilmişse alışkanlık ve ahitlerden AI için özet üretir
  String? buildContext({
    // İşlemleri yöneten RealmController bağlantısını alır ve zorunludur
    required RealmController controller,
    // consent granted parametresini zorunlu alır
    required bool consentGranted,
  }) {
    // Kullanıcı izin vermediyse hiçbir vazife bilgisini paylaşmaz
    if (!consentGranted) return null;
    // Özet metnini satır satır birleştirmek için StringBuffer hazırlar
    final buffer = StringBuffer();
    // Ekranda kullanılacak krallık controllerını kısa değişkene alır
    final c = controller;
    // Rehberin sistem talimatına bu metni ekler
    buffer.writeln('- Rütbe: ${c.era.name} Çağı • ${c.rank} (Sv.${c.level})');
    // Rehberin sistem talimatına bu metni ekler
    buffer.writeln('- İtibar: ${c.reputation}/100, Tecrübe: ${c.xp} XP');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '- Bugünkü durum: ${c.todayCompleted}/${c.activeHabits.length} vazife tamamlandı');
    // Aktif vazifeler varsa ilgili istatistiği gösterir
    if (c.activeHabits.isNotEmpty) {
      // AI için en fazla beş aktif vazifenin kısa durum metnini oluşturur
      final habitList = c.activeHabits.take(5).map((h) {
        // Vazifenin bugün yapılmış olup olmadığını belirler
        final done = h.completedOn(c.today);
        // Vazifenin adını, bugünkü durumunu ve toplam tekrarını metinleştirir
        return '${h.name} (${done ? "Bugün yapıldı" : "Bekliyor"}, ${h.completedDates.length} kez)';
      // Oluşturulan parçaları virgülle ayrılmış tek metinde birleştirir
      }).join(', ');
      // Rehberin sistem talimatına bu metni ekler
      buffer.writeln('- Aktif vazifeler: $habitList');
    }
    // Kullanılabilir veri varsa devam eder
    if (c.pacts.isNotEmpty) {
      // AI için en fazla üç tamamlanmamış ahdi özetler
      final activePacts = c.pacts.where((p) => !p.isCompleted).take(3).map((p) {
        // Ahitte birlikte tamamlanan gün sayısını hesaplar
        final progress = c.pactProgress(p);
        // Ahdin adını ve hedefe kalan ilerlemesini metinleştirir
        return '${p.title} ($progress/${p.goalDays} gün)';
      // Oluşturulan parçaları virgülle ayrılmış tek metinde birleştirir
      }).join(', ');
      // Kullanılabilir veri varsa devam eder
      if (activePacts.isNotEmpty) {
        // Rehberin sistem talimatına bu metni ekler
        buffer.writeln('- Aktif ahitler: $activePacts');
      }
    }
    // Hazırlanan izinli durum özetini String olarak döndürür
    return buffer.toString().trim();
  }
}

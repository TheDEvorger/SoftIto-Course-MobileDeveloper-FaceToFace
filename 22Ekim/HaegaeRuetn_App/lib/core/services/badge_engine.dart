// Vazife modelini projeye ekler
import '../models/habit.dart';
// Ahit modelini projeye ekler
import '../models/pact.dart';
// XP ve seviye hesaplama servisini projeye ekler
import '../services/progression_engine.dart';
// Gerçekleşen ilerlemeye göre kazanılan rozetleri belirler
class BadgeEngine {
  // Tamamlanmış vazife, ahit ve geri dönüş sayılarına göre rozetleri bulur
  static Set<int> earned(
      // Rozet hesabı için vazifeleri, ahitleri ve geri dönüş sayısını alır
      List<Habit> habits, List<Pact> pacts, int comebackCount) {
    // Vazife yapılan farklı tarihleri tekrarsız tutar
    final allDates = <String>{};
    // Toplam tamamlanma sayısını sıfırdan başlatır
    var done = 0;
    // Zor vazifelerin tamamlanma sayısını sıfırdan başlatır
    var hard = 0;
    // Vazifeleri tek tek dolaşıp durumlarını kontrol eder
    for (final habit in habits) {
      // done toplamına yeni değeri ekler
      done += habit.completedDates.length;
      // Bir koleksiyondaki bütün öğeleri diğerine ekler
      allDates.addAll(habit.completedDates);
      // Zor vazifenin tamamlanma sayısını ayrı hesaplar
      if (habit.difficulty == 3) hard += habit.completedDates.length;
    }
    // Tamamlanan ahitlerin sayısını bulur
    final pactDone = pacts.where((p) => p.isCompleted).length;
    // Kazanılan rozet kimliklerini tekrarsız tutan küme oluşturur
    final earned = <int>{};
    // İlk vazife tamamlanınca birinci rozeti açar
    if (done >= 1) earned.add(1);
    // İlk ahit oluşturulduysa ikinci rozeti açar
    if (pacts.isNotEmpty) earned.add(2);
    // Beş vazife tamamlanınca üçüncü rozeti açar
    if (done >= 5) earned.add(3);
    // İlk geri dönüş başarısı için rozet verir
    if (comebackCount >= 1) earned.add(4);
    // Yedi farklı güne yayılmış ilerleme için rozet açar
    if (allDates.length >= 7) earned.add(5);
    // İlk tamamlanan ahit için rozet açar
    if (pactDone >= 1) earned.add(6);
    // On vazife tamamlanınca yedinci rozeti açar
    if (done >= 10) earned.add(7);
    // Aynı gün üç vazife tamamlanıp tamamlanmadığını arar
    final triple = allDates
        // Öğelerden en az birinin koşulu sağlamasını kontrol eder
        .any((date) => habits.where((h) => h.completedOn(date)).length >= 3);
    // Aynı gün üç vazife tamamlanmışsa ilgili rozeti verir
    if (triple) earned.add(10);
    // Beş zor vazife tamamlandığında rozet açar
    if (hard >= 5) earned.add(11);
    // Yüz vazife tamamlanınca ilgili rozeti açar
    if (done >= 100) earned.add(12);
    // Üç geri dönüş yapan kullanıcıya rozet verir
    if (comebackCount >= 3) earned.add(14);
    // Beş tamamlanmış ahit için rozet açar
    if (pactDone >= 5) earned.add(19);
    // Kazanılan rozetlerin ID kümesini döndürür
    return earned;
  }
  // Ahdin bağlı vazifelerinin birlikte tamamlandığı günleri sayar
  static int pactProgress(Pact pact, List<Habit> habits) {
    // Ahde hiç vazife bağlanmamışsa ilerlemeyi sıfır kabul eder
    if (pact.habitIds.isEmpty) return 0;
    // Vazifeleri ID anahtarlarıyla hızlı erişilen Map hâline getirir
    final byId = {for (final habit in habits) habit.id: habit};
    // Ahdin bağlı vazifelerini kimlikleriyle eşleştirir
    final selected = pact.habitIds.map((id) => byId[id]).toList();
    // Ahde bağlı bir vazife silinmişse ilerleme saymaz
    if (selected.any((habit) => habit == null)) return 0;
    // Ahitteki ilk bağlı vazifeyi null olmadığı için alır
    final first = selected.first!;
    // Ahdin başladığı günü saat bilgisinden ayırır
    final from = ProgressionEngine.day(pact.startedAt);
    // Ortak tamamlanan günleri saymak için sıfırdan başlar
    var count = 0;
    // Tamamlanmış günleri tek tek kontrol eder
    for (final date in first.completedDates.toSet()) {
      // Tarih metnini hataya düşmeden DateTimea çevirmeyi dener
      final parsed = DateTime.tryParse(date);
      // Geçersiz veya ahitten önceki tarihleri atlar
      if (parsed == null || parsed.isBefore(from)) continue;
      // Bütün bağlı vazifeler aynı gün yapıldıysa sayacı artırır
      if (selected.every((habit) => habit!.completedOn(date))) count++;
    }
    // Tamamlanan gün sayısını ahdin hedefini aşmadan döndürür
    return count.clamp(0, pact.goalDays).toInt();
  }
}

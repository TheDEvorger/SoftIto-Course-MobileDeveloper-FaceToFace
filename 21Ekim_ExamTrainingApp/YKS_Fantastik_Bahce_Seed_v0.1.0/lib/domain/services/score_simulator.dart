// score simulation dosyasını kullanıma ekler
import '../models/score_simulation.dart';
/// ÖSYM YKS kılavuz standartlarına dayalı güvenli puan simülasyon motoru.
// score simulator bilgilerini veya işlemlerini tutan sınıf
class ScoreSimulator {
  // score simulator nesnesini oluşturur
  const ScoreSimulator();
  // curriculum year için başlangıç sayısını belirler
  static const int curriculumYear = 2026;
  // disclaimer metin değerini tanımlar
  static const String disclaimerText =
      // "ÖSYM puanları ilgili sınav yılının Türkiye …" metnini kullanır
      'ÖSYM puanları ilgili sınav yılının Türkiye genel ortalaması ve standart sapmasına göre hesaplanır. '
      // "Bu hesaplama, geçmiş yılların ortalama kats…" metnini kullanır
      'Bu hesaplama, geçmiş yılların ortalama katsayılarına dayalı yaklaşık/temsili bir tahmindir ve '
      // "resmî sınav sonucu veya sıralama garantisi …" metnini kullanır
      'resmî sınav sonucu veya sıralama garantisi yerine geçmez.';
  /// TYT Ham Puanı Hesapla (Taban 100, Tavan 500)
  // tyt raw score bilgisini hesaplar
  double calculateTytRawScore({
    // turkce bilgisini zorunlu tutar
    required double turkce,
    // matematik bilgisini zorunlu tutar
    required double matematik,
    // sosyal bilgisini zorunlu tutar
    required double sosyal,
    // fen bilgisini zorunlu tutar
    required double fen,
  }) {
    // clamped turkce değerini belirli aralıkta sınırlar
    final clampedTurkce = turkce.clamp(0.0, 40.0);
    // clamped mat değerini belirli aralıkta sınırlar
    final clampedMat = matematik.clamp(0.0, 40.0);
    // clamped sosyal değerini belirli aralıkta sınırlar
    final clampedSosyal = sosyal.clamp(0.0, 20.0);
    // clamped fen değerini belirli aralıkta sınırlar
    final clampedFen = fen.clamp(0.0, 20.0);
    // Katsayılar: 120 net tam yapıldığında tam 500.0 verecek şekilde dengelenmiştir.
    // 100 (taban) + 40*3.30 + 40*3.30 + 20*3.40 + 20*3.40 = 500.0
    // puan için başlangıç sayısını belirler
    final score = 100.0 +
        // Yeni değer veya liste oluşturur
        (clampedTurkce * 3.30) +
        // Yeni değer veya liste oluşturur
        (clampedMat * 3.30) +
        // Yeni değer veya liste oluşturur
        (clampedSosyal * 3.40) +
        // Yeni değer veya liste oluşturur
        (clampedFen * 3.40);
    // Değeri belirtilen aralıkta sınırlar
    return score.clamp(100.0, 500.0);
  }
  /// OBP ve Yerleştirme Katkısı Hesapla
  // obp score bilgisini hesaplar
  double calculateObpScore(double diplomaGrade) {
    // grade değerini belirli aralıkta sınırlar
    final grade = diplomaGrade.clamp(50.0, 100.0);
    // Hesaplanan sonucu döndürür
    return grade * 5.0; // 250.0 - 500.0
  }
  // obp contribution bilgisini hesaplar
  double calculateObpContribution(double obpScore, bool isPreviousYearPlaced) {
    // multiplier değerini koşula göre hesaplar
    final multiplier = isPreviousYearPlaced ? 0.06 : 0.12;
    // Hesaplanan sonucu döndürür
    return obpScore * multiplier;
  }
  /// Alan Puanı ve Yerleştirme Simülasyonu
  // simulate işlemini yapar
  SimulationResult simulate(SimulationInput input) {
    // tyt raw bilgisini hesaplayıp saklar
    final tytRaw = calculateTytRawScore(
      // turkce bilgisini belirler
      turkce: input.tytTurkce,
      // matematik bilgisini belirler
      matematik: input.tytMatematik,
      // sosyal bilgisini belirler
      sosyal: input.tytSosyal,
      // fen bilgisini belirler
      fen: input.tytFen,
    );
    // field raw bilgisini tutar
    double fieldRaw;
    // Belirtilen koşul doğruysa işlemi yapar
    if (input.field == SimulationField.tytOnly) {
      // field raw değerini günceller
      fieldRaw = tytRaw;
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // AYT puanında TYT %40 ağırlığa sahiptir (160 puan payı).
      // tyt contribution bilgisini hesaplayıp saklar
      final tytContribution = (tytRaw - 100.0) * 0.40;
      // ayt net points için başlangıç sayısını belirler
      double aytNetPoints = 0.0;
      // Değere göre uygun durumu seçer
      switch (input.field) {
        // simulation field.sayisal durumu için çalışır
        case SimulationField.sayisal:
          // mat değerini belirli aralıkta sınırlar
          final mat = input.aytMatematik.clamp(0.0, 40.0) * 3.00;
          // fiz değerini belirli aralıkta sınırlar
          final fiz = input.aytFizik.clamp(0.0, 14.0) * 2.85;
          // kim değerini belirli aralıkta sınırlar
          final kim = input.aytKimya.clamp(0.0, 13.0) * 3.07;
          // bio değerini belirli aralıkta sınırlar
          final bio = input.aytBiyoloji.clamp(0.0, 13.0) * 3.07;
          // ayt net points değerini günceller
          aytNetPoints = mat + fiz + kim + bio;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
        // simulation field.esit agirlik durumu için çalışır
        case SimulationField.esitAgirlik:
          // mat değerini belirli aralıkta sınırlar
          final mat = input.aytMatematik.clamp(0.0, 40.0) * 3.00;
          // edb değerini belirli aralıkta sınırlar
          final edb = input.aytEdebiyat.clamp(0.0, 24.0) * 3.00;
          // tar1 değerini belirli aralıkta sınırlar
          final tar1 = input.aytTarih1.clamp(0.0, 10.0) * 2.80;
          // cog1 değerini belirli aralıkta sınırlar
          final cog1 = input.aytCografya1.clamp(0.0, 6.0) * 3.33;
          // ayt net points değerini günceller
          aytNetPoints = mat + edb + tar1 + cog1;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
        // simulation field.sozel durumu için çalışır
        case SimulationField.sozel:
          // edb değerini belirli aralıkta sınırlar
          final edb = input.aytEdebiyat.clamp(0.0, 24.0) * 3.00;
          // tar1 değerini belirli aralıkta sınırlar
          final tar1 = input.aytTarih1.clamp(0.0, 10.0) * 2.80;
          // cog1 değerini belirli aralıkta sınırlar
          final cog1 = input.aytCografya1.clamp(0.0, 6.0) * 3.33;
          // Sözel-2 temsili puanı
          // sos2 değerini tanımlar
          final sos2 =
              // Değeri belirtilen aralıkta sınırlar
              (input.aytTarih1 + input.aytCografya1).clamp(0.0, 40.0) * 2.40;
          // ayt net points değerini günceller
          aytNetPoints = edb + tar1 + cog1 + sos2;
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
        // simulation field.tyt only durumu için çalışır
        case SimulationField.tytOnly:
          // Bulunduğu döngü veya switch bölümünden çıkar
          break;
      }
      // Değeri belirtilen aralıkta sınırlar
      fieldRaw = (100.0 + tytContribution + aytNetPoints).clamp(100.0, 500.0);
    }
    // obp bilgisini hesaplayıp saklar
    final obp = calculateObpScore(input.diplomaGrade);
    // obp contribution değerini tanımlar
    final obpContribution =
        // obp contribution bilgisini hesaplar
        calculateObpContribution(obp, input.isPreviousYearPlaced);
    // placement bilgisini hesaplayıp saklar
    final placement = fieldRaw + obpContribution;
    // simulation result nesnesini oluşturur
    return SimulationResult(
      // field bilgisini belirler
      field: input.field,
      // tyt score bilgisini belirler
      tytScore: tytRaw,
      // field raw score bilgisini belirler
      fieldRawScore: fieldRaw,
      // obp score bilgisini belirler
      obpScore: obp,
      // obp contribution bilgisini belirler
      obpContribution: obpContribution,
      // placement score bilgisini belirler
      placementScore: placement,
      // disclaimer bilgisini belirler
      disclaimer: disclaimerText,
      // curriculum year bilgisini belirler
      curriculumYear: curriculumYear,
    );
  }
}

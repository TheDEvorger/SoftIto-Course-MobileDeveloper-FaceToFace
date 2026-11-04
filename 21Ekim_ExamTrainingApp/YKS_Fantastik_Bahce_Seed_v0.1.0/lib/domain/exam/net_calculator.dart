/// Doğru ve yanlış sayılarından standart net sonucunu üretir.
/// Soru üst sınırı ekranın oturum/branş planında ayrıca doğrulanmalıdır.
// Sabitleri veya ortak işlemleri tutan, nesne oluşturulamayan sınıf
abstract final class NetCalculator {
  // calculate işlemini yapar
  static double calculate({required int correct, required int wrong}) {
    // Belirtilen koşul doğruysa işlemi yapar
    if (correct < 0 || wrong < 0) {
      // Geçersiz durum için hata fırlatır
      throw RangeError('Doğru ve yanlış sayıları negatif olamaz.');
    }
    // Hesaplanan sonucu döndürür
    return correct - (wrong / 4.0);
  }
  // fits deneme işlemini yapar
  static bool fitsExam({
    // doğru sayısı bilgisini zorunlu tutar
    required int correct,
    // yanlış sayısı bilgisini zorunlu tutar
    required int wrong,
    // soru sayısı bilgisini zorunlu tutar
    required int questionCount,
  }) {
    // Birden fazla koşulu birlikte kontrol eder
    return correct >= 0 &&
        // Birden fazla koşulu birlikte kontrol eder
        wrong >= 0 &&
        // Birden fazla koşulu birlikte kontrol eder
        questionCount >= 0 &&
        // Hesaplamada kullanılacak sayısal değeri belirler
        correct + wrong <= questionCount;
  }
}

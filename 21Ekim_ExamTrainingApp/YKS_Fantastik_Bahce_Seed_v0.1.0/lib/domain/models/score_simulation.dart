/// Puan simülasyonu alan türleri
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum SimulationField {
  // sayisal işlemini yapar
  sayisal('Sayısal (SAY)', 'TYT + Matematik + Fen'),
  // esit agirlik işlemini yapar
  esitAgirlik('Eşit Ağırlık (EA)', 'TYT + Matematik + Edebiyat-Sosyal'),
  // sozel işlemini yapar
  sozel('Sözel (SÖZ)', 'TYT + Edebiyat-Sosyal-1 + Sosyal-2'),
  // tyt only işlemini yapar
  tytOnly('Yalnızca TYT', 'Temel Yeterlilik Testi');
  // simulation field nesnesini oluşturur
  const SimulationField(this.title, this.description);
  // başlık bilgisini tutar
  final String title;
  // açıklama bilgisini tutar
  final String description;
}
/// Simülasyon giriş verileri
// simulation input bilgilerini veya işlemlerini tutan sınıf
class SimulationInput {
  // simulation input nesnesini oluşturur
  const SimulationInput({
    // field bilgisini isteğe bağlı alır
    this.field = SimulationField.sayisal,
    // tyt turkce bilgisini isteğe bağlı alır
    this.tytTurkce = 0.0,
    // tyt matematik bilgisini isteğe bağlı alır
    this.tytMatematik = 0.0,
    // tyt sosyal bilgisini isteğe bağlı alır
    this.tytSosyal = 0.0,
    // tyt fen bilgisini isteğe bağlı alır
    this.tytFen = 0.0,
    // ayt matematik bilgisini isteğe bağlı alır
    this.aytMatematik = 0.0,
    // ayt fizik bilgisini isteğe bağlı alır
    this.aytFizik = 0.0,
    // ayt kimya bilgisini isteğe bağlı alır
    this.aytKimya = 0.0,
    // ayt biyoloji bilgisini isteğe bağlı alır
    this.aytBiyoloji = 0.0,
    // ayt edebiyat bilgisini isteğe bağlı alır
    this.aytEdebiyat = 0.0,
    // ayt tarih1 bilgisini isteğe bağlı alır
    this.aytTarih1 = 0.0,
    // ayt cografya1 bilgisini isteğe bağlı alır
    this.aytCografya1 = 0.0,
    // diploma grade bilgisini isteğe bağlı alır
    this.diplomaGrade = 80.0,
    // is previous year placed bilgisini isteğe bağlı alır
    this.isPreviousYearPlaced = false,
  });
  // field bilgisini tutar
  final SimulationField field;
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double tytTurkce; // maks 40
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double tytMatematik; // maks 40
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double tytSosyal; // maks 20
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double tytFen; // maks 20
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytMatematik; // maks 40
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytFizik; // maks 14
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytKimya; // maks 13
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytBiyoloji; // maks 13
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytEdebiyat; // maks 24
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytTarih1; // maks 10
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double aytCografya1; // maks 6
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double diplomaGrade; // 50 - 100
  // Hesaplamada kullanılacak sayısal değeri belirler
  final bool isPreviousYearPlaced; // Kırık OBP
  // toplam tyt net işlemini yapar
  double get totalTytNet => tytTurkce + tytMatematik + tytSosyal + tytFen;
  // with bilgisini kopyalar
  SimulationInput copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    SimulationField? field,
    // İlgili değeri veya görünüm ayarını belirler
    double? tytTurkce,
    // İlgili değeri veya görünüm ayarını belirler
    double? tytMatematik,
    // İlgili değeri veya görünüm ayarını belirler
    double? tytSosyal,
    // İlgili değeri veya görünüm ayarını belirler
    double? tytFen,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytMatematik,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytFizik,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytKimya,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytBiyoloji,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytEdebiyat,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytTarih1,
    // İlgili değeri veya görünüm ayarını belirler
    double? aytCografya1,
    // İlgili değeri veya görünüm ayarını belirler
    double? diplomaGrade,
    // İlgili değeri veya görünüm ayarını belirler
    bool? isPreviousYearPlaced,
  }) {
    // simulation input nesnesini oluşturur
    return SimulationInput(
      // field bilgisini belirler
      field: field ?? this.field,
      // tyt turkce bilgisini belirler
      tytTurkce: tytTurkce ?? this.tytTurkce,
      // tyt matematik bilgisini belirler
      tytMatematik: tytMatematik ?? this.tytMatematik,
      // tyt sosyal bilgisini belirler
      tytSosyal: tytSosyal ?? this.tytSosyal,
      // tyt fen bilgisini belirler
      tytFen: tytFen ?? this.tytFen,
      // ayt matematik bilgisini belirler
      aytMatematik: aytMatematik ?? this.aytMatematik,
      // ayt fizik bilgisini belirler
      aytFizik: aytFizik ?? this.aytFizik,
      // ayt kimya bilgisini belirler
      aytKimya: aytKimya ?? this.aytKimya,
      // ayt biyoloji bilgisini belirler
      aytBiyoloji: aytBiyoloji ?? this.aytBiyoloji,
      // ayt edebiyat bilgisini belirler
      aytEdebiyat: aytEdebiyat ?? this.aytEdebiyat,
      // ayt tarih1 bilgisini belirler
      aytTarih1: aytTarih1 ?? this.aytTarih1,
      // ayt cografya1 bilgisini belirler
      aytCografya1: aytCografya1 ?? this.aytCografya1,
      // diploma grade bilgisini belirler
      diplomaGrade: diplomaGrade ?? this.diplomaGrade,
      // is previous year placed bilgisini belirler
      isPreviousYearPlaced: isPreviousYearPlaced ?? this.isPreviousYearPlaced,
    );
  }
}
/// Simülasyon hesaplama sonucu
// simulation result bilgilerini veya işlemlerini tutan sınıf
class SimulationResult {
  // simulation result nesnesini oluşturur
  const SimulationResult({
    // field bilgisini zorunlu tutar
    required this.field,
    // tyt score bilgisini zorunlu tutar
    required this.tytScore,
    // field raw score bilgisini zorunlu tutar
    required this.fieldRawScore,
    // obp score bilgisini zorunlu tutar
    required this.obpScore,
    // obp contribution bilgisini zorunlu tutar
    required this.obpContribution,
    // placement score bilgisini zorunlu tutar
    required this.placementScore,
    // disclaimer bilgisini zorunlu tutar
    required this.disclaimer,
    // curriculum year bilgisini zorunlu tutar
    required this.curriculumYear,
  });
  // field bilgisini tutar
  final SimulationField field;
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double tytScore; // TYT Ham Puanı (100 - 500)
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double fieldRawScore; // İlgili Alan Ham Puanı (100 - 500)
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double obpScore; // 250 - 500 arası OBP
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double obpContribution; // Yerleştirmeye eklenen puan (30 - 60 arası)
  // Hesaplamada kullanılacak sayısal değeri belirler
  final double placementScore; // Yerleştirme Puanı (Ham + OBP)
  // Hesaplamada kullanılacak sayısal değeri belirler
  final String disclaimer; // Yasal sınırlılık uyarısı
  // Hesaplamada kullanılacak sayısal değeri belirler
  final int curriculumYear; // Temsili kılavuz yılı (örn. 2026)
}

// Çalışılacak dilleri enum ile sınırlar
enum StudyLanguage { german, english }

// StudyLanguage tipine yeni özellikler ekler
extension StudyLanguageX on StudyLanguage {
  // Dilin Türkçe adını döndürür
  String get label => switch (this) {
    // Almanca seçilirse Almanca yazar
    StudyLanguage.german => 'Almanca',
    // İngilizce seçilirse İngilizce yazar
    StudyLanguage.english => 'İngilizce',
  };
  // Dilin kısa kodunu döndürür
  String get code => switch (this) {
    // Almanca için DE döndürür
    StudyLanguage.german => 'DE',
    // İngilizce için EN döndürür
    StudyLanguage.english => 'EN',
  };
  // Dilin bayrak simgesini döndürür
  String get flag => switch (this) {
    // Almanca için Almanya bayrağı
    StudyLanguage.german => '🇩🇪',
    // İngilizce için İngiltere bayrağı
    StudyLanguage.english => '🇬🇧',
  };
}

// Kelimenin öğrenme aşamalarını tanımlar
enum WordStage { newWord, learning, mastered }

// WordStage tipine yeni özellikler ekler
extension WordStageX on WordStage {
  // Öğrenme aşamasının Türkçe adını verir
  String get label => switch (this) {
    // Yeni kelime aşaması
    WordStage.newWord => 'Yeni',
    // Çalışılan kelime aşaması
    WordStage.learning => 'Çalışılıyor',
    // Öğrenilmiş kelime aşaması
    WordStage.mastered => 'Öğrenildi',
  };
  // Kelimeyi bir sonraki öğrenme aşamasına geçirir
  WordStage get next => switch (this) {
    // Yeni kelimeyi çalışılıyor aşamasına geçirir
    WordStage.newWord => WordStage.learning,
    // Çalışılan kelimeyi öğrenildi aşamasına geçirir
    WordStage.learning => WordStage.mastered,
    // Öğrenilen kelimeyi aynı aşamada tutar
    WordStage.mastered => WordStage.mastered,
  };
}

// Kelimelerin bilgilerini tutan model sınıfı
class VocabularyWord {
  // Constructor, gerekli kelime bilgilerini alır
  const VocabularyWord({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Dil bilgisini zorunlu tutar
    required this.language,
    // Kelime bilgisini zorunlu tutar
    required this.word,
    // Anlam bilgisini zorunlu tutar
    required this.meaning,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
    // Örnek cümle verilmezse boş bırakır
    this.example = '',
    // Aşama verilmezse yeni kelime kabul eder
    this.stage = WordStage.newWord,
    // Tekrar sayısı verilmezse sıfır olur
    this.reviewCount = 0,
    // Son tekrar tarihi verilmezse null olur
    this.lastReviewedAt,
  });
  // Kelimenin ID bilgisini tutar
  final String id;
  // Kelimenin hangi dilde olduğunu tutar
  final StudyLanguage language;
  // Kelimenin kendisini tutar
  final String word;
  // Kelimenin Türkçe anlamını tutar
  final String meaning;
  // Örnek cümleyi tutar
  final String example;
  // Kelimenin öğrenme aşamasını tutar
  final WordStage stage;
  // Kelimenin eklenme tarihini tutar
  final DateTime createdAt;
  // Son tekrar tarihini tutar, null olabilir
  final DateTime? lastReviewedAt;
  // Kelimenin kaç kere tekrarlandığını tutar
  final int reviewCount;
  // Mevcut nesneyi değiştirmeden güncellenmiş kopyasını oluşturur
  VocabularyWord copyWith({
    // Yeni öğrenme aşaması isteğe bağlıdır
    WordStage? stage,
    // Yeni tekrar tarihi isteğe bağlıdır
    DateTime? lastReviewedAt,
    // Yeni tekrar sayısı isteğe bağlıdır
    int? reviewCount,
  }) => VocabularyWord(
    // Eski ID bilgisini korur
    id: id,
    // Dil bilgisini korur
    language: language,
    // Kelimeyi korur
    word: word,
    // Anlamını korur
    meaning: meaning,
    // Örnek cümleyi korur
    example: example,
    // Yeni aşama varsa onu yoksa eskisini kullanır
    stage: stage ?? this.stage,
    // Oluşturulma tarihini korur
    createdAt: createdAt,
    // Yeni tekrar tarihi varsa onu kullanır
    lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    // Yeni tekrar sayısı varsa onu kullanır
    reviewCount: reviewCount ?? this.reviewCount,
  );
  // Nesneyi JSONa çevrilebilecek Map yapısına dönüştürür
  Map<String, dynamic> toJson() => {
    // ID bilgisini kaydeder
    'id': id,
    // Enum dil bilgisinin adını kaydeder
    'language': language.name,
    // Kelimeyi kaydeder
    'word': word,
    // Türkçe anlamını kaydeder
    'meaning': meaning,
    // Örnek cümleyi kaydeder
    'example': example,
    // Enum aşama bilgisinin adını kaydeder
    'stage': stage.name,
    // Tarihi ISO formatında Stringe çevirir
    'createdAt': createdAt.toIso8601String(),
    // Tarih null değilse Stringe çevirir
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    // Tekrar sayısını kaydeder
    'reviewCount': reviewCount,
  };
  // JSONdan gelen Map verisiyle VocabularyWord nesnesi oluşturur
  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
    // JSONdan ID bilgisini String olarak alır
    id: json['id'] as String,
    // Dil adını enum değerine çevirir
    language: StudyLanguage.values.byName(json['language'] as String),
    // Kelime bilgisini alır
    word: json['word'] as String,
    // Anlam bilgisini alır
    meaning: json['meaning'] as String,
    // Örnek yoksa boş String kullanır
    example: (json['example'] as String?) ?? '',
    // Aşama yoksa newWord kullanır
    stage: WordStage.values.byName((json['stage'] as String?) ?? 'newWord'),
    // String tarih bilgisini DateTime tipine çevirir
    createdAt: DateTime.parse(json['createdAt'] as String),
    // Son tekrar tarihi yoksa null döndürür
    lastReviewedAt: json['lastReviewedAt'] == null
        // Tarih yoksa null olur
        ? null
        // Tarih varsa DateTime tipine çevirir
        : DateTime.parse(json['lastReviewedAt'] as String),
    // Tekrar sayısını int yapar, yoksa sıfır kullanır
    reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  );
}

// JSON verilerini dönüştürmek için
import 'dart:convert';
// Verileri cihazda saklamak için
import 'package:shared_preferences/shared_preferences.dart';
// Kelime modelini projeye ekler
import '../models/vocabulary_word.dart';

// Kelime ve hedef işlemlerinin ortak sözleşmesi
abstract class WordRepository {
  // Kayıtlı kelimeleri asenkron getirir
  Future<List<VocabularyWord>> loadWords();
  // Kelime listesini asenkron kaydeder
  Future<void> saveWords(List<VocabularyWord> words);
  // Günlük kelime hedefini getirir
  Future<int> loadDailyGoal();
  // Günlük hedefi kaydeder
  Future<void> saveDailyGoal(int goal);
}

// SharedPreferences ile sözleşmedeki işlemleri uygular
class PreferencesWordRepository implements WordRepository {
  // Cihazda veri okumak ve yazmak için kullanılır
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  // Kelimelerin kaydedileceği anahtar
  static const _wordsKey = 'dil_rotasi_words_v1';
  // Günlük hedefin kaydedileceği anahtar
  static const _goalKey = 'dil_rotasi_daily_goal_v1';
  // Üstteki loadWords metodunu uygular
  @override
  // Kayıtlı kelimeleri asenkron olarak getirir
  Future<List<VocabularyWord>> loadWords() async {
    // Anahtara göre kayıtlı String verisini okur
    final raw = await _prefs.getString(_wordsKey);
    // Kayıt yoksa örnek kelimeleri döndürür
    if (raw == null) return demoWords();
    // JSON metnini listeye çevirir
    final list = jsonDecode(raw) as List<dynamic>;
    // Her JSON verisini VocabularyWord nesnesine çevirip liste yapar
    return list
        .map((json) => VocabularyWord.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Üstteki saveWords metodunu uygular
  @override
  // Kelime listesini cihaza kaydeder
  Future<void> saveWords(List<VocabularyWord> words) async {
    // Kelimeleri önce JSONa sonra Stringe çevirerek kaydeder
    await _prefs.setString(
      _wordsKey,
      jsonEncode(words.map((w) => w.toJson()).toList()),
    );
  }

  // Üstteki loadDailyGoal metodunu uygular
  @override
  // Günlük hedefi getirir kayıt yoksa 5 döndürür
  Future<int> loadDailyGoal() async => (await _prefs.getInt(_goalKey)) ?? 5;
  // Üstteki saveDailyGoal metodunu uygular
  @override
  // Günlük hedefi asenkron kaydeder
  Future<void> saveDailyGoal(int goal) async {
    // Hedefi belirtilen anahtarla cihazda saklar
    await _prefs.setInt(_goalKey, goal);
  }
}

// İlk kullanımda gösterilecek örnek kelimeleri oluşturur
List<VocabularyWord> demoWords() {
  // Şu anki tarih ve saati alır
  final now = DateTime.now();
  // Record yapısıyla kelimenin dilini adını anlamını örneğini ve aşamasını tutar
  final examples = <(StudyLanguage, String, String, String, WordStage)>[
    // Almanca imkân kelimesi, öğreniliyor
    (
      StudyLanguage.german,
      'die Möglichkeit',
      'olasılık, imkân',
      'Ich habe eine neue Möglichkeit.',
      WordStage.learning,
    ),
    // Almanca güvenilir kelimesi, yeni
    (
      StudyLanguage.german,
      'zuverlässig',
      'güvenilir',
      'Er ist sehr zuverlässig.',
      WordStage.newWord,
    ),
    // Almanca deneyim kelimesi, öğreniliyor
    (
      StudyLanguage.german,
      'die Erfahrung',
      'deneyim',
      'Ich habe zwei Jahre Erfahrung.',
      WordStage.learning,
    ),
    // Almanca araç kelimesi, öğrenilmiş
    (
      StudyLanguage.german,
      'das Werkzeug',
      'alet, araç',
      'Das Werkzeug liegt auf dem Tisch.',
      WordStage.mastered,
    ),
    // Almanca anlamak fiili, yeni
    (
      StudyLanguage.german,
      'verstehen',
      'anlamak',
      'Ich verstehe die Frage.',
      WordStage.newWord,
    ),
    // Almanca işe başvurmak fiili, yeni
    (
      StudyLanguage.german,
      'sich bewerben',
      'işe başvurmak',
      'Ich möchte mich bewerben.',
      WordStage.newWord,
    ),
    // İngilizce fırsat kelimesi, öğreniliyor
    (
      StudyLanguage.english,
      'opportunity',
      'fırsat',
      'This is a great opportunity.',
      WordStage.learning,
    ),
    // İngilizce güvenilir kelimesi, yeni
    (
      StudyLanguage.english,
      'reliable',
      'güvenilir',
      'The system is reliable.',
      WordStage.newWord,
    ),
    // İngilizce geliştirmek fiili, öğreniliyor
    (
      StudyLanguage.english,
      'improve',
      'geliştirmek',
      'I want to improve my English.',
      WordStage.learning,
    ),
    // İngilizce deneyim kelimesi, öğrenilmiş
    (
      StudyLanguage.english,
      'experience',
      'deneyim',
      'I have work experience.',
      WordStage.mastered,
    ),
    // İngilizce başarmak fiili, yeni
    (
      StudyLanguage.english,
      'achieve',
      'başarmak',
      'We can achieve our goals.',
      WordStage.newWord,
    ),
    // İngilizce arıza gidermek fiili, yeni
    (
      StudyLanguage.english,
      'troubleshoot',
      'arıza gidermek',
      'I can troubleshoot the PLC.',
      WordStage.newWord,
    ),
  ];
  // Örneklerden VocabularyWord listesi oluşturur
  return [
    // Listedeki bütün örnekleri sırayla dolaşır
    for (var index = 0; index < examples.length; index++)
      // Her örnekten yeni kelime nesnesi oluşturur
      VocabularyWord(
        // İndekse göre örnek ID oluşturur
        id: 'sample-$index',
        // Record içindeki ilk değerden dili alır
        language: examples[index].$1,
        // İkinci değerden kelimeyi alır
        word: examples[index].$2,
        // Üçüncü değerden Türkçe anlamını alır
        meaning: examples[index].$3,
        // Dördüncü değerden örnek cümleyi alır
        example: examples[index].$4,
        // Beşinci değerden öğrenme aşamasını alır
        stage: examples[index].$5,
        // Her kelimeye farklı geçmiş kayıt tarihi verir
        createdAt: now.subtract(Duration(days: index + 1)),
      ),
  ];
}

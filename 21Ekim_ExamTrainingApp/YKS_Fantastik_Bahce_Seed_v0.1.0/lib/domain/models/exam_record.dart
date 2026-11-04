// net calculator dosyasını kullanıma ekler
import '../exam/net_calculator.dart';
// deneme score bilgilerini veya işlemlerini tutan sınıf
class ExamScore {
  // deneme score nesnesini oluşturur
  const ExamScore({
    // ID bilgisini zorunlu tutar
    required this.id,
    // deneme ID bilgisini zorunlu tutar
    required this.examId,
    // ders ID bilgisini zorunlu tutar
    required this.subjectId,
    // ders adı bilgisini zorunlu tutar
    required this.subjectName,
    // doğru sayısı bilgisini zorunlu tutar
    required this.correct,
    // yanlış sayısı bilgisini zorunlu tutar
    required this.wrong,
    // boş sayısı bilgisini zorunlu tutar
    required this.blank,
    // net bilgisini zorunlu tutar
    required this.net,
  });
  // ID bilgisini tutar
  final String id;
  // deneme ID bilgisini tutar
  final String examId;
  // ders ID bilgisini tutar
  final String subjectId;
  // ders adı bilgisini tutar
  final String subjectName;
  // doğru sayısı bilgisini tutar
  final int correct;
  // yanlış sayısı bilgisini tutar
  final int wrong;
  // boş sayısı bilgisini tutar
  final int blank;
  // net bilgisini tutar
  final double net;
  // calculate işlemini yapar
  static ExamScore calculate({
    // ID bilgisini zorunlu tutar
    required String id,
    // deneme ID bilgisini zorunlu tutar
    required String examId,
    // ders ID bilgisini zorunlu tutar
    required String subjectId,
    // ders adı bilgisini zorunlu tutar
    required String subjectName,
    // doğru sayısı bilgisini zorunlu tutar
    required int correct,
    // yanlış sayısı bilgisini zorunlu tutar
    required int wrong,
    // soru sayısı bilgisini zorunlu tutar
    required int questionCount,
  }) {
    // net bilgisini hesaplayıp saklar
    final net = NetCalculator.calculate(correct: correct, wrong: wrong);
    // boş sayısı değerini belirli aralıkta sınırlar
    final blank = (questionCount - correct - wrong).clamp(0, questionCount);
    // deneme score nesnesini oluşturur
    return ExamScore(
      // ID bilgisini belirler
      id: id,
      // Deneme ID bilgisini belirler
      examId: examId,
      // Ders ID bilgisini belirler
      subjectId: subjectId,
      // ders adı bilgisini belirler
      subjectName: subjectName,
      // Doğru sayısını belirler
      correct: correct,
      // Yanlış sayısını belirler
      wrong: wrong,
      // Boş sayısını belirler
      blank: blank,
      // Neti belirler
      net: net,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "exam_id': examId" metnini kullanır
      'exam_id': examId,
      // "subject_id': subjectId" metnini kullanır
      'subject_id': subjectId,
      // "subject_name': subjectName" metnini kullanır
      'subject_name': subjectName,
      // "correct': correct" metnini kullanır
      'correct': correct,
      // "wrong': wrong" metnini kullanır
      'wrong': wrong,
      // "blank': blank" metnini kullanır
      'blank': blank,
      // "net': net" metnini kullanır
      'net': net,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory ExamScore.fromMap(Map<String, dynamic> map) {
    // deneme score nesnesini oluşturur
    return ExamScore(
      // ID bilgisini belirler
      id: map['id'] as String,
      // Deneme ID bilgisini belirler
      examId: map['exam_id'] as String,
      // Ders ID bilgisini belirler
      subjectId: map['subject_id'] as String,
      // ders adı bilgisini belirler
      subjectName: map['subject_name'] as String,
      // Doğru sayısını belirler
      correct: map['correct'] as int? ?? 0,
      // Yanlış sayısını belirler
      wrong: map['wrong'] as int? ?? 0,
      // Boş sayısını belirler
      blank: map['blank'] as int? ?? 0,
      // Neti belirler
      net: (map['net'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
// deneme session bilgilerini veya işlemlerini tutan sınıf
class ExamSession {
  // deneme session nesnesini oluşturur
  const ExamSession({
    // ID bilgisini zorunlu tutar
    required this.id,
    // aşama bilgisini zorunlu tutar
    required this.stage, // 'TYT' or 'AYT'
    // başlık bilgisini zorunlu tutar
    required this.title,
    // occurred at bilgisini zorunlu tutar
    required this.occurredAt,
    // scope bilgisini isteğe bağlı alır
    this.scope = 'general', // 'general' or 'branch'
    // toplam correct bilgisini isteğe bağlı alır
    this.totalCorrect = 0,
    // toplam wrong bilgisini isteğe bağlı alır
    this.totalWrong = 0,
    // toplam blank bilgisini isteğe bağlı alır
    this.totalBlank = 0,
    // toplam net bilgisini isteğe bağlı alır
    this.totalNet = 0.0,
    // scores bilgisini isteğe bağlı alır
    this.scores = const [],
  });
  // ID bilgisini tutar
  final String id;
  // aşama bilgisini tutar
  final String stage;
  // başlık bilgisini tutar
  final String title;
  // occurred at bilgisini tutar
  final DateTime occurredAt;
  // scope bilgisini tutar
  final String scope;
  // toplam correct bilgisini tutar
  final int totalCorrect;
  // toplam wrong bilgisini tutar
  final int totalWrong;
  // toplam blank bilgisini tutar
  final int totalBlank;
  // toplam net bilgisini tutar
  final double totalNet;
  // scores bilgisini tutar
  final List<ExamScore> scores;
  // with bilgisini kopyalar
  ExamSession copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? id,
    // İlgili değeri veya görünüm ayarını belirler
    String? stage,
    // İlgili değeri veya görünüm ayarını belirler
    String? title,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? occurredAt,
    // İlgili değeri veya görünüm ayarını belirler
    String? scope,
    // İlgili değeri veya görünüm ayarını belirler
    int? totalCorrect,
    // İlgili değeri veya görünüm ayarını belirler
    int? totalWrong,
    // İlgili değeri veya görünüm ayarını belirler
    int? totalBlank,
    // İlgili değeri veya görünüm ayarını belirler
    double? totalNet,
    // Değerleri karşılaştırır
    List<ExamScore>? scores,
  }) {
    // deneme session nesnesini oluşturur
    return ExamSession(
      // ID bilgisini belirler
      id: id ?? this.id,
      // Öğrenme veya sınav aşamasını belirler
      stage: stage ?? this.stage,
      // Başlığı belirler
      title: title ?? this.title,
      // occurred at bilgisini belirler
      occurredAt: occurredAt ?? this.occurredAt,
      // scope bilgisini belirler
      scope: scope ?? this.scope,
      // toplam correct bilgisini belirler
      totalCorrect: totalCorrect ?? this.totalCorrect,
      // toplam wrong bilgisini belirler
      totalWrong: totalWrong ?? this.totalWrong,
      // toplam blank bilgisini belirler
      totalBlank: totalBlank ?? this.totalBlank,
      // toplam net bilgisini belirler
      totalNet: totalNet ?? this.totalNet,
      // scores bilgisini belirler
      scores: scores ?? this.scores,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "stage': stage" metnini kullanır
      'stage': stage,
      // "title': title" metnini kullanır
      'title': title,
      // "occurred_at': occurredAt.toIso8601String()" metnini kullanır
      'occurred_at': occurredAt.toIso8601String(),
      // "scope': scope" metnini kullanır
      'scope': scope,
      // "total_correct': totalCorrect" metnini kullanır
      'total_correct': totalCorrect,
      // "total_wrong': totalWrong" metnini kullanır
      'total_wrong': totalWrong,
      // "total_blank': totalBlank" metnini kullanır
      'total_blank': totalBlank,
      // "total_net': totalNet" metnini kullanır
      'total_net': totalNet,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory ExamSession.fromMap(
    // Değerleri karşılaştırır
    Map<String, dynamic> map, {
    // scores değerini sabit olarak belirler
    List<ExamScore> scores = const [],
  }) {
    // deneme session nesnesini oluşturur
    return ExamSession(
      // ID bilgisini belirler
      id: map['id'] as String,
      // Öğrenme veya sınav aşamasını belirler
      stage: map['stage'] as String,
      // Başlığı belirler
      title: map['title'] as String,
      // occurred at bilgisini belirler
      occurredAt: DateTime.parse(map['occurred_at'] as String),
      // scope bilgisini belirler
      scope: map['scope'] as String? ?? 'general',
      // toplam correct bilgisini belirler
      totalCorrect: map['total_correct'] as int? ?? 0,
      // toplam wrong bilgisini belirler
      totalWrong: map['total_wrong'] as int? ?? 0,
      // toplam blank bilgisini belirler
      totalBlank: map['total_blank'] as int? ?? 0,
      // toplam net bilgisini belirler
      totalNet: (map['total_net'] as num?)?.toDouble() ?? 0.0,
      // scores bilgisini belirler
      scores: scores,
    );
  }
}

// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum TopicStatus {
  // İlgili değeri veya görünüm ayarını belirler
  notStarted,
  // İlgili değeri veya görünüm ayarını belirler
  inProgress,
  // İlgili değeri veya görünüm ayarını belirler
  completed;
  // etiket işlemini yapar
  String get label {
    // Değere göre uygun durumu seçer
    switch (this) {
      // konu status.not started durumu için çalışır
      case TopicStatus.notStarted:
        // "Eksik" metnini kullanır
        return 'Eksik';
      // konu status.in ilerleme durumu için çalışır
      case TopicStatus.inProgress:
        // "Çalışılıyor" metnini kullanır
        return 'Çalışılıyor';
      // konu status.completed durumu için çalışır
      case TopicStatus.completed:
        // "Tamamlandı" metnini kullanır
        return 'Tamamlandı';
    }
  }
}
// ders bilgilerini veya işlemlerini tutan sınıf
class Subject {
  // ders nesnesini oluşturur
  const Subject({
    // ID bilgisini zorunlu tutar
    required this.id,
    // aşama bilgisini zorunlu tutar
    required this.stage,
    // ad bilgisini zorunlu tutar
    required this.name,
    // sıra numarası bilgisini zorunlu tutar
    required this.orderIndex,
    // soru sayısı bilgisini isteğe bağlı alır
    this.questionCount = 40,
  });
  // ID bilgisini tutar
  final String id;
  // Hesaplamada kullanılacak sayısal değeri belirler
  final String stage; // 'TYT' or 'AYT'
  // ad bilgisini tutar
  final String name;
  // sıra numarası bilgisini tutar
  final int orderIndex;
  // soru sayısı bilgisini tutar
  final int questionCount;
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "stage': stage" metnini kullanır
      'stage': stage,
      // "name': name" metnini kullanır
      'name': name,
      // "order_index': orderIndex" metnini kullanır
      'order_index': orderIndex,
      // "question_count': questionCount" metnini kullanır
      'question_count': questionCount,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory Subject.fromMap(Map<String, dynamic> map) {
    // ders nesnesini oluşturur
    return Subject(
      // ID bilgisini belirler
      id: map['id'] as String,
      // Öğrenme veya sınav aşamasını belirler
      stage: map['stage'] as String,
      // ad bilgisini belirler
      name: map['name'] as String,
      // sıra numarası bilgisini belirler
      orderIndex: map['order_index'] as int? ?? 0,
      // Soru sayısını belirler
      questionCount: map['question_count'] as int? ?? 40,
    );
  }
}
// konu bilgilerini veya işlemlerini tutan sınıf
class Topic {
  // konu nesnesini oluşturur
  const Topic({
    // ID bilgisini zorunlu tutar
    required this.id,
    // ders ID bilgisini zorunlu tutar
    required this.subjectId,
    // ad bilgisini zorunlu tutar
    required this.name,
    // sıra numarası bilgisini zorunlu tutar
    required this.orderIndex,
    // curriculum year bilgisini isteğe bağlı alır
    this.curriculumYear = 2026,
  });
  // ID bilgisini tutar
  final String id;
  // ders ID bilgisini tutar
  final String subjectId;
  // ad bilgisini tutar
  final String name;
  // sıra numarası bilgisini tutar
  final int orderIndex;
  // curriculum year bilgisini tutar
  final int curriculumYear;
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "subject_id': subjectId" metnini kullanır
      'subject_id': subjectId,
      // "name': name" metnini kullanır
      'name': name,
      // "order_index': orderIndex" metnini kullanır
      'order_index': orderIndex,
      // "curriculum_year': curriculumYea" metnini kullanır
      'curriculum_year': curriculumYear,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory Topic.fromMap(Map<String, dynamic> map) {
    // konu nesnesini oluşturur
    return Topic(
      // ID bilgisini belirler
      id: map['id'] as String,
      // Ders ID bilgisini belirler
      subjectId: map['subject_id'] as String,
      // ad bilgisini belirler
      name: map['name'] as String,
      // sıra numarası bilgisini belirler
      orderIndex: map['order_index'] as int? ?? 0,
      // curriculum year bilgisini belirler
      curriculumYear: map['curriculum_year'] as int? ?? 2026,
    );
  }
}
// konu ilerleme bilgilerini veya işlemlerini tutan sınıf
class TopicProgress {
  // konu ilerleme nesnesini oluşturur
  const TopicProgress({
    // konu ID bilgisini zorunlu tutar
    required this.topicId,
    // durum bilgisini isteğe bağlı alır
    this.status = TopicStatus.notStarted,
    // çözülen soru sayısı bilgisini isteğe bağlı alır
    this.answeredCount = 0,
    // last studied at bilgisini isteğe bağlı alır
    this.lastStudiedAt,
  });
  // konu ID bilgisini tutar
  final String topicId;
  // durum bilgisini tutar
  final TopicStatus status;
  // çözülen soru sayısı bilgisini tutar
  final int answeredCount;
  // last studied at bilgisini tutar
  final DateTime? lastStudiedAt;
  // with bilgisini kopyalar
  TopicProgress copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? topicId,
    // İlgili değeri veya görünüm ayarını belirler
    TopicStatus? status,
    // İlgili değeri veya görünüm ayarını belirler
    int? answeredCount,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? lastStudiedAt,
  }) {
    // konu ilerleme nesnesini oluşturur
    return TopicProgress(
      // Konu ID bilgisini belirler
      topicId: topicId ?? this.topicId,
      // durum bilgisini belirler
      status: status ?? this.status,
      // çözülen soru sayısı bilgisini belirler
      answeredCount: answeredCount ?? this.answeredCount,
      // last studied at bilgisini belirler
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "topic_id': topicId" metnini kullanır
      'topic_id': topicId,
      // "status': status.name" metnini kullanır
      'status': status.name,
      // "answered_count': answeredCount" metnini kullanır
      'answered_count': answeredCount,
      // "last_studied_at': lastStudiedAt?.toIso8601S…" metnini kullanır
      'last_studied_at': lastStudiedAt?.toIso8601String(),
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory TopicProgress.fromMap(Map<String, dynamic> map) {
    // konu ilerleme nesnesini oluşturur
    return TopicProgress(
      // Konu ID bilgisini belirler
      topicId: map['topic_id'] as String,
      // durum bilgisini belirler
      status: TopicStatus.values.firstWhere(
        // Yeni değer veya liste oluşturur
        (e) => e.name == map['status'],
        // or else bilgisini belirler
        orElse: () => TopicStatus.notStarted,
      ),
      // çözülen soru sayısı bilgisini belirler
      answeredCount: map['answered_count'] as int? ?? 0,
      // last studied at bilgisini belirler
      lastStudiedAt: map['last_studied_at'] != null
          // Koşul doğruysa bu değeri kullanır
          ? DateTime.tryParse(map['last_studied_at'] as String)
          // Koşul yanlışsa bu değeri kullanır
          : null,
    );
  }
}

// daily görev bilgilerini veya işlemlerini tutan sınıf
class DailyTask {
  // daily görev nesnesini oluşturur
  const DailyTask({
    // ID bilgisini zorunlu tutar
    required this.id,
    // scheduled tarih bilgisini zorunlu tutar
    required this.scheduledDate,
    // açıklama bilgisini zorunlu tutar
    required this.description,
    // ders ID bilgisini isteğe bağlı alır
    this.subjectId,
    // konu ID bilgisini isteğe bağlı alır
    this.topicId,
    // hedef soru sayısı bilgisini isteğe bağlı alır
    this.targetQuestions = 0,
    // tamamlanma bilgisi bilgisini isteğe bağlı alır
    this.isDone = false,
  });
  // ID bilgisini tutar
  final String id;
  // scheduled tarih bilgisini tutar
  final DateTime scheduledDate;
  // açıklama bilgisini tutar
  final String description;
  // ders ID bilgisini tutar
  final String? subjectId;
  // konu ID bilgisini tutar
  final String? topicId;
  // hedef soru sayısı bilgisini tutar
  final int targetQuestions;
  // tamamlanma bilgisi bilgisini tutar
  final bool isDone;
  // with bilgisini kopyalar
  DailyTask copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? id,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? scheduledDate,
    // İlgili değeri veya görünüm ayarını belirler
    String? description,
    // İlgili değeri veya görünüm ayarını belirler
    String? subjectId,
    // İlgili değeri veya görünüm ayarını belirler
    String? topicId,
    // İlgili değeri veya görünüm ayarını belirler
    int? targetQuestions,
    // İlgili değeri veya görünüm ayarını belirler
    bool? isDone,
  }) {
    // daily görev nesnesini oluşturur
    return DailyTask(
      // ID bilgisini belirler
      id: id ?? this.id,
      // scheduled tarih bilgisini belirler
      scheduledDate: scheduledDate ?? this.scheduledDate,
      // açıklama bilgisini belirler
      description: description ?? this.description,
      // Ders ID bilgisini belirler
      subjectId: subjectId ?? this.subjectId,
      // Konu ID bilgisini belirler
      topicId: topicId ?? this.topicId,
      // Hedef soru sayısını belirler
      targetQuestions: targetQuestions ?? this.targetQuestions,
      // tamamlanma bilgisi bilgisini belirler
      isDone: isDone ?? this.isDone,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "scheduled_date':" metnini kullanır
      'scheduled_date':
          // "${scheduledDate.year.toString().padLeft(4, …" metnini kullanır
          '${scheduledDate.year.toString().padLeft(4, '0')}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}',
      // "description': description" metnini kullanır
      'description': description,
      // "subject_id': subjectId" metnini kullanır
      'subject_id': subjectId,
      // "topic_id': topicId" metnini kullanır
      'topic_id': topicId,
      // "target_questions': targetQuestions" metnini kullanır
      'target_questions': targetQuestions,
      // "is_done': isDone ? 1 : 0" metnini kullanır
      'is_done': isDone ? 1 : 0,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory DailyTask.fromMap(Map<String, dynamic> map) {
    // daily görev nesnesini oluşturur
    return DailyTask(
      // ID bilgisini belirler
      id: map['id'] as String,
      // scheduled tarih bilgisini belirler
      scheduledDate: DateTime.parse(map['scheduled_date'] as String),
      // açıklama bilgisini belirler
      description: map['description'] as String,
      // Ders ID bilgisini belirler
      subjectId: map['subject_id'] as String?,
      // Konu ID bilgisini belirler
      topicId: map['topic_id'] as String?,
      // Hedef soru sayısını belirler
      targetQuestions: map['target_questions'] as int? ?? 0,
      // tamamlanma bilgisi bilgisini belirler
      isDone: (map['is_done'] as int?) == 1,
    );
  }
}

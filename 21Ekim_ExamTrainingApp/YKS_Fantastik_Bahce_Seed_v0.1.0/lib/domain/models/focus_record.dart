// focus session bilgilerini veya işlemlerini tutan sınıf
class FocusSession {
  // focus session nesnesini oluşturur
  const FocusSession({
    // ID bilgisini zorunlu tutar
    required this.id,
    // başlangıç zamanı bilgisini zorunlu tutar
    required this.startedAt,
    // saniye cinsinden süre bilgisini zorunlu tutar
    required this.durationSeconds,
    // elapsed seconds bilgisini zorunlu tutar
    required this.elapsedSeconds,
    // ders ID bilgisini isteğe bağlı alır
    this.subjectId,
    // tamamlananlar bilgisini isteğe bağlı alır
    this.completed = false,
  });
  // ID bilgisini tutar
  final String id;
  // başlangıç zamanı bilgisini tutar
  final DateTime startedAt;
  // saniye cinsinden süre bilgisini tutar
  final int durationSeconds;
  // elapsed seconds bilgisini tutar
  final int elapsedSeconds;
  // ders ID bilgisini tutar
  final String? subjectId;
  // tamamlananlar bilgisini tutar
  final bool completed;
  // with bilgisini kopyalar
  FocusSession copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? id,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? startedAt,
    // İlgili değeri veya görünüm ayarını belirler
    int? durationSeconds,
    // İlgili değeri veya görünüm ayarını belirler
    int? elapsedSeconds,
    // İlgili değeri veya görünüm ayarını belirler
    String? subjectId,
    // İlgili değeri veya görünüm ayarını belirler
    bool? completed,
  }) {
    // focus session nesnesini oluşturur
    return FocusSession(
      // ID bilgisini belirler
      id: id ?? this.id,
      // başlangıç zamanı bilgisini belirler
      startedAt: startedAt ?? this.startedAt,
      // saniye cinsinden süre bilgisini belirler
      durationSeconds: durationSeconds ?? this.durationSeconds,
      // elapsed seconds bilgisini belirler
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      // Ders ID bilgisini belirler
      subjectId: subjectId ?? this.subjectId,
      // tamamlananlar bilgisini belirler
      completed: completed ?? this.completed,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "started_at': startedAt.toIso8601String()" metnini kullanır
      'started_at': startedAt.toIso8601String(),
      // "duration_seconds': durationSeconds" metnini kullanır
      'duration_seconds': durationSeconds,
      // "elapsed_seconds': elapsedSeconds" metnini kullanır
      'elapsed_seconds': elapsedSeconds,
      // "subject_id': subjectId" metnini kullanır
      'subject_id': subjectId,
      // "completed': completed ? 1 : 0" metnini kullanır
      'completed': completed ? 1 : 0,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory FocusSession.fromMap(Map<String, dynamic> map) {
    // focus session nesnesini oluşturur
    return FocusSession(
      // ID bilgisini belirler
      id: map['id'] as String,
      // başlangıç zamanı bilgisini belirler
      startedAt: DateTime.parse(map['started_at'] as String),
      // saniye cinsinden süre bilgisini belirler
      durationSeconds: map['duration_seconds'] as int? ?? 1500,
      // elapsed seconds bilgisini belirler
      elapsedSeconds: map['elapsed_seconds'] as int? ?? 0,
      // Ders ID bilgisini belirler
      subjectId: map['subject_id'] as String?,
      // tamamlananlar bilgisini belirler
      completed: (map['completed'] as int?) == 1,
    );
  }
}

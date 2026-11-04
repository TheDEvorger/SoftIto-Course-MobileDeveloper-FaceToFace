// müfredat dosyasını kullanıma ekler
import 'curriculum.dart';
/// MEB müfredatına dayalı doğrulanmış konu düğümü ve önkoşul modeli.
// konu node info bilgilerini veya işlemlerini tutan sınıf
class TopicNodeInfo {
  // konu node info nesnesini oluşturur
  const TopicNodeInfo({
    // konu ID bilgisini zorunlu tutar
    required this.topicId,
    // konu adı bilgisini zorunlu tutar
    required this.topicName,
    // ders ID bilgisini zorunlu tutar
    required this.subjectId,
    // ders adı bilgisini zorunlu tutar
    required this.subjectName,
    // aşama bilgisini zorunlu tutar
    required this.stage,
    // prerequisite ids bilgisini zorunlu tutar
    required this.prerequisiteIds,
    // dependent ids bilgisini isteğe bağlı alır
    this.dependentIds = const [],
    // durum bilgisini isteğe bağlı alır
    this.status = TopicStatus.notStarted,
    // çözülen soru sayısı bilgisini isteğe bağlı alır
    this.answeredCount = 0,
    // last studied at bilgisini isteğe bağlı alır
    this.lastStudiedAt,
    // hazır olma durumu bilgisini isteğe bağlı alır
    this.isReady = true,
    // needs review bilgisini isteğe bağlı alır
    this.needsReview = false,
    // review message bilgisini isteğe bağlı alır
    this.reviewMessage,
    // x konumu bilgisini isteğe bağlı alır
    this.x = 0.0,
    // y konumu bilgisini isteğe bağlı alır
    this.y = 0.0,
  });
  // konu ID bilgisini tutar
  final String topicId;
  // konu adı bilgisini tutar
  final String topicName;
  // ders ID bilgisini tutar
  final String subjectId;
  // ders adı bilgisini tutar
  final String subjectName;
  // aşama bilgisini tutar
  final String stage;
  // prerequisite ids bilgisini tutar
  final List<String> prerequisiteIds;
  // dependent ids bilgisini tutar
  final List<String> dependentIds;
  // durum bilgisini tutar
  final TopicStatus status;
  // çözülen soru sayısı bilgisini tutar
  final int answeredCount;
  // last studied at bilgisini tutar
  final DateTime? lastStudiedAt;
  // hazır olma durumu bilgisini tutar
  final bool isReady;
  // needs review bilgisini tutar
  final bool needsReview;
  // review message bilgisini tutar
  final String? reviewMessage;
  /// Harita grafiğindeki koordinatlar
  // x konumu bilgisini tutar
  final double x;
  // y konumu bilgisini tutar
  final double y;
  // with bilgisini kopyalar
  TopicNodeInfo copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? topicId,
    // İlgili değeri veya görünüm ayarını belirler
    String? topicName,
    // İlgili değeri veya görünüm ayarını belirler
    String? subjectId,
    // İlgili değeri veya görünüm ayarını belirler
    String? subjectName,
    // İlgili değeri veya görünüm ayarını belirler
    String? stage,
    // Değerleri karşılaştırır
    List<String>? prerequisiteIds,
    // Değerleri karşılaştırır
    List<String>? dependentIds,
    // İlgili değeri veya görünüm ayarını belirler
    TopicStatus? status,
    // İlgili değeri veya görünüm ayarını belirler
    int? answeredCount,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? lastStudiedAt,
    // İlgili değeri veya görünüm ayarını belirler
    bool? isReady,
    // İlgili değeri veya görünüm ayarını belirler
    bool? needsReview,
    // İlgili değeri veya görünüm ayarını belirler
    String? reviewMessage,
    // İlgili değeri veya görünüm ayarını belirler
    double? x,
    // İlgili değeri veya görünüm ayarını belirler
    double? y,
  }) {
    // konu node info nesnesini oluşturur
    return TopicNodeInfo(
      // Konu ID bilgisini belirler
      topicId: topicId ?? this.topicId,
      // konu adı bilgisini belirler
      topicName: topicName ?? this.topicName,
      // Ders ID bilgisini belirler
      subjectId: subjectId ?? this.subjectId,
      // ders adı bilgisini belirler
      subjectName: subjectName ?? this.subjectName,
      // Öğrenme veya sınav aşamasını belirler
      stage: stage ?? this.stage,
      // prerequisite ids bilgisini belirler
      prerequisiteIds: prerequisiteIds ?? this.prerequisiteIds,
      // dependent ids bilgisini belirler
      dependentIds: dependentIds ?? this.dependentIds,
      // durum bilgisini belirler
      status: status ?? this.status,
      // çözülen soru sayısı bilgisini belirler
      answeredCount: answeredCount ?? this.answeredCount,
      // last studied at bilgisini belirler
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      // hazır olma durumu bilgisini belirler
      isReady: isReady ?? this.isReady,
      // needs review bilgisini belirler
      needsReview: needsReview ?? this.needsReview,
      // review message bilgisini belirler
      reviewMessage: reviewMessage ?? this.reviewMessage,
      // x konumu bilgisini belirler
      x: x ?? this.x,
      // y konumu bilgisini belirler
      y: y ?? this.y,
    );
  }
}

// Bir ahdin bağlı vazifelerini, hedef gününü ve bitişini tutar
class Pact {
  // Pact nesnesinin başlangıç bilgilerini alır
  const Pact({
    // ID parametresini zorunlu tutar
    required this.id,
    // başlık parametresini zorunlu tutar
    required this.title,
    // vazife ids parametresini zorunlu tutar
    required this.habitIds,
    // hedef days parametresini zorunlu tutar
    required this.goalDays,
    // started at parametresini zorunlu tutar
    required this.startedAt,
    // completed at için isteğe bağlı başlangıç değeri alır
    this.completedAt,
  });
  // Kaydı diğerlerinden ayıran IDyi tutar
  final String id;
  // Başlık metnini tutar
  final String title;
  // Ahde bağlı vazifelerin ID listesini tutar
  final List<String> habitIds;
  // Ahdin hedef gün sayısını tutar
  final int goalDays;
  // Ahdin başlangıç tarihini tutar
  final DateTime startedAt;
  // Ahdin tamamlanma tarihini tutar, null olabilir
  final DateTime? completedAt;
  // Ahit tamamlanma tarihi varsa true döndürür
  bool get isCompleted => completedAt != null;
  // Ahdin tamamlanma tarihini ekleyerek yeni bir Pact döndürür
  Pact complete(DateTime at) => Pact(
        // Kaydın benzersiz kimliğini belirler
        id: id,
        // başlık alanına gelen değeri kullanır
        title: title,
        // Ahdin bağlı olduğu vazife IDlerini aktarır
        habitIds: habitIds,
        // Ahdin hedef gün sayısını aktarır
        goalDays: goalDays,
        // Ahdin başladığı tarihi belirler
        startedAt: startedAt,
        // Ahdin tamamlanma tarihini kaydeder
        completedAt: at,
      );
  // Nesnenin alanlarını JSONa uygun Map biçimine çevirir
  Map<String, dynamic> toJson() => {
        // Kayıt kimliğini JSON alanına yazar
        'id': id,
        // Başlığı JSON alanına yazar
        'title': title,
        // Bağlı vazifelerin kimliklerini JSON alanına aktarır
        'habitIds': habitIds,
        // Ahit hedefini JSON alanına yazar
        'goalDays': goalDays,
        // Ahit başlangıcını ISO tarih biçiminde yazar
        'startedAt': startedAt.toIso8601String(),
        // Ahit tamamlanma tarihini varsa ISO biçiminde yazar
        'completedAt': completedAt?.toIso8601String(),
      };
  // JSON alanlarını okuyarak yeni model nesnesi oluşturur
  factory Pact.fromJson(Map<String, dynamic> json) => Pact(
        // Kaydın benzersiz kimliğini belirler
        id: json['id'] as String,
        // başlık alanına gelen değeri kullanır
        title: json['title'] as String? ?? '',
        // Ahdin bağlı olduğu vazife IDlerini aktarır
        habitIds: (json['habitIds'] as List<dynamic>? ?? []).cast<String>(),
        // Ahdin hedef gün sayısını aktarır
        goalDays: (json['goalDays'] as num?)?.toInt() ?? 7,
        // Ahdin başladığı tarihi belirler
        startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ??
            // Tarih çözümlenemezse güncel zamanı kullanır
            DateTime.now(),
        // Ahdin tamamlanma tarihini kaydeder
        completedAt: DateTime.tryParse(json['completedAt'] as String? ?? ''),
      );
}

// Bir vazifenin adı, zorluğu ve tamamlanan tarihlerini tutar
class Habit {
  // Habit nesnesinin başlangıç bilgilerini alır
  const Habit({
    // ID parametresini zorunlu tutar
    required this.id,
    // name parametresini zorunlu tutar
    required this.name,
    // description parametresini zorunlu tutar
    required this.description,
    // difficulty parametresini zorunlu tutar
    required this.difficulty,
    // created at parametresini zorunlu tutar
    required this.createdAt,
    // completed tarihler parametresini zorunlu tutar
    required this.completedDates,
    // archived için isteğe bağlı başlangıç değeri alır
    this.archived = false,
  });
  // Kaydı diğerlerinden ayıran IDyi tutar
  final String id;
  // Ad bilgisini tutar
  final String name;
  // Açıklama metnini tutar
  final String description;
  // Vazifenin zorluk seviyesini tutar
  final int difficulty;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
  // Vazifenin tamamlandığı günlerin anahtarlarını tutar
  final List<String> completedDates;
  // Vazifenin arşivde olup olmadığını tutar
  final bool archived;
  // Verilen günün tamamlanmış tarihler içinde bulunup bulunmadığını kontrol eder
  bool completedOn(String day) => completedDates.contains(day);
  // Mevcut nesneyi değiştirmeden seçilen alanlarla yeni kopya oluşturur
  Habit copyWith({
    // Ad bilgisini alır, verilmezse null olabilir
    String? name,
    // Açıklama metnini alır, verilmezse null olabilir
    String? description,
    // Vazifenin zorluk seviyesini alır, verilmezse null olabilir
    int? difficulty,
    // Vazifenin tamamlandığı günlerin anahtarlarını alır, verilmezse null olabilir
    List<String>? completedDates,
    // Vazifenin arşivde olup olmadığını alır, verilmezse null olabilir
    bool? archived,
  }) =>
      // Yeni Habit nesnesi oluşturur
      Habit(
        // Kaydın benzersiz kimliğini belirler
        id: id,
        // Vazifenin veya kişiliğin adını belirler
        name: name ?? this.name,
        // Vazifenin veya önerinin açıklamasını belirler
        description: description ?? this.description,
        // Vazifenin zorluk derecesini belirler
        difficulty: difficulty ?? this.difficulty,
        // Oluşturulma tarihini kaydeder
        createdAt: createdAt,
        // Vazifenin tamamlandığı günleri aktarır
        completedDates: completedDates ?? this.completedDates,
        // Vazifenin arşivde olup olmadığını belirtir
        archived: archived ?? this.archived,
      );
  // Nesnenin alanlarını JSONa uygun Map biçimine çevirir
  Map<String, dynamic> toJson() => {
        // Kayıt kimliğini JSON alanına yazar
        'id': id,
        // Ad bilgisini JSON alanına yazar
        'name': name,
        // Açıklamayı JSON alanına yazar
        'description': description,
        // Zorluk derecesini JSON alanına yazar
        'difficulty': difficulty,
        // Oluşturulma tarihini metin biçiminde kaydeder
        'createdAt': createdAt.toIso8601String(),
        // Tamamlanan günleri JSON listesine aktarır
        'completedDates': completedDates,
        // Arşiv durumunu JSON alanına yazar
        'archived': archived,
      };
  // JSON alanlarını okuyarak yeni model nesnesi oluşturur
  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        // Kaydın benzersiz kimliğini belirler
        id: json['id'] as String,
        // Vazifenin veya kişiliğin adını belirler
        name: json['name'] as String? ?? '',
        // Vazifenin veya önerinin açıklamasını belirler
        description: json['description'] as String? ?? '',
        // Vazifenin zorluk derecesini belirler
        difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
        // Yeni kaydın oluşturulduğu zamanı alır
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            // Tarih çözümlenemezse güncel zamanı kullanır
            DateTime.now(),
        // Vazifenin tamamlandığı günleri aktarır
        completedDates:
            // Veriyi beklenen tipe dönüştürür
            (json['completedDates'] as List<dynamic>? ?? []).cast<String>(),
        // Vazifenin arşivde olup olmadığını belirtir
        archived: json['archived'] as bool? ?? false,
      );
}

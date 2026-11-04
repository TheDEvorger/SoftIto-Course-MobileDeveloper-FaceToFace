// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum ThemeModePreference { system, light, dark }
// student preferences bilgilerini veya işlemlerini tutan sınıf
class StudentPreferences {
  // student preferences nesnesini oluşturur
  const StudentPreferences({
    // ID bilgisini isteğe bağlı alır
    this.id = 'current',
    // display adı bilgisini isteğe bağlı alır
    this.displayName,
    // field bilgisini isteğe bağlı alır
    this.field = 'Sayısal',
    // hedef tarihi bilgisini isteğe bağlı alır
    this.targetDate,
    // hedef net bilgisini isteğe bağlı alır
    this.targetNet,
    // tema modu bilgisini isteğe bağlı alır
    this.themeMode = ThemeModePreference.system,
    // humorous exit enabled bilgisini isteğe bağlı alır
    this.humorousExitEnabled = false,
  });
  // ID bilgisini tutar
  final String id;
  // display adı bilgisini tutar
  final String? displayName;
  // field bilgisini tutar
  final String field;
  // hedef tarihi bilgisini tutar
  final DateTime? targetDate;
  // hedef net bilgisini tutar
  final double? targetNet;
  // tema modu bilgisini tutar
  final ThemeModePreference themeMode;
  // humorous exit enabled bilgisini tutar
  final bool humorousExitEnabled;
  // with bilgisini kopyalar
  StudentPreferences copyWith({
    // İlgili değeri veya görünüm ayarını belirler
    String? id,
    // İlgili değeri veya görünüm ayarını belirler
    String? displayName,
    // İlgili değeri veya görünüm ayarını belirler
    String? field,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? targetDate,
    // İlgili değeri veya görünüm ayarını belirler
    double? targetNet,
    // İlgili değeri veya görünüm ayarını belirler
    ThemeModePreference? themeMode,
    // İlgili değeri veya görünüm ayarını belirler
    bool? humorousExitEnabled,
  }) {
    // student preferences nesnesini oluşturur
    return StudentPreferences(
      // ID bilgisini belirler
      id: id ?? this.id,
      // display adı bilgisini belirler
      displayName: displayName ?? this.displayName,
      // field bilgisini belirler
      field: field ?? this.field,
      // hedef tarihi bilgisini belirler
      targetDate: targetDate ?? this.targetDate,
      // Hedef neti belirler
      targetNet: targetNet ?? this.targetNet,
      // Kullanılacak tema modunu belirler
      themeMode: themeMode ?? this.themeMode,
      // humorous exit enabled bilgisini belirler
      humorousExitEnabled: humorousExitEnabled ?? this.humorousExitEnabled,
    );
  }
  // map bilgisini dönüştürür
  Map<String, dynamic> toMap() {
    // Yeni değer veya liste oluşturur
    return {
      // "id': id" metnini kullanır
      'id': id,
      // "display_name': displayName" metnini kullanır
      'display_name': displayName,
      // "field': field" metnini kullanır
      'field': field,
      // "target_date': targetDate?.toIso8601String()" metnini kullanır
      'target_date': targetDate?.toIso8601String(),
      // "target_net': targetNet" metnini kullanır
      'target_net': targetNet,
      // "theme_mode': themeMode.name" metnini kullanır
      'theme_mode': themeMode.name,
      // "humorous_exit_enabled': humorousExitEnabled…" metnini kullanır
      'humorous_exit_enabled': humorousExitEnabled ? 1 : 0,
    };
  }
  // Map verisinden model nesnesi oluşturur
  factory StudentPreferences.fromMap(Map<String, dynamic> map) {
    // student preferences nesnesini oluşturur
    return StudentPreferences(
      // ID bilgisini belirler
      id: map['id'] as String? ?? 'current',
      // display adı bilgisini belirler
      displayName: map['display_name'] as String?,
      // field bilgisini belirler
      field: map['field'] as String? ?? 'Sayısal',
      // hedef tarihi bilgisini belirler
      targetDate: map['target_date'] != null
          // Koşul doğruysa bu değeri kullanır
          ? DateTime.tryParse(map['target_date'] as String)
          // Koşul yanlışsa bu değeri kullanır
          : null,
      // Hedef neti belirler
      targetNet: (map['target_net'] as num?)?.toDouble(),
      // Kullanılacak tema modunu belirler
      themeMode: ThemeModePreference.values.firstWhere(
        // Yeni değer veya liste oluşturur
        (e) => e.name == map['theme_mode'],
        // or else bilgisini belirler
        orElse: () => ThemeModePreference.system,
      ),
      // humorous exit enabled bilgisini belirler
      humorousExitEnabled: (map['humorous_exit_enabled'] as int?) == 1,
    );
  }
}

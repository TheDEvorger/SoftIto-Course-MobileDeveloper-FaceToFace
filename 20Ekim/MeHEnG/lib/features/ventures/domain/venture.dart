// Girişim bilgilerini tutan model
class Venture {
  // Constructor gerekli bilgileri alır
  const Venture({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Girişim adını zorunlu tutar
    required this.name,
    // Çözülecek problemi zorunlu tutar
    required this.problem,
    // Hedef kitleyi zorunlu tutar
    required this.audience,
    // Oluşturulma tarihini zorunlu tutar
    required this.createdAt,
    // Arşiv durumunu isteğe bağlı alır
    this.isArchived = false,
  });
  // ID bilgisini tutar
  final String id;
  // Girişim adını tutar
  final String name;
  // Çözülecek problemi tutar
  final String problem;
  // Hedef kitleyi tutar
  final String audience;
  // Oluşturulma tarihini tutar
  final DateTime createdAt;
  // Arşiv durumunu tutar
  final bool isArchived;
  // Mevcut verilerden güncellenmiş kopya oluşturur
  Venture copyWith({
    // Girişim adını parametre olarak alır
    String? name,
    // Çözülecek problemi parametre olarak alır
    String? problem,
    // Hedef kitleyi parametre olarak alır
    String? audience,
    // Arşiv durumunu parametre olarak alır
    bool? isArchived,
  // Mevcut alanları koruyan yeni Venture nesnesi döndürür
  }) => Venture(
    // ID bilgisini gönderir
    id: id,
    // İsim bilgisini belirler
    name: name ?? this.name,
    // Problem bilgisini gönderir
    problem: problem ?? this.problem,
    // Hedef kitleyi gönderir
    audience: audience ?? this.audience,
    // Oluşturulma tarihini gönderir
    createdAt: createdAt,
    // Arşiv durumunu gönderir
    isArchived: isArchived ?? this.isArchived,
  );
  // Girişim adının geçerli olup olmadığını kontrol eder
  static String? validateName(String? raw) {
    // Değeri boşlukları temizleyerek alır
    final value = raw?.trim() ?? '';
    // Eleman veya karakter sayısını kontrol eder
    if (value.length < 3) return 'En az 3 karakter girin.';
    // Eleman veya karakter sayısını kontrol eder
    if (value.length > 80) return 'En fazla 80 karakter girin.';
    // Hata yoksa null döndürür
    return null;
  }
}

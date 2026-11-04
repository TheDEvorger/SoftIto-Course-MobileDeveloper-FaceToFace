// Ürünün puan ve oy bilgilerini tutan model sınıfı
class Degerlendirme {
  // Ürünün değerlendirme puanını tutar
  final double puan;
  // Ürüne verilen oy sayısını tutar
  final int oySayisi;
  // Puan ve oy sayısını alan sabit constructor
  const Degerlendirme({
    // Puan bilgisinin verilmesini zorunlu tutar
    required this.puan,
    // Oy sayısının verilmesini zorunlu tutar
    required this.oySayisi,
  });
  // APIdeki rating verisinden değerlendirme nesnesi oluşturur
  factory Degerlendirme.fromJson(Map<String, dynamic> json) {
    // Okunan puan ve oy sayısıyla yeni nesne döndürür
    return Degerlendirme(
      // rate değerini double yapar, yoksa sıfır kullanır
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      // count değerini int yapar, yoksa sıfır kullanır
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

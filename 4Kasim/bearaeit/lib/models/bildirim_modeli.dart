// Bir bildirimin bilgilerini tutan model sınıfı
class BildirimModeli {
  // Bildirim ID bilgisini String olarak tutar
  final String id;
  // Bildirimin başlığını tutar
  final String baslik;
  // Bildirimin içerik metnini tutar
  final String icerik;
  // Bildirimin tarih bilgisini metin olarak tutar
  final DateTime tarih;
  // Bildirimin okunup okunmadığını tutar
  final bool okundumu;
  // Bildirim bilgilerini alan constructor
  const BildirimModeli({
    // ID bilgisini zorunlu tutar
    required this.id,
    // Başlık bilgisini zorunlu tutar
    required this.baslik,
    // İçerik bilgisini zorunlu tutar
    required this.icerik,
    // Tarih bilgisini zorunlu tutar
    required this.tarih,
    // Okunmadıysa false değerini varsayılan kullanır
    this.okundumu = false,
  });
  // Mevcut bildirimi değiştirmeden yeni kopyasını oluşturur
  BildirimModeli copyWith({
    // Yeni ID bilgisi isteğe bağlıdır
    String? id,
    // Yeni başlık bilgisi isteğe bağlıdır
    String? baslik,
    // Yeni içerik bilgisi isteğe bağlıdır
    String? icerik,
    // Yeni tarih bilgisi isteğe bağlıdır
    DateTime? tarih,
    // Okundu bilgisi isteğe bağlıdır
    bool? okundumu,
  }) {
    // Yeni bildirim nesnesi döndürür
    return BildirimModeli(
      // ID verilmişse yenisini yoksa eskisini kullanır
      id: id ?? this.id,
      // Başlık verilmişse yenisini yoksa eskisini kullanır
      baslik: baslik ?? this.baslik,
      // İçerik verilmişse yenisini yoksa eskisini kullanır
      icerik: icerik ?? this.icerik,
      // Tarih verilmişse yenisini yoksa eskisini kullanır
      tarih: tarih ?? this.tarih,
      // Okundu bilgisi verilmişse yenisini yoksa eskisini kullanır
      okundumu: okundumu ?? this.okundumu,
    );
  }
}

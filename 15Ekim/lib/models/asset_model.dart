// Varlık bilgilerini tutan model sınıfı
class Asset {
  // Varlığın kısa sembolünü tutar (BTC, ETH)
  final String symbol;
  // Varlığın tam adını tutar
  final String name;
  // Varlığın fiyatını double olarak tutar
  final double price;
  // Son 24 saatlik yüzdelik değişimi tutar
  final double change24h;
  // Kullanıcının sahip olduğu varlık miktarını tutar
  final double balance;
  // Constructor, gerekli bilgileri alarak nesne oluşturur
  const Asset({
    // Sembol bilgisini zorunlu tutar
    required this.symbol,
    // Varlık adını zorunlu tutar
    required this.name,
    // Fiyat bilgisini zorunlu tutar
    required this.price,
    // 24 saatlik değişim bilgisini zorunlu tutar
    required this.change24h,
    // Bakiye bilgisini zorunlu tutar
    required this.balance,
  });
}

// Ürün filtrelemede kullanılacak kategorileri tanımlar
enum Kategori {
  // Bütün kategorileri kapsayan filtre seçeneği
  hepsi,
  // Elektronik ürün kategorisi, sonrasında virgül eksik
  elektronik
  // Takı ve mücevher kategorisi
  taki,
  // Erkek giyim kategorisi
  erkekGiyim,
  // Kadın giyim kategorisi
  kadinGiyim,
}
// Kategori enumuna gösterim ve dönüştürme özellikleri ekler
extension KategoriExtension on Kategori {
  // Seçilen kategorinin Türkçe adını döndürür
  String get gorunenAd{
    // Enum değerine göre farklı sonuç seçer
    switch(this){
      // Hepsi için Tümü yazısını döndürür
      case Kategori.hepsi: return 'Tümü';
      // Elektronik için Türkçe başlığı döndürür
      case Kategori.elektronik: return 'Elektronik';
      // Takı kategorisi için Türkçe başlığı döndürür
      case Kategori.taki: return 'Takı & Mücevher';
      // Erkek giyim başlığını döndürür
      case Kategori.erkekGiyim: return 'Erkek Giyim';
      // Kadın giyim başlığını döndürür
      case Kategori.kadinGiyim: return 'Kadın Giyim';
    }
  }
  // APIden gelen İngilizce kategori adını enuma dönüştürür
  static Kategori apiMetindenUret(String apiMetni){
    // Metni küçük harfe çevirip boşlukları temizler
    switch (apiMetni.toLowerCase().trim()) {
      // electronics değerini elektronik kategorisine dönüştürür
      case 'electronics': return Kategori.elektronik;
      // jewelery değerini takı kategorisine dönüştürür
      case 'jewelery': return Kategori.taki;
      // men's clothing değerini erkek giyim yapar
      case "men's clothing": return Kategori.erkekGiyim;
      // women's clothing değerini kadın giyim yapar
      case "women's clothing": return Kategori.kadinGiyim;
      // Eşleşme yoksa hepsi kategorisini döndürür
      default: return Kategori.hepsi;
    }
  }
}

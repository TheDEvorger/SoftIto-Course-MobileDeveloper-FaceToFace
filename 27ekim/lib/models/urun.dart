// Kategori enumunu kullanmak için ekler
import 'kategori.dart';
// Ürün puanı modelini ekler
import 'degerlendirme.dart';
// Ürüne ait bilgileri bir arada tutan model sınıfı
class Urun {
  // Ürünün sayısal kimliğini tutar
  final int id;
  // Ürünün görünen başlığını tutar
  final String baslik;
  // Ürünün kategori bilgisini tutar
  final Kategori kategori;
  // Ürünün açıklama metnini tutar
  final String aciklama;
  // Ürünün fiyatını ondalıklı sayı olarak tutar
  final double fiyat;
  // Ürün görselinin internet adresini tutar
  final String resimUrl;
  // Stokta görünen ürün miktarını tutar
  final int stokAdedi;
  // Ürünün favorilere eklenip eklenmediğini tutar
  final bool favoriMi;
  // Puan bilgisi yoksa null olabilen değerlendirmeyi tutar
  final Degerlendirme? degerlendirme;
  // Ürün oluşturmak için kullanılan sabit constructor
  const Urun({
    // Kimlik bilgisini zorunlu alır
    required this.id,
    // Ürün başlığını zorunlu alır
    required this.baslik,
    // Kategori bilgisini zorunlu alır
    required this.kategori,
    // Açıklama bilgisini zorunlu alır
    required this.aciklama,
    // Fiyat bilgisini zorunlu alır
    required this.fiyat,
    // Görsel adresini zorunlu alır
    required this.resimUrl,
    // Stok miktarını zorunlu alır
    required this.stokAdedi,
    // Değerlendirme bilgisi verilmezse null kalır
    this.degerlendirme,
    // Favori bilgisi verilmezse false kullanır
    this.favoriMi=false,
  });
// JSON içindeki alanlardan yeni Urun oluşturur
factory Urun.fromJson(Map<String,dynamic> json)
{
  // JSONun rating alanını değerlendirme modeline çevirir
  final degerlendirme = Degerlendirme.fromJson(json['rating'] as Map<String,dynamic>);
  // Dönüştürülen verilerle ürün nesnesi oluşturur
  return Urun(
    // JSONdaki id değerini int olarak alır
    id:json['id']as int,
    // JSONdaki title değerini başlığa atar
    baslik:json['title'] as String,
    // API fiyatını double tipine dönüştürür
    fiyat:(json['price'] as num).toDouble(),
    // JSONdaki açıklama metnini alır
    aciklama:json['description'] as String,
    // JSONdaki görsel bağlantısını alır
    resimUrl:json['image'] as String,
    // İngilizce kategori metnini enuma çevirmeye çalışır
    kategori:_kategoriCevir(json['category'] as String),
    // API stok vermediği için oy sayısını stok yerine koyar
    stokAdedi:degerlendirme.oySayisi, // API stok bilgisi vermediği için oy sayısı kullanılıyor
    // Dönüştürülen puan bilgilerini ürüne ekler
    degerlendirme:degerlendirme,
    // APIden gelen ürün başlangıçta favori değildir
    favoriMi:false,
  );
}
// API kategori adını Kategori enumuna dönüştürür
static Kategori _kategoriCevir(String apiKategori)
{
  // Gelen İngilizce kategori adına göre seçim yapar
  switch(apiKategori)
  {
    // Elektronik kategorisi eşleşmesini tanımlar
    case 'electronics':
      // Elektronik enum değerini döndürür
      return Kategori.elektronik;
    // Erkek giyim eşleşmesini tanımlar
    case "men's clothing":
    // Kadın giyim için de aynı sonucu kullanır
    case "women's clothing":
      // Kategori.giyim mevcut enumda tanımlı değil, derleme hatası verir
      return Kategori.giyim;
    // Takı kategorisi eşleşmesini tanımlar
    case 'jewelery':
      // Kategori.aksesuar mevcut enumda tanımlı değil, derleme hatası verir
      return Kategori.aksesuar;
    // Diğer kategoriler için varsayılan yol
    default:
      // Eşleşmeyen kategoriyi hepsi kabul eder
      return Kategori.hepsi;
  }
}
// Mevcut üründen değiştirilen alanlarla yeni kopya oluşturur
Urun copyWith({
    // Yeni id isteğe bağlıdır
    int? id,
    // Yeni başlık isteğe bağlıdır
    String? baslik,
    // Yeni açıklama isteğe bağlıdır
    String? aciklama,
    // Yeni fiyat isteğe bağlıdır
    double? fiyat,
    // Yeni görsel adresi isteğe bağlıdır
    String? resimUrl,
    // Yeni kategori isteğe bağlıdır
    Kategori? kategori,
    // Yeni stok miktarı isteğe bağlıdır
    int? stokAdedi,
    // Yeni değerlendirme isteğe bağlıdır
    Degerlendirme? degerlendirme,
    // Yeni favori durumu isteğe bağlıdır
    bool? favoriMi,
  }){
    // Önceki bilgileri koruyarak yeni ürün döndürür
    return Urun(
      // Yeni id verilmezse eskisini kullanır
      id: id ?? this.id,
      // Yeni başlık verilmezse eskisini kullanır
      baslik: baslik ?? this.baslik,
      // Yeni açıklama verilmezse eskisini kullanır
      aciklama: aciklama ?? this.aciklama,
      // Yeni fiyat verilmezse eskisini kullanır
      fiyat: fiyat ?? this.fiyat,
      // Yeni görsel adresi verilmezse eskisini kullanır
      resimUrl: resimUrl ?? this.resimUrl,
      // Yeni kategori verilmezse eskisini kullanır
      kategori: kategori ?? this.kategori,
      // Yeni stok verilmezse eskisini kullanır
      stokAdedi: stokAdedi ?? this.stokAdedi,
      // Yeni değerlendirme verilmezse eskisini kullanır
      degerlendirme: degerlendirme ?? this.degerlendirme,
      // Yeni favori bilgisi verilmezse eskisini kullanır
      favoriMi: favoriMi ?? this.favoriMi,
    );
  }
  // Object sınıfındaki metodu yeniden tanımlar
  @override
  // Ürün bilgilerini metin halinde göstermeyi sağlar
  String toString(){
    // Kimlik, başlık, fiyat ve favori durumunu metin olarak döndürür
    return "Urun(id: $id, baslik: $baslik, fiyat: $fiyat ₺,favoriMi: $favoriMi)";
  }
}

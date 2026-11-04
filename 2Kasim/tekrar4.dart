// JSON metnini Dart verisine çevirmek için ekler
import 'dart:convert';
// HTTP isteği göndermek için http paketini ekler
import 'package:http/http.dart' as http;
// API ürün bilgilerini tutan model sınıfı
class UrunModel{
  // Ürünün sayısal kimliğini tutar
  final int id;
  // Ürün başlığını tutar
  final String baslik;
  // Ürün fiyatını ondalıklı sayı olarak tutar
  final double fiyat;
  // Ürün görselinin adresini tutar
  final String resimURL;
  // Ürün kategorisini tutar
  final String kategori;
  // Model nesnesi için zorunlu alanları alır
  UrunModel({
    // Ürün ID bilgisini zorunlu alır
    required this.id,
    // Başlığı zorunlu alır
    required this.baslik,
    // Fiyatı zorunlu alır
    required this.fiyat,
    // Görsel URL bilgisini zorunlu alır
    required this.resimURL,
    // Kategoriyi zorunlu alır
    required this.kategori,
  });
  // JSON haritasından yeni UrunModel oluşturur
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    // Alanları doldurulmuş model döndürür
    return UrunModel(
      // ID yoksa sıfır kullanır
      id: json['id'] as int? ?? 0,
      // Başlık yoksa İsimsiz Ürün yazar
      baslik: json['title'] as String? ?? "İsimsiz Ürün",
      // Fiyatı doublea çevirir, yoksa 0 kullanır
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Görsel yoksa yedek adres kullanır
      resimURL: json['image'] as String? ?? "https://via.placeholder.com/150",
      // Kategori yoksa Genel yazar
      kategori: json['category'] as String? ?? "Genel",
    );
  }
}
// Ürün servisi için ortak sözleşmeyi tanımlar
abstract class IUrunServisi{
  // Ürün listesi döndüren asenkron metodu zorunlu kılar
  Future<List<UrunModel>> urunleriGetir();
}
// HTTP üzerinden ürünleri getiren servis sınıfı
class CanliApiUrunServisi implements IUrunServisi {
  // İstek yapılacak API adresini sabit tutar
  static const String _baseUrl = "https://fakestoreapi.com/products";
  // Arayüzdeki metodu uygular
  @override
  // Ürün listesini HTTP isteğiyle getirir
  Future<List<UrunModel>> urunleriGetir() async {
    // İstek ve dönüşümü hata yakalayarak dener
    try{
      // APIye GET isteği gönderir ve zaman aşımı ekler
      final yanit=await http.get(Uri.parse(_baseUrl)).timeout(
        // Yanıt için en fazla 10 saniye bekler
        const Duration(seconds: 10),
        // Süre aşılırsa çalışacak callbacki tanımlar
        onTimeout: () {
          // Süre aşımında istisna fırlatır
          throw Exception("Ağ zaman aşımına uğradı.");
        },
      );
      // HTTP durum kodu 200 ise başarılı kabul eder
      if(yanit.statusCode==200){
        // Yanıtın gövdesini JSON listesine çevirir
        final List<dynamic> hamListe=jsonDecode(yanit.body) as List<dynamic>;
        // Listeyi ürün modellerine dönüştürerek döndürür
        return hamListe
          // Her JSON öğesinden UrunModel oluşturur
          .map((eleman) => UrunModel.fromJson(eleman as Map<String,dynamic>))
          // Dönüşen öğeleri listeye çevirir
          .toList();
      }
      else{
        // Durum kodunu içeren sunucu hatası fırlatır
        throw Exception("Sunucu Hatası ${yanit.statusCode}");
      }
    }
    // İstek veya dönüşüm hatasını yakalar
    catch (e){
      // Hata bilgisini konsola yazdırır
      print('Ağ Hatası: $e');
      // Hatanın çağıran tarafa iletilmesini sağlar
      rethrow;
    }
  }
}

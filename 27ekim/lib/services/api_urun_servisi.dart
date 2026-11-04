// JSON metinlerini çözmek için ekler
import 'dart:convert';
// HTTP isteği yapmak için paket öğelerini ekler
import 'package:http/http.dart';
// JSON sonucunu ürün nesnesine çevirmek için ekler
import '../models/urun.dart';
// Kategori enumunu kullanmak için ekler
import '../models/kategori.dart';
// Ürün servisi sözleşmesini ekler
import 'i_urun_servisi.dart';
// API üzerinden ürün getirmeyi amaçlayan servis sınıfı
class ApiUrunServisi implements IUrunServisi{
    // Ürünlerin alınacağı adresi tutar; HTTP kullanıyor
    static const String _baseUrl='http://fakestoreapi.com/products';
    // Tüm ürünleri internetten asenkron getirmeyi amaçlar
    @override Future<List<Urun>> tumUrunleriGetir() async {
        // Adres metnini Uri nesnesine çevirir
        final uri=Uri.parse(_baseUrl);
        // Ağ isteğinde oluşabilecek hataları yakalamayı dener
        try{
            // HTTP GET isteğini başlatır; http takma adı tanımlı değil
            final yanit=await http.get(uri).timeout(
                // İsteğin en fazla 10 saniye sürmesini bekler
                const Duration(seconds:10),
                // Süre aşılırsa hata fırlatır
                onTimeout:()=>throw Exception("Ağ isteği zaman aşımına uğradı(Timeout)"),
            );
            // Yanıt kodunun başarılı olup olmadığını kontrol eder
            if(yanit.statusCode==200)
            {
                // Yanıt baytlarını UTF-8 çözüp JSON listesini okur
                final List<dynamic> hamListe=jsonDecode(utf8.decode(yanit.bodyBytes));
                // Her JSON öğesini Urun nesnesine dönüştürüp döndürür
                return hamListe.map((tekilJson)=>Urun.fromJson(tekilJson as Map<String,dynamic)).toList();
            }
            else
            {
                // Yanıt koduyla birlikte hata fırlatır
                throw Exception('Sunucu hatası oluştu!Durum Kodu:${yanit.statusCode}');
            }
        }
        // İstek veya dönüştürme hatalarını yakalar
        catch(hata)
        {
            // Yakalanan hatayı açıklama ekleyerek tekrar fırlatır
            throw Exception('Internet Bağlantısı Kurulamadı $hata');
        }
    }
 // Arayüzdeki metodu yeniden uygular
 @override
 // Seçilen kategoriye göre ürünleri getirmeye çalışır
 Future <List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // Hepsi seçildiyse özel filtre gerekmez
    if(kategori==Kategori.hepsi)
    {
        // Tüm ürünleri getiren metoda yönlendirir
        return tumUrunleriGetir();
    }
    // API adresine gönderilecek kategori metnini tutar
    String kategoriYolu;
    // Kategori değerine göre API yolunu belirler
    switch(kategori)
    {
        // Elektronik için electronics yolunu seçer
        case Kategori.elektronik:kategoriYolu='electronics';
        // Bu switch kolundan çıkar
        break;
        // Kategori.giyim enumda yok, derleme hatası verir
        case Kategori.giyim:kategoriYolu="men's clothing";
        // Bu switch kolundan çıkar
        break;
        // Kategori.mobilya enumda yok, derleme hatası verir
        case Kategori.mobilya:kategoriYolu='jewelery';
        // Bu switch kolundan çıkar
        break;
        // Diğer kategoriler için varsayılan durum
        default:
        // Eşleşmeyen kategorilerde bütün ürünleri getirir
        return tumUrunleriGetir();
    }
    // Kategori yolunu kullanarak API adresi oluşturur
    final uri=Uri.parse('$_baseUrl/category/$kategoriYolu');
    // Kategoriye ait ürünler için HTTP isteği gönderir, http tanımsız
    final yanit=await http.get(uri);
    // Yanıt kodu 200 ise listeyi işler
    if(yanit.statusCode==200)
    // Gelen HTTP yanıtını JSON listesine çevirir
    {final List<dynamic> hamListe=jsonDecode(utf8.decode(yanit.bodyBytes));
    // Her kaydı ürüne çevirmek ister; küçük harfli urun sınıfı tanımsız
    return hamListe.map((j)=>urun.fromJson(j as Map<String,dynamic>)).toList();
    }
    // Başarısız yanıt durumunu ele alır
    else{
        // Sunucunun durum kodunu belirten hata fırlatır
        throw Exception('Kategori Filtreleme Hatası: ${yanit.statusCode}');
    }
 }
// Servis sözleşmesindeki metodu uygular
@override
// Arama metnine göre ürünleri getiren asenkron metot
Future <List<Urun>> adaGoreAra(String aramaMetni) async{
    // Önce bütün ürünleri APIden yükler
    final tumUrunler=await tumUrunleriGetir();
    // Arama boşsa bütün ürünleri döndürür
    if(aramaMetni.trim().isEmpty) return tumUrunler;
    // Ürünleri arama ölçütüne göre süzer
    return tumUrunler.where((urun){
        // Başlıkta veya açıklamada metin geçen ürünleri seçer
        return urun.baslik.toLowerCase().contains(aramaMetni.toLowerCase()) || urun.aciklama.toLowerCase().contains(aramaMetni.toLowerCase());
    // Filtrelenen ürünleri listeye dönüştürür
    }).toList();
}
}

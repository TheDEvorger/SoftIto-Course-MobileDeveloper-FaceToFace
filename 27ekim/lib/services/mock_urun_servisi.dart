// Ürün kategorilerini ekler
import '../models/kategori.dart';
// Ürün modelini ekler
import '../models/urun.dart';
// Servis sözleşmesini ekler
import 'i_urun_servisi.dart';
// İnternet olmadan örnek ürünlerle çalışan servis sınıfı
class MockUrunServisi implements IUrunServisi{
  // Örnek ürünleri tutan değiştirilemez listeyi başlatır
  final List<Urun> _urunDeposu=const
  // Örnek ürün ekler: Macbook M5 Pro Laptop
  [Urun(id:1,baslik:"Macbook M5 Pro Laptop",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
  // Örnek ürünün fiyatını belirler
  fiyat:179999.99,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Ürünün elektronik kategorisinde olduğunu belirtir
  kategori:Kategori.elektronik,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  // Örnek ürün ekler: Apple İphone 18 Pro Max
  ),Urun(id:2,baslik:"Apple İphone 18 Pro Max",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Apple'ın en yeni akıllı telefonu,performans ve şıklığı bir arada sunuyor.",
  // Örnek ürünün fiyatını belirler
  fiyat:250000.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Ürünün elektronik kategorisinde olduğunu belirtir
  kategori:Kategori.elektronik,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  // Örnek ürün ekler: Adidas Erkek Sneaker Ayakkabı
  ),Urun(id:3,baslik:"Adidas Erkek Sneaker Ayakkabı",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Günlük kullanıma uygun,şık ve trend erkek sneaker ayakkabısı",
  // Örnek ürünün fiyatını belirler
  fiyat:3500.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Bu kategori değeri mevcut enumda tanımlı değil, hata verir
  kategori:Kategori.ayakkabi,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ),
  // Örnek ürün ekler: Nike Erkek Sneaker Ayakkabı
  Urun(id:4,baslik:"Nike Erkek Sneaker Ayakkabı",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Koşu ve spor antrenmanları için uygun,dayanıklı ve şık tasarımlı,şık ve trend erkek sneaker ayakkabısı",
  // Örnek ürünün fiyatını belirler
  fiyat:1499.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Bu kategori değeri mevcut enumda tanımlı değil, hata verir
  kategori:Kategori.ayakkabi,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ),
  // Örnek ürün ekler: Şık Kadın Elbise
  Urun(id:5,baslik:"Şık Kadın Elbise",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Pembe rengi ile şık bir görünüm sunan,pamuklu kumaştan üretilmiş,dantel detaylı,günlük kullanıma uygun,şık ve trend kadın elbisesi",
  // Örnek ürünün fiyatını belirler
  fiyat:1999.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Bu kategori değeri mevcut enumda tanımlı değil, hata verir
  kategori:Kategori.giyim,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ),
  // Örnek ürün ekler: Apple Watch Series 9
  Urun(id:6,baslik:"Apple Watch Series 9",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Akıllı saat,kalp atış hızı ölçümü,EKG,kan oksijen seviyesi ölçümü,uyku takibi,spor modları,suya dayanıklı,şık ve trend akıllı saat",
  // Örnek ürünün fiyatını belirler
  fiyat:15000.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Ürünün elektronik kategorisinde olduğunu belirtir
  kategori:Kategori.elektronik,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ), 
  // Örnek ürün ekler: Apple Airpods Pro 2
  Urun(id:7,baslik:"Apple Airpods Pro 2",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Kulaklık ile müziğin tadını çıkarın",
  // Örnek ürünün fiyatını belirler
  fiyat:5000.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Bu kategori değeri mevcut enumda tanımlı değil, hata verir
  kategori:Kategori.aksesuar,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ), 
  // Örnek ürün ekler: Samsung Galaxy S26 Ultra
  Urun(id:8,baslik:"Samsung Galaxy S26 Ultra",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"TelefonGalaxy S26 Ultra,120Hz yenileme hızına sahip AMOLED ekranı,yüksek çözünürlüklü kamerası,uzun pil ömrü ve güçlü işlemcisiyle göz dolduran,şık ve trend akıllı telefon",
  // Örnek ürünün fiyatını belirler
  fiyat:129999.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Ürünün elektronik kategorisinde olduğunu belirtir
  kategori:Kategori.elektronik,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ),
    // Örnek ürün ekler: Erkek Deri Ceket
    Urun(id:9,baslik:"Erkek Deri Ceket",
  // Bu örnek ürünün açıklama metnini belirler
  aciklama:"Yumuşak deriden üretilmiş,şık ve modern tasarımlı,günlük kullanıma uygun,şık ve trend erkek deri ceketi",
  // Örnek ürünün fiyatını belirler
  fiyat:1999.00,
  // Görsel için picsum.photos adresini kullanır
  resimUrl:"https://picsum.photos/400/400",
  // Bu kategori değeri mevcut enumda tanımlı değil, hata verir
  kategori:Kategori.giyim,
  // Örnek ürünün stok miktarını 5 yapar
  stokAdedi:5,
  ),
  ];
// Servis sözleşmesindeki metodu uygular
@override 
// Tüm örnek ürünleri asenkron döndüren metot
Future<List<Urun>> tumUrunleriGetir() async {
  // Gerçek ağ gecikmesini taklit etmek için 1,5 saniye bekler
  await Future.delayed(const Duration(milliseconds: 1500));
  // Örnek ürün listesinin yeni bir kopyasını döndürür
  return List.from(_urunDeposu);
}
// Servis sözleşmesindeki metodu uygular
@override 
// Seçilen kategoriye göre örnek ürünleri getirir
Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
  // 400 milisaniyelik gecikmeyi taklit eder
  await Future.delayed(const Duration(milliseconds: 400));
  // Hepsi kategorisi seçilip seçilmediğini kontrol eder
  if(kategori==Kategori.hepsi)
  {
    // Bütün ürünlerin kopyasını döndürür
    return List.from(_urunDeposu);
  }
  // Kategori eşleşen ürünleri filtreleyip döndürür
  return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
}
// Servis sözleşmesindeki metodu uygular
@override 
// Başlık içinde metin arayan asenkron metot
Future<List<Urun>> adaGoreAra(String aramaMetni) async {
  // 300 milisaniyelik gecikmeyi taklit eder
  await Future.delayed(const Duration(milliseconds: 300));
  // Arama metni boşsa bütün ürünleri seçer
  if(aramaMetni.trim().isEmpty){
    // Örnek ürün listesinin kopyasını döndürür
    return List.from(_urunDeposu);
  }
 // Ürün listesindeki başlıklara filtre uygular
 return _urunDeposu.where((urun)
 {
    // Ürün başlığını küçük harfe çevirir
    final baslikKucuk=urun.baslik.toLowerCase();
    // Aranan metni küçük harfe çevirir
    final arananKucuk=aramaMetni.toLowerCase();
    // Başlık aranan metni içeriyorsa ürünü seçer
    return baslikKucuk.contains(arananKucuk);
 // Eşleşen ürünleri listeye çevirir
 }).toList();
}
}

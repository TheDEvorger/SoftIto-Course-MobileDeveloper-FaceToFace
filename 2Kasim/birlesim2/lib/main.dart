// JSON yanıtını Dart listesine çevirmek için ekler
import 'dart:convert';
// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// APIye istek göndermek için http paketini ekler
import 'package:http/http.dart' as http;
// APIden gelen ürün bilgilerini tutan model sınıfı
class UrunModel {
  // Ürün kimliğini tutar
  final int id;
  // Ürün başlığını tutar
  final String baslik;
  // Ürün fiyatını ondalıklı sayı olarak tutar
  final double fiyat;
  // Görselin internet adresini tutar
  final String resimURL;
  // Ürün kategorisini tutar
  final String kategori;
  // Ürün nesnesi için gerekli bilgileri alır
  UrunModel({
    // Ürün IDsini zorunlu tutar
    required this.id,
    // Başlığı zorunlu tutar
    required this.baslik,
    // Fiyatı zorunlu tutar
    required this.fiyat,
    // Görsel adresini zorunlu tutar
    required this.resimURL,
    // Kategoriyi zorunlu tutar
    required this.kategori,
  });
  // JSON haritasından ürün modeli oluşturan factory
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    // JSON alanlarıyla ürün nesnesi döndürür
    return UrunModel(
      // ID eksikse sıfır kullanır
      id: json['id'] as int? ?? 0,
      // Başlık eksikse İsimsiz Ürün kullanır
      baslik: json['title'] as String? ?? "İsimsiz Ürün",
      // Sayısal fiyatı doublea çevirir, yoksa sıfır kullanır
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Görsel adresi eksikse yedek URL kullanır
      resimURL: json['image'] as String? ?? "https://via.placeholder.com/150",
      // Kategori eksikse Genel kullanır
      kategori: json['category'] as String? ?? "Genel",
    );
  }
}
// Farklı ürün servislerinin uyması gereken sözleşme
abstract class IUrunServisi {
  // Ürün listesi döndürecek asenkron metodu tanımlar
  Future<List<UrunModel>> urunleriGetir();
}
// API üzerinden ürün çeken servis sınıfı
class CanliApiUrunServisi implements IUrunServisi {
  // Ürün listesinin çekileceği URLyi sabit tutar
  static const String _baseUrl = "https://fakestoreapi.com/products";
  // Arayüzdeki ürün getirme metodunu uygular
  @override
  // Ürünleri asenkron olarak getirir
  Future<List<UrunModel>> urunleriGetir() async {
    // İstek hatalarını yakalamak için try başlatır
    try {
      // GET isteğinin sonucunu beklemek için zinciri başlatır
      final yanit = await http
          // URLye HTTP GET isteği yapar
          .get(Uri.parse(_baseUrl))
          // İstek için zaman aşımı tanımlar
          .timeout(
            // En fazla on saniye bekler
            const Duration(seconds: 10),
            // Zaman aşımında çalışacak fonksiyon
            onTimeout: () {
              // On saniye aşılırsa istisna fırlatır
              throw Exception("Ağ zaman aşımına uğradı.");
            },
          );
      // HTTP 200 yanıtını başarılı kabul eder
      if (yanit.statusCode == 200) {
        // Gelen JSON yanıtını Dart listesine çevirir
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        // Listedeki ürünleri dönüştürerek döndürür
        return hamListe
            // Her JSON öğesinden UrunModel üretir
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            // Dönüştürülen öğeleri liste yapar
            .toList();
      } else {
        // Durum koduyla sunucu hatası fırlatır
        throw Exception("Sunucu Hatası ${yanit.statusCode}");
      }
    // İstekte veya dönüşümde oluşan hatayı yakalar
    } catch (e) {
      // Hata mesajını debug konsoluna yazar
      debugPrint('Ağ Hatası: $e');
      // Hatanın çağıran tarafa gitmesini sağlar
      rethrow;
    }
  }
}
// Uygulamanın başlangıç fonksiyonu
void main() {
  // Ürün uygulamasını çalıştırır
  runApp(const UrunUygulamasi());
}
// Ürün uygulamasının ana widgetı
class UrunUygulamasi extends StatelessWidget {
  // Widgetın constructorı
  const UrunUygulamasi({super.key});
  // build metodunu yeniden yazar
  @override
  // Uygulama arayüzünü kurar
  Widget build(BuildContext context) {
    // MaterialApp oluşturur
    return MaterialApp(
      // Debug yazısını kaldırır
      debugShowCheckedModeBanner: false,
      // Uygulamanın adını belirler
      title: 'Ürün Listesi',
      // Tema ayarlarını oluşturur
      theme: ThemeData(
        // Ana tema rengini indigo yapar
        colorSchemeSeed: Colors.indigo,
        // Material 3 görünümünü etkinleştirir
        useMaterial3: true,
      ),
      // İlk ekranı Listecibasi olarak belirler
      home: const Listecibasi(),
    );
  }
}
// API sonucu değişeceği için StatefulWidget kullanır
class Listecibasi extends StatefulWidget {
  // Ürün servisini isteğe bağlı constructor parametresi yapar
  const Listecibasi({super.key, this.servis});
  // Dışarıdan servis verilmesini sağlar, null olabilir
  final IUrunServisi? servis;
  // createState metodunu yeniden yazar
  @override
  // Ekranın State nesnesini oluşturur
  State<Listecibasi> createState() => _ListecibasiState();
}
// Ürün listeleme ekranının durumunu yöneten sınıf
class _ListecibasiState extends State<Listecibasi> {
  // Ürünlerin çekileceği servis değişkeni, sonra atanır
  late final IUrunServisi _servis;
  // İstekten gelecek ürün listesini taşıyan Futureı tutar
  late Future<List<UrunModel>> _urunlerFuture;
  // initState metodunu yeniden yazar
  @override
  // Widget ilk açılınca çalışır
  void initState() {
    // Üst sınıfın initState metodunu çağırır
    super.initState();
    // Dışarıdan servis yoksa canlı API servisini oluşturur
    _servis = widget.servis ?? CanliApiUrunServisi();
    // İlk ürün isteğini başlatır ve Futureı saklar
    _urunlerFuture = _servis.urunleriGetir();
  }
  // Ürün listesini yeniden yükleyen asenkron metot
  Future<void> _yenile() async {
    // Yeni isteği ekranı güncelleyerek başlatır
    setState(() {
      // Servisten yeni ürün listesini ister
      _urunlerFuture = _servis.urunleriGetir();
    });
    // İstek sonucunu hata yakalayarak bekler
    try {
      // Yenilenen ürün isteğinin bitmesini bekler
      await _urunlerFuture;
    // Hata olursa burada yakalar
    } catch (_) {
    }
  }
  // build metodunu yeniden yazar
  @override
  // Liste ekranının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfanın iskeletini oluşturur
    return Scaffold(
      // Ürünler için üst menü oluşturur
      appBar: AppBar(
        // Üst menüde Ürünler başlığı gösterir
        title: const Text('Ürünler'),
        // Üst menüdeki eylem butonlarını listeler
        actions: [
          // Yenileme simgesi olan buton oluşturur
          IconButton(
            // Yenileme simgesini gösterir
            icon: const Icon(Icons.refresh),
            // Butona basılınca yeniden ürün ister
            onPressed: _yenile,
          ),
        ],
      ),
      // Futureın sonucuna göre arayüz oluşturur
      body: FutureBuilder<List<UrunModel>>(
        // Daha önce başlatılan ürün isteğini dinler
        future: _urunlerFuture,
        // İstek durumuna göre ekran oluşturur
        builder: (context, snapshot) {
          // İstek sürüyorsa bu dal çalışır
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Ortada yükleniyor göstergesi gösterir
            return const Center(child: CircularProgressIndicator());
          }
          // İstek hata verdiyse bu dal çalışır
          if (snapshot.hasError) {
            // Hata ekranını ortalar
            return Center(
              // Hata alanının etrafına boşluk ekler
              child: Padding(
                // Her taraftan 24 boşluk bırakır
                padding: const EdgeInsets.all(24),
                // Hata içeriğini alt alta dizer
                child: Column(
                  // İçeriği dikeyde mümkün olduğunca az alanla sınırlar
                  mainAxisSize: MainAxisSize.min,
                  // Hata ekranı elemanlarını listeler
                  children: [
                    // Kırmızı hata simgesi gösterir
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    // Dikeyde 12 boşluk bırakır
                    const SizedBox(height: 12),
                    // Hata metnini oluşturur
                    Text(
                      // İstekten gelen hatayı metne ekler
                      'Bir hata oluştu:\n${snapshot.error}',
                      // Hata yazısını ortalar
                      textAlign: TextAlign.center,
                    ),
                    // Dikeyde 12 boşluk bırakır
                    const SizedBox(height: 12),
                    // Yeniden deneme butonu oluşturur
                    ElevatedButton(
                      // Butona basılınca yenileme isteği başlatır
                      onPressed: _yenile,
                      // Butonun yazısını belirler
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }
          // İstekten gelen listeyi alır, nullsa boş liste kullanır
          final urunler = snapshot.data ?? [];
          // Liste boşsa bu dal çalışır
          if (urunler.isEmpty) {
            // Ürün bulunamadı yazısını ortada gösterir
            return const Center(child: Text('Ürün bulunamadı.'));
          }
          // Aşağı çekerek yenilemeyi sağlar
          return RefreshIndicator(
            // Yenileme fonksiyonunu bağlar
            onRefresh: _yenile,
            // Ayırıcı çizgili kaydırılabilir liste oluşturur
            child: ListView.separated(
              // Liste uzunluğunca satır üretir
              itemCount: urunler.length,
              // Ürünler arasına ince ayırıcı çizgi ekler
              separatorBuilder: (_, _) => const Divider(height: 1),
              // Her ürün için satır oluşturan builder
              itemBuilder: (context, index) {
                // Sıradaki ürünü listeden alır
                final urun = urunler[index];
                // Ürün satırını ListTile ile oluşturur
                return ListTile(
                  // Ürün görselinin alanını oluşturur
                  leading: SizedBox(
                    // Görsel genişliğini 56 yapar
                    width: 56,
                    // Görsel yüksekliğini 56 yapar
                    height: 56,
                    // İnternetten ürün görselini yükler
                    child: Image.network(
                      // Ürünün görsel URL bilgisini kullanır
                      urun.resimURL,
                      // Görseli taşırmadan alanına sığdırır
                      fit: BoxFit.contain,
                      // Görsel yüklenemezse çalışacak callback
                      errorBuilder: (_, _, _) =>
                          // Resim yok simgesini gösterir
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  // Ürün başlığını gösterir
                  title: Text(
                    // Başlık metnini üründen alır
                    urun.baslik,
                    // En fazla iki satır gösterir
                    maxLines: 2,
                    // Uzun başlıkların sonuna üç nokta ekler
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Ürün kategorisini alt yazıda gösterir
                  subtitle: Text(urun.kategori),
                  // Fiyatı sağ tarafta gösterir
                  trailing: Text(
                    // Fiyatı dolar simgesiyle iki ondalıklı yazdırır
                    '\$${urun.fiyat.toStringAsFixed(2)}',
                    // Fiyat yazısını kalın yapar
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

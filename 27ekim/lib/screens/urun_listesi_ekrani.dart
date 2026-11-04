// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Ürün kategorilerini kullanmak için ekler
import '../models/kategori.dart';
// Ürün modelini ekler
import '../models/urun.dart';
// Servis sözleşmesini ekler
import '../services/i_urun_servisi.dart';
// Gerçek APIden veri çeken servisi ekler
import '../services/api_urun_servisi.dart';
// Ürün kartı widgetını ekler
import '../widgets/urun_karti.dart';
// Arama ve favoriler değiştiği için durum tutan ekran widgetı
class UrunListesiEkrani extends StatefulWidget {
  // Ekranın key alabilen constructorı
  const UrunListesiEkrani({super.key});
  // Üst sınıfın createState metodunu yeniden yazar
  @override
  // Ekranın State nesnesini oluşturur
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}
// Ürün listesinin değişen durumunu yöneten sınıf
class _UrunListesiEkraniState extends State<UrunListesiEkrani>{
  // Verileri API servisinden getirecek nesneyi oluşturur
  final IUrunServisi _servis=ApiUrunServisi();
  // Arama kutusunun metnini takip eden controller
  final TextEditingController _aramaController=TextEditingController();
  // Veri yükleme göstergesinin açık olup olmadığını tutar
  bool _yukleniyorMu=true;
  // Başlangıçta bütün kategorileri seçer
  Kategori _seciliKategori=Kategori.hepsi;
  // Filtre sonucu görünen ürünleri tutar
  List<Urun> _filtrelenmisUrunler=[];
  // Servisten yüklenen ürünleri tutar
  List<Urun> _tumUrunler=[]; 
  // Üst sınıfın initState metodunu yeniden yazar
  @override
  // Ekran ilk oluşturulurken çalışır
  void initState() {
    // Üst sınıfın başlangıç metodunu çağırır
    super.initState();
    // Ekran açılınca ürünleri yüklemeye başlar
    _urunleriYukle();
  }
  // Üst sınıfın dispose metodunu yeniden yazar
  @override
  // Ekran kaldırılırken çalışır
  void dispose() {
    // Arama controllerının kaynaklarını temizler
    _aramaController.dispose();
    // Üst sınıfın dispose metodunu çağırır
    super.dispose();
  }
  // Seçili kategoriye göre ürünleri asenkron yükler
  Future<void> _urunleriYukle() async {
    // Yüklenme durumunu arayüze bildirir
    setState(() {
      // Yükleniyor bilgisini true yapar
      _yukleniyorMu = true;
    });
    // Seçili kategorideki ürünlerin gelmesini bekler
    final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);
    // Widget ekranda duruyorsa güncelleme yapar
    if (mounted) {
      // Yeni ürünleri state içine kaydeder
      setState(() {
        // Bütün ürünleri yüklenen listeye eşitler
        _tumUrunler = urunler;
        // Görünen ürün listesini başlangıçta aynı yapar
        _filtrelenmisUrunler = urunler;
        // Yüklenme göstergesini kapatır
        _yukleniyorMu = false;
      });
    }
  }
  // Arama ve kategori koşullarını listeye uygular
  void _filtreyiUygula(){
    // Arama metnini temizleyip küçük harfe çevirir
    final arama=_aramaController.text.trim().toLowerCase();
    // Filtre sonuçlarını ekrana bildirir
    setState(() {
      // Tüm ürünlerden koşula uyanları seçer
      _filtrelenmisUrunler=_tumUrunler.where((urun){
        // Hepsi seçiliyse veya kategori eşleşiyorsa true döner
        final kategoriUygunmu=(_seciliKategori==Kategori.hepsi|| urun.kategori==_seciliKategori); 
        // Arama boşsa ya da başlık/açıklama içeriyorsa true döner
        final aramaUygunmu=arama.isEmpty||urun.baslik.toLowerCase().contains(arama)||urun.aciklama.toLowerCase().contains(arama);
        // Yalnızca iki koşulu birden sağlayan ürünleri tutar
        return kategoriUygunmu && aramaUygunmu;
      // Filtre sonucunu listeye çevirir
      }).toList();
    });
  }
  // Tıklanan ürünün favori durumunu tersine çevirir
  void _favoriyiDegistir(Urun hedefUrun){
    // Favori değişimini ekrana bildirir
    setState(() {
      // Eski ürünün favorisini tersine çeviren kopya oluşturur
      final yeniUrun=hedefUrun.copyWith(favoriMi:!hedefUrun.favoriMi);
      // Ürünü IDye göre ana listede arar
      final index=_tumUrunler.indexWhere((u)=>u.id==hedefUrun.id);
      // Ürün listede bulunmuşsa çalışır
      if(index !=-1){
        // Ana listedeki ürünün yerine yeni kopyasını koyar
        _tumUrunler[index]=yeniUrun;
      }
      // Görünen ürün listesini yeniden filtreler; iç içe setState çağrısı var
      _filtreyiUygula();
    });
  }
  // Üst sınıfın build metodunu yeniden yazar
  @override
  // Ürün listesi ekranını oluşturur
  Widget build(BuildContext context) {
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Sayfanın üst çubuğunu oluşturur
      appBar:AppBar(
        // Üst çubukta mağaza başlığını gösterir
        title:const Text("Mini Mağaza",
        // Başlığın yazı stilini belirler
        style:TextStyle(
          // Başlık yazısını kalın yapar
          fontWeight:FontWeight.bold
        )
        ),
        // Üst çubuk başlığını ortalar
        centerTitle:true,
        // Sağdaki işlem elemanlarını gösterir
        actions:[
          // Favori sayacı için boşluklu alan oluşturur
          Padding(
            // Sağdan 16 boşluk bırakır
            padding:const EdgeInsets.only(right:16.0),
            // Favori göstergesini ortalar
            child:Center(
              // Favori sayısını simge üzerinde rozet olarak gösterir
              child:Badge(
                // Rozetin sayısal metnini oluşturur
                label:Text(
                  // Favori olan ürünleri sayıp yazdırır
                  '${_tumUrunler.where((u)=>u.favoriMi).length}',
                  // Sayı metninin stilini belirler
                  style:const TextStyle(
                    // Favori sayısını kalın gösterir
                    fontWeight:FontWeight.bold,
                  ),
                ),
                // Rozetin altında kırmızı kalp simgesi gösterir
                child:const Icon(Icons.favorite,color:Colors.red),
              ),
            ),
          ),
        ],
      ),
      // Sayfanın ana gövdesini oluşturur
      body: Column(
        // Gövde elemanlarını alt alta dizer
        children:[
          // Arama alanına dış boşluk ekler
          Padding(
            // Arama kutusunun kenar boşluklarını ayarlar
            padding:const EdgeInsets.fromLTRB(16,8,16,4),
            // Kullanıcının metin yazacağı alanı oluşturur
            child:TextField(
              // Arama controllerını alana bağlar
              controller:_aramaController,
              // Metin değişince filtreleri yeniden uygular
              onChanged:(_) => _filtreyiUygula(),
              // Arama kutusunun görünümünü belirler
              decoration:InputDecoration(
                // Arama kutusunun ipucu metnini gösterir
                hintText:"Ürün veya marka ara...",
                // Sol tarafta arama simgesi gösterir
                prefixIcon:const Icon(Icons.search),
                // Metin varsa sağda temizleme butonu oluşturur
                suffixIcon: _aramaController.text.isNotEmpty ? IconButton(
                  // Temizleme simgesini gösterir
                  icon:const Icon(Icons.clear),
                  // Temizle butonunun tıklama fonksiyonunu başlatır
                  onPressed: (){
                    // Arama kutusundaki metni siler
                    _aramaController.clear();
                    // Silme sonrası ürünleri yeniden filtreler
                    _filtreyiUygula();
                  }
                // Arama boşsa temizleme butonu göstermez
                ):null,
                // Arama alanının arka planını doldurur
                filled:true,
                // Arama alanının dolgu rengini açık gri yapar
                fillColor:Colors.grey.shade100,
                // Arama alanının kenarlık şeklini belirler
                border:OutlineInputBorder(
                  // Köşeleri 12 birim yuvarlar
                  borderRadius:BorderRadius.circular(12),
                  // Kenarlık çizgisini kaldırır
                  borderSide:BorderSide.none,
                ),
                // Arama alanının dikey iç boşluğunu sıfırlar
                contentPadding:const EdgeInsets.symmetric(vertical:0),
              ),
            ),
          ),
          // Kategori filtrelerini yatay kaydırılabilir yapar
          SingleChildScrollView(
            // Yalnızca yatay yönde kaydırmayı açar
            scrollDirection:Axis.horizontal,
            // Kategori şeridine iç boşluk verir
            padding:const EdgeInsets.symmetric(horizontal:12,vertical:8),
            // Kategori çiplerini yan yana dizer
            child:Row(
              // Bütün enum kategorilerinden çip oluşturur
              children:Kategori.values.map((kategori){
                // Bu kategorinin seçili olup olmadığını belirler
                final seciliMi=_seciliKategori==kategori;
                // Her çipe dış boşluk ekler
                return Padding(
                  // Çiplerin yatay boşluğunu ayarlar
                  padding:const EdgeInsets.symmetric(horizontal:4.0),
                  // Seçilebilir kategori çipi oluşturur
                  child:ChoiceChip(
                    // Kategori ikonu bekler; mevcut enumda ikon getterı yok
                    avatar:Text(kategori.ikon),
                    // Kategori başlığı bekler; mevcut enumda baslik getterı yok
                    label:Text(kategori.baslik),
                    // Seçili durumunu çipe gönderir
                    selected:seciliMi,
                    // Seçim değiştiğinde çalışacak fonksiyonu tanımlar
                    onSelected:(secildi)
                   // Yeni çip seçilmişse kontrol eder
                   {if(secildi)
                   {
                    // Kategori değişimini ekrana bildirir
                    setState(()
                   {
                    // Yeni seçilen kategoriyi kaydeder
                    _seciliKategori=kategori;
                    // Ürün listesini yeniden filtreler; iç içe setState çağrısı var
                    _filtreyiUygula();
                   });
                   } 
                   },
                  ),
                );
              // Oluşturulan kategori çiplerini listeye çevirir
              }).toList(),
            )
          ),
          // Kalan dikey alanı ürün listesine ayırır
          Expanded(
            // Yükleniyorsa dönen simge, sonuç yoksa boş durum gösterir
            child:_yukleniyorMu ? const Center(child:CircularProgressIndicator()): _filtrelenmisUrunler.isEmpty ? Center(
              // Boş sonuç mesajını alt alta yerleştirir
              child:Column(
             // Boş sonuç elemanlarını dikeyde ortalar
             mainAxisAlignment: MainAxisAlignment.center,
                // Boş durumdaki elemanları başlatır
                children:[
                  // Arama sonucu bulunamadı simgesi gösterir
                  Icon(Icons.search_off_rounded,size:64,color:Colors.grey.shade400),
                  // Dikeyde 12 boşluk bırakır
                  const SizedBox(height:12),
                  // Filtreye uyan ürün bulunamadığı mesajını gösterir
                  Text('Aradığınız kriterlere uygun ürün bulunamadı.',
                  // Boş durum yazısının rengini belirler
                  style:TextStyle(color:Colors.grey.shade600,
                  // Boş durum yazısının boyutunu ve kalınlığını belirler
                  fontSize:16,fontWeight:FontWeight.w600
                  ),
                  ),
                ]
              )
            )
            // Sonuç varsa yalnızca görünen ürünlerin kartlarını oluşturur
            :ListView.builder(
            // Listedeki eleman sayısını belirler
            itemCount:_filtrelenmisUrunler.length,
            // Her indeks için kart oluşturacak fonksiyonu tanımlar
            itemBuilder:(context,index)
            {
              // İlgili indeksteki ürünü alır
              final urun=_filtrelenmisUrunler[index];
              // Ürün kartını oluşturur ve favori tıklamasını bağlar
              return UrunKarti(urun:urun,onFavoriTiklandi:()=>_favoriyiDegistir(urun),
              // Detay kartına basılınca çalışacak fonksiyonu tanımlar
              onDetayTiklandi: () =>
              {
                // Ekranın altında geçici mesaj gösterir
                ScaffoldMessenger.of(context).showSnackBar(
                  // Gösterilecek SnackBarı oluşturur
                  SnackBar(
                    // Tıklanan ürünün başlığını mesajda gösterir
                    content:Text('${urun.baslik} tıklandı!'),
                    // Mesajı 600 milisaniye gösterir
                    duration:const Duration(milliseconds:600),
                  ),
                )
              },
              );
            },
            ),
          ),
        ],
      ),
    );
  }
}

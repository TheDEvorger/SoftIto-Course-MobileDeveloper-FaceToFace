// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// GoRouter ile sayfa geçişlerini kullanmak için ekler
import 'package:go_router/go_router.dart';
// Sepetteki ürün sayısını yöneten sınıf
class SepetKontrolu {
  // Tekil örnek oluşturmayı amaçlar, burada constructor çağrısı hatalı
  static final SepetKontrolu ornek = SepetKontrolu()._dahili();
  // Dışarıdan nesne oluşturulmasını kısıtlayan private constructor
  SepetKontrolu._dahili();
  // Ürün sayısını sıfırdan başlatan ValueNotifier
  final ValueNotifier<int> _urunSayisi = ValueNotifier<int>(0);
  // Sepete eklenen ürün sayısını artıran metot
  void sepeteEkle() {
    // Sayıyı bir artırıp dinleyenlere bildirir
    _urunSayisi.value++;
  }
  // Ürün sayısını sıfırlayan metot
  void sepetiSifirla() {
    // Sayıyı sıfıra indirip dinleyenlere bildirir
    _urunSayisi.value = 0;
  }
}
// Uygulamanın sayfa rotalarını GoRouter ile tanımlar
final GoRouter uygulamaRotalari=GoRouter(
    // İlk rota olarak /anasayfa seçilmiş fakat bu rota tanımlı değil
    initialLocation:'/anasayfa',
    // Uygulamadaki rotaları listeler
    routes:[
        // Alt menü kullanılan sayfaları ortak kabukta toplar
        ShellRouter(
            // ShellRoute builder sözdizimi ve GoRouterState adı burada hatalı
            builder(BuildContext context, GorouterState state, Widget child){
                // Alt ekranı ortak kasa widgetına gönderir
                return AnaKasaEkrani(ekranGovdesi:child);
            }
            // Kabuk içindeki alt rotaları tanımlar
            routes:[
                // Vitrin sayfası için rota oluşturur
                GoRoute(
                    // Vitrin sayfasının adresini belirler
                    path: '/vitrin',
                    // Bu rota açılınca VitrinEkrani oluşturur
                    builder: (context,state)=>const VitrinEkrani()
                ),
                // Profil sayfası için rota oluşturur
                GoRoute(
                    // Profil sayfasının adresini belirler
                    path: '/profil',
                    // Bu rota açılınca ProfilEkrani oluşturur
                    builder: (context,state)=>const ProfilEkrani()
                ),
            ],
        ),
    ],
);
// Alt menüyü koruyan ortak ekran sınıfı
class AnaKasaEkrani extends StatelessWidget {
  // Aktif alt sayfanın widgetını tutar
  final Widget ekranGovdesi;
  // Alt sayfayı constructor ile zorunlu alır
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});
  // build metodunu yeniden yazar
  @override
  // Ortak ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfa iskeleti ve alt menü oluşturur
    return Scaffold(
      // Seçilen sayfayı gövdede gösterir
      body: ekranGovdesi,
      // Alt gezinme menüsünü oluşturur
      bottomNavigationBar: NavigationBar(
        // Seçili sekmeyi hesaplar, ancak parametre adı yanlış yazılmış
        selectedIndeks: _aktifIndexBul(context),
        // Sekme seçimiyle çalışacak fonksiyonu tanımlar
        onDestinationSelected: (yeniIndex){
            // İlk sekmede vitrine gitmeyi amaçlar, go_ metodu yok
            if(yeniIndex==0)context.go_('/vitrin');
            // İkinci sekmede profile gitmeyi amaçlar, go_ metodu yok
            if(yeniIndex==1)context.go_('/profil');
        },
        // Alt menüdeki sekmeleri listeler
        destinations:[
            // Mağaza simgeli Vitrin sekmesini tanımlar
            const NavigationDestination(icon:Icon(Icons.store),label:'Vitrin'),
                // Profil sekmesini oluşturur
                NavigationDestination(
                    // Sayı değişiminde rozeti yenilemek için ValueListenableBuilder kullanır
                    icon:ValueListenableBuilder<int>(
                        // Notiferı dinlemeyi amaçlar, burada fazladan parantez var
                        (valueListenable:SepetKontrolu.ornek._urunSayisi, 
                        // Güncel sayı geldiğinde rozet oluşturur
                        builder: (context,sayi,cocuk){
                            // Sayı rozetini oluşturur
                            return Badge(
                                // Rozette mevcut ürün sayısını yazar
                                label: Text('$sayi'),
                                // Sayı sıfırdan büyükse rozeti gösterir
                                isLabelVisible: sayi>0,
                                // Rozetin altında profil simgesi gösterir
                                child:const Icon(Icons.person),
                            );
                        },
                    ),
                    // Profil yazısını ayarlar fakat label yanlış yazılmış
                    lable:'Profil',
                ),
        ],
      ),
    );
    // Mevcut rotaya göre aktif sekme hesaplayan metot
    int _aktifIndexBul(BuildContext context){
        // URI yolunu okumayı amaçlar, location() çağrısı geçersiz
        final String konum = GoRouterState.of(context).uri.location();
        // Profil yolundaysa ikinci sekmeyi seçer
        if(konum.startsWith('/profil')) return 1;
        // Diğer yollarda ilk sekmeyi seçer
        return 0;
    }
    // Vitrin ekranını tanımlar, burada yanlış seviyede iç içe kalmış
    class VitrinEkrani extends StatelessWidget {
      // Vitrin ekranının constructorı
      const VitrinEkrani({super.key});
      // build metodunu yeniden yazar
      @override
      // Vitrin arayüzünü oluşturur
      Widget build(BuildContext context) {
        // Sabit Scaffold döndürür, fakat altındaki callback const olamaz
        return const Scaffold(
            // AppBar oluşturur, appbar adı yanlış yazılmış
            appbar:AppBar(title:const Text('Canlı Vitrin(ValueNotifier)'),),
            // İçeriği ortalar
            body:Center(
                // Sepete ekleme butonu oluşturur
                child:ElevatedButton.icon(
                    // Butona basılınca çalışacak fonksiyonu tanımlar
                    onPressed: (){
                        // Tekil sepet sayacını bir artırır
                        SepetKontrolu.ornek.sepeteEkle();
                    }, 
                    // Butonda sepet simgesi gösterir
                    icon:const Icon(Icons.add_shopping_cart),
                    // Butonda ürün ekleme yazısını gösterir
                    label:const Text('Sepete Ürün Ekle(+1)'),
                ),
            ), 
        );
      }
    }
  }
}
// Profil sayfasının sınıfını tanımlar
class ProfilEkrani extends StatelessWidget{
    // Profil ekranının constructorı
    const ProfilEkrani({super.key});
    // build metodunu yeniden yazar
    @override
    // Profil arayüzünü oluşturur
    Widget build(BuildContext context){
        // Sayfa iskeletini oluşturur
        return Scaffold(
            // Üstte kullanıcı profili başlığını gösterir
            appBar:AppBar(title:const Text('Kullanıcı Profili'),),
            // İçeriği ortalar
            body:Center(
                // Sepeti sıfırlama butonu oluşturur
                child:TextButton(
                    // Buradaki ok fonksiyonu sözdizimi hatalı, amaç sepeti sıfırlamak
                    onPressed:()=> {SepetKontrolu.ornek.sepetiSifirla();},
                    // Sepeti temizleme yazısını gösterir
                    child: const Text('Sepeti Temizle(0 Yap)'),
                ),
            ),
        );
    }
}

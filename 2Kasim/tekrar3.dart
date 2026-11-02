// setState() bulunduğu state nesnesinin build() metodunu baştan aşağı tetikler.
//scaffold appbar tabbar ve eğer varsa 20 tane container baştan hesaplanır.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SepetKontrolu {
  static final SepetKontrolu ornek = SepetKontrolu()._dahili();
  SepetKontrolu._dahili();

  final ValueNotifier<int> _urunSayisi = ValueNotifier<int>(0);

  void sepeteEkle() {
    _urunSayisi.value++;
  }

  void sepetiSifirla() {
    _urunSayisi.value = 0;
  }
}

final GoRouter uygulamaRotalari=GoRouter(
    initialLocation:'/anasayfa',
    routes:[
        ShellRouter(
            builder(BuildContext context, GorouterState state, Widget child){
                return AnaKasaEkrani(ekranGovdesi:child);
            }
            routes:[
                GoRoute(
                    path: '/vitrin',
                    builder: (context,state)=>const VitrinEkrani()
                ),
                GoRoute(
                    path: '/profil',
                    builder: (context,state)=>const ProfilEkrani()
                ),
            ],
        ),
    ],
);

class AnaKasaEkrani extends StatelessWidget {
  final Widget ekranGovdesi;
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ekranGovdesi,
      bottomNavigationBar: NavigationBar(
        selectedIndeks: _aktifIndexBul(context),
        onDestinationSelected: (yeniIndex){
            if(yeniIndex==0)context.go_('/vitrin');
            if(yeniIndex==1)context.go_('/profil');
        },
        destinations:[
            const NavigationDestination(icon:Icon(Icons.store),label:'Vitrin'),
                NavigationDestination(
                    icon:ValueListenableBuilder<int>(
                        (valueListenable:SepetKontrolu.ornek._urunSayisi, 
                        builder: (context,sayi,cocuk){
                            return Badge(
                                label: Text('$sayi'),
                                isLabelVisible: sayi>0,
                                child:const Icon(Icons.person),
                            );
                        },
                    ),
                    lable:'Profil',
                ),
        ],
      ),
    );

    int _aktifIndexBul(BuildContext context){
        final String konum = GoRouterState.of(context).uri.location();
        if(konum.startsWith('/profil')) return 1;
        return 0;
    }


    class VitrinEkrani extends StatelessWidget {
      const VitrinEkrani({super.key});

      @override
      Widget build(BuildContext context) {
        return const Scaffold(
            appbar:AppBar(title:const Text('Canlı Vitrin(ValueNotifier)'),),
            body:Center(
                child:ElevatedButton.icon(
                    onPressed: (){
                        SepetKontrolu.ornek.sepeteEkle();
                    }, 
                    icon:const Icon(Icons.add_shopping_cart),
                    label:const Text('Sepete Ürün Ekle(+1)'),
                ),
            ), 
        );
      }
    }
  }
}

class ProfilEkrani extends StatelessWidget{
    const ProfilEkrani({super.key});
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(title:const Text('Kullanıcı Profili'),),
            body:Center(
                child:TextButton(
                    onPressed:()=> {SepetKontrolu.ornek.sepetiSifirla();},
                    child: const Text('Sepeti Temizle(0 Yap)'),
                ),
            ),
        );
    }
}
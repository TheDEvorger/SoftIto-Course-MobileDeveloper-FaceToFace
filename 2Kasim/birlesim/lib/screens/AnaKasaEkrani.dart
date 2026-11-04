// Flutter arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// GoRouter yönlendirme özelliklerini ekler
import 'package:go_router/go_router.dart';
// Sepet sayacını yöneten sınıfı ekler
import '../SepetKontrolu.dart';
// Alt menünün hep göründüğü ortak ekran sınıfı
class AnaKasaEkrani extends StatelessWidget {
  // Ekranın ortasında açılacak alt sayfayı tutar
  final Widget ekranGovdesi;
  // Alt sayfayı constructor ile zorunlu alır
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});
  // build metodunu yeniden yazar
  @override
  // Ortak ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Scaffold ile gövde ve alt menü oluşturur
    return Scaffold(
      // Gelen alt sayfayı gövdede gösterir
      body: ekranGovdesi,
      // Sayfalar arasında geçiş için NavigationBar oluşturur
      bottomNavigationBar: NavigationBar(
        // Mevcut rotadan seçili sekmeyi hesaplar
        selectedIndex: _aktifIndexBul(context),
        // Alt menüde sekme seçilince çalışır
        onDestinationSelected: (yeniIndex) {
          // İlk sekmeye basılınca vitrine gider
          if (yeniIndex == 0) context.go('/vitrin');
          // İkinci sekmeye basılınca profile gider
          if (yeniIndex == 1) context.go('/profil');
        },
        // Alt menüdeki sekmeleri tanımlar
        destinations: [
          // Mağaza simgeli Vitrin sekmesini gösterir
          const NavigationDestination(icon: Icon(Icons.store), label: 'Vitrin'),
          // Profil sekmesini oluşturur
          NavigationDestination(
            // Ürün sayısı değişince Badge widgetını günceller
            icon: ValueListenableBuilder<int>(
              // Tekil sepet controllerındaki ürün sayısını dinler
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              // Güncel sayı ile rozet widgetını oluşturur
              builder: (context, sayi, child) {
                // Bildirim rozeti oluşturur
                return Badge(
                  // Sepetteki ürün sayısını gösterir
                  label: Text('$sayi'),
                  // Sayı sıfırdan büyükse rozeti görünür yapar
                  isLabelVisible: sayi > 0,
                  // Rozetin altında profil simgesi gösterir
                  child: const Icon(Icons.person),
                );
              },
            ),
            // Sekmenin adını Profil yapar
            label: 'Profil',
          ),
        ],
      ),
    );
  }
  // Mevcut URLye göre aktif sekmeyi bulur
  int _aktifIndexBul(BuildContext context) {
    // URLdeki path değerini alır
    final String konum = GoRouterState.of(context).uri.path;
    // URL profil ile başlıyorsa ikinci sekmeyi seçer
    if (konum.startsWith('/profil')) return 1;
    // Diğer yollarda ilk sekmeyi seçer
    return 0;
  }
}

// Flutter widgetlarını kullanmak için ekler
import 'package:flutter/material.dart';
// GoRouter ile sayfa yönlendirmesini ekler
import 'package:go_router/go_router.dart';
// Alt menüyü barındıran ana ekranı ekler
import 'screens/AnaKasaEkrani.dart';
// Profil sayfasını ekler
import 'screens/ProfilEkrani.dart';
// Vitrin sayfasını ekler
import 'screens/VitrinEkrani.dart';
// Uygulamanın sayfa yönlendirmelerini oluşturur
final GoRouter uygulamaRotalari = GoRouter(
  // İlk açılışta vitrin sayfasına gider
  initialLocation: '/vitrin',
  // Sayfa rotalarını listeler
  routes: [
    // Ortak alt menü kullanan rotaları ShellRoute ile birleştirir
    ShellRoute(
      // Seçilen sayfayı child olarak alan builderı tanımlar
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // Gelen sayfayı AnaKasaEkrani içine yerleştirir
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      // Kabuk içinde açılacak sayfaları listeler
      routes: [
        // Vitrin adresi için rota oluşturur
        GoRoute(
          // Vitrinin URL yolunu belirler
          path: '/vitrin',
          // Vitrin yolu açıldığında VitrinEkrani oluşturur
          builder: (context, state) => const VitrinEkrani(),
        ),
        // Profil için rota oluşturur
        GoRoute(
          // Profilin URL yolunu belirler
          path: '/profil',
          // Profil yolu açıldığında ProfilEkrani oluşturur
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

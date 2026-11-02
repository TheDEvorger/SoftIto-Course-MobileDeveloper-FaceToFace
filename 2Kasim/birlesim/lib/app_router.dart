import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/AnaKasaEkrani.dart';
import 'screens/ProfilEkrani.dart';
import 'screens/VitrinEkrani.dart';

// 3. SAYFA ROTALARI
final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/vitrin',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      routes: [
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

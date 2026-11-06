import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/storage_ve_fcm_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase başlatma hatası: $e");
  }
  runApp(const SoftitoFcmDemoApplication());
}

class SoftitoFcmDemoApplication extends StatelessWidget {
  const SoftitoFcmDemoApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Softito FCM Demo Applications",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const StorageVeFcmEkrani(),
    );
  }
}

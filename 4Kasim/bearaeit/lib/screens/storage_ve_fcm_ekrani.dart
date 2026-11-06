import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/bildirim_modeli.dart';
import '../services/fcm_bildirim_servisi.dart';
import '../services/storage_servisi.dart';
import '../widgets/bildirim_listesi_karti.dart';
import '../widgets/gorsel_yukleme_karti.dart';

class StorageVeFcmEkrani extends StatefulWidget {
  const StorageVeFcmEkrani({super.key});

  @override
  State<StorageVeFcmEkrani> createState() => _StorageVeFcmEkraniState();
}

class _StorageVeFcmEkraniState extends State<StorageVeFcmEkrani> {
  final StorageServisi _storageServisi = StorageServisi();
  final FcmBildirimServisi _fcmBildirimServisi = FcmBildirimServisi();

  Uint8List? _secilenDosya;
  String? _yuklenenUrl;
  double _yuklemeOrani = 0.0;
  bool _yukleniyorMu = false;

  String? _fcmToken;
  bool _konuyaAboneMi = false;
  final List<BildirimModeli> _bildirimler = [];

  @override
  void initState() {
    super.initState();
    _fcmKur();
  }

  Future<void> _fcmKur() async {
    try {
      final token = await _fcmBildirimServisi.tokenAl();
      if (mounted) {
        setState(() => _fcmToken = token);
      }
      await _fcmBildirimServisi.baslat(
        onMesajGeldi: (message) {
          if (!mounted) return;
          setState(() {
            _bildirimler.insert(
              0,
              BildirimModeli(
                id: message.messageId ?? DateTime.now().toIso8601String(),
                baslik: message.notification?.title ?? 'Yeni Bildirim',
                icerik: message.notification?.body ?? '',
                tarih: DateTime.now(),
              ),
            );
          });
        },
      );
    } catch (e) {
      debugPrint('FCM başlatılamadı (Firebase yapılandırması bekleniyor): $e');
    }
  }

  Future<void> _gorselSec({required bool kameradan}) async {
    final dosya = await _storageServisi.gorselSec(kameradan: kameradan);
    if (dosya != null) {
      setState(() {
        _secilenDosya = dosya;
        _yuklenenUrl = null;
        _yuklemeOrani = 0.0;
      });
    }
  }

  Future<void> _bulutaYukle() async {
    if (_secilenDosya == null) return;
    setState(() => _yukleniyorMu = true);
    try {
      final dosyaAdi = 'profil_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final task = _storageServisi.yuklemeBaslat(
        veri: _secilenDosya!,
        dosyaAdi: dosyaAdi,
      );

      task.snapshotEvents.listen((snapshot) {
        if (snapshot.totalBytes > 0) {
          setState(() {
            _yuklemeOrani = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }
      });

      final tamamlanan = await task;
      final url = await _storageServisi.urlGetir(tamamlanan.ref);

      setState(() {
        _yuklenenUrl = url;
        _yukleniyorMu = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Görsel buluta başarıyla yüklendi'),
            backgroundColor: Color(0xFF006C4A),
          ),
        );
      }
    } catch (e) {
      setState(() => _yukleniyorMu = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yükleme hatası: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _aboneDegistir(bool deger) async {
    setState(() => _konuyaAboneMi = deger);
    try {
      if (deger) {
        await _fcmBildirimServisi.konuyaAboneOl('tum_sinif');
      } else {
        await _fcmBildirimServisi.konudanAyril('tum_sinif');
      }
    } catch (e) {
      debugPrint('Abonelik işlemi hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Softito Storage ve FCM Çalışması',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Buluta Yükleme ve Push Bildirimleri',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GorselYuklemeKarti(
              secilenDosya: _secilenDosya,
              yuklenenUrl: _yuklenenUrl,
              yuklemeOrani: _yuklemeOrani,
              yukleniyorMu: _yukleniyorMu,
              onGaleridenSec: () => _gorselSec(kameradan: false),
              onKameradanCek: () => _gorselSec(kameradan: true),
              onBulutaYukle: _bulutaYukle,
            ),
            const SizedBox(height: 16),
            BildirimListesiKarti(
              bildirimler: _bildirimler,
              token: _fcmToken,
              konuyaAboneMi: _konuyaAboneMi,
              onAboneDegisti: _aboneDegistir,
            ),
          ],
        ),
      ),
    );
  }
}

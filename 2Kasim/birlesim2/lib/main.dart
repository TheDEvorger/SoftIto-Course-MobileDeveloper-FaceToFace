import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UrunModel {
  final int id;
  final String baslik;
  final double fiyat;
  final String resimURL;
  final String kategori;

  UrunModel({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.resimURL,
    required this.kategori,
  });

  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0,

      baslik: json['title'] as String? ?? "İsimsiz Ürün",

      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,

      resimURL: json['image'] as String? ?? "https://via.placeholder.com/150",

      kategori: json['category'] as String? ?? "Genel",
    );
  }
}

abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = "https://fakestoreapi.com/products";

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      final yanit = await http
          .get(Uri.parse(_baseUrl))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception("Ağ zaman aşımına uğradı.");
            },
          );

      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Sunucu Hatası ${yanit.statusCode}");
      }
    } catch (e) {
      debugPrint('Ağ Hatası: $e');
      rethrow;
    }
  }
}

void main() {
  runApp(const UrunUygulamasi());
}

class UrunUygulamasi extends StatelessWidget {
  const UrunUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ürün Listesi',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const Listecibasi(),
    );
  }
}

class Listecibasi extends StatefulWidget {
  const Listecibasi({super.key, this.servis});

  final IUrunServisi? servis;

  @override
  State<Listecibasi> createState() => _ListecibasiState();
}

class _ListecibasiState extends State<Listecibasi> {
  late final IUrunServisi _servis;
  late Future<List<UrunModel>> _urunlerFuture;

  @override
  void initState() {
    super.initState();
    _servis = widget.servis ?? CanliApiUrunServisi();
    _urunlerFuture = _servis.urunleriGetir();
  }

  Future<void> _yenile() async {
    setState(() {
      _urunlerFuture = _servis.urunleriGetir();
    });
    try {
      await _urunlerFuture;
    } catch (_) {
      // Hata FutureBuilder tarafından gösterilir.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _yenile,
          ),
        ],
      ),
      body: FutureBuilder<List<UrunModel>>(
        future: _urunlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Bir hata oluştu:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _yenile,
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }

          final urunler = snapshot.data ?? [];
          if (urunler.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı.'));
          }

          return RefreshIndicator(
            onRefresh: _yenile,
            child: ListView.separated(
              itemCount: urunler.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final urun = urunler[index];
                return ListTile(
                  leading: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      urun.resimURL,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    urun.baslik,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(urun.kategori),
                  trailing: Text(
                    '\$${urun.fiyat.toStringAsFixed(2)}',
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
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
      print('Ağ Hatası: $e');
      rethrow;
    }
  }
}

void main(){
  runApp(
    const listecibasi();
  )
}

class Listecibasi extends StatefulWidget {
  const Listecibasi({super.key});

  @override
  State<Listecibasi> createState() => _ListecibasiState();
}

class _ListecibasiState extends State<Listecibasi> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
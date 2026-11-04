// Kategori enumunu servis imzalarında kullanır
import '../models/kategori.dart';
// Ürün modelini servis imzalarında kullanır
import '../models/urun.dart';
// Ürün servislerinin uygulaması gereken sözleşmeyi tanımlar
abstract class IUrunServisi{
  // Bütün ürünleri gelecekte liste olarak döndüren metot
  Future<List<Urun>> tumUrunleriGetir(); //asenkron
  // Verilen kategoriye ait ürünleri asenkron getirme metodu
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);
  // Arama metnine göre ürün listesi döndüren metot
  Future<List<Urun>> adaGoreAra(String aramaMetni);
}

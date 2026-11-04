// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Stok durumunu gösteren değişmez widget sınıfı
class StokRozeti extends StatelessWidget{
 // Ürünün stok miktarını tutar
 final int stok;
 // Stok bilgisini zorunlu alan constructor
 const StokRozeti({super.key, required this.stok});
// Üst sınıfın build metodunu yeniden yazar
@override
// Stok etiketinin arayüzünü oluşturur
Widget build(BuildContext context){
  // Stok sıfırsa ürünün tükendiğini belirler
  final tukendiMi=stok==0;
  // Stok durumunu göstermek için kutu oluşturur
  return Container(
    // Etiketin yatay ve dikey iç boşluğunu ayarlar
    padding : const EdgeInsets.symmetric(horizontal:8, vertical: 4),
    // Arka plan ve köşe görünümünü belirler
    decoration: BoxDecoration(
      // Stok yoksa kırmızı, varsa yeşil arka plan seçer
      color: tukendiMi?Colors.red.shade100:Colors.green.shade100,
      // Etiketin köşelerini yuvarlar
      borderRadius: BorderRadius.circular(6),
      // Etikete çerçeve ekler
      border: Border.all(
        // Stok yoksa kırmızı, varsa yeşil kenarlık seçer
        color: tukendiMi? Colors.red.shade300 : Colors.green.shade300,
        // Kenar çizgisini 0,8 kalınlıkta yapar
        width: 0.8,
      )
    ),
    // Kutunun içindeki stok metnini oluşturur
    child: Text(
     // Stok sıfırsa Tükendi, değilse stok sayısını yazar
     tukendiMi ? "Tükendi": 'Stok:$stok',
     // Metnin yazı stilini belirler
     style: TextStyle(
      // Stok durumuna göre yazı rengini seçer
      color: tukendiMi?Colors.red.shade900 : Colors.green.shade900,
      // Yazı boyutunu 11 yapar
      fontSize:11,
      // Yazıyı kalın yapar
      fontWeight: FontWeight.bold,
     ),
    )   
  );
}
}

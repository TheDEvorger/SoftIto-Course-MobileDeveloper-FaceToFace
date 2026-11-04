// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Bir çağın adını, açıklamasını, renklerini ve rütbelerini tutar
class Era {
  // Era nesnesinin başlangıç bilgilerini alır
  const Era(this.name, this.tagline, this.primary, this.secondary, this.accent,
      // ranks); için isteğe bağlı başlangıç değeri alır
      this.ranks);
  // Ad bilgisini tutar
  final String name;
  // tagline bilgisini saklar
  final String tagline;
  // Temel rengi tutar
  final Color primary;
  // İkincil rengi tutar
  final Color secondary;
  // Vurgu rengini tutar
  final Color accent;
  // Çağ içindeki dört rütbe adını tutar
  final List<String> ranks;
}
// Çağların sıralı listesini ve her çağın dört rütbesini tutar
const eras = <Era>[
  // Yeni Era nesnesi oluşturur
  Era('Uyanış', 'Bir kıvılcımla başlar.', Color(0xFF246F72), Color(0xFFB6E9DE),
      // Hex kodundan renk oluşturur
      Color(0xFFFFC66E), ['Kıvılcım', 'Çırak', 'Yolcu', 'İzci']),
  // Yeni Era nesnesi oluşturur
  Era(
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Nizam',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Söz mühürlenir, düzen kurulur.',
      // Hex kodundan renk oluşturur
      Color(0xFF436FA6),
      // Hex kodundan renk oluşturur
      Color(0xFFC5E3F6),
      // Hex kodundan renk oluşturur
      Color(0xFFF6BD70),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      ['Kâtip', 'Tertipçi', 'Mühürdar', 'Ahit Bekçisi']),
  // Yeni Era nesnesi oluşturur
  Era(
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Sefer',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Yol uzundur; çizme sağlam.',
      // Hex kodundan renk oluşturur
      Color(0xFF148572),
      // Hex kodundan renk oluşturur
      Color(0xFFB7F3DD),
      // Hex kodundan renk oluşturur
      Color(0xFFEE9D59),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      ['Avcı', 'Maceracı', 'Öncü', 'Sancaktar']),
  // Yeni Era nesnesi oluşturur
  Era(
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Kudret',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Kalkanın asıl gücü istikrardır.',
      // Hex kodundan renk oluşturur
      Color(0xFF6860AE),
      // Hex kodundan renk oluşturur
      Color(0xFFD7D2FA),
      // Hex kodundan renk oluşturur
      Color(0xFFFFCB68),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      ['Silahşor', 'Muhafız', 'Süvari', 'Serdar']),
  // Yeni Era nesnesi oluşturur
  Era(
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Beylik',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Bir çentikten bir kaleye.',
      // Hex kodundan renk oluşturur
      Color(0xFFA0526F),
      // Hex kodundan renk oluşturur
      Color(0xFFF8CCDB),
      // Hex kodundan renk oluşturur
      Color(0xFFE6A951),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      ['Toprak Sahibi', 'Toprak Beyi', 'Derebeyi', 'Beylerbeyi']),
  // Yeni Era nesnesi oluşturur
  Era(
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Taht',
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Kral öldü! Yaşasın yeni kral!',
      // Hex kodundan renk oluşturur
      Color(0xFF3158AE),
      // Hex kodundan renk oluşturur
      Color(0xFFCEDEFF),
      // Hex kodundan renk oluşturur
      Color(0xFFF5BF59),
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      ['Divan Reisi', 'Veliaht', 'Kral Naibi', 'Taç Giyen']),
];
// Seviyeye göre hangi çağda olunduğunu belirler
Era eraForLevel(int level) => eras[((level - 1).clamp(0, 23)) ~/ 4];
// Seviyenin çağ içindeki rütbe adını döndürür
String rankForLevel(int level) =>
    // Seviyeye göre hangi çağda olunduğunu belirler
    eraForLevel(level).ranks[(level - 1).clamp(0, 23) % 4];

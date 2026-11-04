// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Bir rozetin adını, simgesini ve ait olduğu çağı tutar
class BadgeDefinition {
  // BadgeDefinition nesnesinin başlangıç bilgilerini alır
  const BadgeDefinition(
      // ID için isteğe bağlı başlangıç değeri alır
      this.id, this.name, this.description, this.icon, this.era,
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {this.future = false});
  // Kaydı diğerlerinden ayıran IDyi tutar
  final int id;
  // Ad bilgisini tutar
  final String name;
  // Açıklama metnini tutar
  final String description;
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // Rozetin veya kartın ait olduğu çağ bilgisini tutar
  final int era;
  // Henüz uygulanmayan rozet özelliğini belirtir
  final bool future;
}
// Kazanılabilecek rozetleri koşullarıyla birlikte listeler
const badges = <BadgeDefinition>[
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // İlk Çentik rozetinin numarasını 1 olarak belirler
      1, 'İlk Çentik', 'İlk vazifeni bitir.', Icons.auto_awesome, 0),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Mühür Daha Islak rozetinin numarasını 2 olarak belirler
      2, 'Mühür Daha Islak', 'İlk ahdini yaz.', Icons.history_edu, 0),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Yorganla Ateşkes rozetinin numarasını 3 olarak belirler
      3, 'Yorganla Ateşkes', 'Beş vazife tamamla.', Icons.wb_sunny_outlined, 0),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(4, 'Külden Kalkan', 'Aksadıktan sonra yeniden dön.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.local_fire_department_outlined, 0),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(5, 'Takvimin Efendisi', 'Yedi farklı gün ilerle.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.calendar_month_outlined, 1),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Mühür Bozulmadı rozetinin numarasını 6 olarak belirler
      6, 'Mühür Bozulmadı', 'İlk ahdini tamamla.', Icons.verified_outlined, 1),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Dakika Avcısı rozetinin numarasını 7 olarak belirler
      7, 'Dakika Avcısı', 'On vazife tamamla.', Icons.timer_outlined, 1),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(8, 'Kâtiplerin Korkusu', 'Dört hafta değerlendir.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.menu_book_outlined, 1,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Pusula Şaşmaz rozetinin numarasını 9 olarak belirler
      9, 'Pusula Şaşmaz', '14 gün boyunca %80 uyum.', Icons.explore_outlined, 2,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(10, 'Üç Cepheli Sefer', 'Üç alışkanlığı aynı gün bitir.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.flag_outlined, 2),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(11, 'Ejderha da Neymiş!', 'Beş zor vazife tamamla.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.bolt_outlined, 2),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(
      // Çizmeler Eskidi rozetinin numarasını 12 olarak belirler
      12, 'Çizmeler Eskidi', 'Yüz vazife tamamla.', Icons.hiking_outlined, 2),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(13, 'Demir İrade', 'Otuz güne yayılan istikrar.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.shield_outlined, 3,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(14, 'Kalkanı Yere Koyma', 'Üç defa geri dön.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.security_outlined, 3),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(15, 'Fırtına Yararı', 'Zor haftadan sonra toparlan.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.thunderstorm_outlined, 3,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(16, 'Nöbetin Ustası', 'Dinlenme ve çalışma dengesini kur.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.nights_stay_outlined, 3,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(17, 'Köyden Kaleye', 'Üç alışkanlığı bir ay sürdür.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.castle_outlined, 4,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(18, 'Haritaya Sığmayan', 'Üç alanda gelişim göster.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.public_outlined, 4,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(19, 'Ferman Üstüne Ferman', 'Beş ahit tamamla.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.receipt_long_outlined, 4),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(20, 'Seferin Mimarı', 'Otuz günlük seferi tamamla.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.architecture_outlined, 4,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(21, 'Mihmandarın Eli', 'İlk doğrulanmış topluluk yardımın.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.volunteer_activism_outlined, 5,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(22, 'Meydanın Dayanağı', 'On faydalı topluluk yardımın.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.groups_outlined, 5,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(23, 'Vakanüvis', 'On iki haftalık kronik yaz.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.auto_stories_outlined, 5,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
  // Yeni BadgeDefinition nesnesi oluşturur
  BadgeDefinition(24, 'Tahtın Tozunu Aldık!', '90 günlük seferi bitir.',
      // Arayüzde kullanılacak simgeyi seçer
      Icons.workspace_premium_outlined, 5,
      // Henüz aktif olmayan rozet özelliğini işaretler
      future: true),
];

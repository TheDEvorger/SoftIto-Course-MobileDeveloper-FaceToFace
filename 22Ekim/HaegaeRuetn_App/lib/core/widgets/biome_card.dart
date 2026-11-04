// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Çağ ve rütbe modelini projeye ekler
import '../models/era.dart';
// Krallık tema ayarlarını projeye ekler
import '../theme/realm_theme.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import 'ornate_widgets.dart';
// Fantasy biome data detailing visual lore and emblems for the 6 ages.
// Biyomun görselini, aşamalarını ve gösterim metinlerini tutar
class BiomeData {
  // BiomeData nesnesinin başlangıç bilgilerini alır
  const BiomeData({
    // roman number parametresini zorunlu tutar
    required this.romanNumber,
    // biome name parametresini zorunlu tutar
    required this.biomeName,
    // description parametresini zorunlu tutar
    required this.description,
    // motif icon parametresini zorunlu tutar
    required this.motifIcon,
    // rütbe icons parametresini zorunlu tutar
    required this.rankIcons,
  });
  // roman number bilgisini saklar
  final String romanNumber;
  // biome name bilgisini saklar
  final String biomeName;
  // Açıklama metnini tutar
  final String description;
  // motif icon bilgisini saklar
  final IconData motifIcon;
  // rütbe icons bilgisini saklar
  final List<IconData> rankIcons;
  // biomes öğelerini içeren listeyi hazırlar
  static const biomes = <BiomeData>[
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'I',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Zümrüt Vadi & Şafak Ormanı',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Sisli zümrüt vadilerde ilk kıvılcım parlar; küçük adımlar yeşerir.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.wb_sunny_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.local_fire_department_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.eco_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.hiking_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.explore_rounded,
      ],
    ),
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'II',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Mavi Kuleler & Yemin Şehri',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Kâtipler divanı ve taş kütüphaneler. Sözler fermanla mühürlenir.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.auto_stories_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.edit_note_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.receipt_long_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.verified_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.history_edu_rounded,
      ],
    ),
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'III',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Kadim Yaban & Rüzgarlı Geçit',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Fırtınalı dağ yolları ve yaban patikalar. Yol uzundur, çizme sağlam.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.navigation_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.pets_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.terrain_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.flag_circle_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.military_tech_rounded,
      ],
    ),
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'IV',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Ametist Hisar & Muhafız Kalesi',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Aşılmaz mor burçlar ve çelik kalkanlar. Sarsılmaz irade diyarı.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.shield_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.security_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.shield_outlined,
        // Menüde kullanılacak simgeyi seçer
        Icons.sports_kabaddi_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.fort_rounded,
      ],
    ),
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'V',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Gül Bahçeleri & Beylik Kasrı',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Bereketli ovalar, taştan şatolar ve altın hasat. Bir çentikten bir kaleye.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.castle_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.foundation_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.cottage_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.domain_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.location_city_rounded,
      ],
    ),
    // Yeni BiomeData nesnesi oluşturur
    BiomeData(
      // Biyomun Roma rakamıyla sıra numarasını belirler
      romanNumber: 'VI',
      // Biyomun ekranda görünen adını belirler
      biomeName: 'Göksel Saray & Taht Zirvesi',
      // Vazifenin veya önerinin açıklamasını belirler
      description:
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Bulutların üzerinde altın kubbe ve ebedi taht. 24 seviyenin nihai tacı.',
      // Biyomun motif simgesini belirler
      motifIcon: Icons.workspace_premium_rounded,
      // Rütbelere ait simgeleri gönderir
      rankIcons: [
        // Menüde kullanılacak simgeyi seçer
        Icons.groups_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.diamond_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.gavel_rounded,
        // Menüde kullanılacak simgeyi seçer
        Icons.workspace_premium_rounded,
      ],
    ),
  ];
}
// Ornate, richly decorated card representing a kingdom biome / age.
// Bir biyomu kullanıcı ilerlemesine göre kart olarak gösterir
class BiomeCard extends StatelessWidget {
  // BiomeCard nesnesinin başlangıç bilgilerini alır
  const BiomeCard({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // indeks parametresini zorunlu tutar
    required this.index,
    // era parametresini zorunlu tutar
    required this.era,
    // user seviye parametresini zorunlu tutar
    required this.userLevel,
    // on tap için isteğe bağlı başlangıç değeri alır
    this.onTap,
  });
  // indeks bilgisini saklar
  final int index;
  // Rozetin veya kartın ait olduğu çağ bilgisini tutar
  final Era era;
  // user seviye bilgisini saklar
  final int userLevel;
  // on tap bilgisini saklar
  final VoidCallback? onTap;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // BiomeCard için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // first için güncel toplamı hesaplar
    final first = index * 4 + 1;
    // last için güncel toplamı hesaplar
    final last = first + 3;
    // aktif bilgisini saklar
    final isActive = userLevel >= first && userLevel <= last;
    // conquered bilgisini saklar
    final isConquered = userLevel > last;
    // locked bilgisini saklar
    final isLocked = userLevel < first;
    // biome öğelerini içeren listeyi hazırlar
    final biome = BiomeData.biomes[index.clamp(0, BiomeData.biomes.length - 1)];
    // Yeni OrnateCard nesnesi oluşturup döndürür
    return OrnateCard(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.all(14),
      // Bu elemanın rengini belirler
      color: isActive
          // Koşul doğruysa kullanılacak sonucu belirler
          ? Color.lerp(era.secondary, Colors.white, 0.45)!
          // Koşul yanlışsa kullanılacak sonucu belirler
          : isConquered
              // Koşul doğruysa kullanılacak sonucu belirler
              ? Color.lerp(era.secondary, const Color(0xFFF9F6ED), 0.75)!
              // Koşul yanlışsa kullanılacak sonucu belirler
              : const Color(0xFFF3EFE6),
      // border color alanına gelen değeri kullanır
      borderColor: isActive
          // Koşul doğruysa kullanılacak sonucu belirler
          ? era.accent
          // Koşul yanlışsa kullanılacak sonucu belirler
          : isConquered
              // Koşul doğruysa kullanılacak sonucu belirler
              ? const Color(0xFFC8BA9B)
              // Koşul yanlışsa kullanılacak sonucu belirler
              : const Color(0xFFDED8CA),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Column(
        // Ana eksene dik yöndeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // İçeride sıralanacak widgetları listeler
        children: [
          // Elemanları yatay yönde sıralar
          Row(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Biome Roman Numeral Badge
              // Arka plan ve ölçüleri olan bir kutu oluşturur
              Container(
                // Elemanın genişliğini belirler
                width: 44,
                // Elemanın veya satırın yüksekliğini ayarlar
                height: 44,
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: BoxDecoration(
                  // Birden fazla rengin geçişini tanımlar
                  gradient: LinearGradient(
                    // Renk geçişinin başlayacağı yönü belirler
                    begin: Alignment.topLeft,
                    // Renk geçişinin biteceği yönü belirler
                    end: Alignment.bottomRight,
                    // Renk geçişinde kullanılacak renkleri listeler
                    colors: isLocked
                        // Koşul doğruysa kullanılacak sonucu belirler
                        ? [const Color(0xFF88867E), const Color(0xFF5F5D56)]
                        // Koşul yanlışsa kullanılacak sonucu belirler
                        : [
                            // Verilen iki renk arasında yumuşak geçiş hesaplar
                            Color.lerp(era.primary, Colors.white, 0.25)!,
                            // Bu çağın ana rengini kullanır
                            era.primary,
                          ],
                  ),
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(14),
                  // Kutunun kenarlık çizgisini oluşturur
                  border: Border.all(
                    // Bu elemanın rengini belirler
                    color: isActive ? era.accent : const Color(0xFFDCC898),
                    // Elemanın genişliğini belirler
                    width: 1.5,
                  ),
                  // Kutunun gölge ayarlarını belirler
                  boxShadow: [
                    // Kutunun düşen gölgesini tanımlar
                    BoxShadow(
                      // Bu elemanın rengini belirler
                      color:
                          // Çağın vurgu rengine saydamlık uygular
                          era.primary.withValues(alpha: isActive ? 0.35 : 0.12),
                      // Gölgenin ne kadar dağıtılacağını belirler
                      blurRadius: 10,
                      // Çizimin hangi yönde kaydırılacağını belirler
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Center(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Text(
                    // Çağın Roma rakamını karta yazar
                    biome.romanNumber,
                    // Yazının ya da butonun görünümünü belirler
                    style: const TextStyle(
                      // Kullanılacak yazı tipini belirler
                      fontFamily: 'serif',
                      // Yazının kalınlığını belirler
                      fontWeight: FontWeight.w900,
                      // Yazının boyutunu belirler
                      fontSize: 18,
                      // Bu elemanın rengini belirler
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(width: 12),
              // İçeriğin kalan alanı doldurmasını sağlar
              Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Column(
                  // Ana eksene dik yöndeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Elemanları yatay yönde sıralar
                    Row(
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // İçeriğin kalan alanı doldurmasını sağlar
                        Expanded(
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: Text(
                            // Gösterilecek veya kullanılacak metin parçasını ekler
                            '${era.name} Çağı',
                            // Yazının ya da butonun görünümünü belirler
                            style: Theme.of(context)
                                // Aktif temanın metin stillerini kullanır
                                .textTheme
                                // Temadan ilgili yazı stilini seçer
                                .titleMedium
                                // Nesne null değilse bu işleme devam eder
                                ?.copyWith(
                                  // Yazının kalınlığını belirler
                                  fontWeight: FontWeight.w900,
                                  // Bu elemanın rengini belirler
                                  color: isLocked
                                      // Koşul doğruysa kullanılacak sonucu belirler
                                      ? const Color(0xFF7A776D)
                                      // Koşul yanlışsa kullanılacak sonucu belirler
                                      : RealmPalette.ink,
                                ),
                          ),
                        ),
                        // Biyomun açık, tamamlanmış veya kilitli durumunu gösteren etiketi oluşturur
                        _buildStatusBadge(isActive, isConquered, isLocked),
                      ],
                    ),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 2),
                    // Ekrana metin yerleştirir
                    Text(
                      // Biyomun görünen adını karta yazar
                      biome.biomeName,
                      // Yazının ya da butonun görünümünü belirler
                      style: TextStyle(
                        // Yazının boyutunu belirler
                        fontSize: 12,
                        // Yazının kalınlığını belirler
                        fontWeight: FontWeight.w700,
                        // Bu elemanın rengini belirler
                        color: isLocked ? const Color(0xFF8E8B81) : era.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 8),
          // Ekrana metin yerleştirir
          Text(
            // Biyomun açıklamasını karta yazar
            biome.description,
            // Yazının ya da butonun görünümünü belirler
            style: const TextStyle(
                // Yazının boyutunu belirler
                fontSize: 11.5, height: 1.35, color: Color(0xFF595449)),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 10),
          // HeraldicDivider nesnesinin başlangıç bilgilerini alır
          const HeraldicDivider(),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 4),
          // Four Ranks in this Biome
          // Elemanları yatay yönde sıralar
          Row(
            // İçeride sıralanacak widgetları listeler
            children: List.generate(4, (rIndex) {
              // rütbe seviye için güncel toplamı hesaplar
              final rankLevel = first + rIndex;
              // rütbe achieved bilgisini saklar
              final isRankAchieved = userLevel >= rankLevel;
              // güncel rütbe bilgisini saklar
              final isCurrentRank = userLevel == rankLevel;
              // rütbe name öğelerini içeren listeyi hazırlar
              final rankName = era.ranks[rIndex];
              // rütbe icon sayısını hesaplar
              final rankIcon = rIndex < biome.rankIcons.length
                  // Koşul doğruysa kullanılacak sonucu belirler
                  ? biome.rankIcons[rIndex]
                  // Koşul yanlışsa kullanılacak sonucu belirler
                  : Icons.shield_outlined;
              // İçeriğin kalan alanı doldurmasını sağlar
              return Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Container(
                  // Bileşenin dışındaki boşluğu belirler
                  margin: EdgeInsets.only(right: rIndex < 3 ? 6 : 0),
                  // İçeriğin kenarlara olan uzaklığını ayarlar
                  padding:
                      // EdgeInsets nesnesi için başlangıç değerlerini alır
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: BoxDecoration(
                    // Bu elemanın rengini belirler
                    color: isCurrentRank
                        // Koşul doğruysa kullanılacak sonucu belirler
                        ? era.accent.withValues(alpha: 0.35)
                        // Koşul yanlışsa kullanılacak sonucu belirler
                        : isRankAchieved
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? Colors.white.withValues(alpha: 0.8)
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : const Color(0xFFE9E5DC).withValues(alpha: 0.5),
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(10),
                    // Kutunun kenarlık çizgisini oluşturur
                    border: Border.all(
                      // Bu elemanın rengini belirler
                      color: isCurrentRank
                          // Koşul doğruysa kullanılacak sonucu belirler
                          ? era.primary
                          // Koşul yanlışsa kullanılacak sonucu belirler
                          : isRankAchieved
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? const Color(0xFFDCC898)
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : const Color(0xFFDDD8CE),
                      // Elemanın genişliğini belirler
                      width: isCurrentRank ? 1.4 : 1.0,
                    ),
                  ),
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Column(
                    // İçeride sıralanacak widgetları listeler
                    children: [
                      // Ekrana bir simge yerleştirir
                      Icon(
                        // Rütbenin simgesini gösterir
                        rankIcon,
                        // Simgenin veya şeklin boyutunu belirler
                        size: 16,
                        // Bu elemanın rengini belirler
                        color: isRankAchieved
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? era.primary
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : const Color(0xFF9E9B91),
                      ),
                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                      const SizedBox(height: 3),
                      // Ekrana metin yerleştirir
                      Text(
                        // Gösterilecek veya kullanılacak metin parçasını ekler
                        'Lv.$rankLevel',
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(
                          // Yazının boyutunu belirler
                          fontSize: 9,
                          // Yazının kalınlığını belirler
                          fontWeight: FontWeight.w900,
                          // Bu elemanın rengini belirler
                          color: isRankAchieved
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? RealmPalette.ink
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : const Color(0xFF8D8A80),
                        ),
                      ),
                      // Ekrana metin yerleştirir
                      Text(
                        // Rütbenin adını gösterir
                        rankName,
                        // text align alanına gelen değeri kullanır
                        textAlign: TextAlign.center,
                        // Metnin veya giriş alanının en fazla satır sayısını belirler
                        maxLines: 1,
                        // Uzun metnin alana sığmayınca nasıl davranacağını belirler
                        overflow: TextOverflow.ellipsis,
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(
                          // Yazının boyutunu belirler
                          fontSize: 8.5,
                          // Yazının kalınlığını belirler
                          fontWeight:
                              // Mevcut rütbenin adını daha kalın gösterir
                              isCurrentRank ? FontWeight.w900 : FontWeight.w600,
                          // Bu elemanın rengini belirler
                          color: isRankAchieved
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? RealmPalette.ink
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : const Color(0xFF8D8A80),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  // Biyomun açık, tamamlanmış veya kilitli durumunu gösteren etiketi oluşturur
  Widget _buildStatusBadge(bool isActive, bool isConquered, bool isLocked) {
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (isActive) {
      // Arka plan ve ölçüleri olan bir kutu oluşturur
      return Container(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        // Kutunun arka plan, kenar ve süslerini ayarlar
        decoration: BoxDecoration(
          // Rengin saydamlığını belirtilen oranda ayarlar
          color: era.accent.withValues(alpha: 0.9),
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(12),
          // Kutunun kenarlık çizgisini oluşturur
          border: Border.all(color: const Color(0xFFC49A28)),
        ),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: const Row(
          // Ana yönde kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçeride sıralanacak widgetları listeler
          children: [
            // Ekrana bir simge yerleştirir
            Icon(Icons.auto_awesome, size: 11, color: Color(0xFF4A3402)),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            SizedBox(width: 4),
            // Ekrana metin yerleştirir
            Text(
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'AKTİF BİYOM',
              // Yazının ya da butonun görünümünü belirler
              style: TextStyle(
                // Yazının boyutunu belirler
                fontSize: 9.5,
                // Yazının kalınlığını belirler
                fontWeight: FontWeight.w900,
                // Bu elemanın rengini belirler
                color: Color(0xFF4A3402),
                // Harfler arasındaki uzaklığı ayarlar
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      );
    }
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (isConquered) {
      // Arka plan ve ölçüleri olan bir kutu oluşturur
      return Container(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        // Kutunun arka plan, kenar ve süslerini ayarlar
        decoration: BoxDecoration(
          // Bu elemanın rengini belirler
          color: const Color(0xFFE2F4EA),
          // Köşelerin yuvarlaklığını belirler
          borderRadius: BorderRadius.circular(12),
          // Kutunun kenarlık çizgisini oluşturur
          border: Border.all(color: const Color(0xFF8FCFA9)),
        ),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: const Row(
          // Ana yönde kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçeride sıralanacak widgetları listeler
          children: [
            // Ekrana bir simge yerleştirir
            Icon(Icons.check_circle_outline,
                // Simgenin veya şeklin boyutunu belirler
                size: 11, color: Color(0xFF1B6B3E)),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            SizedBox(width: 4),
            // Ekrana metin yerleştirir
            Text(
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'AŞILDI',
              // Yazının ya da butonun görünümünü belirler
              style: TextStyle(
                // Yazının boyutunu belirler
                fontSize: 9.5,
                // Yazının kalınlığını belirler
                fontWeight: FontWeight.w900,
                // Bu elemanın rengini belirler
                color: Color(0xFF1B6B3E),
              ),
            ),
          ],
        ),
      );
    }
    // Arka plan ve ölçüleri olan bir kutu oluşturur
    return Container(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      // Kutunun arka plan, kenar ve süslerini ayarlar
      decoration: BoxDecoration(
        // Bu elemanın rengini belirler
        color: const Color(0xFFE7E3D8),
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(12),
        // Kutunun kenarlık çizgisini oluşturur
        border: Border.all(color: const Color(0xFFCCC5B3)),
      ),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: const Row(
        // Ana yönde kaplanacak alanı belirler
        mainAxisSize: MainAxisSize.min,
        // İçeride sıralanacak widgetları listeler
        children: [
          // Ekrana bir simge yerleştirir
          Icon(Icons.lock_outline, size: 10, color: Color(0xFF787467)),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          SizedBox(width: 3),
          // Ekrana metin yerleştirir
          Text(
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'KİLİTLİ',
            // Yazının ya da butonun görünümünü belirler
            style: TextStyle(
              // Yazının boyutunu belirler
              fontSize: 9,
              // Yazının kalınlığını belirler
              fontWeight: FontWeight.w800,
              // Bu elemanın rengini belirler
              color: Color(0xFF787467),
            ),
          ),
        ],
      ),
    );
  }
}

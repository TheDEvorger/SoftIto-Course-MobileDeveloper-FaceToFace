// garden scene data bilgilerini veya işlemlerini tutan sınıf
class GardenSceneData {
  // garden scene data verisi oluşturur
  const GardenSceneData({
    // ID bilgisini zorunlu tutar
    required this.id,
    // ad bilgisini zorunlu tutar
    required this.name,
    // slug bilgisini zorunlu tutar
    required this.slug,
    // usage bilgisini zorunlu tutar
    required this.usage,
    // açıklama bilgisini zorunlu tutar
    required this.description,
    // görsel dosya yolu bilgisini zorunlu tutar
    required this.assetPath,
  });
  // ID bilgisini tutar
  final String id;
  // ad bilgisini tutar
  final String name;
  // slug bilgisini tutar
  final String slug;
  // usage bilgisini tutar
  final String usage;
  // açıklama bilgisini tutar
  final String description;
  // görsel dosya yolu bilgisini tutar
  final String assetPath;
}
// Sabitleri veya ortak işlemleri tutan, nesne oluşturulamayan sınıf
abstract final class GardenScenes {
  // sunrise için metin değeri belirler
  static const sunrise = 'assets/illustrations/scenes/01_garden_sunrise.webp';
  // river için metin değeri belirler
  static const river = 'assets/illustrations/scenes/02_river_grove.webp';
  // clearing için metin değeri belirler
  static const clearing = 'assets/illustrations/scenes/03_forest_clearing.webp';
  // glasshouse için metin değeri belirler
  static const glasshouse = 'assets/illustrations/scenes/04_glasshouse.webp';
  // valley için metin değeri belirler
  static const valley = 'assets/illustrations/scenes/05_mountain_valley.webp';
  // moon için metin değeri belirler
  static const moon = 'assets/illustrations/scenes/06_moon_garden.webp';
  // terrace için metin değeri belirler
  static const terrace = 'assets/illustrations/scenes/07_golden_terrace.webp';
  // waterfall değerini tanımlar
  static const waterfall =
      // "assets/illustrations/scenes/08_emerald_wate…" metnini kullanır
      'assets/illustrations/scenes/08_emerald_waterfall.webp';
  // cottage için metin değeri belirler
  static const cottage = 'assets/illustrations/scenes/09_study_cottage.webp';
  // rainbow için metin değeri belirler
  static const rainbow = 'assets/illustrations/scenes/10_rainbow_garden.webp';
  // all için boş koleksiyon oluşturur
  static const all = <GardenSceneData>[
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-01',
      // ad bilgisini belirler
      name: 'Gün Doğumunda Kır Evi',
      // slug bilgisini belirler
      slug: 'garden_sunrise',
      // usage bilgisini belirler
      usage: 'Ana sayfa / karşılama',
      // açıklama bilgisini belirler
      description: 'Sabah vadisi, kır evi ve bereketli bahçe',
      // görsel dosya yolu bilgisini belirler
      assetPath: sunrise,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-02',
      // ad bilgisini belirler
      name: 'Orman Nehri',
      // slug bilgisini belirler
      slug: 'river_grove',
      // usage bilgisini belirler
      usage: 'Günlük plan / ferahlık',
      // açıklama bilgisini belirler
      description: 'Yeşil ağaçlar ve turkuaz akarsu',
      // görsel dosya yolu bilgisini belirler
      assetPath: river,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-03',
      // ad bilgisini belirler
      name: 'Fenerli Orman Açıklığı',
      // slug bilgisini belirler
      slug: 'forest_clearing',
      // usage bilgisini belirler
      usage: 'Odak öncesi / başarı',
      // açıklama bilgisini belirler
      description: 'Işık süzülen orman ve asılı fenerler',
      // görsel dosya yolu bilgisini belirler
      assetPath: clearing,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-04',
      // ad bilgisini belirler
      name: 'Botanik Kış Bahçesi',
      // slug bilgisini belirler
      slug: 'glasshouse',
      // usage bilgisini belirler
      usage: 'Konular / öğrenme odası',
      // açıklama bilgisini belirler
      description: 'Sarmaşıklar, ahşap raf ve güneşli çalışma mekânı',
      // görsel dosya yolu bilgisini belirler
      assetPath: glasshouse,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-05',
      // ad bilgisini belirler
      name: 'Dağ Vadisi',
      // slug bilgisini belirler
      slug: 'mountain_valley',
      // usage bilgisini belirler
      usage: 'İlerleme ve hedefler',
      // açıklama bilgisini belirler
      description: 'Çiçekli patika, dağ ve göl panoraması',
      // görsel dosya yolu bilgisini belirler
      assetPath: valley,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-06',
      // ad bilgisini belirler
      name: 'Ay Işığı Bahçesi',
      // slug bilgisini belirler
      slug: 'moon_garden',
      // usage bilgisini belirler
      usage: 'Koyu tema / gece odak',
      // açıklama bilgisini belirler
      description: 'Mor gece, altın fenerler, nilüfer gölü',
      // görsel dosya yolu bilgisini belirler
      assetPath: moon,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-07',
      // ad bilgisini belirler
      name: 'Altın Saat Terası',
      // slug bilgisini belirler
      slug: 'golden_terrace',
      // usage bilgisini belirler
      usage: 'Motivasyon / profil',
      // açıklama bilgisini belirler
      description: 'Limon ağaçları ve sıcak taş teras',
      // görsel dosya yolu bilgisini belirler
      assetPath: terrace,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-08',
      // ad bilgisini belirler
      name: 'Zümrüt Şelaleler',
      // slug bilgisini belirler
      slug: 'emerald_waterfall',
      // usage bilgisini belirler
      usage: 'Konu haritası / keşif',
      // açıklama bilgisini belirler
      description: 'Canlı turkuaz havuzlar ve katmanlı şelaleler',
      // görsel dosya yolu bilgisini belirler
      assetPath: waterfall,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-09',
      // ad bilgisini belirler
      name: 'Orman Çalışma Kulübesi',
      // slug bilgisini belirler
      slug: 'study_cottage',
      // usage bilgisini belirler
      usage: 'Pomodoro / odak',
      // açıklama bilgisini belirler
      description: 'Orman evinin çalışma masası, altın ışık',
      // görsel dosya yolu bilgisini belirler
      assetPath: cottage,
    ),
    // garden scene data verisi oluşturur
    GardenSceneData(
      // ID bilgisini belirler
      id: 'SCENE-10',
      // ad bilgisini belirler
      name: 'Yağmur Sonrası Bahçe',
      // slug bilgisini belirler
      slug: 'rainbow_garden',
      // usage bilgisini belirler
      usage: 'Başarı / ilerleme',
      // açıklama bilgisini belirler
      description: 'Islak yapraklar, hafif gökkuşağı, parlak taş yol',
      // görsel dosya yolu bilgisini belirler
      assetPath: rainbow,
    ),
  ];
}

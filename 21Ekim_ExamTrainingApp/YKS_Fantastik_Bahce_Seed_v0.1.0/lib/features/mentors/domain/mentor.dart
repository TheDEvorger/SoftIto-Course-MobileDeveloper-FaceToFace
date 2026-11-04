// fantasy mentor bilgilerini veya işlemlerini tutan sınıf
class FantasyMentor {
  // fantasy mentor nesnesini oluşturur
  const FantasyMentor({
    // ID bilgisini zorunlu tutar
    required this.id,
    // ad bilgisini zorunlu tutar
    required this.name,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // ders bilgisini zorunlu tutar
    required this.subject,
    // avatar asset bilgisini zorunlu tutar
    required this.avatarAsset,
    // catchphrase bilgisini zorunlu tutar
    required this.catchphrase,
    // live lesson title bilgisini zorunlu tutar
    required this.liveLessonTitle,
    // is live now bilgisini zorunlu tutar
    required this.isLiveNow,
    // lesson time bilgisini zorunlu tutar
    required this.lessonTime,
    // lesson summary bilgisini zorunlu tutar
    required this.lessonSummary,
    // wisdom quote bilgisini zorunlu tutar
    required this.wisdomQuote,
    // specialty tags bilgisini zorunlu tutar
    required this.specialtyTags,
    // suggested questions bilgisini zorunlu tutar
    required this.suggestedQuestions,
  });
  // ID bilgisini tutar
  final String id;
  // ad bilgisini tutar
  final String name;
  // başlık bilgisini tutar
  final String title;
  // ders bilgisini tutar
  final String subject;
  // avatar asset bilgisini tutar
  final String avatarAsset;
  // catchphrase bilgisini tutar
  final String catchphrase;
  // live lesson title bilgisini tutar
  final String liveLessonTitle;
  // is live now bilgisini tutar
  final bool isLiveNow;
  // lesson time bilgisini tutar
  final String lessonTime;
  // lesson summary bilgisini tutar
  final String lessonSummary;
  // wisdom quote bilgisini tutar
  final String wisdomQuote;
  // specialty tags bilgisini tutar
  final List<String> specialtyTags;
  // suggested questions bilgisini tutar
  final List<String> suggestedQuestions;
  // all mentors bilgisini hesaplayıp saklar
  static const List<FantasyMentor> allMentors = [
    // fantasy mentor nesnesini oluşturur
    FantasyMentor(
      // ID bilgisini belirler
      id: 'theron',
      // ad bilgisini belirler
      name: 'Archmage Theron',
      // Başlığı belirler
      title: 'Sayısal Büyüleri & Kadim Geometri Üstadı',
      // ders bilgisini belirler
      subject: 'Matematik & Geometri',
      // avatar asset bilgisini belirler
      avatarAsset: 'assets/illustrations/mentors/mentor_theron.jpg',
      // catchphrase bilgisini belirler
      catchphrase: 'Türev ve integral, evrenin kadim denge mühürleridir.',
      // live lesson title bilgisini belirler
      liveLessonTitle: 'Türev Büyüsü ile Maksimum-Minimum Düğümlerini Çözme',
      // is live now bilgisini belirler
      isLiveNow: true,
      // lesson time bilgisini belirler
      lessonTime: 'Şimdi Yayında (1.420 Aday İzliyor)',
      // lesson summary bilgisini belirler
      lessonSummary:
          // "Fonksiyonların teğet eğimlerini ve grafik t…" metnini kullanır
          'Fonksiyonların teğet eğimlerini ve grafik tepe noktalarını geometrik ışık mühürleriyle adım adım inceliyoruz.',
      // wisdom quote bilgisini belirler
      wisdomQuote:
          // "Gözün korkmasın evlat; en karmaşık polinom …" metnini kullanır
          'Gözün korkmasın evlat; en karmaşık polinom bile doğru çarpanlara ayrıldığında bir su damlası gibi berraklaşır.',
      // specialty tags bilgisini belirler
      specialtyTags: ['Türev', 'Trigonometri', 'Analitik Geometri', 'Problemler'],
      // suggested questions bilgisini belirler
      suggestedQuestions: [
        // "Hocam, limit ve süreklilikte en çok nerede …" metnini kullanır
        'Hocam, limit ve süreklilikte en çok nerede hata yapılıyor?',
        // "Trigonometri formüllerini aklımda tutmanın …" metnini kullanır
        'Trigonometri formüllerini aklımda tutmanın büyülü bir yolu var mı?',
        // "Geometride görme yeteneğini nasıl geliştiri…" metnini kullanır
        'Geometride görme yeteneğini nasıl geliştiririm?',
      ],
    ),
    // fantasy mentor nesnesini oluşturur
    FantasyMentor(
      // ID bilgisini belirler
      id: 'sylva',
      // ad bilgisini belirler
      name: 'Bilge Sylva',
      // Başlığı belirler
      title: 'Doğa Ruhları & Hücre Büyücüsü',
      // ders bilgisini belirler
      subject: 'Biyoloji & Canlı Bilimleri',
      // avatar asset bilgisini belirler
      avatarAsset: 'assets/illustrations/mentors/mentor_sylva.jpg',
      // catchphrase bilgisini belirler
      catchphrase: 'Bahçemizdeki her filiz, hücre bölünmesinin saf mucizesidir.',
      // live lesson title bilgisini belirler
      liveLessonTitle: 'Kalıtım ve Ekoloji: Genetik Düğümleri Çözme Seansı',
      // is live now bilgisini belirler
      isLiveNow: true,
      // lesson time bilgisini belirler
      lessonTime: 'Şimdi Yayında (980 Aday İzliyor)',
      // lesson summary bilgisini belirler
      lessonSummary:
          // "Mendel genetiği, kan grupları ve ekosistem …" metnini kullanır
          'Mendel genetiği, kan grupları ve ekosistem madde döngülerini canlı bitki kristalleri üzerinden keşfediyoruz.',
      // wisdom quote bilgisini belirler
      wisdomQuote:
          // "Canlılık bir rekabet değil, mükemmel bir uy…" metnini kullanır
          'Canlılık bir rekabet değil, mükemmel bir uyumdur. Tıpkı düzenli soru çözerek zihnini besleyen bir tohum gibi.',
      // specialty tags bilgisini belirler
      specialtyTags: ['Kalıtım', 'Fotosentez', 'Hücre Bölünmesi', 'Sistemler'],
      // suggested questions bilgisini belirler
      suggestedQuestions: [
        // "Hocam, fotosentez ve solunum reaksiyonların…" metnini kullanır
        'Hocam, fotosentez ve solunum reaksiyonlarını nasıl karıştırmam?',
        // "Kalıtım çaprazlamalarında pratik yöntem var…" metnini kullanır
        'Kalıtım çaprazlamalarında pratik yöntem var mı?',
        // "Biyoloji ezber mi yoksa mantık mı?" metnini kullanır
        'Biyoloji ezber mi yoksa mantık mı?',
      ],
    ),
    // fantasy mentor nesnesini oluşturur
    FantasyMentor(
      // ID bilgisini belirler
      id: 'ignis',
      // ad bilgisini belirler
      name: 'Simyacı Ignis',
      // Başlığı belirler
      title: 'Enerji Dönüşümleri & Element Efendisi',
      // ders bilgisini belirler
      subject: 'Fizik & Kimya',
      // avatar asset bilgisini belirler
      avatarAsset: 'assets/illustrations/mentors/mentor_ignis.jpg',
      // catchphrase bilgisini belirler
      catchphrase: 'Kuvvet ve tepkime; ateş ile aklın kusursuz kıvılcımıdır.',
      // live lesson title bilgisini belirler
      liveLessonTitle: 'Elektromanyetizma & Gaz Yasaları Simya Laboratuvarı',
      // is live now bilgisini belirler
      isLiveNow: false,
      // lesson time bilgisini belirler
      lessonTime: 'Bugün 20:30 (Canlı Deney)',
      // lesson summary bilgisini belirler
      lessonSummary:
          // "Manyetik alan kuvvet çizgilerini plazma kür…" metnini kullanır
          'Manyetik alan kuvvet çizgilerini plazma kürelerinde gözlemleyip ideal gaz denklemini kıvılcımlarla patlatıyoruz!',
      // wisdom quote bilgisini belirler
      wisdomQuote:
          // "Enerji asla yok olmaz; sadece doğru çalışma…" metnini kullanır
          'Enerji asla yok olmaz; sadece doğru çalışma disipliniyle hedefine ulaşan bir vektöre dönüşür!',
      // specialty tags bilgisini belirler
      specialtyTags: ['Bağıl Hareket', 'Elektrik', 'Kimyasal Denge', 'Organik'],
      // suggested questions bilgisini belirler
      suggestedQuestions: [
        // "İtme-Momentum sorularında yön hatalarını na…" metnini kullanır
        'İtme-Momentum sorularında yön hatalarını nasıl engellerim?',
        // "Kimyasal dengede Le Chatelier ilkesini nası…" metnini kullanır
        'Kimyasal dengede Le Chatelier ilkesini nasıl kafama kazırım?',
        // "Elektrik devrelerinde potansiyel fark bulma…" metnini kullanır
        'Elektrik devrelerinde potansiyel fark bulma taktiği nedir?',
      ],
    ),
    // fantasy mentor nesnesini oluşturur
    FantasyMentor(
      // ID bilgisini belirler
      id: 'valerius',
      // ad bilgisini belirler
      name: 'Ozan Valerius',
      // Başlığı belirler
      title: 'Kelimelerin Büyücüsü & Kadim Tarihçi',
      // ders bilgisini belirler
      subject: 'Türkçe, Edebiyat & Sosyal',
      // avatar asset bilgisini belirler
      avatarAsset: 'assets/illustrations/mentors/mentor_valerius.jpg',
      // catchphrase bilgisini belirler
      catchphrase: 'Kelimeler kılıçtan keskindir; paragrafı anlayan sınavı büker.',
      // live lesson title bilgisini belirler
      liveLessonTitle: '30 Saniyede Paragraf Ana Düşüncesini Mühürleme',
      // is live now bilgisini belirler
      isLiveNow: false,
      // lesson time bilgisini belirler
      lessonTime: 'Yarın 19:00',
      // lesson summary bilgisini belirler
      lessonSummary:
          // "Paragraf metinlerinde yazarın gizlediği ipu…" metnini kullanır
          'Paragraf metinlerinde yazarın gizlediği ipucu kelimeleri sezme ve akış bozan cümleleri tek hamlede eleme sanatı.',
      // wisdom quote bilgisini belirler
      wisdomQuote:
          // "Okumak, başkasının zihninde güvenle yolculu…" metnini kullanır
          'Okumak, başkasının zihninde güvenle yolculuk yapmaktır. Metnin kalbine odaklanırsan seçenekler sana teslim olur.',
      // specialty tags bilgisini belirler
      specialtyTags: ['Paragraf Taktikleri', 'Divan Edebiyatı', 'Tarih', 'Felsefe'],
      // suggested questions bilgisini belirler
      suggestedQuestions: [
        // "Paragrafta iki şık arasında kalınca hangisi…" metnini kullanır
        'Paragrafta iki şık arasında kalınca hangisini seçmeliyim?',
        // "Cumhuriyet Dönemi yazarlarını karıştırmamak…" metnini kullanır
        'Cumhuriyet Dönemi yazarlarını karıştırmamak için ne yapmalıyım?',
        // "Uzun sorularda dikkatim dağılıyor, odaklanm…" metnini kullanır
        'Uzun sorularda dikkatim dağılıyor, odaklanma tüyosu var mı?',
      ],
    ),
  ];
}

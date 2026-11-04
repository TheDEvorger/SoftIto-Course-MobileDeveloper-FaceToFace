// kiralama araç dosyasını ekler
import '../domain/rental_vehicle.dart';
// Bundled representative collection. No live supplier data or remote images.
// kiralama araç kataloğu değerini belirler
const rentalCatalog = <RentalVehicle>[
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'clio',
      // Ad bilgisini belirler
      name: 'Renault Clio',
      // Kategori bilgisini belirler
      category: 'Ekonomik',
      // Şehir bilgisini belirler
      city: 'İstanbul',
      // pickup bilgisini belirler
      pickup: 'Kadıköy',
      // Enerji türünü belirler
      energy: 'Benzin',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 145000,
      // görsel bilgisini belirler
      image: 'compact',
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Şehir içindeki kısa rotalar için pratik bir seçenek. Kompakt sınıf, otomatik vites ve kolay park.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'bmw-320',
      // Ad bilgisini belirler
      name: 'BMW 320i',
      // Kategori bilgisini belirler
      category: 'Premium',
      // Şehir bilgisini belirler
      city: 'İstanbul',
      // pickup bilgisini belirler
      pickup: 'Beşiktaş',
      // Enerji türünü belirler
      energy: 'Benzin',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 385000,
      // görsel bilgisini belirler
      image: 'touring',
      // filo bilgisini belirler
      fleet: false,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'İş planlarından hafta sonu kaçamaklarına. Geniş kabin ve konfor odaklı premium sınıf.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'tesla-3',
      // Ad bilgisini belirler
      name: 'Tesla Model 3',
      // Kategori bilgisini belirler
      category: 'Elektrikli',
      // Şehir bilgisini belirler
      city: 'İstanbul',
      // pickup bilgisini belirler
      pickup: 'Ataşehir',
      // Enerji türünü belirler
      energy: 'Elektrik',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 295000,
      // görsel bilgisini belirler
      image: 'electric',
      // bags bilgisini belirler
      bags: 3,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Sessiz bir sürüş, ferah bir kabin. Elektrikli otomobil deneyimini rotanıza ekleyin.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'peugeot-3008',
      // Ad bilgisini belirler
      name: 'Peugeot 3008',
      // Kategori bilgisini belirler
      category: 'SUV',
      // Şehir bilgisini belirler
      city: 'İzmir',
      // pickup bilgisini belirler
      pickup: 'Bornova',
      // Enerji türünü belirler
      energy: 'Hibrit',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 265000,
      // görsel bilgisini belirler
      image: 'suv',
      // bags bilgisini belirler
      bags: 3,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Aile planlarına ve uzun rotalara yer açın. Yüksek oturma konumu ve geniş bagaj.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'corolla',
      // Ad bilgisini belirler
      name: 'Toyota Corolla',
      // Kategori bilgisini belirler
      category: 'Konfor',
      // Şehir bilgisini belirler
      city: 'Ankara',
      // pickup bilgisini belirler
      pickup: 'Çankaya',
      // Enerji türünü belirler
      energy: 'Hibrit',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 195000,
      // görsel bilgisini belirler
      image: 'electric',
      // bags bilgisini belirler
      bags: 3,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Günlük planlarda rahat bir yol arkadaşı. Sedan kabin ve konforlu yolculuk alanı.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'mercedes-c',
      // Ad bilgisini belirler
      name: 'Mercedes-Benz C200',
      // Kategori bilgisini belirler
      category: 'Premium',
      // Şehir bilgisini belirler
      city: 'İzmir',
      // pickup bilgisini belirler
      pickup: 'Alsancak',
      // Enerji türünü belirler
      energy: 'Benzin',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 425000,
      // görsel bilgisini belirler
      image: 'touring',
      // filo bilgisini belirler
      fleet: false,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Özenli detaylar ve sakin bir sürüş. Özel günler ve uzun yol planları için premium sınıf.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'golf',
      // Ad bilgisini belirler
      name: 'Volkswagen Golf',
      // Kategori bilgisini belirler
      category: 'Konfor',
      // Şehir bilgisini belirler
      city: 'İstanbul',
      // pickup bilgisini belirler
      pickup: 'Bakırköy',
      // Enerji türünü belirler
      energy: 'Benzin',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 225000,
      // görsel bilgisini belirler
      image: 'compact',
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Şehir ve uzun yol arasında dengeli bir seçenek. Kompakt gövde, kullanışlı iç mekân.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'i20',
      // Ad bilgisini belirler
      name: 'Hyundai i20',
      // Kategori bilgisini belirler
      category: 'Ekonomik',
      // Şehir bilgisini belirler
      city: 'Ankara',
      // pickup bilgisini belirler
      pickup: 'Kızılay',
      // Enerji türünü belirler
      energy: 'Benzin',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 135000,
      // görsel bilgisini belirler
      image: 'compact',
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Gündelik işlerinize ve kısa kaçamaklara uyum sağlayan ekonomik sınıf otomobil.'),
  // kiralama araç nesnesi oluşturur
  RentalVehicle(
      // ID bilgisini belirler
      id: 'tucson',
      // Ad bilgisini belirler
      name: 'Hyundai Tucson',
      // Kategori bilgisini belirler
      category: 'SUV',
      // Şehir bilgisini belirler
      city: 'İstanbul',
      // pickup bilgisini belirler
      pickup: 'Üsküdar',
      // Enerji türünü belirler
      energy: 'Hibrit',
      // Günlük fiyatı kuruş cinsinden belirler
      dailyMinor: 285000,
      // görsel bilgisini belirler
      image: 'suv',
      // bags bilgisini belirler
      bags: 3,
      // açıklama bilgisini belirler
      description:
          // İlgili metin değerini belirler
          'Daha geniş bir yolculuk alanı. Hafta sonu valizleri ve aile rotaları için SUV sınıfı.'),
];

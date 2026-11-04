// Rehber servislerinin uyması gereken metotları tanımlar
abstract class GuideService {
  // Kullanıcı metnine ve rehber tonuna göre yerel yanıt hazırlar
  String reply(String input, GuideTone tone);
  // Seçilen rehber kişiliğinin talimat metnini döndürür
  String systemInstruction(GuideTone tone);
}
// Çevrimdışı rehberin konuşma üslubunu sınırlar
enum GuideTone { commander, sage, companion }
// Bağlantı olmadığında kullanılacak işlemi hazırlar
// Bağlantı olmadan anahtar kelimelere göre rehber cevabı üretir
class OfflineGuideService implements GuideService {
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Seçilen rehber kişiliğinin talimat metnini döndürür
  String systemInstruction(GuideTone tone) => switch (tone) {
        // guide tone.commander bilgisini yeni değerle günceller
        GuideTone.commander =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Kullanıcıyı kararlı ama saygılı bir komutan gibi destekle. Zorlamadan mikro hedef öner.',
        // guide tone.sage bilgisini yeni değerle günceller
        GuideTone.sage =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Kullanıcıyı yargılamadan dinle, sakin ve düşünceli şekilde küçük adım sun.',
        // guide tone.companion bilgisini yeni değerle günceller
        GuideTone.companion =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Sıcak, doğal ve samimi konuş. Tek uygulanabilir küçük adım öner.',
      };
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Kullanıcı metnine ve rehber tonuna göre yerel yanıt hazırlar
  String reply(String input, GuideTone tone) {
    // Kullanıcının yazdığı metni düzenlemeye hazırlar
    final text = input.toLowerCase();
    // Koleksiyonda aranan öğe bulunup bulunmadığını kontrol eder
    if (text.contains('yorgun') ||
        // Mesajdaki ilgili anahtar kelimeyi arar
        text.contains('zor') ||
        // Mesajdaki ilgili anahtar kelimeyi arar
        text.contains('bırak') ||
        // Mesajdaki ilgili anahtar kelimeyi arar
        text.contains('vazgeç')) {
      // Duruma göre uygun sonucu seçer
      return switch (tone) {
        // guide tone.commander bilgisini yeni değerle günceller
        GuideTone.commander =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Yolcu! Bugünkü cephemiz küçük: yalnızca beş dakika. Sonra dinlenmeyi yeniden değerlendir.',
        // guide tone.sage bilgisini yeni değerle günceller
        GuideTone.sage =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Bazen ilerlemek yükü azaltmaktır. Beş dakikalık bir deneme veya planlı istirahat seçebilirsin.',
        // guide tone.companion bilgisini yeni değerle günceller
        GuideTone.companion =>
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Anlıyorum, bugün kolay geçmiyor. Beş dakika deneyebilir ya da hakkın olan bir mola verebilirsin.',
      };
    }
    // Koleksiyonda aranan öğe bulunup bulunmadığını kontrol eder
    if (text.contains('başard') ||
        // Mesajdaki ilgili anahtar kelimeyi arar
        text.contains('bitti') ||
        // Mesajdaki ilgili anahtar kelimeyi arar
        text.contains('tamamlad')) {
      // Hesaplanan değeri çağıran yere geri döndürür
      return 'Borazanlar çalıyor! ✨ Başardığın şeyi kroniğine ekle. Sonraki adımı küçük ve sürdürülebilir tut.';
    }
    // Duruma göre uygun sonucu seçer
    return switch (tone) {
      // guide tone.commander bilgisini yeni değerle günceller
      GuideTone.commander =>
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Ferman açık: bir vazife seç, onu on dakikaya böl ve başla. Düzen, iradenin zırhıdır.',
      // guide tone.sage bilgisini yeni değerle günceller
      GuideTone.sage =>
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Bugün hangi küçük adım seni hedefine yaklaştırır? On dakikalık bir başlangıç iyi olabilir.',
      // guide tone.companion bilgisini yeni değerle günceller
      GuideTone.companion =>
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Beraber minicik bir adım seçelim. Hangi vazifeyi bugün biraz ilerletebiliriz?',
    };
  }
}

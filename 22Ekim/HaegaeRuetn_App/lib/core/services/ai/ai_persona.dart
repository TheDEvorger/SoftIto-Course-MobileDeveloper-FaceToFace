// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Rehberin komutan, bilge ve yoldaş türlerini sınırlar
enum AiPersonaType { commander, sage, companion }
// Persona configuration for the Bilge Rehber AI companion.
// Bilge Rehberin kişilik renklerini ve sistem talimatlarını tutar
class AiPersona {
  // AiPersona nesnesinin başlangıç bilgilerini alır
  const AiPersona({
    // type parametresini zorunlu tutar
    required this.type,
    // name parametresini zorunlu tutar
    required this.name,
    // başlık parametresini zorunlu tutar
    required this.title,
    // tagline parametresini zorunlu tutar
    required this.tagline,
    // icon parametresini zorunlu tutar
    required this.icon,
    // primary color parametresini zorunlu tutar
    required this.primaryColor,
    // secondary color parametresini zorunlu tutar
    required this.secondaryColor,
  });
  // type bilgisini saklar
  final AiPersonaType type;
  // Ad bilgisini tutar
  final String name;
  // Başlık metnini tutar
  final String title;
  // tagline bilgisini saklar
  final String tagline;
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // primary color bilgisini saklar
  final Color primaryColor;
  // secondary color bilgisini saklar
  final Color secondaryColor;
  // commander bilgisini saklar
  static const commander = AiPersona(
    // type alanına gelen değeri kullanır
    type: AiPersonaType.commander,
    // Vazifenin veya kişiliğin adını belirler
    name: 'Komutan',
    // başlık alanına gösterilecek metni belirler
    title: 'Kraliyet Serdarı',
    // tagline alanına gösterilecek metni belirler
    tagline: 'Disiplinli, kararlı, stratejik ve yapıcı.',
    // Buton veya kartta kullanılacak simgeyi seçer
    icon: Icons.shield_rounded,
    // primary color alanına belirtilen renk değerini kullanır
    primaryColor: Color(0xFF6860AE),
    // secondary color alanına belirtilen renk değerini kullanır
    secondaryColor: Color(0xFFD7D2FA),
  );
  // sage bilgisini saklar
  static const sage = AiPersona(
    // type alanına gelen değeri kullanır
    type: AiPersonaType.sage,
    // Vazifenin veya kişiliğin adını belirler
    name: 'Bilge',
    // başlık alanına gösterilecek metni belirler
    title: 'Divan Kâtibi',
    // tagline alanına gösterilecek metni belirler
    tagline: 'Sakin, öğretici, derinlikli ve analitik.',
    // Buton veya kartta kullanılacak simgeyi seçer
    icon: Icons.auto_stories_rounded,
    // primary color alanına belirtilen renk değerini kullanır
    primaryColor: Color(0xFF246F72),
    // secondary color alanına belirtilen renk değerini kullanır
    secondaryColor: Color(0xFFB6E9DE),
  );
  // companion bilgisini saklar
  static const companion = AiPersona(
    // type alanına gelen değeri kullanır
    type: AiPersonaType.companion,
    // Vazifenin veya kişiliğin adını belirler
    name: 'Yoldaş',
    // başlık alanına gösterilecek metni belirler
    title: 'Kervan Rehberi',
    // tagline alanına gösterilecek metni belirler
    tagline: 'Samimi, sıcak, esprili ve cesaret verici.',
    // Buton veya kartta kullanılacak simgeyi seçer
    icon: Icons.sentiment_very_satisfied_rounded,
    // primary color alanına belirtilen renk değerini kullanır
    primaryColor: Color(0xFFA0526F),
    // secondary color alanına belirtilen renk değerini kullanır
    secondaryColor: Color(0xFFF8CCDB),
  );
  // Rehberde seçilebilecek bütün kişilikleri listeler
  static const all = [companion, sage, commander];
  // Seçilen rehber türüne karşılık gelen kişiliği döndürür
  static AiPersona fromType(AiPersonaType type) => switch (type) {
        // ai kişilik type.commander bilgisini yeni değerle günceller
        AiPersonaType.commander => commander,
        // ai kişilik type.sage bilgisini yeni değerle günceller
        AiPersonaType.sage => sage,
        // ai kişilik type.companion bilgisini yeni değerle günceller
        AiPersonaType.companion => companion,
      };
  // Kişiliğe göre yapay zekâ sistem talimatını oluşturur
  // Seçilen kişiliğe ve ayarlara göre AI sistem talimatını birleştirir
  String buildSystemPrompt({
    // Yanıtların sade Türkçe olmasını belirler
    bool plainTurkish = false,
    // Kullanıcının rehbere verdiği özel talimatları alır, verilmezse null olabilir
    String? customInstructions,
    // vazife bağlam parametresini isteğe bağlı alır
    String? habitContext,
  }) {
    // Özet metnini satır satır birleştirmek için StringBuffer hazırlar
    final buffer = StringBuffer();
    // Rehberin kimliğini ve evrenini tanıtan talimatları ekler
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Sen, Ałek’ryŧhæ evreninde geçen HægæRûetn adlı krallıkta yaşayan "Bilge Rehber"sin.');
    // AIya ahit önerisinin örnek JSON alanını ekler
    buffer.writeln('Şu anki seçilmiş kişiliğin: **$name ($title)**.');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln();
    // Seçilen kişiliğin konuşma üslubunu belirler
    // Değere göre farklı işlem yolunu seçer
    switch (type) {
      // Komutan seçildiyse disiplinli üslup talimatı ekler
      case AiPersonaType.commander:
        // Sistem talimatına yeni bir satır ekler
        buffer.writeln(
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kişilik tarzın: Bir krallık serdarı gibi kararlı, stratejik, net ve esprili konuş. '
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kullanıcıyı asla küçümseme, suçlama veya utandırma. '
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Zorlandığı anlarda hedefleri derhal 5-10 dakikalık uygulanabilir mikro-cephelere böl.');
      // Bilge seçildiyse sakin ve öğretici üslup talimatı ekler
      case AiPersonaType.sage:
        // Sistem talimatına yeni bir satır ekler
        buffer.writeln(
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kişilik tarzın: Kadim kütüphanelerin bilge bir kâtibi gibi sakin, düşünceli ve analitik konuş. '
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Alışkanlıkların arkasındaki nedenleri anlamaya çalış. '
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'İlerlemenin aceleyle değil, tutarlı sabırla inşa edildiğini hatırlat.');
      // Yoldaş seçildiyse samimi üslup talimatı ekler
      case AiPersonaType.companion:
        // Sistem talimatına yeni bir satır ekler
        buffer.writeln(
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kişilik tarzın: Uzun sefer yollarındaki vefakar bir yol arkadaşı gibi sıcak, neşeli, samimi ve esprili konuş. '
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kullanıcının küçük çabalarını bile büyük bir sevinçle kutla.');
    }
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln();
    // Dil ve anlatım tercihlerini sistem talimatına ekler
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (plainTurkish) {
      // AIya seçilen Türkçe üslubunu bildirir
      buffer.writeln('DİL AYARI: Kullanıcı "Sade Türkçe" tercih etti. '
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Fantezi veya krallık terimlerini abartmadan, modern, temiz ve anlaşılır bir Türkçe kullan.');
    // Önceki koşul sağlanmazsa bu yolu kullanır
    } else {
      // Sistem talimatına yeni bir satır ekler
      buffer.writeln(
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'DİL AYARI: Ałek’ryŧhæ krallığının sıcak, fantastik ve edebi lisanını doğal olarak kullan '
          // Gösterilecek veya kullanılacak metin parçasını ekler
          '(Vazife, ahit, ferman, tecrübe, sefer, itibar gibi terimler). Asla yapay bir conlang uydurma.');
    }
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln();
    // Rehberin uyması gereken değişmez kuralları ekler
    // AIya değişmez güvenlik kurallarının başlığını ekler
    buffer.writeln('DEĞİŞMEZ KRALLIK KURALLARI:');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '- Kullanıcıyı zorlayıcı, aşağılayıcı veya suçlayıcı tavırlardan kaçın. '
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Planlı istirahat bir hak ve erdemdir.');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '- Sen doğrudan alışkanlık SİLEMEZ, GÜNCELLEYEMEZ veya ahit İMZALAYAMAZSIN. '
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Bütün kararlar kullanıcının açık onayına tabidir.');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '- Kısa, öz ve ilham verici yanıtlar ver (ortalama 2-4 paragraf). Gereksiz laf kalabalığından kaçın.');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln();
    // AIya ahit önerilerinin nasıl yazılacağını açıklar
    // AIya ahit önerisinin JSON kurallarını ekler
    buffer.writeln('AHİT (SÖZLEŞME) ÖNERME PROTOKOLÜ:');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Eğer kullanıcının durumuna göre yeni bir Ahit (habit contract) önermek faydalı olacaksa, '
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'mesajının sonuna tam olarak aşağıdaki JSON formatında bir blok ekle. '
        // Gösterilecek veya kullanılacak metin parçasını ekler
        'Kullanıcı ekranda beliren önizleme kartından bu ahdi tek tıkla onaylayıp imzalayabilir:');
    // Ahit önerisi için kod bloğunun sınırını yazar
    buffer.writeln('```pact_suggestion');
    // Rehberin sistem talimatına bu metni ekler
    buffer.writeln('{');
    // AIya ahit önerisinin örnek JSON alanını ekler
    buffer.writeln('  "title": "7 Günlük Bilgi Seferi",');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '  "description": "Her gün en az bir kez kitap kapağını aç.",');
    // AIya ahit önerisinin örnek JSON alanını ekler
    buffer.writeln('  "target_habits": ["Kitap Oku"],');
    // AIya ahit önerisinin örnek JSON alanını ekler
    buffer.writeln('  "target_days": 7,');
    // Rehberin sistem talimatına bu metni ekler
    buffer.writeln('  "total_days": 10,');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln(
        // Gösterilecek veya kullanılacak metin parçasını ekler
        '  "rationale": "Zinciri başlatmak için küçük ve sürdürülebilir bir tempo."');
    // Rehberin sistem talimatına bu metni ekler
    buffer.writeln('}');
    // Ahit önerisi için kod bloğunun sınırını yazar
    buffer.writeln('```');
    // Sistem talimatına yeni bir satır ekler
    buffer.writeln();
    // Kullanıcının ek talimatlarını sisteme dahil eder
    // Kullanılabilir veri varsa devam eder
    if (customInstructions != null && customInstructions.trim().isNotEmpty) {
      // AIya izin verilen kullanıcı talimatı veya özet başlığını ekler
      buffer.writeln('KULLANICININ ÖZEL İSTEKLERİ:');
      // Kullanıcının özel talimatını sistem metnine ekler
      buffer.writeln(customInstructions.trim());
      // Sistem talimatına yeni bir satır ekler
      buffer.writeln();
    }
    // Kullanıcı izin verdiyse vazife durumunu sisteme ekler
    // Kullanılabilir veri varsa devam eder
    if (habitContext != null && habitContext.trim().isNotEmpty) {
      // AIya izin verilen kullanıcı talimatı veya özet başlığını ekler
      buffer.writeln('KULLANICININ İZİNLİ GÜNCEL DURUM ÖZETİ:');
      // İzinli vazife özetini sistem metnine ekler
      buffer.writeln(habitContext.trim());
      // Sistem talimatına yeni bir satır ekler
      buffer.writeln();
    }
    // Hazırlanan izinli durum özetini String olarak döndürür
    return buffer.toString().trim();
  }
}

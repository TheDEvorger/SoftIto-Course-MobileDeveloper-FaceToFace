// Matematiksel işlem fonksiyonlarını ekler
import 'dart:math';
// rehber karakter dosyasını kullanıma ekler
import 'mentor.dart';
// mentor ai response bilgilerini veya işlemlerini tutan sınıf
class MentorAiResponse {
  // mentor ai response nesnesini oluşturur
  const MentorAiResponse({
    // rehber karakter bilgisini zorunlu tutar
    required this.mentor,
    // yanıt bilgisini zorunlu tutar
    required this.reply,
    // öğrenme taktiği bilgisini zorunlu tutar
    required this.spellTactic,
    // önerilen soru sayısı bilgisini zorunlu tutar
    required this.suggestedQuestionCount,
  });
  // rehber karakter bilgisini tutar
  final FantasyMentor mentor;
  // yanıt bilgisini tutar
  final String reply;
  // öğrenme taktiği bilgisini tutar
  final String spellTactic;
  // önerilen soru sayısı bilgisini tutar
  final int suggestedQuestionCount;
}
// mentor ai servis bilgilerini veya işlemlerini tutan sınıf
class MentorAiService {
  // mentor ai servis.  nesnesini oluşturur
  MentorAiService._();
  // instance bilgisini hesaplayıp saklar
  static final MentorAiService instance = MentorAiService._();
  // mentor bilgisini sorar
  Future<MentorAiResponse> askMentor({
    // rehber karakter bilgisini zorunlu tutar
    required FantasyMentor mentor,
    // kullanıcı sorusu bilgisini zorunlu tutar
    required String userQuestion,
  }) async {
    // Simüle edilen zeki yanıt gecikmesi (düşünme & rünleri okuma efekti)
    // Belirtilen süre kadar asenkron bekler
    await Future<void>.delayed(const Duration(milliseconds: 700));
    // lower bilgisini hesaplayıp saklar
    final lower = userQuestion.toLowerCase();
    // yanıt bilgisini tutar
    String reply;
    // tactic bilgisini tutar
    String tactic;
    // hedef soru sayısı için başlangıç sayısını belirler
    int targetQuestions = 25;
    // Değere göre uygun durumu seçer
    switch (mentor.id) {
      // 'theron' durumu için çalışır
      case 'theron':
        // Belirtilen koşul doğruysa işlemi yapar
        if (lower.contains('trig') || lower.contains('açı')) {
          // yanıt değerini günceller
          reply =
              // "Trigonometri bir üçgenin içine hapsedilmiş …" metnini kullanır
              'Trigonometri bir üçgenin içine hapsedilmiş evrensel bir danstır. Birim çemberi zihninde altın bir güneş gibi canlandır. '
              // "Tüm formülleri ezberlemek yerine sin²x + co…" metnini kullanır
              'Tüm formülleri ezberlemek yerine sin²x + cos²x = 1 ve yarım açı açılımlarını anahtar rünler olarak kabul et. '
              // "Bu iki kapı, 10 farklı trigonometri kilidin…" metnini kullanır
              'Bu iki kapı, 10 farklı trigonometri kilidini aynı anda açar!';
          // tactic değerini günceller
          tactic = 'Birim çember üzerindeki işaretleri (Tüm Sınıf Kara Tahtada Coştu) formülüyle mühürle.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 30;
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (lower.contains('limit') || lower.contains('türev') || lower.contains('integral')) {
          // yanıt değerini günceller
          reply =
              // "Ah, değişimin kadim büyüsü! Türevi fonksiyo…" metnini kullanır
              'Ah, değişimin kadim büyüsü! Türevi fonksiyonun her saniyedeki anlık nefesi gibi düşün. '
              // "Eğer eğim sıfırsa tepeye varmışsındır ya da…" metnini kullanır
              'Eğer eğim sıfırsa tepeye varmışsındır ya da bir vadinin en dibindesindir. '
              // "Türev alırken bileşke fonksiyonun iç türevi…" metnini kullanır
              'Türev alırken bileşke fonksiyonun iç türevini unutmak en yaygın dikkatsizlik tuzağıdır. Asla iç türevi es geçme!';
          // tactic değerini günceller
          tactic = 'Tepe ve çukur noktalarında f\'(x) = 0 kuralını hemen kenara not et.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 35;
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (lower.contains('geo') || lower.contains('üçgen')) {
          // yanıt değerini günceller
          reply =
              // "Geometride şekle bakılmaz, şekil okunur gen…" metnini kullanır
              'Geometride şekle bakılmaz, şekil okunur genç çırak! İkizkenar üçgen gördüğünde tepeden tabana dik indirmek '
              // "sana simetrinin iki yarısını bahşeder. Muht…" metnini kullanır
              'sana simetrinin iki yarısını bahşeder. Muhteşem üçlüyü ise bir pusula gibi kullan.';
          // tactic değerini günceller
          tactic = 'Göremediğin sorularda şekli temiz bir kağıda 2 kat büyük çizerek ek çizgiyi ara.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 25;
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // yanıt değerini günceller
          reply =
              // "Matematik rünleri senin kararlılığından bes…" metnini kullanır
              'Matematik rünleri senin kararlılığından beslenir evlat. "$userQuestion" sorunun temelinde işlem disiplini yatıyor. '
              // "İşlem hatasını azaltmak için adımlarını sat…" metnini kullanır
              'İşlem hatasını azaltmak için adımlarını satır satır ve düzenli yaz. Hızlı çözen değil, adımlarını net gören zafere ulaşır!';
          // tactic değerini günceller
          tactic = 'Günde 30 problem çözerek zihinsel hızını kadim seviyeye yükselt.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 30;
        }
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'sylva' durumu için çalışır
      case 'sylva':
        // Belirtilen koşul doğruysa işlemi yapar
        if (lower.contains('kalıtım') || lower.contains('gen')) {
          // yanıt değerini günceller
          reply =
              // "Kalıtım, geçmişin geleceğe fısıldadığı gene…" metnini kullanır
              'Kalıtım, geçmişin geleceğe fısıldadığı genetik bir bahçe şarkısıdır! '
              // "Eğer otozomal çekinik arıyorsan soy ağacınd…" metnini kullanır
              'Eğer otozomal çekinik arıyorsan soy ağacındaki taralı bireylere "aa" yazıp ebeveynlerine doğru filizleri takip et. '
              // "Büyülü sır: Taralı olmayanlarda en az bir b…" metnini kullanır
              'Büyülü sır: Taralı olmayanlarda en az bir büyük "A" olmak zorundadır!';
          // tactic değerini günceller
          tactic = 'Soy ağacı sorularında önce hasta (çekinik) bireyleri küçük harfle işaretle.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 25;
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (lower.contains('fotosentez') || lower.contains('solunum')) {
          // yanıt değerini günceller
          reply =
              // "Fotosentez ışığın glikoza dönüşen ruhudur; …" metnini kullanır
              'Fotosentez ışığın glikoza dönüşen ruhudur; solunum ise o glikozun ATP enerjisine dönüşen ateşidir! '
              // "Işığa bağımlı evrede tilakoit zarda suyun f…" metnini kullanır
              'Işığa bağımlı evrede tilakoit zarda suyun fotoliziyle oksijen salınırken, ışıktan bağımsız Calvin döngüsünde CO₂ besine bağlanır.';
          // tactic değerini günceller
          tactic = 'Işık = Grana (H₂O -> O₂), Karanlık/Enzim = Stroma (CO₂ -> Glikoz) ikilisini unutma.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 20;
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // yanıt değerini günceller
          reply =
              // "Canlılık sistemleri birbirine bağlı yaşayan…" metnini kullanır
              'Canlılık sistemleri birbirine bağlı yaşayan kökler gibidir. "$userQuestion" konusunu kavrarken '
              // "kavramları ezberlemek yerine aralarındaki i…" metnini kullanır
              'kavramları ezberlemek yerine aralarındaki ilişki haritasını çiz. Hücreden organizmaya her şey kusursuz bir düzen içindedir.';
          // tactic değerini günceller
          tactic = 'Konu bitiminde kendi cümlelerinle 5 maddelik bir biyoloji filizi özeti çıkar.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 20;
        }
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'ignis' durumu için çalışır
      case 'ignis':
        // Belirtilen koşul doğruysa işlemi yapar
        if (lower.contains('fizik') || lower.contains('kuvvet') || lower.contains('hareket')) {
          // yanıt değerini günceller
          reply =
              // "Gözlerini aç çırak! F = m · a evrenin en sa…" metnini kullanır
              'Gözlerini aç çırak! F = m · a evrenin en saf motorudur! '
              // "Serbest cisim diyagramı çizmeden soruya dok…" metnini kullanır
              'Serbest cisim diyagramı çizmeden soruya dokunursan patlarsın! Önce cisme etki eden tüm kuvvetleri renkli oklarla çiz, '
              // "ardından net kuvveti bul ve ivmeye doğru fı…" metnini kullanır
              'ardından net kuvveti bul ve ivmeye doğru fırla!';
          // tactic değerini günceller
          tactic = 'Soruya başlamadan önce cisme etki eden yerçekimi ve sürtünme oklarını çiz.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 30;
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (lower.contains('kimya') || lower.contains('denge') || lower.contains('gaz')) {
          // yanıt değerini günceller
          reply =
              // "P·V = n·R·T! Paran Varsa Ne Rahat formülü b…" metnini kullanır
              'P·V = n·R·T! Paran Varsa Ne Rahat formülü boşuna söylenmedi! Gazların hacmi sıcaklıkla dans eder, basınçla sıkışır. '
              // "Denge tepkimelerinde ise sistem her zaman s…" metnini kullanır
              'Denge tepkimelerinde ise sistem her zaman senin yaptığın etkinin tam tersine direnç gösterir (Le Chatelier prensibi).';
          // tactic değerini günceller
          tactic = 'Dengeye sıcaklık/basınç etkisi yapıldığında sistemin nereye kayacağını okla belirt.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 25;
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // yanıt değerini günceller
          reply =
              // "Simya ve doğa kanunları yanılmaz! "$userQue…" metnini kullanır
              'Simya ve doğa kanunları yanılmaz! "$userQuestion" konusunda takıldıysan formüllere değil mantığına odaklan. '
              // "Birim analizi yap; Newton/Metrekare = Pasca…" metnini kullanır
              'Birim analizi yap; Newton/Metrekare = Pascal olduğunu hatırladığın an formül ezberine gerek kalmaz!';
          // tactic değerini günceller
          tactic = 'Birimleri sadeleştirerek cevabın boyutunu kontrol et.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 25;
        }
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'valerius' durumu için çalışır
      case 'valerius':
      // Diğer durumlar için çalışır
      default:
        // Belirtilen koşul doğruysa işlemi yapar
        if (lower.contains('paragraf') || lower.contains('türkçe') || lower.contains('şık')) {
          // yanıt değerini günceller
          reply =
              // "Kelimelerin labirentinde kaybolma yolcu! İk…" metnini kullanır
              'Kelimelerin labirentinde kaybolma yolcu! İki şık arasında kaldığında metnin dışına çıkıyorsun demektir. '
              // "Kendi genel kültürünü unut; metinde yazar n…" metnini kullanır
              'Kendi genel kültürünü unut; metinde yazar ne söylüyorsa mutlak hakikat odur. '
              // "İlk ve son cümleler ana fikrin fenerleridir…" metnini kullanır
              'İlk ve son cümleler ana fikrin fenerleridir; ancak "oysa, fakat, asıl önemli olan" bağlaçlarından sonra gelen cümle yazarın kalbidir!';
          // tactic değerini günceller
          tactic = 'Soruyu okumadan önce soru kökündeki olumsuz ifadeyi (-memiştir) daire içine al.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 35;
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (lower.contains('edebiyat') || lower.contains('yazar') || lower.contains('eser')) {
          // yanıt değerini günceller
          reply =
              // "Dönemlerin ruhunu anlarsan eserler kendiliğ…" metnini kullanır
              'Dönemlerin ruhunu anlarsan eserler kendiliğinden aklına nakşolur. Divan şairlerinin mazmunları ve '
              // "Cumhuriyet aydınlarının memleket edebiyatı …" metnini kullanır
              'Cumhuriyet aydınlarının memleket edebiyatı sevdası... Yazarları kronolojik bir zaman çizelgesinde arkadaş gibi tanı.';
          // tactic değerini günceller
          tactic = 'Yazarları anahtar temaları ve en bilinen üç eseriyle kartlara yaz.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 25;
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // yanıt değerini günceller
          reply =
              // "Zihnini bir göl gibi dingin tut. "$userQues…" metnini kullanır
              'Zihnini bir göl gibi dingin tut. "$userQuestion" sorusu için sana tavsiyem: '
              // "Sınav anında acele eden değil, odaklanmış b…" metnini kullanır
              'Sınav anında acele eden değil, odaklanmış bir dikkatle her kelimenin ağırlığını hisseden zirveye çıkar.';
          // tactic değerini günceller
          tactic = 'Her gün sabah zihnin berrakken 20 paragraf sorusunu aralıksız süre tutarak çöz.';
          // hedef soru sayısı değerini günceller
          targetQuestions = 20;
        }
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
    }
    // random bonus bilgisini hesaplayıp saklar
    final randomBonus = Random().nextInt(5);
    // mentor ai response nesnesini oluşturur
    return MentorAiResponse(
      // rehber karakter bilgisini belirler
      mentor: mentor,
      // Yanıt metnini belirler
      reply: reply,
      // öğrenme taktiği bilgisini belirler
      spellTactic: tactic,
      // önerilen soru sayısı bilgisini belirler
      suggestedQuestionCount: targetQuestions + randomBonus,
    );
  }
}

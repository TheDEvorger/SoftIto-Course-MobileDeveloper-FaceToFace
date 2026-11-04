// müfredat dosyasını kullanıma ekler
import '../models/curriculum.dart';
// konu relation dosyasını kullanıma ekler
import '../models/topic_relation.dart';
// curriculum repository dosyasını kullanıma ekler
import '../repositories/curriculum_repository.dart';
/// MEB müfredatına dayalı doğrulanmış konu ilişkileri ve aralıklı tekrar servisi.
// konu map servis bilgilerini veya işlemlerini tutan sınıf
class TopicMapService {
  // konu map servis nesnesini oluşturur
  TopicMapService(this.curriculumRepository);
  // curriculum repository bilgisini tutar
  final CurriculumRepository curriculumRepository;
  /// Doğrulanmış MEB Pedagojik Önkoşul Veri Seti (Önkoşul -> Hedef Konu)
  // prerequisites by konu id bilgisini hesaplayıp saklar
  static const Map<String, List<String>> prerequisitesByTopicId = {
    // TYT Matematik Zinciri
    // "tyt_mat_2': ['tyt_mat_1'], // Sayı Basamakl…" metnini kullanır
    'tyt_mat_2': ['tyt_mat_1'], // Sayı Basamakları <- Temel Kavramlar
    // "tyt_mat_3': ['tyt_mat_1'], // Bölme Bölüneb…" metnini kullanır
    'tyt_mat_3': ['tyt_mat_1'], // Bölme Bölünebilme <- Temel Kavramlar
    // "tyt_mat_4': ['tyt_mat_3'], // EBOB EKOK <- …" metnini kullanır
    'tyt_mat_4': ['tyt_mat_3'], // EBOB EKOK <- Bölme Bölünebilme
    // "tyt_mat_5': ['tyt_mat_1'], // Rasyonel Sayı…" metnini kullanır
    'tyt_mat_5': ['tyt_mat_1'], // Rasyonel Sayılar <- Temel Kavramlar
    // "tyt_mat_6': ['tyt_mat_5'], // Basit Eşitsiz…" metnini kullanır
    'tyt_mat_6': ['tyt_mat_5'], // Basit Eşitsizlikler <- Rasyonel Sayılar
    // "tyt_mat_7': ['tyt_mat_6'], // Mutlak Değer …" metnini kullanır
    'tyt_mat_7': ['tyt_mat_6'], // Mutlak Değer <- Basit Eşitsizlikler
    // "tyt_mat_8': ['tyt_mat_1'], // Üslü İfadeler…" metnini kullanır
    'tyt_mat_8': ['tyt_mat_1'], // Üslü İfadeler <- Temel Kavramlar
    // "tyt_mat_9': ['tyt_mat_8'], // Köklü İfadele…" metnini kullanır
    'tyt_mat_9': ['tyt_mat_8'], // Köklü İfadeler <- Üslü İfadeler
    // "tyt_mat_10': ['tyt_mat_8'], // Çarpanlara A…" metnini kullanır
    'tyt_mat_10': ['tyt_mat_8'], // Çarpanlara Ayırma <- Üslü İfadeler
    // "tyt_mat_11': ['tyt_mat_5'], // Oran Orantı …" metnini kullanır
    'tyt_mat_11': ['tyt_mat_5'], // Oran Orantı <- Rasyonel Sayılar
    // "tyt_mat_12': ['tyt_mat_10'], // Denklem Çöz…" metnini kullanır
    'tyt_mat_12': ['tyt_mat_10'], // Denklem Çözme <- Çarpanlara Ayırma
    // "tyt_mat_13': [" metnini kullanır
    'tyt_mat_13': [
      // "tyt_mat_11" metnini kullanır
      'tyt_mat_11',
      // "tyt_mat_12" metnini kullanır
      'tyt_mat_12'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Problemler <- Oran Orantı + Denklem
    // "tyt_mat_15': ['tyt_mat_12'], // Fonksiyonla…" metnini kullanır
    'tyt_mat_15': ['tyt_mat_12'], // Fonksiyonlar <- Denklem Çözme
    // "tyt_mat_16': [" metnini kullanır
    'tyt_mat_16': [
      // "tyt_mat_15" metnini kullanır
      'tyt_mat_15',
      // "tyt_mat_10" metnini kullanır
      'tyt_mat_10'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Polinomlar <- Fonksiyonlar + Çarpanlara Ayırma
    // "tyt_mat_17': [" metnini kullanır
    'tyt_mat_17': [
      // "tyt_mat_10" metnini kullanır
      'tyt_mat_10',
      // "tyt_mat_12" metnini kullanır
      'tyt_mat_12'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // İkinci Dereceden Denklemler <- Çarpanlara Ayırma + Denklem
    // AYT Matematik Zinciri
    // "ayt_mat_1': [" metnini kullanır
    'ayt_mat_1': [
      // "tyt_mat_16" metnini kullanır
      'tyt_mat_16'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Polinomlar ve Çarpanlara Ayırma (AYT) <- TYT Polinomlar
    // "ayt_mat_2': [" metnini kullanır
    'ayt_mat_2': [
      // "tyt_mat_17" metnini kullanır
      'tyt_mat_17',
      // "tyt_mat_6" metnini kullanır
      'tyt_mat_6'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // İkinci Dereceden Eşitsizlikler <- İkinci Dereceden Denklemler + Eşitsizlikler
    // "ayt_mat_3': ['tyt_mat_17'], // Parabol <- İ…" metnini kullanır
    'ayt_mat_3': ['tyt_mat_17'], // Parabol <- İkinci Dereceden Denklemler
    // "ayt_mat_4': ['tyt_mat_15'], // Trigonometri…" metnini kullanır
    'ayt_mat_4': ['tyt_mat_15'], // Trigonometri 1 & 2 <- Fonksiyonlar
    // "ayt_mat_5': [" metnini kullanır
    'ayt_mat_5': [
      // "tyt_mat_8" metnini kullanır
      'tyt_mat_8',
      // "tyt_mat_15" metnini kullanır
      'tyt_mat_15'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Logaritma <- Üslü İfadeler + Fonksiyonlar
    // "ayt_mat_6': ['ayt_mat_5'], // Diziler <- Lo…" metnini kullanır
    'ayt_mat_6': ['ayt_mat_5'], // Diziler <- Logaritma / Fonksiyonlar
    // "ayt_mat_7': [" metnini kullanır
    'ayt_mat_7': [
      // "ayt_mat_6" metnini kullanır
      'ayt_mat_6',
      // "tyt_mat_15" metnini kullanır
      'tyt_mat_15'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Limit ve Süreklilik <- Diziler + Fonksiyonlar
    // "ayt_mat_8': ['ayt_mat_7'], // Türev ve Uygu…" metnini kullanır
    'ayt_mat_8': ['ayt_mat_7'], // Türev ve Uygulamaları <- Limit ve Süreklilik
    // "ayt_mat_9': [" metnini kullanır
    'ayt_mat_9': [
      // "ayt_mat_8" metnini kullanır
      'ayt_mat_8'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // İntegral ve Uygulamaları <- Türev ve Uygulamaları
    // Fizik Zinciri
    // "ayt_fizik_1': [" metnini kullanır
    'ayt_fizik_1': [
      // "tyt_fen_2" metnini kullanır
      'tyt_fen_2'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Vektörler ve Bağıl Hareket <- Kuvvet ve Hareket (TYT)
    // "ayt_fizik_2': ['ayt_fizik_1'], // Newton'ın…" metnini kullanır
    'ayt_fizik_2': ['ayt_fizik_1'], // Newton'ın Hareket Yasaları <- Vektörler
    // "ayt_fizik_3': ['ayt_fizik_2'], // Sabit İvm…" metnini kullanır
    'ayt_fizik_3': ['ayt_fizik_2'], // Sabit İvmeli Hareket <- Newton Yasaları
    // "ayt_fizik_4': ['ayt_fizik_3'], // İş, Güç v…" metnini kullanır
    'ayt_fizik_4': ['ayt_fizik_3'], // İş, Güç ve Enerji (AYT) <- İvmeli Hareket
    // "ayt_fizik_5': ['ayt_fizik_4'], // İtme ve Ç…" metnini kullanır
    'ayt_fizik_5': ['ayt_fizik_4'], // İtme ve Çizgisel Momentum <- Enerji
    // "ayt_fizik_6': ['ayt_fizik_1'], // Tork ve D…" metnini kullanır
    'ayt_fizik_6': ['ayt_fizik_1'], // Tork ve Denge <- Vektörler
    // "ayt_fizik_7': [" metnini kullanır
    'ayt_fizik_7': [
      // "tyt_fen_4" metnini kullanır
      'tyt_fen_4'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Elektriksel Kuvvet & Alan <- Elektrostatik (TYT)
    // "ayt_fizik_8': ['ayt_fizik_7'], // Manyetizm…" metnini kullanır
    'ayt_fizik_8': ['ayt_fizik_7'], // Manyetizma <- Elektriksel Alan
    // "ayt_fizik_9': ['ayt_fizik_8'], // Alternati…" metnini kullanır
    'ayt_fizik_9': ['ayt_fizik_8'], // Alternatif Akım <- Manyetizma
    // "ayt_fizik_10': [" metnini kullanır
    'ayt_fizik_10': [
      // "ayt_fizik_3" metnini kullanır
      'ayt_fizik_3'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Çembersel & Harmonik Hareket <- İvmeli Hareket
    // Kimya Zinciri
    // "ayt_kimya_1': [" metnini kullanır
    'ayt_kimya_1': [
      // "tyt_fen_6" metnini kullanır
      'tyt_fen_6'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Modern Atom Teorisi <- Atom ve Periyodik Sistem (TYT)
    // "ayt_kimya_2': [" metnini kullanır
    'ayt_kimya_2': [
      // "ayt_kimya_1" metnini kullanır
      'ayt_kimya_1',
      // "tyt_fen_8" metnini kullanır
      'tyt_fen_8'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Gazlar <- Atom Teorisi + Maddenin Halleri
    // "ayt_kimya_3': ['ayt_kimya_2'], // Sıvı Çöze…" metnini kullanır
    'ayt_kimya_3': ['ayt_kimya_2'], // Sıvı Çözeltiler <- Gazlar
    // "ayt_kimya_4': [" metnini kullanır
    'ayt_kimya_4': [
      // "ayt_kimya_3" metnini kullanır
      'ayt_kimya_3'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Kimyasal Enerji (Entalpi) <- Sıvı Çözeltiler
    // "ayt_kimya_5': ['ayt_kimya_4'], // Kimyasal …" metnini kullanır
    'ayt_kimya_5': ['ayt_kimya_4'], // Kimyasal Hız <- Kimyasal Enerji
    // "ayt_kimya_6': ['ayt_kimya_5'], // Kimyasal …" metnini kullanır
    'ayt_kimya_6': ['ayt_kimya_5'], // Kimyasal Denge <- Kimyasal Hız
    // "ayt_kimya_7': ['ayt_kimya_6'], // Asit-Baz …" metnini kullanır
    'ayt_kimya_7': ['ayt_kimya_6'], // Asit-Baz Dengesi <- Kimyasal Denge
    // "ayt_kimya_8': ['ayt_kimya_7'], // Elektroki…" metnini kullanır
    'ayt_kimya_8': ['ayt_kimya_7'], // Elektrokimya & Piller <- Asit-Baz Dengesi
    // Biyoloji Zinciri
    // "ayt_biyo_7': [" metnini kullanır
    'ayt_biyo_7': [
      // "tyt_fen_9" metnini kullanır
      'tyt_fen_9',
      // "tyt_fen_10" metnini kullanır
      'tyt_fen_10'
    // Hesaplamada kullanılacak sayısal değeri belirler
    ], // Nükleik Asitler <- Canlıların Bileşenleri + Hücre
    // "ayt_biyo_8': ['ayt_biyo_7'], // Fotosentez …" metnini kullanır
    'ayt_biyo_8': ['ayt_biyo_7'], // Fotosentez & Kemosentez <- Nükleik Asitler
    // "ayt_biyo_9': ['ayt_biyo_8'], // Hücresel So…" metnini kullanır
    'ayt_biyo_9': ['ayt_biyo_8'], // Hücresel Solunum <- Fotosentez
    // "ayt_biyo_1': ['tyt_fen_10'], // Sinir Siste…" metnini kullanır
    'ayt_biyo_1': ['tyt_fen_10'], // Sinir Sistemi <- Hücre ve Organelleri
  };
  /// Belirli bir branş/alan zinciri için graf düğümlerini oluşturur
  // konu nodes for branch bilgisini getirir
  Future<List<TopicNodeInfo>> getTopicNodesForBranch({
    // branch key bilgisini zorunlu tutar
    required String branchKey, // 'matematik', 'fizik', 'kimya', 'biyoloji'
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? simulatedNow,
  }) async {
    // şimdiki zaman için güncel tarih ve saati alır
    final now = simulatedNow ?? DateTime.now();
    // ders ids bilgisini tutar
    List<String> subjectIds;
    // Değere göre uygun durumu seçer
    switch (branchKey) {
      // 'fizik' durumu için çalışır
      case 'fizik':
        // ders ids değerini günceller
        subjectIds = ['tyt_fen', 'ayt_fizik'];
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'kimya' durumu için çalışır
      case 'kimya':
        // ders ids değerini günceller
        subjectIds = ['tyt_fen', 'ayt_kimya'];
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'biyoloji' durumu için çalışır
      case 'biyoloji':
        // ders ids değerini günceller
        subjectIds = ['tyt_fen', 'ayt_biyo'];
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // 'matematik' durumu için çalışır
      case 'matematik':
      // Diğer durumlar için çalışır
      default:
        // ders ids değerini günceller
        subjectIds = ['tyt_mat', 'ayt_mat'];
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
    }
    // all topics için boş koleksiyon oluşturur
    final allTopics = <Topic>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final sId in subjectIds) {
      // konular verisini asenkron işlemin sonucundan alır
      final topics = await curriculumRepository.getTopics(sId);
      // all bilgisini ekler
      allTopics.addAll(topics);
    }
    // Tüm konuların veritabanındaki güncel ilerlemesini al
    // ilerleme map için boş koleksiyon oluşturur
    final progressMap = <String, TopicProgress>{};
    // Listedeki öğeleri tek tek dolaşır
    for (final sId in subjectIds) {
      // ilerleme verisini asenkron işlemin sonucundan alır
      final progress = await curriculumRepository.getAllProgressForSubject(sId);
      // all bilgisini ekler
      progressMap.addAll(progress);
    }
    // Bu zincirde yer alacak ve önkoşul ilişkisine sahip olan düğümleri filtrele
    // relevant konu ids için boş koleksiyon oluşturur
    final relevantTopicIds = <String>{};
    // Listedeki öğeleri tek tek dolaşır
    for (final t in allTopics) {
      // Belirtilen koşul doğruysa işlemi yapar
      if (prerequisitesByTopicId.containsKey(t.id)) {
        // add işlemini yapar
        relevantTopicIds.add(t.id);
        // all bilgisini ekler
        relevantTopicIds.addAll(prerequisitesByTopicId[t.id]!);
      }
    }
    // Bağımlılık (dependent) listesini tersine eşle
    // dependents by konu id için boş koleksiyon oluşturur
    final dependentsByTopicId = <String, List<String>>{};
    // Listedeki öğeleri tek tek dolaşır
    for (final entry in prerequisitesByTopicId.entries) {
      // Listedeki öğeleri tek tek dolaşır
      for (final prereq in entry.value) {
        // put if absent işlemini yapar
        dependentsByTopicId.putIfAbsent(prereq, () => []).add(entry.key);
      }
    }
    // Düğümleri sırala ve oluştur
    // düğümler için boş koleksiyon oluşturur
    final nodes = <TopicNodeInfo>[];
    // row index için başlangıç sayısını belirler
    var rowIndex = 0.0;
    // Listedeki öğeleri tek tek dolaşır
    for (final t in allTopics) {
      // Belirtilen koşul doğruysa işlemi yapar
      if (!relevantTopicIds.contains(t.id)) continue;
      // p değerini koşula göre hesaplar
      final p = progressMap[t.id] ?? TopicProgress(topicId: t.id);
      // prereqs bilgisini hesaplayıp saklar
      final prereqs = prerequisitesByTopicId[t.id] ?? const [];
      // dependents bilgisini hesaplayıp saklar
      final dependents = dependentsByTopicId[t.id] ?? const [];
      // Önkoşullar tamamlanmış mı?
      // hazır olma durumu bilgisini hesaplayıp saklar
      final isReady = prereqs.isEmpty ||
          // every işlemini yapar
          prereqs.every((reqId) =>
              // Yeni değer veya liste oluşturur
              (progressMap[reqId]?.status ?? TopicStatus.notStarted) ==
              // İlgili değeri veya görünüm ayarını belirler
              TopicStatus.completed);
      // Tekrar gerekiyor mu? (Spaced repetition)
      // needs review durumunu başlangıçta belirler
      var needsReview = false;
      // review message bilgisini tutar
      String? reviewMessage;
      // Belirtilen koşul doğruysa işlemi yapar
      if (p.status == TopicStatus.completed) {
        // days since study bilgisini iki değeri karşılaştırarak hesaplar
        final daysSinceStudy = p.lastStudiedAt != null
            // Koşul doğruysa bu değeri kullanır
            ? now.difference(p.lastStudiedAt!).inDays
            // Koşul yanlışsa bu değeri kullanır
            : 10;
        // Belirtilen koşul doğruysa işlemi yapar
        if (daysSinceStudy >= 7) {
          // needs review değerini günceller
          needsReview = true;
          // review message değerini günceller
          reviewMessage =
              // "$daysSinceStudy gündür tekrar edilmedi. Unu…" metnini kullanır
              '$daysSinceStudy gündür tekrar edilmedi. Unutma eğrisini tazele!';
        // Önceki koşul sağlanmazsa bu koşulu kontrol eder
        } else if (p.answeredCount < 20) {
          // needs review değerini günceller
          needsReview = true;
          // review message değerini günceller
          reviewMessage =
              // "Pekiştirme için çözülen soru sayısı az (${p…" metnini kullanır
              'Pekiştirme için çözülen soru sayısı az (${p.answeredCount}/20).';
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // review message değerini günceller
          reviewMessage = 'Konu taze ve pekiştirilmiş. Harika gidiyorsun!';
        }
      // Önceki koşul sağlanmazsa bu koşulu kontrol eder
      } else if (p.status == TopicStatus.inProgress) {
        // review message değerini günceller
        reviewMessage = 'Çalışma devam ediyor. Hedef: Tamamlama.';
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // Belirtilen koşul doğruysa işlemi yapar
        if (isReady) {
          // review message değerini günceller
          reviewMessage = 'Tüm önkoşullar tamamlandı. Çalışmaya hazır!';
        // Önceki koşul sağlanmazsa burası çalışır
        } else {
          // review message değerini günceller
          reviewMessage = 'Önce temel önkoşul konularını bitirmen önerilir.';
        }
      }
      // Koordinatlandırma: İki sütunlu veya aşamalı yerleşim
      // is ayt bilgisini hesaplayıp saklar
      final isAyt = t.subjectId.startsWith('ayt');
      // col x değerini koşula göre hesaplar
      final colX = isAyt ? 280.0 : 80.0;
      // pos y için başlangıç sayısını belirler
      final posY = 40.0 + (rowIndex * 95.0);
      // row index değerine yeni miktarı ekler
      rowIndex += 1.0;
      // İlgili fonksiyonu çalıştırır
      nodes.add(
        // konu node info nesnesini oluşturur
        TopicNodeInfo(
          // Konu ID bilgisini belirler
          topicId: t.id,
          // konu adı bilgisini belirler
          topicName: t.name,
          // Ders ID bilgisini belirler
          subjectId: t.subjectId,
          // ders adı bilgisini belirler
          subjectName: t.subjectId.startsWith('ayt')
              // Koşul doğruysa bu değeri kullanır
              ? 'AYT ${t.subjectId.replaceAll('ayt_', '').toUpperCase()}'
              // Koşul yanlışsa bu değeri kullanır
              : 'TYT ${t.subjectId.replaceAll('tyt_', '').toUpperCase()}',
          // Öğrenme veya sınav aşamasını belirler
          stage: isAyt ? 'AYT' : 'TYT',
          // prerequisite ids bilgisini belirler
          prerequisiteIds: prereqs,
          // dependent ids bilgisini belirler
          dependentIds: dependents,
          // durum bilgisini belirler
          status: p.status,
          // çözülen soru sayısı bilgisini belirler
          answeredCount: p.answeredCount,
          // last studied at bilgisini belirler
          lastStudiedAt: p.lastStudiedAt,
          // hazır olma durumu bilgisini belirler
          isReady: isReady,
          // needs review bilgisini belirler
          needsReview: needsReview,
          // review message bilgisini belirler
          reviewMessage: reviewMessage,
          // x konumu bilgisini belirler
          x: colX,
          // y konumu bilgisini belirler
          y: posY,
        ),
      );
    }
    // Hesaplanan sonucu döndürür
    return nodes;
  }
  /// Tüm sistemdeki acil tekrar önerilerini listeler (Spaced Repetition Listesi)
  // review recommendations bilgisini getirir
  Future<List<TopicNodeInfo>> getReviewRecommendations({
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? simulatedNow,
  }) async {
    // branches bilgisini hesaplayıp saklar
    final branches = ['matematik', 'fizik', 'kimya', 'biyoloji'];
    // all recommendations için boş koleksiyon oluşturur
    final allRecommendations = <TopicNodeInfo>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final b in branches) {
      // düğümler verisini asenkron işlemin sonucundan alır
      final nodes = await getTopicNodesForBranch(
        // branch key bilgisini belirler
        branchKey: b,
        // simulated now bilgisini belirler
        simulatedNow: simulatedNow,
      );
      // Listedeki öğeleri tek tek dolaşır
      for (final n in nodes) {
        // Belirtilen koşul doğruysa işlemi yapar
        if (n.needsReview) {
          // add işlemini yapar
          allRecommendations.add(n);
        }
      }
    }
    // En uzun süredir tekrar edilmeyenleri en öne sırala
    // sort işlemini yapar
    allRecommendations.sort((a, b) {
      // tarih a bilgisini hesaplayıp saklar
      final dateA = a.lastStudiedAt ?? DateTime(2000);
      // tarih b bilgisini hesaplayıp saklar
      final dateB = b.lastStudiedAt ?? DateTime(2000);
      // compare to işlemini yapar
      return dateA.compareTo(dateB);
    });
    // Hesaplanan sonucu döndürür
    return allRecommendations;
  }
}

// SQLite veritabanı kütüphanesini ekler
import 'package:sqflite/sqflite.dart';
// schema dosyasını kullanıma ekler
import '../../core/database/schema.dart';
// müfredat dosyasını kullanıma ekler
import '../models/curriculum.dart';
// curriculum repository bilgilerini veya işlemlerini tutan sınıf
class CurriculumRepository {
  // curriculum repository nesnesini oluşturur
  CurriculumRepository(this.db);
  // veritabanı bilgisini tutar
  final Database db;
  // subjects bilgisini getirir
  Future<List<Subject>> getSubjects(String stage) async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // dersler tablosu adını kullanır
      GardenDatabaseSchema.tableSubjects,
      // Sorgunun filtre koşulunu belirler
      where: 'stage = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [stage],
      // Kayıtların sıralanma şeklini belirler
      orderBy: 'order_index ASC',
    );
    // Öğeleri tek tek dönüştürür
    return maps.map(Subject.fromMap).toList();
  }
  // topics bilgisini getirir
  Future<List<Topic>> getTopics(String subjectId) async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // konular tablosu adını kullanır
      GardenDatabaseSchema.tableTopics,
      // Sorgunun filtre koşulunu belirler
      where: 'subject_id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [subjectId],
      // Kayıtların sıralanma şeklini belirler
      orderBy: 'order_index ASC',
    );
    // Öğeleri tek tek dönüştürür
    return maps.map(Topic.fromMap).toList();
  }
  // konu ilerleme bilgisini getirir
  Future<TopicProgress> getTopicProgress(String topicId) async {
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // konu ilerleme tablosu adını kullanır
      GardenDatabaseSchema.tableTopicProgress,
      // Sorgunun filtre koşulunu belirler
      where: 'topic_id = ?',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: [topicId],
      // Getirilecek kayıt sayısını sınırlar
      limit: 1,
    );
    // Liste veya metin doluysa bu koşul çalışır
    if (maps.isNotEmpty) {
      // konu ilerleme.from map nesnesini oluşturur
      return TopicProgress.fromMap(maps.first);
    }
    // konu ilerleme nesnesini oluşturur
    return TopicProgress(topicId: topicId);
  }
  // konu ilerleme bilgisini günceller
  Future<void> updateTopicProgress(TopicProgress progress) async {
    // Veritabanına kayıt ekler
    await db.insert(
      // konu ilerleme tablosu adını kullanır
      GardenDatabaseSchema.tableTopicProgress,
      // Nesnenin verilerini Map yapısına dönüştürür
      progress.toMap(),
      // Aynı kayıt varsa ne yapılacağını belirler
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // all ilerleme for ders bilgisini getirir
  Future<Map<String, TopicProgress>> getAllProgressForSubject(
      // İlgili değeri veya görünüm ayarını belirler
      String subjectId) async {
    // konular verisini asenkron işlemin sonucundan alır
    final topics = await getTopics(subjectId);
    // Liste veya metin boşsa bu koşul çalışır
    if (topics.isEmpty) return {};
    // konu IDleri için listedeki öğeleri dönüştürür
    final topicIds = topics.map((t) => t.id).toList();
    // placeholders bilgisini hesaplayıp saklar
    final placeholders = List.filled(topicIds.length, '?').join(',');
    // Map kayıtları verisini asenkron işlemin sonucundan alır
    final maps = await db.query(
      // konu ilerleme tablosu adını kullanır
      GardenDatabaseSchema.tableTopicProgress,
      // Sorgunun filtre koşulunu belirler
      where: 'topic_id IN ($placeholders)',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: topicIds,
    );
    // sonuç için boş koleksiyon oluşturur
    final result = <String, TopicProgress>{};
    // Listedeki öğeleri tek tek dolaşır
    for (final map in maps) {
      // Map verisinden model nesnesi oluşturur
      final p = TopicProgress.fromMap(map);
      // result[p.konu id] değerini günceller
      result[p.topicId] = p;
    }
    // Hesaplanan sonucu döndürür
    return result;
  }
  // stage summary bilgisini getirir
  Future<Map<String, int>> getStageSummary(String stage) async {
    // dersler verisini asenkron işlemin sonucundan alır
    final subjects = await getSubjects(stage);
    // Liste veya metin boşsa bu koşul çalışır
    if (subjects.isEmpty) {
      // Yeni değer veya liste oluşturur
      return {'totalTopics': 0, 'completedTopics': 0, 'inProgressTopics': 0};
    }
    // ders ids için listedeki öğeleri dönüştürür
    final subjectIds = subjects.map((s) => s.id).toList();
    // placeholders bilgisini hesaplayıp saklar
    final placeholders = List.filled(subjectIds.length, '?').join(',');
    // konular verisini asenkron işlemin sonucundan alır
    final topics = await db.query(
      // konular tablosu adını kullanır
      GardenDatabaseSchema.tableTopics,
      // Sorgunun filtre koşulunu belirler
      where: 'subject_id IN ($placeholders)',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: subjectIds,
    );
    // Liste veya metin boşsa bu koşul çalışır
    if (topics.isEmpty) {
      // Yeni değer veya liste oluşturur
      return {'totalTopics': 0, 'completedTopics': 0, 'inProgressTopics': 0};
    }
    // konu IDleri için listedeki öğeleri dönüştürür
    final topicIds = topics.map((t) => t['id'] as String).toList();
    // konu placeholders bilgisini hesaplayıp saklar
    final topicPlaceholders = List.filled(topicIds.length, '?').join(',');
    // ilerleme maps verisini asenkron işlemin sonucundan alır
    final progressMaps = await db.query(
      // konu ilerleme tablosu adını kullanır
      GardenDatabaseSchema.tableTopicProgress,
      // Sorgunun filtre koşulunu belirler
      where: 'topic_id IN ($topicPlaceholders)',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: topicIds,
    );
    // tamamlananlar için başlangıç sayısını belirler
    var completed = 0;
    // devam edenler için başlangıç sayısını belirler
    var inProgress = 0;
    // Listedeki öğeleri tek tek dolaşır
    for (final m in progressMaps) {
      // durum bilgisini hesaplayıp saklar
      final status = m['status'] as String;
      // Belirtilen koşul doğruysa işlemi yapar
      if (status == TopicStatus.completed.name) {
        // tamamlananlar değerini 1 artırır
        completed++;
      // Önceki koşul sağlanmazsa bu koşulu kontrol eder
      } else if (status == TopicStatus.inProgress.name) {
        // devam edenler değerini 1 artırır
        inProgress++;
      }
    }
    // Yeni değer veya liste oluşturur
    return {
      // Öğe veya karakter sayısını kullanır
      'totalTopics': topics.length,
      // "completedTopics': completed" metnini kullanır
      'completedTopics': completed,
      // "inProgressTopics': inProgress" metnini kullanır
      'inProgressTopics': inProgress,
    };
  }
  // ders stats for stage bilgisini getirir
  Future<Map<String, Map<String, int>>> getSubjectStatsForStage(
      // İlgili değeri veya görünüm ayarını belirler
      String stage) async {
    // dersler verisini asenkron işlemin sonucundan alır
    final subjects = await getSubjects(stage);
    // Liste veya metin boşsa bu koşul çalışır
    if (subjects.isEmpty) return {};
    // ders ids için listedeki öğeleri dönüştürür
    final subjectIds = subjects.map((s) => s.id).toList();
    // placeholders bilgisini hesaplayıp saklar
    final placeholders = List.filled(subjectIds.length, '?').join(',');
    // konular verisini asenkron işlemin sonucundan alır
    final topics = await db.query(
      // konular tablosu adını kullanır
      GardenDatabaseSchema.tableTopics,
      // Sorgunun filtre koşulunu belirler
      where: 'subject_id IN ($placeholders)',
      // Sorguya filtre değerlerini güvenli biçimde gönderir
      whereArgs: subjectIds,
    );
    // ilerleme maps değerini tanımlar
    final progressMaps =
        // Veritabanındaki kayıtları sorgular
        await db.query(GardenDatabaseSchema.tableTopicProgress);
    // completed konu ids bilgisini hesaplayıp saklar
    final completedTopicIds = progressMaps
        // Koşula uyan kayıtları filtreler
        .where((m) => m['status'] == TopicStatus.completed.name)
        // Öğeleri tek tek dönüştürür
        .map((m) => m['topic_id'] as String)
        // set bilgisini dönüştürür
        .toSet();
    // sonuç için boş koleksiyon oluşturur
    final result = <String, Map<String, int>>{};
    // Listedeki öğeleri tek tek dolaşır
    for (final s in subjects) {
      // result[s.id] değerini günceller
      result[s.id] = {'total': 0, 'completed': 0};
    }
    // Listedeki öğeleri tek tek dolaşır
    for (final t in topics) {
      // s id bilgisini hesaplayıp saklar
      final sId = t['subject_id'] as String;
      // t id bilgisini hesaplayıp saklar
      final tId = t['id'] as String;
      // Belirtilen koşul doğruysa işlemi yapar
      if (result.containsKey(sId)) {
        // Değer null ise varsayılanı kullanır
        result[sId]!['total'] = (result[sId]!['total'] ?? 0) + 1;
        // Belirtilen koşul doğruysa işlemi yapar
        if (completedTopicIds.contains(tId)) {
          // Değer null ise varsayılanı kullanır
          result[sId]!['completed'] = (result[sId]!['completed'] ?? 0) + 1;
        }
      }
    }
    // Hesaplanan sonucu döndürür
    return result;
  }
  // initial curriculum if empty bilgisini örnek verileri ekler
  Future<void> seedInitialCurriculumIfEmpty() async {
    // sayı bilgisini hesaplayıp saklar
    final count = Sqflite.firstIntValue(
      // SQL sorgusunu çalıştırır
      await db.rawQuery(
          // "SELECT COUNT(*) FROM ${GardenDatabaseSchema…" metnini kullanır
          'SELECT COUNT(*) FROM ${GardenDatabaseSchema.tableSubjects}'),
    );
    // Belirtilen koşul doğruysa işlemi yapar
    if ((count ?? 0) > 0) return;
    // Veritabanı işlemlerini birlikte çalıştırır
    await db.transaction((txn) async {
      // batch bilgisini hesaplayıp saklar
      final batch = txn.batch();
      // TYT Dersleri
      // tyt subjects bilgisini hesaplayıp saklar
      const tytSubjects = [
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'tyt_turkce',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'TYT',
            // ad bilgisini belirler
            name: 'Türkçe',
            // sıra numarası bilgisini belirler
            orderIndex: 1,
            // Soru sayısını belirler
            questionCount: 40),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'tyt_mat',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'TYT',
            // ad bilgisini belirler
            name: 'Temel Matematik',
            // sıra numarası bilgisini belirler
            orderIndex: 2,
            // Soru sayısını belirler
            questionCount: 40),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'tyt_sosyal',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'TYT',
            // ad bilgisini belirler
            name: 'Sosyal Bilimler',
            // sıra numarası bilgisini belirler
            orderIndex: 3,
            // Soru sayısını belirler
            questionCount: 20),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'tyt_fen',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'TYT',
            // ad bilgisini belirler
            name: 'Fen Bilimleri',
            // sıra numarası bilgisini belirler
            orderIndex: 4,
            // Soru sayısını belirler
            questionCount: 20),
      ];
      // Listedeki öğeleri tek tek dolaşır
      for (final s in tytSubjects) {
        // Nesnenin verilerini Map yapısına dönüştürür
        batch.insert(GardenDatabaseSchema.tableSubjects, s.toMap());
      }
      // AYT Dersleri
      // ayt subjects bilgisini hesaplayıp saklar
      const aytSubjects = [
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_mat',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Matematik & Geometri',
            // sıra numarası bilgisini belirler
            orderIndex: 1,
            // Soru sayısını belirler
            questionCount: 40),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_fizik',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Fizik',
            // sıra numarası bilgisini belirler
            orderIndex: 2,
            // Soru sayısını belirler
            questionCount: 14),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_kimya',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Kimya',
            // sıra numarası bilgisini belirler
            orderIndex: 3,
            // Soru sayısını belirler
            questionCount: 13),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_biyo',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Biyoloji',
            // sıra numarası bilgisini belirler
            orderIndex: 4,
            // Soru sayısını belirler
            questionCount: 13),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_edebiyat',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Türk Dili ve Edebiyatı',
            // sıra numarası bilgisini belirler
            orderIndex: 5,
            // Soru sayısını belirler
            questionCount: 24),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_tarih1',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Tarih-1',
            // sıra numarası bilgisini belirler
            orderIndex: 6,
            // Soru sayısını belirler
            questionCount: 10),
        // ders nesnesini oluşturur
        Subject(
            // ID bilgisini belirler
            id: 'ayt_cografya1',
            // Öğrenme veya sınav aşamasını belirler
            stage: 'AYT',
            // ad bilgisini belirler
            name: 'Coğrafya-1',
            // sıra numarası bilgisini belirler
            orderIndex: 7,
            // Soru sayısını belirler
            questionCount: 6),
      ];
      // Listedeki öğeleri tek tek dolaşır
      for (final s in aytSubjects) {
        // Nesnenin verilerini Map yapısına dönüştürür
        batch.insert(GardenDatabaseSchema.tableSubjects, s.toMap());
      }
      // Konu listesi ekleme fonksiyonu
      // topics bilgisini ekler
      void addTopics(String subjectId, List<String> topicNames) {
        // Belirtilen aralıkta döngü çalıştırır
        for (var i = 0; i < topicNames.length; i++) {
          // t bilgisini hesaplayıp saklar
          final t = Topic(
            // ID bilgisini belirler
            id: '${subjectId}_${i + 1}',
            // Ders ID bilgisini belirler
            subjectId: subjectId,
            // ad bilgisini belirler
            name: topicNames[i],
            // sıra numarası bilgisini belirler
            orderIndex: i + 1,
          );
          // Nesnenin verilerini Map yapısına dönüştürür
          batch.insert(GardenDatabaseSchema.tableTopics, t.toMap());
        }
      }
      // TYT Konuları
      // İlgili fonksiyonu çalıştırır
      addTopics('tyt_turkce', const [
        // "Sözcükte Anlam" metnini kullanır
        'Sözcükte Anlam',
        // "Cümlede Anlam" metnini kullanır
        'Cümlede Anlam',
        // "Paragrafta Anlam" metnini kullanır
        'Paragrafta Anlam',
        // "Ses Bilgisi" metnini kullanır
        'Ses Bilgisi',
        // "Yazım Kuralları" metnini kullanır
        'Yazım Kuralları',
        // "Noktalama İşaretleri" metnini kullanır
        'Noktalama İşaretleri',
        // "Sözcükte Yapı ve Ekler" metnini kullanır
        'Sözcükte Yapı ve Ekler',
        // "İsim, Sıfat, Zamir" metnini kullanır
        'İsim, Sıfat, Zamir',
        // "Zarf, Edat, Bağlaç, Ünlem" metnini kullanır
        'Zarf, Edat, Bağlaç, Ünlem',
        // "Fiiller ve Fiilde Çatı" metnini kullanır
        'Fiiller ve Fiilde Çatı',
        // "Cümle Türleri ve Ögeleri" metnini kullanır
        'Cümle Türleri ve Ögeleri',
        // "Anlatım Bozuklukları" metnini kullanır
        'Anlatım Bozuklukları',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('tyt_mat', const [
        // "Temel Kavramlar" metnini kullanır
        'Temel Kavramlar',
        // "Sayı Basamakları" metnini kullanır
        'Sayı Basamakları',
        // "Bölme ve Bölünebilme" metnini kullanır
        'Bölme ve Bölünebilme',
        // "EBOB - EKOK" metnini kullanır
        'EBOB - EKOK',
        // "Rasyonel Sayılar" metnini kullanır
        'Rasyonel Sayılar',
        // "Basit Eşitsizlikler" metnini kullanır
        'Basit Eşitsizlikler',
        // "Mutlak Değer" metnini kullanır
        'Mutlak Değer',
        // "Üslü İfadeler" metnini kullanır
        'Üslü İfadeler',
        // "Köklü İfadeler" metnini kullanır
        'Köklü İfadeler',
        // "Çarpanlara Ayırma" metnini kullanır
        'Çarpanlara Ayırma',
        // "Oran ve Orantı" metnini kullanır
        'Oran ve Orantı',
        // "Denklem Çözme" metnini kullanır
        'Denklem Çözme',
        // "Problemler (Sayı, Kesir, Yaş, Yüzde, Hız)" metnini kullanır
        'Problemler (Sayı, Kesir, Yaş, Yüzde, Hız)',
        // "Kümeler ve Mantık" metnini kullanır
        'Kümeler ve Mantık',
        // "Fonksiyonlar" metnini kullanır
        'Fonksiyonlar',
        // "Polinomlar" metnini kullanır
        'Polinomlar',
        // "İkinci Dereceden Denklemler" metnini kullanır
        'İkinci Dereceden Denklemler',
        // "Permütasyon - Kombinasyon - Olasılık" metnini kullanır
        'Permütasyon - Kombinasyon - Olasılık',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('tyt_sosyal', const [
        // "Tarih Bilimine Giriş & İlk Çağ Uygarlıkları" metnini kullanır
        'Tarih Bilimine Giriş & İlk Çağ Uygarlıkları',
        // "İslam Öncesi ve İslam Tarihi" metnini kullanır
        'İslam Öncesi ve İslam Tarihi',
        // "Osmanlı Devleti ve Kuruluş-Yükseliş" metnini kullanır
        'Osmanlı Devleti ve Kuruluş-Yükseliş',
        // "Milli Mücadele ve Atatürk İnkılapları" metnini kullanır
        'Milli Mücadele ve Atatürk İnkılapları',
        // "Doğa ve İnsan & Harita Bilgisi" metnini kullanır
        'Doğa ve İnsan & Harita Bilgisi',
        // "İklim Bilgisi & Türkiye İklimi" metnini kullanır
        'İklim Bilgisi & Türkiye İklimi',
        // "Felsefenin Alanı ve Bilgi Felsefesi" metnini kullanır
        'Felsefenin Alanı ve Bilgi Felsefesi',
        // "Ahlak ve Varlık Felsefesi" metnini kullanır
        'Ahlak ve Varlık Felsefesi',
        // "Din Kültürü ve Ahlak Bilgisi Temel Konular" metnini kullanır
        'Din Kültürü ve Ahlak Bilgisi Temel Konular',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('tyt_fen', const [
        // "Fizik Bilimine Giriş & Madde ve Özellikleri" metnini kullanır
        'Fizik Bilimine Giriş & Madde ve Özellikleri',
        // "Kuvvet ve Hareket (TYT)" metnini kullanır
        'Kuvvet ve Hareket (TYT)',
        // "Isı ve Sıcaklık" metnini kullanır
        'Isı ve Sıcaklık',
        // "Elektrostatik ve Elektrik Devreleri" metnini kullanır
        'Elektrostatik ve Elektrik Devreleri',
        // "Optik ve Dalgalar (TYT)" metnini kullanır
        'Optik ve Dalgalar (TYT)',
        // "Kimya Bilimi & Atom ve Periyodik Sistem" metnini kullanır
        'Kimya Bilimi & Atom ve Periyodik Sistem',
        // "Kimyasal Türler Arası Etkileşimler" metnini kullanır
        'Kimyasal Türler Arası Etkileşimler',
        // "Maddenin Halleri & Asit, Baz, Tuz" metnini kullanır
        'Maddenin Halleri & Asit, Baz, Tuz',
        // "Canlıların Ortak Özellikleri ve Temel Bileş…" metnini kullanır
        'Canlıların Ortak Özellikleri ve Temel Bileşenler',
        // "Hücre ve Organelleri & Hücre Bölünmeleri" metnini kullanır
        'Hücre ve Organelleri & Hücre Bölünmeleri',
        // "Kalıtım ve Canlılar Dünyası" metnini kullanır
        'Kalıtım ve Canlılar Dünyası',
      ]);
      // AYT Konuları
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_mat', const [
        // "Polinomlar ve Çarpanlara Ayırma (AYT)" metnini kullanır
        'Polinomlar ve Çarpanlara Ayırma (AYT)',
        // "İkinci Dereceden Eşitsizlikler" metnini kullanır
        'İkinci Dereceden Eşitsizlikler',
        // "Parabol" metnini kullanır
        'Parabol',
        // "Trigonometri 1 & 2" metnini kullanır
        'Trigonometri 1 & 2',
        // "Logaritma" metnini kullanır
        'Logaritma',
        // "Diziler" metnini kullanır
        'Diziler',
        // "Limit ve Süreklilik" metnini kullanır
        'Limit ve Süreklilik',
        // "Türev ve Uygulamaları" metnini kullanır
        'Türev ve Uygulamaları',
        // "İntegral ve Uygulamaları" metnini kullanır
        'İntegral ve Uygulamaları',
        // "Analitik Geometri & Çemberin Analitiği" metnini kullanır
        'Analitik Geometri & Çemberin Analitiği',
        // "Uzay Geometri ve Katı Cisimler" metnini kullanır
        'Uzay Geometri ve Katı Cisimler',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_fizik', const [
        // "Vektörler ve Bağıl Hareket" metnini kullanır
        'Vektörler ve Bağıl Hareket',
        // "Newton’ın Hareket Yasaları (İleri)" metnini kullanır
        'Newton’ın Hareket Yasaları (İleri)',
        // "Bir Boyutta ve İki Boyutta Sabit İvmeli Har…" metnini kullanır
        'Bir Boyutta ve İki Boyutta Sabit İvmeli Hareket',
        // "İş, Güç ve Enerji (AYT)" metnini kullanır
        'İş, Güç ve Enerji (AYT)',
        // "İtme ve Çizgisel Momentum" metnini kullanır
        'İtme ve Çizgisel Momentum',
        // "Tork, Denge ve Kütle Merkezi" metnini kullanır
        'Tork, Denge ve Kütle Merkezi',
        // "Elektriksel Kuvvet, Alan ve Potansiyel" metnini kullanır
        'Elektriksel Kuvvet, Alan ve Potansiyel',
        // "Manyetizma ve Elektromanyetik İndüksiyon" metnini kullanır
        'Manyetizma ve Elektromanyetik İndüksiyon',
        // "Alternatif Akım ve Transformatörler" metnini kullanır
        'Alternatif Akım ve Transformatörler',
        // "Çembersel Hareket ve Basit Harmonik Hareket" metnini kullanır
        'Çembersel Hareket ve Basit Harmonik Hareket',
        // "Dalga Mekaniği ve Modern Fizik" metnini kullanır
        'Dalga Mekaniği ve Modern Fizik',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_kimya', const [
        // "Modern Atom Teorisi (AYT)" metnini kullanır
        'Modern Atom Teorisi (AYT)',
        // "Gazlar ve Gaz Yasaları" metnini kullanır
        'Gazlar ve Gaz Yasaları',
        // "Sıvı Çözeltiler ve Koligatif Özellikler" metnini kullanır
        'Sıvı Çözeltiler ve Koligatif Özellikler',
        // "Kimyasal Tepkimelerde Enerji (Entalpi)" metnini kullanır
        'Kimyasal Tepkimelerde Enerji (Entalpi)',
        // "Kimyasal Tepkimelerde Hız" metnini kullanır
        'Kimyasal Tepkimelerde Hız',
        // "Kimyasal Denge ve Dengeye Etki Eden Faktörler" metnini kullanır
        'Kimyasal Denge ve Dengeye Etki Eden Faktörler',
        // "Sulu Çözelti Dengeleri (Asit-Baz Dengesi)" metnini kullanır
        'Sulu Çözelti Dengeleri (Asit-Baz Dengesi)',
        // "Kimya ve Elektrik (Elektrokimya & Piller)" metnini kullanır
        'Kimya ve Elektrik (Elektrokimya & Piller)',
        // "Karbon Kimyasına Giriş" metnini kullanır
        'Karbon Kimyasına Giriş',
        // "Organik Kimya (Hidrokarbonlar ve Fonksiyone…" metnini kullanır
        'Organik Kimya (Hidrokarbonlar ve Fonksiyonel Gruplar)',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_biyo', const [
        // "Sinir Sistemi ve Duyu Organları" metnini kullanır
        'Sinir Sistemi ve Duyu Organları',
        // "Endokrin Sistem & Destek ve Hareket" metnini kullanır
        'Endokrin Sistem & Destek ve Hareket',
        // "Sindirim, Dolaşım ve Bağışıklık Sistemi" metnini kullanır
        'Sindirim, Dolaşım ve Bağışıklık Sistemi',
        // "Solunum ve Boşaltım Sistemi" metnini kullanır
        'Solunum ve Boşaltım Sistemi',
        // "Üreme Sistemi ve Embriyonik Gelişim" metnini kullanır
        'Üreme Sistemi ve Embriyonik Gelişim',
        // "Komünite ve Popülasyon Ekolojisi" metnini kullanır
        'Komünite ve Popülasyon Ekolojisi',
        // "Nükleik Asitler ve Genden Proteine" metnini kullanır
        'Nükleik Asitler ve Genden Proteine',
        // "Fotosentez ve Kemosentez" metnini kullanır
        'Fotosentez ve Kemosentez',
        // "Hücresel Solunum" metnini kullanır
        'Hücresel Solunum',
        // "Bitki Biyolojisi (Doku, Organ ve Üreme)" metnini kullanır
        'Bitki Biyolojisi (Doku, Organ ve Üreme)',
        // "Canlılar ve Çevre" metnini kullanır
        'Canlılar ve Çevre',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_edebiyat', const [
        // "Şiir Bilgisi ve Edebi Sanatlar" metnini kullanır
        'Şiir Bilgisi ve Edebi Sanatlar',
        // "İslamiyet Öncesi ve Geçiş Dönemi Edebiyatı" metnini kullanır
        'İslamiyet Öncesi ve Geçiş Dönemi Edebiyatı',
        // "Halk Edebiyatı" metnini kullanır
        'Halk Edebiyatı',
        // "Divan Edebiyatı" metnini kullanır
        'Divan Edebiyatı',
        // "Tanzimat, Servetifünun ve Fecriati" metnini kullanır
        'Tanzimat, Servetifünun ve Fecriati',
        // "Milli Edebiyat Dönemi" metnini kullanır
        'Milli Edebiyat Dönemi',
        // "Cumhuriyet Dönemi Türk Edebiyatı" metnini kullanır
        'Cumhuriyet Dönemi Türk Edebiyatı',
        // "Edebi Akımlar" metnini kullanır
        'Edebi Akımlar',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_tarih1', const [
        // "Tarih ve Zaman & İlk Türk Devletleri" metnini kullanır
        'Tarih ve Zaman & İlk Türk Devletleri',
        // "İslam Medeniyetinin Doğuşu" metnini kullanır
        'İslam Medeniyetinin Doğuşu',
        // "Türk-İslam Devletleri" metnini kullanır
        'Türk-İslam Devletleri',
        // "Klasik Çağda Osmanlı" metnini kullanır
        'Klasik Çağda Osmanlı',
        // "20. Yüzyıl Başlarında Osmanlı ve Dünya" metnini kullanır
        '20. Yüzyıl Başlarında Osmanlı ve Dünya',
        // "Milli Mücadele Dönemi (Ayrıntılı)" metnini kullanır
        'Milli Mücadele Dönemi (Ayrıntılı)',
        // "Atatürkçülük ve Türk İnkılabı" metnini kullanır
        'Atatürkçülük ve Türk İnkılabı',
      ]);
      // İlgili fonksiyonu çalıştırır
      addTopics('ayt_cografya1', const [
        // "Ekosistem ve Madde Döngüleri" metnini kullanır
        'Ekosistem ve Madde Döngüleri',
        // "Nüfus Politikaları ve Şehirlerin Fonksiyonları" metnini kullanır
        'Nüfus Politikaları ve Şehirlerin Fonksiyonları',
        // "Türkiye’de Tarım, Hayvancılık ve Madenler" metnini kullanır
        'Türkiye’de Tarım, Hayvancılık ve Madenler',
        // "Bölgeler ve Ülkelerarası Ticaret" metnini kullanır
        'Bölgeler ve Ülkelerarası Ticaret',
        // "Çevre ve Toplum Sorunları" metnini kullanır
        'Çevre ve Toplum Sorunları',
      ]);
      // commit işlemini yapar
      await batch.commit(noResult: true);
    });
  }
}

// deneme record dosyasını kullanıma ekler
import '../../../domain/models/exam_record.dart';
// analytics data point bilgilerini veya işlemlerini tutan sınıf
class AnalyticsDataPoint {
  // analytics data point nesnesini oluşturur
  const AnalyticsDataPoint({
    // ID bilgisini zorunlu tutar
    required this.id,
    // başlık bilgisini zorunlu tutar
    required this.title,
    // tarih bilgisini zorunlu tutar
    required this.date,
    // net bilgisini zorunlu tutar
    required this.net,
    // ders adı bilgisini isteğe bağlı alır
    this.subjectName,
  });
  // ID bilgisini tutar
  final String id;
  // başlık bilgisini tutar
  final String title;
  // tarih bilgisini tutar
  final DateTime date;
  // net bilgisini tutar
  final double net;
  // ders adı bilgisini tutar
  final String? subjectName;
}
// trend summary bilgilerini veya işlemlerini tutan sınıf
class TrendSummary {
  // trend summary nesnesini oluşturur
  const TrendSummary({
    // toplam exams bilgisini zorunlu tutar
    required this.totalExams,
    // latest net bilgisini zorunlu tutar
    required this.latestNet,
    // previous net bilgisini zorunlu tutar
    required this.previousNet,
    // net change bilgisini zorunlu tutar
    required this.netChange,
    // average net bilgisini zorunlu tutar
    required this.averageNet,
    // highest net bilgisini zorunlu tutar
    required this.highestNet,
    // lowest net bilgisini zorunlu tutar
    required this.lowestNet,
    // has sufficient data bilgisini zorunlu tutar
    required this.hasSufficientData,
  });
  // toplam exams bilgisini tutar
  final int totalExams;
  // latest net bilgisini tutar
  final double? latestNet;
  // previous net bilgisini tutar
  final double? previousNet;
  // net change bilgisini tutar
  final double? netChange;
  // average net bilgisini tutar
  final double averageNet;
  // highest net bilgisini tutar
  final double highestNet;
  // lowest net bilgisini tutar
  final double lowestNet;
  // has sufficient data bilgisini tutar
  final bool hasSufficientData;
  // change metin işlemini yapar
  String get changeText {
    // İlgili değer null ise kontrol eder
    if (netChange == null || !hasSufficientData) {
      // "Karşılaştırma için en az 2 deneme gerekiyor" metnini kullanır
      return 'Karşılaştırma için en az 2 deneme gerekiyor';
    }
    // Belirtilen koşul doğruysa işlemi yapar
    if (netChange! > 0) {
      // "+${netChange!.toStringAsFixed(2)} net artış" metnini kullanır
      return '+${netChange!.toStringAsFixed(2)} net artış';
    // Önceki koşul sağlanmazsa bu koşulu kontrol eder
    } else if (netChange! < 0) {
      // "${netChange!.toStringAsFixed(2)} net azalış" metnini kullanır
      return '${netChange!.toStringAsFixed(2)} net azalış';
    // Önceki koşul sağlanmazsa burası çalışır
    } else {
      // "Son denemeyle aynı net" metnini kullanır
      return 'Son denemeyle aynı net';
    }
  }
}
// ders net stat bilgilerini veya işlemlerini tutan sınıf
class SubjectNetStat {
  // ders net stat nesnesini oluşturur
  const SubjectNetStat({
    // ders ID bilgisini zorunlu tutar
    required this.subjectId,
    // ders adı bilgisini zorunlu tutar
    required this.subjectName,
    // average net bilgisini zorunlu tutar
    required this.averageNet,
    // latest net bilgisini zorunlu tutar
    required this.latestNet,
    // deneme sayı bilgisini zorunlu tutar
    required this.examCount,
  });
  // ders ID bilgisini tutar
  final String subjectId;
  // ders adı bilgisini tutar
  final String subjectName;
  // average net bilgisini tutar
  final double averageNet;
  // latest net bilgisini tutar
  final double latestNet;
  // deneme sayı bilgisini tutar
  final int examCount;
}
// Sabitleri veya ortak işlemleri tutan, nesne oluşturulamayan sınıf
abstract final class AnalyticsCalculator {
  /// Denemeleri kronolojik sıraya (eskiden yeniye) dizer ve seçilen derse göre veri noktaları üretir.
  // extract points işlemini yapar
  static List<AnalyticsDataPoint> extractPoints({
    // list bilgisini zorunlu tutar
    required List<ExamSession> exams,
    // Hesaplamada kullanılacak sayısal değeri belirler
    String? subjectId, // null = Toplam Net
  }) {
    // Liste veya metin boşsa bu koşul çalışır
    if (exams.isEmpty) return const [];
    // Kronolojik sıra (eskiden yeniye)
    // sorted bilgisini hesaplayıp saklar
    final sorted = List<ExamSession>.from(exams)
      // sort işlemini yapar
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    // noktalar için boş koleksiyon oluşturur
    final points = <AnalyticsDataPoint>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final exam in sorted) {
      // İlgili değer null ise kontrol eder
      if (subjectId == null) {
        // Genel toplam net
        // İlgili fonksiyonu çalıştırır
        points.add(
          // analytics data point nesnesini oluşturur
          AnalyticsDataPoint(
            // ID bilgisini belirler
            id: exam.id,
            // Başlığı belirler
            title: exam.title,
            // tarih bilgisini belirler
            date: exam.occurredAt,
            // Neti belirler
            net: exam.totalNet,
          ),
        );
      // Önceki koşul sağlanmazsa burası çalışır
      } else {
        // Belirli bir dersin neti
        // matching scores değerini tanımlar
        final matchingScores =
            // Koşula uyan kayıtları filtreler
            exam.scores.where((s) => s.subjectId == subjectId);
        // Liste veya metin doluysa bu koşul çalışır
        if (matchingScores.isNotEmpty) {
          // puan bilgisini hesaplayıp saklar
          final score = matchingScores.first;
          // İlgili fonksiyonu çalıştırır
          points.add(
            // analytics data point nesnesini oluşturur
            AnalyticsDataPoint(
              // ID bilgisini belirler
              id: exam.id,
              // Başlığı belirler
              title: exam.title,
              // tarih bilgisini belirler
              date: exam.occurredAt,
              // Neti belirler
              net: score.net,
              // ders adı bilgisini belirler
              subjectName: score.subjectName,
            ),
          );
        }
      }
    }
    // Hesaplanan sonucu döndürür
    return points;
  }
  /// Veri noktalarından trend özetini hesaplar.
  // trend bilgisini hesaplar
  static TrendSummary calculateTrend(List<AnalyticsDataPoint> points) {
    // Liste veya metin boşsa bu koşul çalışır
    if (points.isEmpty) {
      // trend summary nesnesini oluşturur
      return const TrendSummary(
        // toplam exams bilgisini belirler
        totalExams: 0,
        // latest net bilgisini belirler
        latestNet: null,
        // previous net bilgisini belirler
        previousNet: null,
        // net change bilgisini belirler
        netChange: null,
        // average net bilgisini belirler
        averageNet: 0.0,
        // highest net bilgisini belirler
        highestNet: 0.0,
        // lowest net bilgisini belirler
        lowestNet: 0.0,
        // has sufficient data bilgisini belirler
        hasSufficientData: false,
      );
    }
    // toplam exams bilgisini hesaplayıp saklar
    final totalExams = points.length;
    // latest net bilgisini hesaplayıp saklar
    final latestNet = points.last.net;
    // previous net değerini tanımlar
    final previousNet =
        // Öğe veya karakter sayısını kullanır
        points.length >= 2 ? points[points.length - 2].net : null;
    // net change bilgisini iki değeri karşılaştırarak hesaplar
    final netChange = previousNet != null ? latestNet - previousNet : null;
    // sum için başlangıç sayısını belirler
    double sum = 0.0;
    // highest bilgisini hesaplayıp saklar
    double highest = points.first.net;
    // lowest bilgisini hesaplayıp saklar
    double lowest = points.first.net;
    // Listedeki öğeleri tek tek dolaşır
    for (final p in points) {
      // sum değerine yeni miktarı ekler
      sum += p.net;
      // Belirtilen koşul doğruysa işlemi yapar
      if (p.net > highest) highest = p.net;
      // Belirtilen koşul doğruysa işlemi yapar
      if (p.net < lowest) lowest = p.net;
    }
    // trend summary nesnesini oluşturur
    return TrendSummary(
      // toplam exams bilgisini belirler
      totalExams: totalExams,
      // latest net bilgisini belirler
      latestNet: latestNet,
      // previous net bilgisini belirler
      previousNet: previousNet,
      // net change bilgisini belirler
      netChange: netChange,
      // average net bilgisini belirler
      averageNet: sum / totalExams,
      // highest net bilgisini belirler
      highestNet: highest,
      // lowest net bilgisini belirler
      lowestNet: lowest,
      // has sufficient data bilgisini belirler
      hasSufficientData: points.length >= 2,
    );
  }
  /// Tüm derslerin ortalama ve son net istatistiklerini hesaplar.
  // extract ders stats işlemini yapar
  static List<SubjectNetStat> extractSubjectStats(List<ExamSession> exams) {
    // Liste veya metin boşsa bu koşul çalışır
    if (exams.isEmpty) return const [];
    // sorted bilgisini hesaplayıp saklar
    final sorted = List<ExamSession>.from(exams)
      // sort işlemini yapar
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    // ders net map için boş koleksiyon oluşturur
    final Map<String, List<double>> subjectNetMap = {};
    // ders adı map için boş koleksiyon oluşturur
    final Map<String, String> subjectNameMap = {};
    // latest score map için boş koleksiyon oluşturur
    final Map<String, double> latestScoreMap = {};
    // Listedeki öğeleri tek tek dolaşır
    for (final exam in sorted) {
      // Listedeki öğeleri tek tek dolaşır
      for (final score in exam.scores) {
        // put if absent işlemini yapar
        subjectNetMap.putIfAbsent(score.subjectId, () => []).add(score.net);
        // ders adı map[score.ders id] değerini günceller
        subjectNameMap[score.subjectId] = score.subjectName;
        // latest score map[score.ders id] değerini günceller
        latestScoreMap[score.subjectId] = score.net;
      }
    }
    // stats için boş koleksiyon oluşturur
    final stats = <SubjectNetStat>[];
    // Listedeki öğeleri tek tek dolaşır
    for (final entry in subjectNetMap.entries) {
      // sub id bilgisini hesaplayıp saklar
      final subId = entry.key;
      // nets bilgisini hesaplayıp saklar
      final nets = entry.value;
      // avg bilgisini hesaplayıp saklar
      final avg = nets.reduce((a, b) => a + b) / nets.length;
      // İlgili fonksiyonu çalıştırır
      stats.add(
        // ders net stat nesnesini oluşturur
        SubjectNetStat(
          // Ders ID bilgisini belirler
          subjectId: subId,
          // ders adı bilgisini belirler
          subjectName: subjectNameMap[subId] ?? subId,
          // average net bilgisini belirler
          averageNet: avg,
          // latest net bilgisini belirler
          latestNet: latestScoreMap[subId] ?? 0.0,
          // deneme sayı bilgisini belirler
          examCount: nets.length,
        ),
      );
    }
    // İsme göre sırala
    // sort işlemini yapar
    stats.sort((a, b) => a.subjectName.compareTo(b.subjectName));
    // Hesaplanan sonucu döndürür
    return stats;
  }
}

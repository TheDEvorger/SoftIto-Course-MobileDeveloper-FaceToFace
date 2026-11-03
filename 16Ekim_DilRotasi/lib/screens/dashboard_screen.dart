// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Renk ayarlarını ekler
import '../core/palette.dart';
// Kelime modelini ekler
import '../models/vocabulary_word.dart';
// Ortak arayüz elemanlarını ekler
import '../widgets/ui_parts.dart';

// Verileri dışarıdan aldığı için StatelessWidget kullanılır
class DashboardScreen extends StatelessWidget {
  // Constructor ile gerekli bilgileri alır
  const DashboardScreen({
    // Üst sınıfa key gönderir
    super.key,
    // Kelime listesini zorunlu tutar
    required this.words,
    // Günlük hedef bilgisini zorunlu tutar
    required this.dailyGoal,
    // Kelime ekleme fonksiyonunu zorunlu tutar
    required this.onAdd,
    // Kelime defteri fonksiyonunu zorunlu tutar
    required this.onLibrary,
    // Tekrar fonksiyonunu zorunlu tutar
    required this.onReview,
    // Hedef değiştirme fonksiyonunu zorunlu tutar
    required this.onChangeGoal,
  });
  // Kelime listesini tutar
  final List<VocabularyWord> words;
  // Günlük hedef sayısını tutar
  final int dailyGoal;
  // Kelime ekleme için parametresiz callback
  final VoidCallback onAdd;
  // Kelime defterini açan callback
  final VoidCallback onLibrary;
  // Kelime IDsi alan callback
  final ValueChanged<String> onReview;
  // Yeni hedef sayısını alan callback
  final ValueChanged<int> onChangeGoal;
  // Üstteki build metodunu yeniden yazar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Şu anki tarihi alır
    final now = DateTime.now();
    // Bugün çalışılan kelimeleri sayar
    final todayCount = words
        .where(
          (w) =>
              w.lastReviewedAt != null &&
              DateUtils.isSameDay(w.lastReviewedAt, now),
        )
        .length;
    // Öğrenilmiş kelimeleri sayar
    final done = words.where((w) => w.stage == WordStage.mastered).length;
    // Çalışılmakta olan kelimeleri sayar
    final ongoing = words.where((w) => w.stage == WordStage.learning).length;
    // Günlük hedefin tamamlanma oranını 0 ile 1 arasında tutar
    final progress = (todayCount / dailyGoal).clamp(0.0, 1.0).toDouble();
    // Henüz öğrenilmemiş kelimeleri listeye alır
    final pending = words.where((w) => w.stage != WordStage.mastered).toList();
    // Günün tarihine göre listeden bir kelime seçer
    final featured = pending.isEmpty ? null : pending[now.day % pending.length];
    // Ekranın kaydırılmasını sağlar
    return SingleChildScrollView(
      // Sayfanın ortak çerçevesini kullanır
      child: PageFrame(
        // Elemanları alt alta ve sola hizalı dizer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bölüm başlığını gösterir
            const Kicker('GÜNLÜK ÇALIŞMA DEFTERİ   /   01'),
            // Dikeyde 11 boşluk bırakır
            const SizedBox(height: 11),
            // Ana başlığı temadaki yazı stiliyle gösterir
            Text(
              'Bir kelime daha,\nbir adım daha.',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Açıklama yazısını gösterir
            const Text(
              'Almanca ve İngilizce yolculuğunu kendi ritminle büyüt.',
              style: TextStyle(color: Palette.muted, fontSize: 14),
            ),
            // Dikeyde 28 boşluk bırakır
            const SizedBox(height: 28),
            // Günlük çalışma kartını oluşturur
            _StudyHero(
              // Günlük hedefi gönderir
              dailyGoal: dailyGoal,
              // Bugün çalışılan kelime sayısını gönderir
              todayCount: todayCount,
              // İlerleme oranını gönderir
              progress: progress,
              // Kelime ekleme fonksiyonunu gönderir
              onAdd: onAdd,
              // Hedef butonuna basılınca pencere açar
              onGoalTap: () => _pickGoal(context),
            ),
            // Dikeyde 19 boşluk bırakır
            const SizedBox(height: 19),
            // Ekran genişliğine göre kartları düzenler
            LayoutBuilder(
              builder: (context, constraints) {
                // Genişliğe göre 1, 2 veya 3 sütun belirler
                final columns = constraints.maxWidth >= 760
                    ? 3
                    : constraints.maxWidth >= 450
                    ? 2
                    : 1;
                // Kartlar arasındaki boşluğu belirler
                const gap = 12.0;
                // Sütun sayısına göre kart genişliğini hesaplar
                final tileWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                // Kartları yan yana dizer, sığmazsa alt satıra geçirir
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    // Toplam kelime sayısını gösterir
                    SizedBox(
                      width: tileWidth,
                      child: StatTile(
                        icon: Icons.auto_stories_outlined,
                        label: 'Defterdeki kelimeler',
                        value: '${words.length}',
                        tint: Palette.sage,
                        accent: Palette.forest,
                      ),
                    ),
                    // Öğrenilen kelime sayısını gösterir
                    SizedBox(
                      width: tileWidth,
                      child: StatTile(
                        icon: Icons.workspace_premium_outlined,
                        label: 'Öğrenilen',
                        value: '$done',
                        tint: Palette.coralLight,
                        accent: Palette.terracotta,
                      ),
                    ),
                    // Çalışılan kelime sayısını gösterir
                    SizedBox(
                      width: tileWidth,
                      child: StatTile(
                        icon: Icons.edit_note_rounded,
                        label: 'Çalışılmakta olan',
                        value: '$ongoing',
                        tint: Palette.amberSoft,
                        accent: const Color(0xFF8A6230),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Dikeyde 34 boşluk bırakır
            const SizedBox(height: 34),
            // Dil istatistiklerinin başlığını gösterir
            const SectionHeading(
              title: 'İki dil, tek yolculuk',
              subtitle: 'Kendi kelime arşivinin ilerleme notları.',
            ),
            // Dikeyde 15 boşluk bırakır
            const SizedBox(height: 15),
            // Ekran genişliğine göre dil kartlarını yerleştirir
            LayoutBuilder(
              builder: (context, constraints) {
                // Almanca istatistik kartını oluşturur
                final german = _LanguageNote(
                  language: StudyLanguage.german,
                  words: words,
                  sequence: '01',
                );
                // İngilizce istatistik kartını oluşturur
                final english = _LanguageNote(
                  language: StudyLanguage.english,
                  words: words,
                  sequence: '02',
                );
                // Ekran darsa kartları alt alta gösterir
                if (constraints.maxWidth < 690)
                  return Column(
                    children: [german, const SizedBox(height: 12), english],
                  );
                // Ekran genişse kartları yan yana gösterir
                return Row(
                  children: [
                    Expanded(child: german),
                    const SizedBox(width: 12),
                    Expanded(child: english),
                  ],
                );
              },
            ),
            // Dikeyde 34 boşluk bırakır
            const SizedBox(height: 34),
            // Günün kelimesi bölümünü oluşturur
            SectionHeading(
              // Bölüm başlığını belirler
              title: 'Bugünün kelimesi',
              // Açıklama metnini belirler
              subtitle: 'Bir kelime seç, ona bir kez daha uğra.',
              // Başlığın sağına buton ekler
              trailing: IconButton(
                // Butonun açıklaması
                tooltip: 'Kelime defterini aç',
                // Basılınca kelime defterini açar
                onPressed: onLibrary,
                // Sağ ok simgesini gösterir
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            // Dikeyde 14 boşluk bırakır
            const SizedBox(height: 14),
            // Seçilen kelime varsa kartını gösterir
            if (featured != null)
              // Kelimeyi gösterir, basılınca tekrar işlemini çalıştırır
              WordTile(
                word: featured,
                compact: true,
                onReview: () => onReview(featured.id),
              )
            // Kelime yoksa boş ekran bilgisini gösterir
            else
              // Boş liste için bilgilendirme alanı
              EmptyState(
                // Alanın başlığı
                title: 'Defterinde bekleyen kelime yok',
                // Açıklama metni
                message:
                    'Yeni bir kelime ekleyerek bugünün sayfasını açabilirsin.',
                // Boş liste simgesi
                icon: Icons.bookmark_add_outlined,
                // Kelime ekleme butonunu gösterir
                action: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Kelime ekle'),
                ),
              ),
            // Dikeyde 30 boşluk bırakır
            const SizedBox(height: 30),
            // Sayfanın altındaki yazıyı gösterir
            const Center(
              child: Text(
                'DİL ROTASI     •     YAVAŞ VE SAĞLAM',
                style: TextStyle(
                  letterSpacing: 1.7,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Palette.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Günlük hedefi değiştiren pencereyi açar
  Future<void> _pickGoal(BuildContext context) async {
    // Mevcut hedefi double tipine çevirir
    var value = dailyGoal.toDouble();
    // Kullanıcının seçeceği hedef değerini bekler
    final updated = await showDialog<int>(
      // Pencerenin açılacağı context
      context: context,
      // Pencerenin içeriğini oluşturur
      builder: (dialogContext) => StatefulBuilder(
        // Pencere içindeki değişiklikleri yönetir
        builder: (context, update) => AlertDialog(
          // Pencerenin başlığı
          title: const Text('Günlük çalışma hedefi'),
          // Hedef ayarlarını alt alta gösterir
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Seçilen günlük hedefi gösterir
              Text(
                '${value.round()} kelime / gün',
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 25,
                  color: Palette.forest,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Slider ile 1 ile 30 arasında hedef seçilir
              Slider(
                value: value,
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (v) => update(() => value = v),
              ),
              // Hedefin nasıl hesaplandığını açıklar
              const Text(
                'Aynı kelimeyi günde birkaç kez çalışsan da hedefe bir kez sayılır.',
                style: TextStyle(color: Palette.muted, fontSize: 12),
              ),
            ],
          ),
          // Pencerenin altındaki butonları tutar
          actions: [
            // Vazgeç butonu pencereyi kapatır
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Vazgeç'),
            ),
            // Kaydet butonu seçilen hedefi geri gönderir
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, value.round()),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    // Yeni hedef seçildiyse değiştirme fonksiyonunu çağırır
    if (updated != null) onChangeGoal(updated);
  }
}

// Günlük çalışma kartını oluşturan sınıf
class _StudyHero extends StatelessWidget {
  // Constructor gerekli bilgileri alır
  const _StudyHero({
    required this.dailyGoal,
    required this.todayCount,
    required this.progress,
    required this.onAdd,
    required this.onGoalTap,
  });
  // Günlük hedefi tutar
  final int dailyGoal;
  // Bugün çalışılan kelime sayısını tutar
  final int todayCount;
  // İlerleme oranını tutar
  final double progress;
  // Kelime ekleme callbacki
  final VoidCallback onAdd;
  // Hedef değiştirme callbacki
  final VoidCallback onGoalTap;
  // Üstteki build metodunu yeniden yazar
  @override
  // Günlük çalışma kartını oluşturur
  Widget build(BuildContext context) => Container(
    // Kartın dışına taşan elemanları keser
    clipBehavior: Clip.antiAlias,
    // Kartın rengini ve köşelerini belirler
    decoration: BoxDecoration(
      color: Palette.forest,
      borderRadius: BorderRadius.circular(18),
    ),
    // Kart genişliğine göre içeriği düzenler
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Genişlik yeterliyse süs desenini gösterir
        final roomForSeal = constraints.maxWidth >= 620;
        // Elemanları üst üste yerleştirir
        return Stack(
          children: [
            // Yeterli alan varsa desen gösterilir
            if (roomForSeal)
              // Deseni kartın sağ tarafına yerleştirir
              Positioned(
                right: 36,
                top: 5,
                bottom: 5,
                child: Center(
                  child: OrbitPattern(size: 215, color: Palette.olive),
                ),
              ),
            // Kartın iç boşluklarını belirler
            Padding(
              // Genişliğe göre yatay boşluğu değiştirir
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < 450 ? 23 : 30,
                vertical: 26,
              ),
              // İçerikleri alt alta dizer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve hedef butonunu yan yana gösterir
                  Row(
                    children: [
                      // Başlığı kalan alana yayar
                      const Expanded(child: Kicker('BUGÜNÜN İZİ', dark: true)),
                      // Hedef değiştirme butonu
                      TextButton.icon(
                        // Basılınca hedef penceresini açar
                        onPressed: onGoalTap,
                        // Butonun renk ve yoğunluğunu belirler
                        style: TextButton.styleFrom(
                          foregroundColor: Palette.paper,
                          visualDensity: VisualDensity.compact,
                        ),
                        // Ayar simgesini gösterir
                        icon: const Icon(Icons.tune_rounded, size: 17),
                        // Butonun yazısını gösterir
                        label: const Text(
                          'Hedef',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  // Dikeyde 10 boşluk bırakır
                  const SizedBox(height: 10),
                  // Bugün çalışılan kelime sayısını ve hedefi gösterir
                  Text(
                    '$todayCount / $dailyGoal',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: Palette.paper,
                      fontSize: 47,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  // Dikeyde 10 boşluk bırakır
                  const SizedBox(height: 10),
                  // Sayaç açıklamasını gösterir
                  const Text(
                    'Bugün çalışılan farklı kelimeler',
                    style: TextStyle(color: Color(0xFFE2E8DA), fontSize: 12),
                  ),
                  // Dikeyde 20 boşluk bırakır
                  const SizedBox(height: 20),
                  // İlerleme çubuğunun genişliğini ayarlar
                  SizedBox(
                    // Geniş ekranda yüzde 55 alan kaplar
                    width: roomForSeal
                        ? constraints.maxWidth * .55
                        : double.infinity,
                    // Yuvarlak köşeli ilerleme çubuğu oluşturur
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        // Tamamlanma oranını gösterir
                        value: progress,
                        // Çubuğun arka plan rengi
                        backgroundColor: const Color(0xFF536D5D),
                        // İlerleme rengini sabit tutar
                        valueColor: const AlwaysStoppedAnimation(
                          Palette.mustard,
                        ),
                        // Çubuğun yüksekliği
                        minHeight: 8,
                      ),
                    ),
                  ),
                  // Dikeyde 17 boşluk bırakır
                  const SizedBox(height: 17),
                  // Hedef tamamlandıysa farklı mesaj gösterir
                  Text(
                    progress >= 1
                        ? 'Bugünün sayfası tamamlandı. Tebrikler!'
                        : 'Az ama düzenli: bir kelimeyle başla.',
                    style: const TextStyle(fontSize: 13, color: Palette.paper),
                  ),
                  // Dikeyde 20 boşluk bırakır
                  const SizedBox(height: 20),
                  // Yeni kelime ekleme butonu
                  FilledButton.icon(
                    // Basılınca kelime ekleme ekranına geçer
                    onPressed: onAdd,
                    // Butonun renklerini belirler
                    style: FilledButton.styleFrom(
                      backgroundColor: Palette.mustard,
                      foregroundColor: Palette.forestDeep,
                    ),
                    // Artı simgesini gösterir
                    icon: const Icon(Icons.add_rounded),
                    // Butonun yazısını gösterir
                    label: const Text('Yeni kelime yaz'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

// Dillere göre ilerlemeyi gösteren kart sınıfı
class _LanguageNote extends StatelessWidget {
  // Constructor dil, kelimeler ve sıra bilgilerini alır
  const _LanguageNote({
    required this.language,
    required this.words,
    required this.sequence,
  });
  // Kartın dil bilgisini tutar
  final StudyLanguage language;
  // Kelime listesini tutar
  final List<VocabularyWord> words;
  // Kartın sıra numarasını tutar
  final String sequence;
  // Üstteki build metodunu yeniden yazar
  @override
  // Dil istatistiklerini hesaplayıp kartı oluşturur
  Widget build(BuildContext context) {
    // Seçilen dile ait toplam kelime sayısını bulur
    final total = words.where((w) => w.language == language).length;
    // Seçilen dilde öğrenilen kelimeleri sayar
    final mastered = words
        .where((w) => w.language == language && w.stage == WordStage.mastered)
        .length;
    // Öğrenilen kelimelerin oranını hesaplar
    final percentage = total == 0 ? 0.0 : mastered / total;
    // Seçilen dil Almancaysa true olur
    final isGerman = language == StudyLanguage.german;
    // İstatistik kartının panelini oluşturur
    return SurfacePanel(
      // Kartın iç boşluğu
      padding: const EdgeInsets.all(20),
      // Kart içeriğini alt alta dizer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sıra numarası ve dil rozetini yan yana gösterir
          Row(
            children: [
              // Kartın sıra numarasını gösterir
              Text(
                sequence,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 27,
                  fontStyle: FontStyle.italic,
                  color: Palette.terracotta,
                ),
              ),
              // Elemanların arasını açar
              const Spacer(),
              // Dilin rozetini gösterir
              LanguageBadge(language: language),
            ],
          ),
          // Dikeyde 12 boşluk bırakır
          const SizedBox(height: 12),
          // Almanca veya İngilizce başlığını gösterir
          Text(
            isGerman ? 'Deutsch lernen' : 'Learn English',
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Palette.ink,
            ),
          ),
          // Dikeyde 6 boşluk bırakır
          const SizedBox(height: 6),
          // Öğrenilen ve toplam kelime sayısını gösterir
          Text(
            '$mastered / $total kelime öğrenildi',
            style: const TextStyle(color: Palette.muted, fontSize: 12),
          ),
          // Dikeyde 19 boşluk bırakır
          const SizedBox(height: 19),
          // Öğrenme oranını ilerleme çubuğuyla gösterir
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              // Öğrenilen kelimelerin oranını verir
              value: percentage,
              // Çubuğun yüksekliği
              minHeight: 6,
              // Çubuğun arka plan rengi
              backgroundColor: Palette.fog,
              // Almanca ve İngilizce için farklı renk kullanır
              valueColor: AlwaysStoppedAnimation(
                isGerman ? Palette.terracotta : Palette.moss,
              ),
            ),
          ),
          // Dikeyde 8 boşluk bırakır
          const SizedBox(height: 8),
          // Tamamlanma yüzdesini sağ tarafta gösterir
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '%${(percentage * 100).round()}',
              style: const TextStyle(
                color: Palette.ink,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

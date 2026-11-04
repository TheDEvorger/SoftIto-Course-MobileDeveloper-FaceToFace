// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// rehber karakter dosyasını kullanıma ekler
import '../domain/mentor.dart';
// live lesson pencere dosyasını kullanıma ekler
import 'live_lesson_dialog.dart';
// mentors ekran bölümünü oluşturan StatelessWidget sınıfı
class MentorsScreen extends StatelessWidget {
  // mentors ekran sayfasını gösterir
  const MentorsScreen({super.key});
  // live lesson bilgisini açar
  void _openLiveLesson(BuildContext context, FantasyMentor mentor) {
    // Kullanıcıya açılır pencere gösterir
    showDialog<void>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (_) => LiveLessonDialog(mentor: mentor),
    );
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ana renk bilgisini hesaplayıp saklar
    const primary = GardenPalette.mossEmerald;
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: const Text('Kadim Akademi & Canlı Dersler'),
        // Gölge yüksekliğini belirler
        elevation: 0,
      ),
      // Sayfanın ana içeriğini belirler
      body: ListView(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // İçerideki widgetları listeler
        children: [
          // Karşılama ve Atmosfer Başlığı
          // Görsel bir kutu oluşturur
          Container(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(16),
            // Kutu ve kenarlık görünümünü belirler
            decoration: BoxDecoration(
              // Renk geçişini belirler
              gradient: LinearGradient(
                // renkler bilgisini belirler
                colors: isDark
                    // Koşul doğruysa bu değeri kullanır
                    ? [const Color(0xFF1B2B20), const Color(0xFF101B14)]
                    // Koşul yanlışsa bu değeri kullanır
                    : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
              ),
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(20),
              // Kenarlığı belirler
              border: Border.all(color: primary.withValues(alpha: 0.3)),
            ),
            // İçine yerleştirilecek widgetı belirler
            child: Row(
              // İçerideki widgetları listeler
              children: [
                // Görsel bir kutu oluşturur
                Container(
                  // İç boşlukları belirler
                  padding: const EdgeInsets.all(12),
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: BoxDecoration(
                    // Rengi belirler
                    color: primary.withValues(alpha: 0.15),
                    // Widgetın kenar şeklini belirler
                    shape: BoxShape.circle,
                  ),
                  // İçine yerleştirilecek widgetı belirler
                  child: const Icon(Icons.auto_awesome, color: primary, size: 28),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(width: 14),
                // Kalan boşluğu kullanacak alan oluşturur
                Expanded(
                  // İçine yerleştirilecek widgetı belirler
                  child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki widgetları listeler
                    children: [
                      // Metni ekranda gösterir
                      Text(
                        // "Fantastik Akademi Salonu" metnini kullanır
                        'Fantastik Akademi Salonu',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 16,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.bold,
                          // Rengi belirler
                          color: isDark ? Colors.white : GardenPalette.inkPlum,
                        ),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(height: 4),
                      // Metni ekranda gösterir
                      Text(
                        // "Bahçenin dört bir yanından gelen kadim YKS …" metnini kullanır
                        'Bahçenin dört bir yanından gelen kadim YKS üstatları canlı yayınlarda ve soru-cevap seanslarında seni bekliyor!',
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 12,
                          // Rengi belirler
                          color: isDark ? Colors.white70 : Colors.black87,
                          // Yüksekliği belirler
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 20),
          // Metni ekranda gösterir
          Text(
            // "BİLGE EĞİTMENLER & CANLI YAYINLAR" metnini kullanır
            'BİLGE EĞİTMENLER & CANLI YAYINLAR',
            // Görünüm stilini belirler
            style: TextStyle(
              // Yazı boyutunu belirler
              fontSize: 11,
              // Yazı kalınlığını belirler
              fontWeight: FontWeight.bold,
              // Harfler arasındaki boşluğu belirler
              letterSpacing: 1.2,
              // Rengi belirler
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          // Sabit boyutlu veya boşluk bırakan alan oluşturur
          const SizedBox(height: 12),
          // Eğitmen Kartları
          // Öğeleri tek tek dönüştürür
          ...FantasyMentor.allMentors.map((mentor) {
            // Görsel bir kutu oluşturur
            return Container(
              // Dış boşlukları belirler
              margin: const EdgeInsets.only(bottom: 20),
              // Kutu ve kenarlık görünümünü belirler
              decoration: BoxDecoration(
                // Rengi belirler
                color: isDark ? const Color(0xFF141F18) : Colors.white,
                // Köşelerin yuvarlaklığını belirler
                borderRadius: BorderRadius.circular(24),
                // Gölge ayarlarını belirler
                boxShadow: [
                  // Kutuya gölge ayarı ekler
                  BoxShadow(
                    // Rengi belirler
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    // Gölgenin bulanıklığını belirler
                    blurRadius: 12,
                    // Gölgenin konumunu belirler
                    offset: const Offset(0, 4),
                  ),
                ],
                // Kenarlığı belirler
                border: Border.all(
                  // Rengi belirler
                  color: mentor.isLiveNow
                      // Koşul doğruysa bu değeri kullanır
                      ? Colors.redAccent.withValues(alpha: 0.4)
                      // Koşul yanlışsa bu değeri kullanır
                      : (isDark ? Colors.white10 : Colors.black12),
                  // Genişliği belirler
                  width: mentor.isLiveNow ? 1.5 : 1.0,
                ),
              ),
              // İçine yerleştirilecek widgetı belirler
              child: Column(
                // Çapraz eksendeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // İçerideki widgetları listeler
                children: [
                  // Hoca Resmi ve Üst Bilgi
                  // Elemanları üst üste yerleştirir
                  Stack(
                    // İçerideki widgetları listeler
                    children: [
                      // Köşelere göre taşan kısmı keser
                      ClipRRect(
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        // İçine yerleştirilecek widgetı belirler
                        child: SizedBox(
                          // Yüksekliği belirler
                          height: 180,
                          // Genişliği belirler
                          width: double.infinity,
                          // İçine yerleştirilecek widgetı belirler
                          child: Image.asset(
                            // İlgili değeri veya görünüm ayarını belirler
                            mentor.avatarAsset,
                            // Görselin alana nasıl sığacağını belirler
                            fit: BoxFit.cover,
                            // İçeriğin hizalanmasını belirler
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      // Karartma gradyanı
                      // positioned.fill nesnesini oluşturur
                      Positioned.fill(
                        // İçine yerleştirilecek widgetı belirler
                        child: DecoratedBox(
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Renk geçişini belirler
                            gradient: LinearGradient(
                              // renkler bilgisini belirler
                              colors: [
                                // Temadan renk veya görünüm değeri alır
                                Colors.transparent,
                                // Temadan renk veya görünüm değeri alır
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              // begin bilgisini belirler
                              begin: Alignment.topCenter,
                              // end bilgisini belirler
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Canlı Yayında Rozeti
                      // Elemanı Stack içinde konumlandırır
                      Positioned(
                        // top bilgisini belirler
                        top: 12,
                        // left bilgisini belirler
                        left: 12,
                        // İçine yerleştirilecek widgetı belirler
                        child: Container(
                          // İç boşlukları belirler
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: mentor.isLiveNow ? Colors.redAccent : Colors.black54,
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(16),
                            // Gölge ayarlarını belirler
                            boxShadow: [
                              // Belirtilen koşul doğruysa işlemi yapar
                              if (mentor.isLiveNow)
                                // Kutuya gölge ayarı ekler
                                BoxShadow(
                                  // Rengi belirler
                                  color: Colors.redAccent.withValues(alpha: 0.4),
                                  // Gölgenin bulanıklığını belirler
                                  blurRadius: 8,
                                  // Gölgenin konumunu belirler
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Row(
                            // Ana eksende kaplanacak alanı belirler
                            mainAxisSize: MainAxisSize.min,
                            // İçerideki widgetları listeler
                            children: [
                              // Simge gösterir
                              Icon(
                                // İlgili değeri veya görünüm ayarını belirler
                                mentor.isLiveNow
                                    // Koşul doğruysa bu değeri kullanır
                                    ? Icons.fiber_manual_record
                                    // Koşul yanlışsa bu değeri kullanır
                                    : Icons.schedule,
                                // Rengi belirler
                                color: Colors.white,
                                // Boyutu belirler
                                size: 12,
                              ),
                              // Sabit boyutlu veya boşluk bırakan alan oluşturur
                              const SizedBox(width: 4),
                              // Metni ekranda gösterir
                              Text(
                                // Koşula göre iki değerden birini seçer
                                mentor.isLiveNow ? 'CANLI YAYINDA' : mentor.lessonTime,
                                // Görünüm stilini belirler
                                style: const TextStyle(
                                  // Rengi belirler
                                  color: Colors.white,
                                  // Yazı boyutunu belirler
                                  fontSize: 10,
                                  // Yazı kalınlığını belirler
                                  fontWeight: FontWeight.bold,
                                  // Harfler arasındaki boşluğu belirler
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Branş Rozeti
                      // Elemanı Stack içinde konumlandırır
                      Positioned(
                        // top bilgisini belirler
                        top: 12,
                        // right bilgisini belirler
                        right: 12,
                        // İçine yerleştirilecek widgetı belirler
                        child: Container(
                          // İç boşlukları belirler
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: primary.withValues(alpha: 0.9),
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(16),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            mentor.subject,
                            // Görünüm stilini belirler
                            style: const TextStyle(
                              // Rengi belirler
                              color: Colors.white,
                              // Yazı boyutunu belirler
                              fontSize: 10,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Resim üzerindeki alt isim
                      // Elemanı Stack içinde konumlandırır
                      Positioned(
                        // bottom bilgisini belirler
                        bottom: 12,
                        // left bilgisini belirler
                        left: 16,
                        // right bilgisini belirler
                        right: 16,
                        // İçine yerleştirilecek widgetı belirler
                        child: Column(
                          // Çapraz eksendeki hizalamayı belirler
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // İçerideki widgetları listeler
                          children: [
                            // Metni ekranda gösterir
                            Text(
                              // İlgili değeri veya görünüm ayarını belirler
                              mentor.name,
                              // Görünüm stilini belirler
                              style: const TextStyle(
                                // Rengi belirler
                                color: Colors.white,
                                // Yazı boyutunu belirler
                                fontSize: 18,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Metni ekranda gösterir
                            Text(
                              // İlgili değeri veya görünüm ayarını belirler
                              mentor.title,
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Rengi belirler
                                color: Colors.amber.shade200,
                                // Yazı boyutunu belirler
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Açıklama ve Canlı Ders Başlığı
                  // İç boşluk ekler
                  Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(16),
                    // İçine yerleştirilecek widgetı belirler
                    child: Column(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçerideki widgetları listeler
                      children: [
                        // Bilgelik Sözü
                        // Görsel bir kutu oluşturur
                        Container(
                          // İç boşlukları belirler
                          padding: const EdgeInsets.all(10),
                          // Kutu ve kenarlık görünümünü belirler
                          decoration: BoxDecoration(
                            // Rengi belirler
                            color: isDark ? const Color(0xFF1D2B22) : const Color(0xFFF1F8F4),
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // İçine yerleştirilecek widgetı belirler
                          child: Row(
                            // Çapraz eksendeki hizalamayı belirler
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // İçerideki widgetları listeler
                            children: [
                              // Simge gösterir
                              const Icon(Icons.format_quote_rounded, color: Colors.amber, size: 20),
                              // Sabit boyutlu veya boşluk bırakan alan oluşturur
                              const SizedBox(width: 6),
                              // Kalan boşluğu kullanacak alan oluşturur
                              Expanded(
                                // İçine yerleştirilecek widgetı belirler
                                child: Text(
                                  // İlgili değeri veya görünüm ayarını belirler
                                  mentor.wisdomQuote,
                                  // Görünüm stilini belirler
                                  style: TextStyle(
                                    // Yazı boyutunu belirler
                                    fontSize: 12,
                                    // Yazının italik olup olmadığını belirler
                                    fontStyle: FontStyle.italic,
                                    // Rengi belirler
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    // Yüksekliği belirler
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 12),
                        // Canlı Ders Bilgisi
                        // Metni ekranda gösterir
                        Text(
                          // "Güncel Seans: ${mentor.liveLessonTitle}" metnini kullanır
                          'Güncel Seans: ${mentor.liveLessonTitle}',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 13,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.bold,
                            // Rengi belirler
                            color: isDark ? Colors.white : GardenPalette.inkPlum,
                          ),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 4),
                        // Metni ekranda gösterir
                        Text(
                          // İlgili değeri veya görünüm ayarını belirler
                          mentor.lessonSummary,
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Rengi belirler
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            // Yüksekliği belirler
                            height: 1.3,
                          ),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 12),
                        // Uzmanlık Etiketleri
                        // Öğeleri sığmadıkça alt satıra geçirir
                        Wrap(
                          // spacing bilgisini belirler
                          spacing: 6,
                          // run spacing bilgisini belirler
                          runSpacing: 4,
                          // İçerideki widgetları listeler
                          children: mentor.specialtyTags.map((tag) {
                            // Etiket görünümü oluşturur
                            return Chip(
                              // Buton veya alan yazısını belirler
                              label: Text(tag, style: const TextStyle(fontSize: 10)),
                              // İç boşlukları belirler
                              padding: EdgeInsets.zero,
                              // material tap hedef size bilgisini belirler
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              // Arka plan rengini belirler
                              backgroundColor:
                                  // Koşula göre iki değerden birini seçer
                                  isDark ? const Color(0xFF1E2D24) : const Color(0xFFE8F1EB),
                            );
                          // Sonuçları listeye çevirir
                          }).toList(),
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 16),
                        // Eylem Butonları
                        // Elemanları yan yana dizer
                        Row(
                          // İçerideki widgetları listeler
                          children: [
                            // Kalan boşluğu kullanacak alan oluşturur
                            Expanded(
                              // İçine yerleştirilecek widgetı belirler
                              child: ElevatedButton.icon(
                                // simge bilgisini belirler
                                icon: Icon(
                                  // Koşula göre iki değerden birini seçer
                                  mentor.isLiveNow ? Icons.play_arrow_rounded : Icons.forum_rounded,
                                  // Boyutu belirler
                                  size: 18,
                                ),
                                // Buton veya alan yazısını belirler
                                label: Text(
                                  // Koşula göre iki değerden birini seçer
                                  mentor.isLiveNow ? 'Canlı Derse Katıl' : 'Hocaya Soru Sor (AI)',
                                  // Görünüm stilini belirler
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                // Görünüm stilini belirler
                                style: ElevatedButton.styleFrom(
                                  // Arka plan rengini belirler
                                  backgroundColor:
                                      // Koşula göre iki değerden birini seçer
                                      mentor.isLiveNow ? Colors.redAccent : primary,
                                  // Yazı ve simge rengini belirler
                                  foregroundColor: Colors.white,
                                  // İç boşlukları belirler
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  // Widgetın kenar şeklini belirler
                                  shape: RoundedRectangleBorder(
                                    // Köşelerin yuvarlaklığını belirler
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                // Basılınca çalışacak fonksiyonu belirler
                                onPressed: () => _openLiveLesson(context, mentor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

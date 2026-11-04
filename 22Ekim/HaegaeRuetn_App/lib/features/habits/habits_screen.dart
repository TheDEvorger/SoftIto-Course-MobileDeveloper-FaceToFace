// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Vazife modelini projeye ekler
import '../../core/models/habit.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Krallık tema ayarlarını projeye ekler
import '../../core/theme/realm_theme.dart';
// Krallık manzarası çizimini projeye ekler
import '../../core/widgets/original_kingdom_art.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Ortak krallık kartlarını projeye ekler
import '../../core/widgets/realm_card.dart';
// Vazife düzenleme formunu projeye ekler
import 'habit_editor_sheet.dart';
// Günlük vazifeleri ve dinlenme günü ayarını gösterir
class HabitsScreen extends StatelessWidget {
  // HabitsScreen nesnesinin başlangıç bilgilerini alır
  const HabitsScreen({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Yeni veya mevcut vazife için düzenleme penceresini açar
  void openEditor(BuildContext context, [Habit? habit]) =>
      // Sonraki satırlardan gelecek parametreleri alır
      showModalBottomSheet<void>(
        // İşlemin çalıştığı widget bağlamını gönderir
        context: context,
        // Alt panelin ekranı daha fazla kaplamasına izin verir
        isScrollControlled: true,
        // Alt panelin tutma çizgisini gösterir
        showDragHandle: true,
        // Arka plan rengini belirler
        backgroundColor: const Color(0xFFF8F3E8),
        // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
        builder: (context) =>
            // Yeni HabitEditorSheet nesnesi oluşturur
            HabitEditorSheet(controller: controller, habit: habit),
      );
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // HabitsScreen için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ekranda kullanılacak krallık controllerını kısa değişkene alır
    final c = controller;
    // Geçerli seviyenin çağını alır
    final era = c.era;
    // Kaydırılabilir öğe listesi oluşturur
    return ListView(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      // İçeride sıralanacak widgetları listeler
      children: [
        // Yeni FancyHeroHeader nesnesi oluşturur
        FancyHeroHeader(
          // başlık alanına gösterilecek metni belirler
          title: 'Bugünkü Vazifeler',
          // subtitle alanına değerini belirler
          subtitle:
              // Gösterilecek veya kullanılacak metin parçasını ekler
              '${era.name} Çağı • ${c.rank} • “Küçük adımlar büyük krallıklar kurar.”',
          // Gösterilecek görselin dosya yolunu belirler
          assetPath: ArtAssets.habits,
          // rozet alanına gelen değeri kullanır
          badge: FramedIconBadge(
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.workspace_premium_outlined,
            // Butonun ya da etiketin görünen yazısını belirler
            label: 'İtibar',
            // Gösterilecek güncel değeri atar
            value: '${c.reputation}/100',
            // Bu elemanın rengini belirler
            color: era.primary,
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 14),
        // Elemanları yatay yönde sıralar
        Row(
          // İçeride sıralanacak widgetları listeler
          children: [
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: MiniStatCard(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'TECRÜBE',
                // Gösterilecek güncel değeri atar
                value: '${c.xp} XP',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.auto_awesome,
                // Bu elemanın rengini belirler
                color: era.secondary,
              ),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(width: 8),
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: MiniStatCard(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'TAMAM',
                // Gösterilecek güncel değeri atar
                value: '${c.todayCompleted}/${c.activeHabits.length}',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.task_alt,
                // Bu elemanın rengini belirler
                color: const Color(0xFFFFE6B9),
              ),
            ),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(width: 8),
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: MiniStatCard(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'ROZET',
                // Gösterilecek güncel değeri atar
                value: '${c.badgeCount}/24',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.emoji_events_outlined,
                // Bu elemanın rengini belirler
                color: const Color(0xFFE9DDFC),
              ),
            ),
          ],
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 16),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Elemanları yatay yönde sıralar
              Row(
                // İçeride sıralanacak widgetları listeler
                children: [
                  // İçeriğin kalan alanı doldurmasını sağlar
                  Expanded(
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Text('Bugünkü seferin',
                        // Yazının ya da butonun görünümünü belirler
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  // Yeni RealmPill nesnesi oluşturur
                  RealmPill(
                      // Butonun ya da etiketin görünen yazısını belirler
                      label: '%${c.todayPercent} tamamlandı',
                      // Bu elemanın rengini belirler
                      color: era.secondary),
                ],
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 13),
              // Yeni OrnateProgressBar nesnesi oluşturur
              OrnateProgressBar(
                  // Gösterilecek güncel değeri atar
                  value: c.todayPercent / 100, color: era.primary),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Ekrana metin yerleştirir
              Text(
                // Aktif vazife yoksa boş durum içeriğini gösterir
                c.activeHabits.isEmpty
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? 'Önce vazifelerini belirle, sonra çentik atmaya başla.'
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : '${c.todayCompleted} / ${c.activeHabits.length} vazife tamamlandı.',
                // Yazının ya da butonun görünümünü belirler
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 20),
        // Elemanları yatay yönde sıralar
        Row(
          // İçeride sıralanacak widgetları listeler
          children: [
            // İçeriğin kalan alanı doldurmasını sağlar
            const Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child:
                    // Yeni SectionTitle nesnesi oluşturur
                    SectionTitle('Vazifelerim', icon: Icons.edit_note_rounded)),
            // Yeni OrnateButton nesnesi oluşturur
            OrnateButton(
              // Butonun ya da etiketin görünen yazısını belirler
              label: 'Yeni vazife',
              // Buton veya kartta kullanılacak simgeyi seçer
              icon: Icons.add_rounded,
              // Butona basılınca çalışacak fonksiyonu bağlar
              onPressed: () => openEditor(context),
            ),
          ],
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 10),
        // Gerekli liste ya da metin boşsa işlem yapmaz
        if (c.activeHabits.isEmpty)
          // RealmCard nesnesinin başlangıç bilgilerini alır
          const RealmCard(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text(
                  // Gösterilecek veya kullanılacak metin parçasını ekler
                  'Henüz vazifen yok. Bir alışkanlık belirleyerek ilk fermanı yaz.')),
        // Aynı nesnede ek çizim ayarını yapar
        ...c.activeHabits.map(
          // Her vazife için boşluk verilmiş liste satırı oluşturur
          (habit) => Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.only(bottom: 10),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: _HabitTile(
              // vazife alanına gelen değeri kullanır
              habit: habit,
              // Metin veya liste kontrolcüsünü ilgili alana bağlar
              controller: c,
              // on edit alanına gelen değeri kullanır
              onEdit: () => openEditor(context, habit),
            ),
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 12),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Bu elemanın rengini belirler
          color: const Color(0xFFFFF7E1),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // SectionTitle nesnesinin başlangıç bilgilerini alır
              const SectionTitle('Planlı İstirahat',
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: Icons.nightlight_round),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Ekrana metin yerleştirir
              const Text(
                  // Gösterilecek veya kullanılacak metin parçasını ekler
                  'İrade yalnızca yüklenmek değil, doğru vakitte nefes almaktır.'),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 12),
              // Yeni OrnateButton nesnesi oluşturur
              OrnateButton(
                // Butonun ya da etiketin görünen yazısını belirler
                label: c.restDates.contains(c.today)
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? 'Bugünkü istirahat mührünü kaldır'
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : 'Bugünü planlı istirahat olarak işaretle',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: c.restDates.contains(c.today)
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? Icons.sunny
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : Icons.bedtime_outlined,
                // İçeriğin açık olup olmadığını belirler
                expanded: true,
                // Butona basılınca çalışacak fonksiyonu bağlar
                onPressed: c.toggleRestDay,
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Ekrana metin yerleştirir
              const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Planlı istirahat günlerinde itibar cezası uygulanmaz.',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 16),
        // Yeni OriginalKingdomArt nesnesi oluşturur
        OriginalKingdomArt(
            // sky alanına gelen değeri kullanır
            sky: era.secondary,
            // land alanına gelen değeri kullanır
            land: era.primary,
            // highlight alanına gelen değeri kullanır
            highlight: era.accent,
            // Elemanın veya satırın yüksekliğini ayarlar
            height: 165),
      ],
    );
  }
}
// Tek bir vazifenin durumunu ve kontrol butonunu gösterir
class _HabitTile extends StatelessWidget {
  // _HabitTile nesnesinin başlangıç bilgilerini alır
  const _HabitTile({
    // vazife parametresini zorunlu tutar
    required this.habit,
    // controller parametresini zorunlu tutar
    required this.controller,
    // on edit parametresini zorunlu tutar
    required this.onEdit,
  });
  // vazife bilgisini saklar
  final Habit habit;
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // on edit bilgisini saklar
  final VoidCallback onEdit;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _HabitTile için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Rozetin veya kartın ait olduğu çağ bilgisini tutar
    final era = controller.era;
    // done bilgisini saklar
    final done = habit.completedOn(controller.today);
    // Yeni OrnateCard nesnesi oluşturup döndürür
    return OrnateCard(
      // Bu elemanın rengini belirler
      color:
          // Tamamlanan vazifeyi açık çağ rengiyle, diğerini beyaz gösterir
          done ? Color.lerp(era.secondary, Colors.white, 0.72)! : Colors.white,
      // border color alanına belirtilen renk değerini kullanır
      borderColor: done ? const Color(0xFFD4AF37) : const Color(0xFFDDD2BA),
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Row(
        // İçeride sıralanacak widgetları listeler
        children: [
          // Dokunulduğunda tepki veren Material alanı oluşturur
          InkWell(
            // Dokunulduğunda çalışacak işlemi bağlar
            onTap: () => controller.toggleHabit(habit),
            // Köşelerin yuvarlaklığını belirler
            borderRadius: BorderRadius.circular(22),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: done
                // Koşul doğruysa kullanılacak sonucu belirler
                ? const HeraldicSeal(
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.check_rounded,
                    // Simgenin veya şeklin boyutunu belirler
                    size: 42,
                    // Bu elemanın rengini belirler
                    color: Color(0xFF1C6B3F),
                    // border color alanına belirtilen renk değerini kullanır
                    borderColor: Color(0xFFFFD166),
                  )
                // Koşul yanlışsa kullanılacak sonucu belirler
                : Container(
                    // Elemanın genişliğini belirler
                    width: 42,
                    // Elemanın veya satırın yüksekliğini ayarlar
                    height: 42,
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Kutunun veya butonun geometrik biçimini belirler
                      shape: BoxShape.circle,
                      // Bu elemanın rengini belirler
                      color: const Color(0xFFFCFAF4),
                      // Kutunun kenarlık çizgisini oluşturur
                      border: Border.all(
                          // Bu elemanın rengini belirler
                          color: const Color(0xFFD5C399), width: 1.6),
                      // Kutunun gölge ayarlarını belirler
                      boxShadow: [
                        // Kutunun düşen gölgesini tanımlar
                        BoxShadow(
                          // Bu elemanın rengini belirler
                          color:
                              // Hex kodundan sabit renk oluşturur
                              const Color(0xFF4A3816).withValues(alpha: 0.08),
                          // Gölgenin ne kadar dağıtılacağını belirler
                          blurRadius: 6,
                          // Çizimin hangi yönde kaydırılacağını belirler
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Center(
                      // Bu widgetın içinde gösterilecek elemanı yerleştirir
                      child: Container(
                        // Elemanın genişliğini belirler
                        width: 15,
                        // Elemanın veya satırın yüksekliğini ayarlar
                        height: 15,
                        // Kutunun arka plan, kenar ve süslerini ayarlar
                        decoration: BoxDecoration(
                          // Kutunun veya butonun geometrik biçimini belirler
                          shape: BoxShape.circle,
                          // Kutunun kenarlık çizgisini oluşturur
                          border: Border.all(
                              // Rengin saydamlığını belirtilen oranda ayarlar
                              color: era.primary.withValues(alpha: 0.45),
                              // Elemanın genişliğini belirler
                              width: 1.6),
                        ),
                      ),
                    ),
                  ),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(width: 12),
          // İçeriğin kalan alanı doldurmasını sağlar
          Expanded(
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: InkWell(
              // Dokunulduğunda çalışacak işlemi bağlar
              onTap: () => controller.toggleHabit(habit),
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Column(
                // Ana eksene dik yöndeki hizalamayı belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // İçeride sıralanacak widgetları listeler
                children: [
                  // Elemanları yatay yönde sıralar
                  Row(
                    // İçeride sıralanacak widgetları listeler
                    children: [
                      // İçeriğin kalan alanı doldurmasını sağlar
                      Expanded(
                        // Bu widgetın içinde gösterilecek elemanı yerleştirir
                        child: Text(
                          // Vazifenin adını kartta gösterir
                          habit.name,
                          // Yazının ya da butonun görünümünü belirler
                          style: TextStyle(
                            // Yazının kalınlığını belirler
                            fontWeight: FontWeight.w900,
                            // Yazının boyutunu belirler
                            fontSize: 15.5,
                            // Kutunun arka plan, kenar ve süslerini ayarlar
                            decoration:
                                // Tamamlanan vazifenin adının üstünü çizer
                                done ? TextDecoration.lineThrough : null,
                            // Bu elemanın rengini belirler
                            color: done
                                // Koşul doğruysa kullanılacak sonucu belirler
                                ? const Color(0xFF5B6963)
                                // Koşul yanlışsa kullanılacak sonucu belirler
                                : RealmPalette.ink,
                          ),
                        ),
                      ),
                      // Belirtilen koşul sağlanırsa bu işlemi uygular
                      if (done)
                        // İçeriğin çevresine boşluk ekler
                        const Padding(
                          // İçeriğin kenarlara olan uzaklığını ayarlar
                          padding: EdgeInsets.only(left: 6),
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: Icon(Icons.verified_rounded,
                              // Simgenin veya şeklin boyutunu belirler
                              size: 16, color: Color(0xFFD4AF37)),
                        ),
                    ],
                  ),
                  // Kullanılabilir veri varsa devam eder
                  if (habit.description.isNotEmpty)
                    // İçeriğin çevresine boşluk ekler
                    Padding(
                      // İçeriğin kenarlara olan uzaklığını ayarlar
                      padding: const EdgeInsets.only(top: 3),
                      // Bu widgetın içinde gösterilecek elemanı yerleştirir
                      child: Text(
                        // Vazifenin açıklamasını kartta gösterir
                        habit.description,
                        // Yazının ya da butonun görünümünü belirler
                        style: const TextStyle(
                            // Yazının boyutunu belirler
                            fontSize: 11.5, color: Color(0xFF6B6559)),
                      ),
                    ),
                  // Belirtilen ölçülerde boşluk veya alan oluşturur
                  const SizedBox(height: 7),
                  // Sığmayan öğeleri bir sonraki satıra geçirir
                  Wrap(
                    // spacing alanına 7 değerini kullanır
                    spacing: 7,
                    // run spacing alanına 5 değerini kullanır
                    runSpacing: 5,
                    // İçeride sıralanacak widgetları listeler
                    children: [
                      // Yeni RealmPill nesnesi oluşturur
                      RealmPill(
                        // Butonun ya da etiketin görünen yazısını belirler
                        label: '+${12 + habit.difficulty * 6} XP',
                        // Buton veya kartta kullanılacak simgeyi seçer
                        icon: Icons.bolt_rounded,
                        // Bu elemanın rengini belirler
                        color: era.secondary,
                      ),
                      // Yeni RealmPill nesnesi oluşturur
                      RealmPill(
                        // Butonun ya da etiketin görünen yazısını belirler
                        label: [
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          '?',
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          'Kolay',
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          'Orta',
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          'Zorlu'
                        // Vazifenin zorluğuna uygun etiketi seçer
                        ][habit.difficulty],
                        // Buton veya kartta kullanılacak simgeyi seçer
                        icon: Icons.flag_outlined,
                        // Bu elemanın rengini belirler
                        color: const Color(0xFFFFE8C7),
                      ),
                      // Kullanılabilir veri varsa devam eder
                      if (habit.completedDates.isNotEmpty)
                        // Yeni RealmPill nesnesi oluşturur
                        RealmPill(
                          // Butonun ya da etiketin görünen yazısını belirler
                          label: '${habit.completedDates.length} Mühür',
                          // Buton veya kartta kullanılacak simgeyi seçer
                          icon: Icons.history_edu_rounded,
                          // Bu elemanın rengini belirler
                          color: const Color(0xFFE9F4EE),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Sonraki satırlardan gelecek parametreleri alır
          PopupMenuButton<String>(
            // Butonun açıklama metnini gösterir
            tooltip: 'Vazife seçenekleri',
            // İstenen indekse göre liste öğesi oluşturur
            itemBuilder: (_) => const [
              // popup menu item bileşenini oluşturur
              PopupMenuItem(value: 'edit', child: Text('Düzenle')),
              // popup menu item bileşenini oluşturur
              PopupMenuItem(value: 'archive', child: Text('Arşivle')),
            ],
            // Seçim yapıldığında çalışacak fonksiyonu bağlar
            onSelected: (value) {
              // Belirtilen koşul sağlanırsa bu işlemi uygular
              if (value == 'edit') onEdit();
              // Belirtilen koşul sağlanırsa bu işlemi uygular
              if (value == 'archive') controller.archiveHabit(habit);
            },
          ),
        ],
      ),
    );
  }
}

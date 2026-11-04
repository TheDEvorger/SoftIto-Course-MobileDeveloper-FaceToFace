// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Rozet tanımlarını projeye ekler
import '../../core/models/badge_definition.dart';
// Çağ ve rütbe modelini projeye ekler
import '../../core/models/era.dart';
// XP ve seviye hesaplama servisini projeye ekler
import '../../core/services/progression_engine.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Biyom kartını projeye ekler
import '../../core/widgets/biome_card.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Ortak krallık kartlarını projeye ekler
import '../../core/widgets/realm_card.dart';
// İlerleme geçmişini, rozetleri ve çağ haritasını gösterir
class ChronicleScreen extends StatelessWidget {
  // ChronicleScreen nesnesinin başlangıç bilgilerini alır
  const ChronicleScreen({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // ChronicleScreen için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Ekranda kullanılacak krallık controllerını kısa değişkene alır
    final c = controller;
    // next için güncel toplamı hesaplar
    final next = c.level < 24 ? ProgressionEngine.xpThreshold(c.level + 1) : 0;
    // güncel bilgisini saklar
    final current = ProgressionEngine.xpThreshold(c.level);
    // ilerleme bilgisini saklar
    final progress = c.level == 24
        // Koşul doğruysa kullanılacak sonucu belirler
        ? 1.0
        // Koşul yanlışsa kullanılacak sonucu belirler
        : ((c.xp - current) / (next - current)).clamp(0.0, 1.0).toDouble();
    // tarihler öğelerini içeren listeyi hazırlar
    final dates = List.generate(
        // Bugün dahil önceki on dört günün tarihlerini oluşturur
        14, (index) => DateTime.now().subtract(Duration(days: 13 - index)));
    // Kaydırılabilir öğe listesi oluşturur
    return ListView(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      // İçeride sıralanacak widgetları listeler
      children: [
        // Yeni FancyHeroHeader nesnesi oluşturur
        FancyHeroHeader(
          // başlık alanına gösterilecek metni belirler
          title: 'Krallık Kronikleri',
          // subtitle alanına değerini belirler
          subtitle:
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'Bugünün izini yarının tarihçisi okuyacak. 24 seviye, 24 rozet ve altı çağın destanı.',
          // Gösterilecek görselin dosya yolunu belirler
          assetPath: ArtAssets.chronicle,
          // rozet alanına gelen değeri kullanır
          badge: FramedIconBadge(
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.castle_outlined,
            // Butonun ya da etiketin görünen yazısını belirler
            label: 'Rütbe',
            // Gösterilecek güncel değeri atar
            value: c.rank,
            // Bu elemanın rengini belirler
            color: c.era.primary,
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 16),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Rengin saydamlığını belirtilen oranda ayarlar
          color: c.era.secondary.withValues(alpha: .55),
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
                  // Arka plan ve ölçüleri olan bir kutu oluşturur
                  Container(
                    // İçeriğin kenarlara olan uzaklığını ayarlar
                    padding: const EdgeInsets.all(13),
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Rengin saydamlığını belirtilen oranda ayarlar
                      color: Colors.white.withValues(alpha: .75),
                      // Kutunun veya butonun geometrik biçimini belirler
                      shape: BoxShape.circle,
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Icon(Icons.emoji_events_outlined,
                        // Simgenin veya şeklin boyutunu belirler
                        size: 34, color: c.era.primary),
                  ),
                  // Belirtilen ölçülerde boşluk veya alan oluşturur
                  const SizedBox(width: 14),
                  // İçeriğin kalan alanı doldurmasını sağlar
                  Expanded(
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Column(
                      // Ana eksene dik yöndeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // Ekrana metin yerleştirir
                        Text('Seviye ${c.level} / 24',
                            // Yazının ya da butonun görünümünü belirler
                            style: const TextStyle(
                                // Yazının kalınlığını belirler
                                fontWeight: FontWeight.w900, fontSize: 19)),
                        // Ekrana metin yerleştirir
                        Text(c.rank,
                            // Yazının ya da butonun görünümünü belirler
                            style: TextStyle(
                                // Bu elemanın rengini belirler
                                color: c.era.primary,
                                // Yazının kalınlığını belirler
                                fontWeight: FontWeight.w900)),
                        // Ekrana metin yerleştirir
                        Text('${c.era.name} Çağı',
                            // Yazının ya da butonun görünümünü belirler
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 15),
              // Yeni OrnateProgressBar nesnesi oluşturur
              OrnateProgressBar(value: progress, color: c.era.primary),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 7),
              // Ekrana metin yerleştirir
              Text('XP: ${c.xp}${c.level == 24 ? ' • Zirve!' : ' / $next'}',
                  // Yazının ya da butonun görünümünü belirler
                  style: const TextStyle(
                      // Yazının boyutunu belirler
                      fontSize: 12, fontWeight: FontWeight.w700)),
              // Belirtilen koşul sağlanırsa bu işlemi uygular
              if (c.level < c.earnedLevel)
                // İçeriğin çevresine boşluk ekler
                const Padding(
                  // İçeriğin kenarlara olan uzaklığını ayarlar
                  padding: EdgeInsets.only(top: 7),
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Text(
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    'İtibarın düştüğü için geçici mevki kaybın var. Emeğin ve XP korunuyor.',
                    // Yazının ya da butonun görünümünü belirler
                    style: TextStyle(color: Color(0xFF945A3B), fontSize: 11),
                  ),
                ),
            ],
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
                child: _Stat(
                    // Gösterilecek güncel değeri atar
                    value: '${c.totalCompletions}',
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: 'Toplam vazife',
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.check_circle_outline,
                    // Bu elemanın rengini belirler
                    color: const Color(0xFFE5F3ED))),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(width: 9),
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: _Stat(
                    // Gösterilecek güncel değeri atar
                    value: '${c.pacts.where((p) => p.isCompleted).length}',
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: 'Tam ahit',
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.history_edu_outlined,
                    // Bu elemanın rengini belirler
                    color: const Color(0xFFFFE7C6))),
            // Belirtilen ölçülerde boşluk veya alan oluşturur
            const SizedBox(width: 9),
            // İçeriğin kalan alanı doldurmasını sağlar
            Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: _Stat(
                    // Gösterilecek güncel değeri atar
                    value: '${c.reputation}',
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: 'İtibar',
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.stars_outlined,
                    // Bu elemanın rengini belirler
                    color: const Color(0xFFE6DEFD))),
          ],
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 20),
        // SectionTitle nesnesinin başlangıç bilgilerini alır
        const SectionTitle('14 günlük iz haritası', icon: Icons.map_outlined),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 11),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Sığmayan öğeleri bir sonraki satıra geçirir
              Wrap(
                // spacing alanına 7 değerini kullanır
                spacing: 7,
                // run spacing alanına 8 değerini kullanır
                runSpacing: 8,
                // İçeride sıralanacak widgetları listeler
                children: dates.map((d) {
                  // key bilgisini saklar
                  final key = ProgressionEngine.dayKey(d);
                  // completed bilgisini saklar
                  final completed =
                      // Verilen günde tamamlanan vazifeleri sayar
                      c.habits.where((habit) => habit.completedOn(key)).length;
                  // color bilgisini saklar
                  final color = completed == 0
                      // Koşul doğruysa kullanılacak sonucu belirler
                      ? const Color(0xFFE5E4D9)
                      // Koşul yanlışsa kullanılacak sonucu belirler
                      : Color.lerp(c.era.secondary, c.era.primary,
                          // Değeri izin verilen aralığa sabitler
                          (completed / 4).clamp(.1, 1).toDouble())!;
                  // Basılı tutunca açıklama gösterir
                  return Tooltip(
                    // Kullanıcıya gösterilecek mesajı belirler
                    message: '$key • $completed tamamlanan',
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Container(
                      // Elemanın genişliğini belirler
                      width: 32,
                      // Elemanın veya satırın yüksekliğini ayarlar
                      height: 37,
                      // İçeriğin hangi tarafa hizalanacağını belirler
                      alignment: Alignment.center,
                      // Kutunun arka plan, kenar ve süslerini ayarlar
                      decoration: BoxDecoration(
                          // Bu elemanın rengini belirler
                          color: color, borderRadius: BorderRadius.circular(9)),
                      // Bu widgetın içinde gösterilecek elemanı yerleştirir
                      child: Text(
                        // Gösterilecek veya kullanılacak metin parçasını ekler
                        '${d.day}',
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(
                          // Bu elemanın rengini belirler
                          color: completed >= 3
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? Colors.white
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : const Color(0xFF3E4843),
                          // Yazının kalınlığını belirler
                          fontWeight: FontWeight.w800,
                          // Yazının boyutunu belirler
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                // Dönüştürülen öğeleri yeni liste hâline getirir
                }).toList(),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 11),
              // Ekrana metin yerleştirir
              const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Her kutu bir günü, renk yoğunluğu tamamlanan vazife sayısını gösterir.',
                // Yazının ya da butonun görünümünü belirler
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 20),
        // Yeni SectionTitle nesnesi oluşturur
        SectionTitle('24 Şan Rozeti',
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.workspace_premium_outlined,
            // Satırın son tarafına gösterilecek elemanı yerleştirir
            trailing: RealmPill(label: '${c.badgeCount} / 24 açıldı')),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 10),
        // grid view.builder bileşenini oluşturur
        GridView.builder(
          // Listenin kendi içeriği kadar yer kaplamasını sağlar
          shrinkWrap: true,
          // Kaydırmanın hareket davranışını ayarlar
          physics: const NeverScrollableScrollPhysics(),
          // grid delegate alanına gelen değeri kullanır
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // cross axis sayı alanına 3 değerini kullanır
            crossAxisCount: 3,
            // main axis spacing alanına 8 değerini kullanır
            mainAxisSpacing: 8,
            // cross axis spacing alanına 8 değerini kullanır
            crossAxisSpacing: 8,
            // child aspect ratio alanına gelen değeri kullanır
            childAspectRatio: .95,
          ),
          // Listede oluşturulacak öğe sayısını belirler
          itemCount: badges.length,
          // İstenen indekse göre liste öğesi oluşturur
          itemBuilder: (context, index) {
            // rozet öğelerini içeren listeyi hazırlar
            final badge = badges[index];
            // unlocked koşulunun doğru olup olmadığını bulur
            final unlocked = c.badgeIds.contains(badge.id);
            // Rozetin veya kartın ait olduğu çağ bilgisini tutar
            final era = eras[badge.era];
            // Dokunulduğunda tepki veren Material alanı oluşturur
            return InkWell(
              // Köşelerin yuvarlaklığını belirler
              borderRadius: BorderRadius.circular(16),
              // Dokunulduğunda çalışacak işlemi bağlar
              onTap: () => showDialog<void>(
                // İşlemin çalıştığı widget bağlamını gönderir
                context: context,
                // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
                builder: (ctx) => AlertDialog(
                  // başlık alanına gelen değeri kullanır
                  title: Text(
                      // Gösterilecek veya kullanılacak metin parçasını ekler
                      '${badge.id.toString().padLeft(2, '0')} • ${badge.name}'),
                  // Mesajın veya pencerenin içeriğini belirler
                  content: Text(
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    '${badge.description}\n\n${unlocked ? 'Rozeti kazandın!' : badge.future ? 'Bu rozet sonraki sürümde açılacak.' : 'Henüz kazanılmadı.'}',
                  ),
                  // actions alanına gelen değeri kullanır
                  actions: [
                    // Yalnızca metinle çalışan buton oluşturur
                    TextButton(
                        // Butona basılınca çalışacak fonksiyonu bağlar
                        onPressed: () => Navigator.pop(ctx),
                        // Bu widgetın içinde gösterilecek elemanı yerleştirir
                        child: const Text('Kapat'))
                  ],
                ),
              ),
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Container(
                // İçeriğin kenarlara olan uzaklığını ayarlar
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                // Kutunun arka plan, kenar ve süslerini ayarlar
                decoration: BoxDecoration(
                  // Bu elemanın rengini belirler
                  color: unlocked ? era.secondary : const Color(0xFFEEEDE6),
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(16),
                  // Kutunun kenarlık çizgisini oluşturur
                  border: Border.all(
                      // Bu elemanın rengini belirler
                      color: unlocked ? era.accent : const Color(0xFFDCDAD1)),
                ),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Column(
                  // Ana yöndeki hizalamayı belirler
                  mainAxisAlignment: MainAxisAlignment.center,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Ekrana bir simge yerleştirir
                    Icon(badge.icon,
                        // Bu elemanın rengini belirler
                        color: unlocked ? era.primary : const Color(0xFF9A9990),
                        // Simgenin veya şeklin boyutunu belirler
                        size: 28),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 6),
                    // Ekrana metin yerleştirir
                    Text(
                      // Rozetin adını ekranda gösterir
                      badge.name,
                      // text align alanına gelen değeri kullanır
                      textAlign: TextAlign.center,
                      // Metnin veya giriş alanının en fazla satır sayısını belirler
                      maxLines: 2,
                      // Yazının ya da butonun görünümünü belirler
                      style: TextStyle(
                        // Yazının kalınlığını belirler
                        fontWeight: FontWeight.w800,
                        // Bu elemanın rengini belirler
                        color: unlocked
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? const Color(0xFF272F2C)
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : const Color(0xFF7D8077),
                        // Yazının boyutunu belirler
                        fontSize: 10,
                      ),
                    ),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 3),
                    // Ekrana metin yerleştirir
                    Text(
                      // Rozetin açık olup olmadığını gösterir
                      unlocked
                          // Koşul doğruysa kullanılacak sonucu belirler
                          ? 'KAZANILDI'
                          // Koşul yanlışsa kullanılacak sonucu belirler
                          : badge.future
                              // Koşul doğruysa kullanılacak sonucu belirler
                              ? 'YAKINDA'
                              // Koşul yanlışsa kullanılacak sonucu belirler
                              : 'KİLİTLİ',
                      // Yazının ya da butonun görünümünü belirler
                      style: const TextStyle(fontSize: 8, letterSpacing: .5),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 19),
        // SectionTitle nesnesinin başlangıç bilgilerini alır
        const SectionTitle('Altı Çağ & Krallık Biyomları',
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.terrain_outlined),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 10),
        // Aynı nesnede ek çizim ayarını yapar
        ...eras.asMap().entries.map((entry) {
          // indeks bilgisini saklar
          final index = entry.key;
          // Rozetin veya kartın ait olduğu çağ bilgisini tutar
          final era = entry.value;
          // İçeriğin çevresine boşluk ekler
          return Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.only(bottom: 12),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: BiomeCard(
              // Aktif sekme veya öğenin sıra numarasını belirler
              index: index,
              // İlgili çağın sıra numarasını belirler
              era: era,
              // user seviye alanına gelen değeri kullanır
              userLevel: c.level,
            ),
          );
        }),
      ],
    );
  }
}
// Tek bir sayı ve açıklamayı istatistik olarak gösterir
class _Stat extends StatelessWidget {
  // _Stat nesnesinin başlangıç bilgilerini alır
  const _Stat(
      // Bu koleksiyonun içine yeni öğeler yerleştirir
      {required this.value,
      // label parametresini zorunlu tutar
      required this.label,
      // icon parametresini zorunlu tutar
      required this.icon,
      // color parametresini zorunlu tutar
      required this.color});
  // value bilgisini saklar
  final String value;
  // label bilgisini saklar
  final String label;
  // Gösterilecek simgeyi tutar
  final IconData icon;
  // color bilgisini saklar
  final Color color;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _Stat için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Yeni MiniStatCard nesnesi oluşturup döndürür
    return MiniStatCard(label: label, value: value, icon: icon, color: color);
  }
}

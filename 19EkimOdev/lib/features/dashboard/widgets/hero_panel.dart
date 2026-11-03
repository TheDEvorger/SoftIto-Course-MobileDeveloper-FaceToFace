// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app tema dosyasını projeye ekler
import '../../../core/theme/app_theme.dart';
// formatters dosyasını projeye ekler
import '../../../core/utils/formatters.dart';
// collection ziyaret dosyasını projeye ekler
import '../../../data/models/collection_visit.dart';
// demo hasta dosyasını projeye ekler
import '../../../data/models/demo_patient.dart';
// HeroPanel sınıfını tanımlar
class HeroPanel extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const HeroPanel({
    // Üst sınıfın ilgili işlemini çağırır
    super.key,
    // today bilgisini zorunlu tutar
    required this.today,
    // sonraki ziyaret bilgisini zorunlu tutar
    required this.nextVisit,
    // sonraki hasta bilgisini zorunlu tutar
    required this.nextPatient,
    // waiting sayı bilgisini zorunlu tutar
    required this.waitingCount,
    // call sonraki işlemi bilgisini zorunlu tutar
    required this.onCallNext,
    // yeni hasta işlemi bilgisini zorunlu tutar
    required this.onNewPatient,
  });
  // today bilgisini tutar
  final DateTime today;
  // sonraki ziyaret bilgisini tutar
  final CollectionVisit? nextVisit;
  // sonraki hasta bilgisini tutar
  final DemoPatient? nextPatient;
  // waiting sayı bilgisini tutar
  final int waitingCount;
  // call sonraki işlemi bilgisini tutar
  final VoidCallback onCallNext;
  // yeni hasta işlemi bilgisini tutar
  final VoidCallback onNewPatient;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // renk paleti değerini tanımlar
    final VenaPalette palette = context.palette;
    // hero işlemi değerini tanımlar
    const Color onHero = Colors.white;
    // container değerini hesaplar veya döndürür
    return Container(
      // Görünüm ayarlarını oluşturur
      decoration: BoxDecoration(
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(24),
        // gradient bilgisini belirler
        gradient: LinearGradient(
          // begin bilgisini belirler
          begin: Alignment.topLeft,
          // end bilgisini belirler
          end: Alignment.bottomRight,
          // colors bilgisini belirler
          colors: <Color>[palette.heroStart, palette.heroEnd],
        ),
      ),
      // İçeride gösterilecek widgetı belirler
      child: Stack(
        // Alt widgetları listeler
        children: <Widget>[
          // Positioned nesnesini oluşturur veya kullanır
          Positioned(
            // right bilgisini belirler
            right: -40,
            // top bilgisini belirler
            top: -50,
            // İçeride gösterilecek widgetı belirler
            child: _Glow(size: 180, opacity: 0.10),
          ),
          // Positioned nesnesini oluşturur veya kullanır
          Positioned(
            // right bilgisini belirler
            right: 60,
            // bottom bilgisini belirler
            bottom: -70,
            // İçeride gösterilecek widgetı belirler
            child: _Glow(size: 140, opacity: 0.07),
          ),
          // İçeriğin çevresine boşluk bırakır
          Padding(
            // İç boşlukları belirler
            padding: const EdgeInsets.all(20),
            // İçeride gösterilecek widgetı belirler
            child: Column(
              // Elemanların çapraz hizasını belirler
              crossAxisAlignment: CrossAxisAlignment.start,
              // Alt widgetları listeler
              children: <Widget>[
                // Elemanları yan yana dizer
                Row(
                  // Alt widgetları listeler
                  children: <Widget>[
                    // Constructor, yeni nesnenin bilgilerini alır
                    const Icon(Icons.water_drop_rounded, color: onHero, size: 18),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const SizedBox(width: 6),
                    // Kalan alanı doldurmasını sağlar
                    Expanded(
                      // İçeride gösterilecek widgetı belirler
                      child: Text(
                        // Değeri ekranda gösterilecek biçime çevirir
                        Formatters.longDate(today),
                        // style bilgisini belirler
                        style: theme.textTheme.labelLarge?.copyWith(
                            // Rengini belirler
                            color: onHero.withValues(alpha: 0.85)),
                        // Uzun metnin taşmasını önler
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Constructor, yeni nesnenin bilgilerini alır
                    const _DemoPill(),
                  ],
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 14),
                // Semantics nesnesini oluşturur veya kullanır
                Semantics(
                  // header bilgisini belirler
                  header: true,
                  // İçeride gösterilecek widgetı belirler
                  child: Text(
                    // Bu metin değerini kullanır
                    'Kan Alma Birimi',
                    // style bilgisini belirler
                    style: theme.textTheme.headlineMedium
                        // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                        ?.copyWith(color: onHero),
                  ),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 4),
                // Metin gösterir
                Text(
                  // waiting sayı bilgisini günceller
                  waitingCount == 0
                      // Koşul doğruysa bu değeri kullanır
                      ? 'Şu an sırada bekleyen hasta yok.'
                      // Koşul yanlışsa bu değeri kullanır
                      : 'Sırada $waitingCount hasta bekliyor.',
                  // style bilgisini belirler
                  style: theme.textTheme.bodyMedium
                      // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                      ?.copyWith(color: onHero.withValues(alpha: 0.85)),
                ),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 16),
                // sonraki up tile fonksiyonunu çağırır
                _NextUpTile(visit: nextVisit, patient: nextPatient),
                // Constructor, yeni nesnenin bilgilerini alır
                const SizedBox(height: 16),
                // Elemanları yan yana dizer, sığmayınca alt satıra geçirir
                Wrap(
                  // Elemanların arasındaki boşluğu belirler
                  spacing: 10,
                  // Satırlar arasındaki boşluğu belirler
                  runSpacing: 10,
                  // Alt widgetları listeler
                  children: <Widget>[
                    // İlgili işlem butonunu oluşturur
                    FilledButton.icon(
                      // Widgetın kimlik bilgisini belirler
                      key: const Key('dashboard_call_next'),
                      // style bilgisini belirler
                      style: FilledButton.styleFrom(
                        // Arka plan rengini belirler
                        backgroundColor: onHero,
                        // Yazı ve simge rengini belirler
                        foregroundColor: palette.heroEnd,
                        // disabled background renk bilgisini belirler
                        disabledBackgroundColor:
                            // İlgili nesne üzerinden metodu çağırır
                            onHero.withValues(alpha: 0.25),
                        // disabled foreground renk bilgisini belirler
                        disabledForegroundColor:
                            // İlgili nesne üzerinden metodu çağırır
                            onHero.withValues(alpha: 0.7),
                      ),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: nextVisit == null ? null : onCallNext,
                      // Gösterilecek simgeyi belirler
                      icon: const Icon(Icons.campaign_rounded),
                      // Gösterilecek etiketi belirler
                      label: const Text('Sıradakini Çağır'),
                    ),
                    // İlgili işlem butonunu oluşturur
                    OutlinedButton.icon(
                      // style bilgisini belirler
                      style: OutlinedButton.styleFrom(
                        // Yazı ve simge rengini belirler
                        foregroundColor: onHero,
                        // side bilgisini belirler
                        side: BorderSide(color: onHero.withValues(alpha: 0.5)),
                      ),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: onNewPatient,
                      // Gösterilecek simgeyi belirler
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      // Gösterilecek etiketi belirler
                      label: const Text('Yeni Hasta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// _NextUpTile arayüz elemanını oluşturan sınıf
class _NextUpTile extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _NextUpTile({required this.visit, required this.patient});
  // ziyaret bilgisini tutar
  final CollectionVisit? visit;
  // hasta bilgisini tutar
  final DemoPatient? patient;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // hero işlemi değerini tanımlar
    const Color onHero = Colors.white;
    // v değerini tanımlar
    final CollectionVisit? v = visit;
    // animated switcher değerini hesaplar veya döndürür
    return AnimatedSwitcher(
      // İşlemin süresini belirler
      duration: const Duration(milliseconds: 300),
      // İçeride gösterilecek widgetı belirler
      child: Container(
        // Widgetın kimlik bilgisini belirler
        key: ValueKey<String?>(v?.id),
        // İç boşlukları belirler
        padding: const EdgeInsets.all(12),
        // Görünüm ayarlarını oluşturur
        decoration: BoxDecoration(
          // Rengini belirler
          color: onHero.withValues(alpha: 0.12),
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(14),
          // Kenarlık ayarlarını belirler
          border: Border.all(color: onHero.withValues(alpha: 0.18)),
        ),
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Alt widgetları listeler
          children: <Widget>[
            // Görünüm ve yerleşim için kutu oluşturur
            Container(
              // İç boşlukları belirler
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              // Görünüm ayarlarını oluşturur
              decoration: BoxDecoration(
                // Rengini belirler
                color: onHero.withValues(alpha: 0.18),
                // Köşeleri yuvarlar
                borderRadius: BorderRadius.circular(10),
              ),
              // İçeride gösterilecek widgetı belirler
              child: Text(
                // v bilgisini günceller
                v == null ? '—' : Formatters.queueNumber(v.queueNumber),
                // style bilgisini belirler
                style: theme.textTheme.titleMedium?.copyWith(
                  // Rengini belirler
                  color: onHero,
                  // Yazı kalınlığını belirler
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 12),
            // Kalan alanı doldurmasını sağlar
            Expanded(
              // İçeride gösterilecek widgetı belirler
              child: Column(
                // Elemanların çapraz hizasını belirler
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alt widgetları listeler
                children: <Widget>[
                  // Metin gösterir
                  Text(
                    // Bu metin değerini kullanır
                    'SIRADAKİ',
                    // style bilgisini belirler
                    style: theme.textTheme.labelSmall?.copyWith(
                      // Rengini belirler
                      color: onHero.withValues(alpha: 0.7),
                      // Harfler arasındaki boşluğu ayarlar
                      letterSpacing: 1.2,
                    ),
                  ),
                  // Metin gösterir
                  Text(
                    // v bilgisini günceller
                    v == null
                        // Koşul doğruysa bu değeri kullanır
                        ? 'Bekleyen hasta yok'
                        // Koşul yanlışsa bu değeri kullanır
                        : '${Formatters.shortName(patient?.displayName ?? '-')}'
                            // Bu metin değerini kullanır
                            ' · ${patient?.department ?? '-'}',
                    // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                    style: theme.textTheme.titleSmall?.copyWith(color: onHero),
                    // Giriş alanının satır sayısını belirler
                    maxLines: 1,
                    // Uzun metnin taşmasını önler
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// _DemoPill sınıfını tanımlar
class _DemoPill extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _DemoPill();
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // container değerini hesaplar veya döndürür
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // Görünüm ayarlarını oluşturur
      decoration: BoxDecoration(
        // Rengini belirler
        color: Colors.white.withValues(alpha: 0.16),
        // Köşeleri yuvarlar
        borderRadius: BorderRadius.circular(20),
      ),
      // İçeride gösterilecek widgetı belirler
      child: Text(
        // Bu metin değerini kullanır
        'Eğitim Demosu',
        // style değerini aktif temadan alır
        style: Theme.of(context)
            // Aktif temanın yazı stillerini alır
            .textTheme
            // Tema içindeki etiket stilini seçer
            .labelSmall
            // Mevcut nesnenin güncellenmiş kopyasını oluşturur
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}
// _Glow sınıfını tanımlar
class _Glow extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const _Glow({required this.size, required this.opacity});
  // boyut bilgisini tutar
  final double size;
  // saydamlık bilgisini tutar
  final double opacity;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // container değerini hesaplar veya döndürür
    return Container(
      // Genişliğini belirler
      width: size,
      // Yüksekliğini belirler
      height: size,
      // Görünüm ayarlarını oluşturur
      decoration: BoxDecoration(
        // Widgetın şeklini belirler
        shape: BoxShape.circle,
        // Rengini belirler
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// collection durum dosyasını projeye ekler
import '../../data/models/collection_status.dart';
// demo numune dosyasını projeye ekler
import '../../data/models/demo_specimen.dart';
// app tema dosyasını projeye ekler
import '../theme/app_theme.dart';
// StatusColors sabitlerini tutar, nesne oluşturulamaz
abstract final class StatusColors {
  // for ziyaret değerini hesaplar veya döndürür
  static Color forVisit(BuildContext context, CollectionStatus status) {
    // Aktif temadan renk şeması bilgisini alır
    final ColorScheme scheme = Theme.of(context).colorScheme;
    // renk paleti değerini tanımlar
    final VenaPalette palette = context.palette;
    // switch değerini hesaplar veya döndürür
    return switch (status) {
      // collection durum bilgisini günceller
      CollectionStatus.waiting => palette.secondaryText,
      // collection durum bilgisini günceller
      CollectionStatus.called => palette.amber,
      // collection durum bilgisini günceller
      CollectionStatus.inProgress => scheme.primary,
      // collection durum bilgisini günceller
      CollectionStatus.sampleCollected => palette.primaryDark,
      // collection durum bilgisini günceller
      CollectionStatus.delivered => palette.success,
      // collection durum bilgisini günceller
      CollectionStatus.cancelled => palette.coral,
    };
  }
  // for numune değerini hesaplar veya döndürür
  static Color forSpecimen(BuildContext context, SpecimenStatus status) {
    // renk paleti değerini tanımlar
    final VenaPalette palette = context.palette;
    // switch değerini hesaplar veya döndürür
    return switch (status) {
      // numune durum bilgisini günceller
      SpecimenStatus.awaitingDelivery => palette.amber,
      // numune durum bilgisini günceller
      SpecimenStatus.delivered => palette.success,
      // numune durum bilgisini günceller
      SpecimenStatus.cancelled => palette.coral,
    };
  }
  // readable değerini hesaplar veya döndürür
  static Color readable(BuildContext context, Color color) {
    // Aktif temadan tema bilgisini alır
    final ThemeData theme = Theme.of(context);
    // Koşul sağlanırsa ilgili işlemi yapar
    if (theme.brightness == Brightness.dark) return color;
    // Hesaplanan sonucu döndürür
    return Color.lerp(color, theme.colorScheme.onSurface, 0.35)!;
  }
}
// StatusChip arayüz elemanını oluşturan sınıf
class StatusChip extends StatelessWidget {
  // Constructor, yeni nesnenin bilgilerini alır
  const StatusChip.visit(CollectionStatus this.visitStatus, {super.key})
      // Koşul yanlışsa bu değeri kullanır
      : specimenStatus = null;
  // Constructor, yeni nesnenin bilgilerini alır
  const StatusChip.specimen(SpecimenStatus this.specimenStatus, {super.key})
      // Koşul yanlışsa bu değeri kullanır
      : visitStatus = null;
  // ziyaret durum bilgisini tutar
  final CollectionStatus? visitStatus;
  // numune durum bilgisini tutar
  final SpecimenStatus? specimenStatus;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // ziyaret değerini tanımlar
    final CollectionStatus? visit = visitStatus;
    // numune değerini tanımlar
    final SpecimenStatus? specimen = specimenStatus;
    // renk değerini tanımlar
    final Color color = visit != null
        // Koşul doğruysa bu değeri kullanır
        ? StatusColors.forVisit(context, visit)
        // Koşul yanlışsa bu değeri kullanır
        : StatusColors.forSpecimen(context, specimen!);
    // etiket değerini tanımlar
    final String label = visit?.label ?? specimen!.label;
    // simge değerini tanımlar
    final IconData icon = visit?.icon ?? specimen!.icon;
    // fg değerini tanımlar
    final Color fg = StatusColors.readable(context, color);
    // semantics değerini hesaplar veya döndürür
    return Semantics(
      // Gösterilecek etiketi belirler
      label: 'Durum: $label',
      // exclude semantics bilgisini belirler
      excludeSemantics: true,
      // İçeride gösterilecek widgetı belirler
      child: Container(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        // Görünüm ayarlarını oluşturur
        decoration: BoxDecoration(
          // Rengini belirler
          color: color.withValues(alpha: 0.14),
          // Köşeleri yuvarlar
          borderRadius: BorderRadius.circular(20),
          // Kenarlık ayarlarını belirler
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        // İçeride gösterilecek widgetı belirler
        child: Row(
          // Kaplayacağı ana eksen alanını belirler
          mainAxisSize: MainAxisSize.min,
          // Alt widgetları listeler
          children: <Widget>[
            // Simge gösterir
            Icon(icon, size: 16, color: fg),
            // Constructor, yeni nesnenin bilgilerini alır
            const SizedBox(width: 6),
            // Metin gösterir
            Text(
              // Metodun veya constructorın parametresini tanımlar
              label,
              // style değerini aktif temadan alır
              style: Theme.of(context)
                  // Aktif temanın yazı stillerini alır
                  .textTheme
                  // Tema içindeki etiket stilini seçer
                  .labelMedium
                  // Mevcut nesnenin güncellenmiş kopyasını oluşturur
                  ?.copyWith(color: fg, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

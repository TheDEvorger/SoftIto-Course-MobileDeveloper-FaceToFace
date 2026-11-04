// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// kiralama action işlemini asenkron yürütür
Future<void> rentalAction(
    // İlgili işlemin kod bloğunu başlatır
    BuildContext context, Future<void> Function() action) async {
  // Hata oluşabilecek işlemleri dener
  try {
    // Asenkron işlemin tamamlanmasını bekler
    await action();
  // İşlem hata verirse çalışır
  } catch (error) {
    // Widget hâlâ ekrandaysa işlemi sürdürür
    if (context.mounted) {
      // Ekranda kısa bilgi mesajı gösterir
      ScaffoldMessenger.of(context)
          // Önceki ifade üzerinde ek işlem uygular
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
// kiralama tarihler işlemini asenkron yürütür
Future<DateTimeRange?> rentalDates(BuildContext context,
    // Veri alanlarını tanımlar
    {DateTimeRange? initial}) async {
  // now değerini belirler
  final now = DateUtils.dateOnly(DateTime.now());
  // Hesaplanan sonucu geri döndürür
  return showDateRangePicker(
      // context bilgisini belirler
      context: context,
      // Seçilebilecek ilk tarihi belirler
      firstDate: now,
      // Seçilebilecek son tarihi belirler
      lastDate: DateTime(now.year + 1, now.month, now.day),
      // Başlangıç tarih aralığını belirler
      initialDateRange:
          // İfadeye karşılaştırma koşulu ekler
          initial != null && !initial.start.isBefore(now) ? initial : null,
      // help metin bilgisini belirler
      helpText: 'Alış ve dönüş tarihlerini seçin',
      // kaydetme metin bilgisini belirler
      saveText: 'Tarihleri seç');
}

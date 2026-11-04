// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// app copy dosyasını kullanıma ekler
import '../../core/content/app_copy.dart';
// seed notice bölümünü oluşturan StatelessWidget sınıfı
class SeedNotice extends StatelessWidget {
  // seed notice nesnesini oluşturur
  const SeedNotice({super.key});
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => Padding(
        // İç boşlukları belirler
        padding: const EdgeInsets.symmetric(vertical: 8),
        // İçine yerleştirilecek widgetı belirler
        child: Text(
          // İlgili değeri veya görünüm ayarını belirler
          AppCopy.demoNotice,
          // Görünüm stilini belirler
          style: Theme.of(context).textTheme.labelMedium,
          // Yazıyı hizalar
          textAlign: TextAlign.center,
        ),
      );
}

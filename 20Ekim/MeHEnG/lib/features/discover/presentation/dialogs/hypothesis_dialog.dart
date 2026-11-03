// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Doğrulama ViewModel sınıfını ekler
import '../discover_view_model.dart';
// Hipotez ekleme penceresi
class HypothesisDialog extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const HypothesisDialog({required this.ventureId, super.key});
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<HypothesisDialog> createState() => _HypothesisDialogState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _HypothesisDialogState extends ConsumerState<HypothesisDialog> {
  // Form girişini kontrol eden controller oluşturur
  final text = TextEditingController();
  // Hata mesajını tutar, başlangıçta null olur
  String? error;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Text.dispose işlemini çağırır
    text.dispose();
    // Üst sınıfın temizleme metodunu çalıştırır
    super.dispose();
  }
  // Save metodunu tanımlar
  void save() {
    // Hata oluşabilecek işlemleri dener
    try {
      // Riverpod referansı üzerinden işleme devam eder
      ref
          // Providerdan güncel değeri okur
          .read(discoverViewModelProvider)
          // Yeni hipotez oluşturma metodunu çağırır
          .addHypothesis(widget.ventureId, text.text);
      // Açık sayfayı veya pencereyi kapatır
      Navigator.pop(context);
    // İşlem hata verirse çalışır
    } catch (e) {
      // Değişikliği bildirerek ekranı günceller
      setState(() => error = '$e');
    }
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => AlertDialog(
    // Başlık bilgisini belirler
    title: const Text('Test edilebilir hipotez'),
    // Pencere içeriğini belirler
    content: SizedBox(
      // Genişliği belirler
      width: 430,
      // İçerideki widgetı belirler
      child: Column(
        // Ana eksende kaplanan alanı belirler
        mainAxisSize: MainAxisSize.min,
        // İçeride gösterilecek elemanları listeler
        children: [
          // Metin giriş alanı oluşturur
          TextField(
            // Giriş alanını yöneten controllerı bağlar
            controller: text,
            // Açılınca otomatik odaklanmayı ayarlar
            autofocus: true,
            // Giriş alanındaki satır sayısını belirler
            maxLines: 3,
            // En fazla kaç karakter yazılacağını belirler
            maxLength: 600,
            // Görünüm ayarlarını belirler
            decoration: const InputDecoration(
              // Giriş alanındaki ipucunu gösterir
              hintText: 'Örn: Çiftçiler aylık 200 TL ödemeye hazır.',
            ),
          ),
          // Değerin boş olup olmadığını kontrol eder
          if (error != null)
            // Metni ekranda gösterir
            Text(error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    ),
    // Buton ve işlemleri listeler
    actions: [
      // Yazılı buton oluşturur
      TextButton(
        // Basılınca pencereyi kapatır
        onPressed: () => Navigator.pop(context),
        // İçerideki widgetı belirler
        child: const Text('Vazgeç'),
      ),
      // Dolu buton oluşturur
      FilledButton(onPressed: save, child: const Text('Kaydet')),
    ],
  );
}

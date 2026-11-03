// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Doğrulama ViewModel sınıfını ekler
import '../discover_view_model.dart';
// Deney ekleme penceresi
class ExperimentDialog extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const ExperimentDialog({required this.hypothesisId, super.key});
  // Hipotezin ID bilgisini tutar
  final String hypothesisId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<ExperimentDialog> createState() => _ExperimentDialogState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _ExperimentDialogState extends ConsumerState<ExperimentDialog> {
  // Form girişini kontrol eden controller oluşturur
  final title = TextEditingController();
  // Form girişini kontrol eden controller oluşturur
  final method = TextEditingController();
  // Hata mesajını tutar, başlangıçta null olur
  String? error;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Title.dispose işlemini çağırır
    title.dispose();
    // Method.dispose işlemini çağırır
    method.dispose();
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
          // Yeni deney oluşturma metodunu çağırır
          .addExperiment(widget.hypothesisId, title.text, method.text);
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
    title: const Text('Yeni deney'),
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
            controller: title,
            // Açılınca otomatik odaklanmayı ayarlar
            autofocus: true,
            // En fazla kaç karakter yazılacağını belirler
            maxLength: 140,
            // Görünüm ayarlarını belirler
            decoration: const InputDecoration(labelText: 'Deney başlığı'),
          ),
          // Constructor gerekli bilgileri alır
          const SizedBox(height: 10),
          // Metin giriş alanı oluşturur
          TextField(
            // Giriş alanını yöneten controllerı bağlar
            controller: method,
            // En fazla kaç karakter yazılacağını belirler
            maxLength: 500,
            // Giriş alanındaki satır sayısını belirler
            maxLines: 2,
            // Görünüm ayarlarını belirler
            decoration: const InputDecoration(labelText: 'Uygulanacak yöntem'),
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

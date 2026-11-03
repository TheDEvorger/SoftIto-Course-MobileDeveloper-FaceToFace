// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Girişim modelini ekler
import '../domain/venture.dart';
// Girişim providerlarını ekler
import 'venture_providers.dart';
// Girişim düzenleme penceresi
class EditVentureDialog extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const EditVentureDialog({required this.venture, super.key});
  // Venture bilgisini tutar
  final Venture venture;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<EditVentureDialog> createState() => _EditVentureDialogState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _EditVentureDialogState extends ConsumerState<EditVentureDialog> {
  // Formun durumunu kontrol eden anahtar oluşturur
  final formKey = GlobalKey<FormState>();
  // Form girişini kontrol eden controller oluşturur
  late final TextEditingController name;
  // Form girişini kontrol eden controller oluşturur
  late final TextEditingController problem;
  // Form girişini kontrol eden controller oluşturur
  late final TextEditingController audience;
  // Hata mesajını tutar, başlangıçta null olur
  String? error;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widget ilk açıldığında çalışır
  void initState() {
    // Üst sınıfın başlatma metodunu çalıştırır
    super.initState();
    // Girişim adını günceller
    name = TextEditingController(text: widget.venture.name);
    // Çözülecek problemi günceller
    problem = TextEditingController(text: widget.venture.problem);
    // Hedef kitleyi günceller
    audience = TextEditingController(text: widget.venture.audience);
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Name.dispose işlemini çağırır
    name.dispose();
    // Problem.dispose işlemini çağırır
    problem.dispose();
    // Audience.dispose işlemini çağırır
    audience.dispose();
    // Üst sınıfın temizleme metodunu çalıştırır
    super.dispose();
  }
  // Save metodunu tanımlar
  void save() {
    // Koşul doğruysa ilgili işlemi yapar
    if (!formKey.currentState!.validate()) return;
    // Hata oluşabilecek işlemleri dener
    try {
      // Riverpod referansı üzerinden işleme devam eder
      ref
          // Providerdan güncel değeri okur
          .read(ventureViewModelProvider)
          // Mevcut kaydı günceller
          .update(
            // ID bilgisini gönderir
            id: widget.venture.id,
            // İsim bilgisini belirler
            name: name.text,
            // Problem bilgisini gönderir
            problem: problem.text,
            // Hedef kitleyi gönderir
            audience: audience.text,
          );
      // Açık sayfayı veya pencereyi kapatır
      Navigator.of(context).pop();
    // İşlem hata verirse çalışır
    } catch (e) {
      // Değişikliği bildirerek ekranı günceller
      setState(() => error = 'Güncelleme başarısız: $e');
    }
  }
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) => AlertDialog(
    // Başlık bilgisini belirler
    title: const Text('Girişimi düzenle'),
    // Pencere içeriğini belirler
    content: SizedBox(
      // Genişliği belirler
      width: 420,
      // İçerideki widgetı belirler
      child: SingleChildScrollView(
        // İçerideki widgetı belirler
        child: Form(
          // Widget için benzersiz anahtar verir
          key: formKey,
          // İçerideki widgetı belirler
          child: Column(
            // Ana eksende kaplanan alanı belirler
            mainAxisSize: MainAxisSize.min,
            // İçeride gösterilecek elemanları listeler
            children: [
              // Form giriş alanı oluşturur
              TextFormField(
                // Giriş alanını yöneten controllerı bağlar
                controller: name,
                // Açılınca otomatik odaklanmayı ayarlar
                autofocus: true,
                // Görünüm ayarlarını belirler
                decoration: const InputDecoration(labelText: 'Girişimin adı'),
                // En fazla kaç karakter yazılacağını belirler
                maxLength: 80,
                // Girilen veriyi kontrol eder
                validator: Venture.validateName,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 8),
              // Form giriş alanı oluşturur
              TextFormField(
                // Giriş alanını yöneten controllerı bağlar
                controller: problem,
                // Görünüm ayarlarını belirler
                decoration: const InputDecoration(labelText: 'Çözdüğü problem'),
                // Giriş alanındaki satır sayısını belirler
                maxLines: 2,
                // En fazla kaç karakter yazılacağını belirler
                maxLength: 500,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 8),
              // Form giriş alanı oluşturur
              TextFormField(
                // Giriş alanını yöneten controllerı bağlar
                controller: audience,
                // Görünüm ayarlarını belirler
                decoration: const InputDecoration(labelText: 'Hedef kitle'),
                // En fazla kaç karakter yazılacağını belirler
                maxLength: 200,
              ),
              // Değerin boş olup olmadığını kontrol eder
              if (error != null)
                // Metni ekranda gösterir
                Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
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

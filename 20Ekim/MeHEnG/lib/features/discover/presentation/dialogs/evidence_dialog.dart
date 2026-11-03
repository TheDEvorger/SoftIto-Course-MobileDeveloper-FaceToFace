// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Kanıt modelini ekler
import '../../domain/evidence.dart';
// Doğrulama ViewModel sınıfını ekler
import '../discover_view_model.dart';
// Kanıt ekleme penceresi
class EvidenceDialog extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const EvidenceDialog({required this.experimentId, super.key});
  // Deneyin ID bilgisini tutar
  final String experimentId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<EvidenceDialog> createState() => _EvidenceDialogState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _EvidenceDialogState extends ConsumerState<EvidenceDialog> {
  // Form girişini kontrol eden controller oluşturur
  final note = TextEditingController();
  // Form girişini kontrol eden controller oluşturur
  final source = TextEditingController();
  // Kanıtın başlangıç yönünü belirler
  EvidenceDirection direction = EvidenceDirection.neutral;
  // Doğru yanlış değerini tanımlar
  bool hasConsent = true;
  // Hata mesajını tutar, başlangıçta null olur
  String? error;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Note.dispose işlemini çağırır
    note.dispose();
    // Source.dispose işlemini çağırır
    source.dispose();
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
          // Yeni kanıt oluşturma metodunu çağırır
          .addEvidence(
            // İlgili değeri veya işlemi tanımlar
            widget.experimentId,
            // İlgili değeri veya işlemi tanımlar
            note.text,
            // İlgili değeri veya işlemi tanımlar
            direction,
            // Kanıtın kaynağını gönderir
            source: source.text,
            // İzin bilgisini gönderir
            hasConsent: hasConsent,
          );
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
    title: const Text('Gözlem / kanıt ekle'),
    // Pencere içeriğini belirler
    content: SizedBox(
      // Genişliği belirler
      width: 440,
      // İçerideki widgetı belirler
      child: SingleChildScrollView(
        // İçerideki widgetı belirler
        child: Column(
          // Ana eksende kaplanan alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçeride gösterilecek elemanları listeler
          children: [
            // Metin giriş alanı oluşturur
            TextField(
              // Giriş alanını yöneten controllerı bağlar
              controller: note,
              // Açılınca otomatik odaklanmayı ayarlar
              autofocus: true,
              // Giriş alanındaki satır sayısını belirler
              maxLines: 3,
              // En fazla kaç karakter yazılacağını belirler
              maxLength: 1000,
              // Görünüm ayarlarını belirler
              decoration: const InputDecoration(
                // Label text özelliğini belirler
                labelText: 'Gerçekte ne gözlemledin?',
              ),
            ),
            // Constructor gerekli bilgileri alır
            const SizedBox(height: 10),
            // Seçenek açılır listesi oluşturur
            DropdownButtonFormField<EvidenceDirection>(
              // Başlangıç değerini belirler
              initialValue: direction,
              // Görünüm ayarlarını belirler
              decoration: const InputDecoration(labelText: 'İlişki'),
              // Items özelliğini belirler
              items: const [
                // Açılır listeye seçenek ekler
                DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: EvidenceDirection.supports,
                  // İçerideki widgetı belirler
                  child: Text('Hipotezi destekliyor'),
                ),
                // Açılır listeye seçenek ekler
                DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: EvidenceDirection.contradicts,
                  // İçerideki widgetı belirler
                  child: Text('Hipotezle çelişiyor'),
                ),
                // Açılır listeye seçenek ekler
                DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: EvidenceDirection.neutral,
                  // İçerideki widgetı belirler
                  child: Text('Henüz belirsiz / nötr'),
                ),
              ],
              // Değer değişince çalışacak işlemi belirler
              onChanged: (value) {
                // Değerin boş olup olmadığını kontrol eder
                if (value != null) setState(() => direction = value);
              },
            ),
            // Constructor gerekli bilgileri alır
            const SizedBox(height: 10),
            // Metin giriş alanı oluşturur
            TextField(
              // Giriş alanını yöneten controllerı bağlar
              controller: source,
              // Görünüm ayarlarını belirler
              decoration: const InputDecoration(
                // Label text özelliğini belirler
                labelText: 'Kaynak / kanıt kökeni (opsiyonel)',
                // Giriş alanındaki ipucunu gösterir
                hintText: 'Örn: Mülakat #3, Analytics, Anket formu',
              ),
            ),
            // Constructor gerekli bilgileri alır
            const SizedBox(height: 12),
            // İşaretlenebilir liste satırı oluşturur
            CheckboxListTile(
              // Content padding özelliğini belirler
              contentPadding: EdgeInsets.zero,
              // Dense özelliğini belirler
              dense: true,
              // Kullanılacak değeri belirler
              value: hasConsent,
              // Değişince ekranı günceller
              onChanged: (val) => setState(() => hasConsent = val ?? false),
              // Başlık bilgisini belirler
              title: const Text(
                // Gösterilecek metni belirler
                'Veri sahibi rızası alındı',
                // Görünüm stilini belirler
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              // Alt açıklamayı belirler
              subtitle: const Text(
                // Gösterilecek metni belirler
                'Gözlem etik ilkelere ve gizlilik kurallarına uygundur.',
              ),
            ),
            // Değerin boş olup olmadığını kontrol eder
            if (error != null)
              // Metni ekranda gösterir
              Text(error!, style: const TextStyle(color: Colors.red)),
          ],
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
      FilledButton(onPressed: save, child: const Text('Kanıtı kaydet')),
    ],
  );
}

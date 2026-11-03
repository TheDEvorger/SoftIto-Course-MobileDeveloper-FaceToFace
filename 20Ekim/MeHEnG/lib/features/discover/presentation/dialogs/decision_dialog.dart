// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// Riverpod state yönetimini ekler
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Karar modelini ekler
import '../../domain/decision.dart';
// Kanıt modelini ekler
import '../../domain/evidence.dart';
// Doğrulama providerlarını ekler
import '../discover_providers.dart';
// Doğrulama ViewModel sınıfını ekler
import '../discover_view_model.dart';
// Karar ekleme penceresi
class DecisionDialog extends ConsumerStatefulWidget {
  // Constructor gerekli bilgileri alır
  const DecisionDialog({required this.ventureId, super.key});
  // Girişimin ID bilgisini tutar
  final String ventureId;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // State sınıfını oluşturur
  ConsumerState<DecisionDialog> createState() => _DecisionDialogState();
}
// Ekranın değişen durumlarını yöneten State sınıfı
class _DecisionDialogState extends ConsumerState<DecisionDialog> {
  // Form girişini kontrol eden controller oluşturur
  final rationaleController = TextEditingController();
  // Başlangıç karar sonucunu belirler
  DecisionOutcome outcome = DecisionOutcome.continueRun;
  // Selected evidence ids bilgisini oluşturur
  final Set<String> selectedEvidenceIds = {};
  // Hata mesajını tutar, başlangıçta null olur
  String? error;
  // Üst sınıftaki metodu yeniden yazar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Rationale controller.dispose işlemini çağırır
    rationaleController.dispose();
    // Üst sınıfın temizleme metodunu çalıştırır
    super.dispose();
  }
  // Girilen bilgileri kaydeder
  void _save() {
    // Hata oluşabilecek işlemleri dener
    try {
      // Riverpod üzerinden ilgili işlemi çalıştırır
      ref.read(discoverViewModelProvider).addDecision(
            // Girişim ID bilgisini gönderir
            ventureId: widget.ventureId,
            // Karar sonucunu gönderir
            outcome: outcome,
            // Karar gerekçesini gönderir
            rationale: rationaleController.text,
            // Kanıt IDlerini gönderir
            evidenceIds: selectedEvidenceIds.toList(),
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
  Widget build(BuildContext context) {
    // Girişime ait hipotezleri dinler
    final hypotheses = ref.watch(hypothesesProvider(widget.ventureId));
    // İlgili tüm kanıtlar için boş liste oluşturur
    final allEvidence = <Evidence>[];
    // Listedeki elemanları sırayla dolaşır
    for (final h in hypotheses) {
      // Hipoteze ait deneyleri dinler
      final experiments = ref.watch(experimentsProvider(h.id));
      // Listedeki elemanları sırayla dolaşır
      for (final exp in experiments) {
        // All evidence.add all işlemini çağırır
        allEvidence.addAll(ref.watch(evidenceProvider(exp.id)));
      }
    }
    // Açılır pencere oluşturur
    return AlertDialog(
      // Başlık bilgisini belirler
      title: const Text('Stratejik Karar Kaydet'),
      // Pencere içeriğini belirler
      content: SizedBox(
        // Genişliği belirler
        width: 500,
        // İçerideki widgetı belirler
        child: SingleChildScrollView(
          // İçerideki widgetı belirler
          child: Column(
            // Ana eksende kaplanan alanı belirler
            mainAxisSize: MainAxisSize.min,
            // Çapraz eksen hizasını belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride gösterilecek elemanları listeler
            children: [
              // Seçenek açılır listesi oluşturur
              DropdownButtonFormField<DecisionOutcome>(
                // Başlangıç değerini belirler
                initialValue: outcome,
                // Görünüm ayarlarını belirler
                decoration: const InputDecoration(labelText: 'Karar Yönü'),
                // Items özelliğini belirler
                items: DecisionOutcome.values
                    // Elemanları yeni nesnelere dönüştürür
                    .map(
                      // İlgili fonksiyonun parametrelerini belirler
                      (o) => DropdownMenuItem(
                        // Kullanılacak değeri belirler
                        value: o,
                        // İçerideki widgetı belirler
                        child: Text(o.label),
                      ),
                    )
                    // Sonuçları listeye dönüştürür
                    .toList(),
                // Değer değişince çalışacak işlemi belirler
                onChanged: (val) {
                  // Değerin boş olup olmadığını kontrol eder
                  if (val != null) setState(() => outcome = val);
                },
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 12),
              // Metin giriş alanı oluşturur
              TextField(
                // Giriş alanını yöneten controllerı bağlar
                controller: rationaleController,
                // Açılınca otomatik odaklanmayı ayarlar
                autofocus: true,
                // Giriş alanındaki satır sayısını belirler
                maxLines: 3,
                // En fazla kaç karakter yazılacağını belirler
                maxLength: 1000,
                // Görünüm ayarlarını belirler
                decoration: const InputDecoration(
                  // Label text özelliğini belirler
                  labelText: 'Karar gerekçesi',
                  // Giriş alanındaki ipucunu gösterir
                  hintText: 'Neden bu sonuca vardınız? Hangi kanıtlar belirleyici oldu?',
                ),
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 12),
              // Metni ekranda gösterir
              Text(
                // Gösterilecek metni belirler
                'Dayanak Kanıtlar (${selectedEvidenceIds.length} seçildi):',
                // Görünüm stilini belirler
                style: Theme.of(context).textTheme.titleSmall,
              ),
              // Constructor gerekli bilgileri alır
              const SizedBox(height: 4),
              // Liste veya metin boşsa çalışır
              if (allEvidence.isEmpty)
                // Constructor gerekli bilgileri alır
                const Padding(
                  // İç boşlukları ayarlar
                  padding: EdgeInsets.symmetric(vertical: 8),
                  // İçerideki widgetı belirler
                  child: Text(
                    // Gösterilecek metni belirler
                    'Henüz kayıtlı kanıt bulunmuyor. Kararı genel gerekçeyle kaydedebilirsiniz.',
                    // Görünüm stilini belirler
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                )
              // Önceki koşul gerçekleşmezse çalışır
              else
                // Alanı boyut sınırlarıyla oluşturur
                ConstrainedBox(
                  // Boyut sınırlarını belirler
                  constraints: const BoxConstraints(maxHeight: 180),
                  // İçerideki widgetı belirler
                  child: ListView.builder(
                    // Listeyi içeriğinin boyutuyla sınırlar
                    shrinkWrap: true,
                    // Listedeki eleman sayısını belirler
                    itemCount: allEvidence.length,
                    // Her liste elemanının nasıl oluşturulacağını belirler
                    itemBuilder: (context, index) {
                      // Ev bilgisini oluşturur
                      final ev = allEvidence[index];
                      // Is selected bilgisini oluşturur
                      final isSelected = selectedEvidenceIds.contains(ev.id);
                      // Icon bilgisini oluşturur
                      final icon = switch (ev.direction) {
                        // Destekleyen kanıt seçeneğini belirler
                        EvidenceDirection.supports => Icons.check_circle_outline,
                        // Çelişen kanıt seçeneğini belirler
                        EvidenceDirection.contradicts => Icons.highlight_off,
                        // Tarafsız kanıt seçeneğini belirler
                        EvidenceDirection.neutral => Icons.help_outline,
                      };
                      // Color bilgisini oluşturur
                      final color = switch (ev.direction) {
                        // Destekleyen kanıt seçeneğini belirler
                        EvidenceDirection.supports => Colors.green,
                        // Çelişen kanıt seçeneğini belirler
                        EvidenceDirection.contradicts => Colors.redAccent,
                        // Tarafsız kanıt seçeneğini belirler
                        EvidenceDirection.neutral => Colors.grey,
                      };
                      // İşaretlenebilir liste satırı oluşturur
                      return CheckboxListTile(
                        // Dense özelliğini belirler
                        dense: true,
                        // Kullanılacak değeri belirler
                        value: isSelected,
                        // İkincil tema rengini belirler
                        secondary: Icon(icon, color: color, size: 20),
                        // Başlık bilgisini belirler
                        title: Text(
                          // Kanıt açıklamasını ilgili işleme aktarır
                          ev.note,
                          // Giriş alanındaki satır sayısını belirler
                          maxLines: 1,
                          // Overflow özelliğini belirler
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Alt açıklamayı belirler
                        subtitle: Text(
                          // İlgili değeri veya işlemi tanımlar
                          ev.source ?? 'Kaynak belirtilmedi',
                          // Görünüm stilini belirler
                          style: const TextStyle(fontSize: 11),
                        ),
                        // Değer değişince çalışacak işlemi belirler
                        onChanged: (checked) {
                          // Değişikliği bildirerek ekranı günceller
                          setState(() {
                            // Değerler eşitse çalışır
                            if (checked == true) {
                              // Selected evidence ids.add işlemini çağırır
                              selectedEvidenceIds.add(ev.id);
                            // Önceki koşul gerçekleşmezse çalışır
                            } else {
                              // Selected evidence ids.remove işlemini çağırır
                              selectedEvidenceIds.remove(ev.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              // Değerin boş olup olmadığını kontrol eder
              if (error != null)
                // İçerik çevresine boşluk bırakır
                Padding(
                  // İç boşlukları ayarlar
                  padding: const EdgeInsets.only(top: 8),
                  // İçerideki widgetı belirler
                  child: Text(error!, style: const TextStyle(color: Colors.red)),
                ),
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
        FilledButton(
          // Basılınca formu kaydeder
          onPressed: _save,
          // İçerideki widgetı belirler
          child: const Text('Kararı kaydet'),
        ),
      ],
    );
  }
}

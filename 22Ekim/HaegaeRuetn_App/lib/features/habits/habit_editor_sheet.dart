// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Vazife modelini projeye ekler
import '../../core/models/habit.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Vazife ekleme ve düzenleme alanını oluşturur
class HabitEditorSheet extends StatefulWidget {
  // HabitEditorSheet nesnesinin başlangıç bilgilerini alır
  const HabitEditorSheet({super.key, required this.controller, this.habit});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // vazife bilgisini saklar
  final Habit? habit;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<HabitEditorSheet> createState() => _HabitEditorSheetState();
}
// vazife editor sheet state bilgilerini ve ilgili davranışları tanımlar
class _HabitEditorSheetState extends State<HabitEditorSheet> {
  // Başlık metnini tutar
  late final TextEditingController title;
  // Açıklama metnini tutar
  late final TextEditingController description;
  // Vazifenin zorluk seviyesini tutar
  late int difficulty;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // init state için gerekli sonucu hesaplar
  void initState() {
    // Üst sınıfın başlangıç işlemlerini çalıştırır
    super.initState();
    // başlık bilgisini yeni değeriyle günceller
    title = TextEditingController(text: widget.habit?.name ?? '');
    // description bilgisini yeni değeriyle günceller
    description = TextEditingController(text: widget.habit?.description ?? '');
    // difficulty bilgisini yeni değeriyle günceller
    difficulty = widget.habit?.difficulty ?? 1;
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Artık kullanılmayan controller kaynaklarını temizler
    title.dispose();
    // Artık kullanılmayan controller kaynaklarını temizler
    description.dispose();
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _HabitEditorSheetState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) => Padding(
        // İçeriğin kenarlara olan uzaklığını ayarlar
        padding:
            // edge insets.only bileşenini oluşturur
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: SafeArea(
            // top alanına özelliği kapatır
            top: false,
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: SingleChildScrollView(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Padding(
              // İçeriğin kenarlara olan uzaklığını ayarlar
              padding: const EdgeInsets.all(22),
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Column(
                  // Ana eksene dik yöndeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // Ana yönde kaplanacak alanı belirler
                  mainAxisSize: MainAxisSize.min,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Ekrana metin yerleştirir
                    Text(
                        // widget.habit bilgisini yeni değerle günceller
                        widget.habit == null
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? 'Yeni vazife yaz'
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : 'Vazifeyi düzenle',
                        // Yazının ya da butonun görünümünü belirler
                        style: Theme.of(context).textTheme.headlineSmall),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 16),
                    // Kullanıcının yazı girebileceği alanı oluşturur
                    TextField(
                        // Metin veya liste kontrolcüsünü ilgili alana bağlar
                        controller: title,
                        // Yazılabilecek en fazla karakter sayısını belirler
                        maxLength: 70,
                        // autofocus alanına özelliği açık yapar
                        autofocus: true,
                        // Kutunun arka plan, kenar ve süslerini ayarlar
                        decoration: const InputDecoration(
                            // Form alanının başlığını gösterir
                            labelText: 'Vazifenin adı',
                            // Alan boşken kullanıcıya örnek giriş metnini gösterir
                            hintText: 'Örn. 20 dakika çalış')),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 8),
                    // Kullanıcının yazı girebileceği alanı oluşturur
                    TextField(
                        // Metin veya liste kontrolcüsünü ilgili alana bağlar
                        controller: description,
                        // Yazılabilecek en fazla karakter sayısını belirler
                        maxLength: 120,
                        // Kutunun arka plan, kenar ve süslerini ayarlar
                        decoration: const InputDecoration(
                            // Form alanının başlığını gösterir
                            labelText: 'Kısa açıklama (isteğe bağlı)')),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 12),
                    // Ekrana metin yerleştirir
                    const Text('Zorluk derecesi',
                        // Yazının ya da butonun görünümünü belirler
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    // Sonraki satırlardan gelecek parametreleri alır
                    SegmentedButton<int>(
                      // segments alanına gelen değeri kullanır
                      segments: const [
                        // button segment bileşenini oluşturur
                        ButtonSegment(value: 1, label: Text('Kolay')),
                        // button segment bileşenini oluşturur
                        ButtonSegment(value: 2, label: Text('Orta')),
                        // button segment bileşenini oluşturur
                        ButtonSegment(value: 3, label: Text('Zorlu'))
                      ],
                      // Öğenin aktif seçili durumda olup olmadığını belirler
                      selected: {difficulty},
                      // on selection changed alanına gelen değeri kullanır
                      onSelectionChanged: (s) =>
                          // Değişen bilgiyi ekrana yansıtmak için Statei günceller
                          setState(() => difficulty = s.first),
                    ),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 20),
                    // filled button.icon bileşenini oluşturur
                    FilledButton.icon(
                        // Butona basılınca çalışacak fonksiyonu bağlar
                        onPressed: () {
                          // Gerekli liste ya da metin boşsa işlem yapmaz
                          if (title.text.trim().isEmpty) return;
                          // Gerekli veri yoksa alternatif işlem yolunu kullanır
                          if (widget.habit == null) {
                            // Yeni öğeyi ilgili listeye veya kümeye ekler
                            widget.controller.addHabit(
                                // Formdaki ad, açıklama ve zorluk bilgisini kaydetmeye gönderir
                                title.text, description.text, difficulty);
                          // Önceki koşul sağlanmazsa bu yolu kullanır
                          } else {
                            // Seçili vazifeyi form bilgileriyle günceller
                            widget.controller.editHabit(widget.habit!,
                                // Formdaki ad, açıklama ve zorluk bilgisini kaydetmeye gönderir
                                title.text, description.text, difficulty);
                          }
                          // navigator.pop bileşenini oluşturur
                          Navigator.pop(context);
                        },
                        // Buton veya kartta kullanılacak simgeyi seçer
                        icon: const Icon(Icons.verified_outlined),
                        // Butonun ya da etiketin görünen yazısını belirler
                        label: const Text('Mühürle ve kaydet')),
                  ]),
            ))),
      );
}

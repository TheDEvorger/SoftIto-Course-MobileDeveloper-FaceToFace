// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// müfredat dosyasını kullanıma ekler
import '../../../domain/models/curriculum.dart';
// daily görev dosyasını kullanıma ekler
import '../../../domain/models/daily_task.dart';
// curriculum repository dosyasını kullanıma ekler
import '../../../domain/repositories/curriculum_repository.dart';
// garden buttons dosyasını kullanıma ekler
import '../../../shared/widgets/garden_buttons.dart';
// görev entry pencere için değişen verileri yöneten StatefulWidget kullanılır
class TaskEntryDialog extends StatefulWidget {
  // görev entry pencere penceresini oluşturur
  const TaskEntryDialog({
    // existing görev bilgisini isteğe bağlı alır
    this.existingTask,
    // başlangıç tarihi bilgisini isteğe bağlı alır
    this.initialDate,
    // curriculum repository bilgisini isteğe bağlı alır
    this.curriculumRepository,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // existing görev bilgisini tutar
  final DailyTask? existingTask;
  // başlangıç tarihi bilgisini tutar
  final DateTime? initialDate;
  // curriculum repository bilgisini tutar
  final CurriculumRepository? curriculumRepository;
  // show işlemini yapar
  static Future<DailyTask?> show(
    // İlgili değeri veya görünüm ayarını belirler
    BuildContext context, {
    // İlgili değeri veya görünüm ayarını belirler
    DailyTask? existingTask,
    // İlgili değeri veya görünüm ayarını belirler
    DateTime? initialDate,
    // İlgili değeri veya görünüm ayarını belirler
    CurriculumRepository? curriculumRepository,
  }) {
    // Kullanıcıya açılır pencere gösterir
    return showDialog<DailyTask>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (_) => TaskEntryDialog(
        // existing görev bilgisini belirler
        existingTask: existingTask,
        // Başlangıç tarihini belirler
        initialDate: initialDate,
        // curriculum repository bilgisini belirler
        curriculumRepository: curriculumRepository,
      ),
    );
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<TaskEntryDialog> createState() => _TaskEntryDialogState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _TaskEntryDialogState extends State<TaskEntryDialog> {
  // desc controller bilgisini tutar
  late TextEditingController _descController;
  // questions controller bilgisini tutar
  late TextEditingController _questionsController;
  // seçilen tarih bilgisini tutar
  late DateTime _selectedDate;
  // seçilen ders id bilgisini tutar
  String? _selectedSubjectId;
  // dersler için boş koleksiyon oluşturur
  List<Subject> _subjects = [];
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // görev bilgisini hesaplayıp saklar
    final task = widget.existingTask;
    // Koşula göre iki değerden birini seçer
    _descController = TextEditingController(text: task?.description ?? '');
    // questions controller değerini günceller
    _questionsController = TextEditingController(
      // Gösterilecek metni belirler
      text: task != null && task.targetQuestions > 0
          // Koşul doğruysa bu değeri kullanır
          ? task.targetQuestions.toString()
          // Koşul yanlışsa bu değeri kullanır
          : '30',
    );
    // Güncel tarih ve saati alır
    _selectedDate = task?.scheduledDate ?? widget.initialDate ?? DateTime.now();
    // seçilen ders id değerini günceller
    _selectedSubjectId = task?.subjectId;
    // subjects bilgisini yükler
    _loadSubjects();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    _descController.dispose();
    // Kullanılan kaynakları temizler
    _questionsController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // subjects bilgisini yükler
  Future<void> _loadSubjects() async {
    // İlgili değer null değilse kontrol eder
    if (widget.curriculumRepository != null) {
      // tyt verisini asenkron işlemin sonucundan alır
      final tyt = await widget.curriculumRepository!.getSubjects('TYT');
      // ayt verisini asenkron işlemin sonucundan alır
      final ayt = await widget.curriculumRepository!.getSubjects('AYT');
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Değişen verileri arayüze bildirir
        setState(() {
          // dersler değerini günceller
          _subjects = [...tyt, ...ayt];
        });
      }
    }
  }
  // pick tarih işlemini yapar
  Future<void> _pickDate() async {
    // picked verisini asenkron işlemin sonucundan alır
    final picked = await showDatePicker(
      // context bilgisini belirler
      context: context,
      // Başlangıç tarihini belirler
      initialDate: _selectedDate,
      // Seçilebilecek ilk tarihi belirler
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      // Seçilebilecek son tarihi belirler
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    // Widget artık açık değilse işlemi durdurur
    if (picked != null && mounted) {
      // Değişen verileri arayüze bildirir
      setState(() => _selectedDate = picked);
    }
  }
  // save bilgisini işler
  void _onSave() {
    // desc bilgisini hesaplayıp saklar
    final desc = _descController.text.trim();
    // Liste veya metin boşsa bu koşul çalışır
    if (desc.isEmpty) {
      // Ekranda kısa bilgilendirme mesajı gösterir
      ScaffoldMessenger.of(context).showSnackBar(
        // Kısa bildirim mesajı oluşturur
        const SnackBar(content: Text('Lütfen bir görev açıklaması yazın.')),
      );
      // Metodu burada bitirir
      return;
    }
    // questions bilgisini hesaplayıp saklar
    final questions = int.tryParse(_questionsController.text.trim()) ?? 0;
    // ID bilgisini hesaplayıp saklar
    final id = widget.existingTask?.id ??
        // Güncel tarih ve saati alır
        'task_${DateTime.now().millisecondsSinceEpoch}';
    // görev bilgisini hesaplayıp saklar
    final task = DailyTask(
      // ID bilgisini belirler
      id: id,
      // scheduled tarih bilgisini belirler
      scheduledDate: _selectedDate,
      // açıklama bilgisini belirler
      description: desc,
      // Ders ID bilgisini belirler
      subjectId: _selectedSubjectId,
      // Hedef soru sayısını belirler
      targetQuestions: questions,
      // tamamlanma bilgisi bilgisini belirler
      isDone: widget.existingTask?.isDone ?? false,
    );
    // navigator.of nesnesini oluşturur
    Navigator.of(context).pop(task);
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // is edit bilgisini iki değeri karşılaştırarak hesaplar
    final isEdit = widget.existingTask != null;
    // tarih formatted değerini tanımlar
    final dateFormatted =
        // "${_selectedDate.day.toString().padLeft(2, '…" metnini kullanır
        '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}';
    // Açılır pencere oluşturur
    return Dialog(
      // Widgetın kenar şeklini belirler
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // İçine yerleştirilecek widgetı belirler
      child: Container(
        // İç boşlukları belirler
        padding: const EdgeInsets.all(22),
        // constraints bilgisini belirler
        constraints: const BoxConstraints(maxWidth: 420),
        // İçine yerleştirilecek widgetı belirler
        child: SingleChildScrollView(
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // Ana eksende kaplanacak alanı belirler
            mainAxisSize: MainAxisSize.min,
            // Çapraz eksendeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // İçerideki widgetları listeler
            children: [
              // Elemanları yan yana dizer
              Row(
                // İçerideki widgetları listeler
                children: [
                  // Görsel bir kutu oluşturur
                  Container(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(8),
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Rengi belirler
                      color: GardenPalette.mossEmerald.withAlpha(25),
                      // Widgetın kenar şeklini belirler
                      shape: BoxShape.circle,
                    ),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Icon(
                      // Gösterilecek simgeyi belirler
                      Icons.edit_calendar,
                      // Rengi belirler
                      color: GardenPalette.mossEmerald,
                      // Boyutu belirler
                      size: 22,
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 12),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Column(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçerideki widgetları listeler
                      children: [
                        // Metni ekranda gösterir
                        Text(
                          // Koşula göre iki değerden birini seçer
                          isEdit ? 'Görevi Düzenle' : 'Yeni Günlük Hedef',
                          // Görünüm stilini belirler
                          style: const TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 18,
                            // Yazı kalınlığını belirler
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Metni ekranda gösterir
                        Text(
                          // "Adım adım hedefine yaklaş" metnini kullanır
                          'Adım adım hedefine yaklaş',
                          // Görünüm stilini belirler
                          style: TextStyle(
                            // Yazı boyutunu belirler
                            fontSize: 12,
                            // Rengi belirler
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 18),
              // Description
              // Metin giriş alanı oluşturur
              TextField(
                // Veriyi yöneten controllerı bağlar
                controller: _descController,
                // Açılışta otomatik odaklanmayı belirler
                autofocus: !isEdit,
                // Kutu ve kenarlık görünümünü belirler
                decoration: InputDecoration(
                  // Giriş alanının etiketini belirler
                  labelText: 'Görev Açıklaması',
                  // Giriş alanında ipucu gösterir
                  hintText: 'Örn: Paragraf soru bankası 2 test',
                  // Kenarlığı belirler
                  border: OutlineInputBorder(
                    // Köşelerin yuvarlaklığını belirler
                    borderRadius: BorderRadius.circular(14),
                  ),
                  // filled bilgisini belirler
                  filled: true,
                  // İç dolgu rengini belirler
                  fillColor: isDark
                      // Koşul doğruysa bu değeri kullanır
                      ? GardenPalette.nightCard
                      // Koşul yanlışsa bu değeri kullanır
                      : GardenPalette.gardenPaper.withAlpha(50),
                ),
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 14),
              // Target Questions & Date Row
              // Elemanları yan yana dizer
              Row(
                // İçerideki widgetları listeler
                children: [
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // flex bilgisini belirler
                    flex: 4,
                    // İçine yerleştirilecek widgetı belirler
                    child: TextField(
                      // Veriyi yöneten controllerı bağlar
                      controller: _questionsController,
                      // Klavye tipini belirler
                      keyboardType: TextInputType.number,
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: InputDecoration(
                        // Giriş alanının etiketini belirler
                        labelText: 'Soru Hedefi',
                        // Giriş alanında ipucu gösterir
                        hintText: '30',
                        // suffix metin bilgisini belirler
                        suffixText: 'Soru',
                        // Kenarlığı belirler
                        border: OutlineInputBorder(
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(14),
                        ),
                        // filled bilgisini belirler
                        filled: true,
                        // İç dolgu rengini belirler
                        fillColor: isDark
                            // Koşul doğruysa bu değeri kullanır
                            ? GardenPalette.nightCard
                            // Koşul yanlışsa bu değeri kullanır
                            : GardenPalette.gardenPaper.withAlpha(50),
                      ),
                    ),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 12),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // flex bilgisini belirler
                    flex: 5,
                    // İçine yerleştirilecek widgetı belirler
                    child: OutlinedButton.icon(
                      // Görünüm stilini belirler
                      style: OutlinedButton.styleFrom(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(
                            // horizontal bilgisini belirler
                            horizontal: 10, vertical: 15),
                        // Widgetın kenar şeklini belirler
                        shape: RoundedRectangleBorder(
                          // Köşelerin yuvarlaklığını belirler
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: _pickDate,
                      // simge bilgisini belirler
                      icon: const Icon(Icons.calendar_today, size: 16),
                      // Buton veya alan yazısını belirler
                      label: Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        dateFormatted,
                        // Görünüm stilini belirler
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              // Sabit boyutlu veya boşluk bırakan alan oluşturur
              const SizedBox(height: 14),
              // Subject Dropdown (if subjects loaded)
              // Liste veya metin doluysa bu koşul çalışır
              if (_subjects.isNotEmpty) ...[
                // Form için açılır seçim menüsü oluşturur
                DropdownButtonFormField<String>(
                  // Başlangıç değerini belirler
                  initialValue: _selectedSubjectId,
                  // Kutu ve kenarlık görünümünü belirler
                  decoration: InputDecoration(
                    // Giriş alanının etiketini belirler
                    labelText: 'İlgili Ders (İsteğe Bağlı)',
                    // Kenarlığı belirler
                    border: OutlineInputBorder(
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(14),
                    ),
                    // filled bilgisini belirler
                    filled: true,
                    // İç dolgu rengini belirler
                    fillColor: isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? GardenPalette.nightCard
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.gardenPaper.withAlpha(50),
                  ),
                  // Listelenecek öğeleri belirler
                  items: [
                    // Seçim menüsüne öğe ekler
                    const DropdownMenuItem(
                      // Kullanılacak değeri belirler
                      value: null,
                      // İçine yerleştirilecek widgetı belirler
                      child: Text('Genel Çalışma'),
                    ),
                    // Öğeleri tek tek dönüştürür
                    ..._subjects.map(
                      // Yeni değer veya liste oluşturur
                      (s) => DropdownMenuItem(
                        // Kullanılacak değeri belirler
                        value: s.id,
                        // İçine yerleştirilecek widgetı belirler
                        child: Text('${s.stage} - ${s.name}'),
                      ),
                    ),
                  ],
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: (val) {
                    // Değişen verileri arayüze bildirir
                    setState(() => _selectedSubjectId = val);
                  },
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 20),
              // İlgili değeri veya görünüm ayarını belirler
              ] else
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 10),
              // Buttons
              // Elemanları yan yana dizer
              Row(
                // Ana eksendeki hizalamayı belirler
                mainAxisAlignment: MainAxisAlignment.end,
                // İçerideki widgetları listeler
                children: [
                  // Metin butonu oluşturur
                  TextButton(
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: () => Navigator.of(context).pop(),
                    // İçine yerleştirilecek widgetı belirler
                    child: const Text('Vazgeç'),
                  ),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 8),
                  // garden primary button nesnesini oluşturur
                  GardenPrimaryButton(
                    // Buton veya alan yazısını belirler
                    label: isEdit ? 'Güncelle' : 'Görevi Ekle',
                    // simge bilgisini belirler
                    icon: Icons.check,
                    // Genişliği belirler
                    width: 140,
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: _onSave,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

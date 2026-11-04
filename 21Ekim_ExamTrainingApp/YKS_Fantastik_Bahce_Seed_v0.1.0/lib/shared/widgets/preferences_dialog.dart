// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../core/theme/garden_palette.dart';
// student preferences dosyasını kullanıma ekler
import '../../domain/models/student_preferences.dart';
// preferences repository dosyasını kullanıma ekler
import '../../domain/repositories/preferences_repository.dart';
// garden buttons dosyasını kullanıma ekler
import 'garden_buttons.dart';
// preferences pencere için değişen verileri yöneten StatefulWidget kullanılır
class PreferencesDialog extends StatefulWidget {
  // preferences pencere penceresini oluşturur
  const PreferencesDialog({
    // repository bilgisini zorunlu tutar
    required this.repository,
    // initial preferences bilgisini isteğe bağlı alır
    this.initialPreferences,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // repository bilgisini tutar
  final PreferencesRepository repository;
  // initial preferences bilgisini tutar
  final StudentPreferences? initialPreferences;
  // show işlemini yapar
  static Future<StudentPreferences?> show(
    // İlgili değeri veya görünüm ayarını belirler
    BuildContext context, {
    // repository bilgisini zorunlu tutar
    required PreferencesRepository repository,
    // İlgili değeri veya görünüm ayarını belirler
    StudentPreferences? initialPreferences,
  }) {
    // Değerleri karşılaştırır
    return showModalBottomSheet<StudentPreferences>(
      // context bilgisini belirler
      context: context,
      // is scroll controlled bilgisini belirler
      isScrollControlled: true,
      // Arka plan rengini belirler
      backgroundColor: Colors.transparent,
      // Gelen verilerle arayüzü oluşturur
      builder: (_) => PreferencesDialog(
        // repository bilgisini belirler
        repository: repository,
        // initial preferences bilgisini belirler
        initialPreferences: initialPreferences,
      ),
    );
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<PreferencesDialog> createState() => _PreferencesDialogState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _PreferencesDialogState extends State<PreferencesDialog> {
  // adı controller bilgisini tutar
  late TextEditingController _nameController;
  // net controller bilgisini tutar
  late TextEditingController _netController;
  // seçilen field bilgisini tutar
  late String _selectedField;
  // seçilen tarih bilgisini tutar
  DateTime? _selectedDate;
  // yükleme durumu durumunu başlangıçta belirler
  bool _isLoading = false;
  // fields değerini sabit olarak belirler
  final _fields = const ['Sayısal', 'Eşit Ağırlık', 'Sözel', 'Dil'];
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // tercihler bilgisini hesaplayıp saklar
    final prefs = widget.initialPreferences;
    // Koşula göre iki değerden birini seçer
    _nameController = TextEditingController(text: prefs?.displayName ?? '');
    // net controller değerini günceller
    _netController = TextEditingController(
        // Gösterilecek metni belirler
        text: prefs?.targetNet != null ? prefs!.targetNet.toString() : '');
    // Değer null ise varsayılanı kullanır
    _selectedField = prefs?.field ?? 'Sayısal';
    // seçilen tarih değerini günceller
    _selectedDate = prefs?.targetDate;
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    _nameController.dispose();
    // Kullanılan kaynakları temizler
    _netController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // pick tarih işlemini yapar
  Future<void> _pickDate() async {
    // şimdiki zaman için güncel tarih ve saati alır
    final now = DateTime.now();
    // initial bilgisini hesaplayıp saklar
    final initial = _selectedDate ?? DateTime(now.year + 1, 6, 20, 10, 15);
    // picked tarih verisini asenkron işlemin sonucundan alır
    final pickedDate = await showDatePicker(
      // context bilgisini belirler
      context: context,
      // Başlangıç tarihini belirler
      initialDate:
          // Koşula göre iki değerden birini seçer
          initial.isBefore(now) ? now.add(const Duration(days: 30)) : initial,
      // Seçilebilecek ilk tarihi belirler
      firstDate: now,
      // Seçilebilecek son tarihi belirler
      lastDate: DateTime(now.year + 5),
      // help metin bilgisini belirler
      helpText: 'Hedef Sınav Tarihini Seç',
      // confirm metin bilgisini belirler
      confirmText: 'Seç',
      // cancel metin bilgisini belirler
      cancelText: 'İptal',
    );
    // Widget artık açık değilse işlemi durdurur
    if (pickedDate != null && mounted) {
      // picked time verisini asenkron işlemin sonucundan alır
      final pickedTime = await showTimePicker(
        // context bilgisini belirler
        context: context,
        // initial time bilgisini belirler
        initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
        // help metin bilgisini belirler
        helpText: 'Sınav Başlama Saatini Seç',
        // confirm metin bilgisini belirler
        confirmText: 'Ayarla',
        // cancel metin bilgisini belirler
        cancelText: 'İptal',
      );
      // hour bilgisini hesaplayıp saklar
      final hour = pickedTime?.hour ?? 10;
      // minute bilgisini hesaplayıp saklar
      final minute = pickedTime?.minute ?? 15;
      // Değişen verileri arayüze bildirir
      setState(() {
        // seçilen tarih değerini günceller
        _selectedDate = DateTime(
          // İlgili değeri veya görünüm ayarını belirler
          pickedDate.year,
          // İlgili değeri veya görünüm ayarını belirler
          pickedDate.month,
          // İlgili değeri veya görünüm ayarını belirler
          pickedDate.day,
          // İlgili değeri veya görünüm ayarını belirler
          hour,
          // İlgili değeri veya görünüm ayarını belirler
          minute,
        );
      });
    }
  }
  // save işlemini yapar
  Future<void> _save() async {
    // Değişen verileri arayüze bildirir
    setState(() => _isLoading = true);
    // existing değerini tanımlar
    final existing =
        // Değer null ise varsayılanı kullanır
        widget.initialPreferences ?? await widget.repository.getPreferences();
    // hedef net bilgisini hesaplayıp saklar
    final targetNet = double.tryParse(_netController.text.trim());
    // display adı bilgisini hesaplayıp saklar
    final displayName = _nameController.text.trim().isEmpty
        // Koşul doğruysa bu değeri kullanır
        ? null
        // Koşul yanlışsa bu değeri kullanır
        : _nameController.text.trim();
    // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
    final updated = existing.copyWith(
      // display adı bilgisini belirler
      displayName: displayName,
      // field bilgisini belirler
      field: _selectedField,
      // hedef tarihi bilgisini belirler
      targetDate: _selectedDate,
      // Hedef neti belirler
      targetNet: targetNet,
    );
    // preferences bilgisini kaydeder
    await widget.repository.savePreferences(updated);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // navigator.of nesnesini oluşturur
      Navigator.of(context).pop(updated);
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // bg değerini koşula göre hesaplar
    final bg = isDark ? GardenPalette.nightCard : GardenPalette.sandyPorcelain;
    // Görsel bir kutu oluşturur
    return Container(
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: bg,
        // Köşelerin yuvarlaklığını belirler
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // İç boşlukları belirler
      padding: EdgeInsets.only(
        // left bilgisini belirler
        left: 20,
        // right bilgisini belirler
        right: 20,
        // top bilgisini belirler
        top: 20,
        // bottom bilgisini belirler
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      // İçine yerleştirilecek widgetı belirler
      child: SingleChildScrollView(
        // İçine yerleştirilecek widgetı belirler
        child: Column(
          // Çapraz eksendeki hizalamayı belirler
          crossAxisAlignment: CrossAxisAlignment.start,
          // Ana eksende kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçerideki widgetları listeler
          children: [
            // İçeriği ortalar
            Center(
              // İçine yerleştirilecek widgetı belirler
              child: Container(
                // Genişliği belirler
                width: 40,
                // Yüksekliği belirler
                height: 4,
                // Kutu ve kenarlık görünümünü belirler
                decoration: BoxDecoration(
                  // Rengi belirler
                  color: Colors.grey.shade400,
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
            // Elemanları yan yana dizer
            Row(
              // İçerideki widgetları listeler
              children: [
                // Simge gösterir
                const Icon(Icons.tune, color: GardenPalette.mossEmerald),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(width: 8),
                // Metni ekranda gösterir
                Text(
                  // "Öğrenci ve Sınav Ayarları" metnini kullanır
                  'Öğrenci ve Sınav Ayarları',
                  // Görünüm stilini belirler
                  style: TextStyle(
                    // Yazı boyutunu belirler
                    fontSize: 18,
                    // Yazı kalınlığını belirler
                    fontWeight: FontWeight.bold,
                    // Rengi belirler
                    color: isDark
                        // Koşul doğruysa bu değeri kullanır
                        ? const Color(0xFFF8F2E8)
                        // Koşul yanlışsa bu değeri kullanır
                        : GardenPalette.inkPlum,
                  ),
                ),
              ],
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
            // İsim alanı
            // Metin giriş alanı oluşturur
            TextField(
              // Veriyi yöneten controllerı bağlar
              controller: _nameController,
              // Kutu ve kenarlık görünümünü belirler
              decoration: InputDecoration(
                // Giriş alanının etiketini belirler
                labelText: 'İsmin veya Takma Adın (İsteğe bağlı)',
                // prefix icon bilgisini belirler
                prefixIcon: const Icon(Icons.person_outline),
                // Kenarlığı belirler
                border: OutlineInputBorder(
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
            // Alan seçimi
            // Metni ekranda gösterir
            Text(
              // "YKS Alanın:" metnini kullanır
              'YKS Alanın:',
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 13,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Rengi belirler
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
            // Öğeleri sığmadıkça alt satıra geçirir
            Wrap(
              // spacing bilgisini belirler
              spacing: 8,
              // İçerideki widgetları listeler
              children: _fields.map((f) {
                // is seçilen bilgisini iki değeri karşılaştırarak hesaplar
                final isSelected = f == _selectedField;
                // Seçilebilir filtre etiketi oluşturur
                return ChoiceChip(
                  // Buton veya alan yazısını belirler
                  label: Text(f),
                  // seçili olma durumu bilgisini belirler
                  selected: isSelected,
                  // Seçili durum rengini belirler
                  selectedColor: GardenPalette.mossEmerald,
                  // etiket stili bilgisini belirler
                  labelStyle: TextStyle(
                    // Rengi belirler
                    color: isSelected ? Colors.white : null,
                    // Yazı kalınlığını belirler
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                  // Seçim değişince çalışacak fonksiyonu belirler
                  onSelected: (val) {
                    // Belirtilen koşul doğruysa işlemi yapar
                    if (val) setState(() => _selectedField = f);
                  },
                );
              // Sonuçları listeye çevirir
              }).toList(),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
            // Hedef Net
            // Metin giriş alanı oluşturur
            TextField(
              // Veriyi yöneten controllerı bağlar
              controller: _netController,
              // Klavye tipini belirler
              keyboardType:
                  // metin input type.number with options nesnesini oluşturur
                  const TextInputType.numberWithOptions(decimal: true),
              // Kutu ve kenarlık görünümünü belirler
              decoration: InputDecoration(
                // Giriş alanının etiketini belirler
                labelText: 'Hedeflenen Toplam Net (Örn: 95.0)',
                // prefix icon bilgisini belirler
                prefixIcon: const Icon(Icons.flag_outlined),
                // Kenarlığı belirler
                border: OutlineInputBorder(
                  // Köşelerin yuvarlaklığını belirler
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 16),
            // Sınav Tarihi Ayarı
            // Metni ekranda gösterir
            Text(
              // "Hedef YKS Tarihi (Resmî veya Tahmini):" metnini kullanır
              'Hedef YKS Tarihi (Resmî veya Tahmini):',
              // Görünüm stilini belirler
              style: TextStyle(
                // Yazı boyutunu belirler
                fontSize: 13,
                // Yazı kalınlığını belirler
                fontWeight: FontWeight.bold,
                // Rengi belirler
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 8),
            // Görsel bir kutu oluşturur
            Container(
              // İç boşlukları belirler
              padding: const EdgeInsets.all(12),
              // Kutu ve kenarlık görünümünü belirler
              decoration: BoxDecoration(
                // Rengi belirler
                color: isDark ? GardenPalette.nightBackdrop : Colors.white,
                // Köşelerin yuvarlaklığını belirler
                borderRadius: BorderRadius.circular(14),
                // Kenarlığı belirler
                border: Border.all(
                  // Rengi belirler
                  color: GardenPalette.mossEmerald.withAlpha(50),
                ),
              ),
              // İçine yerleştirilecek widgetı belirler
              child: Row(
                // İçerideki widgetları listeler
                children: [
                  // Simge gösterir
                  const Icon(Icons.calendar_month,
                      // Rengi belirler
                      color: GardenPalette.peachCoral),
                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                  const SizedBox(width: 12),
                  // Kalan boşluğu kullanacak alan oluşturur
                  Expanded(
                    // İçine yerleştirilecek widgetı belirler
                    child: Text(
                      // İlgili değeri veya görünüm ayarını belirler
                      _selectedDate != null
                          // Koşul doğruysa bu değeri kullanır
                          ? '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year} ${_selectedDate!.hour.toString().padLeft(2, '0')}:${_selectedDate!.minute.toString().padLeft(2, '0')}'
                          // Koşul yanlışsa bu değeri kullanır
                          : 'Tarih seçilmedi (Geri sayım kapalı)',
                      // Görünüm stilini belirler
                      style: TextStyle(
                        // Yazı boyutunu belirler
                        fontSize: 14,
                        // Yazı kalınlığını belirler
                        fontWeight: _selectedDate != null
                            // Koşul doğruysa bu değeri kullanır
                            ? FontWeight.bold
                            // Koşul yanlışsa bu değeri kullanır
                            : FontWeight.normal,
                        // Rengi belirler
                        color: _selectedDate != null
                            // Koşul doğruysa bu değeri kullanır
                            ? (isDark
                                // Koşul doğruysa bu değeri kullanır
                                ? const Color(0xFFF8F2E8)
                                // Koşul yanlışsa bu değeri kullanır
                                : GardenPalette.inkPlum)
                            // Koşul yanlışsa bu değeri kullanır
                            : Colors.grey,
                      ),
                    ),
                  ),
                  // Metin butonu oluşturur
                  TextButton(
                    // Basılınca çalışacak fonksiyonu belirler
                    onPressed: _pickDate,
                    // İçine yerleştirilecek widgetı belirler
                    child:
                        // Metni ekranda gösterir
                        Text(_selectedDate != null ? 'Değiştir' : 'Tarih Seç'),
                  ),
                  // İlgili değer null değilse kontrol eder
                  if (_selectedDate != null)
                    // Simgeli buton oluşturur
                    IconButton(
                      // simge bilgisini belirler
                      icon: const Icon(Icons.clear, size: 20),
                      // tooltip bilgisini belirler
                      tooltip: 'Tarihi Kaldır',
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => setState(() => _selectedDate = null),
                    ),
                ],
              ),
            ),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 24),
            // garden primary button nesnesini oluşturur
            GardenPrimaryButton(
              // Buton veya alan yazısını belirler
              label: 'Ayarları Kaydet',
              // simge bilgisini belirler
              icon: Icons.check,
              // yükleme durumu bilgisini belirler
              isLoading: _isLoading,
              // Basılınca çalışacak fonksiyonu belirler
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

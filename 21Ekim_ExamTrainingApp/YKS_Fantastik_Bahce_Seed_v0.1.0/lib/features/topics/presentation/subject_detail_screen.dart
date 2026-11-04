// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// müfredat dosyasını kullanıma ekler
import '../../../domain/models/curriculum.dart';
// curriculum repository dosyasını kullanıma ekler
import '../../../domain/repositories/curriculum_repository.dart';
// garden cards dosyasını kullanıma ekler
import '../../../shared/widgets/garden_cards.dart';
// garden inputs dosyasını kullanıma ekler
import '../../../shared/widgets/garden_inputs.dart';
// garden ilerleme dosyasını kullanıma ekler
import '../../../shared/widgets/garden_progress.dart';
// ders detail ekran için değişen verileri yöneten StatefulWidget kullanılır
class SubjectDetailScreen extends StatefulWidget {
  // ders detail ekran sayfasını gösterir
  const SubjectDetailScreen({
    // ders bilgisini zorunlu tutar
    required this.subject,
    // repository bilgisini zorunlu tutar
    required this.repository,
    // Üst sınıfın ilgili metodunu çalıştırır
    super.key,
  });
  // ders bilgisini tutar
  final Subject subject;
  // repository bilgisini tutar
  final CurriculumRepository repository;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  // konular için boş koleksiyon oluşturur
  List<Topic> _topics = [];
  // ilerleme map için boş koleksiyon oluşturur
  Map<String, TopicProgress> _progressMap = {};
  // yükleme durumu durumunu başlangıçta belirler
  bool _loading = true;
  // search query için metin değeri belirler
  String _searchQuery = '';
  // status filter bilgisini tutar
  TopicStatus? _statusFilter;
  // search controller metnini yönetir
  final _searchController = TextEditingController();
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // topics bilgisini yükler
    _loadTopics();
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    _searchController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // topics bilgisini yükler
  Future<void> _loadTopics() async {
    // konular verisini asenkron işlemin sonucundan alır
    final topics = await widget.repository.getTopics(widget.subject.id);
    // ilerleme değerini tanımlar
    final progress =
        // all ilerleme for ders bilgisini getirir
        await widget.repository.getAllProgressForSubject(widget.subject.id);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // konular değerini günceller
        _topics = topics;
        // ilerleme map değerini günceller
        _progressMap = progress;
        // yükleme durumu değerini günceller
        _loading = false;
      });
    }
  }
  // status bilgisini değiştirir
  Future<void> _toggleStatus(Topic topic) async {
    // güncel değerini koşula göre hesaplar
    final current = _progressMap[topic.id] ?? TopicProgress(topicId: topic.id);
    // next status bilgisini tutar
    TopicStatus nextStatus;
    // Değere göre uygun durumu seçer
    switch (current.status) {
      // konu status.not started durumu için çalışır
      case TopicStatus.notStarted:
        // next status değerini günceller
        nextStatus = TopicStatus.inProgress;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // konu status.in ilerleme durumu için çalışır
      case TopicStatus.inProgress:
        // next status değerini günceller
        nextStatus = TopicStatus.completed;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
      // konu status.completed durumu için çalışır
      case TopicStatus.completed:
        // next status değerini günceller
        nextStatus = TopicStatus.notStarted;
        // Bulunduğu döngü veya switch bölümünden çıkar
        break;
    }
    // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
    final updated = current.copyWith(
      // durum bilgisini belirler
      status: nextStatus,
      // last studied at bilgisini belirler
      lastStudiedAt: DateTime.now(),
    );
    // konu ilerleme bilgisini günceller
    await widget.repository.updateTopicProgress(updated);
    // Widget hâlâ ekrandaysa işlemi yapar
    if (mounted) {
      // Değişen verileri arayüze bildirir
      setState(() {
        // ilerleme map[konu.id] değerini günceller
        _progressMap[topic.id] = updated;
      });
    }
  }
  // questions bilgisini ekler
  Future<void> _addQuestions(Topic topic) async {
    // güncel değerini koşula göre hesaplar
    final current = _progressMap[topic.id] ?? TopicProgress(topicId: topic.id);
    // controller metnini yönetir
    final controller = TextEditingController(text: '20');
    // sayı verisini asenkron işlemin sonucundan alır
    final count = await showDialog<int>(
      // context bilgisini belirler
      context: context,
      // Gelen verilerle arayüzü oluşturur
      builder: (ctx) => AlertDialog(
        // Başlığı belirler
        title: Text('${topic.name} Soru Ekle'),
        // Gösterilecek içeriği belirler
        content: Column(
          // Ana eksende kaplanacak alanı belirler
          mainAxisSize: MainAxisSize.min,
          // İçerideki widgetları listeler
          children: [
            // Metni ekranda gösterir
            const Text('Bu konuda çözdüğün soru sayısını ekle:'),
            // Sabit boyutlu veya boşluk bırakan alan oluşturur
            const SizedBox(height: 12),
            // Metin giriş alanı oluşturur
            TextField(
              // Veriyi yöneten controllerı bağlar
              controller: controller,
              // Klavye tipini belirler
              keyboardType: TextInputType.number,
              // Açılışta otomatik odaklanmayı belirler
              autofocus: true,
              // Kutu ve kenarlık görünümünü belirler
              decoration: const InputDecoration(
                // Giriş alanının etiketini belirler
                labelText: 'Çözülen Soru Sayısı',
                // Kenarlığı belirler
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        // actions bilgisini belirler
        actions: [
          // Metin butonu oluşturur
          TextButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () => Navigator.of(ctx).pop(),
            // İçine yerleştirilecek widgetı belirler
            child: const Text('İptal'),
          ),
          // Dolu buton oluşturur
          FilledButton(
            // Basılınca çalışacak fonksiyonu belirler
            onPressed: () {
              // val bilgisini hesaplayıp saklar
              final val = int.tryParse(controller.text);
              // navigator.of nesnesini oluşturur
              Navigator.of(ctx).pop(val);
            },
            // İçine yerleştirilecek widgetı belirler
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
    // İlgili değer null değilse kontrol eder
    if (count != null && count > 0) {
      // Mevcut bilgileri koruyup güncellenmiş kopya oluşturur
      final updated = current.copyWith(
        // çözülen soru sayısı bilgisini belirler
        answeredCount: current.answeredCount + count,
        // last studied at bilgisini belirler
        lastStudiedAt: DateTime.now(),
        // durum bilgisini belirler
        status: current.status == TopicStatus.notStarted
            // Koşul doğruysa bu değeri kullanır
            ? TopicStatus.inProgress
            // Koşul yanlışsa bu değeri kullanır
            : current.status,
      );
      // konu ilerleme bilgisini günceller
      await widget.repository.updateTopicProgress(updated);
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Değişen verileri arayüze bildirir
        setState(() {
          // ilerleme map[konu.id] değerini günceller
          _progressMap[topic.id] = updated;
        });
      }
    }
  }
  // status renk bilgisini getirir
  Color _getStatusColor(TopicStatus status) {
    // Değere göre uygun durumu seçer
    switch (status) {
      // konu status.completed durumu için çalışır
      case TopicStatus.completed:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.mossEmerald;
      // konu status.in ilerleme durumu için çalışır
      case TopicStatus.inProgress:
        // Temadan renk veya görünüm değeri alır
        return GardenPalette.peachCoral;
      // konu status.not started durumu için çalışır
      case TopicStatus.notStarted:
        // Temadan renk veya görünüm değeri alır
        return Colors.grey.shade600;
    }
  }
  // status icon bilgisini getirir
  IconData _getStatusIcon(TopicStatus status) {
    // Değere göre uygun durumu seçer
    switch (status) {
      // konu status.completed durumu için çalışır
      case TopicStatus.completed:
        // Gösterilecek simgeyi belirler
        return Icons.check_circle;
      // konu status.in ilerleme durumu için çalışır
      case TopicStatus.inProgress:
        // Gösterilecek simgeyi belirler
        return Icons.eco;
      // konu status.not started durumu için çalışır
      case TopicStatus.notStarted:
        // Gösterilecek simgeyi belirler
        return Icons.radio_button_unchecked;
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // tamamlanan sayısı bilgisini hesaplayıp saklar
    final completedCount = _progressMap.values
        // Koşula uyan kayıtları filtreler
        .where((p) => p.status == TopicStatus.completed)
        // Öğe veya karakter sayısını kullanır
        .length;
    // in ilerleme sayı bilgisini hesaplayıp saklar
    final inProgressCount = _progressMap.values
        // Koşula uyan kayıtları filtreler
        .where((p) => p.status == TopicStatus.inProgress)
        // Öğe veya karakter sayısını kullanır
        .length;
    // toplam bilgisini hesaplayıp saklar
    final total = _topics.length;
    // oran değerini koşula göre hesaplar
    final ratio = total > 0 ? completedCount / total : 0.0;
    // filtered topics için koşula uyan kayıtları filtreler
    final filteredTopics = _topics.where((t) {
      // matches query bilgisini hesaplayıp saklar
      final matchesQuery = _searchQuery.isEmpty ||
          // lower case bilgisini dönüştürür
          t.name.toLowerCase().contains(_searchQuery.toLowerCase());
      // ilerleme bilgisini hesaplayıp saklar
      final progress = _progressMap[t.id];
      // durum bilgisini hesaplayıp saklar
      final status = progress?.status ?? TopicStatus.notStarted;
      // matches status bilgisini iki değeri karşılaştırarak hesaplar
      final matchesStatus = _statusFilter == null || status == _statusFilter;
      // Birden fazla koşulu birlikte kontrol eder
      return matchesQuery && matchesStatus;
    // Sonuçları listeye çevirir
    }).toList();
    // Sayfanın temel iskeletini oluşturur
    return Scaffold(
      // Üst menüyü belirler
      appBar: AppBar(
        // Başlığı belirler
        title: Text('${widget.subject.stage} • ${widget.subject.name}'),
      ),
      // Sayfanın ana içeriğini belirler
      body: _loading
          // Koşul doğruysa bu değeri kullanır
          ? const Center(child: CircularProgressIndicator())
          // Koşul yanlışsa bu değeri kullanır
          : ListView(
              // İç boşlukları belirler
              padding: const EdgeInsets.all(16),
              // İçerideki widgetları listeler
              children: [
                // garden kart kartını oluşturur
                GardenCard(
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // İçerideki widgetları listeler
                    children: [
                      // organic ilerleme ring nesnesini oluşturur
                      OrganicProgressRing(
                        // ilerleme bilgisini belirler
                        progress: ratio,
                        // Boyutu belirler
                        size: 80,
                        // Çizgi kalınlığını belirler
                        strokeWidth: 8,
                        // center metin bilgisini belirler
                        centerText: '%${(ratio * 100).toInt()}',
                        // sub metin bilgisini belirler
                        subText: 'Bitti',
                        // Etkin durum rengini belirler
                        activeColor: GardenPalette.mossEmerald,
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 16),
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
                              // İlgili değeri veya görünüm ayarını belirler
                              widget.subject.name,
                              // Görünüm stilini belirler
                              style: const TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 18,
                                // Yazı kalınlığını belirler
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Sabit boyutlu veya boşluk bırakan alan oluşturur
                            const SizedBox(height: 4),
                            // Metni ekranda gösterir
                            Text(
                              // "Sınavda ~${widget.subject.questionCount} So…" metnini kullanır
                              'Sınavda ~${widget.subject.questionCount} Soru • Toplam $total Konu',
                              // Görünüm stilini belirler
                              style: TextStyle(
                                // Yazı boyutunu belirler
                                fontSize: 12,
                                // Rengi belirler
                                color: isDark
                                    // Koşul doğruysa bu değeri kullanır
                                    ? Colors.white60
                                    // Koşul yanlışsa bu değeri kullanır
                                    : Colors.grey.shade600,
                              ),
                            ),
                            // Sabit boyutlu veya boşluk bırakan alan oluşturur
                            const SizedBox(height: 8),
                            // Öğeleri sığmadıkça alt satıra geçirir
                            Wrap(
                              // spacing bilgisini belirler
                              spacing: 8,
                              // İçerideki widgetları listeler
                              children: [
                                // İlgili fonksiyonu çalıştırır
                                _buildMiniBadge(
                                  // Buton veya alan yazısını belirler
                                  label: '$completedCount Tamam',
                                  // Rengi belirler
                                  color: GardenPalette.mossEmerald,
                                ),
                                // İlgili fonksiyonu çalıştırır
                                _buildMiniBadge(
                                  // Buton veya alan yazısını belirler
                                  label: '$inProgressCount Çalışılıyor',
                                  // Rengi belirler
                                  color: GardenPalette.peachCoral,
                                ),
                                // İlgili fonksiyonu çalıştırır
                                _buildMiniBadge(
                                  // Buton veya alan yazısını belirler
                                  label:
                                      // "${total - completedCount - inProgressCount}…" metnini kullanır
                                      '${total - completedCount - inProgressCount} Eksik',
                                  // Rengi belirler
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 14),
                // nature search field nesnesini oluşturur
                NatureSearchField(
                  // Veriyi yöneten controllerı bağlar
                  controller: _searchController,
                  // Giriş alanında ipucu gösterir
                  hintText: '${widget.subject.name} konusu ara...',
                  // Değer değişince çalışacak fonksiyonu belirler
                  onChanged: (val) => setState(() => _searchQuery = val),
                  // on clear olayındaki fonksiyonu belirler
                  onClear: () => setState(() => _searchQuery = ''),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 12),
                // Sayfayı kaydırılabilir yapar
                SingleChildScrollView(
                  // Kaydırma yönünü belirler
                  scrollDirection: Axis.horizontal,
                  // İçine yerleştirilecek widgetı belirler
                  child: Row(
                    // İçerideki widgetları listeler
                    children: [
                      // nature filter chip nesnesini oluşturur
                      NatureFilterChip(
                        // Buton veya alan yazısını belirler
                        label: 'Tümü ($total)',
                        // seçili olma durumu bilgisini belirler
                        selected: _statusFilter == null,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: (_) => setState(() => _statusFilter = null),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 8),
                      // nature filter chip nesnesini oluşturur
                      NatureFilterChip(
                        // Buton veya alan yazısını belirler
                        label: 'Tamamlandı ($completedCount)',
                        // simge bilgisini belirler
                        icon: Icons.check_circle_outline,
                        // seçili olma durumu bilgisini belirler
                        selected: _statusFilter == TopicStatus.completed,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: (val) => setState(() =>
                            // Koşula göre iki değerden birini seçer
                            _statusFilter = val ? TopicStatus.completed : null),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 8),
                      // nature filter chip nesnesini oluşturur
                      NatureFilterChip(
                        // Buton veya alan yazısını belirler
                        label: 'Çalışılıyor ($inProgressCount)',
                        // simge bilgisini belirler
                        icon: Icons.eco,
                        // seçili olma durumu bilgisini belirler
                        selected: _statusFilter == TopicStatus.inProgress,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: (val) => setState(() => _statusFilter =
                            // Koşula göre iki değerden birini seçer
                            val ? TopicStatus.inProgress : null),
                      ),
                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                      const SizedBox(width: 8),
                      // nature filter chip nesnesini oluşturur
                      NatureFilterChip(
                        // Buton veya alan yazısını belirler
                        label:
                            // "Eksik (${total - completedCount - inProgres…" metnini kullanır
                            'Eksik (${total - completedCount - inProgressCount})',
                        // simge bilgisini belirler
                        icon: Icons.pending_actions,
                        // seçili olma durumu bilgisini belirler
                        selected: _statusFilter == TopicStatus.notStarted,
                        // Seçim değişince çalışacak fonksiyonu belirler
                        onSelected: (val) => setState(() => _statusFilter =
                            // Koşula göre iki değerden birini seçer
                            val ? TopicStatus.notStarted : null),
                      ),
                    ],
                  ),
                ),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 16),
                // botanical section header nesnesini oluşturur
                BotanicalSectionHeader(
                  // Başlığı belirler
                  title: 'Konu Listesi (${filteredTopics.length})',
                  // Alt başlığı belirler
                  subtitle: 'Tıkla: durumu değiştir • Soru ekle',
                  // simge bilgisini belirler
                  icon: Icons.library_books,
                ),
                // Liste veya metin boşsa bu koşul çalışır
                if (filteredTopics.isEmpty)
                  // İç boşluk ekler
                  Padding(
                    // İç boşlukları belirler
                    padding: const EdgeInsets.all(32),
                    // İçine yerleştirilecek widgetı belirler
                    child: Center(
                      // İçine yerleştirilecek widgetı belirler
                      child: Text(
                        // "Bu filtrede konu bulunamadı." metnini kullanır
                        'Bu filtrede konu bulunamadı.',
                        // Görünüm stilini belirler
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                // Önceki koşul sağlanmazsa çalışır
                else
                  // Öğeleri tek tek dönüştürür
                  ...filteredTopics.map((topic) {
                    // ilerleme bilgisini hesaplayıp saklar
                    final progress = _progressMap[topic.id] ??
                        // konu ilerleme nesnesini oluşturur
                        TopicProgress(topicId: topic.id);
                    // renk bilgisini hesaplayıp saklar
                    final color = _getStatusColor(progress.status);
                    // simge bilgisini hesaplayıp saklar
                    final icon = _getStatusIcon(progress.status);
                    // İç boşluk ekler
                    return Padding(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.only(bottom: 8),
                      // İçine yerleştirilecek widgetı belirler
                      child: GardenCard(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(
                            // horizontal bilgisini belirler
                            horizontal: 14, vertical: 12),
                        // Dokunulunca çalışacak fonksiyonu belirler
                        onTap: () => _toggleStatus(topic),
                        // İçine yerleştirilecek widgetı belirler
                        child: Row(
                          // İçerideki widgetları listeler
                          children: [
                            // Dokunma hareketlerini dinler
                            GestureDetector(
                              // Dokunulunca çalışacak fonksiyonu belirler
                              onTap: () => _toggleStatus(topic),
                              // İçine yerleştirilecek widgetı belirler
                              child: Container(
                                // Genişliği belirler
                                width: 38,
                                // Yüksekliği belirler
                                height: 38,
                                // Kutu ve kenarlık görünümünü belirler
                                decoration: BoxDecoration(
                                  // Widgetın kenar şeklini belirler
                                  shape: BoxShape.circle,
                                  // Rengi belirler
                                  color: color.withAlpha(isDark ? 50 : 25),
                                  // Kenarlığı belirler
                                  border: Border.all(color: color, width: 1.5),
                                ),
                                // İçine yerleştirilecek widgetı belirler
                                child: Icon(icon, color: color, size: 20),
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
                                    // İlgili değeri veya görünüm ayarını belirler
                                    topic.name,
                                    // Görünüm stilini belirler
                                    style: TextStyle(
                                      // Yazı boyutunu belirler
                                      fontSize: 14,
                                      // Yazı kalınlığını belirler
                                      fontWeight: FontWeight.w600,
                                      // Kutu ve kenarlık görünümünü belirler
                                      decoration: progress.status ==
                                              // İlgili değeri veya görünüm ayarını belirler
                                              TopicStatus.completed
                                          // Koşul doğruysa bu değeri kullanır
                                          ? TextDecoration.lineThrough
                                          // Koşul yanlışsa bu değeri kullanır
                                          : null,
                                      // Rengi belirler
                                      color: isDark
                                          // Koşul doğruysa bu değeri kullanır
                                          ? const Color(0xFFF8F2E8)
                                          // Koşul yanlışsa bu değeri kullanır
                                          : GardenPalette.inkPlum,
                                    ),
                                  ),
                                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                  const SizedBox(height: 2),
                                  // Elemanları yan yana dizer
                                  Row(
                                    // İçerideki widgetları listeler
                                    children: [
                                      // Metni ekranda gösterir
                                      Text(
                                        // İlgili değeri veya görünüm ayarını belirler
                                        progress.status.label,
                                        // Görünüm stilini belirler
                                        style: TextStyle(
                                          // Yazı boyutunu belirler
                                          fontSize: 11,
                                          // Yazı kalınlığını belirler
                                          fontWeight: FontWeight.bold,
                                          // Rengi belirler
                                          color: color,
                                        ),
                                      ),
                                      // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                      const SizedBox(width: 8),
                                      // Metni ekranda gösterir
                                      Text(
                                        // "•  ${progress.answeredCount} soru" metnini kullanır
                                        '•  ${progress.answeredCount} soru',
                                        // Görünüm stilini belirler
                                        style: TextStyle(
                                          // Yazı boyutunu belirler
                                          fontSize: 11,
                                          // Rengi belirler
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      // İlgili değer null değilse kontrol eder
                                      if (progress.lastStudiedAt != null) ...[
                                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                        const SizedBox(width: 8),
                                        // Metni ekranda gösterir
                                        Text(
                                          // "•  ${progress.lastStudiedAt!.day}.${progres…" metnini kullanır
                                          '•  ${progress.lastStudiedAt!.day}.${progress.lastStudiedAt!.month}',
                                          // Görünüm stilini belirler
                                          style: TextStyle(
                                            // Yazı boyutunu belirler
                                            fontSize: 10,
                                            // Rengi belirler
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Simgeli buton oluşturur
                            IconButton(
                              // simge bilgisini belirler
                              icon: const Icon(Icons.add_task),
                              // tooltip bilgisini belirler
                              tooltip: 'Soru Ekle',
                              // Rengi belirler
                              color: GardenPalette.mossEmerald,
                              // Basılınca çalışacak fonksiyonu belirler
                              onPressed: () => _addQuestions(topic),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                // Sabit boyutlu veya boşluk bırakan alan oluşturur
                const SizedBox(height: 32),
              ],
            ),
    );
  }
  // mini badge bilgisini oluşturur
  Widget _buildMiniBadge({required String label, required Color color}) {
    // Görsel bir kutu oluşturur
    return Container(
      // İç boşlukları belirler
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      // Kutu ve kenarlık görünümünü belirler
      decoration: BoxDecoration(
        // Rengi belirler
        color: color.withAlpha(25),
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(6),
      ),
      // İçine yerleştirilecek widgetı belirler
      child: Text(
        // İlgili değeri veya görünüm ayarını belirler
        label,
        // Görünüm stilini belirler
        style: TextStyle(
          // Yazı boyutunu belirler
          fontSize: 10,
          // Yazı kalınlığını belirler
          fontWeight: FontWeight.bold,
          // Rengi belirler
          color: color,
        ),
      ),
    );
  }
}

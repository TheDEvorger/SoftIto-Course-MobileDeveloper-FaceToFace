// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Renk ayarlarını ekler
import '../core/palette.dart';
// Kelime modelini ekler
import '../models/vocabulary_word.dart';
// Ortak arayüz elemanlarını ekler
import '../widgets/ui_parts.dart';

// Arama ve filtreler değişeceği için StatefulWidget kullanılır
class DictionaryScreen extends StatefulWidget {
  // Constructor gerekli bilgileri alır
  const DictionaryScreen({
    // Üst sınıfa key gönderir
    super.key,
    // Kelime listesini zorunlu tutar
    required this.words,
    // Kelime tekrar fonksiyonunu zorunlu tutar
    required this.onReview,
    // Öğrenildi işaretleme fonksiyonunu zorunlu tutar
    required this.onMarkMastered,
    // Aşamayı sıfırlama fonksiyonunu zorunlu tutar
    required this.onReset,
    // Kelime silme fonksiyonunu zorunlu tutar
    required this.onDelete,
    // Kelime ekleme fonksiyonunu zorunlu tutar
    required this.onAdd,
  });
  // Kelime listesini tutar
  final List<VocabularyWord> words;
  // Kelime IDsi alarak tekrar işlemini çalıştırır
  final ValueChanged<String> onReview;
  // Kelimeyi öğrenildi olarak işaretleyen callback
  final ValueChanged<String> onMarkMastered;
  // Kelimenin aşamasını sıfırlayan callback
  final ValueChanged<String> onReset;
  // Kelime silme callbacki
  final ValueChanged<String> onDelete;
  // Kelime ekleme ekranını açan callback
  final VoidCallback onAdd;
  // Üstteki createState metodunu uygular
  @override
  // Ekranın State sınıfını oluşturur
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

// Arama ve filtrelerin durumunu yöneten State sınıfı
class _DictionaryScreenState extends State<DictionaryScreen> {
  // Arama kutusundaki metni kontrol eder
  final _searchController = TextEditingController();
  // Aranan kelimeyi tutar
  String _query = '';
  // Seçilen dili tutar, null ise bütün diller
  StudyLanguage? _language;
  // Seçilen aşamayı tutar, null ise bütün aşamalar
  WordStage? _stage;
  // Üstteki dispose metodunu yeniden yazar
  @override
  // Widget kaldırılırken çalışır
  void dispose() {
    // Arama controllerını temizler
    _searchController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }

  // Bütün arama ve filtreleri temizler
  void _clearFilters() => setState(() {
    // Arama kutusundaki yazıyı siler
    _searchController.clear();
    // Arama değişkenini boş yapar
    _query = '';
    // Dil filtresini kaldırır
    _language = null;
    // Öğrenme aşaması filtresini kaldırır
    _stage = null;
  });
  // Üstteki build metodunu yeniden yazar
  @override
  // Kelime defteri ekranını oluşturur
  Widget build(BuildContext context) {
    // Aranan metnin boşluklarını temizleyip küçük harfe çevirir
    final query = _query.trim().toLowerCase();
    // Arama ve filtrelere uyan kelimeleri bulur
    final matches = widget.words.where((w) {
      // Kelime anlam ve örnek cümleyi arar, dil ve aşama filtrelerini kontrol eder
      return (query.isEmpty ||
              w.word.toLowerCase().contains(query) ||
              w.meaning.toLowerCase().contains(query) ||
              w.example.toLowerCase().contains(query)) &&
          // Dil seçilmediyse hepsini, seçildiyse eşleşenleri alır
          (_language == null || w.language == _language) &&
          // Aşama seçilmediyse hepsini, seçildiyse eşleşenleri alır
          (_stage == null || w.stage == _stage);
      // where ile filtrelenen sonuçları listeye çevirir
    }).toList();
    // Ekranın kaydırılmasını sağlar
    return SingleChildScrollView(
      // Sayfanın ortak çerçevesini kullanır
      child: PageFrame(
        // Elemanları alt alta ve sola hizalı dizer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bölüm başlığını gösterir
            const Kicker('KİŞİSEL ARŞİV   /   02'),
            // Dikeyde 11 boşluk bırakır
            const SizedBox(height: 11),
            // Sayfanın başlığını gösterir
            Text(
              'Kelime defterim',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            // Dikeyde 11 boşluk bırakır
            const SizedBox(height: 11),
            // Açıklama yazısını gösterir
            const Text(
              'Birikmiş kelimelerin, küçük bir sözlüğün. Ara, dön, tekrar et.',
              style: TextStyle(color: Palette.muted, fontSize: 14),
            ),
            // Dikeyde 24 boşluk bırakır
            const SizedBox(height: 24),
            // Arama ve filtreler için panel oluşturur
            SurfacePanel(
              // Panelin iç boşluklarını belirler
              padding: const EdgeInsets.fromLTRB(17, 18, 17, 18),
              // Filtre elemanlarını alt alta dizer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kelime arama kutusu oluşturur
                  TextField(
                    // Arama controllerını bağlar
                    controller: _searchController,
                    // Metin değişince arama sonucunu günceller
                    onChanged: (value) => setState(() => _query = value),
                    // Arama kutusunun görünümünü ayarlar
                    decoration: InputDecoration(
                      // Arama ipucunu gösterir
                      hintText: 'Kelime veya anlam ara...',
                      // Arama simgesini gösterir
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Palette.moss,
                      ),
                      // Arama boş değilse temizleme butonu gösterir
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              // Butonun açıklaması
                              tooltip: 'Aramayı temizle',
                              // Arama metnini silip ekranı günceller
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _query = '';
                              }),
                              // Çarpı simgesini gösterir
                              icon: const Icon(Icons.close_rounded),
                              // Arama boşsa buton göstermez
                            )
                          : null,
                    ),
                  ),
                  // Dikeyde 17 boşluk bırakır
                  const SizedBox(height: 17),
                  // Dil filtresinin başlığını gösterir
                  const Kicker('DİL SEÇİMİ'),
                  // Dikeyde 9 boşluk bırakır
                  const SizedBox(height: 9),
                  // Dil seçeneklerini dizer, sığmazsa alt satıra geçirir
                  Wrap(
                    spacing: 7,
                    runSpacing: 5,
                    children: [
                      // Hepsi seçilince dil filtresini kaldırır
                      _filter(
                        'Hepsi',
                        _language == null,
                        () => setState(() => _language = null),
                      ),
                      // Enum içindeki bütün dilleri dolaşır
                      for (final language in StudyLanguage.values)
                        // Her dil için filtre butonu oluşturur
                        _filter(
                          '${language.flag} ${language.label}',
                          _language == language,
                          () => setState(() => _language = language),
                        ),
                    ],
                  ),
                  // Dikeyde 12 boşluk bırakır
                  const SizedBox(height: 12),
                  // Öğrenme aşaması başlığını gösterir
                  const Kicker('ÖĞRENME AŞAMASI'),
                  // Dikeyde 9 boşluk bırakır
                  const SizedBox(height: 9),
                  // Öğrenme aşaması seçeneklerini gösterir
                  Wrap(
                    spacing: 7,
                    runSpacing: 5,
                    children: [
                      // Her aşama seçilince aşama filtresini kaldırır
                      _filter(
                        'Her aşama',
                        _stage == null,
                        () => setState(() => _stage = null),
                      ),
                      // Enum içindeki bütün aşamaları dolaşır
                      for (final stage in WordStage.values)
                        // Her aşama için filtre butonu oluşturur
                        _filter(
                          stage.label,
                          _stage == stage,
                          () => setState(() => _stage = stage),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Dikeyde 22 boşluk bırakır
            const SizedBox(height: 22),
            // Kelime sayısı ve butonları yan yana dizer
            Row(
              children: [
                // Bulunan ve toplam kelime sayısını gösterir
                Expanded(
                  child: Text(
                    '${matches.length} KELİME   /   KAYITLI ${widget.words.length}',
                    style: const TextStyle(
                      letterSpacing: 1.15,
                      color: Palette.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                // Herhangi bir filtre varsa temizleme butonu gösterir
                if (query.isNotEmpty || _language != null || _stage != null)
                  // Bütün filtreleri temizler
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Temizle'),
                  ),
                // Yeni kelime ekleme butonu
                IconButton.filledTonal(
                  // Butonun açıklaması
                  tooltip: 'Yeni kelime',
                  // Basılınca kelime ekleme ekranını açar
                  onPressed: widget.onAdd,
                  // Artı simgesini gösterir
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            // Dikeyde 13 boşluk bırakır
            const SizedBox(height: 13),
            // Filtreye uyan kelime yoksa boş ekran gösterir
            if (matches.isEmpty)
              // Boş liste için bilgilendirme alanı
              EmptyState(
                // Kayıt yoksa veya sonuç bulunamadıysa farklı başlık gösterir
                title: widget.words.isEmpty
                    ? 'İlk sayfa seni bekliyor'
                    : 'Aradığın kelimeyi bulamadım',
                // Duruma göre açıklama mesajı gösterir
                message: widget.words.isEmpty
                    ? 'Defterine ilk kelimeni ekleyebilirsin.'
                    : 'Başka bir kelime veya filtre deneyebilirsin.',
                // Boş liste simgesini gösterir
                icon: Icons.chrome_reader_mode_outlined,
                // Kayıt yoksa kelime ekleme, varsa filtre temizleme butonu gösterir
                action: widget.words.isEmpty
                    // Kayıt yoksa kelime ekleme ekranına geçer
                    ? FilledButton.icon(
                        onPressed: widget.onAdd,
                        icon: const Icon(Icons.add),
                        label: const Text('Kelime ekle'),
                      )
                    // Kayıt varsa filtreleri kaldırır
                    : OutlinedButton(
                        onPressed: _clearFilters,
                        child: const Text('Filtreleri kaldır'),
                      ),
              )
            // Kelime bulunduysa kartları gösterir
            else
              // Ekran genişliğine göre kartları düzenler
              LayoutBuilder(
                builder: (context, constraints) {
                  // Geniş ekranda 2, dar ekranda 1 sütun olur
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  // Sütun sayısına göre kart genişliğini hesaplar
                  final cardWidth =
                      (constraints.maxWidth - (columns == 2 ? 14 : 0)) /
                      columns;
                  // Kartları yan yana dizer, sığmazsa alt satıra geçirir
                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      // Filtreye uyan bütün kelimeleri dolaşır
                      for (final item in matches)
                        // Her kelime için kart alanı oluşturur
                        SizedBox(
                          width: cardWidth,
                          child: WordTile(
                            // Kelimenin IDsini key olarak kullanır
                            key: ValueKey(item.id),
                            // Kelime bilgisini karta gönderir
                            word: item,
                            // Tekrar butonuyla ilgili kelimeyi çalıştırır
                            onReview: () => widget.onReview(item.id),
                            // Kelimeyi öğrenildi olarak işaretler
                            onMastered: () => widget.onMarkMastered(item.id),
                            // Öğrenme aşamasını sıfırlar
                            onReset: () => widget.onReset(item.id),
                            // Kelime silme onay penceresini açar
                            onDelete: () => _confirmDelete(context, item),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Dil ve aşama filtreleri için ortak buton oluşturur
  Widget _filter(String title, bool active, VoidCallback onTap) => ChoiceChip(
    // Butonun yazısını gösterir
    label: Text(title),
    // Seçili olup olmadığını belirler
    selected: active,
    // Basılınca gelen callbacki çalıştırır
    onSelected: (_) => onTap(),
    // Seçili butonun arka plan rengi
    selectedColor: Palette.sage,
    // Normal arka plan rengi
    backgroundColor: Palette.parchment,
    // Seçili duruma göre kenarlık rengi
    side: BorderSide(color: active ? Palette.moss : Palette.border),
    // Butonun köşelerini yuvarlar
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    // Seçili duruma göre yazı stilini belirler
    labelStyle: TextStyle(
      fontSize: 12,
      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
      color: active ? Palette.forest : Palette.muted,
    ),
    // Butonun kapladığı alanı sıkılaştırır
    visualDensity: VisualDensity.compact,
  );
  // Kelime silmeden önce onay penceresi açar
  Future<void> _confirmDelete(BuildContext context, VocabularyWord word) async {
    // Kullanıcının onay sonucunu bekler
    final confirmed = await showDialog<bool>(
      // Pencerenin açılacağı context
      context: context,
      // Onay penceresini oluşturur
      builder: (dialogContext) => AlertDialog(
        // Pencerenin başlığını gösterir
        title: const Text('Kelime silinsin mi?'),
        // Silinecek kelimenin adını gösterir
        content: Text('“${word.word}” defterinden kaldırılacak.'),
        // Pencerenin altındaki butonları tutar
        actions: [
          // Vazgeç seçilince false döndürür
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          // Sil seçilince true döndürür
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    // Silme onaylandıysa ve widget hâlâ açıksa kelimeyi siler
    if (confirmed == true && mounted) widget.onDelete(word.id);
  }
}

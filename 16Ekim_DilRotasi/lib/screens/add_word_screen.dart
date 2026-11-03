// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// Renk ayarlarını ekler
import '../core/palette.dart';
// Kelime modelini ekler
import '../models/vocabulary_word.dart';
// Ortak arayüz elemanlarını ekler
import '../widgets/ui_parts.dart';

// Formdaki bilgiler değişeceği için StatefulWidget kullanılır
class AddWordScreen extends StatefulWidget {
  // Constructor, onSubmit verilmesini zorunlu tutar
  const AddWordScreen({super.key, required this.onSubmit});
  // Kaydedilen kelimeyi üst sınıfa gönderen callback
  final ValueChanged<VocabularyWord> onSubmit;
  // Üstteki createState metodunu uygular
  @override
  // Ekranın State sınıfını oluşturur
  State<AddWordScreen> createState() => _AddWordScreenState();
}

// Formun değişen verilerini tutan State sınıfı
class _AddWordScreenState extends State<AddWordScreen> {
  // Formu kontrol etmek için GlobalKey kullanılır
  final _formKey = GlobalKey<FormState>();
  // Girilen kelimeyi kontrol eder
  final _wordController = TextEditingController();
  // Girilen anlamı kontrol eder
  final _meaningController = TextEditingController();
  // Örnek cümleyi kontrol eder
  final _exampleController = TextEditingController();
  // Başlangıçta Almanca seçili olur
  StudyLanguage _language = StudyLanguage.german;
  // Üstteki dispose metodunu yeniden yazar
  @override
  // Widget kaldırılırken çalışır
  void dispose() {
    // Kelime controllerını temizler
    _wordController.dispose();
    // Anlam controllerını temizler
    _meaningController.dispose();
    // Örnek cümle controllerını temizler
    _exampleController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }

  // Girilen metnin geçerli olup olmadığını kontrol eder
  String? _required(String? value) {
    // Alan boşsa hata mesajı döndürür
    if ((value ?? '').trim().isEmpty) return 'Bu alanı doldurmalısın.';
    // Metin 90 karakteri geçerse hata verir
    if (value!.trim().length > 90) return 'En fazla 90 karakter yazabilirsin.';
    // Hata yoksa null döndürür
    return null;
  }

  // Kelimeyi kaydetmek için kullanılan metot
  void _save() {
    // Form geçerli değilse işlemi durdurur
    if (!_formKey.currentState!.validate()) return;
    // Yeni kelime oluşturup callback ile üst widgeta gönderir
    widget.onSubmit(
      VocabularyWord(
        // Zamana göre benzersiz ID oluşturur
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        // Seçilen dili kaydeder
        language: _language,
        // Kelimeyi alır ve boşluklarını temizler
        word: _wordController.text.trim(),
        // Türkçe anlamını alır
        meaning: _meaningController.text.trim(),
        // Örnek cümleyi alır
        example: _exampleController.text.trim(),
        // Kelimenin eklenme tarihini kaydeder
        createdAt: DateTime.now(),
      ),
    );
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Ekranın kaydırılmasını sağlar
  Widget build(BuildContext context) => SingleChildScrollView(
    // Sayfanın ortak çerçeve yapısını kullanır
    child: PageFrame(
      // Elemanları alt alta dizer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sayfanın bölüm başlığını gösterir
          const Kicker('YENİ BİR SAYFA   /   03'),
          // Dikeyde 11 boşluk bırakır
          const SizedBox(height: 11),
          // Başlığı temadaki büyük yazı stiliyle gösterir
          Text(
            'Defterine bir\nkelime bırak.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          // Dikeyde 11 boşluk bırakır
          const SizedBox(height: 11),
          // Açıklama yazısını gösterir
          const Text(
            'Okuduğun, duyduğun ya da öğrendiğin ifadeleri burada biriktir.',
            style: TextStyle(color: Palette.muted, fontSize: 14),
          ),
          // Dikeyde 24 boşluk bırakır
          const SizedBox(height: 24),
          // Kullanılabilir genişliği öğrenmek için LayoutBuilder kullanılır
          LayoutBuilder(
            builder: (context, constraints) {
              // Genişlik 920 ve üzerindeyse yan yana gösterir
              final sideBySide = constraints.maxWidth >= 920;
              // Kelime formunu oluşturur
              final form = _formPanel();
              // Önizleme kartını oluşturur
              final preview = _previewPanel();
              // Ekran darsa form ve önizlemeyi alt alta dizer
              if (!sideBySide)
                return Column(
                  children: [form, const SizedBox(height: 18), preview],
                );
              // Geniş ekranda form ve önizlemeyi yan yana dizer
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form için 7 birimlik alan ayırır
                  Expanded(flex: 7, child: form),
                  // Araya 18 boşluk bırakır
                  const SizedBox(width: 18),
                  // Önizleme için 5 birimlik alan ayırır
                  Expanded(flex: 5, child: preview),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
  // Kelime giriş formunu oluşturan metot
  Widget _formPanel() => SurfacePanel(
    // Panelin içinden 23 boşluk bırakır
    padding: const EdgeInsets.all(23),
    // Form alanlarını bir arada yönetir
    child: Form(
      // Formun durumunu kontrol eden key
      key: _formKey,
      // Form elemanlarını alt alta dizer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formun bölüm başlığını gösterir
          const Kicker('KELİME FİŞİ   •   01'),
          // Dikeyde 10 boşluk bırakır
          const SizedBox(height: 10),
          // Dil seçme başlığını gösterir
          const Text(
            'Hangi dili çalışıyoruz?',
            style: TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
              color: Palette.ink,
              fontSize: 21,
            ),
          ),
          // Dikeyde 12 boşluk bırakır
          const SizedBox(height: 12),
          // Dil seçeneklerini dizer, yer kalmazsa alt satıra geçirir
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              // Enum içindeki bütün dilleri dolaşır
              for (final language in StudyLanguage.values)
                // Her dil için seçim butonu oluşturur
                _LanguageOption(
                  // Dil bilgisini gönderir
                  language: language,
                  // Seçili dil ile eşleşiyorsa true olur
                  selected: _language == language,
                  // Seçilen dili değiştirip ekranı günceller
                  onTap: () => setState(() => _language = language),
                ),
            ],
          ),
          // Dikeyde 27 boşluk bırakır
          const SizedBox(height: 27),
          // Kelime alanının başlığını gösterir, zorunlu alan
          const _FieldLabel('Kelime veya ifade', mandatory: true),
          // Dikeyde 8 boşluk bırakır
          const SizedBox(height: 8),
          // Kelime girişi için form alanı oluşturur
          TextFormField(
            // Kelime controllerını bağlar
            controller: _wordController,
            // En fazla 90 karakter girilebilir
            maxLength: 90,
            // Girilen metni _required ile kontrol eder
            validator: _required,
            // Yazı değişince önizlemeyi günceller
            onChanged: (_) => setState(() {}),
            // Cümle başlarında büyük harf kullanımını ayarlar
            textCapitalization: TextCapitalization.sentences,
            // Klavyede sonraki alan tuşunu gösterir
            textInputAction: TextInputAction.next,
            // Örnek kelimeyi ipucu olarak gösterir
            decoration: const InputDecoration(
              hintText: 'Örn. die Herausforderung',
            ),
          ),
          // Dikeyde 7 boşluk bırakır
          const SizedBox(height: 7),
          // Türkçe anlam alanının başlığını gösterir
          const _FieldLabel('Türkçe anlamı', mandatory: true),
          // Dikeyde 8 boşluk bırakır
          const SizedBox(height: 8),
          // Türkçe anlam için form alanı oluşturur
          TextFormField(
            // Anlam controllerını bağlar
            controller: _meaningController,
            // En fazla 90 karakter girilebilir
            maxLength: 90,
            // Girilen anlamı kontrol eder
            validator: _required,
            // Yazı değişince önizlemeyi günceller
            onChanged: (_) => setState(() {}),
            // Klavyede sonraki alan tuşunu gösterir
            textInputAction: TextInputAction.next,
            // Örnek anlamı ipucu olarak gösterir
            decoration: const InputDecoration(
              hintText: 'Örn. zorluk, meydan okuma',
            ),
          ),
          // Dikeyde 7 boşluk bırakır
          const SizedBox(height: 7),
          // Örnek cümle alanının başlığını gösterir
          const _FieldLabel('Örnek cümle'),
          // Dikeyde 8 boşluk bırakır
          const SizedBox(height: 8),
          // Örnek cümle için form alanı oluşturur
          TextFormField(
            // Örnek cümle controllerını bağlar
            controller: _exampleController,
            // En fazla 240 karakter girilebilir
            maxLength: 240,
            // Metin alanını 3 satır yapar
            maxLines: 3,
            // Metin değişince önizlemeyi günceller
            onChanged: (_) => setState(() {}),
            // Örnek cümleyi ipucu olarak gösterir
            decoration: const InputDecoration(
              hintText: 'Örn. Das ist eine große Herausforderung.',
            ),
          ),
          // Dikeyde 19 boşluk bırakır
          const SizedBox(height: 19),
          // Kayıt butonunun alanını oluşturur
          SizedBox(
            // Butonu mümkün olan genişliğe yayar
            width: double.infinity,
            // Simge ve yazılı buton oluşturur
            child: FilledButton.icon(
              // Basılınca _save metodunu çalıştırır
              onPressed: _save,
              // Butonun simgesini gösterir
              icon: const Icon(Icons.bookmark_add_outlined, size: 20),
              // Butonun yazısını gösterir
              label: const Text('Kelimeyi deftere kaydet'),
            ),
          ),
          // Dikeyde 10 boşluk bırakır
          const SizedBox(height: 10),
          // Kayıt bilgilerini yan yana gösterir
          const Row(
            children: [
              // Kilit simgesini gösterir
              Icon(Icons.lock_outline_rounded, size: 16, color: Palette.moss),
              // Yatayda 7 boşluk bırakır
              SizedBox(width: 7),
              // Yazının kalan alanı kullanmasını sağlar
              Expanded(
                child: Text(
                  'Bu cihazda saklanır. Buluta gönderilmez.',
                  style: TextStyle(color: Palette.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  // Girilen kelimenin önizleme kartını oluşturur
  Widget _previewPanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Önizleme için kutu oluşturur
      Container(
        // Arka plan rengini ve köşeleri ayarlar
        decoration: BoxDecoration(
          color: Palette.coralLight,
          borderRadius: BorderRadius.circular(16),
        ),
        // Kutunun iç boşluklarını belirler
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        // Önizleme elemanlarını alt alta dizer
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Önizleme başlığını gösterir
            const Kicker('KARTIN ÖNİZLEMESİ'),
            // Dikeyde 8 boşluk bırakır
            const SizedBox(height: 8),
            // Kartın açıklama başlığını gösterir
            const Text(
              'Daha kaydetmeden\nnasıl görünecek?',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Palette.ink,
              ),
            ),
            // Dikeyde 20 boşluk bırakır
            const SizedBox(height: 20),
            // Kelime kartını oluşturur
            Container(
              // Kartı genişliğe yayar
              width: double.infinity,
              // Kartın iç boşluklarını belirler
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 23),
              // Kartın arka plan ve kenarlık ayarları
              decoration: BoxDecoration(
                color: Palette.paper,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Palette.border),
              ),
              // Kart içindeki elemanları alt alta dizer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dil ve kart bilgisini yan yana gösterir
                  Row(
                    children: [
                      // Seçilen dilin rozetini gösterir
                      LanguageBadge(language: _language),
                      // İki elemanın arasını açar
                      const Spacer(),
                      // Kartın not bilgisini gösterir
                      const Text(
                        '01 / NOT',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          color: Palette.muted,
                        ),
                      ),
                    ],
                  ),
                  // Dikeyde 27 boşluk bırakır
                  const SizedBox(height: 27),
                  // Kelime girilmişse onu, boşsa örnek metni gösterir
                  Text(
                    _wordController.text.trim().isEmpty
                        ? 'Dein Wort…'
                        : _wordController.text.trim(),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 29,
                      color: Palette.ink,
                    ),
                  ),
                  // Dikeyde 8 boşluk bırakır
                  const SizedBox(height: 8),
                  // Anlam girilmişse onu, boşsa ipucunu gösterir
                  Text(
                    _meaningController.text.trim().isEmpty
                        ? 'Anlamı burada görünecek'
                        : _meaningController.text.trim(),
                    style: const TextStyle(color: Palette.muted, fontSize: 14),
                  ),
                  // Örnek cümle boş değilse altındaki elemanları gösterir
                  if (_exampleController.text.trim().isNotEmpty) ...[
                    // Dikeyde 22 boşluk bırakır
                    const SizedBox(height: 22),
                    // Ayırıcı çizgi oluşturur
                    const Divider(),
                    // Dikeyde 8 boşluk bırakır
                    const SizedBox(height: 8),
                    // Girilen örnek cümleyi italik gösterir
                    Text(
                      '“${_exampleController.text.trim()}”',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontStyle: FontStyle.italic,
                        color: Palette.ink,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  // Dikeyde 24 boşluk bırakır
                  const SizedBox(height: 24),
                  // Kartın altındaki logo ve yazıyı yan yana dizer
                  const Row(
                    children: [
                      // Kitap simgesini gösterir
                      Icon(
                        Icons.auto_stories_outlined,
                        size: 16,
                        color: Palette.terracotta,
                      ),
                      // Yatayda 7 boşluk bırakır
                      SizedBox(width: 7),
                      // Uygulamanın adını gösterir
                      Text(
                        'DİL ROTASI',
                        style: TextStyle(
                          letterSpacing: 1.8,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Palette.terracotta,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Önizleme altında 15 boşluk bırakır
      const SizedBox(height: 15),
      // İpucu mesajını panel içinde gösterir
      const SurfacePanel(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ampul simgesini gösterir
            Icon(Icons.lightbulb_outline_rounded, color: Palette.terracotta),
            // Yatayda 11 boşluk bırakır
            SizedBox(width: 11),
            // İpucu metnini kalan alana yayar
            Expanded(
              child: Text(
                'İpucu: Bir kelimenin yanına kendi örnek cümleni yazmak, onu hatırlamanı kolaylaştırabilir.',
                style: TextStyle(fontSize: 13, color: Palette.muted),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Dil seçme butonunu oluşturan sınıf
class _LanguageOption extends StatelessWidget {
  // Constructor, dil ve tıklama bilgilerini zorunlu alır
  const _LanguageOption({
    required this.language,
    required this.selected,
    required this.onTap,
  });
  // Hangi dil olduğunu tutar
  final StudyLanguage language;
  // Seçili olup olmadığını tutar
  final bool selected;
  // Basılınca çalışacak callback
  final VoidCallback onTap;
  // Üstteki build metodunu yeniden yazar
  @override
  // Dil butonunun arayüzünü oluşturur
  Widget build(BuildContext context) => Material(
    // Seçiliyse koyu, değilse açık renk kullanır
    color: selected ? Palette.forest : Palette.parchment,
    // Butonun kenarlık ve köşe şeklini ayarlar
    shape: RoundedRectangleBorder(
      // Köşeleri yuvarlar
      borderRadius: BorderRadius.circular(10),
      // Seçili olmasına göre kenarlık rengini belirler
      side: BorderSide(color: selected ? Palette.forest : Palette.border),
    ),
    // Butona tıklama özelliği verir
    child: InkWell(
      // Tıklanınca gönderilen callback çalışır
      onTap: onTap,
      // Tıklama alanının köşelerini yuvarlar
      borderRadius: BorderRadius.circular(10),
      // Butonun iç boşluklarını ayarlar
      child: Padding(
        // Yatayda 15 dikeyde 12 boşluk bırakır
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        // Bayrak ve dil adını yan yana dizer
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Seçilen dilin bayrağını gösterir
            Text(language.flag, style: const TextStyle(fontSize: 17)),
            // Yatayda 8 boşluk bırakır
            const SizedBox(width: 8),
            // Dil adını gösterir, seçiliyse yazı rengi değişir
            Text(
              language.label,
              style: TextStyle(
                color: selected ? Palette.paper : Palette.ink,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            // Seçili dil için tik simgesi gösterir
            if (selected) ...[
              // Yatayda 9 boşluk bırakır
              const SizedBox(width: 9),
              // Seçili olduğunu gösteren tik simgesi
              const Icon(Icons.check_rounded, size: 17, color: Palette.olive),
            ],
          ],
        ),
      ),
    ),
  );
}

// Form alanlarının başlığını oluşturan sınıf
class _FieldLabel extends StatelessWidget {
  // Constructor, başlık alır zorunluluk bilgisi isteğe bağlıdır
  const _FieldLabel(this.title, {this.mandatory = false});
  // Alanın başlık metnini tutar
  final String title;
  // Alanın zorunlu olup olmadığını tutar
  final bool mandatory;
  // Üstteki build metodunu yeniden yazar
  @override
  // Başlık ve zorunluluk işaretini birlikte gösterir
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        // Alanın başlığını yazdırır
        TextSpan(
          text: title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.ink,
            fontSize: 13,
          ),
        ),
        // Zorunluysa başlığın yanına yıldız ekler
        if (mandatory)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Palette.terracotta),
          ),
      ],
    ),
  );
}

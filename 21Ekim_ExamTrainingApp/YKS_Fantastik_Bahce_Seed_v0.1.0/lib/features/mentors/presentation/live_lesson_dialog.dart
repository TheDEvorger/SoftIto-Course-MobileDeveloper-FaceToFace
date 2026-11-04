// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// garden palette dosyasını kullanıma ekler
import '../../../core/theme/garden_palette.dart';
// rehber karakter dosyasını kullanıma ekler
import '../domain/mentor.dart';
// mentor ai servis dosyasını kullanıma ekler
import '../domain/mentor_ai_service.dart';
// live lesson pencere için değişen verileri yöneten StatefulWidget kullanılır
class LiveLessonDialog extends StatefulWidget {
  // live lesson pencere penceresini oluşturur
  const LiveLessonDialog({required this.mentor, super.key});
  // rehber karakter bilgisini tutar
  final FantasyMentor mentor;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Değerleri karşılaştırır
  State<LiveLessonDialog> createState() => _LiveLessonDialogState();
}
// Ekranın değişen verilerini yöneten State sınıfı
class _LiveLessonDialogState extends State<LiveLessonDialog> {
  // soru controller metnini yönetir
  final TextEditingController _questionController = TextEditingController();
  // chat history için boş koleksiyon oluşturur
  final List<_ChatMessage> _chatHistory = [];
  // is consulting ai durumunu başlangıçta belirler
  bool _isConsultingAi = false;
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Widget ilk oluşturulduğunda bir kez çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // İlgili fonksiyonu çalıştırır
    _chatHistory.addAll([
      // İlgili fonksiyonu çalıştırır
      _ChatMessage(
        // sender bilgisini belirler
        sender: widget.mentor.name,
        // Gösterilecek metni belirler
        text: 'Kadim Akademi dersimize hoş geldin genç yolcu! ${widget.mentor.catchphrase}',
        // is mentor bilgisini belirler
        isMentor: true,
      ),
      // chat message sınıfının constructorı
      const _ChatMessage(
        // sender bilgisini belirler
        sender: 'Sınav Yolcusu (Mert)',
        // Gösterilecek metni belirler
        text: 'Hocam türev teğet eğimi sorusu geldiğinde ne yapıyoruz?',
        // is mentor bilgisini belirler
        isMentor: false,
      ),
      // İlgili fonksiyonu çalıştırır
      _ChatMessage(
        // sender bilgisini belirler
        sender: widget.mentor.name,
        // Gösterilecek metni belirler
        text: 'Mert, harika bir soru! Şimdi tahtadaki ışık rünlerine odaklanın.',
        // is mentor bilgisini belirler
        isMentor: true,
      ),
    ]);
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Kullanılan kaynakları temizler
  void dispose() {
    // Kullanılan kaynakları temizler
    _questionController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }
  // soru bilgisini sorar
  Future<void> _askQuestion(String question) async {
    // metin bilgisini hesaplayıp saklar
    final text = question.trim();
    // Liste veya metin boşsa bu koşul çalışır
    if (text.isEmpty) return;
    // clear işlemini yapar
    _questionController.clear();
    // Değişen verileri arayüze bildirir
    setState(() {
      // add işlemini yapar
      _chatHistory.add(_ChatMessage(sender: 'Sen', text: text, isMentor: false));
      // is consulting ai değerini günceller
      _isConsultingAi = true;
    });
    // Hata oluşturabilecek işlemleri dener
    try {
      // response verisini asenkron işlemin sonucundan alır
      final response = await MentorAiService.instance.askMentor(
        // rehber karakter bilgisini belirler
        mentor: widget.mentor,
        // kullanıcı sorusu bilgisini belirler
        userQuestion: text,
      );
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) {
        // Değişen verileri arayüze bildirir
        setState(() {
          // is consulting ai değerini günceller
          _isConsultingAi = false;
          // İlgili fonksiyonu çalıştırır
          _chatHistory.add(
            // İlgili fonksiyonu çalıştırır
            _ChatMessage(
              // sender bilgisini belirler
              sender: widget.mentor.name,
              // Gösterilecek metni belirler
              text: response.reply,
              // is mentor bilgisini belirler
              isMentor: true,
              // tactic highlight bilgisini belirler
              tacticHighlight: response.spellTactic,
            ),
          );
        });
      }
    // İşlem sırasında hata oluşursa burası çalışır
    } catch (_) {
      // Widget hâlâ ekrandaysa işlemi yapar
      if (mounted) setState(() => _isConsultingAi = false);
    }
  }
  // Üst sınıftaki metodu yeniden tanımlar
  @override
  // Ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // koyu tema durumu bilgisini aktif temadan alır
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // ana renk bilgisini hesaplayıp saklar
    const primary = GardenPalette.mossEmerald;
    // Açılır pencere oluşturur
    return Dialog(
      // inset padding bilgisini belirler
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      // Arka plan rengini belirler
      backgroundColor: isDark ? const Color(0xFF141E18) : Colors.white,
      // Widgetın kenar şeklini belirler
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      // İçine yerleştirilecek widgetı belirler
      child: ClipRRect(
        // Köşelerin yuvarlaklığını belirler
        borderRadius: BorderRadius.circular(24),
        // İçine yerleştirilecek widgetı belirler
        child: SizedBox(
          // Genişliği belirler
          width: 600,
          // Yüksekliği belirler
          height: 650,
          // İçine yerleştirilecek widgetı belirler
          child: Column(
            // İçerideki widgetları listeler
            children: [
              // Canlı Yayın Başlığı ve Canlı Rozeti
              // Görsel bir kutu oluşturur
              Container(
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                // Rengi belirler
                color: isDark ? const Color(0xFF0F1713) : GardenPalette.mossEmerald,
                // İçine yerleştirilecek widgetı belirler
                child: Row(
                  // İçerideki widgetları listeler
                  children: [
                    // Görsel bir kutu oluşturur
                    Container(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      // Kutu ve kenarlık görünümünü belirler
                      decoration: BoxDecoration(
                        // Rengi belirler
                        color: Colors.redAccent,
                        // Köşelerin yuvarlaklığını belirler
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // İçine yerleştirilecek widgetı belirler
                      child: const Row(
                        // İçerideki widgetları listeler
                        children: [
                          // Simge gösterir
                          Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          SizedBox(width: 4),
                          // Metni ekranda gösterir
                          Text(
                            // "CANLI AKADEMİ" metnini kullanır
                            'CANLI AKADEMİ',
                            // Görünüm stilini belirler
                            style: TextStyle(
                              // Rengi belirler
                              color: Colors.white,
                              // Yazı boyutunu belirler
                              fontSize: 10,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.bold,
                              // Harfler arasındaki boşluğu belirler
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(width: 8),
                    // Kalan boşluğu kullanacak alan oluşturur
                    Expanded(
                      // İçine yerleştirilecek widgetı belirler
                      child: Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        widget.mentor.liveLessonTitle,
                        // Görünüm stilini belirler
                        style: const TextStyle(
                          // Rengi belirler
                          color: Colors.white,
                          // Yazı boyutunu belirler
                          fontSize: 13,
                          // Yazı kalınlığını belirler
                          fontWeight: FontWeight.w600,
                        ),
                        // Gösterilecek en fazla satır sayısını belirler
                        maxLines: 1,
                        // Uzun yazının taşma şeklini belirler
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Simgeli buton oluşturur
                    IconButton(
                      // simge bilgisini belirler
                      icon: const Icon(Icons.close, color: Colors.white70),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Büyülü Canlı Ders Tahtası / Sahnesi
              // Elemanları üst üste yerleştirir
              Stack(
                // İçerideki widgetları listeler
                children: [
                  // Görsel bir kutu oluşturur
                  Container(
                    // Yüksekliği belirler
                    height: 180,
                    // Genişliği belirler
                    width: double.infinity,
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // görsel bilgisini belirler
                      image: DecorationImage(
                        // görsel bilgisini belirler
                        image: AssetImage(widget.mentor.avatarAsset),
                        // Görselin alana nasıl sığacağını belirler
                        fit: BoxFit.cover,
                        // İçeriğin hizalanmasını belirler
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Görsel bir kutu oluşturur
                  Container(
                    // Yüksekliği belirler
                    height: 180,
                    // Kutu ve kenarlık görünümünü belirler
                    decoration: BoxDecoration(
                      // Renk geçişini belirler
                      gradient: LinearGradient(
                        // renkler bilgisini belirler
                        colors: [
                          // Temadan renk veya görünüm değeri alır
                          Colors.black.withValues(alpha: 0.85),
                          // Temadan renk veya görünüm değeri alır
                          Colors.black.withValues(alpha: 0.2),
                          // Temadan renk veya görünüm değeri alır
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        // begin bilgisini belirler
                        begin: Alignment.topCenter,
                        // end bilgisini belirler
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Elemanı Stack içinde konumlandırır
                  Positioned(
                    // bottom bilgisini belirler
                    bottom: 12,
                    // left bilgisini belirler
                    left: 16,
                    // right bilgisini belirler
                    right: 16,
                    // İçine yerleştirilecek widgetı belirler
                    child: Column(
                      // Çapraz eksendeki hizalamayı belirler
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // İçerideki widgetları listeler
                      children: [
                        // Elemanları yan yana dizer
                        Row(
                          // İçerideki widgetları listeler
                          children: [
                            // Yuvarlak avatar alanı oluşturur
                            CircleAvatar(
                              // Yarıçapı belirler
                              radius: 18,
                              // background image bilgisini belirler
                              backgroundImage: AssetImage(widget.mentor.avatarAsset),
                            ),
                            // Sabit boyutlu veya boşluk bırakan alan oluşturur
                            const SizedBox(width: 8),
                            // Elemanları alt alta dizer
                            Column(
                              // Çapraz eksendeki hizalamayı belirler
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // İçerideki widgetları listeler
                              children: [
                                // Metni ekranda gösterir
                                Text(
                                  // İlgili değeri veya görünüm ayarını belirler
                                  widget.mentor.name,
                                  // Görünüm stilini belirler
                                  style: const TextStyle(
                                    // Rengi belirler
                                    color: Colors.white,
                                    // Yazı kalınlığını belirler
                                    fontWeight: FontWeight.bold,
                                    // Yazı boyutunu belirler
                                    fontSize: 14,
                                  ),
                                ),
                                // Metni ekranda gösterir
                                Text(
                                  // İlgili değeri veya görünüm ayarını belirler
                                  widget.mentor.title,
                                  // Görünüm stilini belirler
                                  style: TextStyle(
                                    // Rengi belirler
                                    color: Colors.amber.shade200,
                                    // Yazı boyutunu belirler
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                        const SizedBox(height: 6),
                        // Metni ekranda gösterir
                        Text(
                          // "🔮 Büyülü Taktik: ${widget.mentor.catchphrase}" metnini kullanır
                          '🔮 Büyülü Taktik: ${widget.mentor.catchphrase}',
                          // Görünüm stilini belirler
                          style: const TextStyle(
                            // Rengi belirler
                            color: Colors.white70,
                            // Yazının italik olup olmadığını belirler
                            fontStyle: FontStyle.italic,
                            // Yazı boyutunu belirler
                            fontSize: 11,
                          ),
                          // Gösterilecek en fazla satır sayısını belirler
                          maxLines: 1,
                          // Uzun yazının taşma şeklini belirler
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Canlı Sohbet ve AI Soru-Cevap Akışı
              // Kalan boşluğu kullanacak alan oluşturur
              Expanded(
                // İçine yerleştirilecek widgetı belirler
                child: ListView.builder(
                  // İç boşlukları belirler
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // Listede gösterilecek öğe sayısını belirler
                  itemCount: _chatHistory.length + (_isConsultingAi ? 1 : 0),
                  // Her liste elemanının nasıl gösterileceğini belirler
                  itemBuilder: (context, index) {
                    // Belirtilen koşul doğruysa işlemi yapar
                    if (index == _chatHistory.length && _isConsultingAi) {
                      // İç boşluk ekler
                      return Padding(
                        // İç boşlukları belirler
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        // İçine yerleştirilecek widgetı belirler
                        child: Row(
                          // İçerideki widgetları listeler
                          children: [
                            // Yuvarlak avatar alanı oluşturur
                            CircleAvatar(
                              // Yarıçapı belirler
                              radius: 14,
                              // background image bilgisini belirler
                              backgroundImage: AssetImage(widget.mentor.avatarAsset),
                            ),
                            // Sabit boyutlu veya boşluk bırakan alan oluşturur
                            const SizedBox(width: 8),
                            // Görsel bir kutu oluşturur
                            Container(
                              // İç boşlukları belirler
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              // Kutu ve kenarlık görünümünü belirler
                              decoration: BoxDecoration(
                                // Rengi belirler
                                color: primary.withValues(alpha: 0.12),
                                // Köşelerin yuvarlaklığını belirler
                                borderRadius: BorderRadius.circular(16),
                              ),
                              // İçine yerleştirilecek widgetı belirler
                              child: const Row(
                                // Ana eksende kaplanacak alanı belirler
                                mainAxisSize: MainAxisSize.min,
                                // İçerideki widgetları listeler
                                children: [
                                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                  SizedBox(
                                    // Genişliği belirler
                                    width: 12,
                                    // Yüksekliği belirler
                                    height: 12,
                                    // İçine yerleştirilecek widgetı belirler
                                    child: CircularProgressIndicator(strokeWidth: 2, color: primary),
                                  ),
                                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                  SizedBox(width: 8),
                                  // Metni ekranda gösterir
                                  Text(
                                    // "Büyü rünleri fısıldanıyor..." metnini kullanır
                                    'Büyü rünleri fısıldanıyor...',
                                    // Görünüm stilini belirler
                                    style: TextStyle(color: primary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    // msg bilgisini hesaplayıp saklar
                    final msg = _chatHistory[index];
                    // İç boşluk ekler
                    return Padding(
                      // İç boşlukları belirler
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      // İçine yerleştirilecek widgetı belirler
                      child: Column(
                        // Çapraz eksendeki hizalamayı belirler
                        crossAxisAlignment:
                            // Koşula göre iki değerden birini seçer
                            msg.isMentor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        // İçerideki widgetları listeler
                        children: [
                          // Metni ekranda gösterir
                          Text(
                            // İlgili değeri veya görünüm ayarını belirler
                            msg.sender,
                            // Görünüm stilini belirler
                            style: TextStyle(
                              // Yazı boyutunu belirler
                              fontSize: 10,
                              // Yazı kalınlığını belirler
                              fontWeight: FontWeight.bold,
                              // Rengi belirler
                              color: msg.isMentor
                                  // Koşul doğruysa bu değeri kullanır
                                  ? (isDark ? Colors.amber.shade300 : GardenPalette.mossEmerald)
                                  // Koşul yanlışsa bu değeri kullanır
                                  : Colors.grey,
                            ),
                          ),
                          // Sabit boyutlu veya boşluk bırakan alan oluşturur
                          const SizedBox(height: 2),
                          // Görsel bir kutu oluşturur
                          Container(
                            // constraints bilgisini belirler
                            constraints: const BoxConstraints(maxWidth: 380),
                            // İç boşlukları belirler
                            padding: const EdgeInsets.all(12),
                            // Kutu ve kenarlık görünümünü belirler
                            decoration: BoxDecoration(
                              // Rengi belirler
                              color: msg.isMentor
                                  // Koşul doğruysa bu değeri kullanır
                                  ? (isDark ? const Color(0xFF1E2D24) : const Color(0xFFEAF5EE))
                                  // Koşul yanlışsa bu değeri kullanır
                                  : primary.withValues(alpha: 0.15),
                              // Köşelerin yuvarlaklığını belirler
                              borderRadius: BorderRadius.circular(16),
                              // Kenarlığı belirler
                              border: Border.all(
                                // Rengi belirler
                                color: msg.isMentor ? primary.withValues(alpha: 0.3) : Colors.transparent,
                              ),
                            ),
                            // İçine yerleştirilecek widgetı belirler
                            child: Column(
                              // Çapraz eksendeki hizalamayı belirler
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // İçerideki widgetları listeler
                              children: [
                                // Metni ekranda gösterir
                                Text(
                                  // İlgili değeri veya görünüm ayarını belirler
                                  msg.text,
                                  // Görünüm stilini belirler
                                  style: TextStyle(
                                    // Yazı boyutunu belirler
                                    fontSize: 13,
                                    // Yüksekliği belirler
                                    height: 1.35,
                                    // Rengi belirler
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                // İlgili değer null değilse kontrol eder
                                if (msg.tacticHighlight != null) ...[
                                  // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                  const SizedBox(height: 8),
                                  // Görsel bir kutu oluşturur
                                  Container(
                                    // İç boşlukları belirler
                                    padding: const EdgeInsets.all(8),
                                    // Kutu ve kenarlık görünümünü belirler
                                    decoration: BoxDecoration(
                                      // Rengi belirler
                                      color: Colors.amber.withValues(alpha: 0.15),
                                      // Köşelerin yuvarlaklığını belirler
                                      borderRadius: BorderRadius.circular(8),
                                      // Kenarlığı belirler
                                      border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                                    ),
                                    // İçine yerleştirilecek widgetı belirler
                                    child: Row(
                                      // İçerideki widgetları listeler
                                      children: [
                                        // Simge gösterir
                                        const Icon(Icons.auto_awesome, color: Colors.amber, size: 14),
                                        // Sabit boyutlu veya boşluk bırakan alan oluşturur
                                        const SizedBox(width: 6),
                                        // Kalan boşluğu kullanacak alan oluşturur
                                        Expanded(
                                          // İçine yerleştirilecek widgetı belirler
                                          child: Text(
                                            // "Mühür Tavsiye: ${msg.tacticHighlight}" metnini kullanır
                                            'Mühür Tavsiye: ${msg.tacticHighlight}',
                                            // Görünüm stilini belirler
                                            style: const TextStyle(
                                              // Yazı boyutunu belirler
                                              fontSize: 11,
                                              // Yazı kalınlığını belirler
                                              fontWeight: FontWeight.w600,
                                              // Rengi belirler
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Hızlı Örnek Sorular Çubuğu
              // Görsel bir kutu oluşturur
              Container(
                // Yüksekliği belirler
                height: 40,
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 12),
                // İçine yerleştirilecek widgetı belirler
                child: ListView.separated(
                  // Kaydırma yönünü belirler
                  scrollDirection: Axis.horizontal,
                  // Listede gösterilecek öğe sayısını belirler
                  itemCount: widget.mentor.suggestedQuestions.length,
                  // Liste elemanları arasındaki ayırıcıyı oluşturur
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  // Her liste elemanının nasıl gösterileceğini belirler
                  itemBuilder: (context, i) {
                    // q bilgisini hesaplayıp saklar
                    final q = widget.mentor.suggestedQuestions[i];
                    // action chip nesnesini oluşturur
                    return ActionChip(
                      // Buton veya alan yazısını belirler
                      label: Text(
                        // İlgili değeri veya görünüm ayarını belirler
                        q,
                        // Görünüm stilini belirler
                        style: TextStyle(
                          // Yazı boyutunu belirler
                          fontSize: 11,
                          // Rengi belirler
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      // Arka plan rengini belirler
                      backgroundColor: isDark ? const Color(0xFF1D2A22) : const Color(0xFFF0F4F1),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => _askQuestion(q),
                    );
                  },
                ),
              ),
              // Mesaj & Soru Gönderme Alanı
              // Görsel bir kutu oluşturur
              Container(
                // İç boşlukları belirler
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                // Rengi belirler
                color: isDark ? const Color(0xFF0F1713) : const Color(0xFFF6FAF7),
                // İçine yerleştirilecek widgetı belirler
                child: Row(
                  // İçerideki widgetları listeler
                  children: [
                    // Kalan boşluğu kullanacak alan oluşturur
                    Expanded(
                      // İçine yerleştirilecek widgetı belirler
                      child: TextField(
                        // Veriyi yöneten controllerı bağlar
                        controller: _questionController,
                        // Metin gönderilince çalışacak fonksiyonu belirler
                        onSubmitted: _askQuestion,
                        // Kutu ve kenarlık görünümünü belirler
                        decoration: InputDecoration(
                          // Giriş alanında ipucu gösterir
                          hintText: '${widget.mentor.name}\'a YKS sorusu sor...',
                          // hint style bilgisini belirler
                          hintStyle: const TextStyle(fontSize: 12),
                          // content padding bilgisini belirler
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          // is dense bilgisini belirler
                          isDense: true,
                          // filled bilgisini belirler
                          filled: true,
                          // İç dolgu rengini belirler
                          fillColor: isDark ? const Color(0xFF1A261F) : Colors.white,
                          // Kenarlığı belirler
                          border: const OutlineInputBorder(
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            // Kenarlığın rengini ve kalınlığını belirler
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // Sabit boyutlu veya boşluk bırakan alan oluşturur
                    const SizedBox(width: 8),
                    // Simgeli buton oluşturur
                    IconButton(
                      // simge bilgisini belirler
                      icon: const Icon(Icons.send_rounded, color: primary),
                      // Basılınca çalışacak fonksiyonu belirler
                      onPressed: () => _askQuestion(_questionController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// chat message bilgilerini veya işlemlerini tutan sınıf
class _ChatMessage {
  // chat message sınıfının constructorı
  const _ChatMessage({
    // sender bilgisini zorunlu tutar
    required this.sender,
    // metin bilgisini zorunlu tutar
    required this.text,
    // is mentor bilgisini zorunlu tutar
    required this.isMentor,
    // tactic highlight bilgisini isteğe bağlı alır
    this.tacticHighlight,
  });
  // sender bilgisini tutar
  final String sender;
  // metin bilgisini tutar
  final String text;
  // is mentor bilgisini tutar
  final bool isMentor;
  // tactic highlight bilgisini tutar
  final String? tacticHighlight;
}

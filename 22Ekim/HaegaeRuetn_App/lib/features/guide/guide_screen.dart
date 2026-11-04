// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Sohbet controllerını projeye ekler
import '../../core/services/ai/ai_chat_controller.dart';
// Sohbet mesajı modelini projeye ekler
import '../../core/services/ai/ai_message.dart';
// Rehber kişiliklerini projeye ekler
import '../../core/services/ai/ai_persona.dart';
// Worker üzerinden mesajlaşma servisini projeye ekler
import '../../core/services/ai/groq_ai_repository.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Krallık tema ayarlarını projeye ekler
import '../../core/theme/realm_theme.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Ortak krallık kartlarını projeye ekler
import '../../core/widgets/realm_card.dart';
// Rehber ayarları panelini projeye ekler
import 'guide_settings_sheet.dart';
// AI ahit önerisi kartını projeye ekler
import 'pact_suggestion_card.dart';
// Bilge Rehber screen connected to GroqCloud via Cloudflare Worker proxy,
// Bağlantı olmadığında kullanılacak işlemi hazırlar
// AI sohbet mesajlarını ve ahit önerilerini gösterir
class GuideScreen extends StatefulWidget {
  // GuideScreen nesnesinin başlangıç bilgilerini alır
  const GuideScreen({
    // Widgetın key bilgisini üst sınıfa aktarır
    super.key,
    // controller için isteğe bağlı başlangıç değeri alır
    this.controller,
    // sohbet controller için isteğe bağlı başlangıç değeri alır
    this.chatController,
  });
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController? controller;
  // Rehber sohbetini yöneten isteğe bağlı controllerı tutar
  final AiChatController? chatController;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<GuideScreen> createState() => _GuideScreenState();
}
// guide screen state bilgilerini ve ilgili davranışları tanımlar
class _GuideScreenState extends State<GuideScreen> {
  // Bu widgetın durumunu yönetecek controllerı oluşturur
  final _textController = TextEditingController();
  // Bu widgetın durumunu yönetecek controllerı oluşturur
  final _scrollController = ScrollController();
  // Sohbet mesajlarını yöneten controllerı tutar
  late final AiChatController _chat;
  // Sohbet controllerının bu ekranda oluşturulduğunu belirtir
  bool _ownsChatController = false;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // init state için gerekli sonucu hesaplar
  void initState() {
    // Üst sınıfın başlangıç işlemlerini çalıştırır
    super.initState();
    // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
    if (widget.chatController != null) {
      // sohbet bilgisini yeni değeriyle günceller
      _chat = widget.chatController!;
    // Önceki koşul sağlanmazsa bu yolu kullanır
    } else {
      // sohbet bilgisini yeni değeriyle günceller
      _chat = AiChatController();
      // owns sohbet controller bilgisini yeni değeriyle günceller
      _ownsChatController = true;
      // Sohbet bağlantısını ve kayıtlı tercihleri yükler
      _chat.initialize();
    }
    // Yeni sohbet mesajlarında ekranı güncelleyecek dinleyiciyi ekler
    _chat.addListener(_onChatUpdated);
  }
  // Sohbet değişince ekranı güncelleyip son mesaja kaydırır
  void _onChatUpdated() {
    // Widget ekrandan kalktıysa işlemi durdurur
    if (!mounted) return;
    // Değişen bilgiyi ekrana yansıtmak için Statei günceller
    setState(() {});
    // Yeni mesaj geldiğinde sohbet listesini en alta kaydırır
    _scrollToBottom();
  }
  // Yeni mesaj geldiğinde sohbet listesini en alta kaydırır
  void _scrollToBottom() {
    // Kaydırma işlemini ekran çizimi bittikten sonra yapar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Belirtilen koşul sağlanırsa bu işlemi uygular
      if (_scrollController.hasClients) {
        // Kaydırma listesini hedef konuma animasyonla taşır
        _scrollController.animateTo(
          // Sohbet listesinin en alt kaydırma konumunu kullanır
          _scrollController.position.maxScrollExtent,
          // Animasyonun veya zaman aşımının süresini belirler
          duration: const Duration(milliseconds: 300),
          // Animasyonun hız değişimini belirler
          curve: Curves.easeOut,
        );
      }
    });
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Ekran kapanırken sohbet dinleyicisini kaldırır
    _chat.removeListener(_onChatUpdated);
    // Belirtilen koşul sağlanırsa bu işlemi uygular
    if (_ownsChatController) {
      // Bu ekranda oluşturulan sohbet controllerını kapatır
      _chat.dispose();
    }
    // Mesaj yazma controllerını serbest bırakır
    _textController.dispose();
    // Sohbet kaydırma controllerını serbest bırakır
    _scrollController.dispose();
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Boş olmayan mesajı rehbere gönderip yazı alanını temizler
  void _send() {
    // Kullanıcının yazdığı metni düzenlemeye hazırlar
    final text = _textController.text.trim();
    // Gerekli liste ya da metin boşsa işlem yapmaz
    if (text.isEmpty) return;
    // Gönderilen metni yazı alanından temizler
    _textController.clear();
    // Mesajı ve varsa krallık verisini rehbere iletir
    _chat.sendMessage(text, widget.controller);
  }
  // Rehber ayarlarını alt panelde açar
  void _openSettings() {
    // Sonraki satırlardan gelecek parametreleri alır
    showModalBottomSheet<void>(
      // İşlemin çalıştığı widget bağlamını gönderir
      context: context,
      // Alt panelin ekranı daha fazla kaplamasına izin verir
      isScrollControlled: true,
      // Alt panelin tutma çizgisini gösterir
      showDragHandle: true,
      // Arka plan rengini belirler
      backgroundColor: const Color(0xFFF9F5EC),
      // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
      builder: (_) => GuideSettingsSheet(controller: _chat),
    );
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _GuideScreenState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // AI yanıtının kullanılacağı rehber kişiliğini tutar
    final persona = _chat.currentPersona;
    // Elemanları dikey yönde sıralar
    return Column(
      // İçeride sıralanacak widgetları listeler
      children: [
        // İçeriğin kalan alanı doldurmasını sağlar
        Expanded(
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: ListView(
            // Metin veya liste kontrolcüsünü ilgili alana bağlar
            controller: _scrollController,
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            // İçeride sıralanacak widgetları listeler
            children: [
              // FancyHeroHeader nesnesinin başlangıç bilgilerini alır
              const FancyHeroHeader(
                // başlık alanına gösterilecek metni belirler
                title: 'Bilge Rehber',
                // subtitle alanına değerini belirler
                subtitle:
                    // Gösterilecek veya kullanılacak metin parçasını ekler
                    'Ałek’ryŧhæ kadim arşivi, yapay zekâ danışmanı ve yol arkadaşın.',
                // Gösterilecek görselin dosya yolunu belirler
                assetPath: ArtAssets.guide,
                // Elemanın veya satırın yüksekliğini ayarlar
                height: 185,
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 12),
              // Bağlantı durumu ve ayarlar butonunu yan yana gösterir
              // Elemanları yatay yönde sıralar
              Row(
                // İçeride sıralanacak widgetları listeler
                children: [
                  // İçeriğin kalan alanı doldurmasını sağlar
                  Expanded(
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: _chat.isCloudConnected
                        // Koşul doğruysa kullanılacak sonucu belirler
                        ? const RealmPill(
                            // Butonun ya da etiketin görünen yazısını belirler
                            label:
                                // Gösterilecek veya kullanılacak metin parçasını ekler
                                'Bulut AI Aktif • ${GroqAiRepository.primaryModel}',
                            // Buton veya kartta kullanılacak simgeyi seçer
                            icon: Icons.cloud_done_rounded,
                            // Bu elemanın rengini belirler
                            color: Color(0xFFE2F4EA),
                          )
                        // Koşul yanlışsa kullanılacak sonucu belirler
                        : const RealmPill(
                            // Butonun ya da etiketin görünen yazısını belirler
                            label: 'Çevrimdışı Prototip • Worker URL ekleyin',
                            // Buton veya kartta kullanılacak simgeyi seçer
                            icon: Icons.cloud_off_rounded,
                            // Bu elemanın rengini belirler
                            color: Color(0xFFFFE8C7),
                          ),
                  ),
                  // Belirtilen ölçülerde boşluk veya alan oluşturur
                  const SizedBox(width: 8),
                  // Arka plan ve ölçüleri olan bir kutu oluşturur
                  Container(
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Rengin saydamlığını belirtilen oranda ayarlar
                      color: Colors.white.withValues(alpha: 0.9),
                      // Kutunun veya butonun geometrik biçimini belirler
                      shape: BoxShape.circle,
                      // Kutunun kenarlık çizgisini oluşturur
                      border: Border.all(color: const Color(0xFFDCC898)),
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: IconButton(
                      // Buton veya kartta kullanılacak simgeyi seçer
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      // Butonun açıklama metnini gösterir
                      tooltip: 'Rehber Ayarları',
                      // Bu elemanın rengini belirler
                      color: RealmPalette.ink,
                      // Butona basılınca çalışacak fonksiyonu bağlar
                      onPressed: _openSettings,
                    ),
                  ),
                ],
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 10),
              // Rehber kişiliklerini seçim butonlarıyla gösterir
              // Sığmayan öğeleri bir sonraki satıra geçirir
              Wrap(
                // spacing alanına 7 değerini kullanır
                spacing: 7,
                // İçeride sıralanacak widgetları listeler
                children: AiPersona.all.map((p) {
                  // seçilenler bilgisini saklar
                  final isSelected = _chat.personaType == p.type;
                  // Seçilebilir küçük filtre butonu oluşturur
                  return ChoiceChip(
                    // avatar alanına gelen değeri kullanır
                    avatar: Icon(
                      // Seçilen rehber kişiliğinin simgesini gösterir
                      p.icon,
                      // Simgenin veya şeklin boyutunu belirler
                      size: 16,
                      // Bu elemanın rengini belirler
                      color: isSelected ? Colors.white : p.primaryColor,
                    ),
                    // Butonun ya da etiketin görünen yazısını belirler
                    label: Text(p.name),
                    // Öğenin aktif seçili durumda olup olmadığını belirler
                    selected: isSelected,
                    // seçilenler color alanına gelen değeri kullanır
                    selectedColor: p.primaryColor,
                    // Etiket yazısının stilini belirler
                    labelStyle: TextStyle(
                      // Yazının kalınlığını belirler
                      fontWeight: FontWeight.w800,
                      // Bu elemanın rengini belirler
                      color: isSelected ? Colors.white : RealmPalette.ink,
                    ),
                    // Seçim yapıldığında çalışacak fonksiyonu bağlar
                    onSelected: (_) => _chat.setPersona(p.type),
                  );
                // Dönüştürülen öğeleri yeni liste hâline getirir
                }).toList(),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 14),
              // Önceki sohbet mesajlarını listeler
              // Aynı nesnede ek çizim ayarını yapar
              ..._chat.messages.map((m) => _buildMessageBubble(m, persona)),
              // AI yanıtı beklenirken yükleme simgesi gösterir
              // AI yanıtı bekleniyorsa yükleme durumunu gösterir
              if (_chat.isLoading) ...[
                // İçeriği belirtilen yöne hizalar
                Align(
                  // İçeriğin hangi tarafa hizalanacağını belirler
                  alignment: Alignment.centerLeft,
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Container(
                    // Bileşenin dışındaki boşluğu belirler
                    margin: const EdgeInsets.only(bottom: 12),
                    // İçeriğin kenarlara olan uzaklığını ayarlar
                    padding: const EdgeInsets.symmetric(
                        // horizontal alanına 14, vertical: 10) değerini kullanır
                        horizontal: 14, vertical: 10),
                    // Kutunun arka plan, kenar ve süslerini ayarlar
                    decoration: BoxDecoration(
                      // Rengin saydamlığını belirtilen oranda ayarlar
                      color: Colors.white.withValues(alpha: 0.92),
                      // Köşelerin yuvarlaklığını belirler
                      borderRadius: BorderRadius.circular(18),
                      // Kutunun kenarlık çizgisini oluşturur
                      border: Border.all(color: const Color(0xFFDFC57C)),
                    ),
                    // Bu widgetın içinde gösterilecek elemanı yerleştirir
                    child: Row(
                      // Ana yönde kaplanacak alanı belirler
                      mainAxisSize: MainAxisSize.min,
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // Belirtilen ölçülerde boşluk veya alan oluşturur
                        SizedBox(
                          // Elemanın genişliğini belirler
                          width: 14,
                          // Elemanın veya satırın yüksekliğini ayarlar
                          height: 14,
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: CircularProgressIndicator(
                            // Çizgi veya halka kalınlığını belirler
                            strokeWidth: 2,
                            // value color alanına değerini belirler
                            valueColor:
                                // always stopped animation bileşenini oluşturur
                                AlwaysStoppedAnimation(persona.primaryColor),
                          ),
                        ),
                        // Belirtilen ölçülerde boşluk veya alan oluşturur
                        const SizedBox(width: 10),
                        // Ekrana metin yerleştirir
                        Text(
                          // Gösterilecek veya kullanılacak metin parçasını ekler
                          '${persona.name} düşünüyor...',
                          // Yazının ya da butonun görünümünü belirler
                          style: TextStyle(
                            // Yazının boyutunu belirler
                            fontSize: 12.5,
                            // Yazının kalınlığını belirler
                            fontWeight: FontWeight.w700,
                            // Bu elemanın rengini belirler
                            color: persona.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Sohbetin mesaj yazma alanını oluşturur
        // İçeriğin çevresine boşluk ekler
        Padding(
          // İçeriğin kenarlara olan uzaklığını ayarlar
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Row(
            // İçeride sıralanacak widgetları listeler
            children: [
              // İçeriğin kalan alanı doldurmasını sağlar
              Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: TextField(
                  // Metin veya liste kontrolcüsünü ilgili alana bağlar
                  controller: _textController,
                  // Metin alanının en az kaç satır olacağını belirler
                  minLines: 1,
                  // Metnin veya giriş alanının en fazla satır sayısını belirler
                  maxLines: 3,
                  // Klavyeden gönderildiğinde çalışacak fonksiyonu bağlar
                  onSubmitted: (_) => _send(),
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: InputDecoration(
                    // Alan boşken kullanıcıya örnek giriş metnini gösterir
                    hintText: '${persona.name} ile konuş...',
                    // İçeriğin kendi içindeki boşluğunu belirler
                    contentPadding: const EdgeInsets.symmetric(
                        // horizontal alanına 14, vertical: 11) değerini kullanır
                        horizontal: 14, vertical: 11),
                  ),
                ),
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(width: 8),
              // icon button.filled bileşenini oluşturur
              IconButton.filled(
                // Butonun açıklama metnini gösterir
                tooltip: 'Gönder',
                // Butona basılınca çalışacak fonksiyonu bağlar
                onPressed: _send,
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Mesajın kullanıcıya veya rehbere ait oluşuna göre sohbet balonu oluşturur
  Widget _buildMessageBubble(AiMessage message, AiPersona persona) {
    // Mesaj kullanıcıya aitse uygun sohbet balonu seçer
    if (message.isUser) {
      // İçeriği belirtilen yöne hizalar
      return Align(
        // İçeriğin hangi tarafa hizalanacağını belirler
        alignment: Alignment.centerRight,
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: ConstrainedBox(
          // Bileşenin boyut sınırlarını belirler
          constraints: const BoxConstraints(maxWidth: 320),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.only(bottom: 10),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: OrnateCard(
              // Bu elemanın rengini belirler
              color: const Color(0xFFE4F0EC),
              // border color alanına belirtilen renk değerini kullanır
              borderColor: const Color(0xFFB4D8CD),
              // İçeriğin kenarlara olan uzaklığını ayarlar
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              // show corners alanına özelliği kapatır
              showCorners: false,
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text(
                // Sohbet mesajının metnini balonda gösterir
                message.content,
                // Yazının ya da butonun görünümünü belirler
                style: const TextStyle(
                  // Yazının boyutunu belirler
                  fontSize: 14,
                  // Elemanın veya satırın yüksekliğini ayarlar
                  height: 1.4,
                  // Yazının kalınlığını belirler
                  fontWeight: FontWeight.w600,
                  // Bu elemanın rengini belirler
                  color: RealmPalette.ink,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Assistant Message Bubble
    // İçeriği belirtilen yöne hizalar
    return Align(
      // İçeriğin hangi tarafa hizalanacağını belirler
      alignment: Alignment.centerLeft,
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: ConstrainedBox(
        // Bileşenin boyut sınırlarını belirler
        constraints: const BoxConstraints(maxWidth: 345),
        // Bu widgetın içinde gösterilecek elemanı yerleştirir
        child: Padding(
          // İçeriğin kenarlara olan uzaklığını ayarlar
          padding: const EdgeInsets.only(bottom: 12),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Yeni OrnateCard nesnesi oluşturur
              OrnateCard(
                // Bu elemanın rengini belirler
                color: message.isError
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? const Color(0xFFFFF0F0)
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : const Color(0xFFFFFDF8),
                // border color alanına gelen değeri kullanır
                borderColor: message.isError
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? const Color(0xFFEAA2A2)
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : const Color(0xFFE0C988),
                // İçeriğin kenarlara olan uzaklığını ayarlar
                padding:
                    // EdgeInsets nesnesi için başlangıç değerlerini alır
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Column(
                  // Ana eksene dik yöndeki hizalamayı belirler
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // İçeride sıralanacak widgetları listeler
                  children: [
                    // Persona & Source Badge Header
                    // Elemanları yatay yönde sıralar
                    Row(
                      // Ana yönde kaplanacak alanı belirler
                      mainAxisSize: MainAxisSize.min,
                      // İçeride sıralanacak widgetları listeler
                      children: [
                        // Ekrana bir simge yerleştirir
                        Icon(persona.icon,
                            // Simgenin veya şeklin boyutunu belirler
                            size: 14, color: persona.primaryColor),
                        // Belirtilen ölçülerde boşluk veya alan oluşturur
                        const SizedBox(width: 5),
                        // Ekrana metin yerleştirir
                        Text(
                          // Seçilen rehber kişiliğinin adını gösterir
                          persona.name,
                          // Yazının ya da butonun görünümünü belirler
                          style: TextStyle(
                            // Yazının boyutunu belirler
                            fontSize: 11,
                            // Yazının kalınlığını belirler
                            fontWeight: FontWeight.w900,
                            // Bu elemanın rengini belirler
                            color: persona.primaryColor,
                          ),
                        ),
                        // Belirtilen ölçülerde boşluk veya alan oluşturur
                        const SizedBox(width: 6),
                        // Arka plan ve ölçüleri olan bir kutu oluşturur
                        Container(
                          // İçeriğin kenarlara olan uzaklığını ayarlar
                          padding: const EdgeInsets.symmetric(
                              // horizontal alanına 6, vertical: 2) değerini kullanır
                              horizontal: 6, vertical: 2),
                          // Kutunun arka plan, kenar ve süslerini ayarlar
                          decoration: BoxDecoration(
                            // Bu elemanın rengini belirler
                            color: message.isOfflineFallback
                                // Koşul doğruysa kullanılacak sonucu belirler
                                ? const Color(0xFFFFEDCE)
                                // Koşul yanlışsa kullanılacak sonucu belirler
                                : const Color(0xFFE2F4EA),
                            // Köşelerin yuvarlaklığını belirler
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Bu widgetın içinde gösterilecek elemanı yerleştirir
                          child: Text(
                            // Mesaj çevrimdışı üretildiyse bilgi etiketini gösterir
                            message.isOfflineFallback
                                // Koşul doğruysa kullanılacak sonucu belirler
                                ? 'Çevrimdışı'
                                // Koşul yanlışsa kullanılacak sonucu belirler
                                : 'Groq AI',
                            // Yazının ya da butonun görünümünü belirler
                            style: TextStyle(
                              // Yazının boyutunu belirler
                              fontSize: 9,
                              // Yazının kalınlığını belirler
                              fontWeight: FontWeight.w800,
                              // Bu elemanın rengini belirler
                              color: message.isOfflineFallback
                                  // Koşul doğruysa kullanılacak sonucu belirler
                                  ? const Color(0xFF8B6415)
                                  // Koşul yanlışsa kullanılacak sonucu belirler
                                  : const Color(0xFF1B6B3E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Belirtilen ölçülerde boşluk veya alan oluşturur
                    const SizedBox(height: 6),
                    // Ekrana metin yerleştirir
                    Text(
                      // Sohbet mesajının metnini balonda gösterir
                      message.content,
                      // Yazının ya da butonun görünümünü belirler
                      style: TextStyle(
                        // Yazının boyutunu belirler
                        fontSize: 13.5,
                        // Elemanın veya satırın yüksekliğini ayarlar
                        height: 1.45,
                        // Bu elemanın rengini belirler
                        color: message.isError
                            // Koşul doğruysa kullanılacak sonucu belirler
                            ? const Color(0xFF942828)
                            // Koşul yanlışsa kullanılacak sonucu belirler
                            : RealmPalette.ink,
                      ),
                    ),
                    // Son mesaj hata içeriyorsa ona göre işlem yapar
                    if (message.isError) ...[
                      // Belirtilen ölçülerde boşluk veya alan oluşturur
                      const SizedBox(height: 8),
                      // text button.icon bileşenini oluşturur
                      TextButton.icon(
                        // Buton veya kartta kullanılacak simgeyi seçer
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        // Butonun ya da etiketin görünen yazısını belirler
                        label: const Text('Yeniden Dene'),
                        // Butona basılınca çalışacak fonksiyonu bağlar
                        onPressed: () => _chat.retryLast(widget.controller),
                      ),
                    ],
                  ],
                ),
              ),
              // If model suggested an interactive pact, display the confirmation card
              // İsteğe bağlı veri mevcutsa ilgili bölümü kullanır
              if (message.pactSuggestion != null)
                // Yeni PactSuggestionCard nesnesi oluşturur
                PactSuggestionCard(
                  // suggestion alanına gelen değeri kullanır
                  suggestion: message.pactSuggestion!,
                  // realm controller alanına gelen değeri kullanır
                  realmController: widget.controller,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

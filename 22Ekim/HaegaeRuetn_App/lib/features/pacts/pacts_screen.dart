// Flutterın Material arayüz bileşenlerini ekler
import 'package:flutter/material.dart';
// Ahit modelini projeye ekler
import '../../core/models/pact.dart';
// Krallık verilerini yöneten controllerı projeye ekler
import '../../core/state/realm_controller.dart';
// Süslü ortak arayüz bileşenlerini projeye ekler
import '../../core/widgets/ornate_widgets.dart';
// Ortak krallık kartlarını projeye ekler
import '../../core/widgets/realm_card.dart';
// Ahitleri ve hedef günlerini listeler
class PactsScreen extends StatelessWidget {
  // PactsScreen nesnesinin başlangıç bilgilerini alır
  const PactsScreen({super.key, required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // PactsScreen için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // age bilgisini saklar
    final age = controller.era;
    // Kaydırılabilir öğe listesi oluşturur
    return ListView(
      // İçeriğin kenarlara olan uzaklığını ayarlar
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      // İçeride sıralanacak widgetları listeler
      children: [
        // Yeni FancyHeroHeader nesnesi oluşturur
        FancyHeroHeader(
          // başlık alanına gösterilecek metni belirler
          title: 'Ahit Defteri',
          // subtitle alanına değerini belirler
          subtitle:
              // Gösterilecek veya kullanılacak metin parçasını ekler
              'Bir söz, bir yol, biraz da mürekkep. “Küçük sözler büyük yolculuklar başlatır.”',
          // Gösterilecek görselin dosya yolunu belirler
          assetPath: ArtAssets.pacts,
          // rozet alanına gelen değeri kullanır
          badge: FramedIconBadge(
            // Buton veya kartta kullanılacak simgeyi seçer
            icon: Icons.history_edu_outlined,
            // Butonun ya da etiketin görünen yazısını belirler
            label: 'Kayıt',
            // Gösterilecek güncel değeri atar
            value: '${controller.pacts.length}',
            // Bu elemanın rengini belirler
            color: age.primary,
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 16),
        // Yeni RealmCard nesnesi oluşturur
        RealmCard(
          // Rengin saydamlığını belirtilen oranda ayarlar
          color: age.secondary.withValues(alpha: .42),
          // Bu widgetın içinde gösterilecek elemanı yerleştirir
          child: Column(
            // Ana eksene dik yöndeki hizalamayı belirler
            crossAxisAlignment: CrossAxisAlignment.start,
            // İçeride sıralanacak widgetları listeler
            children: [
              // SectionTitle nesnesinin başlangıç bilgilerini alır
              const SectionTitle('Yeni Ahit', icon: Icons.gavel_rounded),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 8),
              // Ekrana metin yerleştirir
              const Text(
                // Gösterilecek veya kullanılacak metin parçasını ekler
                'Bir veya birkaç vazife seç. Hedefin kadar farklı günde hepsini aynı gün tamamla. Ardışık gün şartı yok.',
              ),
              // Belirtilen ölçülerde boşluk veya alan oluşturur
              const SizedBox(height: 14),
              // Yeni OrnateButton nesnesi oluşturur
              OrnateButton(
                // Butonun ya da etiketin görünen yazısını belirler
                label: 'Yeni ahit yaz',
                // Buton veya kartta kullanılacak simgeyi seçer
                icon: Icons.add_rounded,
                // İçeriğin açık olup olmadığını belirler
                expanded: true,
                // Butona basılınca çalışacak fonksiyonu bağlar
                onPressed: controller.activeHabits.isEmpty
                    // Koşul doğruysa kullanılacak sonucu belirler
                    ? null
                    // Koşul yanlışsa kullanılacak sonucu belirler
                    : () => showModalBottomSheet<void>(
                          // İşlemin çalıştığı widget bağlamını gönderir
                          context: context,
                          // Alt panelin ekranı daha fazla kaplamasına izin verir
                          isScrollControlled: true,
                          // Alt panelin tutma çizgisini gösterir
                          showDragHandle: true,
                          // Arka plan rengini belirler
                          backgroundColor: const Color(0xFFF8F3E8),
                          // Gelen duruma göre arayüz oluşturan fonksiyonu çalıştırır
                          builder: (_) => _PactEditor(controller: controller),
                        ),
              ),
            ],
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 20),
        // Elemanları yatay yönde sıralar
        Row(
          // İçeride sıralanacak widgetları listeler
          children: [
            // İçeriğin kalan alanı doldurmasını sağlar
            const Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: SectionTitle('Mühürlü Ahitler',
                    // Buton veya kartta kullanılacak simgeyi seçer
                    icon: Icons.shield_moon_outlined)),
            // Yeni RealmPill nesnesi oluşturur
            RealmPill(label: '${controller.pacts.length} kayıt'),
          ],
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 10),
        // Kayıtlı ahit yoksa bilgilendirme alanı gösterir
        if (controller.pacts.isEmpty)
          // RealmCard nesnesinin başlangıç bilgilerini alır
          const RealmCard(
              // Bu widgetın içinde gösterilecek elemanı yerleştirir
              child: Text(
                  // Gösterilecek veya kullanılacak metin parçasını ekler
                  'Ahit defteri henüz boş. İlk anlaşmanı yaz ve yolun taşlarını döşe.')),
        // Aynı nesnede ek çizim ayarını yapar
        ...controller.pacts.reversed.map(
          // Her ahit için kenar boşluğu olan kart oluşturur
          (pact) => Padding(
            // İçeriğin kenarlara olan uzaklığını ayarlar
            padding: const EdgeInsets.only(bottom: 12),
            // Bu widgetın içinde gösterilecek elemanı yerleştirir
            child: _PactCard(controller: controller, pact: pact),
          ),
        ),
        // Belirtilen ölçülerde boşluk veya alan oluşturur
        const SizedBox(height: 12),
        // Ekrana metin yerleştirir
        const Text(
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Ahitler cihazında saklanır. Tamamlanan anlaşmalar bir defa XP kazandırır.',
          // Yazının ya da butonun görünümünü belirler
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
// Ahit başlığını, bağlı vazifeleri ve ilerlemesini gösterir
class _PactCard extends StatelessWidget {
  // _PactCard nesnesinin başlangıç bilgilerini alır
  const _PactCard({required this.controller, required this.pact});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // ahit bilgisini saklar
  final Pact pact;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _PactCard için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // ilerleme bilgisini saklar
    final progress = controller.pactProgress(pact);
    // color bilgisini saklar
    final color = controller.era.primary;
    // Vazifeleri benzersiz kimlikleriyle Map içine alır
    final byId = {for (final habit in controller.habits) habit.id: habit.name};
    // completion bilgisini saklar
    final completion = (progress / pact.goalDays).clamp(0.0, 1.0);
    // Yeni RealmCard nesnesi oluşturup döndürür
    return RealmCard(
      // Bu widgetın içinde gösterilecek elemanı yerleştirir
      child: Column(
        // Ana eksene dik yöndeki hizalamayı belirler
        crossAxisAlignment: CrossAxisAlignment.start,
        // İçeride sıralanacak widgetları listeler
        children: [
          // Elemanları yatay yönde sıralar
          Row(
            // İçeride sıralanacak widgetları listeler
            children: [
              // İçeriğin kalan alanı doldurmasını sağlar
              Expanded(
                  // Bu widgetın içinde gösterilecek elemanı yerleştirir
                  child: Text(pact.title,
                      // Yazının ya da butonun görünümünü belirler
                      style: Theme.of(context).textTheme.titleLarge)),
              // Tamamlanan ahdin durumunu kullanıcıya gösterir
              if (pact.isCompleted)
                // Ekrana bir simge yerleştirir
                const Icon(Icons.verified, color: Color(0xFF278258)),
              // Sonraki satırlardan gelecek parametreleri alır
              PopupMenuButton<String>(
                // Butonun açıklama metnini gösterir
                tooltip: 'Ahit seçenekleri',
                // Seçim yapıldığında çalışacak fonksiyonu bağlar
                onSelected: (value) {
                  // Belirtilen koşul sağlanırsa bu işlemi uygular
                  if (value == 'remove') controller.removePact(pact);
                },
                // İstenen indekse göre liste öğesi oluşturur
                itemBuilder: (_) => const [
                  // popup menu item bileşenini oluşturur
                  PopupMenuItem(value: 'remove', child: Text('Ahdi kaldır'))
                ],
              ),
            ],
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 4),
          // Ekrana metin yerleştirir
          Text(
            // Ahde bağlı vazife kimliklerini kullanır
            pact.habitIds
                // Öğeleri tek tek başka biçime dönüştürür
                .map((id) => byId[id] ?? 'Arşivlenen vazife')
                // Bağlı vazife adlarını nokta işaretiyle birleştirir
                .join(' • '),
            // Yazının ya da butonun görünümünü belirler
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 12),
          // Yeni OrnateProgressBar nesnesi oluşturur
          OrnateProgressBar(value: completion, color: color),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 9),
          // Elemanları yatay yönde sıralar
          Row(
            // İçeride sıralanacak widgetları listeler
            children: [
              // İçeriğin kalan alanı doldurmasını sağlar
              Expanded(
                // Bu widgetın içinde gösterilecek elemanı yerleştirir
                child: Text(
                  // Ahdin tamamlanmış olup olmadığını kontrol eder
                  pact.isCompleted
                      // Koşul doğruysa kullanılacak sonucu belirler
                      ? 'Ahit başarıyla tamamlandı!'
                      // Koşul yanlışsa kullanılacak sonucu belirler
                      : '$progress / ${pact.goalDays} uyumlu gün',
                  // Yazının ya da butonun görünümünü belirler
                  style: TextStyle(
                      // Bu elemanın rengini belirler
                      color: color, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              // Ekrana metin yerleştirir
              Text('+${90 + pact.goalDays * 10} XP',
                  // Yazının ya da butonun görünümünü belirler
                  style: const TextStyle(
                      // Yazının boyutunu belirler
                      fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          // Belirtilen ölçülerde boşluk veya alan oluşturur
          const SizedBox(height: 10),
          // Sığmayan öğeleri bir sonraki satıra geçirir
          Wrap(
            // spacing alanına 8 değerini kullanır
            spacing: 8,
            // run spacing alanına 6 değerini kullanır
            runSpacing: 6,
            // İçeride sıralanacak widgetları listeler
            children: [
              // Yeni RealmPill nesnesi oluşturur
              RealmPill(
                  // Butonun ya da etiketin görünen yazısını belirler
                  label: '${pact.goalDays} gün hedefi',
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: Icons.calendar_month_outlined,
                  // Bu elemanın rengini belirler
                  color: controller.era.secondary),
              // RealmPill nesnesinin başlangıç bilgilerini alır
              const RealmPill(
                  // Butonun ya da etiketin görünen yazısını belirler
                  label: '+8 İtibar',
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: Icons.workspace_premium_outlined,
                  // Bu elemanın rengini belirler
                  color: Color(0xFFFFEBC0)),
            ],
          ),
        ],
      ),
    );
  }
}
// Yeni ahit formunun değişen alanlarını yönetir
class _PactEditor extends StatefulWidget {
  // _PactEditor nesnesinin başlangıç bilgilerini alır
  const _PactEditor({required this.controller});
  // İşlemleri yöneten RealmController bağlantısını tutar
  final RealmController controller;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // Widgetın değişen durumunu yönetecek State nesnesini oluşturur
  State<_PactEditor> createState() => _PactEditorState();
}
// ahit editor state bilgilerini ve ilgili davranışları tanımlar
class _PactEditorState extends State<_PactEditor> {
  // Gelen veriden ahdin başlığını seçer
  final title = TextEditingController();
  // Seçili menü veya öğenin indeksini tutar
  final selected = <String>{};
  // days bilgisini saklar
  int days = 7;
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // dispose için gerekli sonucu hesaplar
  void dispose() {
    // Artık kullanılmayan controller kaynaklarını temizler
    title.dispose();
    // Üst sınıfın temizleme işlemlerini tamamlar
    super.dispose();
  }
  // Üst sınıfta tanımlanan metodu veya özelliği yeniden uygular
  @override
  // _PactEditorState için ekranın arayüzünü oluşturur
  Widget build(BuildContext context) {
    // İçeriğin çevresine boşluk ekler
    return Padding(
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
                Text('Yeni Ahit',
                    // Yazının ya da butonun görünümünü belirler
                    style: Theme.of(context).textTheme.headlineSmall),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 15),
                // Kullanıcının yazı girebileceği alanı oluşturur
                TextField(
                  // Metin veya liste kontrolcüsünü ilgili alana bağlar
                  controller: title,
                  // Yazılabilecek en fazla karakter sayısını belirler
                  maxLength: 60,
                  // Kutunun arka plan, kenar ve süslerini ayarlar
                  decoration: const InputDecoration(
                      // Form alanının başlığını gösterir
                      labelText: 'Ahde bir isim ver',
                      // Alan boşken kullanıcıya örnek giriş metnini gösterir
                      hintText: 'Örn. Bilginin Seferi'),
                ),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 8),
                // Ekrana metin yerleştirir
                const Text('Ahde bağlı vazifeler',
                    // Yazının ya da butonun görünümünü belirler
                    style: TextStyle(fontWeight: FontWeight.w800)),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 6),
                // Aynı nesnede ek çizim ayarını yapar
                ...widget.controller.activeHabits.map(
                  // Her vazife için işaretlenebilir seçim satırı oluşturur
                  (habit) => CheckboxListTile(
                    // Satırın daha sıkı yerleşmesini sağlar
                    dense: true,
                    // İçeriğin kendi içindeki boşluğunu belirler
                    contentPadding: EdgeInsets.zero,
                    // başlık alanına gelen değeri kullanır
                    title: Text(habit.name),
                    // Aranan değerin koleksiyonda bulunup bulunmadığını kontrol eder
                    value: selected.contains(habit.id),
                    // Değer değişince çalışacak fonksiyonu bağlar
                    onChanged: (checked) => setState(() {
                      // Belirtilen koşul sağlanırsa bu işlemi uygular
                      if (checked ?? false) {
                        // Yeni öğeyi ilgili listeye veya kümeye ekler
                        selected.add(habit.id);
                      // Önceki koşul sağlanmazsa bu yolu kullanır
                      } else {
                        // İlgili öğeyi koleksiyondan kaldırır
                        selected.remove(habit.id);
                      }
                    }),
                  ),
                ),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 8),
                // Ekrana metin yerleştirir
                const Text('Hedef gün sayısı',
                    // Yazının ya da butonun görünümünü belirler
                    style: TextStyle(fontWeight: FontWeight.w800)),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 8),
                // Sığmayan öğeleri bir sonraki satıra geçirir
                Wrap(
                  // spacing alanına 8 değerini kullanır
                  spacing: 8,
                  // run spacing alanına 8 değerini kullanır
                  runSpacing: 8,
                  // İçeride sıralanacak widgetları listeler
                  children: [3, 7, 14, 30].map((value) {
                    // Seçilebilir küçük filtre butonu oluşturur
                    return ChoiceChip(
                      // Butonun ya da etiketin görünen yazısını belirler
                      label: Text('$value gün'),
                      // Öğenin aktif seçili durumda olup olmadığını belirler
                      selected: days == value,
                      // Seçim yapıldığında çalışacak fonksiyonu bağlar
                      onSelected: (_) => setState(() => days = value),
                    );
                  // Dönüştürülen öğeleri yeni liste hâline getirir
                  }).toList(),
                ),
                // Belirtilen ölçülerde boşluk veya alan oluşturur
                const SizedBox(height: 18),
                // Yeni OrnateButton nesnesi oluşturur
                OrnateButton(
                  // Butonun ya da etiketin görünen yazısını belirler
                  label: 'Ahdi mühürle',
                  // Buton veya kartta kullanılacak simgeyi seçer
                  icon: Icons.verified_outlined,
                  // İçeriğin açık olup olmadığını belirler
                  expanded: true,
                  // Butona basılınca çalışacak fonksiyonu bağlar
                  onPressed: selected.isEmpty
                      // Koşul doğruysa kullanılacak sonucu belirler
                      ? null
                      // Koşul yanlışsa kullanılacak sonucu belirler
                      : () {
                          // Gerekli liste ya da metin boşsa işlem yapmaz
                          if (title.text.trim().isEmpty) return;
                          // Krallık işlemlerini yöneten controllerı gönderir
                          widget.controller
                              // Yeni öğeyi ilgili listeye veya kümeye ekler
                              .addPact(title.text, selected.toList(), days);
                          // navigator.pop bileşenini oluşturur
                          Navigator.pop(context);
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

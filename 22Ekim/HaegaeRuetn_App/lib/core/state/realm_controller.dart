// JSON metnini dönüştürmek için kullanılır
import 'dart:convert';
// ChangeNotifier ve ValueNotifier gibi durum yapılarını ekler
import 'package:flutter/foundation.dart';
// Cihaz içi kayıt servisini projeye ekler
import '../data/local_realm_store.dart';
// Rozet tanımlarını projeye ekler
import '../models/badge_definition.dart';
// Çağ ve rütbe modelini projeye ekler
import '../models/era.dart';
// Vazife modelini projeye ekler
import '../models/habit.dart';
// Ahit modelini projeye ekler
import '../models/pact.dart';
// Rozet hesaplama servisini projeye ekler
import '../services/badge_engine.dart';
// XP ve seviye hesaplama servisini projeye ekler
import '../services/progression_engine.dart';
// Vazife, ahit, XP, itibar ve kayıt değişikliklerini yönetir
class RealmController extends ChangeNotifier {
  // Yeni RealmController nesnesi oluşturur
  RealmController(this._store, {DateTime Function()? clock})
      // Verilmeyen parametre yerine varsayılan nesneyi kullanır
      : _now = clock ?? DateTime.now;
  // Verileri okuyup yazan yerel depolama bağlantısını tutar
  final RealmStore _store;
  // Testte değiştirilebilen tarih kaynağını tutar
  final DateTime Function() _now;
  // Vazifeleri tutan listeyi saklar
  List<Habit> habits = [];
  // Oluşturulmuş ahitlerin listesini saklar
  List<Pact> pacts = [];
  // Kazanılmış deneyim puanını tutar
  int xp = 0;
  // Krallığın 0 ile 100 arasındaki itibarını tutar
  int reputation = 70;
  // Ara verdikten sonra vazifeye dönüş sayısını tutar
  int comebackCount = 0;
  // En son kontrol edilen günü tutar
  String? lastCheckedDate;
  // Planlı dinlenme günlerinin anahtarlarını tutar
  final Set<String> restDates = {};
  // Ekranda gösterilen krallık duyurusunu tutar
  String herald =
      // Gösterilecek veya kullanılacak metin parçasını ekler
      'Hoş geldin yolcu! Küçük bir vazife, büyük bir destanın ilk satırıdır.';
  // Başarı olunca gösterilecek kutlama metnini tutar
  String? celebration;
  // Krallık olaylarını ayırt eden artan sayıyı tutar
  int eventNumber = 0;
  // Ardışık kayıtların çakışmaması için tamamlanmış Future tutar
  Future<void> _writeQueue = Future<void>.value();
  // Yeni kimlik üretiminde kullanılan artan sayacı tutar
  int _idSequence = 0;
  // Yerel verinin okunamadığını belirtir
  bool _loadFailed = false;
  // Kayıt hatası varsa salt okunur kurtarma modunu bildirir
  bool get readOnlyRecoveryMode => _loadFailed;
  // Şu anki günü kayıt anahtarı biçiminde döndürür
  String get today => ProgressionEngine.dayKey(_now());
  // Toplam XPye göre kazanılan seviyeyi döndürür
  int get earnedLevel => ProgressionEngine.levelForXp(xp);
  // XP ve itibara göre gösterilecek seviyeyi döndürür
  int get level => ProgressionEngine.titleLevel(xp, reputation);
  // Mevcut seviyeye ait çağı döndürür
  Era get era => eraForLevel(level);
  // Mevcut seviyenin rütbesini döndürür
  String get rank => rankForLevel(level);
  // Bugün tamamlanan aktif vazife sayısını hesaplar
  int get todayCompleted =>
      // Aktif vazifeler arasından bugün tamamlananları sayar
      activeHabits.where((h) => h.completedOn(today)).length;
  // Arşivlenmemiş vazifeleri liste olarak döndürür
  List<Habit> get activeHabits =>
      // Arşivlenmemiş vazifeleri filtreleyip sabit boyutlu liste yapar
      habits.where((h) => !h.archived).toList(growable: false);
  // Bütün vazifelerin tamamlandığı gün sayılarını toplar
  int get totalCompletions =>
      // Bütün vazifelerin tamamlanma sayılarını toplar
      habits.fold(0, (sum, h) => sum + h.completedDates.length);
  // Şu an kazanılan rozetlerin IDlerini hesaplar
  Set<int> get badgeIds => BadgeEngine.earned(habits, pacts, comebackCount);
  // Kazanılan rozet sayısını döndürür
  int get badgeCount => badgeIds.length;
  // Açılmış rozetlerin tanımlarını getirir
  List<BadgeDefinition> get unlockedBadges =>
      // Aranan değerin koleksiyonda bulunup bulunmadığını kontrol eder
      badges.where((b) => badgeIds.contains(b.id)).toList();
  // Ahdin bağlı vazifelerinin birlikte tamamlandığı günleri sayar
  int pactProgress(Pact pact) => BadgeEngine.pactProgress(pact, habits);
  // Bugün aktif vazifelerin yüzde kaçının bittiğini hesaplar
  int get todayPercent =>
      // Aktif vazife yoksa sıfır, varsa bugünkü tamamlanma yüzdesini hesaplar
      activeHabits.isEmpty ? 0 : (todayCompleted * 100 ~/ activeHabits.length);
  // Kayıtlı verileri yükleyip uygulamanın durumunu hazırlar
  Future<void> initialize() async {
    // Hata oluşabilecek işlemleri denemeye başlar
    try {
      // Cihazda daha önce kaydedilmiş krallık verisini okur
      final raw = await _store.read();
      // Cihazda eski kayıt varsa içindeki vazife ve ahitleri geri yükler
      if (raw != null) {
        // Cihazdan okunan JSON metnini Map olarak açar
        final data = jsonDecode(raw) as Map<String, dynamic>;
        // vazifeler bilgisini yeni değeriyle günceller
        habits = (data['habits'] as List<dynamic>? ?? [])
            // Öğeleri tek tek başka biçime dönüştürür
            .map((item) =>
                // Kaydedilmiş vazife verisinden yeni Habit nesnesi oluşturur
                Habit.fromJson(Map<String, dynamic>.from(item as Map)))
            // Sonuçları liste biçimine toplar
            .toList();
        // ahitler bilgisini yeni değeriyle günceller
        pacts = (data['pacts'] as List<dynamic>? ?? [])
            // Öğeleri tek tek başka biçime dönüştürür
            .map(
                // Veriyi beklenen tipe dönüştürür
                (item) => Pact.fromJson(Map<String, dynamic>.from(item as Map)))
            // Sonuçları liste biçimine toplar
            .toList();
        // XP bilgisini yeni değeriyle günceller
        xp = (data['xp'] as num?)?.toInt() ?? 0;
        // itibar bilgisini yeni değeriyle günceller
        reputation = (data['reputation'] as num?)?.toInt() ?? 70;
        // comeback sayı bilgisini yeni değeriyle günceller
        comebackCount = (data['comebackCount'] as num?)?.toInt() ?? 0;
        // last checked tarih bilgisini yeni değeriyle günceller
        lastCheckedDate = data['lastCheckedDate'] as String?;
        // Planlı istirahat günlerinin kümesini kullanır
        restDates
            // Bir koleksiyondaki bütün öğeleri diğerine ekler
            .addAll((data['restDates'] as List<dynamic>? ?? []).cast<String>());
        // ID sequence bilgisini yeni değeriyle günceller
        _idSequence = (data['idSequence'] as num?)?.toInt() ?? 0;
      // Önceki koşul sağlanmazsa bu yolu kullanır
      } else {
        // İlk açılışta düzenlenebilir örnek vazifeler yükler, ilerleme uydurmaz
        // Tarih hesaplarında kullanılacak bugünü alır
        final now = _now();
        // vazifeler bilgisini yeni değeriyle günceller
        habits = [
          // Yeni Habit nesnesi oluşturur
          Habit(
              // Yeni kayıt için benzersiz kimlik üretir
              id: _id(),
              // Vazifenin veya kişiliğin adını belirler
              name: '20 dakika kitap oku',
              // Vazifenin veya önerinin açıklamasını belirler
              description: 'Bilgi seferi',
              // Vazifenin zorluk derecesini belirler
              difficulty: 1,
              // Oluşturulma tarihini kaydeder
              createdAt: now,
              // Yeni vazifeyi henüz tamamlanan günü olmadan başlatır
              completedDates: []),
          // Yeni Habit nesnesi oluşturur
          Habit(
              // Yeni kayıt için benzersiz kimlik üretir
              id: _id(),
              // Vazifenin veya kişiliğin adını belirler
              name: '15 dakika dil çalış',
              // Vazifenin veya önerinin açıklamasını belirler
              description: 'Yeni kelimelerin izinde',
              // Vazifenin zorluk derecesini belirler
              difficulty: 2,
              // Oluşturulma tarihini kaydeder
              createdAt: now,
              // Yeni vazifeyi henüz tamamlanan günü olmadan başlatır
              completedDates: []),
          // Yeni Habit nesnesi oluşturur
          Habit(
              // Yeni kayıt için benzersiz kimlik üretir
              id: _id(),
              // Vazifenin veya kişiliğin adını belirler
              name: 'Kısa bir yürüyüş yap',
              // Vazifenin veya önerinin açıklamasını belirler
              description: 'Yolcunun adımları',
              // Vazifenin zorluk derecesini belirler
              difficulty: 1,
              // Oluşturulma tarihini kaydeder
              createdAt: now,
              // Yeni vazifeyi henüz tamamlanan günü olmadan başlatır
              completedDates: []),
        ];
      }
      // Geçen günlerde aksayan vazifeler için itibar kontrolü yapar
      _applyElapsedDays();
      // Krallık durumunu JSONa çevirip sırayla cihaza kaydeder
      _persist();
    // İşlem başarısız olursa hata durumunu ele alır
    } catch (_) {
      // Veri okuma başarısız olduğu için değiştirmeyi engeller
      _loadFailed = true;
      // Bozuk kayıtlar kullanıcı verilerinin üzerine yazılmamalıdır
      // herald bilgisini yeni değeriyle günceller
      herald =
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Yerel kayıt yüklenemedi. Veriler korunuyor; lütfen yedek alıp tekrar dene.';
      // vazifeler bilgisini yeni değeriyle günceller
      habits = [];
      // ahitler bilgisini yeni değeriyle günceller
      pacts = [];
    }
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
  }
  // Geçen günlerde aksayan vazifeler için itibar kontrolü yapar
  void _applyElapsedDays() {
    // Günün saat bilgisini kaldırarak karşılaştırma tarihi oluşturur
    final current = ProgressionEngine.day(_now());
    // Son kontrol edilen günü geçerli tarihe çevirmeyi dener
    final previous = DateTime.tryParse(lastCheckedDate ?? '');
    // Önceki gün ve aktif vazife varsa eksik günleri hesaplar
    if (previous != null && activeHabits.isNotEmpty) {
      // pointer bilgisini saklar
      var pointer = ProgressionEngine.day(previous);
      // missed bilgisini saklar
      var missed = 0;
      // Son kontrolden bugüne kadar her günü dolaşır
      while (pointer.isBefore(current)) {
        // key bilgisini saklar
        final key = ProgressionEngine.dayKey(pointer);
        // O gün itibarıyla oluşturulmuş vazifeleri seçer
        final due = activeHabits
            // Koşula uymayan öğeleri eler
            .where((h) => !ProgressionEngine.day(h.createdAt).isAfter(pointer))
            // Sonuçları liste biçimine toplar
            .toList();
        // O gün yapılması gereken vazifeler varsa kontrol eder
        if (due.isNotEmpty &&
            // Aranan değerin koleksiyonda bulunup bulunmadığını kontrol eder
            !restDates.contains(key) &&
            // Yapılması gereken vazifelerden eksik kalan var mı diye bakar
            due.any((h) => !h.completedOn(key))) {
          // Eksik tamamlanan gün sayısını artırır
          missed++;
        }
        // Takvim işaretçisini bir sonraki güne taşır
        pointer = DateTime(pointer.year, pointer.month, pointer.day + 1);
      }
      // Aksayan gün varsa itibarı düşürür ve duyuru oluşturur
      if (missed > 0) {
        // Eksik her gün için itibardan 12 puan düşürür
        reputation = (reputation - missed * 12).clamp(0, 100).toInt();
        // herald bilgisini yeni değeriyle günceller
        herald =
            // Gösterilecek veya kullanılacak metin parçasını ekler
            'Kraliyet kâtibi $missed aksayan gün buldu. Tahtı toparlayacak bir küçük görev seçelim!';
      }
    }
    // last checked tarih bilgisini yeni değeriyle günceller
    lastCheckedDate = ProgressionEngine.dayKey(current);
  }
  // Zaman ve artan sayaçla yeni kayıt IDsi oluşturur
  String _id() => '${_now().microsecondsSinceEpoch}_${_idSequence++}';
  // Boş olmayan yeni vazifeyi listeye ekleyip kaydeder
  void addHabit(String name, String description, int difficulty) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // Yeni vazifenin adındaki gereksiz boşlukları temizler
    final clean = name.trim();
    // Gerekli liste ya da metin boşsa işlem yapmaz
    if (clean.isEmpty) return;
    // vazifeler bilgisini yeni değeriyle günceller
    habits = [
      // Aynı nesnede ek çizim ayarını yapar
      ...habits,
      // Yeni Habit nesnesi oluşturur
      Habit(
          // Yeni kayıt için benzersiz kimlik üretir
          id: _id(),
          // Vazifenin veya kişiliğin adını belirler
          name: clean,
          // Vazifenin veya önerinin açıklamasını belirler
          description: description.trim(),
          // Vazife zorluğunu 1 ile 3 arasında sınırlar
          difficulty: difficulty.clamp(1, 3).toInt(),
          // Oluşturulma tarihini kaydeder
          createdAt: _now(),
          // Yeni vazifeyi henüz tamamlanan günü olmadan başlatır
          completedDates: [])
    ];
    // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
    _event('Yeni vazife kayda geçti. Kâtipler mürekkep siparişi verdi.');
  }
  // Seçilen vazifenin adını, açıklamasını ve zorluğunu günceller
  void editHabit(Habit habit, String name, String description, int difficulty) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // Gerekli liste ya da metin boşsa işlem yapmaz
    if (name.trim().isEmpty) return;
    // vazifeler bilgisini yeni değeriyle günceller
    habits = habits
        // Öğeleri tek tek başka biçime dönüştürür
        .map((h) => h.id == habit.id
            // Koşul doğruysa kullanılacak sonucu belirler
            ? h.copyWith(
                // Vazifenin veya kişiliğin adını belirler
                name: name.trim(),
                // Vazifenin veya önerinin açıklamasını belirler
                description: description.trim(),
                // Vazife zorluğunu 1 ile 3 arasında sınırlar
                difficulty: difficulty.clamp(1, 3).toInt())
            // Koşul yanlışsa kullanılacak sonucu belirler
            : h)
        // Sonuçları liste biçimine toplar
        .toList();
    // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
    _event('Vazife yeniden düzenlendi. Ferman geçerlidir.');
  }
  // Vazifeyi silmeden arşivlenmiş olarak işaretler
  void archiveHabit(Habit habit) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // vazifeler bilgisini yeni değeriyle günceller
    habits = habits
        // Öğeleri tek tek başka biçime dönüştürür
        .map((h) => h.id == habit.id ? h.copyWith(archived: true) : h)
        // Sonuçları liste biçimine toplar
        .toList();
    // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
    _event('Vazife arşive kaldırıldı. Eski kayıtlar saklanıyor.');
  }
  // Vazifenin bugünkü tamamlanma durumunu ve XPyi günceller
  void toggleHabit(Habit habit) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // key bilgisini saklar
    final key = today;
    // Vazife bugün zaten tamamlanmışsa işaretini geri alır
    if (habit.completedOn(key)) {
      // vazifeler bilgisini yeni değeriyle günceller
      habits = habits
          // Öğeleri tek tek başka biçime dönüştürür
          .map((h) => h.id == habit.id
              // Koşul doğruysa kullanılacak sonucu belirler
              ? h.copyWith(
                  // Vazifenin tamamlandığı günleri aktarır
                  completedDates:
                      // Bugünkü işareti tamamlanan günler listesinden çıkarır
                      h.completedDates.where((d) => d != key).toList())
              // Koşul yanlışsa kullanılacak sonucu belirler
              : h)
          // Sonuçları liste biçimine toplar
          .toList();
      // XP bilgisini yeni değeriyle günceller
      xp =
          // Değeri izin verilen aralığa sabitler
          (xp - ProgressionEngine.rewardFor(habit)).clamp(0, 999999999).toInt();
      // Tamamlama iptal edildiğinde itibarı 4 azaltır, sıfırın altına inmez
      reputation = (reputation - 4).clamp(0, 100).toInt();
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event('Çentik geri alındı. Günlük kayıt düzeltildi.');
      // Kalan işlemleri çalıştırmadan çıkar
      return;
    }
    // İşlem öncesinde kazanılmış rozetleri saklar
    final before = badgeIds;
    // İşlemden önceki seviyeyi karşılaştırma için saklar
    final levelBefore = level;
    // Vazifenin eski günlerine bugünün tarihini ekler
    final dates = [...habit.completedDates, key];
    // had prior day bilgisini saklar
    final hadPriorDay = habit.completedDates.any((day) => day != key);
    // Daha önce tamamlanan gün varsa geri dönüş sayısını kontrol eder
    if (hadPriorDay) {
      // Vazifenin dün yapılıp yapılmadığını kontrol etmek için tarihi bulur
      final yesterday = ProgressionEngine.dayKey(
          // progression engine.day bileşenini oluşturur
          ProgressionEngine.day(_now()).subtract(const Duration(days: 1)));
      // Vazife dün yapılmadıysa geri dönüş sayısını artırır
      if (!habit.completedOn(yesterday)) comebackCount++;
    }
    // vazifeler bilgisini yeni değeriyle günceller
    habits = habits
        // Öğeleri tek tek başka biçime dönüştürür
        .map((h) => h.id == habit.id ? h.copyWith(completedDates: dates) : h)
        // Sonuçları liste biçimine toplar
        .toList();
    // Vazifenin zorluğuna uygun XP ödülünü toplama ekler
    xp += ProgressionEngine.rewardFor(habit);
    // Vazife tamamlanınca itibarı 4 artırır, 100ü geçmez
    reputation = (reputation + 4).clamp(0, 100).toInt();
    // Hedefine ulaşan ahitleri tamamlayıp XP ve itibar ekler
    _checkPacts();
    // Son işlemle yeni kazanılan rozetleri eski rozetlerden ayırır
    final newBadges = badgeIds.difference(before);
    // Yeni bir rütbeye çıkıldıysa kutlama duyurusu hazırlar
    if (level > levelBefore) {
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event('RÜTBE YÜKSELDİ! Artık $rank. Borazanları uyandırın!',
          // Başarı kutlamasının gösterilip gösterilmeyeceğini belirler
          celebrate: true);
    // Önceki koşul sağlanmadığında ikinci durumu kontrol eder
    } else if (newBadges.isNotEmpty) {
      // rozet bilgisini saklar
      final badge = badges.firstWhere((b) => b.id == newBadges.first);
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event(
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'ROZET KAZANILDI: ${badge.name}! Mühürdar sevinçten mührünü düşürdü.',
          // Başarı kutlamasının gösterilip gösterilmeyeceğini belirler
          celebrate: true);
    // Önceki koşul sağlanmazsa bu yolu kullanır
    } else {
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event(
          // Gösterilecek veya kullanılacak metin parçasını ekler
          'Vazife tamamlandı! +${ProgressionEngine.rewardFor(habit)} XP. Krallık bir adım daha ileri.',
          // Başarı kutlamasının gösterilip gösterilmeyeceğini belirler
          celebrate: true);
    }
  }
  // Hedefine ulaşan ahitleri tamamlayıp XP ve itibar ekler
  void _checkPacts() {
    // Ahitleri tek tek dolaşıp ilerlemelerini kontrol eder
    for (var i = 0; i < pacts.length; i++) {
      // ahit öğelerini içeren listeyi hazırlar
      final pact = pacts[i];
      // Ahdin tamamlanma durumuna göre hareket eder
      if (!pact.isCompleted &&
          // rozet engine.pact ilerleme bileşenini oluşturur
          BadgeEngine.pactProgress(pact, habits) >= pact.goalDays) {
        // Hedefi biten ahde tamamlanma tarihini yazar
        pacts[i] = pact.complete(_now());
        // Tamamlanan ahit için hedef süresine bağlı XP ekler
        xp += 90 + pact.goalDays * 10;
        // Ahit tamamlanınca itibarı 8 artırır, 100ü geçmez
        reputation = (reputation + 8).clamp(0, 100).toInt();
      }
    }
  }
  // Geçerli vazifelere bağlı yeni ahit oluşturur
  void addPact(String title, List<String> habitIds, int goalDays) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // Başlığı veya bağlı vazifesi olmayan ahdi reddeder
    if (title.trim().isEmpty || habitIds.isEmpty) return;
    // Yeni ahde yalnızca arşivlenmemiş vazifelerin bağlanmasını sağlar
    final validIds = activeHabits.map((h) => h.id).toSet();
    // Seçilen vazifeler aktif listede yoksa ahit oluşturmaz
    if (!habitIds.every(validIds.contains)) return;
    // ahitler bilgisini yeni değeriyle günceller
    pacts = [
      // Aynı nesnede ek çizim ayarını yapar
      ...pacts,
      // Yeni Pact nesnesi oluşturur
      Pact(
          // Yeni kayıt için benzersiz kimlik üretir
          id: _id(),
          // başlık alanına baş ve sondaki boşlukları temizler
          title: title.trim(),
          // Ahdin bağlı olduğu vazife IDlerini aktarır
          habitIds: habitIds.toSet().toList(),
          // Ahit hedefini 3 ile 90 gün arasında sınırlar
          goalDays: goalDays.clamp(3, 90).toInt(),
          // Ahdin başlangıç tarihi olarak bugünü kaydeder
          startedAt: _now())
    ];
    // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
    _event('Yeni ahit mühürlendi. Artık ferman defterindesin!');
  }
  // Seçilen ahdi listeden kaldırır, kazanılmış XPyi korur
  void removePact(Pact pact) {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // ahitler listesini koşula göre yeniden oluşturur
    pacts = pacts.where((p) => p.id != pact.id).toList();
    // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
    _event('Ahit arşivden kaldırıldı. Kazanılmış tecrübe korunur.');
  }
  // Bugünü planlı istirahat olarak işaretler veya işareti kaldırır
  void toggleRestDay() {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // Koleksiyonda aranan öğe bulunup bulunmadığını kontrol eder
    if (restDates.contains(today)) {
      // İlgili öğeyi koleksiyondan kaldırır
      restDates.remove(today);
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event('Bugünün istirahat mührü kaldırıldı.');
    // Önceki koşul sağlanmazsa bu yolu kullanır
    } else {
      // Yeni öğeyi ilgili listeye veya kümeye ekler
      restDates.add(today);
      // Bu değişikliği duyurur, kaydeder ve arayüze bildirir
      _event('Bugün planlı istirahat. İtibar kaybı uygulanmaz.');
    }
  }
  // Olay mesajını günceller, kaydeder ve arayüze bildirir
  void _event(String message, {bool celebrate = false}) {
    // herald bilgisini yeni değeriyle günceller
    herald = message;
    // celebration bilgisini yeni değeriyle günceller
    celebration = celebrate ? message : null;
    // event number sayacını bir artırır
    eventNumber++;
    // Krallık durumunu JSONa çevirip sırayla cihaza kaydeder
    _persist();
    // State değiştiğini dinleyen widgetlara bildirir
    notifyListeners();
  }
  // Krallık durumunu JSONa çevirip sırayla cihaza kaydeder
  void _persist() {
    // Yerel kayıt bozuksa verileri değiştirmeyi engeller
    if (_loadFailed) return;
    // Vazife, ahit, XP ve itibar durumunu JSON metnine çevirir
    final encoded = jsonEncode({
      // Kayıt veri biçiminin sürümünü belirtir
      'version': 1,
      // Son kimlik sayacını cihaza kaydeder
      'idSequence': _idSequence,
      // Toplam XPyi cihaza kaydeder
      'xp': xp,
      // İtibarı cihaza kaydeder
      'reputation': reputation,
      // Geri dönüş sayısını cihaza kaydeder
      'comebackCount': comebackCount,
      // Son kontrol edilen günü cihaza kaydeder
      'lastCheckedDate': lastCheckedDate,
      // Planlı dinlenme günlerini cihaza kaydeder
      'restDates': restDates.toList(),
      // Vazifeleri JSON listesine dönüştürerek kaydeder
      'habits': habits.map((h) => h.toJson()).toList(),
      // Ahitleri JSON listesine dönüştürerek kaydeder
      'pacts': pacts.map((p) => p.toJson()).toList(),
    });
    // Yeni kayıt işlemini önceki yazma tamamlandıktan sonra başlatır
    _writeQueue = _writeQueue
        // Önceki asenkron iş bitince sonraki adımı çalıştırır
        .then((_) => _store.write(encoded))
        // Asenkron kayıt hatasını yakalar
        .catchError((Object error) {
      // Hata veya durum bilgisini geliştirici konsoluna yazar
      debugPrint('Yerel kayıt hatası: $error');
    });
  }
}

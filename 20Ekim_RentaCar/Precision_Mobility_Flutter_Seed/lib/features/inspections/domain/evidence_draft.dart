// kanıt template dosyasını ekler
import 'evidence_template.dart';
/// 20 açılı araç inceleme taslağı modeli.
/// Slot durumlarını, kabul edilen fotoğraf sayısını ve JSON serileştirme/geri yükleme işlemlerini yönetir.
// kanıt taslak için sınıf oluşturur
class EvidenceDraft {
  // kanıt taslak nesnesi oluşturur
  EvidenceDraft(this.bookingId) {
    // Liste veya metin boşsa koşulu çalıştırır
    if (bookingId.isEmpty) {
      // Geçersiz parametre hatası verir
      throw ArgumentError('Örnek rezervasyon kimliği gerekli.');
    }
  }
  /// Bağlı olduğu rezervasyonun kimliği
  // rezervasyon ID bilgisini tutar
  final String bookingId;
  // 20 çekim açısına karşılık gelen slot listesi
  // slots değerini tanımlar
  final List<EvidenceSlot> _slots =
      // kanıt slot constructorını tanımlar
      List.generate(20, (_) => const EvidenceSlot());
  /// Slotların dışarıdan salt-okunur listesi
  // slots bilgisini döndürür
  List<EvidenceSlot> get slots => List.unmodifiable(_slots);
  /// Kabul edilmiş slotların toplam adedi
  // accepted sayı bilgisini döndürür
  int get acceptedCount => _slots
      // Koşula uyan elemanları filtreler
      .where((s) =>
          // s değerini günceller
          s.status == EvidenceStatus.received &&
          // s değerini günceller
          s.review == EvidenceReview.accepted)
      // Önceki ifade üzerinde ek işlem uygular
      .length;
  /// Tüm 20 açının başarıyla incelenip kabul edilip edilmediği
  // durum complete bilgisini döndürür
  bool get isComplete => acceptedCount == evidenceAngles.length;
  /// Belirtilen açı için yükleme işlemini başlatır.
  // başlangıç upload işlemini gerçekleştirir
  void startUpload(int index) {
    // İlgili metodu çalıştırır
    _validate(index);
    // Koşul doğruysa bu işlemi çalıştırır
    if (_slots[index].status == EvidenceStatus.uploading) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Bu örnek yükleme zaten sürüyor.');
    }
    // slots değerini günceller
    _slots[index] = const EvidenceSlot(status: EvidenceStatus.uploading);
  }
  /// Kanıtın sunucuya ulaştığını ve alındı zaman damgasını kaydeder.
  // receive işlemini gerçekleştirir
  void receive(int index, DateTime now) {
    // İlgili metodu çalıştırır
    _validate(index);
    // Koşul doğruysa bu işlemi çalıştırır
    if (_slots[index].status != EvidenceStatus.uploading) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Başlatılmış örnek yükleme gerekli.');
    }
    // slots değerini günceller
    _slots[index] =
        // kanıt slot nesnesi oluşturur
        EvidenceSlot(status: EvidenceStatus.received, receivedAt: now);
  }
  /// Yükleme başarısızlığını simüle eder.
  // fail işlemini gerçekleştirir
  void fail(int index) {
    // İlgili metodu çalıştırır
    _validate(index);
    // Koşul doğruysa bu işlemi çalıştırır
    if (_slots[index].status != EvidenceStatus.uploading) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Başlatılmış örnek yükleme gerekli.');
    }
    // slots değerini günceller
    _slots[index] = const EvidenceSlot(status: EvidenceStatus.failed);
  }
  /// Alınan kanıtı insan denetimiyle kabul eder veya yeniden çekim ister.
  // review işlemini gerçekleştirir
  void review(int index, {required bool accepted}) {
    // İlgili metodu çalıştırır
    _validate(index);
    // slot değerini belirler
    final slot = _slots[index];
    // Koşul doğruysa bu işlemi çalıştırır
    if (slot.status != EvidenceStatus.received ||
        // Koşul veya parametre ifadesini devam ettirir
        (accepted && slot.review == EvidenceReview.retake)) {
      // İşlem başarısız olduğunda hata oluşturur
      throw StateError('Örnek alındı kaydı olmadan inceleme yapılamaz.');
    }
    // slots değerini günceller
    _slots[index] = EvidenceSlot(
        // Durum bilgisini belirler
        status: slot.status,
        // received at bilgisini belirler
        receivedAt: slot.receivedAt,
        // review bilgisini belirler
        review: accepted ? EvidenceReview.accepted : EvidenceReview.retake);
  }
  // doğrulama işlemini gerçekleştirir
  void _validate(int index) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (index < 0 || index >= _slots.length) {
      // İşlem başarısız olduğunda hata oluşturur
      throw RangeError.index(index, _slots);
    }
  }
  // to json işlemini gerçekleştirir
  Map<String, Object?> toJson() => {
        // İlgili metin değerini belirler
        'version': inspectionTemplateVersion,
        // İlgili metin değerini belirler
        'bookingId': bookingId,
        // İlgili metin değerini belirler
        'slots': [
          // Listedeki öğeleri veya indeksleri sırayla dolaşır
          for (final slot in _slots)
            // Veri alanlarını tanımlar
            {
              // İlgili metin değerini belirler
              'status': slot.status.name,
              // İlgili metin değerini belirler
              'review': slot.review.name,
              // İlgili metin değerini belirler
              'receivedAt': slot.receivedAt?.toIso8601String(),
            }
        ],
      };
  // restore verisinden yeni nesne oluşturur
  factory EvidenceDraft.restore(Map<String, Object?> json,
      // Veri alanlarını tanımlar
      {required String expectedBookingId}) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (json['version'] != inspectionTemplateVersion ||
        // Önceki ifadeyi tamamlar
        json['bookingId'] != expectedBookingId ||
        // Önceki ifadeyi tamamlar
        json['slots'] is! List ||
        // Koşul veya parametre ifadesini devam ettirir
        (json['slots'] as List).length != evidenceAngles.length) {
      // Veri biçimi hatası oluşturur
      throw const FormatException('Uyumsuz örnek inceleme taslağı.');
    }
    // taslak değerini belirler
    final draft = EvidenceDraft(expectedBookingId);
    // Hata oluşabilecek işlemleri dener
    try {
      // slots değerini belirler
      final slots = json['slots'] as List;
      // Listedeki öğeleri veya indeksleri sırayla dolaşır
      for (var i = 0; i < slots.length; i++) {
        // raw değerini belirler
        final raw = slots[i] as Map;
        // durum değerini belirler
        var status = EvidenceStatus.values.byName(raw['status'] as String);
        // review değerini belirler
        final review = EvidenceReview.values.byName(raw['review'] as String);
        // zaman değerini belirler
        final time = raw['receivedAt'] == null
            // Koşul doğruysa bu değeri seçer
            ? null
            // Koşul yanlışsa bu değeri seçer
            : DateTime.parse(raw['receivedAt'] as String);
        // Koşul doğruysa bu işlemi çalıştırır
        if (status == EvidenceStatus.uploading) status = EvidenceStatus.failed;
        // Değer null değilse koşulu çalıştırır
        if ((status == EvidenceStatus.received) != (time != null) ||
            // Koşul veya parametre ifadesini devam ettirir
            (status != EvidenceStatus.received &&
                // İfadeye karşılaştırma koşulu ekler
                review != EvidenceReview.pending)) {
          // Veri biçimi hatası oluşturur
          throw const FormatException('Geçersiz örnek kayıt durumu.');
        }
        // taslak değerini günceller
        draft._slots[i] =
            // kanıt slot nesnesi oluşturur
            EvidenceSlot(status: status, review: review, receivedAt: time);
      }
    // İşlem hata verirse çalışır
    } catch (_) {
      // Veri biçimi hatası oluşturur
      throw const FormatException('Bozuk örnek inceleme kaydı.');
    }
    // taslak bilgisini tutar
    return draft;
  }
}

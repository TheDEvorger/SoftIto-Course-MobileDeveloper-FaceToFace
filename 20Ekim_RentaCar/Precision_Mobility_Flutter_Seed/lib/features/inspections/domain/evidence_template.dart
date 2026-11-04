/// Denetim şablonu sürüm kodu
// kontrol template version değerini belirler
const inspectionTemplateVersion = 'demo-20-v1';
/// Araç tesliminde ve iadesinde fotoğraflanması gereken standart 20 çekim açısı
// kanıt angles değerini belirler
const evidenceAngles = [
  // İlgili metin değerini belirler
  'Ön genel',
  // İlgili metin değerini belirler
  'Arka genel',
  // İlgili metin değerini belirler
  'Sol genel',
  // İlgili metin değerini belirler
  'Sağ genel',
  // İlgili metin değerini belirler
  'Sol ön köşe',
  // İlgili metin değerini belirler
  'Sağ ön köşe',
  // İlgili metin değerini belirler
  'Sol arka köşe',
  // İlgili metin değerini belirler
  'Sağ arka köşe',
  // İlgili metin değerini belirler
  'Ön cam',
  // İlgili metin değerini belirler
  'Arka cam',
  // İlgili metin değerini belirler
  'Tavan',
  // İlgili metin değerini belirler
  'Kaput',
  // İlgili metin değerini belirler
  'Sol ön jant',
  // İlgili metin değerini belirler
  'Sağ ön jant',
  // İlgili metin değerini belirler
  'Sol arka jant',
  // İlgili metin değerini belirler
  'Sağ arka jant',
  // İlgili metin değerini belirler
  'Ön kabin',
  // İlgili metin değerini belirler
  'Arka kabin',
  // İlgili metin değerini belirler
  'Bagaj',
  // İlgili metin değerini belirler
  'Gösterge paneli',
];
/// Kanıt slotu yükleme durumları
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum EvidenceStatus { missing, uploading, failed, received }
/// Kanıt insan inceleme durumu (beklemede, kabul edildi, yeniden çekim istendi)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum EvidenceReview { pending, accepted, retake }
/// 20 açıdan birine ait kanıt kaydı slotu
// kanıt slot için sınıf oluşturur
class EvidenceSlot {
  // kanıt slot nesnesi oluşturur
  const EvidenceSlot(
      // Veri alanlarını tanımlar
      {this.status = EvidenceStatus.missing,
      // this değerini günceller
      this.review = EvidenceReview.pending,
      // received at parametresini alır
      this.receivedAt});
  /// Slotun yükleme durumu
  // durum bilgisini tutar
  final EvidenceStatus status;
  /// Slotun inceleme onay durumu
  // review bilgisini tutar
  final EvidenceReview review;
  /// Sunucuya/sisteme ulaştığı an (temsili zaman)
  // received at bilgisini tutar
  final DateTime? receivedAt;
  /// Temsili alındı makbuz numarası (kriptografik iddia içermez)
  // örnek receipt bilgisini döndürür
  String? get demoReceipt => receivedAt == null
      // Koşul doğruysa bu değeri seçer
      ? null
      // Koşul yanlışsa bu değeri seçer
      : 'demo-receipt-${receivedAt!.microsecondsSinceEpoch}';
}

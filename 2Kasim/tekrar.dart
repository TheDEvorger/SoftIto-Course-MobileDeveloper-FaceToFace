// Ödeme sonucunun yalnızca tanımlı alt türlerden oluşmasını sağlar
sealed class OdemeDurumu {}
// Başarılı ödeme sonucunu temsil eder
class OdemeBasarili extends OdemeDurumu {
  // Referans kodu ve tutarı tek bir Record içinde tutar
  final ({String referansKodu, double tutar}) veri;
  // Başarı bilgilerini constructor ile alır
  OdemeBasarili(this.veri);
}
// Başarısız ödeme sonucunu temsil eder
class OdemeBasarisiz extends OdemeDurumu {
  // Ödemenin neden başarısız olduğunu saklar
  final String hataNedeni;
  // Hata açıklamasını constructor ile alır
  OdemeBasarisiz(this.hataNedeni);
}
// Ödeme servisinin uyması gereken metodu tanımlar
abstract class IBankServisi {
  // Zorunlu tutar alır, gelecekte ödeme sonucu döndürür
  Future<OdemeDurumu> odemeYap({required double miktar});
}
// Sınıflara token kontrolü özelliği eklemek için mixin
mixin GuvenlikDenetimMixin {
  // Gönderilen tokenın geçerli olup olmadığını kontrol eder
  bool tokenGecerliMi(String token) {
    // Token boş değilse ve en az 32 karakterse true döner
    return token.isNotEmpty && token.length >= 32;
  }
}
// Sınıflara işlem günlüğü yazma özelliği ekler
mixin AuditLogMixin {
  // Verilen mesajı tarih bilgisiyle yazdırır
  void islemiKaydet(String mesaj) {
    // Şu anki zamanı ISO biçiminde metne dönüştürür
    final zaman = DateTime.now().toIso8601String();
    // Tarih ve mesajı konsola yazar
    print('Log - $zaman - $mesaj');
  }
}
// Ödeme servisinin sınıfını tanımlar
class GarantiBankasiServisi
    // İki mixindeki metotları bu sınıfa katar
    with GuvenlikDenetimMixin, AuditLogMixin
    // Banka servisinin sözleşmesini uygular
    implements IBankServisi {
  // Token olarak kullanılan API anahtarını tutar
  final String apiAnahtari;
  // API anahtarını zorunlu constructor parametresi olarak alır
  GarantiBankasiServisi({required this.apiAnahtari});
  // Arayüzde tanımlı ödeme metodunu uygular
  @override
  // Gelen tutar için asenkron ödeme sonucu üretir
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    // API anahtarının uzunluğunu ve boşluğunu kontrol eder
    if (!tokenGecerliMi(apiAnahtari)) {
      // Geçersiz token uyarısını işlem günlüğüne yazar
      islemiKaydet('Ödeme Reddedildi: Geçersiz API anahtarı');
      // Başarısız ödeme sonucu döndürür
      return OdemeBasarisiz('Yetkilendirme hatası:Geçersiz Token');
    }
    // Bir saniye gecikme ekler, gerçek ödeme isteği göndermez
    await Future.delayed(const Duration(milliseconds: 1000));
    // Onay mesajını günlüğe yazmak için çağrı başlatır
    islemiKaydet(
      // Tutar bilgisini onay mesajına ekler
      '$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI',
    );
    // Başarılı ödeme sonucu için Record oluşturur
    return OdemeBasarili((
      // Güncel zamandan örnek referans kodu üretir
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      // Ödenen tutarı sonuç bilgisine ekler
      tutar: miktar,
    ));
  }
}
// Ödeme sonucunu uygun mesaja çevirip yazdırır
void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  // Sealed alt sınıfına göre bir mesaj seçer
  final mesaj = switch (durum) {
    // Sonuç başarılıysa bu kol çalışır
    OdemeBasarili b =>
      // Başarı mesajına referans kodu ve tutarı ekler
      'Ödeme Başarılı! Referans Kodu: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}',
    // Başarısızsa hata nedenini mesaja ekler
    OdemeBasarisiz h => 'Ödeme Başarısız! Hata Nedeni: ${h.hataNedeni}',
  };
  // Oluşan mesajı konsola yazdırır
  print(mesaj);
}
// Asenkron örneğin başlangıç fonksiyonu
void main() async {
  // Örnek banka servisi nesnesi oluşturur
  final garantiBankasi = GarantiBankasiServisi(
    // Kontrolü geçen 32 karakterlik örnek token gönderir
    apiAnahtari: '12345678901234567890123456789012',
  );
  // 550 tutarında örnek işlem sonucunu bekler
  final odemeDurumu = await garantiBankasi.odemeYap(miktar: 550.0);
  // İşlem sonucunu ekrana yazdıran fonksiyona gönderir
  odemeSonucunuEkranaBas(odemeDurumu);
}

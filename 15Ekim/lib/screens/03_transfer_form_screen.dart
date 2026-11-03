// Flutter arayüz kütüphanesi
import 'package:flutter/material.dart';
// İşlem modelini projeye ekler
import '../models/transation_model.dart';

// Veriler değişeceği için StatefulWidget kullanılır
class TransferFormScreen extends StatefulWidget {
  // Sınıfın constructorı
  const TransferFormScreen({super.key});
  // Üstteki createState metodunu uygular
  @override
  // State sınıfını oluşturur
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

// Transfer ekranının değişen verilerini tutar
class _TransferFormScreenState extends State<TransferFormScreen> {
  // Başlangıç bakiyesini tutar
  double _balance = 148950.50;
  // Transfer geçmişini tutan liste
  final List<TransactionItem> _history = [
    // İlk transfer kaydı
    const TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_init_1',
      // Alıcının adı
      title: 'Ahmet Yılmaz',
      // İşlemin kategorisi
      category: 'Hızlı Transfer',
      // İşlem tarihi
      date: 'Bugün, 11:30',
      // Gönderilen tutar
      amount: 1500.00,
      // Gider olduğu için true
      isExpense: true,
      // Gönderme simgesi
      icon: Icons.send_rounded,
    ),
    // İkinci transfer kaydı
    const TransactionItem(
      // İşlemin ID bilgisi
      id: 'tx_init_2',
      // Alıcının adı
      title: 'Merve Demir',
      // İşlemin kategorisi
      category: 'Hızlı Transfer',
      // İşlem tarihi
      date: 'Dün, 15:45',
      // Gönderilen tutar
      amount: 2400.00,
      // Gider olduğu için true
      isExpense: true,
      // Gönderme simgesi
      icon: Icons.send_rounded,
    ),
  ];
  // Transfer penceresini açan metot
  void _openTransferModal() {
    // Ekranın altından açılır pencere gösterir
    showModalBottomSheet(
      // Bulunduğu ekranın context bilgisi
      context: context,
      // Klavye açıldığında pencerenin büyümesini sağlar
      isScrollControlled: true,
      // Pencerenin arka plan rengi
      backgroundColor: Colors.white,
      // Pencerenin şeklini belirler
      shape: const RoundedRectangleBorder(
        // Üst köşeleri yuvarlar
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      // Açılacak pencerenin içeriğini oluşturur
      builder: (ctx) {
        // Transfer formunu ekrana getirir
        return _TransferBottomSheet(
          // Güncel bakiyeyi forma gönderir
          currentBalance: _balance,
          // Transfer onaylanınca tutar ve alıcı bilgilerini alır
          onTransferConfirmed: (amount, recipient) {
            // Değişiklikleri ekrana yansıtır
            setState(() {
              // Gönderilen tutarı bakiyeden düşer
              _balance -= amount;
              // Yeni transferi geçmiş listesine ekler
              _history.insert(
                // Listenin başına ekler
                0,
                // Yeni işlem kaydı oluşturur
                TransactionItem(
                  // Zaman bilgisinden benzersiz ID üretir
                  id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                  // Alıcı adını kaydeder
                  title: recipient,
                  // İşlem kategorisi
                  category: 'Hızlı Transfer',
                  // İşlem zamanını şimdi olarak gösterir
                  date: 'Şimdi',
                  // Gönderilen tutarı kaydeder
                  amount: amount,
                  // Para çıkışı olduğu için true
                  isExpense: true,
                  // Transfer simgesi
                  icon: Icons.send_rounded,
                ),
              );
            });
            // Transfer tamamlanınca bilgilendirme mesajı gösterir
            ScaffoldMessenger.of(context).showSnackBar(
              // Ekranda kısa süreli mesaj oluşturur
              SnackBar(
                // Mesajın arka planını yeşil yapar
                backgroundColor: const Color(0xFF10B981),
                // Mesajı yüzen kutu şeklinde gösterir
                behavior: SnackBarBehavior.floating,
                // Dış taraftan 16 boşluk bırakır
                margin: const EdgeInsets.all(16),
                // Mesajın köşelerini yuvarlar
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                // Mesaj içindeki elemanları yan yana dizer
                content: Row(
                  // Row içindeki elemanlar
                  children: [
                    // Başarılı işlem simgesi
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    // Yatayda 10 boşluk bırakır
                    const SizedBox(width: 10),
                    // Yazının kalan alana yayılmasını sağlar
                    Expanded(
                      // Transfer sonucunu gösterir
                      child: Text(
                        // Tutarı ve alıcı adını mesaj içinde gösterir
                        '₺${amount.toStringAsFixed(2)} tutarındaki transfer $recipient kişisine başarıyla gönderildi!',
                        // Yazıyı yarı kalın yapar
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Transfer ekranının arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Sayfanın kaydırılmasını sağlar
    return SingleChildScrollView(
      // Kaydırma sonunda esneme efekti verir
      physics: const BouncingScrollPhysics(),
      // Her taraftan 20 boşluk bırakır
      padding: const EdgeInsets.all(20),
      // Elemanları alt alta dizer
      child: Column(
        // Elemanları sola hizalar
        crossAxisAlignment: CrossAxisAlignment.start,
        // Column içindeki elemanları tutar
        children: [
          // Bakiye kartını oluşturur
          Container(
            // Kartın iç boşluğu
            padding: const EdgeInsets.all(20),
            // Kartın görünüm ayarları
            decoration: BoxDecoration(
              // Arka planı beyaz yapar
              color: Colors.white,
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(20),
              // İnce kenarlık ekler
              border: Border.all(color: const Color(0xFFE2E8F0)),
              // Karta gölge ekler
              boxShadow: const [
                // Gölgenin ayarları
                BoxShadow(
                    // Gölgenin rengi
                    color: Color(0x05000000),
                    // Gölgeyi aşağı kaydırır
                    offset: Offset(0, 4),
                    // Gölgenin bulanıklığı
                    blurRadius: 10),
              ],
            ),
            // Bakiye ve butonu yan yana dizer
            child: Row(
              // Elemanları iki yana dağıtır
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Row içindeki elemanlar
              children: [
                // Bakiye bilgilerini alt alta dizer
                Column(
                  // Elemanları sola hizalar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Column içindeki elemanlar
                  children: [
                    // Bakiye başlığını gösterir
                    const Text('Kullanılabilir Bakiye',
                        // Başlığın yazı stili
                        style:
                            // Yazı boyutu ve rengi
                            TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    // Dikeyde 4 boşluk bırakır
                    const SizedBox(height: 4),
                    // Güncel bakiye tutarını gösterir
                    Text(
                      // Bakiyeyi 2 ondalık basamakla yazar
                      '₺${_balance.toStringAsFixed(2)}',
                      // Tutarın yazı stili
                      style: const TextStyle(
                          // Yazı boyutu
                          fontSize: 24,
                          // Yazıyı kalın yapar
                          fontWeight: FontWeight.bold,
                          // Yazı rengini belirler
                          color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                // Simge ve yazı içeren transfer butonu
                ElevatedButton.icon(
                  // Butonun görünümünü ayarlar
                  style: ElevatedButton.styleFrom(
                    // Butonun arka plan rengi
                    backgroundColor: const Color(0xFF6366F1),
                    // Yazı ve simge rengini beyaz yapar
                    foregroundColor: Colors.white,
                    // Butonun köşelerini yuvarlar
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  // Butona basılınca transfer penceresini açar
                  onPressed: _openTransferModal,
                  // Butonun simgesi
                  icon: const Icon(Icons.send_rounded, size: 18),
                  // Butonun yazısı
                  label: const Text('Transfer Yap'),
                ),
              ],
            ),
          ),
          // Dikeyde 24 boşluk bırakır
          const SizedBox(height: 24),
          // Bilgilendirme kutusu oluşturur
          Container(
            // Kutunun iç boşluğu
            padding: const EdgeInsets.all(14),
            // Kutunun görünüm ayarları
            decoration: BoxDecoration(
              // Açık mor arka plan verir
              color: const Color(0xFFEEF2FF),
              // Köşeleri yuvarlar
              borderRadius: BorderRadius.circular(14),
              // Kenarlık ekler
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            // Simge ve açıklamayı yan yana dizer
            child: const Row(
              // Row içindeki elemanlar
              children: [
                // Güvenlik simgesini gösterir
                Icon(Icons.security, color: Color(0xFF4F46E5), size: 24),
                // Yatayda 10 boşluk bırakır
                SizedBox(width: 10),
                // Metni kalan alana yayar
                Expanded(
                  // Bilgilendirme yazısını gösterir
                  child: Text(
                    // Formda kullanılan yapıları açıklar
                    'Form girişlerinde GlobalKey<FormState> ve TextEditingController kullanılmıştır. Geçersiz tutar veya bakiye yetersizliğinde kırmızı uyarı verir.',
                    // Yazı boyutu, rengi ve satır yüksekliği
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFF3730A3), height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          // Dikeyde 24 boşluk bırakır
          const SizedBox(height: 24),
          // Transfer geçmişi başlığını gösterir
          const Text(
            // Başlık yazısı
            'Transfer Geçmişi (Dinamik Liste)',
            // Başlığın yazı stili
            style: TextStyle(
                // Yazı boyutu
                fontSize: 16,
                // Yazıyı kalın yapar
                fontWeight: FontWeight.bold,
                // Yazının rengi
                color: Color(0xFF0F172A)),
          ),
          // Dikeyde 12 boşluk bırakır
          const SizedBox(height: 12),
          // İşlemleri aralarına çizgi koyarak listeler
          ListView.separated(
            // Liste içeriği kadar yer kaplar
            shrinkWrap: true,
            // Listenin kendi kaydırmasını kapatır
            physics: const NeverScrollableScrollPhysics(),
            // Geçmişteki işlem sayısını alır
            itemCount: _history.length,
            // İşlemlerin arasına ayırıcı çizgi koyar
            separatorBuilder: (context, index) =>
                // Çizginin boyutunu ve rengini belirler
                const Divider(height: 1, indent: 64, color: Color(0xFFF1F5F9)),
            // Her işlem için liste elemanı oluşturur
            itemBuilder: (context, index) {
              // İlgili indeksteki işlemi getirir
              final item = _history[index];
              // Hazır liste satırı oluşturur
              return ListTile(
                // Satırın varsayılan iç boşluğunu kaldırır
                contentPadding: EdgeInsets.zero,
                // Sol taraftaki simge alanı
                leading: Container(
                  // Simge kutusunun genişliği
                  width: 44,
                  // Simge kutusunun yüksekliği
                  height: 44,
                  // Simge kutusunun görünümü
                  decoration: BoxDecoration(
                    // Açık kırmızı arka plan verir
                    color: const Color(0x1FEF4444),
                    // Köşeleri yuvarlar
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Yukarı ok simgesini gösterir
                  child: const Icon(Icons.arrow_upward,
                      // Simgenin rengi ve boyutu
                      color: Color(0xFFEF4444),
                      size: 20),
                ),
                // Alıcının adını gösterir
                title: Text(item.title,
                    // Başlığın yazı stili
                    style: const TextStyle(
                        // Yazı kalınlığı ve boyutu
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                // İşlem kategorisini ve tarihini gösterir
                subtitle: Text('${item.category} • ${item.date}',
                    // Alt yazının stili
                    style: const TextStyle(
                        // Yazı boyutu ve rengi
                        fontSize: 12,
                        color: Color(0xFF64748B))),
                // Sağ tarafta gönderilen tutarı gösterir
                trailing: Text(
                  // Tutarı eksi işaretiyle ve 2 ondalıkla yazar
                  '-₺${item.amount.toStringAsFixed(2)}',
                  // Tutarın yazı stili
                  style: const TextStyle(
                      // Yazıyı kalın yapar
                      fontWeight: FontWeight.bold,
                      // Yazı boyutunu belirler
                      fontSize: 14,
                      // Yazıyı kırmızı yapar
                      color: Color(0xFFEF4444)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Alt tarafta açılan transfer formunu oluşturur
class _TransferBottomSheet extends StatefulWidget {
  // Güncel bakiyeyi tutar
  final double currentBalance;
  // Transfer onaylanınca tutar ve alıcıyı geri gönderen callback
  final Function(double amount, String recipient) onTransferConfirmed;
  // Constructor, iki parametrenin verilmesini zorunlu tutar
  const _TransferBottomSheet({
    // Güncel bakiye zorunlu parametre
    required this.currentBalance,
    // Transfer onaylama fonksiyonu zorunlu parametre
    required this.onTransferConfirmed,
  });
  // Üstteki createState metodunu uygular
  @override
  // Formun State sınıfını oluşturur
  State<_TransferBottomSheet> createState() => _TransferBottomSheetState();
}

// Formdaki değişen verileri yöneten State sınıfı
class _TransferBottomSheetState extends State<_TransferBottomSheet> {
  // Formun durumunu kontrol etmek için GlobalKey kullanılır
  final _formKey = GlobalKey<FormState>();
  // Alıcı bilgisini kontrol eden controller
  late final TextEditingController _recipientController;
  // Tutar bilgisini kontrol eden controller
  late final TextEditingController _amountController;
  // Üstteki initState metodunu yeniden yazar
  @override
  // Widget ilk oluşturulduğunda bir kere çalışır
  void initState() {
    // Üst sınıfın initState metodunu çalıştırır
    super.initState();
    // Alıcı için controller oluşturur
    _recipientController = TextEditingController();
    // Tutar için controller oluşturur
    _amountController = TextEditingController();
  }

  // Üstteki dispose metodunu yeniden yazar
  @override
  // Widget kaldırılırken kaynakları temizler
  void dispose() {
    // Alıcı controllerını temizler
    _recipientController.dispose();
    // Tutar controllerını temizler
    _amountController.dispose();
    // Üst sınıfın dispose metodunu çalıştırır
    super.dispose();
  }

  // Transfer formunu onaylayan metot
  void _submit() {
    // Formdaki bütün alanlar geçerliyse çalışır
    if (_formKey.currentState!.validate()) {
      // Girilen tutarı Stringden double tipine çevirir
      final amount = double.parse(_amountController.text.trim());
      // Alıcı bilgisini alır, boşlukları temizler
      final recipient = _recipientController.text.trim();
      // Açık olan transfer penceresini kapatır
      Navigator.pop(context);
      // Tutar ve alıcı bilgisini üst widgeta gönderir
      widget.onTransferConfirmed(amount, recipient);
    }
  }

  // Üstteki build metodunu yeniden yazar
  @override
  // Transfer formunun arayüzünü oluşturur
  Widget build(BuildContext context) {
    // Formun çevresine boşluk bırakır
    return Padding(
      // Her kenarın boşluğunu ayrı ayrı belirler
      padding: EdgeInsets.only(
        // Sol boşluk
        left: 24,
        // Sağ boşluk
        right: 24,
        // Üst boşluk
        top: 20,
        // Klavye açılınca alttaki boşluğu artırır
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      // Form alanlarını bir arada yönetir
      child: Form(
        // Formun durumunu kontrol eden key
        key: _formKey,
        // Form elemanlarını alt alta dizer
        child: Column(
          // Column sadece içeriği kadar yer kaplar
          mainAxisSize: MainAxisSize.min,
          // Elemanları sola hizalar
          crossAxisAlignment: CrossAxisAlignment.start,
          // Form içindeki elemanları tutar
          children: [
            // Üstteki küçük çizgiyi ortalar
            Center(
              // Çizgi için kutu oluşturur
              child: Container(
                // Çizginin genişliği
                width: 40,
                // Çizginin yüksekliği
                height: 4,
                // Çizginin görünümünü ayarlar
                decoration: BoxDecoration(
                    // Çizginin rengi
                    color: const Color(0xFFCBD5E1),
                    // Köşeleri yuvarlar
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            // Dikeyde 16 boşluk bırakır
            const SizedBox(height: 16),
            // Transfer formunun başlığını gösterir
            const Text('Hızlı Para Transferi',
                // Başlığın boyutunu ve kalınlığını belirler
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Dikeyde 4 boşluk bırakır
            const SizedBox(height: 4),
            // Güncel bakiyeyi gösterir
            Text(
              // Üst widgettan gelen bakiyeyi 2 ondalıkla yazar
              'Mevcut Bakiyeniz: ₺${widget.currentBalance.toStringAsFixed(2)}',
              // Yazı boyutu ve rengi
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            // Dikeyde 16 boşluk bırakır
            const SizedBox(height: 16),
            // Alıcı bilgisinin girileceği form alanı
            TextFormField(
              // Girilen alıcı bilgisini controller ile yönetir
              controller: _recipientController,
              // Metin kutusunun görünüm ayarları
              decoration: InputDecoration(
                // Alanın başlığı
                labelText: 'Alıcı Adı veya Cüzdan Adresi',
                // Örnek giriş metni
                hintText: 'Ör: Ahmet Yılmaz',
                // Alanın solundaki kullanıcı simgesi
                prefixIcon: const Icon(Icons.person_outline),
                // Metin kutusunun kenarlığını ayarlar
                border:
                    // Kenarlığı oluşturur ve köşeleri yuvarlar
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              // Girilen alıcı bilgisini kontrol eder
              validator: (v) {
                // Alan boşsa veya 3 karakterden kısaysa hata verir
                if (v == null || v.trim().length < 3) {
                  // Hata mesajını döndürür
                  return 'En az 3 karakterli geçerli alıcı girin';
                }
                // Hata yoksa null döndürür
                return null;
              },
            ),
            // Dikeyde 12 boşluk bırakır
            const SizedBox(height: 12),
            // Gönderilecek tutarın girileceği form alanı
            TextFormField(
              // Tutar bilgisini controller ile yönetir
              controller: _amountController,
              // Klavyeyi sayısal girişe uygun açar
              keyboardType:
                  // Ondalıklı sayı girişine izin veren klavye
                  const TextInputType.numberWithOptions(decimal: true),
              // Metin kutusunun görünüm ayarları
              decoration: InputDecoration(
                // Alanın başlığı
                labelText: 'Gönderilecek Tutar (₺)',
                // Örnek tutar gösterir
                hintText: '0.00',
                // Alanın solundaki ödeme simgesi
                prefixIcon: const Icon(Icons.payments_outlined),
                // Metin kutusunun kenarlığını ayarlar
                border:
                    // Kenarlığı oluşturur ve köşeleri yuvarlar
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              // Girilen tutarın geçerliliğini kontrol eder
              validator: (v) {
                // Tutar boşsa hata verir
                if (v == null || v.trim().isEmpty) {
                  // Boş tutar hata mesajı
                  return 'Lütfen bir tutar girin';
                }
                // Metni double tipine çevirmeyi dener
                final val = double.tryParse(v.trim());
                // Sayıya çevrilemezse veya sıfırdan büyük değilse hata verir
                if (val == null || val <= 0) {
                  // Geçersiz tutar mesajını döndürür
                  return 'Geçerli bir pozitif tutar girin';
                }
                // Tutar mevcut bakiyeyi geçiyorsa hata verir
                if (val > widget.currentBalance) {
                  // Yetersiz bakiye mesajını döndürür
                  return 'Yetersiz bakiye!';
                }
                // Kontroller başarılıysa null döndürür
                return null;
              },
            ),
            // Dikeyde 20 boşluk bırakır
            const SizedBox(height: 20),
            // Onay butonu için alan oluşturur
            SizedBox(
              // Butonun mümkün olan genişliği kaplamasını sağlar
              width: double.infinity,
              // Butonun yüksekliği
              height: 50,
              // Transferi onaylamak için buton oluşturur
              child: ElevatedButton(
                // Butonun görünümünü ayarlar
                style: ElevatedButton.styleFrom(
                  // Butonun arka plan rengi
                  backgroundColor: const Color(0xFF6366F1),
                  // Yazı rengini beyaz yapar
                  foregroundColor: Colors.white,
                  // Butonun köşelerini yuvarlar
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                // Butona basılınca _submit metodunu çalıştırır
                onPressed: _submit,
                // Butonun yazısını gösterir
                child: const Text('Transferi Gerçekleştir',
                    // Buton yazısının stili
                    style:
                        // Yazı boyutu ve kalınlığı
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

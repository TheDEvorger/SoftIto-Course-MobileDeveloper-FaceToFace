// Asenkron işlemler için kütüphane eklentisi
import 'dart:async';

// Giriş çıkış işlemlerinin ortak sözleşme
abstract class AuthRepository {
  // Giriş yapar geriye String döndürür
  Future<String> login(String email, String password);
  // Çıkış yapar değer döndürmez
  Future<void> logout();
  // Giriş durumunu bool olarak verir
  bool get isAuth;
}

// Firebase için sözleşmeyi uygular
class FirebaseAuthRepository implements AuthRepository {
  // Üstteki login metodunun üzerine yazar
  @override
  // Email şifre alır asenkron çalışır
  Future<String> login(String email, String password) async {
    // Örnek token döndürür
    return "firebase_token_xyz_123";
  }

  // Üstteki logout metodunu uygular
  @override
  // Asenkron çıkış işlemi
  Future<void> logout() async {
    // Firebase çıkış kodu buraya gelir
  }

  // Üstteki getterı uygular
  @override
  // Giriş yapılmış kabul eder
  bool get isAuth => true;
}

// Test için sahte giriş sınıfı
class MockAuthRepository implements AuthRepository {
  // Login metodunu burada uygular
  @override
  // Sahte giriş işlemi
  Future<String> login(String email, String password) async {
    // 1 saniye bekler
    await Future.delayed(Duration(seconds: 1));
    // Sahte token döndürür
    return "mock_token_abc_789";
  }

  // Logout metodunu uygular
  @override
  // İşlem yapmadan tamamlanır
  Future<void> logout() async {}

  // Getterı burada uygular
  @override
  // Giriş yapılmamış kabul eder
  bool get isAuth => false;
}

// Log özelliğini sınıflara eklemek için mixin
mixin Logger {
  // Gelen mesajı yazdırır
  void log(String msg) => print("LOG:$msg");
}

// Analitik işlemler için mixin
mixin Analytics {
  // Gelen olay bilgisini yazdırır
  void track(String msg) => print("Analitik:$msg");
}

// with ile iki mixini de kullanır
class PaymentService with Logger, Analytics {
  // Ödeme metodu
  void pay() {
    // Logger içindeki metodu çağırır
    log("Ödeme Yapıldı");
    // Analytics içindeki metodu çağırır
    track("payment_completed");
  }
}

// Temel sınıf
abstract class BaseWidget {}

// on sayesinde sadece BaseWidget alt türlerinde kullanılır
mixin LifeLogger on BaseWidget {
  // Başlatılma mesajını yazdırır
  void logInit() => print("Widget Başlatıldı");
}

// BaseWidgettan türer LifeLogger özelliğini alır
class MyWidget extends BaseWidget with LifeLogger {}

// String tipine yeni özellik ekler
extension StringValidator on String {
  // Email biçimini kontrol eden getter
  bool get isValidEmail {
    // Email kontrolü için regex oluşturur
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    // Eşleşme varsa true döndürür
    return emailRegex.hasMatch(this);
  }

  // İlk harfi büyük yapar
  String toCapitalize() {
    // Boşsa olduğu gibi döndürür
    if (isEmpty) return this;
    // İlk harfi büyütüp kalanını ekler
    return this[0].toUpperCase() + substring(1);
  }
}

// ID bilgisi için ortak sözleşme
abstract class Identifiable {
  // String tipinde ID ister
  String get id;
}

// T tipi Identifiable olmak zorunda
class GenericCache<T extends Identifiable> {
  // ID ve nesneleri tutan Map
  final Map<String, T> _storage = {};

  // Nesneyi kaydeder
  void save(T item) {
    // ID üzerinden Map içine ekler
    _storage[item.id] = item;
    // Kaydedilen IDyi yazdırır
    print("ID:${item.id} önbelleğe alındı");
  }

  // IDye göre getirir yoksa null döndürür
  T? getById(String id) => _storage[id];
}

// Identifiable sözleşmesini kullanan örnek sınıf
class UserRecord implements Identifiable {
  // Üstteki ID özelliğini uygular
  @override
  // Değişmeyen ID bilgisi
  final String id;
  // Constructor ile ID alır
  UserRecord(this.id);
}

// Ana fonksiyon
void main() {
  // Örnek email
  String email = "selahaddin@kodvance.com";

  // Email biçimini kontrol eder
  if (email.isValidEmail) {
    // Doğruysa yazdırır
    print("Geçerli Eposta");
    // Yanlışsa buraya girer
  } else {
    // Geçersiz mesajını yazdırır
    print("Geçersiz Eposta");
  }

  // İlk harfi büyütüp yazdırır
  print(email.toCapitalize());

  // Ödeme nesnesi oluşturur
  final payment = PaymentService();
  // Ödeme metodunu çalıştırır
  payment.pay();

  // Widget nesnesi oluşturur
  final widget = MyWidget();
  // Mixin metodunu çalıştırır
  widget.logInit();

  // UserRecord tipinde cache oluşturur
  final cache = GenericCache<UserRecord>();
  // IDsi 123 olan kullanıcıyı kaydeder
  cache.save(UserRecord("123"));
  // IDye göre bulur null değilse yazdırır
  print(cache.getById("123")?.id);

  // Senkron olduğu için ilk çalışır
  print("1.Senkron başladı");

  // Microtask kuyruğuna görev ekler
  scheduleMicrotask(() {
    // Senkron kod bitince çalışır
    print("2.Task Oluştu(Vip Kuyruk)");
  });

  // Event kuyruğuna görev ekler
  Future(() {
    // Microtasklardan sonra çalışır
    print("3.Standart Event Kuyruğu");
  });

  // Future döndüren microtask oluşturur
  Future.microtask(() {
    // İkinci microtask olarak çalışır
    print("4.Future.microtask çalıştı");
  });

  // Senkron olduğu için kuyruklardan önce çalışır
  print("5.Senkron kod tamamlandı");
}

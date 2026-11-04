// Asenkron işlem yapılarını ekler
import 'dart:async';
// JSON kodlama ve çözme işlemlerini ekler
import 'dart:convert';
// HTTP istek kütüphanesini ekler
import 'package:http/http.dart' as http;
// API exception sınıfını tanımlar ve belirtilen sözleşmeyi uygular
class ApiException implements Exception {
  // API exception nesnesi oluşturur
  const ApiException(this.message, {this.status});
  // mesaj bilgisini tutar
  final String message;
  // durum bilgisini tutar
  final int? status;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // to string işlemini gerçekleştirir
  String toString() => message;
}
// API istemci için sınıf oluşturur
class ApiClient {
  // API istemci nesnesi oluşturur
  ApiClient({required Uri baseUri, http.Client? client})
      // Constructor alanlarını başlangıç değerleriyle ayarlar
      : baseUri = validate(baseUri),
        // istemci değerini günceller
        _client = client ?? http.Client();
  // base uri bilgisini tutar
  final Uri baseUri;
  // istemci bilgisini tutar
  final http.Client _client;
  // çalışma alanı anahtarı bilgisini tutar
  String? _workspaceKey;
  // örnekler değerini belirler
  bool _examples = false;
  // örnekler bilgisini döndürür
  bool get examples => _examples;
  // çalışma alanı anahtarı bilgisini döndürür
  String? get workspaceKey => _workspaceKey;
  // çalışma alanı anahtarı işlemini gerçekleştirir
  set workspaceKey(String? value) {
    // çalışma alanı anahtarı değerini günceller
    _workspaceKey = value;
    // örnekler değerini günceller
    _examples = false;
  }
  // oturum doğrulama bilgisini döndürür
  bool get authenticated => workspaceKey?.isNotEmpty ?? false;
  // open örnekler işlemini asenkron yürütür
  Future<void> openExamples() async {
    // sonuç değerini belirler
    final result = await request('POST', 'examples/session',
        // operational bilgisini belirler
        operational: true, credential: '');
    // anahtar değerini belirler
    final key = result['workspace_key'];
    // Koşul doğruysa bu işlemi çalıştırır
    if (result['example'] != true || key is! String || key.length < 32) {
      // API hatası oluşturur
      throw const ApiException('Örnek çalışma alanı yanıtı geçersiz.');
    }
    // çalışma alanı anahtarı değerini günceller
    _workspaceKey = key;
    // örnekler değerini günceller
    _examples = true;
  }
  // connect çalışma alanı işlemini asenkron yürütür
  Future<void> connectWorkspace(String key) async {
    // Asenkron işlemin tamamlanmasını bekler
    await request('GET', 'workspace', operational: true, credential: key);
    // çalışma alanı anahtarı değerini günceller
    workspaceKey = key;
  }
  // doğrulama değerini tanımlar
  static Uri validate(Uri uri) {
    // yerel değerini belirler
    final local =
        // Liste öğelerini tanımlar
        ['localhost', '127.0.0.1', '10.0.2.2', '::1'].contains(uri.host);
    // Koşul doğruysa bu işlemi çalıştırır
    if ((uri.scheme != 'https' && !(uri.scheme == 'http' && local)) ||
        // İlgili verinin özelliğini kontrol eder
        uri.host.isEmpty ||
        // İlgili verinin özelliğini kontrol eder
        uri.userInfo.isNotEmpty ||
        // İlgili verinin özelliğini kontrol eder
        uri.hasQuery ||
        // İlgili verinin özelliğini kontrol eder
        uri.hasFragment) {
      // Geçersiz parametre hatası verir
      throw ArgumentError(
          // İlgili metin değerini belirler
          'API adresi HTTPS veya yerel geliştirme adresi olmalı.');
    }
    // Hesaplanan sonucu geri döndürür
    return uri.replace(
        // İstek yolunu belirler
        path: uri.path.endsWith('/') ? uri.path : '${uri.path}/');
  }
  // get işlemini asenkron yürütür
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) =>
      // İlgili fonksiyonu çalıştırır
      request('GET', path, query: query);
  // istek işlemini asenkron yürütür
  Future<Map<String, dynamic>> request(String method, String path,
      // Veri alanlarını tanımlar
      {Map<String, dynamic>? body,
      // Asenkron işlemi veya veri türünü tanımlar
      Map<String, String>? query,
      // Önceki ifadeyi tamamlar
      String? requestKey,
      // operational değerini belirler
      bool operational = false,
      // İlgili işlemin kod bloğunu başlatır
      String? credential}) async {
    // Koşul doğruysa bu işlemi çalıştırır
    if (path.startsWith('/') ||
        // İlgili verinin özelliğini kontrol eder
        path.contains('..') ||
        // Adres bilgisini oluşturur
        Uri.parse(path).hasScheme) {
      // Geçersiz parametre hatası verir
      throw ArgumentError('Geçersiz API yolu.');
    }
    // scoped path değerini belirler
    final scopedPath = _examples && !operational ? 'examples/$path' : path;
    // anahtar değerini belirler
    final key = credential ?? workspaceKey;
    // istek değerini belirler
    final request = http.Request(
        // Önceki ifadeyi tamamlar
        method, baseUri.resolve(scopedPath).replace(queryParameters: query))
      // Aynı nesne üzerinde ek işlem yapar
      ..followRedirects = false
      // Aynı nesne üzerinde ek işlem yapar
      ..headers['Accept'] = 'application/json';
    // Liste veya metin boş değilse koşulu çalıştırır
    if (key?.isNotEmpty ?? false) {
      // istek değerini günceller
      request.headers['Authorization'] = 'Bearer $key';
    }
    // Değer null değilse koşulu çalıştırır
    if (requestKey != null) request.headers['Idempotency-Key'] = requestKey;
    // Değer null değilse koşulu çalıştırır
    if (body != null) {
      // istek değerini günceller
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      // istek değerini günceller
      request.body = jsonEncode(body);
    }
    // Hata oluşabilecek işlemleri dener
    try {
      // yanıt değerini belirler
      final response =
          // Asenkron işlemin tamamlanmasını bekler
          await http.Response.fromStream(await _client.send(request))
              // süre constructorını tanımlar
              .timeout(const Duration(seconds: 10));
      // Koşul doğruysa bu işlemi çalıştırır
      if (response.bodyBytes.length > 2 * 1024 * 1024) {
        // Veri biçimi hatası oluşturur
        throw const FormatException();
      }
      // veri değerini belirler
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      // format exception constructorını tanımlar
      if (data is! Map<String, dynamic>) throw const FormatException();
      // Koşul doğruysa bu işlemi çalıştırır
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // hata değerini belirler
        final error = data['error'];
        // API hatası oluşturur
        throw ApiException(
            // Gelen değerin tipini kontrol eder
            error is Map && error['message'] is String
                // Koşul doğruysa bu değeri seçer
                ? error['message'] as String
                // Koşul yanlışsa bu değeri seçer
                : 'Sunucu isteği tamamlayamadı.',
            // Durum bilgisini belirler
            status: response.statusCode);
      }
      // veri bilgisini tutar
      return data;
    // Zaman aşımı oluşursa çalışır
    } on TimeoutException {
      // API hatası oluşturur
      throw const ApiException(
          // İlgili metin değerini belirler
          'Sunucu yanıt vermedi. Bağlantıyı kontrol edip yeniden deneyin.');
    // İşlem hata verirse çalışır
    } on http.ClientException {
      // API hatası oluşturur
      throw const ApiException(
          // İlgili metin değerini belirler
          'Sunucuya ulaşılamadı. Yerel sunucunun çalıştığını kontrol edin.');
    // Veri biçimi hatasında çalışır
    } on FormatException {
      // API hatası oluşturur
      throw const ApiException('Sunucu yanıtı beklenen biçimde değil.');
    }
  }
  // close işlemini gerçekleştirir
  void close() {
    // çalışma alanı anahtarı değerini günceller
    workspaceKey = null;
    // İlgili işlemi çalıştırır
    _client.close();
  }
}

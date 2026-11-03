// Formatters sabitlerini tutar, nesne oluşturulamaz
abstract final class Formatters {
  // months listesini oluşturur
  static const List<String> _months = <String>[
    // Bu metin değerini kullanır
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    // Bu metin değerini kullanır
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];
  // weekdays listesini oluşturur
  static const List<String> _weekdays = <String>[
    // Bu metin değerini kullanır
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
  ];
  // two değerini hesaplar veya döndürür
  static String _two(int v) => v.toString().padLeft(2, '0');
  // sıra numarası değerini hesaplar veya döndürür
  static String queueNumber(int number) =>
      // Bu metin değerini kullanır
      'S-${number.toString().padLeft(3, '0')}';
  // saat değerini hesaplar veya döndürür
  static String time(DateTime dt) => '${_two(dt.hour)}:${_two(dt.minute)}';
  // long tarih değerini hesaplar veya döndürür
  static String longDate(DateTime dt) =>
      // Bu metin değerini kullanır
      '${dt.day} ${_months[dt.month - 1]} ${dt.year}, '
      // Bu metin değerini kullanır
      '${_weekdays[dt.weekday - 1]}';
  // short tarih saat değerini hesaplar veya döndürür
  static String shortDateTime(DateTime dt) =>
      // Bu metin değerini kullanır
      '${dt.day} ${_months[dt.month - 1].substring(0, 3)} · ${time(dt)}';
  // short ad değerini hesaplar veya döndürür
  static String shortName(String fullName) {
    // parts değerini tanımlar
    final List<String> parts = fullName
        // Metnin başındaki ve sonundaki boşlukları kaldırır
        .trim()
        // RegExp nesnesini oluşturur veya kullanır
        .split(RegExp(r'\s+'))
        // Koşula uyan elemanları filtreler
        .where((String p) => p.isNotEmpty)
        // Sonucu listeye çevirir
        .toList();
    // Koşul sağlanırsa ilgili işlemi yapar
    if (parts.length < 2) return fullName.trim();
    // Hesaplanan sonucu döndürür
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }
  // süre değerini hesaplar veya döndürür
  static String duration(DateTime from, DateTime to) {
    // minutes değerini tanımlar
    final int minutes = to.difference(from).inMinutes;
    // Koşul sağlanırsa ilgili işlemi yapar
    if (minutes < 1) return '1 dk içinde';
    // Koşul sağlanırsa ilgili işlemi yapar
    if (minutes < 60) return '$minutes dk';
    // Hesaplanan sonucu döndürür
    return '${minutes ~/ 60} sa ${minutes % 60} dk';
  }
  // arama widget anahtarı değerini hesaplar veya döndürür
  static String searchKey(String text) =>
      // İlgili nesne üzerinden metodu çağırır
      text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase().trim();
}

/// Filo simülasyon rolleri (Görüntüleyici: salt-okunur, Operatör: işlem yapabilir, Yönetici: tam yetki)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum FleetDemoRole { viewer, operator, manager }
/// Filo araç durumu (Müsait veya Bakımda)
// Kullanılabilecek sabit seçenekleri enum ile tanımlar
enum FleetVehicleStatus { available, maintenance }
/// Örnek kurumsal filo organizasyonları
// örnek organizations değerini belirler
const demoOrganizations = {
  // İlgili metin değerini belirler
  'north': 'Örnek Kuzey Filo',
  // İlgili metin değerini belirler
  'south': 'Örnek Güney Filo'
};
/// Örnek şube tanımları (Organizasyon Kimliği, Şube Adı)
// örnek branches değerini belirler
const demoBranches = {
  // İlgili metin değerini belirler
  'north-center': ('north', 'Örnek Merkez'),
  // İlgili metin değerini belirler
  'north-west': ('north', 'Örnek Batı'),
  // İlgili metin değerini belirler
  'south-center': ('south', 'Örnek Güney Merkez'),
};
/// Filoya ait araç modeli
// filo araç için sınıf oluşturur
class FleetVehicle {
  // filo araç nesnesi oluşturur
  const FleetVehicle(this.id, this.organizationId, this.branchId, this.name,
      // Veri alanlarını tanımlar
      {this.status = FleetVehicleStatus.available});
  /// Araç kimliği
  // ID bilgisini tutar
  final String id;
  /// Ait olduğu organizasyon
  // organization ID bilgisini tutar
  final String organizationId;
  /// Ait olduğu şube
  // branch ID bilgisini tutar
  final String branchId;
  /// Araç adı
  // ad bilgisini tutar
  final String name;
  /// Bakım / uygunluk durumu
  // durum bilgisini tutar
  final FleetVehicleStatus status;
  /// Durumu güncellenmiş yeni araç örneği oluşturur
  // with durum işlemini gerçekleştirir
  FleetVehicle withStatus(FleetVehicleStatus value) =>
      // filo araç nesnesi oluşturur
      FleetVehicle(id, organizationId, branchId, name, status: value);
}
/// Çoklu kiracılı (multi-tenant) filo çalışma alanı yönetim sınıfı.
/// Organizasyon, şube ve rol simülasyonunu yönetir.
// örnek filo çalışma alanı için sınıf oluşturur
class DemoFleetWorkspace {
  // organization ID değerini belirler
  String _organizationId = 'north';
  // branch ID bilgisini tutar
  String? _branchId;
  // rol değerini belirler
  FleetDemoRole _role = FleetDemoRole.viewer;
  // araçlar değerini tanımlar
  final List<FleetVehicle> _vehicles = [
    // filo araç nesnesi oluşturur
    const FleetVehicle('fleet-1', 'north', 'north-center', 'Executive S'),
    // filo araç nesnesi oluşturur
    const FleetVehicle('fleet-2', 'north', 'north-west', 'Grand Tourer'),
    // filo araç nesnesi oluşturur
    const FleetVehicle('fleet-3', 'south', 'south-center', 'Urban E'),
  ];
  // organization ID bilgisini döndürür
  String get organizationId => _organizationId;
  // branch ID bilgisini döndürür
  String? get branchId => _branchId;
  // rol bilgisini döndürür
  FleetDemoRole get role => _role;
  // izin düzenleme bilgisini döndürür
  bool get canEdit => _role != FleetDemoRole.viewer;
  // görünürlük araçlar bilgisini döndürür
  List<FleetVehicle> get visibleVehicles => List.unmodifiable(_vehicles.where(
      // Bu eleman için oluşturulacak değeri belirler
      (v) =>
          // v değerini günceller
          v.organizationId == _organizationId &&
          // Koşul veya parametre ifadesini devam ettirir
          (_branchId == null || v.branchId == _branchId)));
  // select organization işlemini gerçekleştirir
  void selectOrganization(String id) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!demoOrganizations.containsKey(id)) {
      // Geçersiz parametre hatası verir
      throw ArgumentError('Bilinmeyen örnek filo.');
    }
    // organization ID değerini günceller
    _organizationId = id;
    // branch ID değerini günceller
    _branchId = null;
    // rol değerini günceller
    _role = FleetDemoRole.viewer;
  }
  // select branch işlemini gerçekleştirir
  void selectBranch(String? id) {
    // Değer null değilse koşulu çalıştırır
    if (id != null && demoBranches[id]?.$1 != _organizationId) {
      // Geçersiz parametre hatası verir
      throw ArgumentError('Şube bu örnek filoya ait değil.');
    }
    // branch ID değerini günceller
    _branchId = id;
  }
  // select örnek rol işlemini gerçekleştirir
  void selectDemoRole(FleetDemoRole role) => _role = role;
  // toggle maintenance işlemini gerçekleştirir
  void toggleMaintenance(String id) {
    // Koşul doğruysa bu işlemi çalıştırır
    if (!canEdit) throw StateError('Görüntüleyici demo verisini değiştiremez.');
    // indeks değerini belirler
    final index = _vehicles.indexWhere((v) =>
        // v değerini günceller
        v.id == id &&
        // v değerini günceller
        v.organizationId == _organizationId &&
        // Koşul veya parametre ifadesini devam ettirir
        (_branchId == null || v.branchId == _branchId));
    // Koşul doğruysa bu işlemi çalıştırır
    if (index < 0) throw StateError('Araç seçili filo/şube bağlamında değil.');
    // araç değerini belirler
    final vehicle = _vehicles[index];
    // araçlar değerini günceller
    _vehicles[index] = vehicle.withStatus(
        // araç değerini günceller
        vehicle.status == FleetVehicleStatus.available
            // Koşul doğruysa bu değeri seçer
            ? FleetVehicleStatus.maintenance
            // Koşul yanlışsa bu değeri seçer
            : FleetVehicleStatus.available);
  }
}

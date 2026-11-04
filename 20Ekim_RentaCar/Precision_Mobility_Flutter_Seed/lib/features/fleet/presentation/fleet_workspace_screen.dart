// Flutter arayüz kütüphanesini ekler
import 'package:flutter/material.dart';
// section heading dosyasını ekler
import '../../../shared/widgets/section_heading.dart';
// örnek filo çalışma alanı dosyasını ekler
import '../domain/demo_fleet_workspace.dart';
/// Filo araç durumunu kullanıcı dostu metne dönüştürür
// filo durum etiket işlemini gerçekleştirir
String fleetStatusLabel(FleetVehicleStatus status) =>
    // durum değerini günceller
    status == FleetVehicleStatus.available ? 'Örnek uygun' : 'Örnek bakımda';
/// Filo rolünü kullanıcı dostu metne dönüştürür
// filo rol etiket işlemini gerçekleştirir
String fleetRoleLabel(FleetDemoRole role) => switch (role) {
      // filo örnek rol değerini günceller
      FleetDemoRole.viewer => 'Demo görüntüleyici',
      // filo örnek rol değerini günceller
      FleetDemoRole.operator => 'Demo operatör',
      // filo örnek rol değerini günceller
      FleetDemoRole.manager => 'Demo yönetici',
    };
/// Filo yöneticisi ve operatörleri için çalışma alanı (Dashboard) ekranı.
/// Organizasyon seçimi, şube filtreleme ve bakım durumu geçişlerini simüle eder.
// filo çalışma alanı ekran ekranının değişen durumunu yönetir
class FleetWorkspaceScreen extends StatefulWidget {
  // filo çalışma alanı ekran nesnesi oluşturur
  const FleetWorkspaceScreen({super.key, this.workspace});
  /// Opsiyonel filo çalışma alanı modeli (testler için enjekte edilebilir)
  // çalışma alanı bilgisini tutar
  final DemoFleetWorkspace? workspace;
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın State nesnesini oluşturur
  State<FleetWorkspaceScreen> createState() => _FleetWorkspaceScreenState();
}
// filo çalışma alanı ekran durum ekranının durumunu yöneten sınıf
class _FleetWorkspaceScreenState extends State<FleetWorkspaceScreen> {
  // çalışma alanı değerini tanımlar
  late final _workspace = widget.workspace ?? DemoFleetWorkspace();
  // mesaj değerini belirler
  String _message = 'Demo görüntüleyici: yalnızca okuma.';
  // change işlemini gerçekleştirir
  void _change(VoidCallback action, String message) => setState(() {
        // İlgili fonksiyonu çalıştırır
        action();
        // mesaj değerini günceller
        _message = message;
      });
  // Üst sınıftaki metodu yeniden uygular
  @override
  // Widgetın arayüzünü oluşturur
  Widget build(BuildContext context) =>
      // Alan genişliğine göre içeriği düzenler
      LayoutBuilder(builder: (context, constraints) {
        // araçlar değerini belirler
        final vehicles = _workspace.visibleVehicles;
        // maintenance değerini belirler
        final maintenance = vehicles
            // Koşula uyan elemanları filtreler
            .where((v) => v.status == FleetVehicleStatus.maintenance)
            // Önceki ifade üzerinde ek işlem uygular
            .length;
        // Kaydırılabilir liste oluşturur
        return ListView(padding: const EdgeInsets.all(20), children: [
          // section heading nesnesi oluşturur
          const SectionHeading(
              // Başlığı belirler
              title: 'Filo çalışma alanı',
              // Alt başlığı belirler
              subtitle:
                  // İlgili metin değerini belirler
                  'DEMO • Gerçek kuruluş, çalışan veya araç yönetimi yok.'),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // İfadeye karşılaştırma koşulu ekler
          DropdownButtonFormField<String>(
            // durum genişletme bilgisini belirler
            isExpanded: true,
            // Widget kimliğini belirler
            key: const ValueKey('fleet-organization'),
            // Başlangıç değerini belirler
            initialValue: _workspace.organizationId,
            // Kutunun görünümünü ayarlar
            decoration: const InputDecoration(labelText: 'Örnek kuruluş'),
            // Seçenekleri listeler
            items: demoOrganizations.entries
                // Listedeki elemanları dönüştürür
                .map(
                    // Bu eleman için oluşturulacak değeri belirler
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                // Sonucu listeye dönüştürür
                .toList(),
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (id) => _change(() => _workspace.selectOrganization(id!),
                // İlgili metin değerini belirler
                'Kuruluş değişti; rol görüntüleyiciye ve şube tümüne sıfırlandı.'),
          ),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // İfadeye karşılaştırma koşulu ekler
          DropdownButtonFormField<String>(
            // durum genişletme bilgisini belirler
            isExpanded: true,
            // Widget kimliğini belirler
            key: ValueKey('fleet-branch-${_workspace.organizationId}'),
            // Başlangıç değerini belirler
            initialValue: _workspace.branchId ?? 'all',
            // Kutunun görünümünü ayarlar
            decoration: const InputDecoration(labelText: 'Örnek şube'),
            // Seçenekleri listeler
            items: [
              // Seçim listesine seçenek ekler
              const DropdownMenuItem(
                  // Kullanılacak değeri belirler
                  value: 'all', child: Text('Tüm örnek şubeler')),
              // Listedeki öğeleri veya indeksleri sırayla dolaşır
              for (final branch in demoBranches.entries)
                // Koşul doğruysa bu işlemi çalıştırır
                if (branch.value.$1 == _workspace.organizationId)
                  // Seçim listesine seçenek ekler
                  DropdownMenuItem(
                      // Kullanılacak değeri belirler
                      value: branch.key, child: Text(branch.value.$2)),
            ],
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (id) => _change(
                // Bu eleman için oluşturulacak değeri belirler
                () => _workspace.selectBranch(id == 'all' ? null : id),
                // İlgili metin değerini belirler
                'Örnek şube görünümü güncellendi.'),
          ),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // İfadeye karşılaştırma koşulu ekler
          DropdownButtonFormField<FleetDemoRole>(
            // durum genişletme bilgisini belirler
            isExpanded: true,
            // Widget kimliğini belirler
            key: ValueKey('fleet-role-${_workspace.organizationId}'),
            // Başlangıç değerini belirler
            initialValue: _workspace.role,
            // Kutunun görünümünü ayarlar
            decoration: const InputDecoration(labelText: 'Rol simülasyonu'),
            // Seçenekleri listeler
            items: FleetDemoRole.values
                // Listedeki elemanları dönüştürür
                .map((role) => DropdownMenuItem(
                    // Kullanılacak değeri belirler
                    value: role, child: Text(fleetRoleLabel(role))))
                // Sonucu listeye dönüştürür
                .toList(),
            // Değer değişince çalışacak fonksiyonu belirler
            onChanged: (role) => _change(() => _workspace.selectDemoRole(role!),
                // İlgili metin değerini belirler
                'Rol simülasyonu değişti; gerçek yetki verilmez.'),
          ),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // Metni gösterir
          Text('${vehicles.length} örnek araç • $maintenance örnek bakımda'),
          // semantics nesnesi oluşturur
          Semantics(liveRegion: true, child: Text(_message)),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 12),
          // Koşul doğruysa bu işlemi çalıştırır
          if (constraints.maxWidth >= 700)
            // Sayfanın kaydırılmasını sağlar
            SingleChildScrollView(
                // scroll direction bilgisini belirler
                scrollDirection: Axis.horizontal,
                // İçerikte gösterilecek widgetı belirler
                child: DataTable(
                  // columns bilgisini belirler
                  columns: const [
                    // veri column nesnesi oluşturur
                    DataColumn(label: Text('Örnek araç')),
                    // veri column nesnesi oluşturur
                    DataColumn(label: Text('Şube')),
                    // veri column nesnesi oluşturur
                    DataColumn(label: Text('Durum')),
                    // veri column nesnesi oluşturur
                    DataColumn(label: Text('Demo işlem'))
                  ],
                  // rows bilgisini belirler
                  rows: [
                    // Listedeki öğeleri veya indeksleri sırayla dolaşır
                    for (final vehicle in vehicles)
                      // veri row nesnesi oluşturur
                      DataRow(cells: [
                        // veri cell nesnesi oluşturur
                        DataCell(Text(vehicle.name)),
                        // veri cell nesnesi oluşturur
                        DataCell(Text(demoBranches[vehicle.branchId]!.$2)),
                        // veri cell nesnesi oluşturur
                        DataCell(Text(fleetStatusLabel(vehicle.status))),
                        // veri cell nesnesi oluşturur
                        DataCell(_action(vehicle)),
                      ])
                  ],
                ))
          // Önceki ifadeyi tamamlar
          else
            // Listedeki öğeleri veya indeksleri sırayla dolaşır
            for (final vehicle in vehicles)
              // Kart görünümü oluşturur
              Card(
                  // İçerikte gösterilecek widgetı belirler
                  child: Padding(
                // İç boşlukları ayarlar
                padding: const EdgeInsets.all(16),
                // İçerikte gösterilecek widgetı belirler
                child: Column(
                    // Çapraz eksendeki hizalamayı belirler
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // İçerideki elemanları listeler
                    children: [
                      // Metni gösterir
                      Text(vehicle.name),
                      // Metni gösterir
                      Text(demoBranches[vehicle.branchId]!.$2),
                      // Metni gösterir
                      Text(fleetStatusLabel(vehicle.status)),
                      // İlgili metodu çalıştırır
                      _action(vehicle),
                    ]),
              )),
          // Belirtilen boyutta boşluk veya kutu oluşturur
          const SizedBox(height: 16),
          // Metni gösterir
          const Text(
              // İlgili metin değerini belirler
              'Veriler oturum belleğindedir. Kuruluş/rol seçimleri yalnızca '
              // İlgili metin değerini belirler
              'arayüz demosudur; sunucu yetkilendirmesi yerine geçmez.'),
        ]);
      });
  // action işlemini gerçekleştirir
  Widget _action(FleetVehicle vehicle) => OutlinedButton(
        // Widget kimliğini belirler
        key: ValueKey('fleet-action-${vehicle.id}'),
        // Butona basılınca çalışacak fonksiyonu belirler
        onPressed: !_workspace.canEdit
            // Koşul doğruysa bu değeri seçer
            ? null
            // Koşul yanlışsa bu değeri seçer
            : () => _change(() => _workspace.toggleMaintenance(vehicle.id),
                // İlgili metin değerini belirler
                '${vehicle.name} için örnek bakım durumu değiştirildi.'),
        // İçerikte gösterilecek widgetı belirler
        child: const Text('Örnek bakım durumunu değiştir'),
      );
}

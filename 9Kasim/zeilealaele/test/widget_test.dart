import 'package:flutter_test/flutter_test.dart';
import 'package:zeilealaele/main.dart';

void main() {
  testWidgets('MiniCuzdanApp yükleme testi', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniCuzdanApp());
    await tester.pumpAndSettle();
    expect(find.text('Kodvance BLoC Cüzdan'), findsOneWidget);
    expect(find.text('Toplam Net Bakiye'), findsOneWidget);
  });
}

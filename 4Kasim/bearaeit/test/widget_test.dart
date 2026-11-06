import 'package:flutter_test/flutter_test.dart';

import 'package:bearaeit/main.dart';

void main() {
  testWidgets('Softito FCM smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SoftitoFcmDemoApplication());
  });
}

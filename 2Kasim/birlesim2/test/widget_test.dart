// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:birlesim2/main.dart';

class SahteUrunServisi implements IUrunServisi {
  @override
  Future<List<UrunModel>> urunleriGetir() async {
    return [
      UrunModel(
        id: 1,
        baslik: 'Test Ürünü',
        fiyat: 9.99,
        resimURL: 'https://example.com/a.png',
        kategori: 'Test',
      ),
    ];
  }
}

void main() {
  testWidgets('Ürün listesi gösterilir', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Listecibasi(servis: SahteUrunServisi())),
    );

    // İlk karede yükleniyor göstergesi olmalı.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Test Ürünü'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ci_cd_mobile/View/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ci_cd_mobile/main.dart';

void main() {
  testWidgets('Default test widget'
      '', (WidgetTester tester) async {
  });

  testWidgets('HomePage contains AppBar title and FloatingActionButton', (WidgetTester tester) async {
    // Construire la page
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Vérifier la présence du titre dans l'AppBar
    expect(find.text('CI/CD Mobile'), findsOneWidget);

    // Vérifier la présence du FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Vérifier l'icône du bouton flottant
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}

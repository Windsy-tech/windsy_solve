import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:windsy_solve/core/common/widgets/labelled_text.dart';

void main() {
  //Widget tests for all widgets in the app
  group('Widget Tests', () {
    testWidgets('LabelledText', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LabelledText(
              label: 'label',
              text: 'text',
            ),
          ),
        ),
      );

      // Verify that our counter starts at 0.
      expect(find.text('label'), findsOneWidget);
      expect(find.text('text'), findsOneWidget);
    });
  });
}

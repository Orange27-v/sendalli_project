import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/onboarding/screens/welcome_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/name_input_screen.dart';

void main() {
  testWidgets('WelcomeScreen renders brand titles and action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const WelcomeScreen(),
      ),
    );

    // Verify brand name and options
    expect(find.text('SENDALLI'), findsOneWidget);
    expect(find.text('Corridor Parcel Logistics'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('I already have an account • Log In'), findsOneWidget);
    expect(find.text('Have a Tracking ID? Track here'), findsOneWidget);
  });

  testWidgets('NameInputScreen validates name before enabling button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const NameInputScreen(),
      ),
    );

    expect(find.text('Enter your name'), findsOneWidget);

    final continueBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(continueBtn.onPressed, isNull);

    // Fill valid names
    await tester.enterText(find.byType(TextField).first, 'Diran');
    await tester.enterText(find.byType(TextField).last, 'Olakunle');
    await tester.pump();

    final activeBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(activeBtn.onPressed, isNotNull);
  });
}

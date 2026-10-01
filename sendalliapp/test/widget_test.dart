import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/onboarding/screens/welcome_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/name_input_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/role_selection_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/phone_input_screen.dart';

import 'package:sendalliapp/features/onboarding/screens/role_gateway_screen.dart';

void main() {
  testWidgets('WelcomeScreen renders outside receiver portal and operator actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const WelcomeScreen(),
      ),
    );

    // Verify brand name and options
    expect(find.text('SENDALLI'), findsOneWidget);
    expect(find.text('Corridor Parcel Logistics • Warri & Effurun'), findsOneWidget);
    expect(find.text('Receiving a Parcel?'), findsOneWidget);
    expect(find.text('Track by ID'), findsOneWidget);
    expect(find.text('Receiver Portal'), findsOneWidget);
    expect(find.text('OPERATORS: SENDERS • RIDERS • HUBS'), findsOneWidget);
    expect(find.text('Choose Role to Enter'), findsOneWidget);
    expect(find.text('Operator Sign In • Phone & PIN'), findsOneWidget);
  });

  testWidgets('RoleGatewayScreen renders the 3 operator roles and fast onboarding actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const RoleGatewayScreen(),
      ),
    );

    expect(find.text('How will you use Sendalli?'), findsOneWidget);
    expect(find.text('Merchant / Sender'), findsOneWidget);
    expect(find.text('Keke / Dispatch Rider'), findsOneWidget);
    expect(find.text('Drop Hub Partner'), findsOneWidget);
    expect(find.text('Quick Onboard as Sender / Merchant'), findsOneWidget);
    expect(find.text('Sign In as Sender / Merchant • Phone & PIN'), findsOneWidget);
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

  testWidgets('RoleSelectionScreen displays the 3 operator roles and excludes Receiver', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: RoleSelectionScreen(
            phoneNumber: '+2348031234567',
            firstName: 'Tega',
            lastName: 'Okoro',
            pin: '1234',
          ),
        ),
      ),
    );

    // Verify 3 operator roles are rendered
    expect(find.text('Send Parcels'), findsOneWidget);
    expect(find.text('Deliver Along Route (Rider)'), findsOneWidget);
    expect(find.text('Roadside Drop Hub Partner'), findsOneWidget);

    // Verify Receiver is excluded from logged-in onboarding
    expect(find.text('Receive & Track Parcels'), findsNothing);

    // Tap Rider card
    await tester.ensureVisible(find.text('Deliver Along Route (Rider)'));
    await tester.tap(find.text('Deliver Along Route (Rider)'));
    await tester.pump();

    // Verify Continue button is enabled
    final continueBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(continueBtn.onPressed, isNotNull);
  });

  testWidgets('RandomizeButton populates NameInputScreen fields and enables Continue', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const NameInputScreen(),
      ),
    );

    // Initial state: continue button disabled
    final continueBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(continueBtn.onPressed, isNull);

    // Tap Randomize action
    expect(find.text('Randomize'), findsOneWidget);
    await tester.tap(find.text('Randomize'));
    await tester.pump();

    // Verify fields populated and continue button enabled
    final activeBtn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(activeBtn.onPressed, isNotNull);
  });

  testWidgets('PhoneInputScreen renders square input boxes, validation badge, and quick-fill', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const PhoneInputScreen(firstName: 'Osas'),
      ),
    );

    // Verify header and square country code prefix
    expect(find.text('Hi, Osas 👋'), findsOneWidget);
    expect(find.text('+234'), findsOneWidget);
    expect(find.text('MOBILE PHONE NUMBER'), findsOneWidget);
    expect(find.text('10 digits required'), findsOneWidget);

    // Initial state: button is disabled
    final initialBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send Verification Code'));
    expect(initialBtn.onPressed, isNull);

    // Tap quick-fill chip for MTN
    expect(find.text('803 (MTN)'), findsOneWidget);
    await tester.tap(find.text('803 (MTN)'));
    await tester.pump();

    // Verify 10 digits valid status and button enabled
    expect(find.text('✓ 10 digits valid'), findsOneWidget);
    final activeBtn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Send Verification Code'));
    expect(activeBtn.onPressed, isNotNull);
  });
}

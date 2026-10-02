import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/onboarding/screens/welcome_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/name_input_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/role_selection_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/phone_input_screen.dart';

import 'package:sendalliapp/features/onboarding/screens/role_gateway_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/track_parcel_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/onboarding_walkthrough_screen.dart';

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
    expect(find.text('Local Parcel Delivery • Warri & Effurun'), findsOneWidget);
    expect(find.text('Receiving a Parcel?'), findsOneWidget);
    expect(find.text('Track by ID'), findsOneWidget);
    expect(find.text('My Parcels'), findsOneWidget);
    expect(find.text('FOR: SENDERS • RIDERS • HUBS'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Already have an account? Sign In'), findsOneWidget);
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
    expect(find.text('Sign Up as Sender / Merchant'), findsOneWidget);
    expect(find.text('Sign In as Sender / Merchant'), findsOneWidget);
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

  testWidgets('TrackParcelScreen renders dedicated receiver tracking context', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const TrackParcelScreen(),
      ),
    );

    expect(find.text('Track Your Parcel'), findsOneWidget);
    expect(find.text('NO LOGIN'), findsOneWidget);
    expect(find.text('TRACKING NUMBER'), findsOneWidget);
    expect(find.text('Track Live Delivery'), findsOneWidget);
    expect(find.text('Go to My Parcels'), findsOneWidget);

    // Tap sample chip
    expect(find.widgetWithText(InkWell, 'SND-WAR-8492'), findsOneWidget);
    await tester.tap(find.widgetWithText(InkWell, 'SND-WAR-8492'));
    await tester.pump();
  });

  testWidgets('OnboardingWalkthroughScreen renders separate context slides with navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const OnboardingWalkthroughScreen(),
      ),
    );
    await tester.pump();

    // Slide 1: Send Parcels context
    expect(find.text('LOCAL DELIVERY'), findsOneWidget);
    expect(find.text('Send Parcels Across Warri & Effurun'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // Tap Next to advance to Slide 2: Keke Transit context
    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(find.text('RIDERS EARN MORE'), findsOneWidget);
    expect(find.text('Keke Drivers Earn Extra on Their Route'), findsOneWidget);
  });

  testWidgets('AppNavigator.safePop navigates to WelcomeScreen when route cannot pop', (WidgetTester tester) async {
    // When a screen is pushed as sole root (canPop is false), back navigation must not exit into blank screen
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const TrackParcelScreen(),
      ),
    );

    expect(find.text('Track Your Parcel'), findsOneWidget);

    // Tap back leading button
    final backBtn = find.byType(IconButton).first;
    expect(backBtn, findsOneWidget);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // Instead of popping to blank canvas, it safely returns to WelcomeScreen
    expect(find.text('SENDALLI'), findsOneWidget);
    expect(find.text('Receiving a Parcel?'), findsOneWidget);
  });
}


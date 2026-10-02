import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/widgets/map/sendalli_map_view.dart';
import 'package:sendalliapp/widgets/map/full_screen_map_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/terms_and_conditions_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/role_gateway_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SendalliMapView Zoom & Full Screen Controls', () {
    testWidgets('renders Zoom In, Zoom Out, and Full Screen buttons on map', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SendalliMapView(
              height: 250,
              corridorName: 'Warri — Effurun Corridor',
            ),
          ),
        ),
      );

      // Verify zoom controls and fullscreen button exist
      expect(find.byKey(const Key('map_zoom_in_button')), findsOneWidget);
      expect(find.byKey(const Key('map_zoom_out_button')), findsOneWidget);
      expect(find.byKey(const Key('map_fullscreen_button')), findsOneWidget);
      expect(find.text('Warri — Effurun Corridor'), findsOneWidget);
    });

    testWidgets('Zoom In and Zoom Out buttons can be tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SendalliMapView(height: 250),
          ),
        ),
      );

      // Tap zoom in twice
      await tester.tap(find.byKey(const Key('map_zoom_in_button')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('map_zoom_in_button')));
      await tester.pump();

      // Tap zoom out
      await tester.tap(find.byKey(const Key('map_zoom_out_button')));
      await tester.pump();

      expect(find.byKey(const Key('map_zoom_in_button')), findsOneWidget);
      expect(find.byKey(const Key('map_zoom_out_button')), findsOneWidget);
    });

    testWidgets('Full Screen button opens FullScreenMapScreen with Minimise button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SendalliMapView(
              height: 250,
              corridorName: 'Warri — Effurun Corridor',
            ),
          ),
        ),
      );

      // Tap full screen button
      await tester.tap(find.byKey(const Key('map_fullscreen_button')));
      await tester.pumpAndSettle();

      // Now FullScreenMapScreen is open
      expect(find.byType(FullScreenMapScreen), findsOneWidget);
      expect(find.byKey(const Key('map_minimize_button')), findsOneWidget);
      expect(find.byKey(const Key('map_minimize_header_button')), findsOneWidget);
      expect(find.text('Minimise'), findsOneWidget);

      // Tap minimise button to exit full screen
      await tester.tap(find.byKey(const Key('map_minimize_header_button')));
      await tester.pumpAndSettle();

      // FullScreenMapScreen is popped and back to normal view
      expect(find.byType(FullScreenMapScreen), findsNothing);
      expect(find.byKey(const Key('map_fullscreen_button')), findsOneWidget);
    });
  });

  group('TermsAndConditionsScreen Onboarding Flow', () {
    testWidgets('Terms & Conditions button is disabled until checkbox is checked', (tester) async {
      bool accepted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: TermsAndConditionsScreen(
            targetRole: UserRole.sender,
            onAccepted: () {
              accepted = true;
            },
          ),
        ),
      );

      // Verify screen title and clauses
      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.text('Sendalli Terms of Service'), findsOneWidget);
      expect(find.text('1. Corridor Operations & Roadside Handover'), findsOneWidget);
      expect(find.text('2. 60-Second Waiting Rule & Hub Diversion'), findsOneWidget);
      expect(find.text('3. Escrow Security & 30-Minute Inspection Window'), findsOneWidget);
      expect(find.text('4. Mandatory QR Code & 4-Digit PIN Handover'), findsOneWidget);
      expect(find.text('5. Prohibited Items & Roadside Safety'), findsOneWidget);

      // Button is initially disabled
      final continueButtonFinder = find.byKey(const Key('terms_continue_button'));
      expect(continueButtonFinder, findsOneWidget);
      ElevatedButton button = tester.widget<ElevatedButton>(continueButtonFinder);
      expect(button.onPressed, isNull);

      // Try tapping disabled button
      await tester.tap(continueButtonFinder);
      await tester.pump();
      expect(accepted, isFalse);

      // Check the acceptance checkbox
      final checkboxFinder = find.byKey(const Key('terms_accept_checkbox'));
      expect(checkboxFinder, findsOneWidget);
      await tester.tap(checkboxFinder);
      await tester.pump();

      // Button is now enabled
      button = tester.widget<ElevatedButton>(continueButtonFinder);
      expect(button.onPressed, isNotNull);

      // Tap button and verify onAccepted is called
      await tester.tap(continueButtonFinder);
      await tester.pump();
      expect(accepted, isTrue);
    });

    testWidgets('RoleGatewayScreen registration leads to TermsAndConditionsScreen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RoleGatewayScreen(initialRole: UserRole.rider),
        ),
      );

      // Tap the register button
      final registerButton = find.text('Sign Up as Keke Rider');
      expect(registerButton, findsOneWidget);
      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Verify that TermsAndConditionsScreen is shown
      expect(find.byType(TermsAndConditionsScreen), findsOneWidget);
      expect(find.text('Terms & Conditions'), findsOneWidget);
      expect(find.byKey(const Key('terms_accept_checkbox')), findsOneWidget);
    });
  });
}

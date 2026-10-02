import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/hub/hub_home_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/receiver/receiver_home_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/receiver/receiver_tracking_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/track_parcel_screen.dart';
import 'package:sendalliapp/widgets/map/sendalli_map_view.dart';
import 'package:sendalliapp/widgets/checkout/order_step_progress.dart';

void main() {
  testWidgets('ReceiverHomeScreen renders map, active parcel, and roadside stop info', (WidgetTester tester) async {
    final user = UserProfile.guestReceiver();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ReceiverHomeScreen(user: user),
      ),
    );
    await tester.pumpAndSettle();

    // Verify map is rendered
    expect(find.byType(SendalliMapView), findsOneWidget);
    // Verify receiver title and roadside pickup
    expect(find.text('Package Tracker'), findsOneWidget);
    expect(find.text('Track A Parcel'), findsOneWidget);
    expect(find.textContaining('Pickup Stop:'), findsOneWidget);
    // Verify active parcel details
    expect(find.text('Refinery Road — Jakpa'), findsNWidgets(2));
    expect(find.text('HANDOVER RELEASE CODE'), findsOneWidget);
    expect(find.text('Diran Olakunle (Keke)'), findsOneWidget);
  });

  testWidgets('ReceiverTrackingScreen renders stepper, 6-digit PIN, and corridor map', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReceiverTrackingScreen(
          trackingId: 'SND-WAR-8492',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify OrderStepProgress and SendalliMapView
    expect(find.byType(OrderStepProgress), findsOneWidget);
    expect(find.byType(SendalliMapView), findsOneWidget);

    // Verify tracking ID & release PIN
    expect(find.textContaining('SND-WAR-8492'), findsOneWidget);
    expect(find.textContaining('849 201'), findsOneWidget);
    expect(find.text('Diran Olakunle'), findsOneWidget);
  });

  testWidgets('HubHomeScreen renders holding fee summary and logistics map', (WidgetTester tester) async {
    final hubUser = UserProfile(
      id: 'hub_01',
      firstName: 'Chinedu',
      lastName: 'Okafor',
      phone: '+2348012345678',
      role: UserRole.hub,
      pin: '1234',
      shopName: 'Chinedu Supermarket & Chemist',
      landmark: '14 Effurun Roundabout, Delta',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: HubHomeScreen(user: hubUser),
      ),
    );
    await tester.pumpAndSettle();

    // Verify hub name and custody credit
    expect(find.text('Chinedu Supermarket & Chemist'), findsOneWidget);
    expect(find.text('₦500 custody credit per package'), findsOneWidget);
    // Verify corridor logistics map
    expect(find.byType(SendalliMapView), findsOneWidget);
    expect(find.text('Corridor Hub Logistics'), findsOneWidget);
    expect(find.text('Packages In Holding (0)'), findsOneWidget);
  });

  testWidgets('TrackParcelScreen renders corridor map preview and sample quick fills', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const TrackParcelScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify live map preview
    expect(find.byType(SendalliMapView), findsOneWidget);
    expect(find.text('Track Your Parcel'), findsOneWidget);
    expect(find.text('NO LOGIN'), findsOneWidget);

    // Tap sample chip
    await tester.tap(find.text('SND-EFF-4019'));
    await tester.pump();

    // Verify text field controller was populated with the sample ID
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, 'SND-EFF-4019');
  });
}

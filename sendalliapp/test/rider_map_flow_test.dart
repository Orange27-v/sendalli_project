import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_home_screen.dart';
import 'package:sendalliapp/widgets/map/sendalli_map_view.dart';

void main() {
  final testRider = const UserProfile(
    id: 'RDR-001',
    firstName: 'John',
    lastName: 'Deo',
    phone: '+2348030001234',
    role: UserRole.rider,
    pin: '1234',
    corridor: 'Refinery Road — Jakpa',
    vehiclePlate: 'WRA-492-XA',
    trustScore: 92,
  );

  testWidgets('RiderHomeScreen renders top overlay, SendalliMapView and offline card initially', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: testRider),
      ),
    );

    expect(find.text('Hello John'), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.byType(SendalliMapView), findsOneWidget);
    expect(find.text('Corridor Broadcast Paused'), findsOneWidget);
    expect(find.text('Corridor: Refinery Road — Jakpa'), findsOneWidget);
    expect(find.text('Trust: 92%'), findsOneWidget);
  });

  testWidgets('RiderHomeScreen toggles Online and shows incoming delivery card with accept flow', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: testRider),
      ),
    );

    // Toggle switch to go Online
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Package Delivery'), findsOneWidget);
    expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
    expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
    expect(find.text('Accept Delivery'), findsOneWidget);

    // Accept Delivery
    await tester.tap(find.text('Accept Delivery'));
    await tester.pumpAndSettle();

    // Verify Active Delivery screen rendered
    expect(find.text('#BE12345'), findsWidgets);
    expect(find.text('Confirm Delivery Code from customer: 1234'), findsOneWidget);
    expect(find.text('Delivery Status'), findsOneWidget);
    expect(find.text('Complete Order'), findsOneWidget);

    // Scroll to and Complete Order
    await tester.ensureVisible(find.text('Complete Order'));
    await tester.tap(find.text('Complete Order'));
    await tester.pumpAndSettle();

    // Returns to map home
    expect(find.text('Hello John'), findsOneWidget);
  });

  testWidgets('SendalliMapView renders successfully in test environment', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SendalliMapView(
            corridorName: 'Test Corridor',
            height: 200,
          ),
        ),
      ),
    );

    expect(find.text('Test Corridor'), findsOneWidget);
    expect(find.byType(SendalliMapView), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_home_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/hub/hub_home_screen.dart';

void main() {
  final sampleRider = const UserProfile(
    id: 'RDR-TEST-01',
    firstName: 'Diran',
    lastName: 'Olakunle',
    phone: '+2348031112233',
    role: UserRole.rider,
    pin: '1234',
    corridor: 'Warri — Effurun Corridor',
    vehiclePlate: 'WRA-102-XA',
    trustScore: 95,
  );

  final sampleHub = UserProfile(
    id: 'hub_01',
    firstName: 'Chinedu',
    lastName: 'Okafor',
    phone: '+2348012345678',
    role: UserRole.hub,
    pin: '1234',
    shopName: 'Chinedu Supermarket & Chemist',
    landmark: '14 Effurun Roundabout, Delta',
  );

  group('Keke Rider Dashboard Data Tests', () {
    testWidgets('renders enriched pending and delivered requests data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: RiderHomeScreen(user: sampleRider),
        ),
      );

      // Switch to Deliveries tab
      await tester.tap(find.text('Deliveries'));
      await tester.pumpAndSettle();

      // Verify pending deliveries data
      expect(find.byKey(const Key('deliveries_filter_pending')), findsOneWidget);
      expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
      expect(find.text('Enerhen Pharmacy Hub (Pickup Location)'), findsOneWidget);
      expect(find.text('Deco Electronics Hub (Pickup Location)'), findsOneWidget);
      expect(find.text('Main Market Textile Depot (Pickup Location)'), findsOneWidget);
      expect(find.text('Warri City Bakeries (Pickup Location)'), findsOneWidget);

      // Switch to Delivered tab
      await tester.tap(find.byKey(const Key('deliveries_filter_completed')));
      await tester.pumpAndSettle();

      // Verify delivered trips data
      expect(find.text('9ja Kitchen • Ring Road'), findsOneWidget);
      expect(find.text('Warri Central Chemist'), findsOneWidget);
      expect(find.text('Deco Road Provisions'), findsOneWidget);
      expect(find.text('Enerhen Auto Spares'), findsOneWidget);
      expect(find.text('Refinery Junction Bakery'), findsOneWidget);
      expect(find.text('Delivered'), findsWidgets);
    });
  });

  group('Hub Dashboard Data Tests', () {
    testWidgets('renders pending drop-offs, held packages, and delivered parcels', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: HubHomeScreen(user: sampleHub),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state: Pending filter is active
      expect(find.byKey(const Key('hub_filter_pending')), findsOneWidget);
      expect(find.byKey(const Key('hub_filter_held')), findsOneWidget);
      expect(find.byKey(const Key('hub_filter_delivered')), findsOneWidget);

      // Verify pending drop-offs data
      expect(find.text('SND-WAR-9021'), findsOneWidget);
      expect(find.text('SND-EFF-4180'), findsOneWidget);
      expect(find.text('SND-WAR-7734'), findsOneWidget);
      expect(find.text('Electronics • Bluetooth Speaker & Charger'), findsOneWidget);
      expect(find.text('Documents • CAC Certificate & Deeds'), findsOneWidget);
      expect(find.text('Fashion • Aso-ebi Lace Fabric'), findsOneWidget);

      // Switch to In Custody tab
      await tester.ensureVisible(find.byKey(const Key('hub_filter_held')));
      await tester.tap(find.byKey(const Key('hub_filter_held')));
      await tester.pumpAndSettle();

      // Verify held packages in custody
      expect(find.text('SND-WAR-8492'), findsOneWidget);
      expect(find.text('SND-EFF-3312'), findsOneWidget);
      expect(find.text('Pharmacy • Prescription box'), findsOneWidget);
      expect(find.text('Automotive • Replacement Gaskets'), findsOneWidget);
      expect(find.text('Release (PIN)'), findsWidgets);

      // Switch to Delivered tab
      await tester.ensureVisible(find.byKey(const Key('hub_filter_delivered')));
      await tester.tap(find.byKey(const Key('hub_filter_delivered')));
      await tester.pumpAndSettle();

      // Verify delivered/released parcels
      expect(find.text('SND-WAR-8201'), findsOneWidget);
      expect(find.text('SND-EFF-2940'), findsOneWidget);
      expect(find.text('SND-WAR-7115'), findsOneWidget);
      expect(find.text('SND-WAR-6890'), findsOneWidget);
      expect(find.text('Food • Jollof Rice Pack'), findsOneWidget);
      expect(find.text('Cosmetics • Skincare Package'), findsOneWidget);
      expect(find.text('+₦500.00 Credited'), findsWidgets);
      expect(find.text('Delivered & Released'), findsWidgets);
    });
  });
}

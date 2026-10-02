import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_home_screen.dart';
import 'package:sendalliapp/widgets/delivery/propose_fare_sheet.dart';

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

  testWidgets('Deliveries tab renders Pending, Accepted, and Completed filter tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: sampleRider),
      ),
    );

    // Switch to Deliveries tab (index 1)
    await tester.tap(find.text('Deliveries'));
    await tester.pumpAndSettle();

    // Verify filter pills exist
    expect(find.byKey(const Key('deliveries_filter_pending')), findsOneWidget);
    expect(find.byKey(const Key('deliveries_filter_accepted')), findsOneWidget);
    expect(find.byKey(const Key('deliveries_filter_completed')), findsOneWidget);

    // Initially Pending tab is selected
    expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
    expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
    expect(find.text('Sender Offer'), findsWidgets);
    expect(find.text('₦ 260.00'), findsOneWidget);

    // Switch to Accepted tab
    await tester.tap(find.byKey(const Key('deliveries_filter_accepted')));
    await tester.pumpAndSettle();

    expect(find.text('Market Stall 14 (Pickup Location)'), findsOneWidget);
    expect(find.text('Effurun Roundabout (Drop-off Location)'), findsOneWidget);
    expect(find.text('Accepted • On Route'), findsOneWidget);
    expect(find.text('Resume Delivery'), findsOneWidget);

    // Switch to Completed tab
    await tester.tap(find.byKey(const Key('deliveries_filter_completed')));
    await tester.pumpAndSettle();

    expect(find.text('Warri Central Chemist'), findsOneWidget);
    expect(find.text('PTI Gate Roadside'), findsOneWidget);
    expect(find.text('Delivered'), findsWidgets);
  });

  testWidgets('Rider can object to delivery fare and propose custom amount', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: sampleRider),
      ),
    );

    // Switch to Deliveries tab
    await tester.tap(find.text('Deliveries'));
    await tester.pumpAndSettle();

    // Tap Object / Propose on the first pending item (#BE12345)
    final objectButton = find.byKey(const Key('object_button_#BE12345'));
    expect(objectButton, findsOneWidget);
    await tester.tap(objectButton);
    await tester.pumpAndSettle();

    // Verify ProposeFareSheet opened
    expect(find.byType(ProposeFareSheet), findsOneWidget);
    expect(find.text('Object & Propose Fare'), findsOneWidget);
    expect(find.text('Sender Offered Price:'), findsOneWidget);

    // Tap quick increment chip +₦200
    await tester.tap(find.text('+₦200'));
    await tester.pump();

    // Select reason: Heavy Cargo / Weight
    await tester.tap(find.text('Heavy Cargo / Weight'));
    await tester.pump();

    // Submit proposed amount
    await tester.tap(find.byKey(const Key('send_proposed_amount_button')));
    await tester.pumpAndSettle();

    // Verify bottom sheet closed and counter-offer status badge rendered
    expect(find.byType(ProposeFareSheet), findsNothing);
    expect(find.textContaining('Counter-Offer:'), findsOneWidget);
    expect(find.textContaining('Waiting for Sender'), findsOneWidget);

    // Now accept the request
    final acceptButton = find.byKey(const Key('accept_button_#BE12345'));
    expect(acceptButton, findsOneWidget);
    await tester.tap(acceptButton);
    await tester.pumpAndSettle();

    // Navigated to active delivery screen
    expect(find.text('#BE12345'), findsWidgets);
    expect(find.text('Delivery Status'), findsOneWidget);
  });
}

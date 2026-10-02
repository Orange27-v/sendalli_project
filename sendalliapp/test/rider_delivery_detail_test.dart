import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_delivery_detail_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_home_screen.dart';
import 'package:sendalliapp/widgets/dashboard_app_bar.dart';

void main() {
  final sampleRider = const UserProfile(
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

  testWidgets('DashboardAppBar renders user avatar, greeting, notification bell, and settings icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          appBar: DashboardAppBar(
            user: sampleRider,
            title: 'Hello John',
            subtitle: 'Refinery Road — Jakpa',
          ),
          body: const SizedBox(),
        ),
      ),
    );

    // Verify avatar with initial
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('J'), findsOneWidget);

    // Verify greeting and subtitle
    expect(find.text('Hello John'), findsOneWidget);
    expect(find.text('Refinery Road — Jakpa'), findsOneWidget);

    // Verify header action icons
    expect(find.byIcon(FeatherIcons.bell), findsOneWidget);
    expect(find.byIcon(FeatherIcons.settings), findsOneWidget);
  });

  testWidgets('RiderDeliveryDetailScreen renders route info, package details, notes, and triggers accept', (WidgetTester tester) async {
    bool accepted = false;
    bool declined = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderDeliveryDetailScreen(
          orderId: '#BE12345',
          referenceId: 'Ref: #BE12345',
          dateText: 'Today • 2:45 PM',
          pickupTitle: '9ja kitchen (Pickup Location)',
          dropoffTitle: 'John Deo (Drop-off Location)',
          packageItem: 'Food • Jollof Rice, meat and moi moi',
          deliveryFee: '₦ 1,200',
          customerName: 'John Deo',
          onAccept: () => accepted = true,
          onDecline: () => declined = true,
        ),
      ),
    );

    expect(find.text('Request Information'), findsOneWidget);
    expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
    expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
    expect(find.textContaining('Food • Jollof Rice, meat and moi moi'), findsWidgets);
    expect(find.text('Tap to inspect'), findsOneWidget);
    expect(find.text('Parcel Photo'), findsOneWidget);
    expect(find.text('₦ 1,200'), findsOneWidget);
    expect(find.text('1-Minute Roadside Window'), findsOneWidget);
    expect(find.text('Accept Delivery'), findsOneWidget);
    expect(find.text('Decline Request'), findsOneWidget);

    // Scroll to and Tap Accept Delivery
    await tester.ensureVisible(find.text('Accept Delivery'));
    await tester.tap(find.text('Accept Delivery'));
    await tester.pumpAndSettle();

    expect(accepted, isTrue);
    expect(declined, isFalse);
  });

  testWidgets('Tapping request item card in RiderHomeScreen opens RiderDeliveryDetailScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: sampleRider),
      ),
    );

    // Go Online
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Verify slide-up sheet rendered with request card
    expect(find.text('Package Delivery'), findsOneWidget);
    expect(find.text('Tap to inspect route & parcel details'), findsOneWidget);

    // Tap to open full details page
    await tester.tap(find.text('Tap to inspect route & parcel details'));
    await tester.pumpAndSettle();

    // Verify we navigated to RiderDeliveryDetailScreen
    expect(find.text('Request Information'), findsOneWidget);
    expect(find.text('1-Minute Roadside Window'), findsOneWidget);
  });
}

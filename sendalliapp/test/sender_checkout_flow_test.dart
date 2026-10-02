import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_checkout_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_order_tracking_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_home_screen.dart';
import 'package:sendalliapp/widgets/checkout/save_location_sheet.dart';

void main() {
  final testSender = const UserProfile(
    id: 'USR-123',
    firstName: 'Amaka',
    lastName: 'Chukwu',
    phone: '+2348012345678',
    role: UserRole.sender,
    pin: '1234',
    shopName: 'Amaka Kitchen & Grills',
  );

  testWidgets('SenderHomeScreen navigates to SenderCheckoutScreen on Send a New Parcel tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SenderHomeScreen(user: testSender),
      ),
    );

    expect(find.text('Send a New Parcel'), findsOneWidget);
    await tester.tap(find.text('Send a New Parcel'));
    await tester.pumpAndSettle();

    expect(find.byType(SenderCheckoutScreen), findsOneWidget);
    expect(find.text('Amaka Kitchen & Grills'), findsOneWidget);
    expect(find.text('Place Order'), findsOneWidget);
  });

  testWidgets('SenderCheckoutScreen updates total when toggling delivery options and places order', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SenderCheckoutScreen(user: testSender),
      ),
    );

    // Initial total is 1200 + 650 = 1850.00
    expect(find.text('₦ 1850.00'), findsOneWidget);

    // Scroll to and tap Standard 25 mins option
    await tester.ensureVisible(find.text('Standard 25 mins'));
    await tester.tap(find.text('Standard 25 mins'));
    await tester.pumpAndSettle();

    // Updated total is 1200 + 400 = 1600.00
    expect(find.text('₦ 1600.00'), findsOneWidget);

    // Tap Place Order
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    // Verify transitioned to tracking screen
    expect(find.byType(SenderOrderTrackingScreen), findsOneWidget);
    expect(find.text('10:20 - 10:30 PM'), findsOneWidget);
    expect(find.text("On time • We've got your order!"), findsOneWidget);
  });

  testWidgets('SaveLocationSheet allows entering address details and saving', (WidgetTester tester) async {
    String? savedDetails;
    String? savedNote;
    bool? savedFav;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SaveLocationSheet(
            onSave: (details, note, fav) {
              savedDetails = details;
              savedNote = note;
              savedFav = fav;
            },
            onSkip: () {},
          ),
        ),
      ),
    );

    expect(find.text('Do you want to save this location?'), findsOneWidget);

    // Enter address details
    await tester.enterText(find.byType(TextFormField).first, 'Flat 4, 2nd Floor');
    // Enter note to driver
    await tester.enterText(find.byType(TextFormField).last, 'Call when at the gate');

    // Tap save
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(savedDetails, 'Flat 4, 2nd Floor');
    expect(savedNote, 'Call when at the gate');
    expect(savedFav, isFalse);
  });

  testWidgets('SenderOrderTrackingScreen allows stepping through milestones and expanding summary', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SenderOrderTrackingScreen(
          orderId: '#SE12345',
          senderName: 'Amaka Kitchen & Grills',
          pickupAddress: 'Warri Central Kitchen',
          dropoffAddress: 'Effurun Market Plaza, Shop 14B',
          totalAmount: '₦ 1,850.00',
          deliveryOption: 'Priority (< 15 mins)',
          addressDetails: 'Flat 4, 2nd Floor',
          noteToDriver: 'Call when at gate',
        ),
      ),
    );

    expect(find.text('10:20 - 10:30 PM'), findsOneWidget);
    expect(find.text("We've received your order and notified the sender."), findsOneWidget);

    // Tap simulate next step
    await tester.tap(find.text('Simulate Next Step'));
    await tester.pump();
    expect(find.text('Order is being prepared and packed at the hub.'), findsOneWidget);

    // Expand summary
    await tester.ensureVisible(find.text('View order summary'));
    await tester.tap(find.text('View order summary'));
    await tester.pumpAndSettle();
    expect(find.text('#SE12345'), findsOneWidget);
    expect(find.text('Flat 4, 2nd Floor'), findsOneWidget);
  });
}

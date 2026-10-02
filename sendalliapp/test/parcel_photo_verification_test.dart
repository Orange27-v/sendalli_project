import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_checkout_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_home_screen.dart';
import 'package:sendalliapp/widgets/delivery/parcel_photo_card.dart';

void main() {
  final sampleSender = UserProfile(
    id: 'sender_test',
    firstName: 'Amaka',
    lastName: 'Eze',
    phone: '+2348098765432',
    role: UserRole.sender,
    pin: '1234',
    shopName: 'Amaka Fashion Boutique',
    corridor: 'Warri — Effurun Corridor',
  );

  final sampleRider = UserProfile(
    id: 'rider_test',
    firstName: 'John',
    lastName: 'Deo',
    phone: '+2348012345678',
    role: UserRole.rider,
    pin: '1234',
    vehiclePlate: 'WRA-492-XA',
    corridor: 'Warri — Effurun Corridor',
  );

  testWidgets('SenderCheckoutScreen renders corridor context, parcel photo card, and verification protocol', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SenderCheckoutScreen(user: sampleSender),
      ),
    );
    await tester.pumpAndSettle();

    // Verify corridor transit banner
    expect(find.text('Keke Route-Pooled Delivery'), findsOneWidget);
    expect(find.text('Delivery Corridor: Warri — Effurun'), findsOneWidget);

    // Verify parcel photo card and action buttons
    expect(find.byType(ParcelPhotoCard), findsOneWidget);
    expect(find.text('Snap Item Photo'), findsOneWidget);
    expect(find.text('Upload Image'), findsOneWidget);

    // Verify sample item chips
    expect(find.text('🍱 Food Cooler'), findsOneWidget);
    expect(find.text('👗 Fashion Pack'), findsOneWidget);

    // Verify two-way photo verification protocol card
    expect(find.text('Two-Way Photo Verification Protocol'), findsOneWidget);
    expect(find.textContaining('Sender attaches item dispatch photo before booking'), findsOneWidget);
    expect(find.textContaining('Keke rider snaps & submits confirmation picture'), findsOneWidget);

    // Tap sample item chip
    await tester.tap(find.text('👗 Fashion Pack'));
    await tester.pumpAndSettle();

    // Verify photo capture simulation
    await tester.tap(find.text('Snap Item Photo'));
    await tester.pumpAndSettle();
    expect(find.text('Parcel dispatch photo captured successfully!'), findsOneWidget);
  });

  testWidgets('RiderHomeScreen allows rider to snap and transmit roadside confirmation picture', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: RiderHomeScreen(user: sampleRider),
      ),
    );
    await tester.pumpAndSettle();

    // Toggle online
    final switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Accept incoming delivery to start active delivery view
    final acceptBtn = find.text('Accept Delivery');
    expect(acceptBtn, findsOneWidget);
    await tester.tap(acceptBtn);
    await tester.pumpAndSettle();

    // Verify Confirmation Picture card is present
    expect(find.text('Roadside Delivery Confirmation Picture'), findsOneWidget);
    final snapBtn = find.byKey(const Key('rider_snap_confirmation_btn'));
    expect(snapBtn, findsOneWidget);

    // Tap Snap Photo
    await tester.tap(snapBtn);
    await tester.pumpAndSettle();

    // Verify confirmation status
    expect(find.text('Confirmation Picture Captured & Sent'), findsOneWidget);
    expect(find.text('Roadside Handover Proof Verified'), findsOneWidget);
    expect(find.text('SENT'), findsOneWidget);
  });
}

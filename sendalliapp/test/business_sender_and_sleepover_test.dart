import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/hub_parcel_item.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/features/dashboard/screens/hub/hub_home_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_home_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/business_sender_registration_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/sender_setup_screen.dart';

void main() {
  group('Sleepover Custody Fee Tests (+₦500 overnight)', () {
    test('HubParcelItem correctly calculates base fee and overnight sleepover fees', () {
      final normalItem = HubParcelItem(
        trackingId: 'SND-WAR-1001',
        packageName: 'Standard Package',
        riderName: 'Musa',
        riderPhone: '08012345678',
        customerName: 'Emeka',
        customerPhone: '08087654321',
        corridor: 'Refinery Road — Jakpa',
        intakeTime: 'Today 2:00 PM',
        releasePin: '123456',
        reason: 'Handoff missed',
        overnightNights: 0,
      );

      expect(normalItem.hasSleptOver, isFalse);
      expect(normalItem.baseCustodyFee, 500.0);
      expect(normalItem.sleepoverFeeAmount, 0.0);
      expect(normalItem.totalHoldingFee, 500.0);
      expect(normalItem.formattedTotalFee, '₦ 500.00');

      final sleepoverItem = HubParcelItem(
        trackingId: 'SND-WAR-1002',
        packageName: 'Overnight Package',
        riderName: 'Diran',
        riderPhone: '08011122233',
        customerName: 'Sarah',
        customerPhone: '08099988877',
        corridor: 'Refinery Road — Jakpa',
        intakeTime: 'Intake: Yesterday • 1 Night',
        releasePin: '654321',
        reason: 'Unclaimed overnight',
        overnightNights: 1, // Slept over 1 night -> attracts extra ₦500
      );

      expect(sleepoverItem.hasSleptOver, isTrue);
      expect(sleepoverItem.baseCustodyFee, 500.0);
      expect(sleepoverItem.sleepoverFeeAmount, 500.0);
      expect(sleepoverItem.totalHoldingFee, 1000.0); // ₦500 base + ₦500 overnight
      expect(sleepoverItem.formattedTotalFee, '₦ 1000.00');
      expect(sleepoverItem.formattedSleepoverFee, '₦ 500.00');

      final multiNightItem = HubParcelItem(
        trackingId: 'SND-WAR-1003',
        packageName: '2 Nights Sleepover',
        riderName: 'Godwin',
        riderPhone: '08055566677',
        customerName: 'Festus',
        customerPhone: '08033322211',
        corridor: 'Effurun Roundabout Corridor',
        intakeTime: 'Intake: 2 Days ago',
        releasePin: '998877',
        reason: 'Extended hold',
        overnightNights: 2, // 2 nights -> attracts extra ₦1000
      );

      expect(multiNightItem.hasSleptOver, isTrue);
      expect(multiNightItem.totalHoldingFee, 1500.0); // 500 + (2 * 500)
      expect(multiNightItem.sleepoverFeeAmount, 1000.0);
    });

    testWidgets('HubHomeScreen displays sleepover badge and overnight breakdown modal', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const hubUser = UserProfile(
        id: 'HUB-TEST-01',
        firstName: 'John',
        lastName: 'Hub',
        phone: '08012345678',
        role: UserRole.hub,
        pin: '1234',
        unionPark: 'Refinery Road Drop Hub',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: HubHomeScreen(user: hubUser),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to "In Custody" tab (filter index 1)
      final inCustodyTab = find.byKey(const Key('hub_filter_held'));
      expect(inCustodyTab, findsOneWidget);
      await tester.ensureVisible(inCustodyTab);
      await tester.tap(inCustodyTab);
      await tester.pumpAndSettle();

      // Verify sleepover badge is visible on the held item that slept over
      expect(find.text('Sleepover (+₦500)'), findsOneWidget);
      expect(find.textContaining('₦500 base + ₦500 sleepover'), findsOneWidget);

      // Tap on the sleepover parcel to open details bottom sheet
      await tester.ensureVisible(find.text('Sleepover (+₦500)'));
      await tester.tap(find.text('Sleepover (+₦500)'));
      await tester.pumpAndSettle();

      // Verify modal displays overnight sleepover breakdown
      expect(find.text('Parcel Order Details'), findsOneWidget);
      expect(find.text('Custody Payout (Sleepover)'), findsOneWidget);
      expect(find.text('₦ 1000.00'), findsWidgets);
      expect(find.textContaining('Overnight Sleepover Applied (1 Night)'), findsOneWidget);
      expect(find.textContaining('Base Hub Custody Fee:'), findsOneWidget);
      expect(find.textContaining('+₦ 500.00'), findsOneWidget);
      expect(find.textContaining('Total Custody Fee Payable:'), findsOneWidget);
    });
  });

  group('Business Sender Registration Form Tests (Dedicated Screen & CAC Upload)', () {
    testWidgets('SenderSetupScreen provides direct link to BusinessSenderRegistrationScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: SenderSetupScreen(
            phoneNumber: '+234 803 111 2233',
            firstName: 'Tari',
            lastName: 'Ebi',
            pin: '1234',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify business application banner exists on setup screen
      expect(find.text('Applying as a Registered Business?'), findsOneWidget);
      final applyBtn = find.byKey(const Key('apply_as_business_sender_btn'));
      expect(applyBtn, findsOneWidget);

      await tester.ensureVisible(applyBtn);
      await tester.tap(applyBtn);
      await tester.pumpAndSettle();

      // Verify we arrived on the dedicated Business Sender Application screen
      expect(find.text('Business Sender Application'), findsOneWidget);
      expect(find.text('1. REGISTERED BUSINESS IDENTITY'), findsOneWidget);
      expect(find.text('3. CAC REGISTRATION CERTIFICATE (MANDATORY)'), findsOneWidget);
    });

    testWidgets('BusinessSenderRegistrationScreen validates required fields and CAC certificate upload', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: BusinessSenderRegistrationScreen(
            phoneNumber: '+234 803 999 8877',
            firstName: 'Amina',
            lastName: 'Bello',
            pin: '1234',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially certificate is not uploaded
      expect(find.text('Upload CAC Certificate / Document'), findsOneWidget);

      // Attempt to submit without filling required fields
      final submitBtn = find.byKey(const Key('submit_business_application_btn'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
      expect(find.text('Please enter your Registered Business Name.'), findsOneWidget);

      // Enter business name
      await tester.enterText(find.byKey(const Key('business_name_field')), 'Bello Logistics Ltd');
      await tester.pumpAndSettle();

      // Attempt to submit without CAC RC/BN number
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
      expect(find.text('Please enter your CAC Registration (RC or BN) number.'), findsOneWidget);

      // Enter CAC number
      await tester.enterText(find.byKey(const Key('business_cac_field')), 'RC-9988771');
      await tester.pumpAndSettle();

      // Attempt to submit without uploading certificate
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();
      expect(find.text('Business Registration Certificate is mandatory. Please upload your CAC certificate.'), findsOneWidget);

      // Now attach sample CAC certificate
      final sampleCacBtn = find.byKey(const Key('sample_cac_certificate_btn'));
      await tester.ensureVisible(sampleCacBtn);
      await tester.tap(sampleCacBtn);
      await tester.pumpAndSettle();

      // Verify certificate is marked as attached
      expect(find.text('Attached'), findsOneWidget);
      expect(find.textContaining('Incorporation_Cert.pdf'), findsOneWidget);
      expect(find.byKey(const Key('replace_certificate_btn')), findsOneWidget);
      expect(find.byKey(const Key('remove_certificate_btn')), findsOneWidget);
    });

    testWidgets('Quick sample fill and submission on BusinessSenderRegistrationScreen succeeds', (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: BusinessSenderRegistrationScreen(
            phoneNumber: '+234 803 555 1234',
            firstName: 'Chief',
            lastName: 'Obi',
            pin: '1234',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap sample data quick fill button
      await tester.tap(find.byKey(const Key('quick_fill_business_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Warri Central Mercantile Ltd'), findsWidgets);
      expect(find.text('RC-1849204'), findsOneWidget);
      expect(find.text('Attached'), findsOneWidget);

      // Tap submit application button
      final submitBtn = find.byKey(const Key('submit_business_application_btn'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));



      // Handle permission dialog if presented
      final enableNotifFinder = find.text('Enable Notifications');
      if (enableNotifFinder.evaluate().isNotEmpty) {
        await tester.tap(enableNotifFinder);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Profile completed modal appears
      expect(find.text('Profile Completed!'), findsOneWidget);
      expect(find.textContaining('Business Application Submitted!'), findsOneWidget);
    });

    testWidgets('SenderHomeScreen displays CAC verified status badge for verified businesses', (tester) async {
      const verifiedBizUser = UserProfile(
        id: 'BIZ-USER-01',
        firstName: 'Chief',
        lastName: 'Obi',
        phone: '+234 803 555 1234',
        role: UserRole.sender,
        pin: '1234',
        shopName: 'Warri Central Mercantile Ltd',
        cacNumber: 'RC-1849204',
        isBusinessVerified: true,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: SenderHomeScreen(user: verifiedBizUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Verified Commercial Business • CAC: RC-1849204'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/features/onboarding/screens/sender_setup_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/rider_setup_screen.dart';
import 'package:sendalliapp/features/onboarding/screens/hub_setup_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/common/profile_screen.dart';

void main() {
  group('Onboarding Email Field Tests for Rider, Sender, and Hub', () {
    testWidgets('SenderSetupScreen renders Email Address input field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SenderSetupScreen(
            phoneNumber: '+2348031234567',
            firstName: 'Amina',
            lastName: 'Bello',
            pin: '1234',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Email Address (for Receipts & Tracking)'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField).at(1),
        'amina.store@sendalli.com',
      );
      await tester.pump();
      expect(find.text('amina.store@sendalli.com'), findsOneWidget);
    });

    testWidgets('RiderSetupScreen renders Email Address input field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RiderSetupScreen(
            phoneNumber: '+2348039876543',
            firstName: 'Tega',
            lastName: 'Okoro',
            pin: '5678',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Email Address (for Payout Statements)'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField).last,
        'tega.rider@gmail.com',
      );
      await tester.pump();
      expect(find.text('tega.rider@gmail.com'), findsOneWidget);
    });

    testWidgets('HubSetupScreen renders Email Address input field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HubSetupScreen(
            phoneNumber: '+2348055554444',
            firstName: 'Osas',
            lastName: 'Igho',
            pin: '9012',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Email Address (for Invoices & Holding Fees)'), findsOneWidget);
      await tester.enterText(
        find.byType(TextField).at(2),
        'osas.hub@sendalli.com',
      );
      await tester.pump();
      expect(find.text('osas.hub@sendalli.com'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders email address when present', (tester) async {
      const user = UserProfile(
        id: 'USR-TEST-001',
        firstName: 'Efe',
        lastName: 'Macaulay',
        phone: '+2348021112222',
        role: UserRole.sender,
        pin: '1234',
        email: 'efe.macaulay@sendalli.com',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(user: user),
        ),
      );
      await tester.pump();

      expect(find.text('efe.macaulay@sendalli.com'), findsOneWidget);
    });
  });
}

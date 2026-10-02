import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:sendalliapp/core/models/user_profile.dart';
import 'package:sendalliapp/core/models/user_role.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/features/dashboard/screens/screens.dart';

void main() {
  final sampleRider = UserProfile(
    id: 'rider_01',
    firstName: 'John',
    lastName: 'Doe',
    phone: '+2348012345678',
    role: UserRole.rider,
    pin: '1234',
    trustScore: 80,
    vehiclePlate: 'WRA-492-XA',
    corridor: 'Warri — Effurun Corridor',
    unionPark: 'Effurun Central Park',
  );

  final sampleSender = UserProfile(
    id: 'sender_01',
    firstName: 'Amaka',
    lastName: 'Eze',
    phone: '+2348098765432',
    role: UserRole.sender,
    pin: '1234',
    shopName: 'Amaka Fashion Boutique',
    landmark: 'Main Market, Warri',
  );

  testWidgets('ProfileScreen renders rider trust metrics and operational credentials', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ProfileScreen(user: sampleRider),
      ),
    );
    await tester.pumpAndSettle();

    // Verify user profile credentials
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Pioneer Corridor Rider'), findsOneWidget);
    expect(find.text('80.0'), findsOneWidget);
    expect(find.text('TRUST SCORE'), findsOneWidget);
    expect(find.text('WRA-492-XA'), findsOneWidget);
    expect(find.text('Guaranty Trust Bank (GTB)'), findsOneWidget);
  });

  testWidgets('NotificationsScreen displays role-specific corridor alerts and filter tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: NotificationsScreen(user: sampleRider),
      ),
    );
    await tester.pumpAndSettle();

    // Verify filter tabs
    expect(find.textContaining('All'), findsOneWidget);
    expect(find.textContaining('Unread'), findsOneWidget);
    expect(find.text('Actionable'), findsOneWidget);

    // Verify rider notifications
    expect(find.text('New Corridor Trip Nearby'), findsOneWidget);
    expect(find.text('Trust Score Milestone (+2 pts)'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders notification switches and security PIN actions', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SettingsScreen(user: sampleSender),
      ),
    );
    await tester.pumpAndSettle();

    // Verify sections
    expect(find.text('NOTIFICATIONS & ALERTS'), findsOneWidget);
    expect(find.text('Push Notifications'), findsOneWidget);
    expect(find.text('Roadside SMS Arrival Alerts'), findsOneWidget);
    expect(find.text('CORRIDOR PREFERENCES'), findsOneWidget);
    expect(find.text('Change 4-Digit Security PIN'), findsOneWidget);
  });

  testWidgets('SenderHomeScreen displays header icons (notifications, settings) and corridor map', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: SenderHomeScreen(user: sampleSender),
      ),
    );
    await tester.pumpAndSettle();

    // Verify header icons
    expect(find.byIcon(FeatherIcons.bell), findsOneWidget);
    expect(find.byIcon(FeatherIcons.settings), findsOneWidget);

    // Verify corridor map and status
    expect(find.text('Corridor Route Activity'), findsOneWidget);
    expect(find.text('Corridor Live'), findsOneWidget);
  });
}

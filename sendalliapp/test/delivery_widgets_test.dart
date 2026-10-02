import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/widgets/delivery/delivery_widgets.dart';

void main() {
  testWidgets('DeliveryRouteCard renders pickup and drop-off information correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeliveryRouteCard(
            pickupTitle: '9ja kitchen (Pickup Location)',
            pickupSubtitle: 'Lagos avenue, Ring road',
            dropoffTitle: 'John Deo (Drop-off Location)',
            dropoffSubtitle: '114, Ojuelegba, Lagos state',
          ),
        ),
      ),
    );

    expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
    expect(find.text('Lagos avenue, Ring road'), findsOneWidget);
    expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
    expect(find.text('114, Ojuelegba, Lagos state'), findsOneWidget);
  });

  testWidgets('DeliveryCodeBanner displays code with prominent amber styling', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeliveryCodeBanner(
            code: '1234',
          ),
        ),
      ),
    );

    expect(find.textContaining('Confirm Delivery Code from customer:'), findsOneWidget);
    expect(find.textContaining('1234'), findsOneWidget);
  });

  testWidgets('DeliveryPrimaryButton handles press events and loading state', (WidgetTester tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: DeliveryPrimaryButton(
            label: 'Accept Delivery',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    expect(find.text('Accept Delivery'), findsOneWidget);
    await tester.tap(find.text('Accept Delivery'));
    await tester.pump();
    expect(pressed, isTrue);

    // Test loading state
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: DeliveryPrimaryButton(
            label: 'Accept Delivery',
            isLoading: true,
            onPressed: null,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DeliveryNoteTile and DeliveryCustomerNoteCard render properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              DeliveryNoteTile(title: 'Pickup note'),
              DeliveryCustomerNoteCard(note: 'Ring the bell when you get to the gate'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Pickup note'), findsOneWidget);
    expect(find.text('Customers note'), findsOneWidget);
    expect(find.text('Ring the bell when you get to the gate'), findsOneWidget);
  });

  testWidgets('DeliveryCustomerRow triggers chat and call actions', (WidgetTester tester) async {
    var chatCalled = false;
    var callCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeliveryCustomerRow(
            name: 'John Deo',
            onChatPressed: () => chatCalled = true,
            onCallPressed: () => callCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('John Deo'), findsOneWidget);
    await tester.tap(find.byTooltip('Send message'));
    expect(chatCalled, isTrue);

    await tester.tap(find.byTooltip('Call customer'));
    expect(callCalled, isTrue);
  });

  testWidgets('DeliveryPackageCard renders package details and fee', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeliveryPackageCard(
            packageId: '#BE12345',
            packageItem: 'Food',
            deliveryFee: '₦ 260.00',
          ),
        ),
      ),
    );

    expect(find.text('Package Id #BE12345'), findsOneWidget);
    expect(find.text('Package Item: Food'), findsOneWidget);
    expect(find.text('₦ 260.00'), findsOneWidget);
  });

  testWidgets('IncomingDeliverySheet renders all composite components', (WidgetTester tester) async {
    var accepted = false;
    var cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: IncomingDeliverySheet(
            onAccept: () => accepted = true,
            onCancel: () => cancelled = true,
          ),
        ),
      ),
    );

    expect(find.text('Package Delivery'), findsOneWidget);
    expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
    expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
    expect(find.text('Accept Delivery'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.ensureVisible(find.text('Accept Delivery'));
    await tester.tap(find.text('Accept Delivery'));
    expect(accepted, isTrue);

    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    expect(cancelled, isTrue);
  });
}

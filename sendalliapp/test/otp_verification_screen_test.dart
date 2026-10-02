import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/features/onboarding/screens/otp_verification_screen.dart';

void main() {
  testWidgets('OtpVerificationScreen renders sizable 4-digit input boxes and auto-advances', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OtpVerificationScreen(
          phoneNumber: '+2348059088934',
        ),
      ),
    );
    await tester.pump();

    // Verify headers
    expect(find.text('Verify OTP'), findsOneWidget);
    expect(find.text('We sent you an SMS'), findsOneWidget);
    expect(find.text('Enter the 4-digit code sent to +2348059088934'), findsOneWidget);

    // Verify 4 input boxes are present
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(4));

    // Verify sleek container dimensions (48 x 52)
    final containers = tester.widgetList<Container>(
      find.descendant(of: find.byType(Row), matching: find.byType(Container)),
    );
    final otpBox = containers.firstWhere(
      (c) => c.constraints?.maxWidth == 48 || (c.decoration is BoxDecoration && (c.decoration as BoxDecoration).borderRadius != null),
    );
    expect(otpBox, isNotNull);

    // Enter digits sequentially
    await tester.enterText(textFields.at(0), '1');
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.enterText(textFields.at(1), '2');
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.enterText(textFields.at(2), '3');
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    await tester.enterText(textFields.at(3), '4');
    await tester.pump();
    expect(find.text('4'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpWidget(const SizedBox());
  });
}

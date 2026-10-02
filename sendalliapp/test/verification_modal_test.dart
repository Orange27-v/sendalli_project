import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/widgets/verification/verification_widgets.dart';

void main() {
  testWidgets('SendalliQrDisplay renders title, QR CustomPaint, and formatted PIN', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SendalliQrDisplay(
            qrData: 'SND-WAR-8492',
            pin: '849201',
            title: 'Customer Release QR',
          ),
        ),
      ),
    );

    expect(find.text('Customer Release QR'), findsOneWidget);
    expect(find.textContaining('849 201'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('SendalliQrScannerView triggers onScanned callback upon detection', (WidgetTester tester) async {
    String scannedCode = '';

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SendalliQrScannerView(
            simulatedCode: 'SND-WAR-8492',
            onScanned: (val) => scannedCode = val,
          ),
        ),
      ),
    );

    expect(find.text('Point camera at the QR code to verify'), findsOneWidget);
    expect(find.text('Simulate Camera QR Detection'), findsOneWidget);

    // Tap simulate scan button
    await tester.tap(find.text('Simulate Camera QR Detection'));
    await tester.pump();

    expect(scannedCode, 'SND-WAR-8492');
  });

  testWidgets('SendalliPinInputView validates entered digits and quick fills valid PIN', (WidgetTester tester) async {
    String verifiedPin = '';

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SendalliPinInputView(
            pinLength: 4,
            expectedPin: '1234',
            onVerified: (pin) => verifiedPin = pin,
          ),
        ),
      ),
    );

    expect(find.text('Enter Security Handover PIN'), findsOneWidget);
    expect(find.text('Verify PIN'), findsOneWidget);

    // Tap quick fill valid PIN
    await tester.tap(find.textContaining('Quick Fill Valid PIN'));
    await tester.pump();

    expect(verifiedPin, '1234');
  });

  testWidgets('SendalliVerificationModal switches tabs and confirms verification', (WidgetTester tester) async {
    bool? verifiedResult;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SendalliVerificationModal(
            title: 'Verify Delivery Step',
            subtitle: 'Scan QR or enter PIN',
            expectedPin: '1234',
            showPresentationTab: true,
            pinLength: 4,
            onVerified: (code) => verifiedResult = true,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Verify modal headers and tabs
    expect(find.text('Verify Delivery Step'), findsOneWidget);
    expect(find.text('Scan QR'), findsOneWidget);
    expect(find.text('Enter PIN'), findsOneWidget);
    expect(find.text('My QR/PIN'), findsOneWidget);

    // Switch to Enter PIN tab
    await tester.ensureVisible(find.text('Enter PIN'));
    await tester.tap(find.text('Enter PIN'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Enter Security Handover PIN'), findsOneWidget);

    // Switch to My QR/PIN tab
    await tester.ensureVisible(find.text('My QR/PIN'));
    await tester.tap(find.text('My QR/PIN'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Handover QR Code'), findsOneWidget);
    expect(find.textContaining('12 34'), findsOneWidget);

    // Switch back to Scan QR tab and simulate scan
    await tester.ensureVisible(find.text('Scan QR'));
    await tester.tap(find.text('Scan QR'));
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Simulate Camera QR Detection'));
    await tester.pump(const Duration(milliseconds: 800));

    // Verify confirmation and result
    expect(verifiedResult, isTrue);
  });
}

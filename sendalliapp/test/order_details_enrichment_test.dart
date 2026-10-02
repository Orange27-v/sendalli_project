import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendalliapp/core/theme/app_theme.dart';
import 'package:sendalliapp/widgets/delivery/parcel_photo_card.dart';
import 'package:sendalliapp/features/dashboard/screens/rider/rider_delivery_detail_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/sender/sender_order_tracking_screen.dart';
import 'package:sendalliapp/features/dashboard/screens/receiver/receiver_tracking_screen.dart';

void main() {
  group('Order Details Enrichment Tests (Value, Photo, Pickup/Drop-off, Other Info)', () {
    testWidgets('ParcelPhotoCard renders photo container, value badge, and opens enlarged view', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ParcelPhotoCard(
              orderId: '#BE88910',
              packageItem: 'Electronics & Fast Charger',
              packageValue: '₦ 16,500.00',
              photoAsset: 'assets/images/parcel_sample.png',
            ),
          ),
        ),
      );

      // Verify basic card presence
      expect(find.text('Parcel Photo'), findsOneWidget);
      expect(find.text('Value: ₦ 16,500.00'), findsOneWidget);
      expect(find.text('Tap to inspect'), findsOneWidget);

      // Tap to inspect enlarged photo modal
      await tester.tap(find.text('Tap to inspect'));
      await tester.pumpAndSettle();

      // Verify enlarged modal contents
      expect(find.text('Parcel Photo • #BE88910'), findsOneWidget);
      expect(find.text('Declared Value: ₦ 16,500.00'), findsWidgets);
      expect(find.text('Tamper-Evident Seal Verified'), findsOneWidget);
    });

    testWidgets('RiderDeliveryDetailScreen shows full order details including value, photo, and contacts', (tester) async {
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
            packageValue: '₦ 4,800.00',
            weightCategory: 'Standard (< 5kg)',
            customerName: 'John Deo',
            customerPhone: '+234 803 111 2222',
            senderName: 'Mama Put Canteen',
            senderPhone: '+234 802 333 4444',
            customerNote: 'Package is wrapped in thermal foil.',
          ),
        ),
      );

      // Verify order details
      expect(find.text('Request Information'), findsOneWidget);
      expect(find.text('Declared Value: ₦ 4,800.00'), findsOneWidget);
      expect(find.text('9ja kitchen (Pickup Location)'), findsOneWidget);
      expect(find.text('John Deo (Drop-off Location)'), findsOneWidget);
      expect(find.text('Sender: Mama Put Canteen'), findsOneWidget);
      expect(find.text('Receiver: John Deo'), findsOneWidget);
      expect(find.text('1-Minute Roadside Window'), findsOneWidget);
    });

    testWidgets('SenderOrderTrackingScreen displays parcel photo, declared value, and specifications', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SenderOrderTrackingScreen(
            orderId: 'SND-WAR-8492',
            senderName: 'Tunde Fashion House',
            pickupAddress: 'Effurun Market Gate, Warri',
            dropoffAddress: 'Jakpa Junction (Roadside Stop)',
            totalAmount: '₦ 1,800.00',
            deliveryOption: 'Standard Delivery',
            packageValue: '₦ 9,500.00',
            weightCategory: 'Medium Parcel (< 10kg)',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ORDER SPECIFICATIONS'), findsOneWidget);
      expect(find.text('Escrow Secured'), findsWidgets);
      expect(find.text('₦ 9,500.00'), findsWidgets);
      expect(find.text('Medium Parcel (< 10kg)'), findsOneWidget);
    });

    testWidgets('ReceiverTrackingScreen renders parcel photo and order value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ReceiverTrackingScreen(
            trackingId: 'TRK-WAR-5930',
            packageValue: '₦ 7,200.00',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('TRK-WAR-5930'), findsOneWidget);
      expect(find.text('Value: ₦ 7,200.00'), findsWidgets);
      expect(find.text('YOUR 6-DIGIT RELEASE CODE'), findsOneWidget);
    });
  });
}

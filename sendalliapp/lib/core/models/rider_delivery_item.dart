/// Status of a corridor delivery request from the rider's perspective.
enum DeliveryItemStatus {
  pending,
  counterOffered,
  accepted,
  completed,
}

/// Model representing a delivery request for riders, including counter-offer capabilities,
/// item value, dispatch photo, route information, and contact details.
class RiderDeliveryItem {
  final String orderId;
  final String referenceId;
  final String dateText;
  final String pickupTitle;
  final String pickupSubtitle;
  final String dropoffTitle;
  final String dropoffSubtitle;
  final String packageItem;
  final String customerName;
  final String customerNote;
  final String handoverCode;
  String deliveryFee;
  String? riderProposedFee;
  String? objectionReason;
  DeliveryItemStatus status;

  // Detailed order properties
  final String packageValue;
  final String? photoAsset;
  final String senderName;
  final String senderPhone;
  final String customerPhone;
  final String weightCategory;
  final String paymentStatus;

  RiderDeliveryItem({
    required this.orderId,
    required this.referenceId,
    required this.dateText,
    required this.pickupTitle,
    required this.pickupSubtitle,
    required this.dropoffTitle,
    required this.dropoffSubtitle,
    required this.packageItem,
    required this.customerName,
    required this.customerNote,
    required this.handoverCode,
    required this.deliveryFee,
    this.riderProposedFee,
    this.objectionReason,
    this.status = DeliveryItemStatus.pending,
    this.packageValue = '₦ 5,000.00',
    this.photoAsset,
    this.senderName = 'Corridor Sender',
    this.senderPhone = '+234 803 111 2233',
    this.customerPhone = '+234 803 000 1234',
    this.weightCategory = 'Small Parcel (< 1kg)',
    this.paymentStatus = 'Escrow Secured (Sendalli Guarantee)',
  });
}

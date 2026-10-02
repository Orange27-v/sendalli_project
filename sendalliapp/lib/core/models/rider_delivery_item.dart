/// Status of a corridor delivery request from the rider's perspective.
enum DeliveryItemStatus {
  pending,
  counterOffered,
  accepted,
  completed,
}

/// Model representing a delivery request for riders, including counter-offer capabilities.
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
  });
}

/// Status of a parcel within a corridor hub custody lifecycle.
enum HubParcelStatus {
  pendingDropoff,
  heldInCustody,
  delivered,
}

/// Model representing a parcel drop-off and custody item in a Hub.
class HubParcelItem {
  final String trackingId;
  final String packageName;
  final String riderName;
  final String riderPhone;
  final String customerName;
  final String customerPhone;
  final String corridor;
  final String intakeTime;
  final String? releaseTime;
  final String custodyFee;
  final String releasePin;
  final String reason;
  final String? eta;
  final String? storageLocation;
  HubParcelStatus status;

  // Overnight sleepover custody fee tracking (attracts extra ₦500 per overnight stay)
  final int overnightNights;
  final double baseCustodyFee;
  final double sleepoverFeePerNight;

  // Detailed order properties
  final String packageValue;
  final String? photoAsset;
  final String pickupTitle;
  final String dropoffTitle;
  final String weightCategory;
  final String paymentStatus;

  HubParcelItem({
    required this.trackingId,
    required this.packageName,
    required this.riderName,
    required this.riderPhone,
    required this.customerName,
    required this.customerPhone,
    required this.corridor,
    required this.intakeTime,
    this.releaseTime,
    String? custodyFee,
    required this.releasePin,
    required this.reason,
    this.eta,
    this.storageLocation,
    this.status = HubParcelStatus.pendingDropoff,
    this.overnightNights = 0,
    this.baseCustodyFee = 500.0,
    this.sleepoverFeePerNight = 500.0,
    this.packageValue = '₦ 8,500.00',
    this.photoAsset,
    this.pickupTitle = 'Refinery Road Pickup Hub',
    this.dropoffTitle = 'Jakpa Roadside Delivery Stop',
    this.weightCategory = '0.9 kg • Sealed Box',
    this.paymentStatus = 'Escrow Secured',
  }) : custodyFee = custodyFee ?? '₦ ${(baseCustodyFee + (overnightNights * sleepoverFeePerNight)).toStringAsFixed(2)}';

  /// Whether this parcel has slept over overnight in the Hub.
  bool get hasSleptOver => overnightNights > 0;

  /// Total custody holding fee including overnight sleepovers (₦500 base + ₦500/night).
  double get totalHoldingFee => baseCustodyFee + (overnightNights * sleepoverFeePerNight);

  /// Additional fee accrued exclusively from sleeping over.
  double get sleepoverFeeAmount => overnightNights * sleepoverFeePerNight;

  /// Formatted total fee string.
  String get formattedTotalFee => '₦ ${totalHoldingFee.toStringAsFixed(2)}';

  /// Formatted sleepover fee string.
  String get formattedSleepoverFee => '₦ ${sleepoverFeeAmount.toStringAsFixed(2)}';
}

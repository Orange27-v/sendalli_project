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
    this.custodyFee = '₦ 500.00',
    required this.releasePin,
    required this.reason,
    this.eta,
    this.storageLocation,
    this.status = HubParcelStatus.pendingDropoff,
  });
}

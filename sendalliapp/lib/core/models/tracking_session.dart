/// Model representing an active parcel tracking session for guest receivers.
class TrackingSession {
  final String trackingId;
  final String senderName;
  final String receiverName;
  final String receiverPhone;
  final String pickupPoint;
  final String dropPoint;
  final String status; // 'booked', 'picked_up', 'in_transit', 'arrived_hub', 'completed'
  final int estimatedArrivalMinutes;
  final String releaseCode; // 6-digit code
  final String? riderName;
  final String? riderPhone;
  final String? riderVehiclePlate;
  final int? riderTrustScore;
  final double deliveryFee;

  const TrackingSession({
    required this.trackingId,
    required this.senderName,
    required this.receiverName,
    required this.receiverPhone,
    required this.pickupPoint,
    required this.dropPoint,
    required this.status,
    required this.estimatedArrivalMinutes,
    required this.releaseCode,
    this.riderName,
    this.riderPhone,
    this.riderVehiclePlate,
    this.riderTrustScore,
    required this.deliveryFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'trackingId': trackingId,
      'senderName': senderName,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'pickupPoint': pickupPoint,
      'dropPoint': dropPoint,
      'status': status,
      'estimatedArrivalMinutes': estimatedArrivalMinutes,
      'releaseCode': releaseCode,
      'riderName': riderName,
      'riderPhone': riderPhone,
      'riderVehiclePlate': riderVehiclePlate,
      'riderTrustScore': riderTrustScore,
      'deliveryFee': deliveryFee,
    };
  }

  factory TrackingSession.fromJson(Map<String, dynamic> json) {
    return TrackingSession(
      trackingId: json['trackingId'] as String,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      receiverPhone: json['receiverPhone'] as String,
      pickupPoint: json['pickupPoint'] as String,
      dropPoint: json['dropPoint'] as String,
      status: json['status'] as String,
      estimatedArrivalMinutes: json['estimatedArrivalMinutes'] as int,
      releaseCode: json['releaseCode'] as String,
      riderName: json['riderName'] as String?,
      riderPhone: json['riderPhone'] as String?,
      riderVehiclePlate: json['riderVehiclePlate'] as String?,
      riderTrustScore: json['riderTrustScore'] as int?,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
    );
  }
}

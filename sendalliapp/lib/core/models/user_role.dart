/// The 4 distinct operational roles within the Sendalli ecosystem.
enum UserRole {
  sender,
  rider,
  hub,
  receiver;

  String get displayName {
    switch (this) {
      case UserRole.sender:
        return 'Sender';
      case UserRole.rider:
        return 'Rider (Keke / Bus)';
      case UserRole.hub:
        return 'Drop Hub Partner';
      case UserRole.receiver:
        return 'Package Receiver';
    }
  }

  String get shortTag {
    switch (this) {
      case UserRole.sender:
        return 'Send Parcels';
      case UserRole.rider:
        return 'Deliver Along Route';
      case UserRole.hub:
        return 'Roadside Store Hub';
      case UserRole.receiver:
        return 'Track Parcel';
    }
  }

  String get description {
    switch (this) {
      case UserRole.sender:
        return 'Anybody can send parcels or items across town on keke corridors.';
      case UserRole.rider:
        return 'I drive commercial routes and want to earn extra on small packages.';
      case UserRole.hub:
        return 'I operate a roadside shop or chemist and want to store packages.';
      case UserRole.receiver:
        return 'I am expecting a package and want to track its roadside arrival.';
    }
  }
}

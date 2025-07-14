class CarInformation {
  final String carId;         // Firestore doc ID or generated UUID
  final String ownerId;       // UID of the user who owns this car
  final String brand;         // Brand or make (e.g., Toyota)
  final String model;         // Model (e.g., Vios)
  final String plateNumber;   // Car plate
  final int seatsAvailable;   // Number of seats in car
  final String color;         // Car color
  final bool isVerified;      // ✅ NEW: Whether this car is verified

  CarInformation({
    required this.carId,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.seatsAvailable,
    required this.color,
    this.isVerified = false, // New cars default to not verified
  });

  factory CarInformation.fromJson(Map<String, dynamic> json) {
    return CarInformation(
      carId: json['carId'],
      ownerId: json['ownerId'],
      brand: json['brand'],
      model: json['model'],
      plateNumber: json['plateNumber'],
      seatsAvailable: json['seatsAvailable'],
      color: json['color'],
      isVerified: json['isVerified'] ?? false, // fallback default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'plateNumber': plateNumber,
      'seatsAvailable': seatsAvailable,
      'color': color,
      'isVerified': isVerified,
    };
  }
}
class CarInformation {
  final String carId;
  final String ownerId;
  final String brand;
  final String model;
  final int year;
  final String color;
  final String plateNumber;
  final String vin;
  final bool isVerified;

  CarInformation({
    required this.carId,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.plateNumber,
    required this.vin,
    required this.isVerified,
  });

  factory CarInformation.fromJson(Map<String, dynamic> json) {
    return CarInformation(
      carId: json['carId'],
      ownerId: json['ownerId'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      plateNumber: json['plateNumber'],
      vin: json['vin'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carId': carId,
      'ownerId': ownerId,
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'plateNumber': plateNumber,
      'vin': vin,
      'isVerified': isVerified,
    };
  }
}

class CarInformation {
  final String carId;
  final String ownerId; // Rider UID
  final String brand;
  final String model;
  final String plateNumber;
  final int seatsAvailable;
  final String color;
  final String? carImage;

  CarInformation({
    required this.carId,
    required this.ownerId,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.seatsAvailable,
    required this.color,
    this.carImage,
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
      carImage: json['carImage'],
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
      'carImage': carImage,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class RideModel {
  final String rideId;
  final String creatorId;
  final String carId;
  final List<PassengerStatus> passengers; 
  final bool isStarted;
  final bool isCompleted;
  final DateTime createdAt;

  RideModel({
    required this.rideId,
    required this.creatorId,
    required this.carId,
    required this.passengers,
    required this.isStarted,
    required this.isCompleted,
    required this.createdAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    final passengerList = (json['passengers'] as List<dynamic>? ?? [])
        .map((p) => PassengerStatus.fromJson(p as Map<String, dynamic>))
        .toList();

    return RideModel(
      rideId: json['rideId'] ?? '',
      creatorId: json['creatorId'] ?? '',
      carId: json['carId'] ?? '',
      passengers: passengerList,
      isStarted: json['isStarted'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'creatorId': creatorId,
      'carId': carId,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'isStarted': isStarted,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }
}

class PassengerStatus {
  final String passengerId;
  final String status; // 'joined', 'accepted', 'rejected'

  PassengerStatus({
    required this.passengerId,
    required this.status,
  });

  factory PassengerStatus.fromJson(Map<String, dynamic> json) {
    return PassengerStatus(
      passengerId: json['passengerId'] ?? '',
      status: json['status'] ?? 'joined',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passengerId': passengerId,
      'status': status,
    };
  }
}
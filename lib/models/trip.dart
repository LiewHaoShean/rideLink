import 'package:cloud_firestore/cloud_firestore.dart';

class PassengerStatus {
  final String passengerId;
  final String status;

  PassengerStatus({
    required this.passengerId,
    required this.status,
  });

  factory PassengerStatus.fromJson(Map<String, dynamic> json) {
    return PassengerStatus(
      passengerId: json['passengerId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passengerId': passengerId,
      'status': status,
    };
  }
}

class Trip {
  final String rideId;
  final String creatorId;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int availableSeats;
  final double pricePerSeat;
  final List<PassengerStatus> passengers;
  final String status;

  Trip({
    required this.rideId, 
    required this.creatorId,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.passengers,
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    // Smart fallback for origin and destination
    final fromMap = json['from'] as Map<String, dynamic>?;
    final toMap = json['to'] as Map<String, dynamic>?;

    final origin = json['origin'] ?? fromMap?['name'] ?? '';
    final destination = json['destination'] ?? toMap?['name'] ?? '';

    // Smart fallback for departureTime
    final Timestamp? timestamp = json['departureTime'] ??
        json['time'] ??
        json['date'];

    final departureTime = timestamp?.toDate() ?? DateTime.now();

    return Trip(
      rideId: json['rideId'] ?? '',
      creatorId: json['creatorId'] ?? '',
      origin: origin,
      destination: destination,
      departureTime: departureTime,
      availableSeats: json['availableSeats'] ?? json['seats'] ?? 0,
      pricePerSeat: (json['pricePerSeat'] ?? json['price'] ?? 0).toDouble(),
      passengers: (json['passengers'] as List<dynamic>? ?? [])
          .map((p) => PassengerStatus.fromJson(p as Map<String, dynamic>))
          .toList(),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creatorId': creatorId,
      'origin': origin,
      'destination': destination,
      'departureTime': Timestamp.fromDate(departureTime),
      'availableSeats': availableSeats,
      'pricePerSeat': pricePerSeat,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'status': status,
      // rideId is *not* saved in Firestore, only local.
    };
  }
}


import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Trip {
  final String tripId;
  final String riderId;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int availableSeats;
  final double pricePerSeat;
  final List<String> passengerIds;
  final String status; // 'scheduled', 'ongoing', etc.

  Trip({
    required this.tripId,
    required this.riderId,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.passengerIds,
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'],
      riderId: json['riderId'],
      origin: json['origin'],
      destination: json['destination'],
      departureTime: (json['departureTime'] as Timestamp).toDate(),
      availableSeats: json['availableSeats'],
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      passengerIds: List<String>.from(json['passengerIds']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'riderId': riderId,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime,
      'availableSeats': availableSeats,
      'pricePerSeat': pricePerSeat,
      'passengerIds': passengerIds,
      'status': status,
    };
  }
}

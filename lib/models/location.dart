class Location {
  final String name;
  final double latitude;
  final double longitude;
  final String addressLine;
  final String city;
  final String state;
  final String postcode;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.postcode,
  });

  /// Convert to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'postcode': postcode,
    };
  }

  /// Create from Firestore JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      addressLine: json['addressLine'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postcode: json['postcode']?.toString() ?? '',
    );
  }

  /// String representation
  @override
  String toString() {
    return '$name, $addressLine, $city, $state, $postcode';
  }

  /// Equality: good for comparing locations
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          addressLine == other.addressLine &&
          city == other.city &&
          state == other.state &&
          postcode == other.postcode;

  @override
  int get hashCode =>
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      addressLine.hashCode ^
      city.hashCode ^
      state.hashCode ^
      postcode.hashCode;
}

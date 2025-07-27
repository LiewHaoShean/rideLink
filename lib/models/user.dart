class UserModel {
  final String uid;
  final String name;
  final String email;
  final String userRole; // e.g. 'driver' or 'passenger' or 'admin'
  final String nic;
  final String? gender;
  final bool isEmailVerified;
  double credit;
  double profit;
  final String? phone;
  final bool isBanned;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.userRole,
    required this.nic,
    this.phone,
    this.gender,
    this.credit = 0,
    this.profit = 0,
    this.isEmailVerified = false,
    this.isBanned = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      userRole: json['userRole'],
      nic: json['nic'],
      phone: json['phone'],
      gender: json['gender'],
      credit: parseDouble(json['credit']),
      profit: parseDouble(json['profit']),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isBanned: json['isBanned'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'userRole': userRole,
      'nic': nic,
      'phone': phone,
      'gender': gender,
      'credit': credit,
      'profit': profit,
      'isEmailVerified': isEmailVerified,
      'isBanned': isBanned,
    };
  }
}

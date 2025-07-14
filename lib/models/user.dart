class UserModel {
  final String uid;
  final String name;
  final String email;
  final String userRole; // 'default: passenger' or 'rider'
  final String nic;
  final String? gender;
  final bool isEmailVerified;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.userRole,
    required this.nic,
    this.gender,
    this.isEmailVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      userRole: json['userRole'],
      nic: json['nic'],
      gender: json['gender'],
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'userRole': userRole,
      'nic': nic,
      'gender': gender,
      'isEmailVerified': isEmailVerified,
    };
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'fullName': fullName, 'email': email, 'phoneNumber': phoneNumber};
  }
}

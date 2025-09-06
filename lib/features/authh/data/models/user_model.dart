import '../../../../core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.userName,
    required super.password,
  });


  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      userName:  map['userName'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'userName': userName,
      'password': password,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? userName,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      password: password ?? this.password,
    );
  }

}

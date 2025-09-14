// import '../../../../core/entities/user.dart';
//
// class UserModel extends User {
//   UserModel({
//     required super.id,
//     required super.email,
//     required super.fullName,
//     required super.userName,
//     required super.password,
//   });
//
//
//   factory UserModel.fromJson(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       fullName: map['fullName'] ?? '',
//       userName:  map['userName'] ?? '',
//       password: map['password'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'email': email,
//       'fullName': fullName,
//       'userName': userName,
//       'password': password,
//     };
//   }
//
//   UserModel copyWith({
//     String? id,
//     String? email,
//     String? fullName,
//     String? userName,
//     String? password,
//   }) {
//     return UserModel(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       fullName: fullName ?? this.fullName,
//       userName: userName ?? this.userName,
//       password: password ?? this.password,
//     );
//   }
//
// }
import '../../../../core/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.full_name,
    required super.user_name,
    required super.password,
    required super.bio,
    required super.avatarUrl,
    required super.phone,
    required super.address,
    required super.age,
    required super.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      full_name: map['full_name'] ?? '',
      user_name: map['user_name'] ?? '',
      password: map['password'] ?? '',
      bio: map['bio'] ?? '',
      avatarUrl: map['avatar_url'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': full_name,
      'user_name': user_name,
      'password': password,
      'bio': bio,
      'avatar_url': avatarUrl,
      'phone': phone,
      'address': address,
      'age': age,
      'gender': gender,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? full_name,
    String? user_name,
    String? password,
    String? bio,
    String? avatarUrl,
    String? phone,
    String? address,
    int? age,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      full_name: full_name ?? this.full_name,
      user_name: user_name ?? this.user_name,
      password: password ?? this.password,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}

import 'dart:core';

class User {
  final String id;
  final String email;
  final String full_name;
  final String user_name;
  final String password;
  final String bio;
  final String avatarUrl;
  final String phone;
  final String address;
  final int age;
  final String? gender;

  User({
    required this.id,
    required this.email,
    required this.full_name,
    required this.user_name,
    required this.password,
    required this.bio,
    required this.avatarUrl,
    required this.phone,
    required this.address,
    required this.age,
    required this.gender,
  });
}

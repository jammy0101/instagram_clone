// import 'package:hive/hive.dart';
// import '../../domain/entities/profile_entity.dart';
//
// //part 'profile_model.g.dart';
//
// @HiveType(typeId: 0)
// class ProfileModel extends HiveObject {
//   @HiveField(0)
//   final String id;
//   @HiveField(1)
//   final String name;
//   @HiveField(2)
//   final String username;
//   @HiveField(3)
//   final String bio;
//   @HiveField(4)
//   final String? avatarUrl;
//   @HiveField(5)
//   final String? phone;
//   @HiveField(6)
//   final String? address;
//   @HiveField(7)
//   final int? age;
//   @HiveField(8)
//   final String? gender;
//
//   ProfileModel({
//     required this.id,
//     required this.name,
//     required this.username,
//     required this.bio,
//     this.avatarUrl,
//     this.phone,
//     this.address,
//     this.age,
//     this.gender,
//   });
//
//   factory ProfileModel.fromEntity(Profile p) => ProfileModel(
//     id: p.id,
//     name: p.name,
//     username: p.username,
//     bio: p.bio,
//     avatarUrl: p.avatarUrl,
//     phone: p.phone,
//     address: p.address,
//     age: p.age,
//     gender: p.gender,
//   );
//
//   Profile toEntity() => Profile(
//     id: id,
//     name: name,
//     username: username,
//     bio: bio,
//     avatarUrl: avatarUrl,
//     phone: phone,
//     address: address,
//     age: age,
//     gender: gender,
//   );
// }
import 'package:hive/hive.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart'; // ✅ required for Hive code generation

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String bio;

  @HiveField(4)
  final String? avatarUrl;

  @HiveField(5)
  final String? phone;

  @HiveField(6)
  final String? address;

  @HiveField(7)
  final int? age;

  @HiveField(8)
  final String? gender;

   ProfileModel({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    this.avatarUrl,
    this.phone,
    this.address,
    this.age,
    this.gender,
  });

  /// ✅ Convert from domain entity to model
  factory ProfileModel.fromEntity(Profile p) => ProfileModel(
    id: p.id,
    name: p.name,
    username: p.username,
    bio: p.bio,
    avatarUrl: p.avatarUrl,
    phone: p.phone,
    address: p.address,
    age: p.age,
    gender: p.gender,
  );

  /// ✅ Convert model back to domain entity
  Profile toEntity() => Profile(
    id: id,
    name: name,
    username: username,
    bio: bio,
    avatarUrl: avatarUrl,
    phone: phone,
    address: address,
    age: age,
    gender: gender,
  );

  /// ✅ Convert from JSON (Supabase)
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as String,
    name: json['name'] ?? '',
    username: json['username'] ?? '',
    bio: json['bio'] ?? '',
    avatarUrl: json['avatar_url'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    age: json['age'] as int?,
    gender: json['gender'] as String?,
  );

  /// ✅ Convert to JSON (Supabase)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'bio': bio,
    'avatar_url': avatarUrl,
    'phone': phone,
    'address': address,
    'age': age,
    'gender': gender,
  };
}

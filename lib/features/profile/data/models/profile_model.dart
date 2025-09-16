
import 'package:hive/hive.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String userName;

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
    required this.fullName,
    required this.userName,
    this.bio = '',
    this.avatarUrl,
    this.phone,
    this.address,
    this.age,
    this.gender,
  });

  /// domain -> model
  factory ProfileModel.fromEntity(Profile p) => ProfileModel(
    id: p.id,
    fullName: p.fullName,
    userName: p.userName,
    bio: p.bio,
    avatarUrl: p.avatarUrl,
    phone: p.phone,
    address: p.address,
    age: p.age,
    gender: p.gender,
  );

  /// model -> domain
  Profile toEntity() => Profile(
    id: id,
    fullName: fullName,
    userName: userName,
    bio: bio,
    avatarUrl: avatarUrl,
    phone: phone,
    address: address,
    age: age,
    gender: gender,
  );

  /// from Supabase JSON (snake_case friendly)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: (json['full_name'] ?? '') as String,
      userName: (json['user_name'] ?? '') as String,
      bio: (json['bio'] ?? '') as String,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      age: json['age'] is int
          ? json['age'] as int
          : (json['age'] != null
          ? int.tryParse(json['age'].toString())
          : null),
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'user_name': userName,
    'bio': bio,
    'avatar_url': avatarUrl,
    'phone': phone,
    'address': address,
    'age': age,
    'gender': gender,
  };
}
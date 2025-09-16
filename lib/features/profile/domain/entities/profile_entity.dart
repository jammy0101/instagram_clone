class Profile {
  final String id;
  final String fullName;
  final String userName;
  final String bio;
  final String? avatarUrl;
  final String? phone;
  final String? address;
  final int? age;
  final String? gender;

  const Profile({
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

  Profile copyWith({
    String? fullName,
    String? userName,
    String? bio,
    String? avatarUrl,
    String? phone,
    String? address,
    int? age,
    String? gender,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}

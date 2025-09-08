class Profile {
  final String id;
  final String name;
  final String username;
  final String bio;
  final String? avatarUrl;
  final String? phone;
  final String? address;
  final int? age;
  final String? gender;

  Profile({
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

  Profile copyWith({
    String? name,
    String? username,
    String? bio,
    String? avatarUrl,
    String? phone,
    String? address,
    int? age,
    String? gender,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}

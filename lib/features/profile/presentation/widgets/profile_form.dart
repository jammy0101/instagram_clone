// import 'package:flutter/material.dart';
// import '../../domain/entities/profile_entity.dart';
//
// class ProfileForm extends StatefulWidget {
//   final Profile profile;
//   final VoidCallback onAvatarTap;
//   final ValueChanged<Profile> onChanged;
//
//   const ProfileForm({
//     super.key,
//     required this.profile,
//     required this.onAvatarTap,
//     required this.onChanged,
//   });
//
//   @override
//   State<ProfileForm> createState() => _ProfileFormState();
// }
//
// class _ProfileFormState extends State<ProfileForm> {
//   late TextEditingController _name;
//   late TextEditingController _username;
//   late TextEditingController _bio;
//
//   @override
//   void initState() {
//     super.initState();
//     _name = TextEditingController(text: widget.profile.name);
//     _username = TextEditingController(text: widget.profile.username);
//     _bio = TextEditingController(text: widget.profile.bio);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Center(
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 44,
//                 backgroundImage: widget.profile.avatarUrl != null
//                     ? NetworkImage(widget.profile.avatarUrl!)
//                     : null,
//               ),
//               TextButton(
//                 onPressed: widget.onAvatarTap,
//                 child: const Text("Change profile photo"),
//               )
//             ],
//           ),
//         ),
//         TextField(
//           controller: _name,
//           decoration: const InputDecoration(labelText: "Name"),
//           onChanged: (v) => widget.onChanged(widget.profile.copyWith(name: v)),
//         ),
//         TextField(
//           controller: _username,
//           decoration: const InputDecoration(labelText: "Username"),
//           onChanged: (v) => widget.onChanged(widget.profile.copyWith(username: v)),
//         ),
//         TextField(
//           controller: _bio,
//           decoration: const InputDecoration(labelText: "Bio"),
//           maxLines: 3,
//           onChanged: (v) => widget.onChanged(widget.profile.copyWith(bio: v)),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileForm extends StatefulWidget {
  final Profile profile;
  final VoidCallback onAvatarTap;
  final ValueChanged<Profile> onChanged;

  const ProfileForm({
    super.key,
    required this.profile,
    required this.onAvatarTap,
    required this.onChanged,
  });

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _name;
  late TextEditingController _username;
  late TextEditingController _bio;
  late TextEditingController _phone;
  late TextEditingController _address;
  late TextEditingController _age;
  late TextEditingController _gender;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _username = TextEditingController(text: widget.profile.username);
    _bio = TextEditingController(text: widget.profile.bio);
    _phone = TextEditingController(text: widget.profile.phone);
    _address = TextEditingController(text: widget.profile.address);
    _age = TextEditingController(text: widget.profile.age?.toString() ?? '');
    _gender = TextEditingController(text: widget.profile.gender);
  }

  void _onChanged() {
    widget.onChanged(widget.profile.copyWith(
      name: _name.text,
      username: _username.text,
      bio: _bio.text,
      phone: _phone.text,
      address: _address.text,
      age: int.tryParse(_age.text),
      gender: _gender.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage: widget.profile.avatarUrl != null
                    ? NetworkImage(widget.profile.avatarUrl!)
                    : null,
              ),
              TextButton(
                onPressed: widget.onAvatarTap,
                child: const Text("Change profile photo"),
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: _name,
          decoration: const InputDecoration(labelText: "Name"),
          onChanged: (_) => _onChanged(),
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _username,
          decoration: const InputDecoration(labelText: "Username"),
          onChanged: (_) => _onChanged(),
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _bio,
          decoration: const InputDecoration(labelText: "Bio"),
          maxLines: 3,
          onChanged: (_) => _onChanged(),
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _phone,
          decoration: const InputDecoration(labelText: "Phone"),
          onChanged: (_) => _onChanged(),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _address,
          decoration: const InputDecoration(labelText: "Address"),
          onChanged: (_) => _onChanged(),
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _age,
          decoration: const InputDecoration(labelText: "Age"),
          onChanged: (_) => _onChanged(),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20,),
        TextField(
          controller: _gender,
          decoration: const InputDecoration(labelText: "Gender"),
          onChanged: (_) => _onChanged(),
        ),
      ],
    );
  }
}

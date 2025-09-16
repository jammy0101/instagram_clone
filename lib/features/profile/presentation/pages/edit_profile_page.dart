
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_form.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late ProfileCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
    cubit.loadProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (cubit.state.profile != null) {
                cubit.saveProfile(cubit.state.profile!);
              }
            },
          )
        ],
      ),

      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text("Error: ${state.error}"));
          if (state.profile == null) return const SizedBox();

          return ProfileForm(
            profile: state.profile!,
            onAvatarTap: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                cubit.changeAvatar(widget.userId, picked.path);
              }
            },
            onChanged: (updated) {
              cubit.emit(state.copyWith(profile: updated));
            },
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../core/bottum_navigation_bar/bottom_navigation_bar.dart';
// import '../cubit/profile_cubit.dart';
// import '../widgets/profile_form.dart';
//
// class EditProfilePage extends StatefulWidget {
//   final String userId;
//   const EditProfilePage({super.key, required this.userId});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   late ProfileCubit cubit;
//
//   @override
//   void initState() {
//     super.initState();
//     cubit = context.read<ProfileCubit>();
//     cubit.loadProfile(widget.userId);
//   }
//
//   Future<void> _pickAvatar() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       cubit.changeAvatar(widget.userId, picked.path);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check, size: 26),
//             onPressed: () {
//               if (cubit.state.profile != null) {
//                 cubit.saveProfile(cubit.state.profile!);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Profile updated successfully")),
//                 );
//               }
//             },
//           )
//         ],
//       ),
//       bottomNavigationBar: const CustomNavigationBar(),
//       body: BlocBuilder<ProfileCubit, ProfileState>(
//         builder: (context, state) {
//           if (state.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.error != null) {
//             return Center(child: Text("Error: ${state.error}"));
//           }
//           if (state.profile == null) return const SizedBox();
//
//           return ProfileForm(
//             profile: state.profile!,
//             onAvatarTap: _pickAvatar,
//             onChanged: (updated) {
//               cubit.emit(state.copyWith(profile: updated));
//             },
//           );
//         },
//       ),
//     );
//   }
// }

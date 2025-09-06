import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/authh/presentation/pages/login_page.dart';

import '../../../authh/presentation/bloc/auth_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 👇 Dispatch logout event
              context.read<AuthBloc>().add(AuthLogout());
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}

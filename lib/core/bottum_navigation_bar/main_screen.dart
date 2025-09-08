import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/home/presentation/pages/home.dart';
import 'package:horizon/features/search/presentation/pages/search.dart';
import 'package:horizon/features/feed/presentation/pages/feed.dart';
import 'package:horizon/features/cart/presentation/pages/cart.dart';
import 'package:horizon/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/common/cubit/bottom_nav_cubit.dart';
import 'bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) =>  MainScreen());

  final List<Widget> _pages =  [
    Home(),
    Search(),
    Feed(),
    Cart(),
    EditProfilePage(userId: Supabase.instance.client.auth.currentUser?.id ?? ''),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, selectedIndex) {
        return Scaffold(
          body: IndexedStack(
            index: selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: const CustomNavigationBar(),
        );
      },
    );
  }
}

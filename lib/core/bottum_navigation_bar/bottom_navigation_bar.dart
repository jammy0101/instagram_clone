import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/home/presentation/pages/home.dart';
import 'package:horizon/features/social_profile_page/presentation/pages/social_profile_page.dart';
import '../../features/Reel/presentation/pages/feed_page.dart';
import '../../features/cart/presentation/pages/cart.dart';
import '../../features/search/presentation/pages/search.dart';
import '../common/cubit/bottom_nav_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, selectedIndex) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.blueGrey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          onTap: (index) {
            if (index == selectedIndex) return;
            context.read<BottomNavCubit>().setTab(index);

            Widget destination;
            switch (index) {
              case 0:
                destination = const Home();
                break;
              case 1:
                destination = const Search();
                break;
              case 2:
                final userId = Supabase.instance.client.auth.currentUser?.id;
                if (userId == null) {
                  // TODO: Navigate to login page
                  destination = const Home();
                } else {
                  destination = FeedPage(currentUserId: userId);
                }
                break;
              case 3:
                destination = const Cart();
                break;
              // case 4:
              //   destination =  EditProfilePage(userId: Supabase.instance.client.auth.currentUser?.id ?? '');
              //   break;
              case 4:
                destination = SocialProfilePage();
              default:
                destination = const Home();
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => destination),
            );
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Reel'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}

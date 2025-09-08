import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/home/presentation/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/cart/presentation/pages/cart.dart';
import '../../features/feed/presentation/pages/feed.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/search/presentation/pages/search.dart';
import '../common/cubit/bottom_nav_cubit.dart';


// class CustomNavigationBar extends StatelessWidget {
//   const CustomNavigationBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavCubit, int>(
//       builder: (context, selectedIndex) {
//         return BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: selectedIndex,
//           selectedItemColor: Colors.red,
//           unselectedItemColor:  Colors.blueGrey,
//           showUnselectedLabels: true,
//           showSelectedLabels: true,
//           onTap: (index) {
//             if (index == selectedIndex) return;
//
//             // Update Cubit index
//             context.read<BottomNavCubit>().setTab(index);
//
//             // Navigate to the selected page
//             Widget destination;
//             switch (index) {
//               case 0:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => Home()),
//                 );
//                 break;
//               case 1:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => Search()),
//                 );
//                 break;
//               case 2:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => Feed()),
//                 );
//                 break;
//               case 3:
//                // destination = const Cart();
//               // Replace current screen with new screen
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => Cart()),
//                 );
//                 break;
//               default:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => Profile()),
//                 );
//             }
//
//
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.search),
//               label: 'Search',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.vertical_distribute),
//               label: 'Feed',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag),
//               label: 'Cart',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/cubit/bottom_nav_cubit.dart';

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
          // onTap: (index) {
          //   if (index == selectedIndex) return;
          //   print("Switching to tab $index"); // 👈 test
          //   context.read<BottomNavCubit>().setTab(index);
          // },
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
                destination = const Feed();
                break;
              case 3:
                destination = const Cart();
                break;
              case 4:
                destination =  EditProfilePage(userId: Supabase.instance.client.auth.currentUser?.id ?? '');
                break;
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
            BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      },
    );
  }
}

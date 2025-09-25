//
// import 'package:flutter/foundation.dart'; // for kDebugMod
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:horizon/core/bottum_navigation_bar/main_screen.dart';
// import 'package:horizon/features/stories/presentation/cubit/story_cubit.dart';
// import 'core/common/cubit/auth_user_cubit.dart';
// import 'core/common/cubit/bottom_nav_cubit.dart';
// import 'core/theme/theme.dart';
// import 'features/Reel/data/models/post_model.dart';
// import 'features/Reel/presentation/bloc/feed_bloc.dart';
// import 'features/authh/presentation/bloc/auth_bloc.dart';
// import 'features/authh/presentation/pages/login_page.dart';
// import 'features/profile/data/models/profile_model.dart';
// import 'features/profile/presentation/cubit/profile_cubit.dart';
// import 'features/social_profile_page/presentation/bloc/social_profile_bloc.dart';
// import 'init_dependencies_main.dart';
//
// // AuthRemoteDataSource → calls Supabase, can throw ServerException.
// // AuthRepository (interface) → the contract your app depends on.
// // AuthRepositoryImpl → converts exceptions to Failure, returns Either.
// // UI → calls repository only, matches on Either to show success/error.
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   //Hive.registerAdapter(ProfileModelAdapter());
//   //await Hive.openBox<ProfileModel>('profileBox');
//   if (!Hive.isAdapterRegistered(0)) {
//     Hive.registerAdapter(ProfileModelAdapter());
//   }
//
//   // Register PostModel adapter safely
//   if (!Hive.isAdapterRegistered(2)) {
//     Hive.registerAdapter(PostModelAdapter());
//   }
//
//   await Hive.deleteBoxFromDisk('feedBox');
//   await Hive.openBox<ProfileModel>('profileBox');
//   await Hive.openBox<String>('socialProfileBox');
//   await Hive.openBox<PostModel>('feedBox');
//
//   await initDependencies();
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => serviceLocater<AuthUserCubit>()),
//         BlocProvider(create: (_) => serviceLocater<AuthBloc>()),
//         BlocProvider(create: (_) => serviceLocater<StoryCubit>()),
//         BlocProvider(create: (_) => serviceLocater<BottomNavCubit>()),
//         BlocProvider(create: (_) => serviceLocater<ProfileCubit>()),
//         BlocProvider(create: (_) => serviceLocater<SocialProfileBloc>()),
//         BlocProvider(create: (_) => serviceLocater<FeedBloc>()), // ✅ add this
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//   @override
//   void initState() {
//     super.initState();
//     context.read<AuthBloc>().add(AuthIsUserLoggedIn());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: AppTheme.dartThemeMode,
//       home: BlocSelector<AuthUserCubit, AuthUserState, bool>(
//         selector: (state) {
//           return state is AuthUserLoggedIn;
//         },
//         builder: (context, isLoggedIn) {
//           if (isLoggedIn) {
//             return MainScreen();
//           }
//           return LoginPage();
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:horizon/core/bottum_navigation_bar/main_screen.dart';
import 'package:horizon/features/stories/presentation/cubit/story_cubit.dart';
import 'core/common/cubit/auth_user_cubit.dart';
import 'core/common/cubit/bottom_nav_cubit.dart';
import 'core/theme/theme.dart';
import 'features/Reel/data/models/post_model.dart';
import 'features/Reel/presentation/bloc/feed_bloc.dart';
import 'features/authh/presentation/bloc/auth_bloc.dart';
import 'features/authh/presentation/pages/login_page.dart';
import 'features/profile/data/models/profile_model.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/social_profile_page/presentation/bloc/social_profile_bloc.dart';
import 'init_dependencies_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register ProfileModel adapter safely
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ProfileModelAdapter());
  }

  // Register PostModel adapter safely
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PostModelAdapter());
  }

  // ❌ remove this line (was wiping data every restart)
  // await Hive.deleteBoxFromDisk('feedBox');

  // Open Hive boxes
  await Hive.openBox<ProfileModel>('profileBox');
  await Hive.openBox<String>('socialProfileBox');
  await Hive.openBox<PostModel>('feedBox');

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocater<AuthUserCubit>()),
        BlocProvider(create: (_) => serviceLocater<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocater<StoryCubit>()),
        BlocProvider(create: (_) => serviceLocater<BottomNavCubit>()),
        BlocProvider(create: (_) => serviceLocater<ProfileCubit>()),
        BlocProvider(create: (_) => serviceLocater<SocialProfileBloc>()),
        BlocProvider(create: (_) => serviceLocater<FeedBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.dartThemeMode,
      home: BlocSelector<AuthUserCubit, AuthUserState, bool>(
        selector: (state) => state is AuthUserLoggedIn,
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return  MainScreen();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

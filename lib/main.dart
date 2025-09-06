// import 'package:flutter/material.dart';
// import 'package:horizon/core/secrets/app_secret.dart';
// import 'package:horizon/features/auth/presentation/pages/login_page.dart';
// import 'package:horizon/features/auth/presentation/pages/signup_page.dart';
// import 'package:horizon/features/authh/presentation/pages/signup_page.dart';
//
// import 'features/authh/presentation/pages/login_page.dart';
// import 'init_dependencies.dart';
//
// void main()async{
//   WidgetsFlutterBinding.ensureInitialized();
//   initDependencies();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData.dark(),
//       initialRoute: '/',
//       routes: {
//         '/' : (context) => LoginPage(),
//         '/signUp' : (context) => SignupPage(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/home/presentation/pages/home.dart';
import 'package:horizon/features/profile/presentation/pages/profile.dart';
import 'package:horizon/features/stories/presentation/cubit/story_cubit.dart';

import 'core/common/cubit/auth_user_cubit.dart';
import 'core/theme/theme.dart';
import 'features/authh/presentation/bloc/auth_bloc.dart';
import 'features/authh/presentation/pages/login_page.dart';
import 'init_dependencies_main.dart';
// AuthRemoteDataSource → calls Supabase, can throw ServerException.
// AuthRepository (interface) → the contract your app depends on.
// AuthRepositoryImpl → converts exceptions to Failure, returns Either.
// UI → calls repository only, matches on Either to show success/error.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocater<AuthUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocater<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocater<StoryCubit>(),
        ),
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
  // This widget is the root of your application.
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
        selector: (state) {
          return state is AuthUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if(isLoggedIn){
            return Home();
          }
          return LoginPage();
        },
      ),
    );
  }
}

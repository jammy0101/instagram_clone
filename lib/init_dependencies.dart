part of 'init_dependencies_main.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initStory();
  _initNavigation();
  _initProfile();

  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );
  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AuthUserCubit());
  //serviceLocater.registerLazySingleton(() => Hive.box(name : 'blogs'));
  serviceLocater.registerLazySingleton(
    () => Logout(serviceLocater<AuthRepository>()),
  );
  serviceLocater.registerLazySingleton(() => InternetConnection());
  serviceLocater.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocater()),
  );

  serviceLocater.registerLazySingleton(
    () => StoryCubit(
      serviceLocater<GetStoriesUseCase>(),
      serviceLocater<UploadStoryUseCase>(),
      serviceLocater<DeleteExpiredStories>(),
      serviceLocater<MarkStoryViewed>(),
      serviceLocater<DeleteStory>(),
    ),
  );

  serviceLocater.registerLazySingleton(() => StorageService(serviceLocater()));
}

void _initAuth() {
  //this is the datasource
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocater()),
    )
    //this is the repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocater(), serviceLocater()),
    )
    //this is the Use cases
    ..registerFactory(() => UserSignUp(authRepository: serviceLocater()))
    //this is for Login
    ..registerFactory(() => UserLogin(authRepository: serviceLocater()))
    //This is for Current User
    ..registerFactory(() => CurrentUser(serviceLocater()))
    //This is the bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocater(),
        userLogin: serviceLocater(),
        currentUser: serviceLocater(),
        authUserCubit: serviceLocater(),
        logout: serviceLocater(),
      ),
    );
}

void _initStory() {
  serviceLocater
    ..registerFactory<StoryRemoteDataSource>(
      () => StoryRemoteDataSourceImpl(serviceLocater()),
    )
    ..registerFactory<StoryRepository>(
      () => StoryRepositoryImpl(serviceLocater()),
    )
    ..registerFactory(() => GetStoriesUseCase(serviceLocater()))
    ..registerFactory(() => UploadStoryUseCase(serviceLocater()))
    ..registerFactory(() => MarkStoryViewed(serviceLocater()))
    ..registerFactory(() => DeleteExpiredStories(repository: serviceLocater()))
    ..registerFactory(() => DeleteStory(repository: serviceLocater()));
}

void _initNavigation() {
  serviceLocater.registerLazySingleton(() => BottomNavCubit());
}

// void _initProfile() {
//   // Hive adapter for profile
//
//   // ✅ Just use already opened box
//   final profileBox = Hive.box<ProfileModel>('profileBox');
//
//   Hive.registerAdapter(ProfileModelAdapter());
//   serviceLocater.registerLazySingletonAsync<Box<ProfileModel>>(
//         () async => await Hive.openBox<ProfileModel>('profileBox'),
//   );
//
//   // Data sources
//   serviceLocater
//     ..registerFactory<ProfileRemoteDataSource>(
//           () => ProfileRemoteDataSource(serviceLocater()),
//     )
//     ..registerFactory<ProfileLocalDataSource>(
//           () => ProfileLocalDataSource(serviceLocater()),
//     )
//
//   // Repository
//     ..registerFactory<ProfileRepository>(
//           () => ProfileRepositoryImpl(
//         remote: serviceLocater(),
//         local: serviceLocater(),
//       ),
//     )
//
//   // Usecases
//     ..registerFactory(() => GetProfile(serviceLocater()))
//     ..registerFactory(() => UpdateProfile(serviceLocater()))
//     ..registerFactory(() => UploadAvatar(serviceLocater()))
//
//   // Cubit
//     ..registerLazySingleton(
//           () => ProfileCubit(
//         getProfile: serviceLocater(),
//         updateProfile: serviceLocater(),
//         uploadAvatar: serviceLocater(),
//       ),
//     );
// }
void _initProfile() {
  // ✅ Reuse already opened box from main.dart
  final profileBox = Hive.box<ProfileModel>('profileBox');

  serviceLocater
    ..registerLazySingleton<Box<ProfileModel>>(() => profileBox)

  // Data sources
    ..registerFactory<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSource(serviceLocater()),
    )
    ..registerFactory<ProfileLocalDataSource>(
          () => ProfileLocalDataSource(serviceLocater()),
    )

  // Repository
    ..registerFactory<ProfileRepository>(
          () => ProfileRepositoryImpl(
        remote: serviceLocater(),
        local: serviceLocater(),
      ),
    )

  // Usecases
    ..registerFactory(() => GetProfile(serviceLocater()))
    ..registerFactory(() => UpdateProfile(serviceLocater()))
    ..registerFactory(() => UploadAvatar(serviceLocater()))

  // Cubit
    ..registerLazySingleton(
          () => ProfileCubit(
        getProfile: serviceLocater(),
        updateProfile: serviceLocater(),
        uploadAvatar: serviceLocater(),
      ),
    );
}


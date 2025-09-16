// part of 'init_dependencies_main.dart';
//
// final serviceLocater = GetIt.instance;
//
// Future<void> initDependencies() async {
//   _initAuth();
//   _initStory();
//   _initNavigation();
//   _initProfile();
//   _initSocialProfile(); // 👈 add this
//
//   final supabase = await Supabase.initialize(
//     url: AppSecret.supabaseUrl,
//     anonKey: AppSecret.supabaseAnonKey,
//   );
//
//   serviceLocater.registerLazySingleton(() => supabase.client);
//   serviceLocater.registerLazySingleton(() => AuthUserCubit());
//   //serviceLocater.registerLazySingleton(() => Hive.box(name : 'blogs'));
//   serviceLocater.registerLazySingleton(() => Logout(serviceLocater<AuthRepository>()),);
//   serviceLocater.registerLazySingleton(() => InternetConnection());
//   serviceLocater.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocater()),);
//
//   serviceLocater.registerLazySingleton(
//     () => StoryCubit(
//       serviceLocater<GetStoriesUseCase>(),
//       serviceLocater<UploadStoryUseCase>(),
//       serviceLocater<DeleteExpiredStories>(),
//       serviceLocater<MarkStoryViewed>(),
//       serviceLocater<DeleteStory>(),
//     ),
//   );
//
//   serviceLocater.registerLazySingleton(() => StorageService(serviceLocater()));
// }
//
// void _initAuth() {
//   //this is the datasource
//   serviceLocater
//     ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocater()),)
//     //this is the repository
//     ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocater(), serviceLocater()),)
//     //this is the Use cases
//     ..registerFactory(() => UserSignUp(authRepository: serviceLocater()))
//     //this is for Login
//     ..registerFactory(() => UserLogin(authRepository: serviceLocater()))
//     //This is for Current User
//     ..registerFactory(() => CurrentUser(serviceLocater()))
//     //This is the bloc
//     ..registerLazySingleton(() => AuthBloc(
//         userSignUp: serviceLocater(),
//         userLogin:  serviceLocater(),
//         currentUser: serviceLocater(),
//         authUserCubit: serviceLocater(),
//         logout: serviceLocater(),
//       ),
//     );
// }
// void _initStory() {
//   serviceLocater
//     ..registerFactory<StoryRemoteDataSource>(() => StoryRemoteDataSourceImpl(serviceLocater()),)
//     ..registerFactory<StoryRepository>(() => StoryRepositoryImpl(serviceLocater()),)
//     ..registerFactory(() => GetStoriesUseCase(serviceLocater()))
//     ..registerFactory(() => UploadStoryUseCase(serviceLocater()))
//     ..registerFactory(() => MarkStoryViewed(serviceLocater()))
//     ..registerFactory(() => DeleteExpiredStories(repository: serviceLocater()))
//     ..registerFactory(() => DeleteStory(repository: serviceLocater()));
// }
// void _initNavigation() {serviceLocater.registerLazySingleton(() => BottomNavCubit());}
// void _initProfile() {
//   // ✅ Reuse already opened box from main.dart
//   final profileBox = Hive.box<ProfileModel>('profileBox');
//   serviceLocater
//     ..registerLazySingleton<Box<ProfileModel>>(() => profileBox)
//     // Data sources
//     ..registerFactory<ProfileRemoteDataSource>(() => ProfileRemoteDataSource(serviceLocater()),)
//     ..registerFactory<ProfileLocalDataSource>(() => ProfileLocalDataSource(serviceLocater()),)
//     // Repository
//     ..registerFactory<ProfileRepository>(() => ProfileRepositoryImpl(remote: serviceLocater(), local: serviceLocater(),),
//     )
//     // Usecases
//     ..registerFactory(() => GetProfile(serviceLocater()))
//     ..registerFactory(() => UpdateProfile(serviceLocater()))
//     ..registerFactory(() => UploadAvatar(serviceLocater()))
//     // Cubit
//     ..registerLazySingleton(() => ProfileCubit(
//         getProfile: serviceLocater(),
//         updateProfile: serviceLocater(),
//         uploadAvatar: serviceLocater(),
//       ),
//     );
// }
// void _initSocialProfile() {
//   // ✅ Opened in main.dart before calling initDependencies
//   final socialProfileBox = Hive.box<String>('socialProfileBox');
//
//   serviceLocater
//     ..registerLazySingleton<Box<String>>(() => socialProfileBox)
//   // Data source
//     ..registerFactory<SocialProfileRemoteDataSource>(
//             () => SocialProfileRemoteDataSourceImpl(serviceLocater()))
//   // Repository
//     ..registerFactory<SocialProfileRepository>(() => SocialProfileRepositoryImpl(
//       remote: serviceLocater<SocialProfileRemoteDataSource>(),
//       cacheBox: serviceLocater<Box<String>>(),
//     ))
//   // Use case
//     ..registerFactory(() => GetSocialProfile(serviceLocater()))
//   // Bloc
//     ..registerLazySingleton(() => SocialProfileBloc(
//       getSocialProfile: serviceLocater(),
//     ));
// }
//
part of 'init_dependencies_main.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initStory();
  _initNavigation();
  _initProfile();
  _initSocialProfile();
  _initFeed(); // 👈 Added feed setup

  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );

  serviceLocater.registerLazySingleton(() => supabase.client);
  serviceLocater.registerLazySingleton(() => AuthUserCubit());
  //serviceLocater.registerLazySingleton(() => Hive.box(name : 'blogs'));
  serviceLocater.registerLazySingleton(() => Logout(serviceLocater<AuthRepository>()));
  serviceLocater.registerLazySingleton(() => InternetConnection());
  serviceLocater.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocater()));

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
  serviceLocater
    ..registerFactory<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(serviceLocater()))
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocater(), serviceLocater()))
    ..registerFactory(() => UserSignUp(authRepository: serviceLocater()))
    ..registerFactory(() => UserLogin(authRepository: serviceLocater()))
    ..registerFactory(() => CurrentUser(serviceLocater()))
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
    ..registerFactory<StoryRemoteDataSource>(() => StoryRemoteDataSourceImpl(serviceLocater()))
    ..registerFactory<StoryRepository>(() => StoryRepositoryImpl(serviceLocater()))
    ..registerFactory(() => GetStoriesUseCase(serviceLocater()))
    ..registerFactory(() => UploadStoryUseCase(serviceLocater()))
    ..registerFactory(() => MarkStoryViewed(serviceLocater()))
    ..registerFactory(() => DeleteExpiredStories(repository: serviceLocater()))
    ..registerFactory(() => DeleteStory(repository: serviceLocater()));
}

void _initNavigation() {
  serviceLocater.registerLazySingleton(() => BottomNavCubit());
}

void _initProfile() {
  final profileBox = Hive.box<ProfileModel>('profileBox');
  serviceLocater
    ..registerLazySingleton<Box<ProfileModel>>(() => profileBox)
    ..registerFactory<ProfileRemoteDataSource>(() => ProfileRemoteDataSource(serviceLocater()))
    ..registerFactory<ProfileLocalDataSource>(() => ProfileLocalDataSource(serviceLocater()))
    ..registerFactory<ProfileRepository>(() => ProfileRepositoryImpl(remote: serviceLocater(), local: serviceLocater()))
    ..registerFactory(() => GetProfile(serviceLocater()))
    ..registerFactory(() => UpdateProfile(serviceLocater()))
    ..registerFactory(() => UploadAvatar(serviceLocater()))
    ..registerLazySingleton(
          () => ProfileCubit(
        getProfile: serviceLocater(),
        updateProfile: serviceLocater(),
        uploadAvatar: serviceLocater(),
      ),
    );
}

void _initSocialProfile() {
  final socialProfileBox = Hive.box<String>('socialProfileBox');

  serviceLocater
    ..registerLazySingleton<Box<String>>(() => socialProfileBox)
    ..registerFactory<SocialProfileRemoteDataSource>(() => SocialProfileRemoteDataSourceImpl(serviceLocater()))
    ..registerFactory<SocialProfileRepository>(() => SocialProfileRepositoryImpl(
      remote: serviceLocater<SocialProfileRemoteDataSource>(),
      cacheBox: serviceLocater<Box<String>>(),
    ))
    ..registerFactory(() => GetSocialProfile(serviceLocater()))
    ..registerLazySingleton(() => SocialProfileBloc(getSocialProfile: serviceLocater()));
}

void _initFeed() {
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PostModelAdapter());
  }

  final feedBox = Hive.box<PostModel>('feedBox'); // open in main.dart before initDependencies
  serviceLocater.registerLazySingleton<Box<PostModel>>(() => feedBox);

  serviceLocater
    ..registerLazySingleton<PostRemoteDataSource>(
            () => PostRemoteDataSourceImpl(serviceLocater()))
    ..registerLazySingleton<PostLocalDataSource>(
            () => PostLocalDataSourceImpl(serviceLocater()))
    ..registerLazySingleton<PostRepository>(
            () => PostRepositoryImpl(remote: serviceLocater(), local: serviceLocater()))
    ..registerLazySingleton(() => GetFeed(serviceLocater()))
    ..registerLazySingleton(() => LikePost(serviceLocater()))
    ..registerLazySingleton(() => UnlikePost(serviceLocater()))
    ..registerLazySingleton(() => AddComment(serviceLocater()))
    ..registerLazySingleton(() => SavePost(serviceLocater()))
    ..registerLazySingleton(() => UnsavePost(serviceLocater()))
    ..registerFactory(
          () => FeedBloc(
        getFeed: serviceLocater(),
        likePost: serviceLocater(),
        unlikePost: serviceLocater(),
        savePost: serviceLocater(),
        unsavePost: serviceLocater(),
        addComment: serviceLocater(),
        repository: serviceLocater<PostRepository>(),
      ),
    );
}


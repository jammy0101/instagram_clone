//
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../../core/errors/exception.dart';
// import '../models/user_model.dart';
//
// abstract interface class AuthRemoteDataSource {
//   Session? get currentUserSession;
//
//   Future<UserModel?> getCurrentUserData();
//
//   Future<UserModel> signUpWithEmailPassword({
//     required String fullName,
//     required String userName,
//     required String email,
//     required String password,
//   });
//
//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   });
//
//   Future<void> logout();
// }
//
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final SupabaseClient supabaseClient;
//   AuthRemoteDataSourceImpl(this.supabaseClient);
//
//   @override
//   Session? get currentUserSession => supabaseClient.auth.currentSession;
//
//   @override
//   Future<UserModel?> getCurrentUserData() async {
//     try {
//       if (currentUserSession != null) {
//         final userData = await supabaseClient
//             .from('profiles')
//             .select()
//             .eq('id', currentUserSession!.user.id)
//             .maybeSingle();
//
//         if (userData == null) return null;
//         return UserModel.fromJson(userData);
//       }
//       return null;
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
//
//   @override
//   Future<UserModel> loginWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//
//       if (response.user == null) {
//         throw ServerException('User is null!');
//       }
//
//       final userData = await supabaseClient
//           .from('profiles')
//           .select()
//           .eq('id', response.user!.id)
//           .maybeSingle();
//
//       return UserModel.fromJson(userData ?? response.user!.toJson());
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
//
//   @override
//   Future<UserModel> signUpWithEmailPassword({
//     required String fullName,
//     required String userName,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signUp(
//         email: email,
//         password: password,
//       );
//
//       if (response.user == null) {
//         throw ServerException('User is null');
//       }
//
//       // insert into profiles table
//       final profileData = {
//         'id': response.user!.id,
//         'email': email,
//         'fullName': fullName,
//         'userName': userName,
//         'bio': '',
//         'phone': '',
//         'address': '',
//         'age': null,
//         'gender': '',
//       };
//       // final profileData = {
//       //   'id': response.user!.id,
//       //   'email': email,
//       //   'fullName': fullName,
//       //   'userName': userName,
//       //
//       // };
//
//       await supabaseClient.from('profiles').upsert(profileData);
//
//       return UserModel.fromJson(profileData);
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
//
//   @override
//   Future<void> logout() async {
//     try {
//       await supabaseClient.auth.signOut();
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exception.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel?> getCurrentUserData();

  Future<UserModel> signUpWithEmailPassword({
    required String fullName,
    required String userName,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id)
            .maybeSingle();

        if (userData == null) return null;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('User is null!');
      }

      final userData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      return UserModel.fromJson(userData ?? response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String fullName,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException('User is null');
      }

      // ✅ snake_case keys for DB
      final profileData = {
        'id': response.user!.id,
        'email': email,
        'full_name': fullName,
        'user_name': userName,
        'bio': '',
        'phone': '',
        'address': '',
        'age': null,
        'gender': '',
      };

      await supabaseClient.from('profiles').upsert(profileData);

      return UserModel.fromJson(profileData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

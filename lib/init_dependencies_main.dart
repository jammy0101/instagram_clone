import 'package:horizon/core/secrets/app_secret.dart';
import 'package:horizon/features/stories/domain/usecase/delet_expired_stories.dart';
import 'package:horizon/features/stories/domain/usecase/mark_viewed.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/common/cubit/auth_user_cubit.dart';
import 'core/common/storage_service.dart';
import 'core/network/connection_checker.dart';
import 'features/authh/data/data_source/auth_remote_data_source.dart';
import 'features/authh/data/repositories/auth_repository_impl.dart';
import 'features/authh/domain/repository/auth_repository.dart';
import 'features/authh/domain/usecases/current_user.dart';
import 'features/authh/domain/usecases/logout.dart';
import 'features/authh/domain/usecases/user_login.dart';
import 'features/authh/domain/usecases/user_sign_up.dart';
import 'features/authh/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/stories/data/datasource/story_remote_data_source.dart';
import 'features/stories/data/story_repository_impl/story_repository_impl.dart';
import 'features/stories/domain/repository/story_repository.dart';
import 'features/stories/domain/usecase/get_stories_usecase.dart';
import 'features/stories/domain/usecase/upload_story_usecase.dart';
import 'features/stories/presentation/cubit/story_cubit.dart';


part 'init_dependencies.dart';
import 'package:hive/hive.dart';
import '../models/profile_model.dart';

class ProfileLocalDataSource {
  final Box<ProfileModel> box;

  ProfileLocalDataSource(this.box);

  Future<void> cacheProfile(ProfileModel model) async {
    await box.put(model.id, model);
  }

  ProfileModel? getCachedProfile(String id) {
    return box.get(id);
  }
}

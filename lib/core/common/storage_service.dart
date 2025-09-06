//
// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class StorageService {
//   final SupabaseClient client;
//   StorageService(this.client);
//
//   Future<String> uploadStoryFile(File file, String userId) async {
//     final fileName =
//         '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
//     final filePath = '$userId/$fileName';
//
//     final uploaded = await client.storage.from('stories').upload(
//       filePath,
//       file,
//       fileOptions: const FileOptions(upsert: true),
//     );
//
//     if (uploaded == null) {
//       throw Exception('Upload failed');
//     }
//
//     // Public bucket → returns String URL
//     return client.storage.from('stories').getPublicUrl(filePath);
//   }
// }
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient client;

  StorageService(this.client);

  Future<String> uploadStoryFile(File file, String userId) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final filePath = '$userId/$fileName';

    // Upload file
    await client.storage.from('stories').upload(
      filePath,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    // Get public URL
    final publicUrl = client.storage.from('stories').getPublicUrl(filePath);
    return publicUrl;
  }
}

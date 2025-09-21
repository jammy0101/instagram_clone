
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final String currentUserId;
  final ScrollController scrollController;

  const CommentSection({
    Key? key,
    required this.postId,
    required this.currentUserId,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }


  // Future<void> _fetchComments() async {
  //   try {
  //     final response = await supabase
  //         .from('comments')
  //         .select()
  //         .eq('post_id', widget.postId)
  //         .order('created_at', ascending: true);
  //     print("Fetched comments for post ${widget.postId}: $_comments");
  //     print("Fetched comments for post ${widget.postId}: $response"); // 👈 log
  //
  //     setState(() {
  //       _comments = List<Map<String, dynamic>>.from(response);
  //     });
  //   } catch (e) {
  //     print("Error fetching comments: $e");
  //   }
  // }
  Future<void> _fetchComments() async {
    try {
      final response = await supabase
          .from('comments')
          .select('*, profiles(user_name, avatar_url)') // 👈 use correct column name
          .eq('post_id', widget.postId)
          .order('created_at', ascending: true);

      print("Fetched comments with profiles: $response"); // 👈 check output

      setState(() {
        _comments = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  List<Map<String, dynamic>> _buildTree(String? parentId) {
    return _comments.where((c) {
      final dbParentId = c['parent_id'];
      if (parentId == null) {
        return dbParentId == null; // top-level comments
      }
      return dbParentId == parentId; // replies
    }).toList();
  }



  // Future<void> _addComment(String text) async {
  //   if (text.trim().isEmpty) return;
  //
  //   final response = await supabase.from('comments').insert({
  //     'post_id': widget.postId,
  //     'user_id': widget.currentUserId,
  //     'content': text.trim(),
  //     'username': supabase.auth.currentUser?.userMetadata?['username'] ?? 'User',
  //     'avatar_url': supabase.auth.currentUser?.userMetadata?['avatar_url'],
  //   });
  //
  //   if (response.error != null) {
  //     print("Error adding comment: ${response.error!.message}");
  //   } else {
  //     print("✅ Comment added!");
  //     // Optional: clear input field
  //     _controller.clear();
  //   }
  // }
  Future<void> _addComment(String text, {String? parentId}) async {
    if (text.trim().isEmpty) return;

    try {
      // ✅ Insert new comment
      await supabase.from('comments').insert({
        'id' : Uuid().v4(),
        'post_id': widget.postId,
        'user_id': widget.currentUserId,
        'content': text.trim(),
        'parent_id': parentId, // 👈 store parent if it's a reply
        'username': supabase.auth.currentUser?.userMetadata?['username'] ?? 'User',
        'avatar_url': supabase.auth.currentUser?.userMetadata?['avatar_url'],
      });

      // ✅ Increment comment count in posts table (only for top-level comments)
      if (parentId == null) {
        await supabase.rpc(
          'increment_comment_count',
          params: {'postid': widget.postId}, // must match your SQL function param
        );
      }

      print("✅ Comment added (parent: $parentId)");

      _controller.clear();

      // 👇 Refresh UI with latest comments
      await _fetchComments();
    } catch (e) {
      print("Error adding comment: $e");
    }
  }



  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return "${diff.inDays}d";
  }



  // Widget _buildComment(Map<String, dynamic> comment, {int level = 0}) {
  //   // Get replies for this comment
  //   final replies = _buildTree(comment['id']);
  //
  //   // Parse created_at timestamp safely
  //   final createdAt = comment['created_at'] != null
  //       ? DateTime.tryParse(comment['created_at'])
  //       : null;
  //
  //   return Padding(
  //     padding: EdgeInsets.only(left: level * 20.0, top: 8, bottom: 8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         ListTile(
  //           leading: CircleAvatar(
  //             backgroundImage: comment['profiles']?['avatar_url'] != null
  //                 ? NetworkImage(comment['profiles']['avatar_url'])
  //                 : null,
  //             child: comment['profiles']?['avatar_url'] == null
  //                 ? Text(
  //               (comment['profiles']?['user_name'] ?? 'U')[0].toUpperCase(),
  //             )
  //                 : null,
  //           ),
  //           title: Text(comment['profiles']?['user_name'] ?? "Unknown"),
  //           subtitle: Text(comment['content'] ?? ''),
  //           trailing: createdAt != null
  //               ? Text(
  //             _timeAgo(createdAt),
  //             style: const TextStyle(fontSize: 12, color: Colors.grey),
  //           )
  //               : null,
  //         ),
  //
  //
  //         // Reply button
  //         Padding(
  //           padding: const EdgeInsets.only(left: 72.0), // indent under avatar
  //           child: TextButton(
  //             onPressed: () async {
  //               final replyController = TextEditingController();
  //               await showDialog(
  //                 context: context,
  //                 builder: (_) => AlertDialog(
  //                   title: const Text("Reply"),
  //                   content: TextField(
  //                     controller: replyController,
  //                     decoration: const InputDecoration(
  //                       hintText: "Write a reply...",
  //                     ),
  //                   ),
  //                   actions: [
  //                     TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Text("Cancel"),
  //                     ),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         if (replyController.text.trim().isNotEmpty) {
  //                           _addComment(
  //                             replyController.text.trim(),
  //                             parentId: comment['id'], // ✅ link reply to parent
  //                           );
  //                         }
  //                         Navigator.pop(context);
  //                       },
  //                       child: const Text("Reply"),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //             child: const Text(
  //               "Reply",
  //               style: TextStyle(fontSize: 12),
  //             ),
  //           ),
  //         ),
  //
  //         // Recursive replies
  //         for (var reply in replies) _buildComment(reply, level: level + 1),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildComment(Map<String, dynamic> comment, {int level = 0}) {
    final replies = _buildTree(comment['id']);
    final createdAt = comment['created_at'] != null
        ? DateTime.tryParse(comment['created_at'])
        : null;

    final isMyComment = comment['user_id'] == widget.currentUserId;

    return Padding(
      padding: EdgeInsets.only(left: level * 20.0, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: comment['profiles']?['avatar_url'] != null
                  ? NetworkImage(comment['profiles']['avatar_url'])
                  : null,
              child: comment['profiles']?['avatar_url'] == null
                  ? Text(
                (comment['profiles']?['user_name'] ?? 'U')[0].toUpperCase(),
              )
                  : null,
            ),
            title: Text(comment['profiles']?['user_name'] ?? "Unknown"),
            subtitle: Text(comment['content'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (createdAt != null)
                  Text(
                    _timeAgo(createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                if (isMyComment)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final editController =
                        TextEditingController(text: comment['content']);
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Edit Comment"),
                            content: TextField(
                              controller: editController,
                              decoration: const InputDecoration(
                                hintText: "Update your comment",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final newText = editController.text.trim();
                                  if (newText.isNotEmpty) {
                                    await supabase
                                        .from('comments')
                                        .update({'content': newText})
                                        .eq('id', comment['id']);
                                    await _fetchComments();
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Comment"),
                            content: const Text(
                              "Are you sure you want to delete this comment?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await supabase
                              .from('comments')
                              .delete()
                              .eq('id', comment['id']);
                          await _fetchComments();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Reply button
          Padding(
            padding: const EdgeInsets.only(left: 72.0),
            child: TextButton(
              onPressed: () async {
                final replyController = TextEditingController();
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Reply"),
                    content: TextField(
                      controller: replyController,
                      decoration: const InputDecoration(
                        hintText: "Write a reply...",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (replyController.text.trim().isNotEmpty) {
                            _addComment(
                              replyController.text.trim(),
                              parentId: comment['id'],
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: const Text("Reply"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Reply", style: TextStyle(fontSize: 12)),
            ),
          ),

          // Recursive replies
          for (var reply in replies) _buildComment(reply, level: level + 1),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    final topLevelComments = _buildTree(null);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: topLevelComments.length,
            itemBuilder: (context, index) {
              return _buildComment(topLevelComments[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Add a comment...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _addComment(_controller.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

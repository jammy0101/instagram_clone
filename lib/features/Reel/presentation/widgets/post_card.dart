// lib/features/feed/presentation/widgets/post_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaUrl = post.mediaUrls.isNotEmpty ? post.mediaUrls.first : null;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.userAvatarUrl != null ? NetworkImage(post.userAvatarUrl!) : null,
              child: post.userAvatarUrl == null ? Icon(Icons.person) : null,
            ),
            title: Text(post.username ?? 'Unknown'),
            subtitle: Text(
              _formatTime(post.createdAt),
              style: TextStyle(fontSize: 12),
            ),
            trailing: Icon(Icons.more_vert),
          ),

          // media
          if (mediaUrl != null)
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: mediaUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => Center(child: Icon(Icons.broken_image)),
              ),
            ),

          // actions row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, color: post.isLiked ? Colors.red : null),
                  onPressed: onLike,
                ),
                IconButton(icon: Icon(Icons.comment_outlined), onPressed: onComment),
                IconButton(icon: Icon(Icons.send_outlined), onPressed: onShare),
                Spacer(),
                IconButton(icon: Icon(post.isSaved ? Icons.bookmark : Icons.bookmark_border), onPressed: onSave),
              ],
            ),
          ),

          // likes count and caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('${post.likesCount} likes', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          if (post.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Text(post.caption),
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

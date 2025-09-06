// import 'package:flutter/material.dart';
// import '../../domain/entities/story_entities.dart';
//
// class StoryViewerPage extends StatelessWidget {
//   final Story story;
//
//   const StoryViewerPage({super.key, required this.story});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//       ),
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () => Navigator.pop(context), // close on tap
//         child: Center(
//           child: Image.network(story.imageUrl),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/story_entities.dart';

class StoryViewerPage extends StatefulWidget {
  final Story story;
  const StoryViewerPage({super.key, required this.story});

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  @override
  void initState() {
    super.initState();
    // Auto-close after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context), // also close on tap
        child: Center(
          child: Image.network(widget.story.imageUrl),
        ),
      ),
    );
  }
}

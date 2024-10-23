import 'package:flutter/material.dart';
import 'package:evika/data/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  const EventCard({
    super.key,
    required this.event,
    this.onLikeTap,
    this.onCommentTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _topBar(),
          Image.network(event.imageUrls[0]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Divider(),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(event.imageUrls[0]),
              backgroundColor: Colors.grey,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Arneo Paris", style: TextStyle(fontSize: 16)),
                Text(event.title, style: TextStyle(fontSize: 16)),
                Text("${event.user.firstName} ${event.user.lastName}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
        Icon(Icons.bookmark_border_sharp)
      ]),
    );
  }

  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onLikeTap,
            label: Text("69 Like"),
            icon: Icon(Icons.thumb_up),
          ),
          TextButton.icon(
            onPressed: onCommentTap,
            label: Text("69 Comment"),
            icon: Icon(Icons.comment_sharp),
          ),
          TextButton.icon(
            onPressed: onShareTap,
            label: Text("Share"),
            icon: Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}

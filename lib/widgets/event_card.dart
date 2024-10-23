import 'package:flutter/material.dart';
import 'package:evika/data/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  const EventCard({
    super.key,
    required this.event,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _topBar(),
          event.imageUrls.isEmpty
              ? SizedBox(
                  height: 250,
                  child: Icon(Icons.image_not_supported_outlined, size: 100),
                )
              : Image.network(
                  event.imageUrls[0],
                  errorBuilder: (context, error, stackTrace) => SizedBox(
                    height: 250,
                    child: Icon(Icons.image_not_supported_outlined, size: 100),
                  ),
                ),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundImage:
            event.imageUrls.isEmpty ? null : NetworkImage(event.imageUrls[0]),
        backgroundColor: Colors.grey,
      ),
      title: Text(event.title, maxLines: 1),
      subtitle: Text("${event.user.firstName} ${event.user.lastName}"),
      trailing: PopupMenuButton(
          onSelected: (value) => onSaveTap?.call(),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'saved',
                child: ListTile(
                  title: Text(event.isSaved ? 'Saved' : 'Save'),
                  leading: Icon(
                      event.isSaved ? Icons.bookmark_outlined : Icons.bookmark_border),
                ),
              ),
            ];
          },
          icon: Icon(Icons.more_horiz)),
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
            label: Text("${event.likedUsersId.length + (event.isLiked ? 1 : 0)} Like"),
            icon: Icon(event.isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined),
          ),
          TextButton.icon(
            onPressed: onCommentTap,
            label: Text(
                "${event.comments.length + (event.myComment.isNotEmpty ? 1 : 0)} Comment"),
            icon: Icon(Icons.comment_sharp),
          ),
          TextButton.icon(
            onPressed: onSaveTap,
            label: Text("Share"),
            icon: Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}

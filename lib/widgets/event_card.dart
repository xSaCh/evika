import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:evika/data/constants.dart';
import 'package:evika/data/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback? onLikeTap;
  final void Function(String value)? onCommentTap;
  final VoidCallback? onSaveTap;
  const EventCard({
    super.key,
    required this.event,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
  });
  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isDescOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _topBar(),
          _imageBar(),
          GestureDetector(
            onTap: () => setState(() => isDescOpen = !isDescOpen),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(widget.event.description,
                  softWrap: true,
                  maxLines: isDescOpen ? null : 2,
                  overflow: isDescOpen ? null : TextOverflow.ellipsis),
            ),
          ),
          Divider(),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _topBar() {
    Event event = widget.event;

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
          onSelected: (value) => widget.onSaveTap?.call(),
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

  Widget _imageBar() {
    Event event = widget.event;

    // is event date between eventStartAt and eventEndAt
    bool isEventLive = DateTime.now().isAfter(event.eventStartAt) &&
        DateTime.now().isBefore(event.eventEndAt);

    return Stack(
      children: [
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
        if (isEventLive)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 15, color: Colors.red),
                      SizedBox(width: 4),
                      Text("Live", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )),
          )
      ],
    );
  }

  Widget _bottomBar() {
    Event event = widget.event;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: widget.onLikeTap,
            label: Text(
              "${event.likedUsersId.length + (event.isLiked ? 1 : 0)} Like",
              style: TextStyle(color: event.isLiked ? mainColor : greyTextColor),
            ),
            icon: SvgPicture.asset('assets/like.svg',
                colorFilter:
                    event.isLiked ? ColorFilter.mode(mainColor, BlendMode.srcIn) : null),
          ),
          TextButton.icon(
            // onPressed: widget.onCommentTap,
            onPressed: _handleComment,
            label: Text(
              "${event.comments.length + (event.myComment.isNotEmpty ? 1 : 0)} Comment",
              style: TextStyle(
                  color: event.myComment.isNotEmpty ? mainColor : greyTextColor),
            ),
            icon: SvgPicture.asset('assets/comment.svg',
                colorFilter: event.myComment.isNotEmpty
                    ? ColorFilter.mode(mainColor, BlendMode.srcIn)
                    : null),
          ),
          TextButton.icon(
            onPressed: () {},
            label: Text("Share", style: TextStyle(color: greyTextColor)),
            icon: SvgPicture.asset('assets/share.svg'),
          ),
        ],
      ),
    );
  }

  void _handleComment() {
    final cnt = TextEditingController(text: widget.event.myComment);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(hintText: "Comment"),
                        controller: cnt),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.onCommentTap?.call(cnt.text);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.send)),
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.event.comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(widget.event.comments[index]));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

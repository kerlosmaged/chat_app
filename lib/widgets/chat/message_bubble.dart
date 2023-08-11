import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isMe,
    required this.userImage,
  });
  final String message;
  final String userName;
  final bool isMe;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                  bottomRight: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                ),
              ),
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .headlineSmall!
                                    .color),
                      ),
                      Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .primaryTextTheme
                                    .bodyLarge!
                                    .color),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? 120 : null,
          right: !isMe ? 120 : null,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}

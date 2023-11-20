import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isCurrentUser;

  ChatMessageBubble({
    required this.text,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Color.fromARGB(193, 245, 34, 2)
              : Color.fromARGB(178, 216, 215, 215),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isCurrentUser
                    ? Colors.white
                    : Color.fromARGB(239, 57, 57, 57),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

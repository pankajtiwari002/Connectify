import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import '../screens/shimmer_screen.dart';
import 'comment_card.dart';
import 'replyCard.dart';
// import 'reply_card.dart';

class CommentAndReply extends StatelessWidget {
  final String text;
  final String uid;
  final List<dynamic> likes;
  final String commentId;
  final date;
  final Function(String newValue, String id) changeState;
  final List replies;
  const CommentAndReply(
      {super.key,
      required this.text,
      required this.date,
      required this.uid,
      required this.likes,
      required this.commentId,
      required this.changeState,
      required this.replies});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommentCard(
          date: date,
          text: text,
          uid: uid,
          likes: likes,
          commentId: commentId,
          changeState: changeState,
        ),
        Column(
            mainAxisSize: MainAxisSize.min,
            children: replies.map((id) => ReplyCard(commentId: id)).toList()),
        const Divider(),
      ],
    );
  }
}

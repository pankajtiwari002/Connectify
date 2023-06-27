import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class CommentCard extends StatefulWidget {
  final String username;
  final String photoUrl;
  final String text;
  final date; 
  const CommentCard({super.key,required this.username,required this.photoUrl,required this.text,required this.date});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                widget.photoUrl),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.username,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ':  ${widget.text}',
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(DateFormat.yMMMd()
                        .format(widget.date.toDate()),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                  )
                ],
              ),
            ),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: Colors.red,))
        ],
      ),
    );
  }
}

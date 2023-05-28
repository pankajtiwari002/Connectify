import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('comment screen'),
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, 
        icon: Icon(Icons.arrow_back_ios)),
      ),
      body: StreamBuilder(
          stream: firestore
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot< Map<String,dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              log(10);
              return const Center(child: CircularProgressIndicator(color: Colors.blueAccent),);
            }
            final snap = snapshot.data!.docs;
            log(snap.length);
            return ListView.builder(
              itemCount: snap.length,
              itemBuilder: (context, index) => CommentCard(
                username: snap[index]['name'],
                photoUrl: snap[index]['profilePic'],
                date: snap[index]['datePublished'],
                text: snap[index]['text'],
              ),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment as ${user.username}',
                    border: InputBorder.none,
                  ),
                ),
              )),
              IconButton(
                onPressed: () async {
                  await firestoreMethods.postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);
                      setState(() {
                        _commentController.text = "";
                      });
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widget/commentAndReply.dart';
import '../widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  String? commentId;
  FocusNode focusNode = new FocusNode();

  ValueNotifier<String> hintText = ValueNotifier('Add a Comment');
  void changeState(String newValue, String id) {
    hintText.value = newValue;
    commentId = id;
    focusNode.requestFocus();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('comment screen'),
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: StreamBuilder(
          // stream: firestore
          //     .collection('posts')
          //     .doc(widget.snap['postId'])
          //     .collection('comments')
          //     .snapshots(),
          stream: firestore
              .collection('comments')
              .where("postId", isEqualTo: widget.snap['postId'])
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              log(10);
              return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              );
            }
            final snap = snapshot.data!.docs;
            log(snap.length);
            return ListView.builder(
                itemCount: snap.length,
                itemBuilder: (context, index) {
                  if (snap[index].data()['replyId'] == null) {
                    print(snap[index]['replies']);
                    return CommentAndReply(
                      date: snap[index]['datePublished'],
                      text: snap[index]['text'],
                      uid: snap[index]['uid'],
                      likes: snap[index]['likes'],
                      commentId: snap[index].id,
                      replies: snap[index]['replies'],
                      changeState: changeState,
                    );
                  } else {
                    return SizedBox();
                  }
                });
          }),
      bottomNavigationBar: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: hintText,
          builder: (context, value, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hintText.value != 'Add a Comment')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.only(bottom: 4, left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 46, 45, 45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reply',
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                            onPressed: () {
                              hintText.value = 'Add a Comment';
                              commentId = null;
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                Container(
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
                            hintText: hintText.value,
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                      IconButton(
                        onPressed: () async {
                          if (commentId == null) {
                            await firestoreMethods.postComment(
                                widget.snap['postId'],
                                _commentController.text,
                                user.uid);
                          } else {
                            await firestoreMethods.postReply(
                                widget.snap['postId'],
                                _commentController.text,
                                user.uid,
                                commentId!);
                            hintText.value = 'Add a Comment';
                            commentId = null;
                          }
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
              ],
            );
          },
        ),
      ),
    );
  }
}

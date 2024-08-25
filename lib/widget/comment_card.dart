import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';

class CommentCard extends StatefulWidget {
  final String text;
  final String uid;
  final List<dynamic> likes;
  final String commentId;
  final date;
  final Function(String newValue, String id) changeState;
  const CommentCard(
      {super.key,
      required this.text,
      required this.date,
      required this.uid,
      required this.likes,
      required this.commentId,
      required this.changeState});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  String username = "";
  String photoUrl = "";
  bool isLoading = false;

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });
    final User user = await firestoreMethods.getUserDetailsUsingUid(widget.uid);
    username = user.username;
    photoUrl = user.photoUrl;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: 50,
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 18,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width - 90,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 34, 33, 33),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.text}',
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat.yMMMd().format(widget.date.toDate()),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0),
                            ),
                            onPressed: () {
                              widget.changeState(
                                  'Reply to ${username}', widget.commentId);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ReplyScreen(
                              //           snap: snapshot,
                              //           docRef: docRef,
                              //         )));
                            },
                            icon: Icon(Icons.reply),
                            label: Text('Reply',
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            try {
                              final res =
                                  await firestoreMethods.handleLikeOnComment(
                                      widget.commentId,
                                      firebaseAuth.currentUser!.uid,
                                      widget.likes);
                              if (res) {
                                widget.likes.add(firebaseAuth.currentUser!.uid);
                              } else {
                                widget.likes
                                    .remove(firebaseAuth.currentUser!.uid);
                              }
                              setState(() {});
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          icon: widget.likes
                                  .contains(firebaseAuth.currentUser!.uid)
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border_sharp,
                                  color: Colors.white,
                                ))
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

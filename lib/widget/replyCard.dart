import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:intl/intl.dart';

class ReplyCard extends StatefulWidget {
  final String commentId;
  const ReplyCard({super.key, required this.commentId});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  bool isLoading = false;
  Map<String, dynamic>? commentData;
  String username = "";
  String profilePic = "";
  String uid = "";

  Future<void> getCommentData() async {
    try {
      print("reply Card");
      setState(() {
        isLoading = true;
      });
      final res =
          await firestore.collection('comments').doc(widget.commentId).get();
      final data = res.data();
      commentData = data;
      print(commentData);
      final user =
          await firestoreMethods.getUserDetailsUsingUid(commentData!['uid']);
      username = user.username;
      profilePic = user.photoUrl;
      uid = user.uid;
      setState(() {
        isLoading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    getCommentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16)
                .copyWith(left: 70),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                  radius: 18,
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width - 144,
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
                            '${commentData!['text']}',
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat.yMMMd().format(
                                  commentData!['datePublished'].toDate()),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
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
                                      commentData!['likes']);
                              if (res) {
                                commentData!['likes']
                                    .add(firebaseAuth.currentUser!.uid);
                              } else {
                                commentData!['likes']
                                    .remove(firebaseAuth.currentUser!.uid);
                              }
                              setState(() {});
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          icon: commentData!['likes']
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

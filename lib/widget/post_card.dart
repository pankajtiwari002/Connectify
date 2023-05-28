import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlen = 0;

  @override
  void initState() {
    // TODO: implement initState
    getComment();
    super.initState();
  }

  Future<void> getComment() async{
    QuerySnapshot snap = await firestore.collection('posts').doc(widget.snap['postId']).collection('comments').get();
    commentlen = snap.docs.length;
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // header section
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: ['delete']
                                    .map((e) => InkWell(
                                      onTap: () async{
                                        await firestoreMethods.deletePost(widget.snap['postId']);
                                        Navigator.of(context).pop();
                                      },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.more_vert,
                    )),
              ],
            ),
          ),
          // image section
          GestureDetector(
            onDoubleTap: () async{
              await firestoreMethods.likePost(widget.snap['postId'],user.uid,widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['posturl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      child: Icon(Icons.favorite, size: 120),
                      isAnimating: isLikeAnimating,
                      onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                  ),
                )
              ],
            ),
          ),
          // like comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smalllike: true,
                child: IconButton(
                    onPressed: () async{
                      await firestoreMethods.likePost(widget.snap['postId'],user.uid,widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.uid) ?Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ) : Icon(Icons.favorite_border),
                    ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CommentScreen(snap:widget.snap)));
                  },
                  icon: Icon(
                    Icons.comment,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_sharp,
                  )),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),
          //description and number of comments
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${widget.snap['username']} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: '   ${widget.snap['description']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all $commentlen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

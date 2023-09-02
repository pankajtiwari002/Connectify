import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widget/follow_button.dart';
import 'open_image.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    getData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot userSnap =
          await firestore.collection('user').doc(widget.uid).get();
      var postSnap = await firestore
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postlen = postSnap.docs.length;
      followers = (userSnap.data()! as dynamic)['follwers'].length;
      following = (userSnap.data()! as dynamic)['following'].length;
      userData = userSnap.data() as Map<String, dynamic>;
      isFollowing = (userSnap.data()! as dynamic)['follwers']
          .contains(firebaseAuth.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: userData['photoUrl'],
                            imageBuilder: ((context, imageProvider) =>
                                CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 50,
                                )),
                            placeholder: (context, url) => Container(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildStateColumn(postlen, 'posts'),
                                    buildStateColumn(followers, 'followers'),
                                    buildStateColumn(following, 'following'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    firebaseAuth.currentUser!.uid == widget.uid
                                        ? FollowButton(
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            text: 'signOut',
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await authMethod.signOut();
                                              // Navigator.of(context).pushReplacement(
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             const LoginScreen()));
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Colors.white,
                                                text: 'unfollow',
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  String uid =
                                                      await firebaseAuth
                                                          .currentUser!.uid;
                                                  await firestoreMethods
                                                      .followUser(
                                                          uid, widget.uid);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  String uid =
                                                      await firebaseAuth
                                                          .currentUser!.uid;
                                                  await firestoreMethods
                                                      .followUser(
                                                          uid, widget.uid);

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2, left: 4),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                  future: firestore
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        return Container(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OpenImage(
                                    imageUrl: snap['posturl'])));
                            },
                            child: CachedNetworkImage(
                              imageUrl: snap['posturl'],
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }
}

Column buildStateColumn(int nums, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        nums.toString(),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ),
    ],
  );
}

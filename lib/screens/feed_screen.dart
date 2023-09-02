import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/chat_screen.dart';
import 'package:instagram_clone/screens/story_post_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widget/shimmer_effect.dart';
import 'package:instagram_clone/widget/story_card.dart';
import 'package:provider/provider.dart';
import '../models/story.dart';
import '../models/user.dart';
import '../widget/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    if (!Provider.of<UserProvider>(context, listen: false).isAlreadyLoad) {
      Provider.of<UserProvider>(context, listen: false).refreshUser().then((_) {
        setState(() {
          load = false;
          Provider.of<UserProvider>(context, listen: false).changeAlreadyLoad();
        });
      });
    } else {
      setState(() {
        load = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = !load ? Provider.of<UserProvider>(context).getUser : null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
              icon: Icon(Icons.message_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        primary: true,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            load
                ? Container()
                : SingleChildScrollView(
                  child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: InkWell(
                            onTap: () async {
                              Uint8List image =
                                  await pickImage(ImageSource.gallery);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StoryPostScreen(
                                        image: image,
                                        type: 'image',
                                      )));
                            },
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: user!.photoUrl,
                                  imageBuilder: (context, imageProvider) {
                                    return CircleAvatar(
                                      backgroundImage: imageProvider,
                                      radius: 30,
                                    );
                                  },
                                  placeholder: ((context, url) => Container(
                                        height: 30,
                                        width: 30,
                                      )),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Positioned(
                                    top: 40,
                                    left: 40,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      alignment: Alignment.center,
                                      // padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(
                                            color: Colors.black, width: 3),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text('+'),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: StreamBuilder(
                            stream: firestore.collection('story').snapshots(),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      log(snapshot.data!.docs.toString());
                                      if(snapshot.data!.docs[index]['uid']==user.uid){
                                        return Container();
                                      }
                                      return StoryCard(
                                          snap: snapshot,
                                          index: index,
                                          );
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.none) {
                                return const SizedBox();
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                    'error Occur',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                ),
            StreamBuilder(
                // initialData: ,
                stream: firestore.collection('posts').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return load
                          ? const ShimmerEffect()
                          : ListView.builder(
                              // cacheExtent: ,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: (snapshot.data as dynamic).docs.length,
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return (snapshot.data as dynamic)
                                            .docs[index]
                                            .data() ==
                                        null ?
                            ShimmerEffect()
                                    : PostCard(
                                        snap: (snapshot.data as dynamic)
                                            .docs[index]
                                            .data());
                              },
                            );
                    } else {
                      return const ShimmerEffect();
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ShimmerEffect();
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return const ShimmerEffect();
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'error Occur',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const ShimmerEffect();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

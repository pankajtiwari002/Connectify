import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/screens/message_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widget/previous_chats.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isShowUser = false;
  bool? exist;
   Future<bool> checkExist(String docID,String uid) async {       
    try {
        await firestore.collection('user').doc(uid).collection('chats').doc(docID).get().then((doc){
          exist = doc.exists;
        });
        return exist!;
    } catch (e) {
        // If any error
        return false;
    }
}
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 34, 33, 33)),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none),
              onFieldSubmitted: (_) {
                setState(() {
                  isShowUser = true;
                });
              },
            ),
          ),
          isShowUser
              ? FutureBuilder(
                  future: firestore
                      .collection('user')
                      .where('username',
                          isGreaterThanOrEqualTo: searchController.text)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final snap = snapshot.data!.docs;
                              return ListTile(
                                onTap: () async{
                                  bool e = await checkExist(snap[index]['uid'], user.uid);
                                  log(5);
                                  if(!e){
                                    await firestoreMethods.createChat(user,snap[index]);
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MessageScreen(
                                          uid: snap[index]['uid'])));
                                },
                                leading: CachedNetworkImage(
                                  imageUrl: snap[index]['photoUrl'],
                                  imageBuilder: ((context, imageProvider) =>
                                      CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 16,
                                      )),
                                  placeholder: (context, url) => Container(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  snap[index]['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error occurs',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Error occurs in firebase',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                )
              : FutureBuilder(
                future: firestore.collection('user').doc(user.uid).collection('chats').get(),
                builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return PreviousChat(snapshot: snapshot,);
                        // return Container();
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error occurs',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Error occurs in firebase',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
              ),
        ],
      ),
    );
  }
}

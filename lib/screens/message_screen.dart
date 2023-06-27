import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/image_sending_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../widget/message_card.dart';

class MessageScreen extends StatefulWidget {
  final String name;
  final String profileUrl;
  final String uid;
  MessageScreen(
      {super.key,
      required this.profileUrl,
      required this.name,
      required this.uid});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _chatController = TextEditingController();
  Uint8List? _file;
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    ScrollController scrollController = ScrollController();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream: firestore
                    .collection('user')
                    .doc(user.uid)
                    .collection('chats')
                    .doc(widget.uid)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: snapshot.data!['messages'].length,
                        itemBuilder: (context, index) {
                          if(index > 0){
                              return MessageCard(
                              prevdate: snapshot.data!['messages'][index-1]['date'],
                              date: snapshot.data!['messages'][index]['date'],
                              owner: snapshot.data!['messages'][index]['owner'],
                              text: snapshot.data!['messages'][index]['text'],
                              imageUrl: snapshot.data!['messages'][index]['imageUrl'],
                              senderPhotoUrl: user.photoUrl,
                              userPhotoUrl: widget.profileUrl,
                            );
                          }
                          else{
                              return MessageCard(
                              prevdate: null,
                              date: snapshot.data!['messages'][index]['date'],
                              owner: snapshot.data!['messages'][index]['owner'],
                              text: snapshot.data!['messages'][index]['text'],
                              imageUrl: snapshot.data!['messages'][index]['imageUrl'],
                              senderPhotoUrl: user.photoUrl,
                              userPhotoUrl: widget.profileUrl,
                            );
                          }
                          
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'error Occur',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Error in Firebase',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: 70,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const SizedBox(
                    width: 5,
                  ),
                  CachedNetworkImage(
                    imageUrl: widget.profileUrl,
                    imageBuilder: ((context, imageProvider) => CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 20,
                        )),
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: user.photoUrl,
                  imageBuilder: ((context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 16,
                      )),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      hintText: 'Message...',
                      border: InputBorder.none,
                    ),
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    Uint8List file = await pickImage(ImageSource.gallery);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageSendingScreen(file: file,uid: widget.uid,)));
                  },
                  icon: const Icon(
                    Icons.image_sharp,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (_chatController.text.trim() != "") {
                      await firestoreMethods.sendMessage('',
                          _chatController.text, widget.uid, user.uid);
                      setState(() {
                        _chatController.text = "";
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

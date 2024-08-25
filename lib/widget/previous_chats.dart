import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/constants.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../screens/message_screen.dart';

class PreviousChat extends StatefulWidget {
  final snapshot;
  const PreviousChat({super.key, required this.snapshot});

  @override
  State<PreviousChat> createState() => _PreviousChatState();
}

class _PreviousChatState extends State<PreviousChat> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          final snap = widget.snapshot.data!.docs;
          int messagelen = snap[index]['messages'].length;
          return ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessageScreen(
                      uid: snap[index]['uid'])));
            },
            leading: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: snap[index]['photoUrl'],
                imageBuilder: ((context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                      radius: 18,
                    )),
                placeholder: (context, url) => Container(
                  width: 10,
                  height: 10,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(snap[index]['username']),
            // subtitle: Text(snap[index][messagelen-1]),
          );
        });
  }
}

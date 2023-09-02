import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/story_page.dart';

class StoryCard extends StatelessWidget {
  final snap;
  final int index;
  StoryCard({super.key, required this.snap, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => StoryPage(
                    snapshot: snap,
                    index: index,
                  ))));
        },
        child: CachedNetworkImage(
          imageUrl: snap.data!.docs[index]['profileUrl'],
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
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

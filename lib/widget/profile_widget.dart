import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final snap;
  final index;
  ProfileWidget({required this.snap, this.index});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 54),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.snap['profileUrl'],
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 24,
                );
              },
              placeholder: ((context, url) => Container(
                    height: 48,
                    width: 48,
                  )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.snap['username'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '31 August 2023',
                    style: TextStyle(color: Colors.white38),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

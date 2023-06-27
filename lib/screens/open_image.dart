import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class OpenImage extends StatelessWidget {
  String imageUrl;
  OpenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(10),
          minScale: 0.5,
          maxScale: 2.0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Hero(
              tag: imageUrl+'search',
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context,url) => Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

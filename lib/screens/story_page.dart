import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/story_widget.dart';

class StoryPage extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final index;
  StoryPage({required this.snapshot, this.index});
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return PageView(
      controller: controller,
      children: widget.snapshot.data!.docs.map((snap) {
        // log(snap['username']);
        return StoryWidget(snapshot: snap, controller: controller,index: widget.index,last_index: widget.snapshot.data!.size-1,);
      }).toList(),
    );
  }
}

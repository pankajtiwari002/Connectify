import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/widget/profile_widget.dart';
import 'package:story_view/story_view.dart';

class StoryWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;
  final controller;
  final index;
  final last_index;
  const StoryWidget({super.key,required this.snapshot,required this.controller,required this.index,required this.last_index});

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  late StoryController storyController;
  String date = '';

  void addStoryItems() {
    for (final story in widget.snapshot['stories']) {
      switch (story['type']) {
        case 'image':
          // log(story['storyUrl']);
          storyItems.add(StoryItem.pageImage(
            url: story['storyUrl'],
            controller: storyController,
            caption: Text(""),
            duration: Duration(
              milliseconds: (5 * 1000).toInt(),
            ),
          ));
          break;
        case 'text':
          storyItems.add(
            StoryItem.text(
              title: story['text'],
              backgroundColor: story['color'],
              duration: Duration(
                milliseconds: (story.duration * 1000).toInt(),
              ),
            ),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    storyController = StoryController();
    addStoryItems();
    date = '31 August 2023';
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    final currentIndex = widget.index;
    final isLastPage = widget.index == widget.last_index;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: StoryView(
              storyItems: storyItems,
              controller: storyController,
              onComplete: handleCompleted,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
              onStoryShow: (storyItem,ind) {
                final index = storyItems.indexOf(storyItem);
                if (index > 0) {
                  setState(() {
                    date = '31 August 2023';
                  });
                }
              },
            ),
          ),
          ProfileWidget(
            snap: widget.snapshot,
            index: widget.index,
          ),
        ],
      );
  }
}
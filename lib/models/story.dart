class Story{
  final String storyId;
  final String type;
  final String storyUrl;

  Story({
    required this.type,
    required this.storyUrl,
    required this.storyId
  });

  Map<String,dynamic> toJson() => {
    'storyId': storyId,
    'type': type,
    'storyUrl': storyUrl,
    // 'date': DateTime.now()
  };
}
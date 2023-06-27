class Story{
  final String uid;
  final String username;
  final String profileUrl;
  final String type;
  final String url;

  Story({
    required this.type,
    required this.profileUrl,
    required this.uid,
    required this.url,
    required this.username
  });

  Map<String,dynamic> toJson() => {
    'uid' : uid,
    'username': username,
    'profileUrl': profileUrl,
    'type': type,
    'url': url
  };
}
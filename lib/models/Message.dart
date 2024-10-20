import 'package:instagram_clone/models/user.dart';

class Message {
  String id;
  String type;
  int dateTime;
  List<String> messageDeletedFor;
  User sender;
  List<String> readBy;
  Map<String, List<String>> reaction;

  Message(
      {required this.id,
      required this.type,
      required this.dateTime,
      required this.messageDeletedFor,
      required this.reaction,
      required this.readBy,
      required this.sender});
}

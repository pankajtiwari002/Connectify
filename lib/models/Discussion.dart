import 'package:instagram_clone/models/Message.dart';
import 'package:instagram_clone/models/user.dart';

class Discussion {
  String chatId;
  String type;
  List<Message> messages;
  List<User> userList;

  Discussion(
      {required this.chatId,
      required this.type,
      required this.messages,
      required this.userList});
}

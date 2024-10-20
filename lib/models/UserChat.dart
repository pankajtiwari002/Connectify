import 'package:instagram_clone/models/Discussion.dart';
import 'package:instagram_clone/models/Message.dart';
import 'package:instagram_clone/models/user.dart';

class Userchat extends Discussion {
  Userchat(
      String chatId, String type, List<Message> messages, List<User> userList)
      : super(
            chatId: chatId, type: type, messages: messages, userList: userList);
}

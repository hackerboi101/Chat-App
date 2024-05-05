import 'package:chat_app/models/chat_model.dart';

class ChatsModel {
  String socketId;
  String userName;
  List<ChatModel> chat;

  ChatsModel({
    required this.socketId,
    required this.userName,
    required this.chat,
  });

  ChatsModel.fromJson(Map<String, dynamic> json)
      : chat = [],
        socketId = json['socketId'],
        userName = json['userName'] {
    if (json['chat'] != null) {
      chat = <ChatModel>[];
      json['chat'].forEach((v) {
        chat.add(ChatModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['socketId'] = socketId;
    data['userName'] = userName;
    data['chat'] = chat.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'ChatsModel(socketId: $socketId, userName: $userName, chat: $chat)';
  }
}

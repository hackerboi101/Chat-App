class ChatModel {
  String id;
  String userName;
  String sentAt;
  String message;

  ChatModel({
    required this.id,
    required this.userName,
    required this.sentAt,
    required this.message,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userName: json['userName'],
      sentAt: json['sentAt'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'sentAt': sentAt,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, userName: $userName, sentAt: $sentAt, message: $message)';
  }
}

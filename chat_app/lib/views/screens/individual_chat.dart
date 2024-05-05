// ignore_for_file: avoid_print

import 'package:chat_app/models/chats_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/views/widgets/chat_bubble.dart';
import 'package:chat_app/models/chat_model.dart';

class IndividualChat extends StatelessWidget {
  final String myUserName;
  final String userName;

  IndividualChat({super.key, required this.myUserName, required this.userName});

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          String? messageId;
          for (var message in chatController.messages) {
            if (message.id != chatController.socket.id) {
              messageId = message.id;
              break;
            }
          }

          if (messageId != null) {
            chatController.chats.add(ChatsModel(
              socketId: messageId,
              userName: userName,
              chat: chatController.messages,
            ));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(userName),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: chatController.scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: chatController.messages.isEmpty ? false : true,
                    itemCount: 1,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 3),
                        child: Column(
                          mainAxisAlignment: chatController.messages.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children:
                                    chatController.messages.map((message) {
                                  print(message);
                                  return ChatBubble(
                                    date: message.sentAt,
                                    message: message.message,
                                    isMe:
                                        message.id == chatController.socket.id,
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: chatController.messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          if (chatController.messageController.text
                              .trim()
                              .isNotEmpty) {
                            String message =
                                chatController.messageController.text.trim();

                            chatController.socket.emit(
                                "message",
                                ChatModel(
                                        id: chatController.socket.id!,
                                        message: message,
                                        userName: myUserName,
                                        sentAt: DateTime.now()
                                            .toLocal()
                                            .toString()
                                            .substring(0, 16))
                                    .toJson());

                            chatController.messageController.clear();
                          }
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 5.79449,
                            child: const Icon(Icons.send, size: 20)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

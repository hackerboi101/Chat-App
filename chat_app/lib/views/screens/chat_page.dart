import 'package:chat_app/controllers/authentication_controller.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/profile_controller.dart';
import 'package:chat_app/controllers/users_controller.dart';
import 'package:chat_app/views/screens/individual_chat.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:chat_app/views/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final ProfileController profileController = Get.put(ProfileController());
  final UsersController usersController = Get.put(UsersController());
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Chat App'),
        actions: [
          IconButton(
            onPressed: () async {
              await profileController.getProfile();

              Get.to(ProfilePage());
            },
            icon: const Icon(Icons.account_circle_rounded),
          ),
          IconButton(
            onPressed: () {
              authenticationController.logout();
              Get.offAll(() => LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      dividerHeight: 0,
                      tabs: const [
                        Tab(text: 'Chats'),
                        Tab(text: 'Contacts'),
                      ],
                    ),
                  ),
                  TabBarView(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.background,
                        child: ListView.builder(
                          itemCount: chatController.chats.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(chatController.chats[index].userName),
                              onTap: () async {
                                await profileController.getProfile();

                                chatController.messages.clear();

                                chatController.messages.addAll(
                                  chatController.chats[index].chat,
                                );
                                Get.to(
                                  () => IndividualChat(
                                    myUserName: profileController
                                        .profile.value.userName,
                                    userName:
                                        chatController.chats[index].userName,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.background,
                        child: ListView.builder(
                          itemCount: usersController.users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(usersController.users[index].name),
                              subtitle: Text(
                                usersController.users[index].userName,
                              ),
                              onTap: () async {
                                await profileController.getProfile();

                                chatController.messages.clear();

                                for (var chats in chatController.chats) {
                                  if (chats.userName ==
                                      usersController.users[index].userName) {
                                    chatController.messages.addAll(chats.chat);
                                  }
                                }

                                Get.to(
                                  () => IndividualChat(
                                    myUserName: profileController
                                        .profile.value.userName,
                                    userName:
                                        usersController.users[index].userName,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

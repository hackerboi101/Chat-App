// ignore_for_file: avoid_print

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/chats_model.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatController extends GetxController {
  late Socket socket;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final RxList<ChatModel> messages = <ChatModel>[].obs;
  final RxList<ChatsModel> chats = <ChatsModel>[].obs;
  final RxBool showSpinner = false.obs;
  final RxBool showVisibleWidget = false.obs;
  final RxBool showErrorIcon = false.obs;

  @override
  void onInit() async {
    initializeSocketIO();
    await getChats();
    super.onInit();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void initializeSocketIO() {
    try {
      socket = io(
          "https://chat-app-server-ib5y.onrender.com:5000", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();

      socket.on('connect', (data) {
        debugPrint("connected");
        print(socket.connected);
      });

      socket.on('message', (data) {
        var message = ChatModel.fromJson(data);
        messages.add(message);
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });

      socket.onDisconnect((_) => debugPrint('disconnect'));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadChats(
      String socketId, String userName, List<ChatModel> chat) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;
      String username = prefs.getString('username')!;

      http.Response response = await http.post(
        Uri.parse('https://chat-app-server-ib5y.onrender.com:5000/user/chats'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode(<String, String>{
          'socketid': socketId,
          'username': username,
          'chat': json.encode(chat),
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Uploaded Chats');
      } else {
        var responseBody = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Network error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getChats() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;

      http.Response response = await http.get(
        Uri.parse('https://chat-app-server-ib5y.onrender.com:5000/user/chats'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        this.chats.clear();
        final Map<String, dynamic> data = jsonDecode(response.body);
        final ChatsModel chats = ChatsModel.fromJson(data['data']);
        this.chats.add(chats);
      } else {
        var responseBody = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Network error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

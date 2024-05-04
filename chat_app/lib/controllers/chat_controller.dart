import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/material.dart';

class ChatController extends GetxController {
  late Socket socket;

  @override
  void onInit() {
    initializeSocketIO();
    super.onInit();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void initializeSocketIO() {
    socket = io("http://192.168.0.171:5000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.on('connect', (data) {
      debugPrint("connected");
    });

    socket.on('message', (data) {
      debugPrint(data);
    });

    socket.on('disconnect', (data) {
      debugPrint("disconnected");
    });
  }
}

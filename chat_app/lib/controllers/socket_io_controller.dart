import 'package:get/get.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketIoController extends GetxController {
  void connect() {
    final socket = IO.io("http://192.168.0.104/24:5000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.emit("/test", "Hello from Dart!");
    socket.onConnect((data) => debugPrint("Connected"));
    debugPrint(socket.connected.toString());
  }
}

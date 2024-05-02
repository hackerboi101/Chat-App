import 'package:chat_app/controllers/authentication_controller.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthenticationController authenticationController = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF263238),
          primary: Color(0xFF880E4F),
          secondary: Color(0xFF388E3C),
          tertiary: Color(0xFF616161),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: authenticationController.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return ChatPage();
            } else {
              return LoginPage();
            }
          }
          return LoginPage();
        },
      ),
    );
  }
}

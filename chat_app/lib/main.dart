import 'package:chat_app/views/screens/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: SignUpPage(),
    );
  }
}

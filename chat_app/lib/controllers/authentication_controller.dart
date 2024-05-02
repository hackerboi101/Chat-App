import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool passwordIsSeen = false.obs;
  final RxBool rememberMe = false.obs;

  Future<void> login() async {
    try {
      if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Username or password cannot be empty',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      http.Response response = await http.post(
        Uri.parse('http://192.168.0.171:5000/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'username': userNameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Login Successful',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Login Failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

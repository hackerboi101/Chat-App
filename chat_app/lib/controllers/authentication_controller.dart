import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
        Uri.parse('https://chat-app-server-ib5y.onrender.com/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'username': userNameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String jwt = responseBody['data']['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', jwt);

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

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;

      http.Response response = await http.get(
        Uri.parse('https://chat-app-server-ib5y.onrender.com/user/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('jwt');

        Get.snackbar(
          'Success',
          'Logout Successful',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        var responseBody = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Logout Failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Network error: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt');
  }
}

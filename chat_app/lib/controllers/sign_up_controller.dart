import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool passwordIsSeen = false.obs;
  final RxBool confirmPasswordIsSeen = false.obs;

  Future<void> signUp() async {
    try {
      if (userNameController.text.isEmpty ||
          nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill in all fields');
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
        return;
      }

      debugPrint(
          'Username: ${userNameController.text}, name: ${nameController.text}, email: ${emailController.text}, password: ${passwordController.text}');

      http.Response response = await http.post(
        Uri.parse('https://chat-app-server-ib5y.onrender.com/user/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          'username': userNameController.text.trim(),
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        String jwt = responseBody['data']['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', jwt);

        Get.snackbar(
          'Success',
          'Sign Up Successful',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Error',
          'Password cannot be empty',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Sign Up Failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

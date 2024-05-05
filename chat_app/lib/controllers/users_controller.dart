import 'package:chat_app/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UsersController extends GetxController {
  RxList<ProfileModel> users = RxList<ProfileModel>([]);
  RxList<ProfileModel> filteredUsers = RxList<ProfileModel>([]);

  @override
  void onInit() async {
    super.onInit();
    await getUsers();
  }

  Future<void> getUsers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;

      http.Response response = await http.get(
          Uri.parse('https://chat-app-server-ib5y.onrender.com/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $jwt',
          });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<ProfileModel> users = (data['data'] as List)
            .map((user) => ProfileModel.fromJson(user))
            .toList();
        this.users.value = users;
        filteredUsers.value = users;
      } else {
        var responseBody = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          responseBody['message'] ?? 'Network error',
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

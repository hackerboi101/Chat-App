import 'dart:convert';
import 'dart:io';
import 'package:chat_app/models/profile_model.dart';
import 'package:chat_app/views/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final Rx<ProfileModel> profile = ProfileModel(
    userName: '',
    name: '',
    email: '',
  ).obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxBool isProfilePicture = false.obs;
  final Rx<File> profilePicture = Rx<File>(File(''));
  final RxString profilePictureUrl = ''.obs;

  Future<void> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;

      http.Response response = await http.get(
        Uri.parse('http://192.168.0.171:5000/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final ProfileModel profile = ProfileModel.fromJson(data['data']);

        this.profile.value = profile;
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
        'Network error: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;
      String name = nameController.text.trim();
      String email = emailController.text.trim();

      http.Response response = await http.put(
        Uri.parse('http://192.168.0.171:5000/user/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode(<String, String>{
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final ProfileModel profile = ProfileModel.fromJson(data['data']);

        this.profile.value = profile;
        Get.to(ProfilePage());
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
        'Network error: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickProfilePicture() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        isProfilePicture.value = true;
        profilePicture.value = File(image.path);
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Couldn\'t pick profile picture. ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      await pickProfilePicture();

      debugPrint('Profile Picture: ${profilePicture.value.path}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jwt = prefs.getString('jwt')!;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.0.171:5000/user/profile/picture'),
      );

      request.headers.addAll(<String, String>{
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $jwt',
      });

      var file = File(profilePicture.value.path);
      if (await file.exists()) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilepicture',
          profilePicture.value.path,
        ));
      } else {
        throw Exception('File does not exist');
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        isProfilePicture.value = true;

        final Map<String, dynamic> data =
            jsonDecode(await response.stream.bytesToString());
        profilePictureUrl.value = data['data']['profilepicture'];

        debugPrint('Profile Picture URL: ${profilePictureUrl.value}');

        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        var responseBody = await response.stream.bytesToString();
        var decodedResponse = jsonDecode(responseBody);
        Get.snackbar(
          'Error',
          decodedResponse['message'] ?? 'Network error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      debugPrint('Error: ${error.toString()}');

      Get.snackbar(
        'Error',
        'Network error: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

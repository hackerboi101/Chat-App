import 'package:chat_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Obx(
              () => Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Stack(
                    children: [
                      profileController.isProfilePicture.value
                          ? Image.network(
                              'http://192.168.0.171:5000/uploads/${profileController.profilePictureUrl.value}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : SvgPicture.asset(
                              'assets/images/svgs/profile_circle.svg',
                              width: 100,
                              height: 100,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          radius: 17.0,
                          child: IconButton(
                            onPressed: () async {
                              await profileController.updateProfilePicture();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            TextField(
              controller: profileController.nameController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            TextField(
              controller: profileController.emailController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.23),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  await profileController.updateProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

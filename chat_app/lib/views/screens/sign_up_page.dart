import 'package:chat_app/views/screens/chat_page.dart';
import 'package:chat_app/views/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/controllers/sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 40.0),
              TextField(
                controller: signUpController.userNameController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                decoration: InputDecoration(
                  hintText: 'User Name',
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
                controller: signUpController.nameController,
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
                controller: signUpController.emailController,
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
              const SizedBox(height: 25.0),
              Obx(
                () => TextField(
                  controller: signUpController.passwordController,
                  obscureText: !signUpController.passwordIsSeen.value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.passwordIsSeen.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () => signUpController.passwordIsSeen.toggle(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              Obx(
                () => TextField(
                  controller: signUpController.confirmPasswordController,
                  obscureText: !signUpController.confirmPasswordIsSeen.value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        signUpController.confirmPasswordIsSeen.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () =>
                          signUpController.confirmPasswordIsSeen.toggle(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await signUpController.signUp();
                    Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        Get.to(const ChatPage());
                      },
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () => Get.to(LoginPage()),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

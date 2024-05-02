import 'package:chat_app/controllers/authentication_controller.dart';
import 'package:chat_app/views/screens/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

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
              const SizedBox(height: 170),
              const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(97, 97, 97, 1),
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: authenticationController.userNameController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                decoration: InputDecoration(
                  hintText: 'Username',
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
              const SizedBox(height: 25),
              Obx(
                () => TextField(
                  controller: authenticationController.passwordController,
                  obscureText: !authenticationController.passwordIsSeen.value,
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
                        authenticationController.passwordIsSeen.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () =>
                          authenticationController.passwordIsSeen.toggle(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => SizedBox(
                        height: 22,
                        width: 22,
                        child: Checkbox(
                          value: authenticationController.rememberMe.value,
                          onChanged: (value) => authenticationController
                              .rememberMe.value = value!,
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Color.fromRGBO(97, 97, 97, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await authenticationController.login();
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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Color.fromRGBO(97, 97, 97, 1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => Get.to(SignUpPage()),
                    child: Text(
                      'Sign Up',
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

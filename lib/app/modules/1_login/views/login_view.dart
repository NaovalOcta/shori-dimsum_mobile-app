import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/sign_in_pattern.png'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  TextField(
                    controller: controller.loginInputClass.emailController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      floatingLabelStyle: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 17,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.email),
                      ),
                    ),
                  ),
                  Obx(
                    () => TextField(
                      controller: controller.loginInputClass.passwordController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        floatingLabelStyle: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 17,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(Icons.lock),
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            controller.loginInputClass.isPasswordViewable.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                          onTap: () => controller.loginInputClass
                              .togglePasswordViewable(),
                        ),
                      ),
                      obscureText:
                          controller.loginInputClass.isPasswordViewable.value
                          ? false
                          : true,
                      obscuringCharacter: '*',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      child: Text(
                        'Forgot Password ?',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () => null,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            controller.loginInputClass.loginAction();
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            child: Text(
                              "Sign up",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 15,
                              ),
                            ),
                            onTap: () => Get.toNamed(Routes.REGISTER),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

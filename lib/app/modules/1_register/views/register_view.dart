import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
            Image.asset('assets/sign_up_pattern1.png'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  TextField(
                    controller: controller.registerInputClass.emailController,
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
                  TextField(
                    controller:
                        controller.registerInputClass.phoneNumController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
                        child: Icon(Icons.phone),
                      ),
                    ),
                  ),
                  Obx(
                    () => TextField(
                      controller:
                          controller.registerInputClass.passwordController,
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
                            controller
                                    .registerInputClass
                                    .isPasswordViewable
                                    .value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                          onTap: () => controller.registerInputClass
                              .togglePasswordViewable(),
                        ),
                      ),
                      obscureText:
                          controller.registerInputClass.isPasswordViewable.value
                          ? false
                          : true,
                      obscuringCharacter: '*',
                    ),
                  ),
                  Obx(
                    () => TextField(
                      controller:
                          controller.registerInputClass.confPasswordController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                            controller
                                    .registerInputClass
                                    .isConfPasswordViewable
                                    .value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                          ),
                          onTap: () => controller.registerInputClass
                              .toggleConfPasswordViewable(),
                        ),
                      ),
                      obscureText:
                          controller
                              .registerInputClass
                              .isConfPasswordViewable
                              .value
                          ? false
                          : true,
                      obscuringCharacter: '*',
                    ),
                  ),
                  const SizedBox(height: 33),
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
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        controller.registerInputClass.registerAction();
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        child: Text(
                          'Sign In',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () => Get.toNamed(Routes.LOGIN),
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

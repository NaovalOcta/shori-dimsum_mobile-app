import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';
import '../controllers/start_controller.dart';

class StartView extends GetView<StartController> {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/start_bg.jpg',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter, 
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: TextButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(BorderSide.none), 
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), 
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 80, vertical: 13)),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Color.fromARGB(255, 85, 11, 24)),
                ),
                onPressed: () => Get.toNamed(Routes.LOGIN),
              ),
            ),
          ),
        ]
      ),
    );
  }
}

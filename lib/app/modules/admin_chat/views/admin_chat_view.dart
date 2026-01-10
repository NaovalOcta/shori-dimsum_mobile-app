import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/admin_chat_controller.dart';

class AdminChatView extends GetView<AdminChatController> {
  const AdminChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

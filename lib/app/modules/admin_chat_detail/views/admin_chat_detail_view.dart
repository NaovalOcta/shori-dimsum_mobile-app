import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/modules/admin_chat/controllers/admin_chat_controller.dart';

class AdminChatDetailView extends GetView<AdminChatController> {
  final String userName;
  const AdminChatDetailView({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller ditemukan
    final controller = Get.find<AdminChatController>();

    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1, // Cream
      appBar: AppBar(
        backgroundColor: Colors.white, // Header Putih agar kontras
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF3E2723)),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              backgroundImage: const AssetImage(
                'assets/products_placeholder.jpg',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: Color(0xFF3E2723),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Online",
                  style: TextStyle(
                    color: CustomColors.primaryColor, // Maroon status
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[100], height: 1.0),
        ),
      ),
      body: Column(
        children: [
          // --- AREA CHAT BUBBLES ---
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: controller.currentMessages.length,
                itemBuilder: (context, index) {
                  final msg = controller.currentMessages[index];
                  return _buildBubble(msg);
                },
              ),
            ),
          ),

          // --- AREA INPUT (Floating Style) ---
          _buildInputArea(controller),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 280), // Max lebar bubble
        decoration: BoxDecoration(
          color: msg.isSender ? CustomColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(msg.isSender ? 20 : 0),
            bottomRight: Radius.circular(msg.isSender ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: msg.isSender ? Colors.white : const Color(0xFF3E2723),
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              msg.time,
              style: TextStyle(
                color: msg.isSender ? Colors.white70 : Colors.grey[400],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(AdminChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      color: Colors.transparent, // Background transparan
      child: Row(
        children: [
          // Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.messageC,
                style: const TextStyle(color: Color(0xFF3E2723)),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  // Icon attachment (Opsional)
                  prefixIcon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send Button (Custom Asset)
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: CustomColors.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/chat_send_icon.png', // Gunakan asset yang Anda upload
                  color: Colors.white,
                  errorBuilder: (c, o, s) =>
                      const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

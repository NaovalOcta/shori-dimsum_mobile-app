import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import 'package:mobile_tugas_akhir/app/modules/admin_chat_detail/views/admin_chat_detail_view.dart';
import '../controllers/admin_chat_controller.dart';

class AdminChatView extends GetView<AdminChatController> {
  const AdminChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi Controller jika belum ada
    Get.put(AdminChatController());

    return Scaffold(
      backgroundColor: CustomColors.backgroundColor_1, // Cream
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor_1,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF3E2723),
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontFamily: 'Serif',
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        itemCount: controller.chatList.length,
        itemBuilder: (context, index) {
          final chat = controller.chatList[index];
          return _buildChatCard(chat);
        },
      ),
    );
  }

  Widget _buildChatCard(ChatSession chat) {
    return GestureDetector(
      // Navigasi ke Detail Chat saat diklik
      onTap: () => Get.to(() => AdminChatDetailView(userName: chat.userName)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/products_placeholder.jpg',
                  ), // Placeholder user
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Info (Nama & Pesan)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: chat.unreadCount > 0
                                ? Colors.black87
                                : Colors.grey.shade600,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      // Badge Unread
                      if (chat.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: CustomColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

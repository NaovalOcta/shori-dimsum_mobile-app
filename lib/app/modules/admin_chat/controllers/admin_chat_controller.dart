import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model Sederhana untuk Chat
class ChatSession {
  String id;
  String userName;
  String lastMessage;
  String time;
  int unreadCount;
  String profileImg;

  ChatSession(
    this.id,
    this.userName,
    this.lastMessage,
    this.time,
    this.unreadCount,
    this.profileImg,
  );
}

class ChatMessage {
  String text;
  bool isSender; // true = Admin, false = Customer
  String time;

  ChatMessage(this.text, this.isSender, this.time);
}

class AdminChatController extends GetxController {
  // --- Daftar Chat (Inbox) ---
  var chatList = <ChatSession>[
    ChatSession(
      "1",
      "Anisa Rahma",
      "Apakah siomay udang ready gan?",
      "10:30",
      2,
      "",
    ),
    ChatSession(
      "2",
      "Budi Santoso",
      "Pesanan saya statusnya gimana kak?",
      "Yesterday",
      0,
      "",
    ),
    ChatSession(
      "3",
      "Citra Kirana",
      "Oke siap, terima kasih infonya.",
      "Yesterday",
      0,
      "",
    ),
  ].obs;

  // --- Detail Chat (Room) ---
  // Dummy messages untuk demo
  var currentMessages = <ChatMessage>[
    ChatMessage("Halo kak, selamat siang.", false, "10:28"),
    ChatMessage("Siang kak Anisa, ada yang bisa dibantu?", true, "10:29"),
    ChatMessage(
      "Apakah siomay udang ready gan? Saya mau pesan 5 porsi buat acara.",
      false,
      "10:30",
    ),
  ].obs;

  TextEditingController messageC = TextEditingController();

  void sendMessage() {
    if (messageC.text.isNotEmpty) {
      currentMessages.add(ChatMessage(messageC.text, true, "Now"));
      messageC.clear();
      // Scroll ke bawah logic bisa ditambahkan disini
    }
  }
}

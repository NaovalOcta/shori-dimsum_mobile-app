import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Contact', 
          style: TextStyle(
            color: Colors.white
          )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ...
            // ISI CHAT atau maybe seluruh section ini di replace sesuatu (CHAT BISA LEWAT WA)
            // ...
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Type Here',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey) 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ), 
                      floatingLabelStyle: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      'assets/chat_send_icon.png',
                      width: 21,
                      height: 21,
                    ),
                    style: IconButton.styleFrom(
                      overlayColor: CustomColors.primaryColor_100,
                      padding: EdgeInsets.all(19)
                    ),
                    
                    onPressed: () => null,
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }
}

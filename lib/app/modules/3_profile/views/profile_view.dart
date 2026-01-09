import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        // Menggunakan Obx agar UI update saat loading berubah
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // --- Profile Image ---
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    'assets/products_placeholder.jpg', // Placeholder gambar
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- Form Fields ---
              // Nama
              buildProfileField(
                label: "Name",
                textController: controller.nameC,
                isEditable: controller.isProfileEditable.value,
              ),
              const SizedBox(height: 15),

              // Email (Biasanya tidak diedit sembarangan, jadi kita disable atau readonly)
              buildProfileField(
                label: "Email",
                textController: controller.emailC,
                isEditable: false, // Email tidak bisa diubah di form ini
              ),
              const SizedBox(height: 15),

              // Alamat
              buildProfileField(
                label: "Address",
                textController: controller.addressC,
                isEditable: controller.isProfileEditable.value,
                maxLines: 2,
              ),
              const SizedBox(height: 15),

              // Nomor HP
              buildProfileField(
                label: "Phone Number",
                textController: controller.phoneC,
                isEditable: controller.isProfileEditable.value,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 40),

              // --- Action Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol KIRI: Edit atau Cancel
                  Expanded(
                    child: controller.isProfileEditable.value
                        ? _buildCancelButton()
                        : _buildEditButton(),
                  ),

                  const SizedBox(width: 20),

                  // Tombol KANAN: Logout atau Save
                  Expanded(
                    child: controller.isProfileEditable.value
                        ? _buildSaveButton()
                        : _buildLogoutButton(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  // Widget Helper untuk Text Field
  Widget buildProfileField({
    required String label,
    required TextEditingController textController,
    required bool isEditable,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: textController,
          enabled: isEditable, // Kunci field jika tidak mode edit
          maxLines: maxLines,
          keyboardType: inputType,
          style: TextStyle(color: isEditable ? Colors.black : Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: isEditable ? Colors.white : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isEditable
                    ? CustomColors.primaryColor
                    : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: CustomColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  // --- BUTTON WIDGETS ---

  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: controller.editProfileFunc,
      icon: const Icon(Icons.edit, color: Colors.white),
      label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton.icon(
      onPressed: () {
        controller.isProfileEditable.value = false;
        controller.fetchUserProfile(); // Reset data ke awal
      },
      icon: const Icon(Icons.close, color: CustomColors.primaryColor),
      label: const Text(
        "Cancel",
        style: TextStyle(color: CustomColors.primaryColor),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        side: const BorderSide(color: CustomColors.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: controller.saveProfileFunc,
      icon: const Icon(Icons.save, color: Colors.white),
      label: const Text("Save", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Warna hijau untuk save
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: controller.logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text("Logout", style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:mobile_tugas_akhir/app/designs/colors/CustomColors.dart';
// import 'package:mobile_tugas_akhir/app/models/User.dart';
// import 'package:mobile_tugas_akhir/app/modules/2_home/controllers/home_controller.dart';
// import 'package:mobile_tugas_akhir/app/modules/3_food_catalog/controllers/food_catalog_controller.dart';
// import 'package:mobile_tugas_akhir/app/routes/app_pages.dart';

// import '../controllers/profile_controller.dart';

// class ProfileView extends GetView<ProfileController> {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeController hC = Get.find<HomeController>();
//     final FoodCatalogController fCC = Get.find<FoodCatalogController>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: CustomColors.primaryColor,
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text(
//           'Profile', 
//           style: TextStyle(
//             color: Colors.white
//           )
//         ),
//       ),
//       body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30),
//             child: Column(  
//               children: [
//                 const SizedBox(height: 30),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(80),
//                   child: Image.asset(
//                     controller.userClass.users[0].profileImg,
//                     width: 100,
//                     height: 100,
//                   )
//                 ),
//                 const SizedBox(height: 10),
//                 Obx(() =>
//                   TextField(
//                     controller: controller.userClass.nameController,
//                     enabled: controller.userClass.isProfileEditable.value,
//                     decoration: InputDecoration(
//                       labelText: 'Name',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueAccent, width: 3),
//                         borderRadius: BorderRadius.circular(10),
//                       ), 
//                       floatingLabelStyle: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Obx(() =>
//                   TextField(
//                     controller: controller.userClass.emailController,
//                     enabled: controller.userClass.isProfileEditable.value,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueAccent, width: 3),
//                         borderRadius: BorderRadius.circular(10),
//                       ), 
//                       floatingLabelStyle: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Obx(() =>
//                   TextField(
//                     controller: controller.userClass.addressController,
//                     enabled: controller.userClass.isProfileEditable.value,
//                     decoration: InputDecoration(
//                       labelText: 'Delivery Address',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueAccent, width: 3),
//                         borderRadius: BorderRadius.circular(10),
//                       ), 
//                       floatingLabelStyle: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Obx(() =>
//                   TextField(
//                     controller: controller.userClass.phoneNumController,
//                     enabled: controller.userClass.isProfileEditable.value,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueAccent, width: 3),
//                         borderRadius: BorderRadius.circular(10),
//                       ), 
//                       labelStyle: TextStyle(),
//                       floatingLabelStyle: TextStyle(
//                         color: Colors.grey.shade800,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.grey.shade600,
//                     overlayColor: Colors.transparent,
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                     minimumSize: Size.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Payment Details',
//                         style: TextStyle(fontSize: 15)
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios_sharp,
//                         color: Colors.grey.shade600,
//                       )
//                     ]
//                   ),
//                   // Payment Details
//                   onPressed: () => null, 
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     foregroundColor: Colors.grey.shade600,
//                     overlayColor: Colors.transparent,
//                     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                     minimumSize: Size.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Order History',
//                         style: TextStyle(fontSize: 15)
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios_sharp,
//                         color: Colors.grey.shade600,
//                       )
//                     ]
//                   ),
//                   // Order History
//                   onPressed: () => null, 
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Obx(() {
//                       return controller.userClass.isProfileEditable.value 
//                                 ? profileSaveButton(controller) 
//                                 : profileEditButton(controller); 
//                     }),
//                     OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         minimumSize: const Size(0, 50),
//                         maximumSize: const Size(155, 50),
//                         backgroundColor: Colors.white,
//                         overlayColor: Colors.grey.shade500,
//                         side: BorderSide(
//                           color: CustomColors.primaryColor
//                         ),
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(width: 2),
//                           borderRadius: BorderRadius.circular(10),
//                         )
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Text( 
//                             'Logout',
//                             style: TextStyle(
//                               color: CustomColors.primaryColor,
//                               fontSize: 15,
//                             )
//                           ),
//                           const SizedBox(width: 20),
//                           Image.asset(
//                             'assets/sign_out_icon.png',
//                             width: 20,
//                             height: 20,
//                           ),
//                         ]
//                       ), 
//                       // Logout
//                       onPressed: () async {
//                         fCC.productClass.updateCloudDb();
//                         await Get.offAllNamed(Routes.START); 
//                         // Get.toNamed(Routes.START);
//                         hC.navbarClass.resetNavItemSelection();
//                       }, 
//                     )
//                   ]
//                 ),
//                 const SizedBox(height: 20),
//               ] 
//             )
//           )
//         )
//     );
//   }
// }

// Widget profileEditButton(ProfileController controller) {
//   return OutlinedButton(
//     style: OutlinedButton.styleFrom(
//       minimumSize: const Size(0, 50),
//       maximumSize: const Size(160, 50),
//       backgroundColor: CustomColors.primaryColor,
//       overlayColor: CustomColors.primaryColor_100,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       )
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text( 
//           'Edit Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//           )
//         ),
//         const SizedBox(width: 10),
//         Image.asset(
//           'assets/edit_prof_icon.png',
//           width: 20,
//           height: 20,
//         ),
//       ]
//     ), 
//     // Edit Profile 
//     onPressed: () => controller.userClass.editProfileFunc(), 
//   );
// }

// Widget profileSaveButton(ProfileController controller) {
//   return OutlinedButton(
//     style: OutlinedButton.styleFrom(
//       minimumSize: const Size(0, 50),
//       maximumSize: const Size(160, 50),
//       backgroundColor: CustomColors.primaryColor,
//       overlayColor: CustomColors.primaryColor_100,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       )
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Text( 
//           'Save Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 15,
//           )
//         ),
//         const SizedBox(width: 10),
//         Icon(
//           Icons.save,
//           size: 20,
//           color: Colors.white,
//         )
//       ]
//     ), 
//     // Edit Profile 
//     onPressed: () => controller.userClass.saveProfileFunc(), 
//   );
// }
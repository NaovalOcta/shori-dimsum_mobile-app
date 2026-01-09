class User {
  String id;
  String name;
  String email;
  String address;
  String phoneNumber;
  String password;
  String profileImg;
  String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.password,
    required this.profileImg,
    required this.role,
  });

  // Tambahkan factory untuk konversi dari Supabase
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      password: map['password'] ?? '',
      profileImg: map['profile_img'] ?? 'assets/products_placeholder.jpg',
      role: map['role'] ?? 'user',
    );
  }
}

// import 'package:mobile_tugas_akhir/app/modules/2_home/controllers/home_controller.dart';

// class User extends HomeController {
//   String name;
//   String email;
//   String address;
//   String phoneNumber;
//   String password;
//   String profileImg;
//   String role;

//   User({
//     required this.name,
//     required this.email,
//     required this.address,
//     required this.phoneNumber,
//     required this.password,
//     required this.profileImg,
//     required this.role,
//   });
// }

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_tugas_akhir/app/models/User.dart' as model; 

class UserDb {
  static final UserDb _instance = UserDb._internal();
  factory UserDb() => _instance;
  UserDb._internal();

  final _supabase = Supabase.instance.client;

  Future<List<model.User>> fetchUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select();
      
      final data = response as List<dynamic>;
      return data.map((item) => model.User.fromMap(item)).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  String getDefaultProfImg() => 'assets/products_placeholder.jpg';
}












// import 'package:mobile_tugas_akhir/app/models/User.dart';

// class UserDb {
//   static final UserDb _instance = UserDb._internal();
//   factory UserDb() {
//     return _instance;
//   }
//   UserDb._internal();

//   final List<User> userDataList = <User>[
//     User(
//       name: 'ADMIN', 
//       email: 'admin@gmail.com', 
//       address: 'Sesame Street no 10, Japan',
//       phoneNumber: '999',
//       password: '123456789',
//       profileImg: 'assets/products_placeholder.jpg'
//     ),
//     User(
//       name: 'Dimsum Mental', 
//       email: 'dummy123@gmail.com', 
//       address: 'Sesame Street no 10, Japan',
//       phoneNumber: '123',
//       password: '123456789',
//       profileImg: 'assets/products_placeholder.jpg'
//     ),
//   ];

//   String getDefaultProfImg() {
//     return 'assets/products_placeholder.jpg';
//   }
// }
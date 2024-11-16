import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> SignOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      throw e;  
    }
  }

  Future<void> deleteuser() async {
    try {
      await _auth.currentUser?.delete();
    } catch (e) {
      print("Error deleting user: $e");
      throw e;  
    }
  }
}

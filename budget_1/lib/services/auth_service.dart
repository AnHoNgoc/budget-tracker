import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String?> createUser(Map<String, dynamic> data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      final userId = _auth.currentUser!.uid;

      await _fireStore.collection('users').doc(userId).set({
        "username": data["username"],
        "email": data["email"],
        "remainingAmount": data["remainingAmount"],
        "totalCredit": data["totalCredit"],
        "totalDebit": data["totalDebit"],
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already registered.';
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<bool> loginUser(Map<String, dynamic> data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        final cred = EmailAuthProvider.credential(email: email, password: oldPassword);
        await user.reauthenticateWithCredential(cred);

        await user.updatePassword(newPassword);
        return true;
      } else {
        throw Exception("User not found.");
      }
    } catch (e) {
      return false;
    }
  }
}

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

  Future<String?> loginUser(Map<String, dynamic> data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );
      return null;
    } on FirebaseAuthException catch (_) {
      return 'Invalid email or password.';
    } catch (_) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User not found.";
      final email = user.email;
      if (email == null) return "Email not available for this account.";

      // Re-auth với mật khẩu cũ
      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // Đổi mật khẩu
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return "Old password is incorrect.";
        case 'weak-password':
          return "New password is too weak.";
        case 'requires-recent-login':
          return "Please log in again and try changing the password.";
        case 'user-not-found':
        case 'user-mismatch':
          return "User not found or mismatched.";
        case 'too-many-requests':
          return "Too many attempts. Please try again later.";
        default:
          return "Password change failed. Please try again.";
      }
    } catch (e) {
      // debugPrint('changePassword unknown error: $e');
      return "An error occurred. Please try again.";
    }
  }

  Future<bool> deleteUser({String? password}) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      await _fireStore.collection('users').doc(user.uid).delete();
      await user.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (password == null || user.email == null) return false;

        AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);

        await _fireStore.collection('users').doc(user.uid).delete();
        await user.delete();
        return true;
      }
      return false;
    }
  }

  Future<bool> resetAmounts(String userId) async {
    final userDoc = _fireStore.collection('users').doc(userId);

    try {
      // 1. Xóa tất cả transactions
      final transactions = await userDoc.collection('transactions').get();
      for (var doc in transactions.docs) {
        await doc.reference.delete();
      }
      
      return true;
    } catch (e) {
      // Lỗi
      return false;
    }
  }
}

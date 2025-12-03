import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uid = const Uuid();

  // Hàm thêm transaction (của bạn)
  Future<void> addTransaction({
    required String title,
    required int amount,
    required String type,
    required String category,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DateTime date = DateTime.now();
    String monthYear = DateFormat("MMM y").format(date);

    var id = _uid.v4();

    final userDoc = await _fireStore.collection("users").doc(user.uid).get();

    int remainingAmount = userDoc["remainingAmount"];
    int totalCredit = userDoc["totalCredit"];
    int totalDebit = userDoc["totalDebit"];

    if (type == "credit") {
      remainingAmount += amount;
      totalCredit += amount;
    } else {
      remainingAmount -= amount;
      totalDebit += amount;
    }

    await _fireStore.collection("users").doc(user.uid).update({
      "remainingAmount": remainingAmount,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "updateAt": timestamp,
    });

    await _fireStore
        .collection("users")
        .doc(user.uid)
        .collection("transactions")
        .doc(id)
        .set({
      "id": id,
      "title": title,
      "amount": amount,
      "type": type,
      "timestamp": timestamp,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "remainingAmount": remainingAmount,
      "monthYear": monthYear,
      "category": category,
    });
  }

  // Hàm xóa transaction
  Future<void> deleteTransaction(String transactionId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final transactionDoc = await _fireStore
        .collection("users")
        .doc(user.uid)
        .collection("transactions")
        .doc(transactionId)
        .get();

    if (!transactionDoc.exists) {
      throw Exception("Transaction not found");
    }

    final data = transactionDoc.data()!;
    final int amount = data["amount"];
    final String type = data["type"];

    final userDocRef = _fireStore.collection("users").doc(user.uid);
    final userDoc = await userDocRef.get();

    int remainingAmount = userDoc["remainingAmount"];
    int totalCredit = userDoc["totalCredit"];
    int totalDebit = userDoc["totalDebit"];

    // Cập nhật lại các tổng
    if (type == "credit") {
      remainingAmount -= amount;
      totalCredit -= amount;
    } else {
      remainingAmount += amount;
      totalDebit -= amount;
    }

    await userDocRef.update({
      "remainingAmount": remainingAmount,
      "totalCredit": totalCredit,
      "totalDebit": totalDebit,
      "updateAt": DateTime.now().millisecondsSinceEpoch,
    });

    // Xóa transaction
    await _fireStore
        .collection("users")
        .doc(user.uid)
        .collection("transactions")
        .doc(transactionId)
        .delete();
  }
}
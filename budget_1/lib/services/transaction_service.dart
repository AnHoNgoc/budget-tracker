import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _uid = const Uuid();

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
}
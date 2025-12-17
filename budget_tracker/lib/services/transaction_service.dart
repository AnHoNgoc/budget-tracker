import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    required String monthYear
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    var id = _uid.v4();


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
      "monthYear": monthYear,
    });
  }

  // Hàm xóa transaction
  Future<void> deleteTransaction(String transactionId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    // Xóa transaction
    await _fireStore
        .collection("users")
        .doc(user.uid)
        .collection("transactions")
        .doc(transactionId)
        .delete();
  }


  Stream<Map<String, double>> getMonthlyTotals({
    required String userId,
    required String monthYear,
  }) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('monthYear', isEqualTo: monthYear)
        .snapshots()
        .map((snapshot) {
      double credit = 0;
      double debit = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0).toDouble();
        final type = (data['type'] ?? '');

        if (type == 'credit') credit += amount;
        if (type == 'debit') debit += amount;
      }

      return {
        'credit': credit,
        'debit': debit,
        'remaining': credit - debit,
      };
    });
  }

  Stream<QuerySnapshot> getRecentTransactions(String userId) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy("timestamp", descending: true)
        .limit(50)
        .snapshots();
  }


  Future<QuerySnapshot> getFilteredTransactions({
    required String userId,
    required String monthYear,
    required String type,
    required String category,
  }) {
    Query query = _fireStore
        .collection('users')
        .doc(userId)
        .collection("transactions")
        .orderBy("timestamp", descending: true)
        .where("monthYear", isEqualTo: monthYear)
        .where("type", isEqualTo: type);

    if (category != "All") {
      query = query.where("category", isEqualTo: category);
    }

    return query.limit(100).get();
  }
}
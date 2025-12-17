import 'package:budget_tracker/widgets/transaction_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/transaction_service.dart';

class TransactionList extends StatelessWidget {
  TransactionList({
    super.key,
    required this.category,
    required this.type,
    required this.monthYear,
  });

  final String category;
  final String type;
  final String monthYear;

  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _service = TransactionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _service.getFilteredTransactions(
        userId: _userId,
        monthYear: monthYear,
        type: type,
        category: category,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No transactions found"));
        }

        var data = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return TransactionItem(
              data: data[index],
            );
          },
        );
      },
    );
  }
}

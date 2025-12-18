import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../services/transaction_service.dart';
import '../utils/confirm_dialog.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15.w),
          child: Row(
            children: [
              Text(
                "Recent Activity",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        RecentTransactionList(),
      ],
    );
  }
}

class RecentTransactionList extends StatelessWidget {
  RecentTransactionList({super.key});

  final _userId = FirebaseAuth.instance.currentUser?.uid;
  final _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _transactionService.getRecentTransactions(_userId!),
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
            return TransactionItem(data: data[index]);
          },
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  TransactionItem({
    super.key,
    required this.data,
  });

  final dynamic data;
  final TransactionService _transactionService = TransactionService();

  Future<void> _handleDelete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    bool confirm = await ConfirmDialog.show(
      context,
      title: "Delete Transaction",
      content: "Are you sure you want to delete this transaction?",
      cancelText: "Cancel",
      confirmText: "Delete",
    );

    if (!confirm) return;

    try {
      await _transactionService.deleteTransaction(data["id"]);
      messenger.showSnackBar(
        const SnackBar(content: Text("Transaction deleted")),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data["timestamp"]);
    String formattedDate = DateFormat("d MMM hh:mma").format(date);

    bool isCredit = data["type"] == "credit";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: GestureDetector(
        onTap: () => _handleDelete(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.systemGrey.withOpacity(0.15),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // ICON BOX

              SizedBox(width: 14.w),

              // TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + AMOUNT
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${data["title"]}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label,
                            ),
                          ),
                        ),
                        Text(
                          "${isCredit ? "+" : "-"} \$${data["amount"]}",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: isCredit
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.systemRed,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // DATE
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: CupertinoColors.systemGrey3,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:budget_tracker/utils/icons_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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
                "Recent Transaction",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
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
  RecentTransactionList({
    super.key,
  });

  final _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection("transactions")
          .orderBy("timestamp", descending: true)
          .limit(20)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No transactions found"));
        }

        var data = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            var cardData = data[index];
            return TransactionItem(
              data: cardData,
            );
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
  final _appIcon = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data["timestamp"]);
    String formatedDate = DateFormat("d MMM hh:mma").format(date);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h), // tăng nhẹ
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r), // tăng nhẹ
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6.h), // tăng nhẹ
              color: Colors.grey.withOpacity(0.07),
              blurRadius: 8.0,
              spreadRadius: 3.0,
            )
          ],
        ),
        child: ListTile(
          minVerticalPadding: 8.h, // tăng nhẹ
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
          leading: Container(
            width: 60.w, // to hơn một chút
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r), // tăng nhẹ
              color: data["type"] == "credit"
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
            ),
            child: Center(
              child: FaIcon(
                _appIcon.getExpenseCategoryIcons("${data["category"]}"),
                color: data["type"] == "credit" ? Colors.green : Colors.red,
                size: 22.sp, // to hơn chút
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "${data["title"]}",
                  style: TextStyle(
                    fontSize: 18.sp, // to hơn chút
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "${data["type"] == "credit" ? "+" : "-"} \$ ${data["amount"]}",
                style: TextStyle(
                  color: data["type"] == "credit" ? Colors.green : Colors.red,
                  fontSize: 16.sp, // to hơn chút
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h), // tăng nhẹ
              Row(
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp), // to hơn chút
                  ),
                  const Spacer(),
                  Text(
                    "\$ ${data["remainingAmount"]}",
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp), // to hơn chút
                  ),
                ],
              ),
              SizedBox(height: 3.h), // tăng nhẹ
              Text(
                formatedDate,
                style: TextStyle(color: Colors.grey, fontSize: 12.sp), // to hơn chút
              ),
            ],
          ),
        ),
      ),
    );
  }
}


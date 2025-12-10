
import 'package:budget_tracker/widgets/transaction_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/transaction_service.dart';

class TypeTabBar extends StatefulWidget {
  const TypeTabBar({
    super.key,
    required this.category,
    required this.monthYear,
  });

  final String category;
  final String monthYear;

  @override
  State<TypeTabBar> createState() => _TypeTabBarState();
}

class _TypeTabBarState extends State<TypeTabBar> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  final _service = TransactionService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: _service.getMonthlyTotals(
        userId: _userId,
        monthYear: widget.monthYear,
      ),
      builder: (context, snapshot) {
        double credit = 0;
        double debit = 0;

        if (snapshot.hasData) {
          credit = snapshot.data!["credit"] ?? 0;
          debit = snapshot.data!["debit"] ?? 0;
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,

                /// 👇 Thêm style chữ lớn
                labelStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),

                tabs: [
                  Tab(text: "Credit (${credit.toStringAsFixed(0)})"),
                  Tab(text: "Debit (${debit.toStringAsFixed(0)})"),
                ],
              ),

              SizedBox(height: 10.h),

              Expanded(
                child: TabBarView(
                  children: [
                    TransactionList(
                      category: widget.category,
                      monthYear: widget.monthYear,
                      type: 'credit',
                    ),
                    TransactionList(
                      category: widget.category,
                      monthYear: widget.monthYear,
                      type: 'debit',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
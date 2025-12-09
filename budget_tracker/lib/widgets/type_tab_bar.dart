
import 'package:budget_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypeTabBar extends StatelessWidget {
  const TypeTabBar({super.key, required this.category, required this.monthYear});

  final String category;
  final String monthYear;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Credit"),
              Tab(text: "Debit"),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: TabBarView(
              children: [
                TransactionList(
                  category: category,
                  monthYear: monthYear,
                  type: 'credit',
                ),
                TransactionList(
                  category: category,
                  monthYear: monthYear,
                  type: 'debit',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
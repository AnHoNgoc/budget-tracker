import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/transaction_service.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.userId,
    required this.selectedMonth,
  });

  final String userId;
  final String selectedMonth;

  @override
  Widget build(BuildContext context) {
    final transactionService = TransactionService();

    return StreamBuilder<Map<String, double>>(
      stream: transactionService.getMonthlyTotals(
        userId: userId,
        monthYear: selectedMonth,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final remaining = data['remaining'] ?? 0;

        return _buildCard(remaining);
      },
    );
  }

  Widget _buildCard(double remaining) {
    return Container(
      width: double.infinity, // sát 2 bên
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45.r),
          topRight: Radius.circular(45.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Total for $selectedMonth",
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          ),
          SizedBox(height: 10.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: remaining.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 60.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: " \$",
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

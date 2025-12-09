import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userStream =
    FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check snapshot.hasData và snapshot.data!.data() != null
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          // Document không tồn tại → show placeholder hoặc SizedBox
          return const Center(child: Text('User not found'));
        }

        final data = snapshot.data!.data()! as Map<String, dynamic>;

        return HeroCardBody(
          remainingAmount: data["remainingAmount"] ?? 0,
          totalCredit: data["totalCredit"] ?? 0,
          totalDebit: data["totalDebit"] ?? 0,
        );
      },
    );
  }
}

class HeroCardBody extends StatelessWidget {
  const HeroCardBody({
    super.key,
    required this.remainingAmount,
    required this.totalCredit,
    required this.totalDebit,
  });

  final dynamic remainingAmount;
  final dynamic totalCredit;
  final dynamic totalDebit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5E00B8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    height: 2.0.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "\$ $remainingAmount",
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: Colors.white,
                    height: 1.2.h,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.only(
              top: 35.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CardOne(
                    color: Colors.green,
                    heading: "Credit",
                    amount: '$totalCredit',
                    icon: Icons.arrow_upward_outlined,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: CardOne(
                    color: Colors.red,
                    heading: "Debit",
                    amount: '$totalDebit',
                    icon: Icons.arrow_downward_outlined,
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

class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
    required this.icon,
  });

  final Color color;
  final String heading;
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading, style: TextStyle(color: color, fontSize: 16.sp)),
              Text("\$ $amount",
                  style: TextStyle(
                      color: color,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          Icon(icon, color: color, size: 24.sp),
        ],
      ),
    );
  }
}

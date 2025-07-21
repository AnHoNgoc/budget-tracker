import 'package:budget_tracker/widgets/category_list.dart';
import 'package:budget_tracker/widgets/time_line_month.dart';
import 'package:budget_tracker/widgets/type_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String category = "All";
  String monthYear = "";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    monthYear = DateFormat("MMM y").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expansive")),
      body: Column(
        children: [
          SizedBox(height: 15.h),
          TimeLineMonth(
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  monthYear = value;
                });
              }
            },
          ),
          CategoryList(
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  category = value;
                });
              }
            },
          ),
          TypeTabBar(category: category, monthYear: monthYear),
        ],
      ),
    );
  }
}
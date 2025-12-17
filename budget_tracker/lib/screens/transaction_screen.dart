import 'package:budget_tracker/widgets/category_list.dart';
import 'package:budget_tracker/widgets/time_line.dart';
import 'package:budget_tracker/widgets/type_tab_bar.dart';
import 'package:flutter/cupertino.dart';
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
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text(
          "Detail",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.sp),
        ),
      ),

      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 15.h),

                  /// Month Timeline
                  TimeLine(
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => monthYear = value);
                      }
                    },
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),

            /// Main Transaction Content
            SliverFillRemaining(
              hasScrollBody: true,
              child: TypeTabBar(
                category: category,
                monthYear: monthYear,
              ),
            )
          ],
        ),
      ),
    );
  }
}

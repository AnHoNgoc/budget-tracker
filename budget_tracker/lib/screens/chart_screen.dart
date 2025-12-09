import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartScreen extends StatefulWidget {
  final String userId;

  const ChartScreen({super.key, required this.userId});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  Map<String, double> creditByMonth = {};
  Map<String, double> debitByMonth = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMonthlyData();
  }

  Future<void> fetchMonthlyData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("transactions")
          .get();

      Map<String, double> credit = {};
      Map<String, double> debit = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final monthYear = data['monthYear'] ?? 'Unknown';
        final type = data['type'] ?? '';
        final amount = (data['amount'] ?? 0).toDouble();

        if (type == 'credit') {
          credit[monthYear] = (credit[monthYear] ?? 0) + amount;
        } else if (type == 'debit') {
          debit[monthYear] = (debit[monthYear] ?? 0) + amount;
        }
      }

      setState(() {
        creditByMonth = credit;
        debitByMonth = debit;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching chart data: $e");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final months = creditByMonth.keys.toSet().union(debitByMonth.keys.toSet()).toList();
    months.sort();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "Chart",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25.sp,
          ),
        ),
        automaticallyImplyLeading: false, // bỏ nút back
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: getMaxY(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        int index = value.toInt();
                        if (index < 0 || index >= months.length) return const Text('');
                        return Text(
                          months[index],
                          style: TextStyle(fontSize: 10.sp, color: CupertinoColors.systemGrey),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  months.length,
                      (index) {
                    final month = months[index];
                    return BarChartGroupData(
                      x: index,
                      barsSpace: 8,
                      barRods: [
                        BarChartRodData(
                          toY: creditByMonth[month] ?? 0,
                          width: 12.w,
                          color: CupertinoColors.activeGreen,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        BarChartRodData(
                          toY: debitByMonth[month] ?? 0,
                          width: 12.w,
                          color: CupertinoColors.systemRed,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getMaxY() {
    double maxCredit = creditByMonth.values.isEmpty
        ? 0
        : creditByMonth.values.reduce((a, b) => a > b ? a : b);

    double maxDebit = debitByMonth.values.isEmpty
        ? 0
        : debitByMonth.values.reduce((a, b) => a > b ? a : b);

    return (maxCredit > maxDebit ? maxCredit : maxDebit) * 1.2;
  }
}
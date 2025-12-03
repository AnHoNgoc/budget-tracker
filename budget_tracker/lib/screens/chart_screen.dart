import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final months = creditByMonth.keys.toSet().union(debitByMonth.keys.toSet()).toList();
    months.sort(); // sort tháng theo tên hoặc "yyyy-MM"

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chart",
          style: TextStyle(color: Colors.white), // đổi màu chữ
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true, // căn giữa title
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: getMaxY(),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false), // tắt trục dọc
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    int index = value.toInt();
                    if (index < 0 || index >= months.length) return const Text('');
                    return Text(months[index], style: TextStyle(fontSize: 10.sp));
                  },
                ),
              ),
            ),
            barGroups: List.generate(months.length, (index) {
              final month = months[index];
              final credit = creditByMonth[month] ?? 0;
              final debit = debitByMonth[month] ?? 0;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(toY: credit, color: Colors.green, width: 12.w),
                  BarChartRodData(toY: debit, color: Colors.red, width: 12.w),
                ],
                barsSpace: 4,
              );
            }),
          ),
        ),
      ),
    );
  }

  double getMaxY() {
    double maxCredit = creditByMonth.values.isEmpty ? 0 : creditByMonth.values.reduce((a, b) => a > b ? a : b);
    double maxDebit = debitByMonth.values.isEmpty ? 0 : debitByMonth.values.reduce((a, b) => a > b ? a : b);
    return (maxCredit > maxDebit ? maxCredit : maxDebit) * 1.2; // padding 20%
  }
}
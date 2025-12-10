import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MonthDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  const MonthDropdown({super.key, required this.onChanged});

  @override
  State<MonthDropdown> createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  List<String> months = [];
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    for (int i = -12; i <= 0; i++) {
      months.add(DateFormat("MMM y").format(DateTime(now.year, now.month + i, 1)));
    }

    selectedMonth = DateFormat("MMM y").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.blue.shade900, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
          style: TextStyle(fontSize: 14.sp, color: Colors.black),
          items: months.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(m),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMonth = value;
            });
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}
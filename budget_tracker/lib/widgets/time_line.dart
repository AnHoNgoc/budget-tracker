import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  String currentMonth = "";
  List<String> months = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -12; i <= 0; i++) {
      months.add(DateFormat("MMM y").format(DateTime(now.year, now.month + i, 1)));
    }
    currentMonth = DateFormat("MMM y").format(now);

    Future.delayed(const Duration(milliseconds: 300), () {
      scrollToSelectedMonth();
    });
  }

  scrollToSelectedMonth() {
    final selectedMonthIndex = months.indexOf(currentMonth);
    if (selectedMonthIndex != -1) {
      final scrollOffset = (selectedMonthIndex * 100.w) - 170.w;
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h, // To hơn chút
      child: ListView.builder(
        controller: _scrollController,
        itemCount: months.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentMonth = months[index];
                widget.onChanged(months[index]);
              });
              scrollToSelectedMonth();
            },
            child: Container(
              width: 90.w, // To hơn
              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: currentMonth == months[index]
                    ? const Color(0xFF1C1C1E)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r), // To hơn
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: currentMonth == months[index]
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


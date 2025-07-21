import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({super.key, this.categoryType, required this.onChanged});

  final String? categoryType;
  final ValueChanged<String?> onChanged;
  final _appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: categoryType,
        isExpanded: true,
        hint: const Text("Select Category"),
        items: _appIcons.homeExpensesCategories
        .map((e)=> DropdownMenuItem<String>(
          value: e["name"],
            child: Row(
              children: [
                Icon(
                  e["icon"],
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(e["name"],
                  style: const TextStyle(color: Colors.black45),
                ),
              ]
            )))
        .toList(),
        onChanged: onChanged);
  }
}

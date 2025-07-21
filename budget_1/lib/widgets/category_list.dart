import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String _currentCategory = "";
  List<Map<String, dynamic>> _categoryList = [];

  final ScrollController _scrollController = ScrollController();
  final AppIcons _appIcons = AppIcons();

  final Map<String, dynamic> _addCart = {
    "name": "All",
    "icon": FontAwesomeIcons.cartPlus,
  };

  @override
  void initState() {
    super.initState();
    _categoryList = _appIcons.homeExpensesCategories;
    _categoryList.insert(0, _addCart);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var data = _categoryList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentCategory = data["name"];
                widget.onChanged(data["name"]);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: _currentCategory == data["name"]
                    ? Colors.blue.shade900
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      data["icon"],
                      size: 20.sp,
                      color: _currentCategory == data["name"]
                          ? Colors.white
                          : Colors.blue.shade900,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      data["name"],
                      style: TextStyle(
                        color: _currentCategory == data["name"]
                            ? Colors.white
                            : Colors.blue.shade900,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

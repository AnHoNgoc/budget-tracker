import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.selectedIndex, required this.onDestinationSelected});

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return  NavigationBar(
      onDestinationSelected: onDestinationSelected,
      indicatorColor: const Color(0xFF5E00B8),
      selectedIndex: selectedIndex,
      height: 60.h,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.attach_money),
          selectedIcon: Icon(Icons.attach_money, color: Colors.white),
          label: 'Transaction',
        ),

        NavigationDestination(
          icon: Icon(Icons.bar_chart),
          selectedIcon: Icon(
            Icons.bar_chart,
            color: Colors.white,
          ),
          label: 'Chart',
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _width = 150.w;
  double _height = 150.h;
  Color _color = Colors.blue.shade900;
  double _iconScale = 0.7;

  @override
  void initState() {
    super.initState();

    // Bắt đầu animation sau 100ms
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _width = 200.w;
        _height = 200.h;
        _color = Colors.blue.shade700;
        _iconScale = 1.0; // scale icon lên full
      });
    });

    // Chuyển qua LoginScreen sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF252634),
      child: Center(
        child: AnimatedContainer(
          width: _width,
          height: _height,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: _iconScale),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 100.sp, // base size, sẽ scale lên
              ),
            ),
          ),
        ),
      ),
    );
  }
}
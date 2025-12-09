import 'dart:math';
import 'package:budget_tracker/screens/chart_screen.dart';
import 'package:budget_tracker/screens/home_screen.dart';
import 'package:budget_tracker/screens/transaction_screen.dart';
import 'package:budget_tracker/widgets/navbar.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  late final List<Widget> _pages =  [
    HomeScreen(),
    TransactionScreen(),
    ChartScreen(userId: _userId)
  ];
  int _currentIndex = 0;

  // ❌ Không dùng late final, dùng nullable
  ConfettiController? _confettiController;

  @override
  void initState() {
    super.initState();

    // Khởi tạo controller
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController?.play(); // tự động chơi khi vào Dashboard
  }

  @override
  void dispose() {
    _confettiController?.dispose();
    super.dispose();
  }

  // Hàm trigger Confetti khi muốn
  void playConfetti() {
    _confettiController?.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],

          // Confetti rơi từ giữa màn hình
          if (_confettiController != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController!,
                  blastDirection: pi / 2, // rơi thẳng xuống
                  emissionFrequency: 0.02, // giảm tần suất sinh hạt → nhẹ hơn
                  numberOfParticles: 30,   // ít hạt hơn → rơi nhẹ
                  maxBlastForce: 5,        // lực tối đa thấp
                  minBlastForce: 2,        // lực tối thiểu thấp
                  gravity: 0.1,            // rơi chậm hơn
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                  particleDrag: 0.02,      // rơi tự nhiên hơn
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
import 'package:budget_tracker/screens/scan_qr_screen.dart';
import 'package:budget_tracker/widgets/add_transaction_form.dart';
import 'package:budget_tracker/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../utils/logout_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home_card.dart';
import '../widgets/time_line.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _logout() async {

    final shouldLogout = await LogoutDialog.showLogoutConfirmationDialog(context);
    if (shouldLogout) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Future<void> _showAddTransactionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: AddTransactionForm(),
        );
      },
    );
  }

  String _selectedMonth = "";

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat("MMM y").format(DateTime.now());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1C1C1E),
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: AppDrawer(onLogout: _logout),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1C1C1E),
        centerTitle: true,
        title: const Text("Personal Finance", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height, // chiều cao full màn hình
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  TimeLine(
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedMonth = value);
                    },
                  ),
                  SizedBox(height: 20.h),

                  HomeCard(userId: _userId, selectedMonth: _selectedMonth),
                  const TransactionCard(),
                ],
              ),
            ),
          ),

          // 🔥 Nút Scan
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                shape: const CircleBorder(),
                elevation: 6,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => const ScanQrScreen()),
                    );
                  },
                  child: SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: Lottie.asset(
                      'asset/lottie/scan.json',
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


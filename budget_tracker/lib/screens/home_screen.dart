import 'package:budget_tracker/widgets/add_transaction_form.dart';
import 'package:budget_tracker/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/logout_dialog.dart';
import '../widgets/app_drawer.dart';
import '../widgets/hero_card.dart';
import 'login.dart';

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5E00B8),
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: AppDrawer(
        onLogout: () => _logout(),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF5E00B8),
        centerTitle: true,
        title: const Text("Budget Tracker", style: TextStyle(color: Colors.white)),
        actions: [
          Builder(
            builder: (context) {
              return Tooltip(
                message: 'Logout',
                child: IconButton(
                  onPressed: () => _logout(),
                  icon: const Icon(Icons.logout, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeroCard(userId: _userId),
              TransactionCard(),
            ],
          ),
        ),
      ),
    );
  }
}


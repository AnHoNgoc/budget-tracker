import 'package:budget_tracker/widgets/add_transaction_form.dart';
import 'package:budget_tracker/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/logout_dialog.dart';
import '../widgets/hero_card.dart';
import 'change_password.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false,
    );
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

  Future<void> _showSettingsMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);

    final String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        overlay.size.width - offset.dx - button.size.width,
        0,
      ),
      items: const [
        PopupMenuItem<String>(
          value: 'change_password',
          child: Text('Change Password'),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    );

    if (selected == 'change_password') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
      );
    } else if (selected == 'logout') {
      final shouldLogout = await LogoutDialog.showLogoutConfirmationDialog(context);
      if (shouldLogout) {
        _logout(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text("Budget Tracker", style: TextStyle(color: Colors.white)),
        actions: [
          Builder(
            builder: (context) {
              return Tooltip(
                message: 'Settings',
                child: IconButton(
                  onPressed: () => _showSettingsMenu(context),
                  icon: const Icon(Icons.settings, color: Colors.white),
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


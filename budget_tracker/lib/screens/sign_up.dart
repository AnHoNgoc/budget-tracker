import 'package:budget_tracker/screens/login.dart';
import 'package:budget_tracker/services/auth_service.dart';
import 'package:budget_tracker/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/input_decoration.dart';
import '../utils/show_snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoader = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoader = true);

      var data = {
        "username": _userNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "remainingAmount": 0,
        "totalCredit": 0,
        "totalDebit": 0,
      };

      try {
        String? errorMessage = await _authService.createUser(data);

        if (!mounted) return; // ✅ FIX WARNING

        if (errorMessage == null) {
          _userNameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();

          showAppSnackBar(context, 'User created successfully!', Colors.green);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
          );
        } else {
          showAppSnackBar(context, errorMessage, Colors.red);
        }
      } catch (e) {
        if (!mounted) return; // ✅ FIX WARNING
        showAppSnackBar(context, 'Error: $e', Colors.red);
      } finally {
        if (mounted) {
          setState(() => _isLoader = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF252634),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              SizedBox(height: 80.h),
              Center(
                child: SizedBox(
                  width: 250.w,
                  child: Text(
                    "Create New Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              TextFormField(
                controller: _userNameController,
                style: const TextStyle(color: Colors.white),
                decoration: AppInputDecoration.build("UserName", Icons.person),
                validator: AppValidator.validateUser,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: AppInputDecoration.build("Email", Icons.email),
                validator: AppValidator.validateEmail,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: AppInputDecoration.build("Password", Icons.password),
                validator: AppValidator.validatePassword,
                obscureText: true,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _confirmPasswordController,
                style: const TextStyle(color: Colors.white),
                decoration: AppInputDecoration.build("Confirm Password", Icons.password_outlined),
                validator: (value) => AppValidator.validateConfirmPassword(value, _passwordController.text),
                obscureText: true,
              ),
              SizedBox(height: 40.h),
              SizedBox(
                height: 50.h,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3DDC97), // xanh ngọc dịu
                        Color(0xFFFF8A00), // cam mềm
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _isLoader ? null : _submitForm,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoader
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Text("Login", style: TextStyle(color: const Color(0xFF3DDC97), fontSize: 25.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

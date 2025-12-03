
import 'package:budget_tracker/screens/sign_up.dart';
import 'package:budget_tracker/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../utils/input_decoration.dart';
import '../utils/show_snackbar.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoader = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoader = true);

    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      String? result = await _authService.loginUser(data);

      if (!mounted) return;

      if (result == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
              (route) => false,
        );
      } else {
        showAppSnackBar(context, result, Colors.red);
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, 'Error: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoader = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 80.h),
              SizedBox(
                height: 300.h,
                child: Lottie.asset('asset/lottie/login.json', fit: BoxFit.contain),
              ),
              SizedBox(height: 50.h),
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
              SizedBox(height: 40.h),
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3DDC97), // xanh ngọc dịu, cao cấp
                      Color(0xFFFF8A00), // cam mềm, nổi vừa đủ
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: _isLoader ? null : _submitForm,
                  child: _isLoader
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: Text(
                  "Create New Account",
                  style: TextStyle(color: const Color(0xFF3DDC97), fontSize: 22.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


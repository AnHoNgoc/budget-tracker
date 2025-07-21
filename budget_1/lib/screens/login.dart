import 'package:budget_tracker/screens/sign_up.dart';
import 'package:budget_tracker/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../utils/input_decoration.dart';
import 'dashboard.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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

  void _showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoader = true);

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };

      try {
        bool isSuccess = await _authService.loginUser(data);

        if (isSuccess) {
          _showMessage('Login successfully!', color: Colors.green);
          await Future.delayed(const Duration(milliseconds: 800));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
                (route) => false,
          );
        } else {
          _showMessage('Login failed!');
        }
      } catch (e) {
        _showMessage('Error: $e');
      } finally {
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
              SizedBox(
                height: 50.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoader ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF15900),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18.sp),
                  ),
                  child: _isLoader
                      ? const Center(child: CircularProgressIndicator())
                      : Text("Login", style: TextStyle(color: Colors.white, fontSize: 25.sp)),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
                child: Text(
                  "Create New Account",
                  style: TextStyle(color: const Color(0xFFF15900), fontSize: 22.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:expense_tracker/auth/widgets/auth_button.dart';
import 'package:expense_tracker/auth/widgets/auth_header.dart';
import 'package:expense_tracker/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Email: ${emailController.text.trim()}");
      debugPrint("Password: ${passwordController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),
          child: Form(
  key: _formKey,
  child: Column(
    children: [

      const AuthHeader(
        title: "Welcome Back!",
        subtitle: "Login to continue",
      ),

      const SizedBox(height: 30),

      AuthTextField(
        controller: emailController,
        label: "Email",
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
      ),

      const SizedBox(height: 20),

      AuthTextField(
        controller: passwordController,
        label: "Password",
        prefixIcon: Icons.lock_outline,
        isPassword: true,
      ),

      const SizedBox(height: 30),

      AuthButton(
        text: "Login",
        onPressed: login,
      ),
    ],
  ),
),
        ),
      ),
    );
  }
}
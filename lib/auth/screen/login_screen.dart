import 'package:expense_tracker/auth/screen/register_user.dart';
import 'package:expense_tracker/auth/widgets/auth_button.dart';
import 'package:expense_tracker/auth/widgets/auth_header.dart';
import 'package:expense_tracker/auth/widgets/auth_text_field.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Providers/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //authentication

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final auth = AuthService();

    try {
     
     await auth.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
 //on success full login fireauth returns object-> UserCredentials
 //method->>User? user = FirebaseAuth.instance.currentUser;
      Navigator.pushReplacement(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print("No user found.");
          break;

        case 'wrong-password':
          print("Incorrect password.");
          break;

        case 'invalid-email':
          print("Invalid email.");
          break;

        case 'invalid-credential':
          print("Invalid email or password.");
          break;

        default:
          print(e.message);
      }
    } catch (e) {
      print("Unexpected error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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

                AuthButton(text: "Login", onPressed: login),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

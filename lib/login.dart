import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'weather.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background color
              Container(
                color: const Color(0xFFEBEAF8), // Hex color #EBEAF8
              ),
              // Top icon (sun and clouds)
              Positioned(
                top: 30,
                left: 20,
                child: Image.asset(
                  'assets/main_suncloud.png',
                  height: 250,
                ),
              ),
              Positioned(
                top: 180,
                left: 270,
                child: Image.asset(
                  'assets/main_cloud.png',
                  height: 70, // 크기 설정
                ),
              ),
              // Bottom city image
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/main_city.png',
                  fit: BoxFit.cover,
                  height: 150,
                ),
              ),
              // Login card
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign In",
                        textAlign: TextAlign.left, // Align text to the left
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9790F0), // #9790F0
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person,
                              color: const Color(0xFF9790F0)), // Icon color
                          hintText: "Username",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: const Color(0xFF9790F0)), // Icon color
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Row for Login and Sign Up Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomLoginButton(
                              text: "Login",
                              onPressed: () {
                                authService.signIn(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  onSuccess: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("로그인 성공")),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WeatherPage()),
                                    );
                                  },
                                  onError: (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err)),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomLoginButton(
                              text: "Sign Up",
                              onPressed: () {
                                authService.signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  onSuccess: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("회원가입 성공")),
                                    );
                                  },
                                  onError: (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err)),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom Login Button Widget
class CustomLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomLoginButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A60F0), Color(0xFF9790F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

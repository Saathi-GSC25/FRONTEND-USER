import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Handle login with email & password
  Future<void> _login() async {
    try {
      final user = await Provider.of<AuthService>(
        context,
        listen: false,
      ).signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (user != null) {
        // Store user ID locally
        final prefs = await SharedPreferences.getInstance();
        print('user id set');
        await prefs.setString('uuid', user.uid);

        // Show success snackbar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Logged in as ${user.email}")));

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Please check your credentials."),
          ),
        );
      }
    } catch (e) {
      // Show login error
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // Top header with background and title
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 250,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logobg.svg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      left: 32,
                      bottom: 32,
                      right: 32,
                      child: const Text(
                        'Sign in to your account',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Login form
            Positioned(
              top: 298,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Email input
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password input with visibility toggle
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login button
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text("Login"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF93A6D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //"Or Login with"
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Or Login with",
                          style: TextStyle(color: Color(0xFFB0B0B0)),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google login button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Provider.of<AuthService>(
                        context,
                        listen: false,
                      ).signInWithGoogle();
                    },
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text("Google"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App logo
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset('assets/icons/logo.svg', height: 80),
              ),
            ),

            // No account ? Register text
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Color(0xFFB0B0B0)),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: const TextStyle(
                          color: Color(0xFFF93A6D),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                // Navigate to signup screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

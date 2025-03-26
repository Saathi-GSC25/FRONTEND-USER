import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChildSetupScreen extends StatefulWidget {
  @override
  _ChildSetupScreenState createState() => _ChildSetupScreenState();
}

class _ChildSetupScreenState extends State<ChildSetupScreen> {
  @override
  bool _isPasswordVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');

    return {
      'Content-Type': 'application/json',
      if (sessionCookie != null) 'Cookie': sessionCookie, // Attach the cookie
    };
  }

  void submitCredentials(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      var headers = await getHeaders();
      var response = await http.put(
        Uri.parse(
          'https://7153-14-139-185-115.ngrok-free.app/parent/child_cred_update',
        ),
        headers: headers,
        body: json.encode({
          'username': username,
          'password': base64.encode(utf8.encode(password)),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Credentials submitted successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submission failed! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      'Setup your child’s Account',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
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
                ElevatedButton(
                  onPressed: () => submitCredentials(context),
                  child: const Text("Save and Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF93A6D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset('assets/icons/logo.svg', height: 80),
            ),
          ),
        ],
      ),
    );
  }
}

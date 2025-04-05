import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getUUID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uuid = prefs.getString('uuid');
  print("UUID saved: $uuid");
  return uuid;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uuid;
  Map<String, dynamic>? childDetails;

  @override
  void initState() {
    super.initState();
    loadAndFetchDetails();
  }

  Future<void> loadAndFetchDetails() async {
    await loadUUID();
    print('while loading : ${uuid}');
    if (uuid != null) {
      getDetails();
    }
  }

  Future<void> getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    final response;
    if (sessionCookie == null) {
      print('Printing : ${uuid}');
      print("Session cookie not found! + ");
      response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/common/child_details'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'parent_uuid': uuid}),
      );
      print("here");
      sessionCookie = response.headers['set-cookie'];
      if (sessionCookie != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_cookie', sessionCookie);
        print("Session cookie saved: $sessionCookie");
      }
      print(response.body);
    } else {
      print('Printing : ${uuid}');
      response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/common/child_details'),
        headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
        body: json.encode({'parent_uuid': uuid}),
      );
    }

    if (response.statusCode == 200) {
      setState(() {
        childDetails = jsonDecode(response.body);
      });
      print('Printing : ${childDetails}');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<void> loadUUID() async {
    String? loadedUUID = await getUUID();
    setState(() {
      uuid = loadedUUID ?? null;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Half: Greeting with Points and Logout
          Expanded(
            child: Stack(
              children: [
                // Pink Background Container (Bottom Layer)
                Container(
                  color: const Color(0xFFFCCBC4).withOpacity(0.8),
                  width: double.infinity,
                  height: double.infinity,
                ),

                // SVG Background Container (Middle Layer)
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/icons/bg-1.svg',
                    fit: BoxFit.cover,
                  ),
                ),

                // Text and Content Container (Top Layer)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 20,
                      right: 20,
                    ), // To avoid the notch area
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Points and Logout Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/points.svg',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${childDetails?['points']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();

                                // Firebase sign-out
                                await FirebaseAuth.instance.signOut();

                                // Clear local storage
                                await prefs.remove('session_cookie');
                                await prefs.remove('uuid');

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Greeting Message
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hey, check out how ${childDetails?['name'] ?? "loading..."} is doing!',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xBF000000),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half: Four Buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(10),
              children: [
                _buildFunctionalityButton(
                  'Child’s Report',
                  'assets/icons/profile.svg',
                  const Color(0xFFC7E7FB),
                  const Color(0xFF69C5FF),
                  const Color(0xFF9CD8FD),
                  const Color(0xFF069DFD),
                ),
                _buildFunctionalityButton(
                  'Task Manager',
                  'assets/icons/list.svg',
                  const Color(0xFFFADDC1),
                  const Color(0xFFFFB771),
                  const Color(0xFFFFD1A4),
                  const Color(0xFFFF8D1D),
                ),
                _buildFunctionalityButton(
                  'Chat with Aasha',
                  'assets/icons/talk.svg',
                  const Color(0xFFFAD4C6),
                  const Color(0xFFFFAA8A),
                  const Color(0xFFFBB59B),
                  const Color(0xFFFF5A1C),
                ),
                _buildFunctionalityButton(
                  'Schedule Calls',
                  'assets/icons/call.svg',
                  const Color(0xFFF8EDBD),
                  const Color(0xFFFFE058),
                  const Color(0xFFFFE886),
                  const Color(0xFFBE9B00),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionalityButton(
    String text,
    String svgPath,
    Color color1,
    Color color2,
    Color color3,
    Color color4,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: Text(text)),
                    body: Center(child: Text('$text Screen')),
                  ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: color2,
          backgroundColor: color1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
        ),
        child: Stack(
          children: [
            // SVG inside a rounded square
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color3,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(svgPath, height: 32, width: 32),
              ),
            ),
            // Button text positioned a little lower
            Align(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                ), // Adjusted text position
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color4,
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

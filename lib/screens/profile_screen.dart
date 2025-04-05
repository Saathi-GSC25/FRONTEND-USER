import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'child_setup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController additional_infoController =
      TextEditingController();

  List<String> neuro_cats = [
    "Autism Spectrum Disorder",
    "ADHD",
    "Dyslexia",
    "Dyspraxia",
    "Dyscalculia",
    "Tourette Syndrome",
    "Other",
  ];

  List<String> sexs = ["Female", "Male", "Others"];

  String? selectedsex;
  List<String> neuro_cat = [];
  String? uuid;

  @override
  void initState() {
    super.initState();
    getUuid();
  }

  Future<void> getUuid() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uuid = prefs.getString('uuid');
    });
    print('Loaded UUID: $uuid');
  }

  void saveProfile() async {
    String name = nameController.text.trim();
    int age = int.tryParse(ageController.text.trim()) ?? 0;
    String sex = selectedsex ?? '';
    String additional_info = additional_infoController.text.trim();
    print("Retrieved UUID: $uuid");

    if (name.isEmpty ||
        age == 0 ||
        sex.isEmpty ||
        neuro_cat.isEmpty ||
        uuid == null ||
        uuid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("${dotenv.env['BASE_URL']}/parent/child_create"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'parent_uuid': uuid,
          'name': name,
          'age': age,
          'sex': sex,
          'neuro_cat': neuro_cat,
          'additional_info': additional_info,
        }),
      );

      if (response.statusCode == 201) {
        String? sessionCookie = response.headers['set-cookie'];
        if (sessionCookie != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('session_cookie', sessionCookie);
          print("Session cookie saved: $sessionCookie");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile saved successfully!")),
        );

        nameController.clear();
        ageController.clear();
        additional_infoController.clear();
        setState(() {
          selectedsex = null;
          neuro_cat.clear();
        });
        print("Going to next screen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChildSetupScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving profile: ${response.body}")),
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
      appBar: AppBar(
        title: const Text(
          "Profile Setup",
          style: TextStyle(
            color: Color(0xFFF93A6D),
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF93A6D)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "What is your child's name?",
                        labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: Color(0xFFF93A6D)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "How old is your child?",
                        labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: Color(0xFFF93A6D)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedsex,
                      decoration: const InputDecoration(
                        labelText: "How does your child identify?",
                        labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: Color(0xFFF93A6D)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                      ),
                      items:
                          sexs.map((sex) {
                            return DropdownMenuItem<String>(
                              value: sex,
                              child: Text(sex),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedsex = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Which neurodiversity best describe your child?",
                      style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          neuro_cats.map((category) {
                            return FilterChip(
                              label: Text(category),
                              selected: neuro_cat.contains(category),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    neuro_cat.add(category);
                                  } else {
                                    neuro_cat.remove(category);
                                  }
                                });
                              },
                              selectedColor: const Color(0xFFF93A6D),
                              backgroundColor: Colors.transparent,
                              labelStyle: TextStyle(
                                color:
                                    neuro_cat.contains(category)
                                        ? Colors.white
                                        : const Color(0xFFB0B0B0),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Would you like to share any additional additional_info about your child's needs or preferences?",
                      style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: additional_infoController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          borderSide: BorderSide(color: Color(0xFFF93A6D)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        hintText: "Type here...",
                        hintStyle: TextStyle(color: Color(0xFFB0B0B0)),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF93A6D),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Save and Next",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

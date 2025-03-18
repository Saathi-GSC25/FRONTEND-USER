import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  List<String> categories = [
    "Autism Spectrum Disorder",
    "ADHD",
    "Dyslexia",
    "Dyspraxia",
    "Dyscalculia",
    "Tourette Syndrome",
    "Other",
  ];

  List<String> genders = ["Female", "Male", "Others"];

  String? selectedGender;
  List<String> selectedCategories = [];

  void saveProfile() async {
    String name = nameController.text.trim();
    int age = int.tryParse(ageController.text.trim()) ?? 0;
    String gender = selectedGender ?? '';
    String details = detailsController.text.trim();

    if (name.isEmpty ||
        age == 0 ||
        gender.isEmpty ||
        selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('children').add({
        'name': name,
        'age': age,
        'gender': gender,
        'categories': selectedCategories, // Save multiple categories
        'details': details,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );

      nameController.clear();
      ageController.clear();
      detailsController.clear();
      setState(() {
        selectedGender = null;
        selectedCategories.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving profile: $e")));
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
                      value: selectedGender,
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
                          genders.map((gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Which neurodiversity categories best describe your child?",
                      style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          categories.map((category) {
                            return FilterChip(
                              label: Text(category),
                              selected: selectedCategories.contains(category),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                              },
                              selectedColor: const Color(0xFFF93A6D),
                              backgroundColor: Colors.transparent,
                              labelStyle: TextStyle(
                                color:
                                    selectedCategories.contains(category)
                                        ? Colors.white
                                        : const Color(0xFFB0B0B0),
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Would you like to share any additional details about your child's needs or preferences?",
                      style: TextStyle(fontSize: 16, color: Color(0xFFB0B0B0)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: detailsController,
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

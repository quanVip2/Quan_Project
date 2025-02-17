import 'package:flutter/material.dart';

class SignUpGenderScreen extends StatefulWidget {
  const SignUpGenderScreen({Key? key}) : super(key: key);

  @override
  State<SignUpGenderScreen> createState() => _SignUpGenderScreenState();
}

class _SignUpGenderScreenState extends State<SignUpGenderScreen> {
  String _selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
        title: const Text(
          "Create account",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your gender?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildGenderOption("Female"),
                _buildGenderOption("Male"),
                _buildGenderOption("Non-binary"),
                _buildGenderOption("Other"),
                _buildGenderOption("Prefer not to say"),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup_name');
                  print("Selected gender: $_selectedGender");
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    final bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

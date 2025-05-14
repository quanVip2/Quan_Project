import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sign_up_provider.dart';

class SignUpGenderScreenGG extends StatefulWidget {
  final String idToken;
  const SignUpGenderScreenGG({super.key, required this.idToken});

  @override
  State<SignUpGenderScreenGG> createState() => _SignUpGenderScreenState();
}

class _SignUpGenderScreenState extends State<SignUpGenderScreenGG> {
  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    print("Received ID Token: ${widget.idToken}");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
                _buildGenderOption(signUpProvider, "Female"),
                _buildGenderOption(signUpProvider, "Male"),
                _buildGenderOption(signUpProvider, "Non-binary"),
                _buildGenderOption(signUpProvider, "Other"),
                _buildGenderOption(signUpProvider, "Prefer not to say"),
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
                  print("Selected gender: ${signUpProvider.gender}");
                  Navigator.pushNamed(context, '/signup_name_gg',
                      arguments: {'idToken': widget.idToken});
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

  Widget _buildGenderOption(SignUpProvider provider, String genderOption) {
    // Chuyển giá trị sang chữ thường để phù hợp với API (ví dụ: "male", "female")
    final String normalizedGender = genderOption.toLowerCase();
    final bool isSelected = provider.gender.toLowerCase() == normalizedGender;

    return GestureDetector(
      onTap: () {
        setState(() {
          provider.setGender(normalizedGender);
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
          genderOption,
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

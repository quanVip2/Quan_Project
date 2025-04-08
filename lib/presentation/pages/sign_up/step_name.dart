import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sign_up_provider.dart';
import 'package:untitled/navigations/tabbar.dart';

class SignUpNameScreen extends StatefulWidget {
  const SignUpNameScreen({Key? key}) : super(key: key);

  @override
  State<SignUpNameScreen> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _optOutMarketing = false;
  bool _shareRegistrationData = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "What's your name?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: "Enter your name",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "This appears on your Spotify profile.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "By tapping 'Create account', you agree to the Spotify Terms of Use.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Logic cho "Terms of Use"
              },
              child: const Text(
                "Terms of Use",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "To learn more about how Spotify collects, uses, shares and protects your personal data, please see the Spotify Privacy Policy.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // Logic cho "Privacy Policy"
              },
              child: const Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _optOutMarketing,
                  onChanged: (bool? value) {
                    setState(() {
                      _optOutMarketing = value!;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const Expanded(
                  child: Text(
                    "I would prefer not to receive marketing messages from Spotify.",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _shareRegistrationData,
                  onChanged: (bool? value) {
                    setState(() {
                      _shareRegistrationData = value!;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const Expanded(
                  child: Text(
                    "Share my registration data with Spotify's content providers for marketing purposes.",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  // Lưu thông tin vào provider
                  signUpProvider.setName(_nameController.text);
                  signUpProvider.setOptOutMarketing(_optOutMarketing);
                  signUpProvider.setShareRegistrationData(_shareRegistrationData);

                  // Gọi API đăng ký
                  try {
                    bool success = await signUpProvider.registerUser();
                    if (success) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Tabbar()),
                    );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đăng ký thất bại, vui lòng thử lại")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đăng ký thất bại, vui lòng thử lại")),
                    );
                    print(e); // In ra để debug lỗi
                  }

                },

                child: const Text(
                  "Create account",
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/sign_up_provider.dart';
import 'package:untitled/navigations/tabbar.dart';

class SignUpNameScreenGG extends StatefulWidget {
  final String idToken;

  const SignUpNameScreenGG({super.key, required this.idToken});

  @override
  State<SignUpNameScreenGG> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreenGG> {
  final TextEditingController _nameController = TextEditingController();
  bool _optOutMarketing = false;
  bool _shareRegistrationData = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Hiển thị SnackBar sau khi frame hiện tại được dựng xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không lấy được idToken từ Google")),
      );
    });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  // Log để kiểm tra idToken
                  print(
                      "1.Received ID Token: ${widget.idToken}"); // Log idToken tại đây

                  // Lưu thông tin vào provider
                  signUpProvider.setName(_nameController.text);
                  signUpProvider.setOptOutMarketing(_optOutMarketing);
                  signUpProvider
                      .setShareRegistrationData(_shareRegistrationData);

                  // Lấy các thông tin từ các màn hình trước (Ngày sinh, giới tính)
                  final birthday = signUpProvider
                      .dateOfBirth; // Truy cập thông tin ngày sinh
                  final gender =
                      signUpProvider.gender; // Truy cập thông tin giới tính

                  // Kiểm tra nếu tên trống
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Vui lòng nhập tên của bạn.")),
                    );
                    return;
                  }

                  try {
                    // Gọi API đăng ký với thông tin Google
                    final response = await signUpProvider.registerWithGoogle(
                      idToken: widget.idToken,
                      // Gửi idToken từ Google Sign-In
                      userName: _nameController.text,
                      birthday: birthday,
                      gender: gender,
                    );

                    // Kiểm tra nếu có dữ liệu trả về từ API
                    if (response.containsKey('user') &&
                        response.containsKey('token')) {
                      // Lưu token và user vào provider hoặc local storage
                      final user = response['user'];
                      final token = response['token'];

                      // Điều hướng tới màn hình chính
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Tabbar()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Đăng ký thất bại, vui lòng thử lại")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi: ${e.toString()}")),
                    );
                    print(e); // In ra để debug lỗi
                  }
                },
                child: const Text(
                  "Create account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled/presentation/widgets/spotify_logo.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '20138720257-umfd2bjsiqeetuuv367jbgcpc5s8cgs7.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // Hàm xử lý đăng nhập và đăng ký với Google
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      // Đăng xuất Google nếu có tài khoản đang đăng nhập
      await _googleSignIn.signOut();

      // Yêu cầu người dùng đăng nhập bằng Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Nếu người dùng huỷ đăng nhập
        return;
      }

      // Lấy thông tin authentication từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      print("🟢 Google ID Token: $idToken"); // Log ra ID token

      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không lấy được idToken từ Google")),
        );
        return;
      }

      // Chuyển đến màn hình đăng ký với Google, truyền idToken
      Navigator.pushNamed(
        context,
        '/signup_dob_gg', // Đổi thành đường dẫn bạn muốn khi đăng ký thành công
        arguments: {'idToken': idToken}, // Truyền idToken vào màn hình sau
      );
    } catch (e) {
      // Thông báo lỗi khi có sự cố trong quá trình đăng nhập
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi đăng nhập Google: $e")));
    }
  }

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const LogoWidget(),
            const SizedBox(height: 18),
            // Tiêu đề
            const Text(
              "Sign up to start\nlistening",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // "Continue with email"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup_email');
              },
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text(
                "Continue with email",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // "Continue with phone number"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Logic cho "Continue with phone number"
              },
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text("Continue with phone number"),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with Google"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                _handleGoogleSignIn(context); // Gọi hàm xử lý đăng nhập Google
              },
              icon: const Icon(Icons.g_mobiledata, color: Colors.white),
              label: const Text("Continue with Google"),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with Facebook"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // Logic cho "Continue with Facebook"
              },
              icon: const Icon(Icons.facebook, color: Colors.blue),
              label: const Text("Continue with Facebook"),
            ),
            const Spacer(),
            // TextButton cho "Already have an account? Log in"
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: RichText(
                text: const TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Log in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '20138720257-umfd2bjsiqeetuuv367jbgcpc5s8cgs7.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // Dio instance
  final Dio dio = Dio();

  // Hàm đăng nhập với Google và gọi API
  Future<Map<String, dynamic>> loginWithGoogle({
    required String idToken,
  }) async {
    final url =
        'http://192.168.0.102:8080/app/auth/login-google'; // Thay bằng URL thực tế của API đăng nhập Google
    try {
      final response = await dio.post(url, data: {'idToken': idToken});

      final data = response.data;

      if (response.statusCode == 200 && data['status_code'] == 200) {
        final result = data['data'];

        if (result == null) {
          throw Exception('data không có trong phản hồi');
        }

        final token = result['token'];

        if (token == null) {
          throw Exception('token không có trong phản hồi');
        }

        final Map<String, dynamic> safeResult = {
          'token': token.toString(),
          'message': data['message'] != null
              ? data['message'].toString()
              : 'Đăng nhập Google thành công!',
        };

        return safeResult;
      } else {
        throw Exception(data['message'] ?? 'Đăng nhập Google thất bại');
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Lỗi không xác định từ server';
      throw Exception(message);
    } catch (e) {
      throw Exception('Đăng nhập Google thất bại: $e');
    }
  }

  // Hàm xử lý đăng nhập với Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Đăng nhập Google
      final GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user != null) {
        // Lấy token từ Google
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        final idToken = googleAuth.idToken;

        if (idToken == null) {
          throw Exception('Không thể lấy ID token từ Google');
        }

        // Gọi API đăng nhập Google
        final result = await loginWithGoogle(idToken: idToken);

        final token = result['token'];

        // Lưu token hoặc xử lý sau khi đăng nhập thành công
        print('Token đăng nhập: $token');

        // Điều hướng tới màn hình chính hoặc nơi cần thiết
        Navigator.pushNamed(context, '/home'); // Điều hướng tới màn hình chính
      } else {
        // Người dùng hủy đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng nhập Google bị hủy")),
        );
      }
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
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
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const Icon(
              Icons.music_note, // Thay bằng logo cụ thể nếu có
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 20),
            // Tiêu đề
            const Text(
              "Log in to\nSpotify",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Nút "Continue with email"
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/login_email'); // Điều hướng tới LoginEmailScreen
              },
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text(
                "Continue with email",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            // Nút "Continue with phone number"
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
                _signInWithGoogle(context); // Gọi hàm đăng nhập với Google
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
            // TextButton cho "Don't have an account? Sign up"
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/signup'); // Điều hướng tới màn hình đăng ký
              },
              child: RichText(
                text: const TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign up",
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

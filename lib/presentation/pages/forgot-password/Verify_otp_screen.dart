import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    const String apiUrl = "http://10.0.2.2:8080/auth/check-otp";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "otp": _otpController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'];
        if (data != null && data is Map<String, dynamic>) {
          final token = data['token'];
          if (token != null && token is String) {
            Navigator.pushReplacementNamed(
              context,
              '/reset-password',
              arguments: {
                'email': widget.email,
                'token': token,
              },
            );
          } else {
            _showError("Token không hợp lệ từ server.");
          }
        } else {
          _showError("Dữ liệu từ server không đúng định dạng.");
        }
      } else {
        _showError(responseData["message"] ?? "OTP verification failed");
      }
    } catch (e) {
      print("Error: $e");
      _showError("Lỗi kết nối đến server");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Enter OTP", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter the OTP sent to your email",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: "6-digit OTP",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1DB954), // Spotify Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _verifyOtp,
                      child: const Text("Verify OTP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

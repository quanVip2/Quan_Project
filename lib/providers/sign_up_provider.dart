import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _dateOfBirth = "";
  String _gender = "";
  String _name = "";
  bool _optOutMarketing = false;
  bool _shareRegistrationData = false;

  String get email => _email;
  String get password => _password;
  String get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get name => _name;
  bool get optOutMarketing => _optOutMarketing;
  bool get shareRegistrationData => _shareRegistrationData;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setDateOfBirth(String dob) {
    _dateOfBirth = dob;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setOptOutMarketing(bool value) {
    _optOutMarketing = value;
    notifyListeners();
  }

  void setShareRegistrationData(bool value) {
    _shareRegistrationData = value;
    notifyListeners();
  }

  Future<bool> registerUser() async {
  final url = Uri.parse("http://10.0.2.2:8080/auth/register");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _email,
        "password": _password,
        "birthday": _dateOfBirth, // lưu giá trị birthday ở đây
        "gender": _gender,
        "fullName": _name,
        "userName": _name, // Nếu không có trường riêng cho userName, bạn có thể dùng _name hoặc thêm trường mới vào provider
      }),
    );

    final responseData = jsonDecode(response.body);

    print("Phản hồi từ backend: ${response.statusCode}");
    print("Nội dung body: $responseData");

    // Kiểm tra nếu status_code == 200 và message == "success"
    if (response.statusCode == 200 && responseData['status_code'] == 200 && responseData['message'] == "success") {
      return true;
    } else {
      print("Đăng ký thất bại: ${responseData['message']}");
      return false;
    }
  } catch (e) {
    print("Lỗi trong `registerUser()`: $e");
    return false;
  }
}

}

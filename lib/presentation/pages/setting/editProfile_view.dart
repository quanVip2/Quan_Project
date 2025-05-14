import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  String _selectedGender = "Male";
  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  String _password = "********"; // Hiển thị mật khẩu ẩn
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print("Token không tồn tại");
      setState(() => _isLoading = false);
      return;
    }

    const String apiUrl = "http://10.0.2.2:8080/app/auth/profile";
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = data['data'];

        setState(() {
          _fullNameController.text = profile['fullName'] ?? '';
          _selectedGender = _formatGender(profile['gender']);
          _password = "********"; // Mật khẩu không hiển thị thực tế

          if (profile['birthday'] != null) {
            DateTime birthDate = DateTime.parse(profile['birthday']);
            _selectedDay = birthDate.day;
            _selectedMonth = birthDate.month;
            _selectedYear = birthDate.year;
          }
        });
      } else {
        print("Lỗi lấy profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi kết nối API: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatGender(String? gender) {
    switch (gender?.toLowerCase()) {
      case "male":
        return "Male";
      case "female":
        return "Female";
      case "non-binary":
        return "Non-binary";
      case "other":
        return "Other";
      default:
        return "Prefer not to say";
    }
  }

  Future<void> _updateUserProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print("Token không tồn tại");
      return;
    }

    String? birthday;
    if (_selectedDay != null && _selectedMonth != null && _selectedYear != null) {
      birthday = "$_selectedYear-${_selectedMonth!.toString().padLeft(2, '0')}-${_selectedDay!.toString().padLeft(2, '0')}";
    }

    const String apiUrl = "http://10.0.2.2:8080/app/user/update";
    final body = {
      "fullName": _fullNameController.text.trim(),
      "gender": _selectedGender.toLowerCase(),
      "birthday": birthday,
    };

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Cập nhật hồ sơ thành công!");
        Navigator.pop(context);
      } else {
        print("Lỗi cập nhật hồ sơ: ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối API: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Chỉnh sửa hồ sơ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  _buildTitle("Tên đầy đủ"),
                  _buildTextField(_fullNameController),
                  _buildTitle("Mật khẩu"),
                  _buildDisabledTextField(_password),
                  _buildTitle("Giới tính"),
                  _buildDropdown(
                    ["Female", "Male", "Non-binary", "Other", "Prefer not to say"], 
                    _selectedGender, 
                    (value) => setState(() => _selectedGender = value!),
                  ),
                  _buildTitle("Ngày sinh"),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown(List.generate(31, (i) => "${i + 1}"), _selectedDay?.toString(), (v) => setState(() => _selectedDay = int.parse(v!)), hint: "Ngày")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown(List.generate(12, (i) => "Tháng ${i + 1}"), _selectedMonth != null ? "Tháng $_selectedMonth" : null, (v) => setState(() => _selectedMonth = int.parse(v!.split(" ")[1])), hint: "Tháng")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown(List.generate(100, (i) => "${DateTime.now().year - i}"), _selectedYear?.toString(), (v) => setState(() => _selectedYear = int.parse(v!)), hint: "Năm")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(),
    );
  }

  Widget _buildDisabledTextField(String value) {
    return TextField(
      controller: TextEditingController(text: value),
      enabled: false,
      style: const TextStyle(color: Colors.grey),
      decoration: _inputDecoration(),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedValue, ValueChanged<String?> onChanged, {String? hint}) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      dropdownColor: Colors.black,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
      items: items.map((String value) => DropdownMenuItem(value: value, child: Text(value, style: const TextStyle(color: Colors.white)))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _updateUserProfile,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
      child: const Text("Lưu hồ sơ", style: TextStyle(color: Colors.white)),
    );
  }

  InputDecoration _inputDecoration([String? hint]) {
    return InputDecoration(filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), hintText: hint, hintStyle: const TextStyle(color: Colors.white54));
  }
}

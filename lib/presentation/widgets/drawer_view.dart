import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/pages/drawer_Screen/Recent_screen.dart';
import 'package:untitled/presentation/pages/login/login_screen.dart';
import 'package:untitled/presentation/pages/profile_screen.dart';
import 'package:untitled/presentation/pages/drawer_Screen/setting_page.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  String userName = "Người dùng";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      print("Không tìm thấy token, không thể lấy thông tin người dùng");
      return;
    }

    const String apiUrl = "http://10.0.2.2:8080/auth/profile";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data["data"]?["userName"] ?? "Không có tên";
        });
      } else {
        print("Lỗi khi lấy profile: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/image/avatar.png"),
              ),
              title: Text(userName),
              subtitle: const Text('Xem hồ sơ'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            const Divider(color: Colors.white60, thickness: 0.2),
            ListTile(
              leading: const Icon(Icons.add_circle_outline_sharp),
              title: const Text('Thêm tài khoản'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb_outline_sharp),
              title: const Text("Bản phát hành mới"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_backup_restore_sharp),
              title: const Text('Gần đây'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RecentPlaysPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Cài đặt và quyền riêng tư'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}

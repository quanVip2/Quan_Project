import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/navigations/tabbar.dart';
import 'package:untitled/presentation/pages/login/login_screen.dart';
import 'package:untitled/presentation/pages/setting/account_view.dart';
import 'package:untitled/presentation/pages/setting/content_view.dart';
import 'package:untitled/presentation/pages/setting/introduct_view.dart';
import 'package:untitled/presentation/pages/setting/noification_view.dart';
import 'package:untitled/presentation/pages/setting/returnP_view.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // 🔥 Sử dụng đúng key

      if (token == null) {
        print("❌ Không tìm thấy token! Không thể đăng xuất.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bạn chưa đăng nhập hoặc token đã hết hạn."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print("🔑 Token trước khi logout: $token"); // Debug token

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/auth/logout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Server Response: ${response.statusCode}, ${response.body}"); // Debug response

      if (response.statusCode == 200) {
        print("✅ Đăng xuất thành công!");

        await prefs.remove('auth_token'); // Xóa token

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        print("❌ Lỗi khi đăng xuất! Status: ${response.statusCode}, Response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi đăng xuất: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("❌ Lỗi đăng xuất: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined))
        ],
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        'Tài khoản miễn phí',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Dùng Premium',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Tài khoản'),
                subtitle: Text('Tên người dùng'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AccountPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.music_note_outlined),
                title: Text('Nội dung và chế độ hiển thị'),
                subtitle: Text('Canvas • Ngôn ngữ của ứng dụng'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ContentDisplaySettingsPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.repeat, color: Colors.white),
                title: Text('Phát Lại'),
                subtitle: Text('Phát liên tục • Tự động phát'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaybackSettingsPage()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.bell),
                title: Text('Thông báo'),
                subtitle: Text('Thông báo • Email'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationSettingsPage()));
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.info),
                title: Text('Giới thiệu'),
                subtitle: Text('Chính sách quyền riêng tư'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              )
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: _logout, // Gọi API logout khi nhấn nút
              child: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

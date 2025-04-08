import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Đang tải...";
  String userEmail = "Đang tải...";

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

        final profileData = data['data'];
        if (profileData == null) {
          print("Dữ liệu API không hợp lệ: ${response.body}");
          return;
        }

        setState(() {
          userName = profileData['userName'] ?? "Không có tên";
          userEmail = profileData['email'] ?? "Không có email";
          userEmail = profileData['email'] ?? "Không có email";

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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x9E3D4E47),
            Color(0x9E000000),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            Icon(Icons.more_vert),
            SizedBox(width: 16),
          ],
          backgroundColor: Colors.black26,
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildPlaylistSection(),
            const SizedBox(height: 20),
            _buildViewAllButton(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/image/avatar.png'),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '0 người theo dõi • Đang theo dõi 0',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print('Chỉnh sửa hồ sơ');
              },
              child: const Text('Chỉnh sửa'),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                print('Chia sẻ hồ sơ');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaylistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Danh sách phát',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Image.asset('assets/image/album1.jpg', width: 50, height: 50),
          title: Text(userName),
          subtitle: Text('0 lượt lưu • $userEmail'),
          onTap: () {
            print('Mở danh sách phát');
          },
        ),
      ],
    );
  }

  Widget _buildViewAllButton() {
    return ElevatedButton(
      onPressed: () {
        print('Xem tất cả danh sách phát');
      },
      child: const Text('Xem tất cả danh sách phát'),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        print("Chuyển đến tab $index");
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music_outlined),
          label: 'Your Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.workspace_premium),
          label: 'Premium',
        ),
      ],
    );
  }
}

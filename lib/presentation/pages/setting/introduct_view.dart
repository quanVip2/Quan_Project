import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn trước
          },
        ),
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildVersionTile(),
          _buildListTile('Chính sách quyền riêng tư'),
          _buildListTile('Giấy phép bên thứ ba'),
          _buildListTile('Điều khoản sử dụng'),
          _buildListTile('Quy tắc trên nền tảng'),
          _buildListTile('Hỗ trợ'),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget tạo ListTile cho mục phiên bản
  Widget _buildVersionTile() {
    return const Column(
      children: [
        ListTile(
          title: Text('Phiên bản', style: TextStyle(fontSize: 16)),
          trailing: Text('1.0.00.001', style: TextStyle(fontSize: 14, color: Colors.white70)),
        ),
        Divider(color: Colors.white24, thickness: 0.5),
      ],
    );
  }

  // Widget tạo ListTile cho các tùy chọn
  Widget _buildListTile(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
          onTap: () {
            print('Điều hướng đến: $title');
          },
        ),
        const Divider(color: Colors.white24, thickness: 0.5),
      ],
    );
  }

  // Widget tạo Bottom Navigation Bar giống Spotify
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Giả định trang hiện tại là "Premium"
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

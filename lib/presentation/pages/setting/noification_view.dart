import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Chọn thông báo đẩy và email thông báo mà bạn muốn nhận',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
          _buildNotificationTile('Âm nhạc và nghệ sĩ', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Podcast và chương trình', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Thông báo có tập mới', 'Chưa theo dõi chương trình nào'),
          _buildNotificationTile('Sách nói', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Buổi biểu diễn và sự kiện trực tiếp', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Buổi phát trực tiếp và sự kiện trực tuyến', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Bình luận', 'Đang tắt'),
          _buildNotificationTile('Trải nghiệm dùng Spotify dành cho bạn', 'Thông báo đẩy · Email'),
          _buildNotificationTile('Hàng hóa của nghệ sĩ và nhà sáng tạo', 'Thông báo đẩy · Email'),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget tạo ListTile cho từng mục thông báo
  Widget _buildNotificationTile(String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 16)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
          onTap: () {
            print('Điều hướng đến cài đặt: $title');
          },
        ),
        const Divider(color: Colors.white24, thickness: 0.5),
      ],
    );
  }

  // Widget tạo Bottom Navigation Bar giống Spotify
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3, // Giả định trang hiện tại là "Premium"
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

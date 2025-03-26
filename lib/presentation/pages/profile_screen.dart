import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x9E3D4E47), // Màu xanh xám với 62% độ đậm
          Color(0x9E000000), // Màu dưới cùng (đen)
        ],
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent, // Để gradient hiển thị
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn trước
          },
        ),
        actions: const [
          Icon(Icons.more_vert), // Biểu tượng menu tùy chọn
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(), // Ảnh đại diện + Tên người dùng
          const SizedBox(height: 20),
          _buildPlaylistSection(), // Danh sách phát
          const SizedBox(height: 20),
          _buildViewAllButton(), // Nút "Xem tất cả danh sách phát"
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    ),
  );
}


  // Widget phần header (Ảnh đại diện + Thông tin người dùng)
  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/image/album1.jpg'), // Ảnh người dùng
        ),
        const SizedBox(height: 10),
        const Text(
          'Nguyenhongquan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text(
          '0 người theo dõi • Đang theo dõi 0',
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        // Nút "Chỉnh sửa" + Chia sẻ
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

  // Widget phần danh sách phát
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
          leading: Image.asset('assets/image/album2.jpg', width: 50, height: 50), // Ảnh danh sách phát
          title: const Text('Quan'),
          subtitle: const Text('0 lượt lưu • Nguyenhongquan'),
          onTap: () {
            print('Mở danh sách phát');
          },
        ),
      ],
    );
  }

  // Nút "Xem tất cả danh sách phát"
  Widget _buildViewAllButton() {
    return ElevatedButton(
      onPressed: () {
        print('Xem tất cả danh sách phát');
      },
      child: const Text('Xem tất cả danh sách phát'),
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

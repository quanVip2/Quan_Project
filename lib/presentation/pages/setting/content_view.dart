import 'package:flutter/material.dart';

class ContentDisplaySettingsPage extends StatefulWidget {
  const ContentDisplaySettingsPage({Key? key}) : super(key: key);

  @override
  State<ContentDisplaySettingsPage> createState() => _ContentDisplaySettingsPageState();
}

class _ContentDisplaySettingsPageState extends State<ContentDisplaySettingsPage> {
  bool allowExplicitContent1 = true;
  bool allowExplicitContent2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nội dung và chế độ hiển thị'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn trước
          },
        ),
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Lựa chọn ưu tiên về nội dung',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildSwitchTile(
              title: 'Cho phép nội dung phản cảm',
              subtitle: 'Có thể phát nội dung phản cảm',
              value: allowExplicitContent1,
              onChanged: (val) {
                setState(() => allowExplicitContent1 = val);
              },
            ),
            _buildSwitchTile(
              title: 'Cho phép nội dung phản cảm',
              subtitle: 'Có thể phát nội dung phản cảm',
              value: allowExplicitContent2,
              onChanged: (val) {
                setState(() => allowExplicitContent2 = val);
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Lựa chọn ưu tiên về nội dung',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Cho phép nội dung phản cảm', style: TextStyle(fontSize: 16)),
              subtitle: const Text('Có thể phát nội dung phản cảm', style: TextStyle(fontSize: 12, color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
              onTap: () {
                print('Điều hướng đến trang cài đặt nội dung');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Widget tạo ListTile có Switch
  Widget _buildSwitchTile({required String title, String? subtitle, required bool value, required Function(bool) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)) : null,
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white, // Màu của nút bật (trắng)
          activeTrackColor: Colors.green,
        ),
        const Divider(color: Color.fromARGB(166, 255, 255, 255), thickness: 0.5),
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

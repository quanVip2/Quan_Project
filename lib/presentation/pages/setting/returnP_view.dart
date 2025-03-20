import 'package:flutter/material.dart';

class PlaybackSettingsPage extends StatefulWidget {
  const PlaybackSettingsPage({Key? key}) : super(key: key);

  @override
  State<PlaybackSettingsPage> createState() => _PlaybackSettingsPageState();
}

class _PlaybackSettingsPageState extends State<PlaybackSettingsPage> {
  bool isPictureInPicture = true;
  bool isContinuousPlay = true;
  bool isAutoMix = true;
  bool isNormalizeAudio = true;
  bool isMonoAudio = false;
  bool isControlSounds = true;
  bool isAutoPlaySimilar = true;
  double crossfadeValue = 6.0; // Giá trị mặc định của slider

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phát lại'),
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
            _buildSwitchTile(
              title: 'Hình trong hình',
              value: isPictureInPicture,
              onChanged: (val) {
                setState(() => isPictureInPicture = val);
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Chuyển bài',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: crossfadeValue,
              min: 0,
              max: 12,
              divisions: 12,
              label: '${crossfadeValue.round()}s',
              onChanged: (val) {
                setState(() => crossfadeValue = val);
              },
            ),
            _buildSwitchTile(
              title: 'Phát Liên tục',
              value: isContinuousPlay,
              onChanged: (val) {
                setState(() => isContinuousPlay = val);
              },
            ),
            _buildSwitchTile(
              title: 'Tự động phối',
              subtitle: 'Cho phép chuyển tiếp mượt mà giữa các bài hát trong danh sách phát tuyển chọn',
              value: isAutoMix,
              onChanged: (val) {
                setState(() => isAutoMix = val);
              },
            ),
            _buildSwitchTile(
              title: 'Bật chế độ chuẩn hóa âm thanh',
              value: isNormalizeAudio,
              onChanged: (val) {
                setState(() => isNormalizeAudio = val);
              },
            ),
            _buildSwitchTile(
              title: 'Đơn âm',
              subtitle: 'Thiết lập để loa trái và loa phải phát âm thanh giống nhau',
              value: isMonoAudio,
              onChanged: (val) {
                setState(() => isMonoAudio = val);
              },
            ),
            ListTile(
              leading: const Icon(Icons.equalizer, color: Colors.white70),
              title: const Text('Bộ chỉnh âm', style: TextStyle(fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
              onTap: () {
                print('Điều hướng đến Bộ chỉnh âm');
              },
            ),
            _buildSwitchTile(
              title: 'Phát âm thanh tín hiệu điều khiển',
              value: isControlSounds,
              onChanged: (val) {
                setState(() => isControlSounds = val);
              },
            ),
            _buildSwitchTile(
              title: 'Tự động phát nội dung tương tự',
              subtitle: 'Thưởng thức nhạc không gián đoạn. Chúng tôi sẽ phát một bài hát tương tự khi nhạc bạn đang nghe kết thúc',
              value: isAutoPlaySimilar,
              onChanged: (val) {
                setState(() => isAutoPlaySimilar = val);
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

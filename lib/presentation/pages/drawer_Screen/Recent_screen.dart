import 'package:flutter/material.dart';

class RecentPlaysPage extends StatefulWidget {
  const RecentPlaysPage({Key? key}) : super(key: key);

  @override
  State<RecentPlaysPage> createState() => _RecentPlaysPageState();
}

class _RecentPlaysPageState extends State<RecentPlaysPage> {
  Map<String, bool> isExpanded = {
    "Hôm Nay": true,
    "Hôm Qua": false,
    "Ngày 5 Tháng 2, 2025": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Nhạc", style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildMusicSection("Hôm Nay"),
            _buildMusicSection("Hôm Qua"),
            _buildMusicSection("Ngày 5 Tháng 2, 2025"),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded[title] = !(isExpanded[title] ?? false);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(
                isExpanded[title] == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 24,
              ),
            ],
          ),
        ),
        if (isExpanded[title] == true) _buildMusicList(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMusicList() {
    return Column(
      children: List.generate(5, (index) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://upload.wikimedia.org/wikipedia/en/9/9f/Your_Name_poster.png",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: const Text("Kiminonawa (Your Name)", style: TextStyle(fontSize: 16)),
          subtitle: const Text("Sparkle", style: TextStyle(fontSize: 14, color: Colors.white70)),
          trailing: const Icon(Icons.more_vert, color: Colors.white70),
        );
      }),
    );
  }
}

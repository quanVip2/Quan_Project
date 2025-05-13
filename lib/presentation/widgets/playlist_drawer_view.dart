import 'package:flutter/material.dart';

class PlaylistDrawerView extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlaylistDrawerView({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Tùy chọn Playlist',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Sửa playlist', style: TextStyle(color: Colors.white)),
              onTap: onEdit,
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa playlist', style: TextStyle(color: Colors.white)),
              onTap: onDelete,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';

class EditPlaylistPage extends StatefulWidget {
  final String initialName;
  final String? imageUrl;
  final String initialDescription;
  final void Function(String newName, String newDescription) onSave;

  const EditPlaylistPage({
    super.key,
    required this.initialName,
    this.imageUrl,
    required this.initialDescription,
    required this.onSave,
  });

  @override
  State<EditPlaylistPage> createState() => _EditPlaylistPageState();
}

class _EditPlaylistPageState extends State<EditPlaylistPage> {
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        title: const Text('Chỉnh sửa Playlist', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final newName = _nameController.text.trim();
              final newDesc = _descController.text.trim();
              if (newName.isNotEmpty) {
                widget.onSave(newName, newDesc);
                Navigator.of(context).pop('updated');
              }
            },
            child: const Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Center(
                child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(widget.imageUrl!, width: 160, height: 160, fit: BoxFit.cover),
                      )
                    : Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.music_note, color: Colors.white, size: 80),
                      ),
              ),
              const SizedBox(height: 16),
              const Text('Thay đổi hình ảnh', style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tên playlist',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 3,
                minLines: 1,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Thêm mô tả cho playlist',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
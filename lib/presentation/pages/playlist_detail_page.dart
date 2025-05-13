import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/bloc/auth_bloc.dart';
import '../../features/bloc/auth_state.dart';
import 'musicPlayer_page.dart';
import '../../features/library/data/repositories/playlist_repository.dart';
import '../../presentation/widgets/playlist_drawer_view.dart';
import '../../presentation/widgets/edit_playlist_page.dart';

class PlaylistDetailPage extends StatefulWidget {
  final int playlistId;
  final String playlistName;
  final String ownerName;
  final String? imageUrl;
  final String description;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.ownerName,
    this.imageUrl,
    required this.description,
  });

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  bool isLoading = true;
  String? error;
  List<Map<String, dynamic>> songs = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String playlistName = '';
  String playlistDescription = '';

  @override
  void initState() {
    super.initState();
    playlistName = widget.playlistName;
    playlistDescription = widget.description;
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final playlistRepository = PlaylistRepository();
      final fetchedSongs = await playlistRepository.getMusicsByPlaylistId(context, widget.playlistId);
      setState(() {
        songs = fetchedSongs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Lỗi: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSongs = songs.isNotEmpty;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        drawer: PlaylistDrawerView(
          onEdit: () {
            Navigator.pop(context); // Đóng bottom sheet
            Future.delayed(Duration.zero, () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditPlaylistPage(
                    initialName: playlistName,
                    imageUrl: widget.imageUrl,
                    initialDescription: playlistDescription,
                    onSave: (newName, newDesc) async {
                      try {
                        final repo = PlaylistRepository();
                        await repo.updatePlaylistInfo(context, widget.playlistId, newName, newDesc);
                        setState(() {
                          playlistName = newName;
                          playlistDescription = newDesc;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã cập nhật playlist!'), backgroundColor: Colors.green),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                        );
                      }
                    },
                  ),
                ),
              );
              if (result == 'updated') {
                Navigator.of(context).pop('updated');
              }
            });
          },
          onDelete: () async {
            final bool? confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
                  content: const Text('Bạn có chắc chắn muốn xóa playlist này không?', style: TextStyle(color: Colors.white)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              try {
                final playlistRepository = PlaylistRepository();
                final success = await playlistRepository.deletePlaylist(context, widget.playlistId);
                if (success) {
                  Navigator.of(context).pop('deleted');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white),
              onPressed: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (sheetContext) => PlaylistDrawerView(
                    onEdit: () {
                      Navigator.pop(sheetContext); // Đóng bottom sheet
                      Future.delayed(Duration.zero, () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditPlaylistPage(
                              initialName: playlistName,
                              imageUrl: widget.imageUrl,
                              initialDescription: playlistDescription,
                              onSave: (newName, newDesc) async {
                                try {
                                  final repo = PlaylistRepository();
                                  await repo.updatePlaylistInfo(context, widget.playlistId, newName, newDesc);
                                  setState(() {
                                    playlistName = newName;
                                    playlistDescription = newDesc;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Đã cập nhật playlist!'), backgroundColor: Colors.green),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                        if (result == 'updated') {
                          Navigator.of(context).pop('updated');
                        }
                      });
                    },
                    onDelete: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
                            content: const Text('Bạn có chắc chắn muốn xóa playlist này không?', style: TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        try {
                          final playlistRepository = PlaylistRepository();
                          final success = await playlistRepository.deletePlaylist(context, widget.playlistId);
                          if (success) {
                            Navigator.of(context).pop('deleted');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
                if (result == 'deleted') {
                  if (mounted) {
                    Navigator.of(context).pop('deleted');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã xóa playlist thành công'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh playlist
                      Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey[900]!, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(widget.imageUrl!, width: 180, height: 180, fit: BoxFit.cover),
                                )
                              : Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.music_note, color: Colors.white, size: 80),
                                ),
                        ),
                      ),
                      // Tên playlist, user, thời lượng
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlistName,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.green,
                                  child: Text('Q', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 8),
                                Text(widget.ownerName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 12),
                                const Icon(Icons.public, color: Colors.white38, size: 16),
                                const SizedBox(width: 4),
                                Text('0phút', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
                                Builder(
                                  builder: (context) => IconButton(
                                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                                    onPressed: () async {
                                      final result = await showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (sheetContext) => PlaylistDrawerView(
                                          onEdit: () {
                                            Navigator.pop(sheetContext); // Đóng bottom sheet
                                            Future.delayed(Duration.zero, () async {
                                              final result = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => EditPlaylistPage(
                                                    initialName: playlistName,
                                                    imageUrl: widget.imageUrl,
                                                    initialDescription: playlistDescription,
                                                    onSave: (newName, newDesc) async {
                                                      try {
                                                        final repo = PlaylistRepository();
                                                        await repo.updatePlaylistInfo(context, widget.playlistId, newName, newDesc);
                                                        setState(() {
                                                          playlistName = newName;
                                                          playlistDescription = newDesc;
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Đã cập nhật playlist!'), backgroundColor: Colors.green),
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                              if (result == 'updated') {
                                                Navigator.of(context).pop('updated');
                                              }
                                            });
                                          },
                                          onDelete: () async {
                                            final bool? confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.grey[900],
                                                  title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
                                                  content: const Text('Bạn có chắc chắn muốn xóa playlist này không?', style: TextStyle(color: Colors.white)),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Hủy', style: TextStyle(color: Colors.white)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirm == true) {
                                              try {
                                                final playlistRepository = PlaylistRepository();
                                                final success = await playlistRepository.deletePlaylist(context, widget.playlistId);
                                                if (success) {
                                                  Navigator.of(context).pop('deleted');
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Lỗi: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      );
                                      if (result == 'deleted') {
                                        if (mounted) {
                                          Navigator.of(context).pop('deleted');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Đã xóa playlist thành công'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!hasSongs) ...[
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Hãy bắt đầu tạo danh sách phát của bạn',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {},
                            child: const Text('Thêm vào danh sách phát này', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white10,
                                  foregroundColor: Colors.white,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {},
                                child: const Text('+ Thêm'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white10,
                                  foregroundColor: Colors.white,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {},
                                child: const Text('Chỉnh sửa'),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.shuffle, color: Colors.green, size: 32),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill, color: Colors.green, size: 44),
                                onPressed: () async {
                                  if (songs.isEmpty) return;
                                  final repo = PlaylistRepository();
                                  final firstMusicId = songs[0]['id'];
                                  final playId = await repo.playlistPlay(context, firstMusicId, widget.playlistId);
                                  if (playId != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MusicPlayerPage(musicId: playId, playlistId: widget.playlistId),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Không thể phát playlist này!'), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // Danh sách bài hát
                        Expanded(
                          child: ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              return ListTile(
                                leading: song['imageUrl'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(song['imageUrl'], width: 48, height: 48, fit: BoxFit.cover),
                                      )
                                    : Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.music_note, color: Colors.white),
                                      ),
                                title: Text(song['title'] ?? '', style: const TextStyle(color: Colors.white)),
                                subtitle: Text(song['artist'] ?? '', style: const TextStyle(color: Colors.white70)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert, color: Colors.white),
                                  onPressed: () {},
                                ),
                                onTap: () {
                                  final musicId = song['musicId'] ?? song['id'];
                                  int? id;
                                  if (musicId is int) {
                                    id = musicId;
                                  } else if (musicId is String) {
                                    id = int.tryParse(musicId);
                                  }
                                  if (id == null) {
                                    _scaffoldKey.currentState?.showSnackBar(
                                      const SnackBar(content: Text('Bài hát không hợp lệ!')),
                                    );
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MusicPlayerPage(musicId: id!, playlistId: widget.playlistId),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
        floatingActionButton: hasSongs
            ? FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                onPressed: () async {
                  if (songs.isEmpty) return;
                  final repo = PlaylistRepository();
                  final firstMusicId = songs[0]['id'];
                  final playId = await repo.playlistPlay(context, firstMusicId, widget.playlistId);
                  if (playId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MusicPlayerPage(musicId: playId, playlistId: widget.playlistId),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không thể phát playlist này!'), backgroundColor: Colors.red),
                    );
                  }
                },
              )
            : null,
      ),
    );
  }
} 
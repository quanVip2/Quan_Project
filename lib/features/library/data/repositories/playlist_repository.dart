import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';
import '../../../bloc/auth_state.dart';
import '../models/playlist_model.dart';

class PlaylistRepository {
  final String baseUrl = 'http://10.0.2.2:8080/app';

  String? _getToken(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      return state.token;
    }
    return null;
  }

  Future<List<PlaylistModel>> getPlaylistsByUserId(BuildContext context, String userId) async {
    final token = _getToken(context);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/playlist/get-playlist-by-user-id'),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          return data.map((json) => PlaylistModel.fromJson(json)).toList();
        } else {
          throw Exception('Dữ liệu trả về từ server không hợp lệ: $decoded');
        }
      } else {
        throw Exception('Failed to load playlists');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<void> createPlaylist(BuildContext context) async {
    final token = _getToken(context);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/playlist/create-playlist'),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create playlist');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addMusicToPlaylist(BuildContext context, int playlistId, int musicId) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/playlist/add-music-to-playlist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'playlistId': playlistId,
          'musicId': musicId,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập đã hết hạn');
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy playlist hoặc bài hát');
      } else {
        throw Exception('Không thể thêm bài hát vào playlist: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm bài hát vào playlist: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMusicsByPlaylistId(BuildContext context, int playlistId) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/playlist/get-music-by-playlist-id/$playlistId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> data;
        if (decoded is Map && decoded['data'] != null) {
          data = decoded['data'];
        } else if (decoded is Map && decoded['body'] != null && decoded['body']['data'] != null) {
          data = decoded['body']['data'];
        } else {
          data = [];
        }
        return List<Map<String, dynamic>>.from(data);
      } else if (response.statusCode == 401) {
        throw Exception('Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn (401).');
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  Future<bool> deletePlaylist(BuildContext context, int? playlistId) async {
    if (playlistId == null) {
      throw Exception('playlistId bị null');
    }
    final authBloc = context.read<AuthBloc?>();
    if (authBloc == null) {
      throw Exception('AuthBloc không tồn tại trong context');
    }
    final authState = authBloc.state;
    if (authState is! AuthAuthenticated) {
      throw Exception('Người dùng chưa đăng nhập');
    }
    final token = authState.token;
    if (token == null) {
      throw Exception('Token xác thực bị null');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/playlist/delete-playlist/$playlistId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Lỗi khi xóa playlist: ${response.body}');
    }
  }

  Future<bool> updatePlaylistInfo(BuildContext context, int playlistId, String newName, String newDescription) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }
    final response = await http.patch(
      Uri.parse('$baseUrl/playlist/update-playlist/$playlistId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'name': newName, 'description': newDescription}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Lỗi khi cập nhật playlist: ${response.body}');
    }
  }

  Future<void> addMusicToLikeMusic(BuildContext context, int musicId) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/like-music/add-music-to-like-music'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'musicId': musicId}),
      );
      if (response.statusCode != 200) {
        throw Exception('Không thể thêm vào yêu thích: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm vào yêu thích: $e');
    }
  }

  Future<void> deleteMusicFromLikeMusic(BuildContext context, int musicId) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/like-music/delete/$musicId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Không thể xóa khỏi yêu thích: ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi xóa khỏi yêu thích: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLikedMusics(BuildContext context) async {
    final token = _getToken(context);
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/like-music/get-music-from-like-music'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'] ?? decoded['body']['data'];
        return List<Map<String, dynamic>>.from(data ?? []);
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }
} 
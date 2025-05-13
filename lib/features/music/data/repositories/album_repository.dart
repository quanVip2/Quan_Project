import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';
import '../../../bloc/auth_state.dart';

class AlbumRepository {
  static const String _defaultBaseUrl =
      'http://192.168.0.102:8080/app'; // Thay bằng URL thật của bạn
  final String baseUrl;

  AlbumRepository({String? baseUrl}) : baseUrl = baseUrl ?? _defaultBaseUrl;

  Future<AlbumModel> getAlbumDetail(BuildContext context, int id) async {
    final authState = context.read<AuthBloc>().state;
    String? token;
    if (authState is AuthAuthenticated) {
      token = authState.token;
    }
    print('Gọi API: $baseUrl/album/$id');
    final response = await http.get(
      Uri.parse('$baseUrl/album/$id'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final albumData = data['data'] ?? {};
      final albumJson = albumData['album'] ?? {};
      return AlbumModel.fromJson({
        ...albumJson,
        'musics': albumData['musics'] ?? [],
        'authors': albumData['authors'] ?? [],
        'categories': albumData['categories'] ?? [],
      });
    } else {
      print('API trả về lỗi: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load album');
    }
  }

  Future<List<AlbumModel>> getAlbums(BuildContext context) async {
    final List<AlbumModel> result = [];
    for (var id = 1; id <= 8; id++) {
      try {
        final album = await getAlbumDetail(context, id);
        result.add(album);
      } catch (e) {
        // Bỏ qua album lỗi
      }
    }
    return result;
  }

  Future<List<RecentAlbum>> fetchRecentlyPlayedAlbums(BuildContext context,
      {int offset = 0, int limit = 8}) async {
    final authState = context.read<AuthBloc>().state;
    String? token;
    if (authState is AuthAuthenticated) {
      token = authState.token;
    }

    final uri =
        Uri.parse('$baseUrl/home/recently/album?offset=$offset&limit=$limit');
    try {
      final resp = await http.get(uri, headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      });

      if (resp.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);
        final albums = (jsonResponse['data']['albums'] as List?) ?? [];
        return albums.map((e) => RecentAlbum.fromJson(e)).toList();
      } else {
        throw Exception('HTTP Error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi fetch recently played albums: $e');
      throw Exception('Failed to load recently played albums');
    }
  }
}

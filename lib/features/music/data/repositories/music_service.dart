  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import '../models/music_detail_model.dart';

  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:untitled/features/bloc/auth_bloc.dart'; 
  import 'package:untitled/features/bloc/auth_state.dart';
  import '../models/music.dart';

  class MusicService {
    Future<MusicDetail> fetchMusicDetail(BuildContext context, int id) async {
      final uri = Uri.parse('http://10.0.2.2:8080/app/music/play/$id');

      // 🔥 Lấy token từ AuthBloc
      final authState = context.read<AuthBloc>().state;
      String? token;
      if (authState is AuthAuthenticated) {
        token = authState.token;
      }

      try {
        final resp = await http.get(uri, headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        });

        debugPrint('Raw response: ${resp.body}');
        
      if (resp.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);

        /// 👉 KHÔNG còn dùng jsonResponse['body']
        if (jsonResponse['status_code'] == 200) {
          return MusicDetail.fromJson(jsonResponse['data']);
        } else {
          throw Exception('API returned error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi fetch music: $e');
      throw Exception('Failed to load music detail');
    }
  }

  Future<List<RecentMusic>> fetchRecentlyPlayed(BuildContext context, {int offset = 0, int limit = 8}) async {
    final authState = context.read<AuthBloc>().state;
    String? token;
    if (authState is AuthAuthenticated) {
      token = authState.token;
    }
    final uri = Uri.parse('http://10.0.2.2:8080/app/home/recently/music?offset=$offset&limit=$limit');
    try {
      final resp = await http.get(uri, headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      });
      if (resp.statusCode == 200) {
        final jsonResponse = jsonDecode(resp.body);
        final musics = (jsonResponse['data']['musics'] as List?) ?? [];
        return musics.map((e) => RecentMusic.fromJson(e)).toList();
      } else {
        throw Exception('HTTP Error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi fetch recently played: $e');
      throw Exception('Failed to load recently played');
    }
  }
}
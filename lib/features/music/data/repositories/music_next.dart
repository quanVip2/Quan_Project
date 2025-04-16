import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/music_detail_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/bloc/auth_bloc.dart';
import 'package:untitled/features/bloc/auth_state.dart';

class MusicNextRepository {
  final String baseUrl;

  MusicNextRepository({this.baseUrl = 'http://10.0.2.2:8080'});

  Future<MusicDetail> fetchNextMusic(BuildContext context, int currentMusicId) async {
    final uri = Uri.parse('$baseUrl/music/next/$currentMusicId');

    // 🔐 Lấy token từ AuthBloc như trong MusicService
    final authState = context.read<AuthBloc>().state;
    String? token;
    if (authState is AuthAuthenticated) {
      token = authState.token;
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Next music raw response: ${response.body}');

      if (response.statusCode == 200) {
        final outerMap = jsonDecode(response.body);
        final innerMap = outerMap['body'] ?? outerMap;

        if (innerMap['status_code'] == 200) {
          return MusicDetail.fromJson(innerMap['data']);
        } else {
          throw Exception('API error: ${innerMap['message']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi khi gọi fetchNextMusic: $e');
      throw Exception('Không thể tải bài hát tiếp theo');
    }
  }
}

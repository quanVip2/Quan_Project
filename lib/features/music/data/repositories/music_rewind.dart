import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/music_detail_model.dart';

class MusicRewindRepository {
  final String baseUrl;

  MusicRewindRepository({this.baseUrl = 'http://192.168.0.102:8080/app'});

  Future<MusicDetail> fetchRewindMusic({
    required int currentMusicId,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/music/rewind/$currentMusicId');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Rewind music raw response: ${response.body}');

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
      debugPrint('Lỗi khi gọi fetchRewindMusic: $e');
      throw Exception('Không thể tải bài hát trước đó');
    }
  }
}

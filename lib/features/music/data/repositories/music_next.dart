import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/music_detail_model.dart';


class MusicNextRepository {
  final String baseUrl;

  MusicNextRepository({this.baseUrl = 'http://10.0.2.2:8080/app'});

  Future<MusicDetail> fetchNextMusic({
    required int currentMusicId,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/music/next/$currentMusicId');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
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
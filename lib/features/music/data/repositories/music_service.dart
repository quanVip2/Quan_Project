import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/music_detail_model.dart';

class MusicService {
  Future<MusicDetail> fetchMusicDetail(int id) async {
    final uri = Uri.parse('http://10.0.2.2:8080/music/play/$id');

    try {
      final resp = await http.get(uri, headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsImVtYWlsIjoicXVhbjFAZ21haWwuY29tIiwicm9sZUlkIjoxLCJyb2xlTmFtZSI6ImFkbWluIiwidG9rZW5WZXJzaW9uIjowLCJleHAiOjE3NTA1NDAzMzAsImlhdCI6MTc0NDU0MDMzMH0.xS7PF2v4exoKrn6P3gcxos-j4g90XjGefeSPzqZnqI4', // 👈 Thay bằng token thật
      });

      debugPrint('Raw response: ${resp.body}');

      if (resp.statusCode == 200) {
        final outerMap = jsonDecode(resp.body);

        // Nếu backend trả về thêm lớp `body`, lấy ra lớp trong
        final innerMap = outerMap['body'] ?? outerMap;

        if (innerMap['status_code'] == 200) {
          return MusicDetail.fromJson(innerMap['data']);
        } else {
          throw Exception('API returned error: ${innerMap['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi fetch music: $e');
      throw Exception('Failed to load music detail');
    }
  }
}

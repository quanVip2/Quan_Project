import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth_bloc.dart';
import '../../../bloc/auth_state.dart';
import "../models/recent_author_model.dart";
import "../models/author_detail_model.dart";

class MusicRepository {
  // lib/features/music/data/repositories/music_repository.dart
static Future<AuthorDetail> getAuthorDetail(BuildContext context, int authorId) async {
  try {
    final authState = context.read<AuthBloc>().state;
    String? token;
    if (authState is AuthAuthenticated) {
      token = authState.token;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/app/author/$authorId'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded['data'];
      return AuthorDetail.fromJson(data);
    }
    throw Exception('Failed to load author detail');
  } catch (e) {
    debugPrint('Error fetching author detail: $e');
    rethrow;
  }
}
  static Future<List<RecentAuthor>> getRecentAuthors(BuildContext context) async {
    try {
      final authState = context.read<AuthBloc>().state;
      String? token;
      if (authState is AuthAuthenticated) {
        token = authState.token;
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/app/home/recently/author?offset=0&limit=8'),
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded['data'];
        if (data is Map && data['authors'] is List) {
          return (data['authors'] as List)
              .map((author) => RecentAuthor.fromJson(author))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching recent authors: $e');
      return [];
    }
  }
}
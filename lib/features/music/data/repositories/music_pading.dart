import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/bloc/auth_bloc.dart'; // Import AuthBloc
import '../models/music.dart';

class MusicPagingRepository { 
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<MusicItem>> fetchMusicList({required AuthBloc authBloc}) async {
    final token = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).token
        : null;

    final response = await http.get(
      Uri.parse('$baseUrl/home/paging/music'),
      headers: {
        'Authorization': token != null ? 'Bearer $token' : '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final musicList = jsonResponse['data']['musics'] as List;
      return musicList.map((e) => MusicItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load music list: ${response.statusCode}");
    }
  }
}

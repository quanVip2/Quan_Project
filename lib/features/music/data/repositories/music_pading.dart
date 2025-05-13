import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/features/music/data/models/music.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/bloc/auth_bloc.dart';
import 'package:untitled/features/bloc/auth_state.dart';
import 'package:flutter/widgets.dart';

class MusicPagingService {
  Future<List<MusicItem>> fetchPagedMusics(BuildContext context) async {
    try {
      final token = context.read<AuthBloc>().state is AuthAuthenticated
          ? (context.read<AuthBloc>().state as AuthAuthenticated).token
          : null;

      final response = await http.get(
        Uri.parse('http://192.168.0.102:8080/app/home/paging/music'),
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
        debugPrint("❌ Server error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return [];
    }
  }
}

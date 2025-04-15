import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<MusicItem>> fetchMusicList() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/paging/music'));

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    final result = MusicListResponse.fromJson(decoded);
    return result.data.musics;
  } else {
    throw Exception('Failed to load music list');
  }
}

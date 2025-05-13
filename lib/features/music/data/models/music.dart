//pading
class MusicListResponse {
  final int statusCode;
  final String message;
  final MusicListData data;

  MusicListResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MusicListResponse.fromJson(Map<String, dynamic> json) {
    return MusicListResponse(
      statusCode: json['status_code'],
      message: json['message'],
      data: MusicListData.fromJson(json['data']),
    );
  }
}

class MusicListData {
  final List<MusicItem> musics;

  MusicListData({required this.musics});

  factory MusicListData.fromJson(Map<String, dynamic> json) {
    return MusicListData(
      musics: List<MusicItem>.from(json['musics'].map((x) => MusicItem.fromJson(x))),
    );
  }
}

class MusicItem {
  final int id;
  final String title;
  final String imageUrl;
  final List<Author> authors;

  MusicItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.authors,
  });

  factory MusicItem.fromJson(Map<String, dynamic> json) {
    final authorsData = json['authors'];
    List<Author> authorsList;
    if (authorsData is String) {
      authorsList = [Author(id: 0, name: authorsData)];
    } else if (authorsData is List) {
      authorsList = authorsData.map((x) => Author.fromJson(x)).toList();
    } else {
      authorsList = [];
    }
    return MusicItem(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      authors: authorsList,
    );
  }
}

class Author {
  final int id;
  final String name;

  Author({required this.id, required this.name});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RecentMusic {
  final int id;
  final String title;
  final String imageUrl;
  final String authors;

  RecentMusic({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.authors,
  });

  factory RecentMusic.fromJson(Map<String, dynamic> json) {
    return RecentMusic(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      authors: json['authors'] ?? '',
    );
  }
}

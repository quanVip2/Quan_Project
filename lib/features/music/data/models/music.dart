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
    return MusicItem(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      authors: List<Author>.from(json['authors'].map((x) => Author.fromJson(x))),
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

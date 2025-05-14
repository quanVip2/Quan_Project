// lib/features/music/data/models/author_detail_model.dart
class AuthorDetail {
  final int id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final List<AuthorAlbum> albums;
  final List<AuthorMusic> musics;

  AuthorDetail({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.albums,
    required this.musics,
  });

  factory AuthorDetail.fromJson(Map<String, dynamic> json) {
    return AuthorDetail(
      id: json['author']['id'] as int,
      name: json['author']['name'] as String,
      description: json['author']['description'] as String?,
      avatarUrl: json['author']['avatarUrl'] as String?,
      albums: (json['albums'] as List?)
              ?.map((album) => AuthorAlbum.fromJson(album))
              .toList() ??
          [],
      musics: (json['music'] as List?)
              ?.map((music) => AuthorMusic.fromJson(music))
              .toList() ??
          [],
    );
  }
}

class AuthorAlbum {
  final int id;
  final String albumTitle;
  final String? description;
  final String? linkUrlImageAlbum;
  final String? nation;
  final int listenCountAlbum;

  AuthorAlbum({
    required this.id,
    required this.albumTitle,
    this.description,
    this.linkUrlImageAlbum,
    this.nation,
    required this.listenCountAlbum,
  });

  factory AuthorAlbum.fromJson(Map<String, dynamic> json) {
    return AuthorAlbum(
      id: json['id'] as int,
      albumTitle: json['albumTitle'] as String,
      description: json['description'] as String?,
      linkUrlImageAlbum: json['linkUrlImageAlbum'] as String?,
      nation: json['nation'] as String?,
      listenCountAlbum: json['listenCountAlbum'] as int,
    );
  }
}

class AuthorMusic {
  final int id;
  final String title;
  final String? description;
  final int broadcastTime;
  final String? linkUrlMusic;
  final String? imageUrl;
  final int listenCount;
  final String? nation;

  AuthorMusic({
    required this.id,
    required this.title,
    this.description,
    required this.broadcastTime,
    this.linkUrlMusic,
    this.imageUrl,
    required this.listenCount,
    this.nation,
  });

  factory AuthorMusic.fromJson(Map<String, dynamic> json) {
    return AuthorMusic(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      broadcastTime: json['broadcastTime'] as int,
      linkUrlMusic: json['linkUrlMusic'] as String?,
      imageUrl: json['imageUrl'] as String?,
      listenCount: json['listenCount'] as int,
      nation: json['nation'] as String?,
    );
  }
}
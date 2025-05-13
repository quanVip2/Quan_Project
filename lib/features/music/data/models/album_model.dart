import 'music.dart';

class AlbumModel {
  final int id;
  final String albumTitle;
  final String description;
  final String linkUrlImageAlbum;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String nation;
  final int listenCountAlbum;
  final List<MusicItem>? musics;
  final List<AuthorModel>? authors;
  final List<CategoryModel>? categories;

  AlbumModel({
    required this.id,
    required this.albumTitle,
    required this.description,
    required this.linkUrlImageAlbum,
    this.createdAt,
    this.updatedAt,
    required this.nation,
    required this.listenCountAlbum,
    this.musics,
    this.authors,
    this.categories,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] as int,
      albumTitle: json['albumTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      linkUrlImageAlbum: json['linkUrlImageAlbum'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      nation: json['nation'] as String? ?? '',
      listenCountAlbum: json['listenCountAlbum'] as int? ?? 0,
      musics: (json['musics'] as List?)?.map((e) => MusicItem.fromJson(e)).toList(),
      authors: (json['authors'] as List?)?.map((e) => AuthorModel.fromJson(e)).toList(),
      categories: (json['categories'] as List?)?.map((e) => CategoryModel.fromJson(e)).toList(),
    );
  }
}

class AuthorModel {
  final int id;
  final String name;
  final String description;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthorModel({
    required this.id,
    required this.name,
    required this.description,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class RecentAlbum {
  final int id;
  final String albumTitle;
  final String imageUrl;
  final String description;
  final String nation;
  final int listenCount;

  RecentAlbum({
    required this.id,
    required this.albumTitle,
    required this.imageUrl,
    required this.description,
    required this.nation,
    required this.listenCount,
  });

  factory RecentAlbum.fromJson(Map<String, dynamic> json) {
    return RecentAlbum(
      id: json['albumId'] ?? 0,
      albumTitle: json['albumTitle'] ?? '',
      imageUrl: json['linkUrlImageAlbum'] ?? '',
      description: json['description'] ?? '',
      nation: json['nation'] ?? '',
      listenCount: json['listenCount'] ?? 0,
    );
  }
} 
class MusicDetail {
  final int id;
  final String title;
  final String description;
  final int broadcastTime;
  final String linkUrlMusic;
  final String imageUrl;
  final List<Author> authors;
  final List<Category> categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? albumId;
  final int? listenCount;
  final String? nation;

  MusicDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.broadcastTime,
    required this.linkUrlMusic,
    required this.imageUrl,
    required this.authors,
    required this.categories,
    this.createdAt,
    this.updatedAt,
    this.albumId,
    this.listenCount,
    this.nation,
  });

  factory MusicDetail.fromJson(Map<String, dynamic> json) {
    final music = json['music'];
    if (music == null) {
      throw Exception("Missing 'music' object in JSON response");
    }

    final authors = (json['authors'] as List)
        .map((e) => Author.fromJson(e))
        .toList();

    final categories = (json['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();

    return MusicDetail(
      id: music['id'],
      title: music['title'],
      description: music['description'],
      broadcastTime: music['broadcastTime'],
      linkUrlMusic: music['linkUrlMusic'],
      imageUrl: music['imageUrl'],
      authors: authors,
      categories: categories,
      createdAt: music['createdAt'] != null ? DateTime.tryParse(music['createdAt']) : null,
      updatedAt: music['updatedAt'] != null ? DateTime.tryParse(music['updatedAt']) : null,
      albumId: music['albumId'],
      listenCount: music['listenCount'],
      nation: music['nation'],
    );
  }
}

class Author {
  final int id;
  final String name;
  final String? avatarUrl;

  Author({required this.id, required this.name, this.avatarUrl});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
